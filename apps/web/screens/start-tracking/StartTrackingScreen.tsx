import { FC } from "react";

import styles from "./StartTrackingScreen.module.css";

export const StartTrackingScreen: FC = () => {
  return (
    <div className={styles.container}>
      <h1>Start tracking your progress!</h1>
      <h2>No data found yet</h2>
    </div>
  );
};
