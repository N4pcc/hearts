class Address {
  String? id;
  final String name;
  final String line1;
  final String line2;
  final double lat;
  final double long;
  final String area;

  Address(
      {this.id,
      required this.name,
      required this.line1,
      required this.line2,
      required this.lat,
      required this.long,
      required this.area});

  static Address fromSnap(Map<String, dynamic> json) {
    return Address(
      id: json["id"],
      name: json["name"],
      line1: json["line1"],
      lat: json["lat"],
      long: json["long"],
      line2: json["line2"],
      area: json["area"],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "line1": line1,
        "line2": line2,
        "area": area,
        "lat": lat,
        "long": long,
      };
}
