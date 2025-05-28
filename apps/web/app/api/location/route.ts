/** For now just an echo */
export async function POST(request: Request) {
  console.log(await request.json());

  return new Response(undefined, { status: 200 });
}
