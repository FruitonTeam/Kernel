package fruiton;

class Config {

    public static inline var DB_SCHEMA:String = "resources/FruitonDb.schema.json";
    public static var dbFile(default, never):String = "resources/FruitonDb.json";
}