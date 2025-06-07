import { Metadata } from "next";
import { findLocations } from "../db/location";
import { findFeed } from "../db/feed";

import { Main } from "../screens/Main";

export const revalidate = 10;

const getData = async () => {
  const [locations, feed] = await Promise.all([findLocations(), findFeed()]);
  const targetLocation = {
    latitude: 66.551846,
    longitude: 15.321903,
    name: "On the way to the Arctic Circle",
  };

  const hasReachedGoal =
    targetLocation &&
    locations.some((location) => {
      /** We round the current location to 1 db. This way it can be approximated, rather than exactly matched. */

      const hasLatitude =
        Math.round(location.longitude * 10) / 10 === targetLocation.longitude;
      const hasLongitude =
        Math.round(location.latitude * 10) / 10 === targetLocation.latitude;

      return hasLatitude && hasLongitude;
    });

  // _id is not JSON serializable so we strip it off
  return {
    locations: locations.map(({ _id, ...rest }) => rest),
    feed: feed.map(({ _id, ...rest }) => rest),
    targetLocation,
    hasReachedGoal,
  };
};

export type HomePageData = Awaited<ReturnType<typeof getData>>;

export default async function Home() {
  const data = await getData();

  return (
    <Main
      locations={data.locations}
      feed={data.feed}
      targetLocation={data.targetLocation}
      hasReachedGoal={data.hasReachedGoal}
    />
  );
}

export const generateMetadata = async (): Promise<Metadata> => {
  return {
    title: "Safe Travels",
  };
};
