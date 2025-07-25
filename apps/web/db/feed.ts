import { getDbClient } from '.';
import { feedCollection } from './collections';
import { FeedItem } from '@safe-travels/models';

export const insertFeed = async (feedItem: FeedItem) => {
  const db = await getDbClient();

  return db.collection(feedCollection).insertOne(feedItem);
};

export const findFeed = async () => {
  const db = await getDbClient();

  const feed = await db.collection<FeedItem>(feedCollection).find().sort({ _id: -1 }).toArray();

  return feed;
};
