class PhoneHelper {
  static const String countryCode = '+20';

  // 01xxxxxxxxx -> +201xxxxxxxxx
  static String withCountryCode(String phone) {
    final local = phone.trim();
    return '$countryCode${local.startsWith('0') ? local.substring(1) : local}';
  }

  // +201xxxxxxxxx -> 01xxxxxxxxx, the way the user types it
  static String toLocal(String phone) {
    return phone.startsWith(countryCode)
        ? '0${phone.substring(countryCode.length)}'
        : phone;
  }
}
