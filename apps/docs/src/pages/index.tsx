import type { ReactNode } from "react";
import clsx from "clsx";
import useDocusaurusContext from "@docusaurus/useDocusaurusContext";
import Layout from "@theme/Layout";
import Heading from "@theme/Heading";

import styles from "./index.module.css";
import Link from "@docusaurus/Link";

export default function Home(): ReactNode {
  const { siteConfig } = useDocusaurusContext();

  return (
    <Layout title={siteConfig.title} description={siteConfig.tagline}>
      <header className={clsx("hero hero--primary", styles.heroBanner)}>
        <div className="container">
          <Heading as="h1" className="hero__title">
            {siteConfig.title}
          </Heading>
          <p className="hero__subtitle">{siteConfig.tagline}</p>
          <div className={styles.buttons}>
            <Link
              className="button button--secondary button--lg"
              to="/docs/intro"
            >
              Documentation
            </Link>
            <Link className="button button--secondary button--lg" to="/blog">
              Blog
            </Link>
            <Link
              className="button button--secondary button--lg"
              to="https://demo.safe-travels.app"
            >
              Demo
            </Link>
          </div>
        </div>
      </header>
      <main className={styles.main}>
        <div className={styles.columns}></div>
      </main>
    </Layout>
  );
}
