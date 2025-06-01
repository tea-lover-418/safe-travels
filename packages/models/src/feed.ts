import { LocationWithoutTime } from "./location";

export type Feed = FeedImage[];

export type FeedImage = {
  imageSrc: string;
  title: string;
  description?: string;
  location?: LocationWithoutTime;
};
