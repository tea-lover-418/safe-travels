import { program } from 'commander';
import dotenv from 'dotenv';
import { feedSeed, locationSeed } from './seed';

dotenv.config();

const seedLocations = async (url: string, apiToken: string) => {
  await Promise.all(
    locationSeed.map(async location => {
      await fetch(`${url}/api/location`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: apiToken,
        },
        body: JSON.stringify(location),
      });
    }),
  );
};

const seedFeed = async (url: string, apiToken: string) => {
  await Promise.all(
    feedSeed.map(async feed => {
      console.log('tried to insert', feed);
    }),
  );
};

/** Under construction
 *
 * Steps:
 * 1. setup database, https://www.mongodb.com/docs/atlas/cli/current/
 * 3. copy connection string and hold. Maybe write to some local file
 * 4. setup vercel, https://vercel.com/docs/cli
 * 5. setup env, including the connection string
 * 6. ask for optional env, home coords and api token (rec)
 */

program
  .version('1.0.0')
  .description('Safe Travels - Quick setup CLI')
  .action(() => {
    const { API_TOKEN, API_URL } = process.env;
    if (!API_TOKEN || !API_URL) {
      console.error('Missing required .env values');
      return;
    }

    seedLocations(API_URL, API_TOKEN);
    seedFeed(API_URL, API_TOKEN);
  });

program.parse(process.argv);
