import styles from "./page.module.css";
import { Map } from "../components/Map";
import { getDbClient } from "../db";
import { locationCollection } from "../db/collections";
import { Location } from "@safe-travels/models/location";
import { Metadata } from "next";

const getData = async () => {
  const client = await getDbClient();

  const locations = await client
    .collection<Location>(locationCollection)
    .find({})
    .toArray();

  // _id is not JSON serializable so we strip it off
  return {
    locations: locations.map(({ _id, ...rest }) => rest),
  };
};

export default async function Home() {
  const data = await getData();

  return (
    <div className={styles.page}>
      <Map locations={data.locations} />
    </div>
  );
}

export const generateMetadata = async (): Promise<Metadata> => {
  return {
    title: "Safe Travels",
  };
};
