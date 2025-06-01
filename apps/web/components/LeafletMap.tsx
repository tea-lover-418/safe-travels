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
  Popup,
  CircleMarker,
  useMap,
} from "react-leaflet";
import { Location } from "@safe-travels/models/location";
import { FC, useEffect, useRef, useState } from "react";

import "leaflet/dist/leaflet.css";
import { formatDefault } from "../utils/date";

export interface Props {
  locations: Location[];
}

const Marker: FC<{ isNewest: boolean; position: Location }> = ({
  isNewest,
  position,
}) => {
  const map = useMap();

  const currentPositionPopupRef = useRef<L.Popup | null>(null);

  useEffect(() => {
    if (!isNewest) {
      return;
    }

    if (currentPositionPopupRef.current) {
      currentPositionPopupRef.current.toggle();
    }
  }, [isNewest, map]);

  return (
    <CircleMarker
      center={{ lat: position.latitude, lng: position.longitude }}
      radius={8}
      weight={2}
      opacity={0.8}
      fillColor={isNewest ? "blue" : "grey"}
      color={"blue"}
      fillOpacity={0.8}
    >
      <Popup ref={currentPositionPopupRef}>
        {formatDefault(position.timestamp)}
      </Popup>
    </CircleMarker>
  );
};

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
        style={{ height: "100%", width: "100%", borderRadius: 20 }}
        center={mapPosition}
        zoom={9}
      >
        <TileLayer
          attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
          url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
        />
        {locations.map((position, index) => (
          <Marker
            key={index}
            isNewest={index === locations.length - 1}
            position={position}
          />
        ))}
      </MapContainer>
    )
  );
};

export default Map;
