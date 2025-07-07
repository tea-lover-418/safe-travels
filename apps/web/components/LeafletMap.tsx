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
import {
  FeedLocation,
  Location,
  LocationWithoutTime,
} from "@safe-travels/models/location";
import { FC, useEffect, useMemo, useRef, useState } from "react";

import "leaflet/dist/leaflet.css";
import { isToday, formatDefault } from "../utils/date";

const colorSchemes = {
  blue: {
    dark: "#06070E",
    mid: "#454ADE",
    light: "#7478E7",
    grey: "#E6E8F5",
  },
  red: {
    dark: "#330000",
    mid: "#D72638",
    light: "#FF5C5C",
    grey: "#F4E6E6",
  },
  green: {
    dark: "#002D19",
    mid: "#2DC653",
    light: "#81F495",
    grey: "#E6F3EC",
  },
  purple: {
    dark: "#2E003E",
    mid: "#9D4EDD",
    light: "#C77DFF",
    grey: "#F1E6F7",
  },
  yellow: {
    dark: "#4B3A00",
    mid: "#FFD60A",
    light: "#FFEB8A",
    grey: "#F9F6E3",
  },
  teal: {
    dark: "#003D3B",
    mid: "#00B4D8",
    light: "#90E0EF",
    grey: "#E4F1F2",
  },
  orange: {
    dark: "#4A1A00",
    mid: "#FF6D00",
    light: "#FFAD60",
    grey: "#F7EEE8",
  },
  pink: {
    dark: "#3D002C",
    mid: "#FF4D6D",
    light: "#FFA6C9",
    grey: "#FBE9EF",
  },
} as const;

type ColorScheme = (typeof colorSchemes)[keyof typeof colorSchemes];

const FeedLocationMarker: FC<{
  position: FeedLocation;
  colorScheme?: ColorScheme;
  isFocussed?: boolean;
}> = ({ position, colorScheme = colorSchemes.green, isFocussed }) => {
  const feedLocationRef = useRef<L.Popup | null>(null);
  const map = useMap();

  useEffect(() => {
    /** Await the FlyTo animation */
    map.once("moveend", () => {
      if (!isFocussed) {
        return;
      }

      if (feedLocationRef.current) {
        map.openPopup(feedLocationRef.current);
      }
    });
  }, [isFocussed, map]);

  return (
    <CircleMarker
      center={{ lat: position.latitude, lng: position.longitude }}
      radius={10}
      weight={2}
      opacity={0.8}
      fillColor={colorScheme.mid}
      color={colorScheme.dark}
      fillOpacity={0.9}
    >
      <Popup ref={feedLocationRef}>{position.name}</Popup>
    </CircleMarker>
  );
};

const Marker: FC<{
  isNewest: boolean;
  isToday: boolean;
  position: Location;
  colorScheme?: ColorScheme;
}> = ({ isNewest, isToday, position, colorScheme = colorSchemes.blue }) => {
  const map = useMap();
  const positionPopupRef = useRef<L.Popup | null>(null);

  useEffect(() => {
    if (!isNewest) {
      return;
    }

    if (positionPopupRef.current) {
      positionPopupRef.current.toggle();
    }
  }, [isNewest, map]);

  const opacity = isToday ? 1 : 0.7;

  return (
    <CircleMarker
      center={{ lat: position.latitude, lng: position.longitude }}
      radius={isNewest ? 10 : 8}
      weight={2}
      fillColor={
        isNewest
          ? colorScheme.mid
          : isToday
            ? colorScheme.light
            : colorScheme.grey
      }
      color={isNewest ? colorScheme.dark : colorScheme.mid}
      opacity={opacity}
      fillOpacity={opacity}
    >
      <Popup ref={positionPopupRef}>{formatDefault(position.timestamp)}</Popup>
    </CircleMarker>
  );
};

/** Hack component because to mutate the map you need to be a component inside of it. */
const MapPosition: FC<{ mapPosition: [number, number]; key?: string }> = ({
  mapPosition,
}) => {
  const map = useMap();

  useEffect(() => {
    map.flyTo(mapPosition);
  }, [map, mapPosition]);

  return undefined;
};

export interface Props {
  locations: Location[];
  feedLocations?: FeedLocation[];
  mapFocus:
    | { key: string | undefined; position: LocationWithoutTime }
    | undefined;
}

const Map: FC<Props> = ({ locations, feedLocations, mapFocus }) => {
  const [isClient, setIsClient] = useState(false);

  useEffect(() => {
    setIsClient(true);
  }, []);

  const mapPosition: [number, number] = useMemo(() => {
    if (mapFocus?.position.latitude && mapFocus?.position.longitude) {
      return [mapFocus.position.latitude, mapFocus.position.longitude];
    }

    return [0, 0];
  }, [mapFocus]);

  return (
    isClient && (
      <MapContainer
        style={{ height: "100%", width: "100%", borderRadius: 20 }}
        center={mapPosition}
        zoom={9}
      >
        <MapPosition mapPosition={mapPosition} key={mapFocus?.key} />
        <TileLayer
          attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
          url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
        />
        {locations.map((position, index) => (
          <Marker
            key={index}
            isNewest={index === locations.length - 1}
            isToday={isToday(position.timestamp)}
            position={position}
          />
        ))}
        {feedLocations &&
          feedLocations.map((position, index) => {
            return (
              <FeedLocationMarker
                position={position}
                key={index}
                colorScheme={colorSchemes.teal}
                isFocussed={mapFocus?.key === position.name}
              />
            );
          })}
      </MapContainer>
    )
  );
};

export default Map;
