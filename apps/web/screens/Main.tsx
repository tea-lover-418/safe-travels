"use client";

import styles from "./main.module.css";

import { Map } from "../components/Map";
import { Feed } from "../components/feed";
import { OpenSourceNotice } from "../components/open-source-notice";
import { Distance } from "../components/distance";
import { FC, useEffect, useState } from "react";
import {
  LocationWithoutTime,
  Location,
  TargetLocation,
} from "@safe-travels/models/location";
import { FeedItem } from "@safe-travels/models/feed";

type Props = {
  locations: Location[];
  targetLocation: TargetLocation;
  feed: FeedItem[];
  hasReachedGoal: boolean;
};

export const Main: FC<Props> = ({
  locations,
  targetLocation,
  feed,
  hasReachedGoal,
}) => {
  const [mapFocus, setMapFocus] = useState<LocationWithoutTime | undefined>(
    locations[locations.length - 1]
  );

  useEffect(() => {
    console.log(mapFocus);
  }, [mapFocus]);

  return (
    <div className={styles.container}>
      <div className={styles.mapContainer}>
        <Map
          locations={locations}
          feedLocations={feed
            .map(({ location, title }) => {
              if (!location?.latitude || !location.longitude) {
                return;
              }
              return { ...location, name: title };
            })
            .filter((val) => !!val)}
          targetLocation={targetLocation}
          mapFocus={mapFocus}
        />
      </div>
      <div className={styles.feedContainer}>
        <Distance
          locations={locations}
          targetLocation={targetLocation}
          hasReachedGoal={hasReachedGoal}
          setMapFocus={setMapFocus}
        />
        <Feed feed={feed} setMapFocus={setMapFocus} />
        <OpenSourceNotice />
      </div>
    </div>
  );
};
