import { MAPTILER_API_KEY } from "$env/static/private";

export async function load() {
  return {
    // provide env var
    maptilerAPIKey: MAPTILER_API_KEY,
  };
}
