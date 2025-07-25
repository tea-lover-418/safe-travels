/** For some reason, adding an import to next/server breaks a lot of things down the line.
 *  I feel it must be a Next.js internal issue at this point, but kinda need this middleware fam.
 *  Maybe I'll just ditch it and move to NextAuth instead.
 */

// import { NextResponse } from 'next/server';
// import type { NextRequest } from 'next/server';
// import { serverConfig } from './config';

// export default function middleware(request: NextRequest) {
//   const password = serverConfig.security.publicPassword;
//   if (!password) {
//     return NextResponse.next();
//   }

//   if (request.nextUrl.pathname.includes('/login')) {
//     return NextResponse.next();
//   }

//   const cookie = request.cookies.get('auth')?.value;
//   const authorized = cookie === password;

//   if (!authorized) {
//     const loginUrl = new URL('/login', request.url);
//     return NextResponse.redirect(loginUrl);
//   }

//   return NextResponse.next();
// }

// /** This is a verbose allowlist, be sure to add any other routes here that need protection.
//  * Do not pattern match as you will likely include many assets.
//  * */
// export const config = {
//   matcher: ['/'],
// };

export default () => {};
