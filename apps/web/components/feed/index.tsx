import { FC } from "react";
import {
  FeedImage as FeedImageType,
  FeedItem,
} from "@safe-travels/models/feed";

import styles from "./feed.module.css";
import { formatDefault } from "../../utils/date";

interface Props {
  feed: FeedItem[];
}

export const Feed: FC<Props> = ({ feed }) => {
  return feed.map((feedItem, index) => {
    return <FeedImage {...feedItem} key={index} />;
  });
};

export const FeedImage: FC<FeedImageType> = ({
  imageSrc,
  timestamp,
  title,
  description,
  location,
}) => {
  if (!imageSrc?.length && !title) {
    return;
  }

  return (
    <div>
      <h1>{title}</h1>
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
