import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';
import { serverConfig } from './config';

export default function middleware(request: NextRequest) {
  const password = serverConfig.security.publicPassword;
  if (!password) {
    return NextResponse.next();
  }

  if (request.nextUrl.pathname.includes('/login')) {
    return NextResponse.next();
  }

  const cookie = request.cookies.get('auth')?.value;
  const authorized = cookie === password;

  if (!authorized) {
    const loginUrl = new URL('/login', request.url);
    return NextResponse.redirect(loginUrl);
  }

  return NextResponse.next();
}

/** This is a verbose allowlist, be sure to add any other routes here that need protection.
 * Do not pattern match as you will likely include many assets.
 * */
export const config = {
  matcher: ['/'],
};
