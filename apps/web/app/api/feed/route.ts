import { serverConfig } from '../../../config';
import { insertFeed } from '../../../db/feed';
import { isAuthorized } from '../../../utils/auth';
import { FeedItem } from '@safe-travels/models';

export async function POST(request: Request) {
  const token = request.headers.get('Authorization');

  if (!isAuthorized(token)) {
    return new Response(undefined, {
      status: 401,
    });
  }

  const data = (await request.json()) as FeedItem;

  if (!data?.type || !data?.title) {
    return new Response(undefined, {
      status: 400,
      statusText: 'missing required type and title of feed item',
    });
  }

  const feedItem = {
    ...data,
    images: data.images.map((filename: string) => `${serverConfig.r2?.publicUrl}/${filename}`),
    timestamp: new Date().toISOString() /** UTC */,
  };

  const res = await insertFeed(feedItem);

  if (!res.acknowledged) {
    return new Response(undefined, {
      status: 500,
      statusText: 'could not save feedItem',
    });
  }

  return new Response(undefined, { status: 200 });
}
