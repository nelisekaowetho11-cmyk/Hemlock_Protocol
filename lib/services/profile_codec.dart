
import 'dart:convert';

import '../models/vpn_profile.dart';

class ProfileCodec {
  static String encodeProfile(VpnProfile profile) {
    return jsonEncode(profile.toJson());
  }

  static String encodeProfiles(List<VpnProfile> profiles) {
    final data = profiles.map((profile) {
      return profile.toJson();
    }).toList();

    return jsonEncode(data);
  }

  static VpnProfile decodeProfile(String jsonString) {
    final decoded = jsonDecode(jsonString);

    if (decoded is! Map) {
      throw const FormatException('Invalid VPN profile data.');
    }

    return VpnProfile.fromJson(
      Map<String, dynamic>.from(decoded),
    );
  }

  static List<VpnProfile> decodeProfiles(String jsonString) {
    final decoded = jsonDecode(jsonString);

    if (decoded is! List) {
      throw const FormatException('Invalid VPN profiles data.');
    }

    return decoded.map((item) {
      if (item is! Map) {
        throw const FormatException('Invalid profile entry.');
      }

      return VpnProfile.fromJson(
        Map<String, dynamic>.from(item),
      );
    }).toList();
  }
}
