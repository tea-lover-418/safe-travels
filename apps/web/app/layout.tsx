import type { Metadata } from 'next';

import { Analytics } from '@vercel/analytics/next';

import './globals.css';

import { Spectral, Inter } from 'next/font/google';

const serif = Spectral({
  weight: '500',
  subsets: ['latin'],
});

const sans = Inter({
  weight: '300',
  subsets: ['latin'],
});

export const metadata: Metadata = {
  title: 'Safe Travels',
  description: 'Follow my travel diary!',
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <Analytics />
      <body className={`${serif.className}, ${sans.className}`}>{children}</body>
    </html>
  );
}
