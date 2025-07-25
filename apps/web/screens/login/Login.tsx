import styles from './Login.module.css';
import { FC } from 'react';

import { OpenSourceNotice } from '../../components';
import Login from '../../components/login/Login';

export const LoginScreen: FC = () => {
  return (
    <div className={styles.container}>
      <div className={styles.content}>
        <Login />
        <OpenSourceNotice />
      </div>
    </div>
  );
};
