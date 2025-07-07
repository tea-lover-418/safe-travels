"use client";

import styles from "./main.module.css";

import { Map } from "../components/Map";
import { Feed } from "../components/feed";
import { OpenSourceNotice } from "../components/open-source-notice";
import { FC, useEffect, useState } from "react";
import { LocationWithoutTime, Location } from "@safe-travels/models/location";
import { FeedItem } from "@safe-travels/models/feed";

type Props = {
  locations: Location[];
  feed: FeedItem[];
};

export const Main: FC<Props> = ({ locations, feed }) => {
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
