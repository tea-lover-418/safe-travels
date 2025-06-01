import { serverConfig } from "../config";

export const isAuthorized = (token?: string | null) => {
  return token === serverConfig.apiToken;
};
