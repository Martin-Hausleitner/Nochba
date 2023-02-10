export function getNearestDistance(distance: number): string {
  const options = [100, 200, 500, 1000, 5000, 10000, 15000];
  let nearest = options[0];
  for (let option of options) {
    if (Math.abs(distance - option) < Math.abs(distance - nearest)) {
      nearest = option;
    }
  }
  if (nearest >= 1000) {
    return nearest / 1000 + "km";
  } else {
    return nearest + "m";
  }
}