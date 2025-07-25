import { LocationWithoutTime, Location, FeedLocation } from '@safe-travels/models';
import { FC } from 'react';
import { calculateDistance } from '../../utils/coordinates';
import styles from './Distance.module.css';

/** Currently not in used, will be part of a Feed re-do */
export const Distance: FC<{
  locations: LocationWithoutTime[];
  targetLocation: FeedLocation | undefined;
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
      <div className={styles.headerContainer} onClick={() => setMapFocus(targetLocation)}>
        <h1>{targetLocation.name}</h1>
      </div>
      <h2>{displayDistance(distance)} to go</h2>
    </div>
  );
};
