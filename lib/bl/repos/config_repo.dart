import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import '../../models/config_model.dart';
import '../abstractions.dart';
import '../local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigRepository extends BaseRepository<ConfigModel> {
  final LocalStorage _localStorage = LocalStorage();
  final String _filename = 'config.json';
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  @override
  Future<void> create(ConfigModel config) async {
    final data = await _localStorage.readJson(_filename);
    data[config.instance ?? 'defaultInstance'] = config.toJson();
    await _localStorage.writeJson(_filename, data);
  }

  @override
  Future<void> update(ConfigModel config) async {
    final data = await _localStorage.readJson(_filename);
    if (data.containsKey(config.instance)) {
      data[config.instance!] = config.toJson();
      await _localStorage.writeJson(_filename, data);
    }
  }

  @override
  Future<List<ConfigModel>> getAll() async {
    final data = await _localStorage.readJson(_filename);
    return data.values.map((json) => ConfigModel.fromJson(json)).toList();
  }

  @override
  Future<ConfigModel?> getById(String instance) async {
    final data = await _localStorage.readJson(_filename);
    var result = data[instance] != null ? ConfigModel.fromJson(data[instance]) : null;

    if (result == null) {
      var deviceInfo = await _getDeviceInfo();
      var newConfig = ConfigModel(
        instance: 'defaultInstance',
        isFirstRun: true,
        deviceId: deviceInfo['deviceId'],
        user: null,
        update: Update(
          forceUpdate: false,
          latest: 1.0,
          title: "Initial Update",
          changelog: "First version of the app",
        ),
        rating: Rating(
          forcePrompt: false,
          title: "Rate if you enjoy the app. Your rating will be a lot helpful",
        ),
        subscription: Subscription(
          isSubscribed: false,
          subscriptionPlan: null,
        ),
        devices: [
          Device(
            id: deviceInfo['deviceId'],
            model: deviceInfo['model'],
            brand: deviceInfo['brand'],
          )
        ],
        misc: [],
      );
      await create(newConfig);
      return newConfig;
    }
    return result;
  }

  @override
  Future<void> delete(String instance) async {
    final data = await _localStorage.readJson(_filename);
    if (data.containsKey(instance)) {
      data.remove(instance);
      await _localStorage.writeJson(_filename, data);
    }
  }

  Future<Map<String, String>> _getDeviceInfo() async {
    String? deviceId = await _getDeviceId();
    String model = '';
    String brand = '';

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
      model = androidInfo.model;
      brand = androidInfo.brand;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;
      model = iosInfo.utsname.machine;
      brand = 'Apple';
    }

    return {
      'deviceId': deviceId ?? 'unknown_device_id',
      'model': model,
      'brand': brand,
    };
  }

  Future<String?> _getDeviceId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString('device_id');

    if (deviceId == null) {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
        deviceId = androidInfo.id;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor;
      }
      // Store the device ID for future use
      if (deviceId != null) {
        await prefs.setString('device_id', deviceId);
      }
    }
    return deviceId;
  }
}
