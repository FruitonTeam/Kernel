package fruiton.fruitDb.models;

import haxe.macro.Expr;
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
    static var arrayType(default, never):String = "array";
    static var arrayIntType(default, never):String = "arrayInt";
    static var arrayStringType(default, never):String = "arrayString";

    static function getSchemaFromFile(filePath:String):Array<NameTypePair> {
        try {
            var schema:Array<NameTypePair> = [];
            var json:String = File.getContent(filePath);
            var s:Dynamic = Json.parse(json);

            var props:Dynamic = s.definitions.fruiton.properties;
            for (name in Reflect.fields(props)) {
                var field:Dynamic = Reflect.field(props, name);
                if (field.type != arrayType) {
                    schema.push({name: name, type: field.type});
                } else { // Type is array, find out array of what
                    if (field.items.type == intType) {
                        schema.push({name: name, type: arrayIntType});
                    } else if (field.items.type == stringType) {
                        schema.push({name: name, type: arrayStringType});
                    }
                }
            }

            return schema;
        }
        catch(e:Dynamic) {
            return haxe.macro.Context.error('File reading error $filePath: $e', Context.currentPos());
        }
    }

    static function buildModelFromSchema(schema:Array<NameTypePair>):ComplexType {
        var fields:Array<Field> = [];

        for (item in schema) {
            var type;
            if (item.type == intType) {
                type = FVar(macro:Int);
            } else if (item.type == stringType) {
                type = FVar(macro:String);
            } else if (item.type == arrayIntType) {
                type = FVar(macro:Array<Int>);
            } else if (item.type == arrayStringType) {
                type = FVar(macro:Array<String>);
            } else {
                Context.error("Unknown type in schema: " + item.type, Context.currentPos());
            }

            fields.push({
                name: item.name,
                doc: null,
                meta: [],
                access: [APublic],
                kind: type,
                pos: Context.currentPos()
            });
        }

        return TAnonymous(fields);
    }

    public macro static function buildModel(filePath:String):ComplexType {
        var schema = getSchemaFromFile(filePath);
        return buildModelFromSchema(schema);
    }
}
