import styles from "./page.module.css";
import { Map } from "../components/Map";
import { Metadata } from "next";
import { Feed } from "../components/feed";
import { findLocations } from "../db/location";
import { findFeed } from "../db/feed";
import { FC } from "react";
import {
  Location,
  LocationWithoutTime,
  TargetLocation,
} from "@safe-travels/models/location";

import { calculateDistance } from "../utils/coordinates";
import { OpenSourceNotice } from "../components/open-source-notice";

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
    feed,
    targetLocation,
    hasReachedGoal,
  };
};

export default async function Home() {
  const data = await getData();

  return (
    <div className={styles.page}>
      <div className={styles.mapContainer}>
        <Map locations={data.locations} targetLocation={data.targetLocation} />
      </div>
      <div className={styles.feedContainer}>
        <Distance
          locations={data.locations}
          targetLocation={data.targetLocation}
          hasReachedGoal={data.hasReachedGoal}
        />
        <Feed feed={data.feed} />
        <OpenSourceNotice />
      </div>
    </div>
  );
}

const Distance: FC<{
  locations: LocationWithoutTime[];
  targetLocation: TargetLocation | undefined;
  hasReachedGoal?: boolean;
}> = ({ locations, targetLocation, hasReachedGoal }) => {
  if (hasReachedGoal || !locations.length || !targetLocation) {
    return;
  }

  const lastLocation = locations[locations.length - 1] as Location; // ts is dumb sometimes

  const displayDistance = (distance: number) => {
    return `${Math.round(distance / 100) / 10}km`;
  };

  const distance = calculateDistance(lastLocation, targetLocation);
  return (
    <div>
      <h1>{targetLocation.name}</h1>
      <h2>{displayDistance(distance)} to go</h2>
    </div>
  );
};

export const generateMetadata = async (): Promise<Metadata> => {
  return {
    title: "Safe Travels",
  };
};
