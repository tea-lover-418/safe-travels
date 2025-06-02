import { LocationWithoutTime } from "@safe-travels/models/location";

export const isWithin100Meters = (
  homeCoordinate: LocationWithoutTime,
  newCoordinate: LocationWithoutTime
): boolean => {
  const distance = calculateDistance(homeCoordinate, newCoordinate);

  return distance <= 100;
};

export const calculateDistance = (
  pointA: LocationWithoutTime,
  pointB: LocationWithoutTime
) => {
  const toRadians = (degrees: number) => (degrees * Math.PI) / 180;

  /** Earth's radius */
  const R = 6371e3;

  const φ1 = toRadians(pointA.latitude);
  const φ2 = toRadians(pointB.latitude);

  const Δφ = toRadians(pointB.latitude - pointA.latitude);
  const Δλ = toRadians(pointB.longitude - pointA.longitude);

  const a =
    Math.sin(Δφ / 2) * Math.sin(Δφ / 2) +
    Math.cos(φ1) * Math.cos(φ2) * Math.sin(Δλ / 2) * Math.sin(Δλ / 2);

  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  const distance = R * c;

  return distance;
};
