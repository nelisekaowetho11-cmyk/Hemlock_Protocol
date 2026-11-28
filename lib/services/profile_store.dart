
import 'package:flutter/services.dart';

import '../models/vpn_profile.dart';
import 'profile_codec.dart';

class ProfileStore {
  static const MethodChannel _channel =
      MethodChannel('com.primenetvpn/profile_storage');

  Future<List<VpnProfile>> loadProfiles() async {
    try {
      final json = await _channel.invokeMethod<String>('loadProfiles');

      if (json == null || json.isEmpty) {
        return [];
      }

      return ProfileCodec.decodeProfiles(json);
    } on PlatformException catch (error) {
      throw Exception('Could not load profiles: ${error.message}');
    }
  }

  Future<void> saveProfiles(List<VpnProfile> profiles) async {
    try {
      await _channel.invokeMethod<void>(
        'saveProfiles',
        {'data': ProfileCodec.encodeProfiles(profiles)},
      );
    } on PlatformException catch (error) {
      throw Exception('Could not save profiles: ${error.message}');
    }
  }

  Future<void> saveProfile(VpnProfile profile) async {
    final profiles = await loadProfiles();

    final index = profiles.indexWhere(
      (item) => item.id == profile.id,
    );

    if (index == -1) {
      profiles.add(profile);
    } else {
      profiles[index] = profile;
    }

    await saveProfiles(profiles);
  }

  Future<void> deleteProfile(String id) async {
    final profiles = await loadProfiles();

    profiles.removeWhere((profile) => profile.id == id);

    await saveProfiles(profiles);
  }

  Future<void> clearProfiles() async {
    await saveProfiles([]);
  }
}
