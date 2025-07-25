import { isAuthorized } from '../../../utils/auth';

export async function GET(request: Request) {
  const token = request.headers.get('Authorization');

  if (!isAuthorized(token)) {
    return new Response('succes, unauthorized', {
      status: 401,
    });
  }

  return new Response('succes, authorized', { status: 200 });
}
