class Device {
  Device({required this.name, required this.id, required this.inProgress});

  final String name;
  final String id;
  final bool inProgress;

  Device copyWith({
    String? name,
    String? id,
    bool? inProgress,
  }) {
    return Device(
      name: name ?? this.name,
      id: id ?? this.id,
      inProgress: inProgress ?? this.inProgress,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Device &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          id == other.id &&
          inProgress == other.inProgress;

  @override
  int get hashCode => name.hashCode ^ id.hashCode ^ inProgress.hashCode;

  @override
  String toString() {
    return 'Device{name: $name, id: $id, inProgress: $inProgress}';
  }
}
