'use client';

import { useRouter } from 'next/navigation';

import React, { useState } from 'react';
import styles from './Login.module.css';

export const Login: React.FC = () => {
  const [password, setPassword] = useState('');
  const [error, setError] = useState<undefined | string>();
  const router = useRouter();

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();

    const response = await fetch('/api/login', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ password }),
      credentials: 'include', // Important: allows cookies to be set
    });

    if (!response.ok) {
      return setError(response.statusText);
    }

    router.replace('/');
  };

  return (
    <form onSubmit={handleSubmit} className={styles.container}>
      <h2 className={styles.title}>Login</h2>
      <p>Ask the owner of this trip for the password</p>

      <label className={styles.label}>
        Password
        <input
          type="password"
          value={password}
          onChange={e => setPassword(e.target.value)}
          className={styles.input}
          required
        />
      </label>

      <button type="submit" className={styles.button}>
        Log In
      </button>

      {error && <p className={styles.errorText}>{error}</p>}
    </form>
  );
};
