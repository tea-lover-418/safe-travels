"use client";

import L from "leaflet";

/** Icon fix */
L.Icon.Default.mergeOptions({
  iconRetinaUrl:
    "https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.9.4/images/marker-icon-2x.png",
  iconUrl:
    "https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.9.4/images/marker-icon.png",
  shadowUrl:
    "https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.9.4/images/marker-shadow.png",
});

import {
  MapContainer,
  TileLayer,
  Marker,
  Popup,
  CircleMarker,
} from "react-leaflet";
import { Location } from "@safe-travels/models/location";
import { FC, useEffect, useState } from "react";

import "leaflet/dist/leaflet.css";
import { formatDefault } from "../utils/date";

export interface Props {
  locations: Location[];
}

const Map: FC<Props> = ({ locations }) => {
  const [isClient, setIsClient] = useState(false);

  useEffect(() => {
    setIsClient(true);
  }, []);

  const mapPosition = [
    locations[locations.length - 1]?.latitude,
    locations[locations.length - 1]?.longitude,
  ] as [number, number];

  return (
    isClient && (
      <MapContainer
        style={{ height: "800px", width: "100%" }}
        center={mapPosition}
        zoom={13}
      >
        <TileLayer
          attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
          url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
        />
        {locations.map((position, index) => {
          const isNewest = index === locations.length - 1;

          return (
            <CircleMarker
              key={index}
              center={{ lat: position.latitude, lng: position.longitude }}
              radius={8}
              weight={2}
              opacity={0.8}
              fillColor={isNewest ? "blue" : "grey"}
              color={"blue"}
              fillOpacity={0.8}
            >
              <Popup>{formatDefault(position.timestamp)}</Popup>
            </CircleMarker>
          );
        })}
      </MapContainer>
    )
  );
};

export default Map;
