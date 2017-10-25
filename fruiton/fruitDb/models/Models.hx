package fruiton.fruitDb.models;

typedef FruitonModel =
    haxe.macro.MacroType<[fruiton.fruitDb.models.ModelBuilder.buildModel(ModelTypes.fruiton)]>;

typedef MovementModel =
    haxe.macro.MacroType<[fruiton.fruitDb.models.ModelBuilder.buildModel(ModelTypes.movement)]>;

typedef AttackModel =
    haxe.macro.MacroType<[fruiton.fruitDb.models.ModelBuilder.buildModel(ModelTypes.attack)]>;

typedef TargetPatternModel =
    haxe.macro.MacroType<[fruiton.fruitDb.models.ModelBuilder.buildModel(ModelTypes.targetPattern)]>;
