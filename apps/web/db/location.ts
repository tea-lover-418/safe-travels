import { Location } from "@safe-travels/models";
import { getDbClient } from ".";
import { locationCollection } from "./collections";

export const insertLocation = async (location: Location) => {
  const db = await getDbClient();

  return db.collection(locationCollection).insertOne(location);
};

export const findLocations = async () => {
  const db = await getDbClient();

  const locations = await db
    .collection<Location>(locationCollection)
    .find({})
    .toArray();

  return locations;
};
