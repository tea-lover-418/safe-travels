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
      timestamp: new Date().toISOString(),
      imageSrc: [
        "https://images.unsplash.com/photo-1518124880777-cf8c82231ffb?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8bm9yd2F5JTIwd2FsbHBhcGVyfGVufDB8fDB8fHww",
        "https://wallpapercat.com/w/full/e/b/a/31244-2500x1237-desktop-dual-screen-norway-wallpaper-photo.jpg",
      ],
      description:
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum",
      title: "De lofoten",
      location: locations[0],
    },
    {
      timestamp: new Date().toISOString(),
      imageSrc: [
        "https://preikestolen365.com/wp-content/uploads/2021/01/Preikestolen.-Foto-Helge-Kjellevold-1.jpg",
        "https://dynamic-media-cdn.tripadvisor.com/media/photo-o/07/bd/7c/b4/pulpit-rock.jpg?w=900&h=500&s=1",
      ],
      description:
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum",
      title: "Preikstolen",
      location: locations[1],
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
