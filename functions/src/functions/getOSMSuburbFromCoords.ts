import axios from "axios";

export async function getOSMSuburbFromCoords(
  lat: number,
  lon: number
): Promise<string> {
  try {
    const url = `https://nominatim.openstreetmap.org/reverse?format=json&lat=${lat}&lon=${lon}&zoom=18&addressdetails=1`;
    const response = await axios.get(url);
    const data = response.data;
    if (data && data.address && data.address.suburb) {
      return data.address.suburb;
    } else {
      //if town is not null return town else return city else null
      if (data && data.address && data.address.town) {
        return data.address.town;
      }
      if (data && data.address && data.address.city) {
        return data.address.city;
      }
      return null;
    }
  } catch (error) {
    throw error;
  }
}

// async function getOSMSuburbFromCoords(
//   lat: number,
//   lon: number
// ): Promise<string> {
//   const url = `https://nominatim.openstreetmap.org/reverse?format=json&lat=${lat}&lon=${lon}&zoom=18&addressdetails=1`;
//   const { response }: any = await axios.get(url).catch(function (error) {
//     console.log(error.toJSON());
//   });
//   const data = response.data;
//   switch (data) {
//     case data.address.neighbourhood != null:
//       console.log("neighbourhood");
//       return data.address.neighbourhood.toString();
//     case data.address.suburb != null:
//       console.log("suburb");
//       return data.address.suburb.toString();
//     case data.address.town!= null:
//       console.log("town");
//       return data.address.town.toString();
//     case data.address.city!= null:
//       console.log("city");
//       return data.address.city.toString();
//     case data.state_district!= null:
//       console.log("state_district");
//       return data.state_district.toString();
//     case data.state!= null:
//       console.log("state");
//       return data.state.toString();
//     case data.country:
//       return data.country;
//     default:
//       return "??????";
//   }
// }

// console.log(getOSMSuburbFromCoords(48.3068526, 4.2857548).toString());
// //dispaly the return as a string
// console.log(getOSMSuburbFromCoords(48.3068526, 4.2857548));
