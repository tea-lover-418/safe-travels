import { FC } from "react";
import Image from "next/image";
import {
  FeedImage as FeedImageType,
  FeedItem,
} from "@safe-travels/models/feed";

import styles from "./feed.module.css";
import { formatDefault } from "../../utils/date";
import { LocationWithoutTime } from "@safe-travels/models/location";

interface Props {
  feed: FeedItem[];
  setMapFocus: (value: { key: string; position: LocationWithoutTime }) => void;
}

export const Feed: FC<Props> = ({ feed, setMapFocus }) => {
  return feed.map((feedItem, index) => {
    return <FeedImage {...feedItem} setMapFocus={setMapFocus} key={index} />;
  });
};

export const FeedImage: FC<
  FeedImageType & {
    setMapFocus: (mapFocus: {
      key: string;
      position: LocationWithoutTime;
    }) => void;
  }
> = ({ images, timestamp, title, description, location, setMapFocus }) => {
  if (!images?.length && !title) {
    return;
  }

  const hasLocation = location?.latitude && location?.longitude;

  return (
    <div>
      <div
        className={hasLocation ? styles.headerContainer : undefined}
        onClick={
          hasLocation
            ? () => setMapFocus({ key: title, position: location })
            : undefined
        }
      >
        <h1>{title}</h1>
      </div>

      <h3>{formatDefault(timestamp)}</h3>
      <p>{description}</p>
      <div className={styles.imageGridContainer}>
        {images?.map((src, index) => {
          return (
            <div key={index} className={styles.imageContainer}>
              <Image
                src={src}
                className={styles.feedImage}
                alt=""
                loading="lazy"
                unoptimized
                width={0}
                height={0}
                style={{ width: "100%", height: "100%" }}
              />
            </div>
          );
        })}
      </div>
    </div>
  );
};
