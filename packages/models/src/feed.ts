import { LocationWithoutTime } from './location';

export type FeedItem = FeedImage;

type FeedItemBase = {
  type: string;
  timestamp: string;
};

export type FeedImage = FeedItemBase & {
  type: 'FeedImage';
  title: string;
  description?: string;
  images?: string[];
  location?: LocationWithoutTime;
};
