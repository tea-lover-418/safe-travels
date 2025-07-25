import { FC } from 'react';

import styles from './NoData.module.css';

export const NoDataScreen: FC = () => {
  return (
    <div className={styles.container}>
      <h1>Start tracking your progress!</h1>
      <h2>No data found yet</h2>
    </div>
  );
};
