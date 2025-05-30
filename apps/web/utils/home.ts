import { Location } from "@safe-travels/models/location";
import { serverConfig } from "../config";

const splitCoordinates = serverConfig.home?.split(";");

const latitude = splitCoordinates?.[0]
  ? parseFloat(splitCoordinates[0] || "")
  : undefined;

const longitude = splitCoordinates?.[1]
  ? parseFloat(splitCoordinates[1] || "")
  : undefined;

export const home: Omit<Location, "timestamp"> | undefined =
  latitude && longitude
    ? {
        latitude,
        longitude,
      }
    : undefined;
