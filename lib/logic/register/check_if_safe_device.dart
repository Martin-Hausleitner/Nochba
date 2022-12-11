import 'package:safe_device/safe_device.dart';

Future<bool> checkIfSafeDevice() async {
  // Check if device is jailbroken
  bool isJailBroken = await SafeDevice.isJailBroken;
  if (isJailBroken) {
    print('Device is jailbroken');
    return false;
  } else {
    print('Device is not jailbroken');
  }

  // Check if device is a real device
  bool isRealDevice = await SafeDevice.isJailBroken;
  if (isRealDevice) {
    print('Device is a real device');
  } else {
    print('Device is not a real device');
    // return false;

  }

  // Check if device can mock location
  bool canMockLocation = await SafeDevice.canMockLocation;
  if (canMockLocation) {
    print('Device can mock location');
    // return false;
  } else {
    print('Device cannot mock location');
  }

  return true;
}
