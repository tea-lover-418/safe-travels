import { LocationWithoutTime } from "./location";

export type Feed = FeedImage[];

type FeedItemBase = {
  timestamp: string;
};

export type FeedImage = FeedItemBase & {
  imageSrc: string[];
  title: string;
  description?: string;
  location?: LocationWithoutTime;
};
