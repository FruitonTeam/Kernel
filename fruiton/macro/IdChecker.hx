package fruiton.macro;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.ds.IntMap;

class IdChecker {

    static inline var ERROR_REPORT_DEFINE:String = "idCheckAsErrors";

    static var TAKEN_IDS:IntMap<String> = new IntMap<String>();

    static var wasError:Bool = false;

    static function check():Array<Field> {
        // Following two lines are here to avoid checkstyle complaining about unused include
        // @SuppressWarnings for UnusedImport does not seem to work (where to put it?)
        var eUnused:Expr;
        eUnused = null;

        var compilerHandleFunc = contextWarning;
        if (getDefine("idCheckAsErrors") != null) {
            compilerHandleFunc = contextError;
        }

        var fields:Array<Field> = Context.getBuildFields();
        var pos = Context.currentPos();

        var clsName = Context.getLocalClass().get().name;
        var clsErrorMsg = "Class " + clsName + " needs a public static Int called ID with unique value";

        var found:Bool = false;
        for (f in fields) {
            if (f.name == "ID") {
                found = true;
                if (!checkAccess(f)) {
                    compilerHandleFunc(clsErrorMsg, pos);
                }
                switch (f.kind) {
                    case (FVar(t, e)): {
                        if (e == null) {
                            compilerHandleFunc(clsErrorMsg, pos);
                        }
                        switch (e.expr) {
                            case (EConst(val)) : {
                                switch (val) {
                                    case (CInt(intVal)): {
                                        var currentId = Std.parseInt(intVal);
                                        if (TAKEN_IDS.exists(currentId)) {
                                            handleIdWrite(true, null, null);
                                            var msg = "Class " + clsName + " has ID which is not unique, collision with " + TAKEN_IDS.get(currentId);
                                            compilerHandleFunc(msg, pos);
                                        } else {
                                            TAKEN_IDS.set(currentId, clsName);
                                            handleIdWrite(false, currentId, clsName);
                                        }
                                        break;
                                    }
                                    default:
                                        compilerHandleFunc(clsErrorMsg, pos);
                                }
                                break;
                            }
                            default:
                                compilerHandleFunc(clsErrorMsg, pos);
                        }
                        break;
                    }
                    default:
                        compilerHandleFunc(clsErrorMsg, pos);
                }
            }
        }

        if (!found) {
            compilerHandleFunc(clsErrorMsg, pos);
        }

        return fields;
    }

    static function checkAccess(field:Field):Bool {
        if (field.access.indexOf(APublic) == -1 ||
            field.access.indexOf(AStatic) == -1) {
            return false;
        }

        return true;
    }

    static function handleIdWrite(isError:Bool, currentId:Int, className:String) {
        if (getDefine("idCheckAsErrors") != null) {
            // Do not confuse programmer by showing possibly incomplete id table
            return;
        }

        if (!wasError && !isError) {
            return;
        } else if (!wasError && isError) {
            wasError = true;
            for (id in TAKEN_IDS.keys()) {
                trace("[ID_LIST] " + formatId(id) + " - " + Std.string(TAKEN_IDS.get(id)));
            }
        } else if (wasError && !isError) {
            trace("[ID_LIST] " + formatId(currentId) + " - " + className);
        }
    }

    @SuppressWarnings("checkstyle:MagicNumber") // 10 and 100 are no magic
    static function formatId(id:Int):String {
        if (id < 10) {
            return "  " + Std.string(id);
        } else if (id < 100) {
            return " " + Std.string(id);
        } else {
            return Std.string(id);
        }
    }

    macro static function getDefine(key:String):haxe.macro.Expr {
        return macro $v{haxe.macro.Context.definedValue(key)};
    }

    static function contextError(msg:String, pos:Position) {
        Context.error(msg, pos);
    }

    static function contextWarning(msg:String, pos:Position) {
        Context.warning(msg, pos);
    }
}