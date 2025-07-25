"use client";

import styles from "./Main.module.css";
import { FC, useState } from "react";

import { Map, Feed, OpenSourceNotice } from "../../components";

import { LocationWithoutTime, Location } from "@safe-travels/models/location";
import { FeedItem } from "@safe-travels/models/feed";

type Props = {
  locations: Location[];
  feed: FeedItem[];
};

export const Main: FC<Props> = ({ locations, feed }) => {
  const [mapFocus, setMapFocus] = useState<
    | {
        key: string;
        position: LocationWithoutTime;
      }
    | undefined
  >({
    key: "",
    position: locations[locations.length - 1] || { latitude: 0, longitude: 0 },
  });

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
          mapFocus={mapFocus}
        />
      </div>
      <div className={styles.feedContainer}>
        <Feed feed={feed} setMapFocus={setMapFocus} />
        <OpenSourceNotice />
      </div>
    </div>
  );
};
