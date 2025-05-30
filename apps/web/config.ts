const getServerConfig = () => {
  return {
    dbUrl: requireEnv("MONGODB_CONNECTION_STRING"),
    dbName: requireEnv("MONGO_DB_NAME"),
    home: process.env.HOME_COORDS,
  };
};

const requireEnv = (env: string) => {
  if (!process.env[env]) {
    throw Error(`Missing env ${env}`);
  }

  return process.env[env];
};

export const serverConfig = getServerConfig();
