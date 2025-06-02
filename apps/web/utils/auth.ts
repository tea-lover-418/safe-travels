import { serverConfig } from "../config";

export const isAuthorized = (token?: string | null) => {
  /** Auth is optional for now */
  if (!serverConfig.apiToken) {
    return true;
  }

  return token === serverConfig.apiToken;
};
