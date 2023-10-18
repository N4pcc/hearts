class AP {
  final String name;
  final bool isActive;
  final InitialFare initialFare;

  AP({
    required this.name,
    required this.isActive,
    required this.initialFare,
  });

  factory AP.fromJson(Map<String, dynamic> json) {
    return AP(
      name: json['name'],
      isActive: json['isActive'],
      initialFare: InitialFare.fromJson(json['initialFare']),
    );
  }
}

class InitialFare {
  final int basic;
  final int advanced;
  final int airAmbulance;

  InitialFare({
    required this.basic,
    required this.advanced,
    required this.airAmbulance,
  });

  factory InitialFare.fromJson(Map<String, dynamic> json) {
    return InitialFare(
      basic: json['Basic'] as int,
      advanced: json['Advanced'] as int,
      airAmbulance: json['Air Ambulance'] as int,
    );
  }
}