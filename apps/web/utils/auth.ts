import { serverConfig } from '../config';

export const isAuthorized = (token?: string | null) => {
  /** Auth is optional for now */
  if (!serverConfig.security.apiToken) {
    return true;
  }

  return token === serverConfig.security.apiToken;
};
