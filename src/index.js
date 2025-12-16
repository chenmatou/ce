export default {
  async fetch(request, env) {
    const url = new URL(request.url);

    if (url.pathname === "/status") {
      return new Response(JSON.stringify({ status: "ok" }), {
        headers: { "Content-Type": "application/json" }
      });
    }

    const settings = await env.BPB_SETTINGS.get("settings");
    return new Response(`Current settings: ${settings}`);
  }
}
