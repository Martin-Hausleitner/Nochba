export function verifyVerificationCode(code: string): boolean {
  const regex = /^[a-zA-Z0-9]{10}$/;
  return regex.test(code);
}
