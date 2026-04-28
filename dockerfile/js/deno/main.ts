Deno.serve({ port: 8090 }, (req) => {
  const url = new URL(req.url);
  if (req.method === "GET" && url.pathname === "/") {
    return new Response("Hello World", {
      status: 200,
      headers: { "content-type": "text/plain" },
    });
  }
  return new Response("Not Found", { status: 404 });
});
