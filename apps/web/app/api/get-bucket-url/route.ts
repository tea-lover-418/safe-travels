// AWS SDK v3
import { S3Client, PutObjectCommand } from "@aws-sdk/client-s3";
import { getSignedUrl } from "@aws-sdk/s3-request-presigner";
import { isAuthorized } from "../../../utils/auth";
import { serverConfig } from "../../../config";

const r2 = serverConfig.r2
  ? new S3Client({
      region: "auto",
      endpoint: serverConfig.r2.endpoint,
      credentials: {
        accessKeyId: serverConfig.r2.accessKeyId,
        secretAccessKey: serverConfig.r2.secretAccessKey,
      },
    })
  : undefined;

/**
 * curl -v http://localhost:3000/api/get-bucket-url --request POST --header "Authorization: shh" --data '{"filename": "test.png"}'
 */
export async function POST(request: Request) {
  if (!r2) {
    return new Response(undefined, {
      status: 400,
      statusText: "images not enabled on this server",
    });
  }

  const token = request.headers.get("Authorization");

  if (!isAuthorized(token)) {
    return new Response(undefined, {
      status: 401,
    });
  }

  const data = (await request.json()) as any;

  const filename = data?.filename;

  if (!filename) {
    return new Response(undefined, {
      status: 400,
      statusText: "missing required filename",
    });
  }

  const command = new PutObjectCommand({
    Bucket: "safe-travels",
    Key: filename,
    ContentType: "image/jpeg",
  });

  const url = await getSignedUrl(r2, command, { expiresIn: 3600 });

  return new Response(url, { status: 200 });
}
