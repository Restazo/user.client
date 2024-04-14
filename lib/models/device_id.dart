class DeviceId {
  const DeviceId({
    required this.deviceId,
  });

  final String deviceId;
  
  factory DeviceId.fromJson(Map<String, dynamic> json) {
    return DeviceId(
      deviceId: json['deviceId']!,
    );
  }
}
