import styles from "./page.module.css";
import { Map } from "../components/Map";
import { getDbClient } from "../db";
import { locationCollection } from "../db/collections";
import { Location } from "@safe-travels/models/location";
import { Metadata } from "next";
import { Feed } from "../components/feed";
import { Feed as FeedType } from "@safe-travels/models/feed";

export const revalidate = 10;

const getData = async () => {
  const client = await getDbClient();

  const locations = await client
    .collection<Location>(locationCollection)
    .find({})
    .toArray();

  const feed: FeedType = [
    {
      imageSrc:
        "https://images.unsplash.com/photo-1518124880777-cf8c82231ffb?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8bm9yd2F5JTIwd2FsbHBhcGVyfGVufDB8fDB8fHww",
      description: "tmp",
      title: "tmp",
      location: locations[0],
    },
    {
      imageSrc:
        "https://wallpapercat.com/w/full/e/b/a/31244-2500x1237-desktop-dual-screen-norway-wallpaper-photo.jpg",
      description: "tmp",
      title: "tmp",
      location: locations[0],
    },
  ];

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
