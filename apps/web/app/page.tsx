import styles from "./page.module.css";
import { Map } from "../components/Map";
import { Metadata } from "next";
import { Feed } from "../components/feed";
import { findLocations } from "../db/location";
import { findFeed } from "../db/feed";

export const revalidate = 10;

const getData = async () => {
  const [locations, feed] = await Promise.all([findLocations(), findFeed()]);

  // _id is not JSON serializable so we strip it off
  return {
    locations: locations.map(({ _id, ...rest }) => rest),
    feed,
  };
};

export default async function Home() {
  const data = await getData();

  return (
    <div className={styles.page}>
      <div className={styles.mapContainer}>
        <Map locations={data.locations} />
      </div>
      <div className={styles.feedContainer}>
        <Feed feed={data.feed} />
      </div>
    </div>
  );
}

export const generateMetadata = async (): Promise<Metadata> => {
  return {
    title: "Safe Travels",
  };
};
