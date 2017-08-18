package fruiton.fruitDb.models;

typedef FruitonModel = haxe.macro.MacroType<[fruiton.fruitDb.models.ModelBuilder.buildModel("resources/FruitonDb.schema.json", ModelTypes.Fruiton)]>;

typedef MovementModel = haxe.macro.MacroType<[fruiton.fruitDb.models.ModelBuilder.buildModel("resources/FruitonDb.schema.json", ModelTypes.Movement)]>;

typedef AttackModel = haxe.macro.MacroType<[fruiton.fruitDb.models.ModelBuilder.buildModel("resources/FruitonDb.schema.json", ModelTypes.Attack)]>;

typedef TargetPatternModel = haxe.macro.MacroType<[fruiton.fruitDb.models.ModelBuilder.buildModel("resources/FruitonDb.schema.json", ModelTypes.TargetPattern)]>;
