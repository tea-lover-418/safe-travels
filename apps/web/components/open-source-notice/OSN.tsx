import styles from './OSN.module.css';

export const OpenSourceNotice = () => {
  return (
    <div>
      <div className={styles.ossContainer}>
        <h3 className={styles.builtWith}>
          Built with{' '}
          <a href="https://safe-travels.app" target="_blank" rel="noreferrer">
            SafeTravels
          </a>
        </h3>
      </div>
      <div className={styles.ossContainer}>
        <a href="https://github.com/tea-lover-418/safe-travels" target="_blank" rel="noreferrer">
          github
        </a>
        <a href="https://safe-travels.app/docs/intro" target="_blank" rel="noreferrer">
          docs
        </a>
        <p>© 2025</p>
      </div>
    </div>
  );
};
