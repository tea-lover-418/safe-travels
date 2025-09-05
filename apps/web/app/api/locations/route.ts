import { Location } from '@safe-travels/models';
import { insertLocations } from '../../../db/location';
import { isWithin100Meters } from '../../../utils/coordinates';
import { home } from '../../../utils/home';
import { isAuthorized } from '../../../utils/auth';
import { compact } from '../../../utils/array';

export async function POST(request: Request) {
  const token = request.headers.get('Authorization');

  if (!isAuthorized(token)) {
    return new Response(undefined, {
      status: 401,
    });
  }

  const data = await request.json();

  if (!Array.isArray(data)) {
    return new Response(undefined, {
      status: 400,
      statusText: 'Expected Array',
    });
  }

  const locationPoints = data.map(datapoint => {
    if (!datapoint.latitude || !datapoint.longitude || !datapoint.timestamp) {
      return;
    }

    const location: Location = {
      latitude: datapoint.latitude,
      longitude: datapoint.longitude,
      timestamp: datapoint.timestamp ? new Date(datapoint.timestamp).toUTCString() : new Date().toISOString(),
    };

    /** Check if the location is too close to home */
    if (home && isWithin100Meters(home, location)) {
      return;
    }

    return location;
  });

  const res = await insertLocations(compact(locationPoints));

  if (!res.acknowledged) {
    return new Response(undefined, {
      status: 500,
      statusText: 'could not save location',
    });
  }

  const response = JSON.stringify(res.insertedIds);

  return new Response(response, { status: 200 });
}
