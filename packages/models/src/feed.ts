import { LocationWithoutTime } from "./location";

export type FeedItem = FeedImage;

type FeedItemBase = {
  type: string;
  timestamp: string;
};

export type FeedImage = FeedItemBase & {
  type: "FeedImage";
  imageSrc: string[];
  title: string;
  description?: string;
  location?: LocationWithoutTime;
};
