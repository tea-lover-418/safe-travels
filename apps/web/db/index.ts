import { Db, MongoClient } from "mongodb";
import { serverConfig } from "../config";

let mongoClient: MongoClient;
let db: Db;

export async function getDbClient(): Promise<Db> {
  if (db) {
    return db;
  }

  try {
    mongoClient = new MongoClient(serverConfig.dbUrl);

    await mongoClient.connect();
    db = mongoClient.db(serverConfig.dbName);

    return db;
  } catch (error) {
    console.error(`MongoDB connection failed: ${error}`);

    process.exit();
  }
}
