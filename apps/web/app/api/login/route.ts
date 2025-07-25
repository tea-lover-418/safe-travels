import { serverConfig } from '../../../config';

/** This authorization method is safe as long as we use HTTPS.
 * For now it suffices, but a move to NextAuth is being considered.
 * */
export async function POST(request: Request) {
  const password = serverConfig.security.publicPassword;
  const data = await request.json();

  if (!data.password) {
    return new Response(undefined, {
      status: 400,
    });
  }

  const isAuthorized = password === data.password;

  if (!isAuthorized) {
    return new Response(undefined, {
      status: 401,
      statusText: 'Incorrect password',
    });
  }

  const headers = new Headers();
  headers.append('Set-Cookie', `auth=${data.password}; Path=/; HttpOnly; SameSite=Strict; Max-Age=86400`);

  return new Response(undefined, {
    status: 200,
    headers,
  });
}
