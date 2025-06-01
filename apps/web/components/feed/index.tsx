import { FC } from "react";
import {
  FeedImage as FeedImageType,
  Feed as FeedType,
} from "@safe-travels/models/feed";

import styles from "./feed.module.css";

interface Props {
  feed: FeedType;
}

export const Feed: FC<Props> = ({ feed }) => {
  return feed.map((feedItem, index) => {
    return <FeedImage {...feedItem} key={index} />;
  });
};

export const FeedImage: FC<FeedImageType> = ({
  imageSrc,
  title,
  description,
  location,
}) => {
  return <img src={imageSrc} className={styles.feedImage} />;
};
