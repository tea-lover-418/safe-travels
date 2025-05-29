"use client";

import dynamic from "next/dynamic";
import { FC, useMemo } from "react";
import { Props } from "../components/LeafletMap";

/** This map only exists as a fix so we can fetch dynamic on a client component, but also have a SSR page */
export const Map: FC<Props> = ({ locations }) => {
  const LeafletMap = useMemo(
    () =>
      dynamic(() => import("../components/LeafletMap"), {
        loading: () => <p>Map is loading</p>,
        ssr: false,
      }),
    []
  );

  return <LeafletMap locations={locations} />;
};
