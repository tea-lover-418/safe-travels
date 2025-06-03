import styles from "./oss.module.css";

export const OpenSourceNotice = () => {
  return (
    <div>
      <div className={styles.ossContainer}>
        <h3 className={styles.builtWith}>
          Built with{" "}
          <a href="https://github.com/tea-lover-418/safe-travels">
            SafeTravels
          </a>
        </h3>
      </div>
      <div className={styles.ossContainer}>
        <a href="https://github.com/tea-lover-418/safe-travels">github</a>
        <a href="https://github.com/tea-lover-418/safe-travels">docs</a>
        <p>© 2025</p>
      </div>
    </div>
  );
};
