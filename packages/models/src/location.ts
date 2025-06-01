export interface Location {
  latitude: number;
  longitude: number;
  timestamp: string;
}

export type LocationWithoutTime = Omit<Location, "timestamp">;
