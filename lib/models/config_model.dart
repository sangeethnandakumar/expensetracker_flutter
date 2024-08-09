// lib/models/config_model.dart
class ConfigModel {
  final String? instance;
  bool isFirstRun;
  final String? deviceId;
  final User? user;
  final Update? update;
  final Rating? rating;
  final Subscription? subscription;
  final List<Device>? devices;
  final List<Misc>? misc;

  ConfigModel({
    required this.instance,
    required this.isFirstRun,
    required this.deviceId,
    required this.user,
    required this.update,
    required this.rating,
    required this.subscription,
    required this.devices,
    required this.misc,
  });

  factory ConfigModel.fromJson(Map<String, dynamic> json) {
    return ConfigModel(
      instance: json['instance'],
      isFirstRun: json['isFirstRun'] ?? false, // Default to false if null
      deviceId: json['deviceId'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      update: json['update'] != null ? Update.fromJson(json['update']) : null,
      rating: json['rating'] != null ? Rating.fromJson(json['rating']) : null,
      subscription: json['subscription'] != null ? Subscription.fromJson(json['subscription']) : null,
      devices: (json['devices'] as List<dynamic>?)
          ?.map((e) => Device.fromJson(e))
          .toList() ?? [], // Default to an empty list if null
      misc: (json['misc'] as List<dynamic>?)
          ?.map((e) => Misc.fromJson(e))
          .toList() ?? [], // Default to an empty list if null
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'instance': instance,
      'isFirstRun': isFirstRun,
      'deviceId': deviceId,
      'user': user?.toJson(),
      'update': update?.toJson(),
      'rating': rating?.toJson(),
      'subscription': subscription?.toJson(),
      'devices': devices?.map((e) => e.toJson()).toList(),
      'misc': misc?.map((e) => e.toJson()).toList(),
    };
  }
}

class User {
  final String? id;
  final String? firstName;
  final String? lastName;
  final String? email;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
    };
  }
}

class Update {
  final bool forceUpdate;
  final double latest;
  final String title;
  final String changelog;

  Update({
    required this.forceUpdate,
    required this.latest,
    required this.title,
    required this.changelog,
  });

  factory Update.fromJson(Map<String, dynamic> json) {
    return Update(
      forceUpdate: json['forceUpdate'],
      latest: json['latest'].toDouble(),
      title: json['title'],
      changelog: json['changelog'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'forceUpdate': forceUpdate,
      'latest': latest,
      'title': title,
      'changelog': changelog,
    };
  }
}

class Rating {
  final bool forcePrompt;
  final String title;

  Rating({
    required this.forcePrompt,
    required this.title,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      forcePrompt: json['forcePrompt'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'forcePrompt': forcePrompt,
      'title': title,
    };
  }
}

class Subscription {
  final bool isSubscribed;
  final String? subscriptionPlan;

  Subscription({
    required this.isSubscribed,
    required this.subscriptionPlan,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      isSubscribed: json['isSubscribed'],
      subscriptionPlan: json['subscriptionPlan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isSubscribed': isSubscribed,
      'subscriptionPlan': subscriptionPlan,
    };
  }
}

class Device {
  final String? id;
  final String? model;
  final String? brand;

  Device({
    required this.id,
    required this.model,
    required this.brand,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'],
      model: json['model'],
      brand: json['brand']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'model': model,
      'brand': brand
    };
  }
}

class Misc {
  final String key;
  final String value;

  Misc({
    required this.key,
    required this.value,
  });

  factory Misc.fromJson(Map<String, dynamic> json) {
    return Misc(
      key: json['key'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'value': value,
    };
  }
}
