package fruiton.fruitDb.models;

typedef FruitonModel =
    haxe.macro.MacroType<[fruiton.fruitDb.models.ModelBuilder.buildModel(ModelTypes.fruiton)]>;

typedef MovementModel =
    haxe.macro.MacroType<[fruiton.fruitDb.models.ModelBuilder.buildModel(ModelTypes.movement)]>;

typedef AttackModel =
    haxe.macro.MacroType<[fruiton.fruitDb.models.ModelBuilder.buildModel(ModelTypes.attack)]>;

typedef TargetPatternModel =
    haxe.macro.MacroType<[fruiton.fruitDb.models.ModelBuilder.buildModel(ModelTypes.targetPattern)]>;

typedef EffectModel =
    haxe.macro.MacroType<[fruiton.fruitDb.models.ModelBuilder.buildModel(ModelTypes.effect)]>;

typedef AbilityModel =
    haxe.macro.MacroType<[fruiton.fruitDb.models.ModelBuilder.buildModel(ModelTypes.ability)]>;

typedef PointModel =
    haxe.macro.MacroType<[fruiton.fruitDb.models.ModelBuilder.buildModel(ModelTypes.point)]>;

typedef MapModel =
    haxe.macro.MacroType<[fruiton.fruitDb.models.ModelBuilder.buildModel(ModelTypes.map)]>;