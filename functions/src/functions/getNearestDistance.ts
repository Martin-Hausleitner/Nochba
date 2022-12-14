export function getNearestDistance(distance: number): string {
  const options = [200, 400, 1000, 2000, 5000, 10000, 15000];

  // Find the nearest distance in the options array
  let nearest = options[0];
  for (let option of options) {
    if (Math.abs(distance - option) < Math.abs(distance - nearest)) {
      nearest = option;
    }
  }

  // Format the nearest distance as a string with the appropriate unit (m or km)
  if (nearest >= 1000) {
    return nearest / 1000 + "km";
  } else {
    return nearest + "m";
  }
}

// function getNearestValue(distance: number): string {
//     // options for distance in meters
//     const options = [200, 400, 1000, 2000, 5000, 10000, 15000];
  
//     // find the nearest value by calculating the difference
//     // between the given distance and each option, and taking
//     // the minimum value
//     const nearest = options.reduce((prev, curr) =>
//       Math.abs(curr - distance) < Math.abs(prev - distance) ? curr : prev
//     );
  
//     // return the nearest value with the appropriate unit
//     if (nearest >= 1000) {
//       return `${nearest / 1000}km`;
//     } else {
//       return `${nearest}m`;
//     }
//   }
  


// function getNearestDistance(distance: number): string {
//     if (distance <= 200) {
//       return '200m';
//     } else if (distance <= 400) {
//       return '400m';
//     } else if (distance <= 1000) {
//       return '1km';
//     } else if (distance <= 2000) {
//       return '2km';
//     } else if (distance <= 5000) {
//       return '5km';
//     } else if (distance <= 10000) {
//       return '10km';
//     } else if (distance <= 15000) {
//       return '15km';
//     }
//   }