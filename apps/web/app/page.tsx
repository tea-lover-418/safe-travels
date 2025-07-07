import { Metadata } from "next";
import { findLocations } from "../db/location";
import { findFeed } from "../db/feed";

import { Main } from "../screens/Main";

export const revalidate = 10;

const getData = async () => {
  const [locations, feed] = await Promise.all([findLocations(), findFeed()]);

  // _id is not JSON serializable so we strip it off
  return {
    locations: locations.map(({ _id, ...rest }) => rest),
    feed: feed.map(({ _id, ...rest }) => rest),
  };
};

export type HomePageData = Awaited<ReturnType<typeof getData>>;

export default async function Home() {
  const data = await getData();

  return <Main locations={data.locations} feed={data.feed} />;
}

export const generateMetadata = async (): Promise<Metadata> => {
  return {
    title: "Safe Travels",
  };
};
