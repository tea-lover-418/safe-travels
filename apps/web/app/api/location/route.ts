import { Location } from '@safe-travels/models';
import { insertLocation } from '../../../db/location';
import { isWithin100Meters } from '../../../utils/coordinates';
import { home } from '../../../utils/home';
import { isAuthorized } from '../../../utils/auth';

/** Test endpoint:
 * happy: curl http://localhost:3000/api/location --header "Authorization: shh" --request POST --data '{"latitude": 52.402515, "longitude": 4.710760}'
 */
export async function POST(request: Request) {
  const token = request.headers.get('Authorization');

  if (!isAuthorized(token)) {
    return new Response(undefined, {
      status: 401,
    });
  }

  const data = await request.json();

  if (!data.latitude || !data.longitude) {
    return new Response(undefined, {
      status: 400,
      statusText: 'missing required latitude or longitude',
    });
  }

  const location: Location = {
    latitude: data.latitude,
    longitude: data.longitude,
    timestamp: data.timestamp ? new Date(data.timestamp).toUTCString() : new Date().toISOString(),
  };

  /** Check if the location is too close to home */
  if (home && isWithin100Meters(home, location)) {
    return new Response(undefined, {
      status: 403,
      statusText: 'location rejected',
    });
  }

  const res = await insertLocation(location);

  if (!res.acknowledged) {
    return new Response(undefined, {
      status: 500,
      statusText: 'could not save location',
    });
  }

  const response = JSON.stringify({ id: res.insertedId.toString() });

  return new Response(response, { status: 200 });
}
