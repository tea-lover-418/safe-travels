import { isAuthorized } from '../../../utils/auth';

export async function POST(request: Request) {
  const token = request.headers.get('Authorization');

  if (!isAuthorized(token)) {
    return new Response(undefined, {
      status: 401,
    });
  }

  return new Response(undefined, { status: 200 });
}
