const getServerConfig = () => {
  return {
    dbUrl: requireEnv("MONGODB_CONNECTION_STRING"),
    dbName: requireEnv("MONGO_DB_NAME"),
    apiToken: process.env.API_TOKEN,
    home: process.env.HOME_COORDS,
    r2: getR2Config(),
  };
};

/** Cloudflare R2 */
const getR2Config = () => {
  const r2PublicUrl = process.env.R2_PUBLIC_URL;
  const r2Endpoint = process.env.R2_ENDPOINT;
  const r2AccessKeyId = process.env.R2_ACCESS_KEY_ID;
  const r2SecretAccessKey = process.env.R2_SECRET_ACCESS_KEY;

  return r2AccessKeyId && r2SecretAccessKey
    ? {
        publicUrl: r2PublicUrl,
        endpoint: r2Endpoint,
        accessKeyId: r2AccessKeyId,
        secretAccessKey: r2SecretAccessKey,
      }
    : undefined;
};

const requireEnv = (env: string) => {
  if (!process.env[env]) {
    throw Error(`Missing env ${env}`);
  }

  return process.env[env];
};

export const serverConfig = getServerConfig();
