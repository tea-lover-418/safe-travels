import { serverConfig } from "../config";

export const isAuthorized = (token?: string | null) => {
  console.log("server token", serverConfig.apiToken);
  console.log("client token", token);

  return !serverConfig.apiToken && token === serverConfig.apiToken;
};
