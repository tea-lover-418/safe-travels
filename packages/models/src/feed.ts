import { LocationWithoutTime } from "./location";

export type FeedItem = FeedImage;

type FeedItemBase = {
  timestamp: string;
};

export type FeedImage = FeedItemBase & {
  imageSrc: string[];
  title: string;
  description?: string;
  location?: LocationWithoutTime;
};
