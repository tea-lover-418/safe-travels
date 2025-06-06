import {
  LocationWithoutTime,
  TargetLocation,
  Location,
} from "@safe-travels/models/location";
import { FC } from "react";
import { calculateDistance } from "../../utils/coordinates";
import styles from "./distance.module.css";

export const Distance: FC<{
  locations: LocationWithoutTime[];
  targetLocation: TargetLocation | undefined;
  hasReachedGoal?: boolean;
  setMapFocus: (location: LocationWithoutTime) => void;
}> = ({ locations, targetLocation, hasReachedGoal, setMapFocus }) => {
  if (hasReachedGoal || !locations.length || !targetLocation) {
    return;
  }

  const lastLocation = locations[locations.length - 1] as Location; // ts is dumb sometimes

  const displayDistance = (distance: number) => {
    return `${Math.round(distance / 100) / 10}km`;
  };

  const distance = calculateDistance(lastLocation, targetLocation);

  return (
    <div>
      <div
        className={styles.headerContainer}
        onClick={() => setMapFocus(targetLocation)}
      >
        <h1>{targetLocation.name}</h1>
      </div>
      <h2>{displayDistance(distance)} to go</h2>
    </div>
  );
};
