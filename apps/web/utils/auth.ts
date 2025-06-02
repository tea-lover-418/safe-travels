import { serverConfig } from "../config";

export const isAuthorized = (token?: string | null) => {
  return !serverConfig.apiToken && token === serverConfig.apiToken;
};
