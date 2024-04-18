import 'package:restazo_user_mobile/models/setting.dart';

class SettingsSection {
  const SettingsSection({required this.label, required this.settings});

  final String label;
  final List<Setting> settings;
}
