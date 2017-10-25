package fruiton.macro;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.ds.IntMap;

class IdChecker {

    static var TAKEN_IDS:IntMap<String> = new IntMap<String>();

    static function check():Array<Field> {
        // Following two lines are here to avoid checkstyle complaining about unused include
        // @SuppressWarnings for UnusedImport does not seem to work (where to put it?)
        var eUnused:Expr;
        eUnused = null;

        var fields:Array<Field> = Context.getBuildFields();
        var pos = Context.currentPos();

        var clsName = Context.getLocalClass().get().name;
        var clsErrorMsg = "Class " + clsName + " needs a public static Int called ID with unique value";

        var found:Bool = false;
        for (f in fields) {
            if (f.name == "ID") {
                found = true;
                if (!checkAccess(f)) {
                    Context.error(clsErrorMsg, pos);
                }
                switch (f.kind) {
                    case (FVar(t, e)): {
                        if (e == null) {
                            Context.error(clsErrorMsg, pos);
                        }
                        switch (e.expr) {
                            case (EConst(val)) : {
                                switch (val) {
                                    case (CInt(intVal)): {
                                        var currentId = Std.parseInt(intVal);
                                        if (TAKEN_IDS.exists(currentId)) {
                                            Context.error("Class " + clsName + " has ID which is not unique, collision with " + TAKEN_IDS.get(currentId), pos);
                                        } else {
                                            TAKEN_IDS.set(currentId, clsName);
                                        }
                                        break;
                                    }
                                    default:
                                        Context.error(clsErrorMsg, pos);
                                }
                                break;
                            }
                            default:
                                Context.error(clsErrorMsg, pos);
                        }
                        break;
                    }
                    default:
                        Context.error(clsErrorMsg, pos);
                }
            }
        }

        if (!found) {
            Context.error(clsErrorMsg, pos);
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
}