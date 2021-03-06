package fruiton.fruitDb.models;

import haxe.macro.Expr.ComplexType;
import haxe.macro.Expr.Field;
import haxe.macro.Context;
import sys.io.File;
import haxe.Json;

typedef NameTypePair = {
    public var name:String;
    public var type:String;
};

class ModelBuilder {

    static var stringType(default, never):String = "string";
    static var intType(default, never):String = "integer";
    static var pointType(default, never):String = "#/definitions/point";
    static var arrayType(default, never):String = "array";
    static var arrayIntType(default, never):String = "arrayInt";
    static var arrayStringType(default, never):String = "arrayString";
    static var arrayPointType(default, never):String = "arrayPoint";

    static function getSchemaFromFile(filePath:String, type:ModelTypes):Array<NameTypePair> {
        try {
            var schema:Array<NameTypePair> = [];
            var jsonString:String = File.getContent(filePath);
            var jsonSchema:Dynamic = Json.parse(jsonString);
            var reference:Dynamic;

            var props:Dynamic = getPropsForType(jsonSchema, type);
            for (name in Reflect.fields(props)) {
                var field:Dynamic = Reflect.field(props, name);
                if (field.type != arrayType) {
                    schema.push({
                        name: name, type: field.type
                    });
                } else { // Type is array, find out array of what
                    if (field.items.type == intType) {
                        schema.push({
                            name: name, type: arrayIntType
                        });
                    } else if (field.items.type == stringType) {
                        schema.push({
                            name: name, type: arrayStringType
                        });
                    } else if ((reference = Reflect.field(field.items, "$ref")) != null) {
                        if (reference == pointType) {
                            schema.push({
                                name: name, type: arrayPointType
                            });
                        }
                    } else {
                        Context.error("Array of " + type + " is not supported. Modify ModelBuilder or json schema.", Context.currentPos());
                    }
                }
            }
            return schema;
        } catch(e:Dynamic) {
            return haxe.macro.Context.error('File reading error $filePath: $e', Context.currentPos());
        }
    }

    static function getPropsForType(jsonSchema:Dynamic, type:ModelTypes):Dynamic {
        switch (type) {
            case ModelTypes.fruiton: {
                return jsonSchema.definitions.fruiton.properties;
            }
            case ModelTypes.movement: {
                return jsonSchema.definitions.movement.properties;
            }
            case ModelTypes.targetPattern: {
                return jsonSchema.definitions.targetPattern.properties;
            }
            case ModelTypes.effect: {
                return jsonSchema.definitions.effect.properties;
            }
            case ModelTypes.attack: {
                return jsonSchema.definitions.attack.properties;
            }
            case ModelTypes.ability: {
                return jsonSchema.definitions.ability.properties;
            }
            case ModelTypes.point: {
                return jsonSchema.definitions.point.properties;
            }
            case ModelTypes.map: {
                return jsonSchema.definitions.map.properties;
            }
            // Do not specify default so compiler complains about unmatched patterns (if any)
        }
    }

    static function buildModelFromSchema(schema:Array<NameTypePair>):ComplexType {
        var fields:Array<Field> = [];

        for (item in schema) {
            var type;
            if (item.type == intType) {
                type = macro:Int;
            } else if (item.type == stringType) {
                type = macro:String;
            } else if (item.type == pointType) {
                type = macro:PointModel;
            } else if (item.type == arrayIntType) {
                type = macro:Array<Int>;
            } else if (item.type == arrayStringType) {
                type = macro:Array<String>;
            } else if (item.type == arrayPointType) {
                type = macro:Array<PointModel>;
            } else {
                Context.error("Unknown type in schema: " + item.type, Context.currentPos());
            }

            fields.push({
                name: item.name,
                doc: null,
                meta: [],
                access: [APublic],
                kind: FieldType.FProp("default", "never", type),
                pos: Context.currentPos()
            });
        }

        return TAnonymous(fields);
    }

    macro public static function buildModel(typeExpr:haxe.macro.Expr):ComplexType {
        var filePath = fruiton.Config.DB_SCHEMA;

        // Determine enum from given expression
        var typeString:String = switch (typeExpr.expr) {
            case EConst(CIdent(modelType)): { // Without full name specification e.g. Fruiton
                modelType;
            }
            case EField(e, modelType): { // With full name specification e.g. ModelTypes.Fruiton
                modelType;
            }
            default: {
                throw "Type must be ModelTypes either `ModelTypes.[Type]` or just `[Type]`";
            }
        }
        var type:ModelTypes = Type.createEnum(ModelTypes, typeString);

        // Parse schema and return model
        var schema:Array<NameTypePair> = getSchemaFromFile(filePath, type);
        return buildModelFromSchema(schema);
    }
}
