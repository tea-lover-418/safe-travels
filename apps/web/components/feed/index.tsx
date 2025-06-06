import { FC } from "react";
import {
  FeedImage as FeedImageType,
  FeedItem,
} from "@safe-travels/models/feed";

import styles from "./feed.module.css";
import { formatDefault } from "../../utils/date";
import { LocationWithoutTime } from "@safe-travels/models/location";

interface Props {
  feed: FeedItem[];
  setMapFocus: (location: LocationWithoutTime) => void;
}

export const Feed: FC<Props> = ({ feed, setMapFocus }) => {
  return feed.map((feedItem, index) => {
    return <FeedImage {...feedItem} setMapFocus={setMapFocus} key={index} />;
  });
};

export const FeedImage: FC<
  FeedImageType & { setMapFocus: (location: LocationWithoutTime) => void }
> = ({ imageSrc, timestamp, title, description, location, setMapFocus }) => {
  if (!imageSrc?.length && !title) {
    return;
  }

  return (
    <div>
      <div
        className={location ? styles.headerContainer : undefined}
        onClick={location ? () => setMapFocus(location) : undefined}
      >
        <h1>{title}</h1>
      </div>

      <h3>{formatDefault(timestamp)}</h3>
      <p>{description}</p>
      <div className={styles.feedImageContainer}>
        {imageSrc?.map((src, index) => {
          return <img src={src} className={styles.feedImage} key={index} />;
        })}
      </div>
    </div>
  );
};
