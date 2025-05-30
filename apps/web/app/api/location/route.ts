import { Location } from "@safe-travels/models/location";
import { insertLocation } from "../../../db/location";
import { isWithin100Meters } from "../../../utils/coordinates";
import { home } from "../../../utils/home";

/** Test endpoint:
 * happy: curl http://localhost:3000/api/location --request POST --data '{"latitude": 52.402515, "longitude": 4.710760}'
 * unhappy: curl http://localhost:3000/api/location --request POST --data '{"jemoeder": true}'
 */
export async function POST(request: Request) {
  const data = await request.json();

  if (!data.latitude || !data.longitude) {
    return new Response(undefined, {
      status: 400,
      statusText: "missing required latitude or longitude",
    });
  }

  const location: Location = {
    latitude: data.latitude,
    longitude: data.longitude,
    timestamp: new Date().toISOString() /** UTC */,
  };

  /** Check if the location is too close to home */
  if (home && isWithin100Meters(home, location)) {
    return new Response(undefined, {
      status: 403,
      statusText: "location rejected",
    });
  }

  console.info("inserting", location);

  const res = await insertLocation(location);

  if (!res.acknowledged) {
    return new Response(undefined, {
      status: 500,
      statusText: "could not save location",
    });
  }

  return new Response(undefined, { status: 200 });
}
