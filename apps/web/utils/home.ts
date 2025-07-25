import { LocationWithoutTime } from "@safe-travels/models";
import { serverConfig } from "../config";

const splitCoordinates = serverConfig.home?.split(",");

const latitude = splitCoordinates?.[0]
  ? parseFloat(splitCoordinates[0] || "")
  : undefined;

const longitude = splitCoordinates?.[1]
  ? parseFloat(splitCoordinates[1] || "")
  : undefined;

export const home: LocationWithoutTime | undefined =
  latitude && longitude
    ? {
        latitude,
        longitude,
      }
    : undefined;
