import { Location } from "@safe-travels/models/location";

export const isWithin100Meters = (
  homeCoordinate: Omit<Location, "timestamp">,
  newCoordinate: Omit<Location, "timestamp">
): boolean => {
  const toRadians = (degrees: number) => (degrees * Math.PI) / 180;

  /** Earth's radius */
  const R = 6371e3;

  const φ1 = toRadians(homeCoordinate.latitude);
  const φ2 = toRadians(newCoordinate.latitude);

  const Δφ = toRadians(newCoordinate.latitude - homeCoordinate.latitude);
  const Δλ = toRadians(newCoordinate.longitude - homeCoordinate.longitude);

  const a =
    Math.sin(Δφ / 2) * Math.sin(Δφ / 2) +
    Math.cos(φ1) * Math.cos(φ2) * Math.sin(Δλ / 2) * Math.sin(Δλ / 2);

  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  const distance = R * c;

  return distance <= 100;
};
