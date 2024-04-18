class Setting {
  const Setting({
    required this.label,
    this.action,
    this.value,
    this.valueExtension,
  });

  final String label;
  final String? value;
  final void Function()? action;
  final String? valueExtension;

  Setting copyWith({
    String? label,
    void Function()? action,
    String? value,
    String? valueExtension,
  }) {
    return Setting(
      label: label ?? this.label,
      action: action ?? this.action,
      value: value ?? this.value,
      valueExtension: valueExtension ?? this.valueExtension,
    );
  }
}
