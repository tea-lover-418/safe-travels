import { isAuthorized } from "../../../utils/auth";
import { FeedItem } from "@safe-travels/models/feed";
import { insertFeed } from "../../../db/feed";

export async function POST(request: Request) {
  const token = request.headers.get("Authorization");

  if (!isAuthorized(token)) {
    return new Response(undefined, {
      status: 401,
    });
  }

  const data = (await request.json()) as FeedItem;

  if (!data?.type) {
    return new Response(undefined, {
      status: 400,
      statusText: "missing required type of feed item",
    });
  }

  const feedItem = {
    ...data,
    timestamp: new Date().toISOString() /** UTC */,
  };

  console.info("inserting", feedItem);

  const res = await insertFeed(feedItem);

  if (!res.acknowledged) {
    return new Response(undefined, {
      status: 500,
      statusText: "could not save feedItem",
    });
  }

  return new Response(undefined, { status: 200 });
}
