class Memorie {
  int id;
  String image;
  double latitude;
  double longitude;
  String description;
  String formattedAddress;

  Memorie([
    this.id,
    this.image,
    this.latitude,
    this.longitude,
    this.description,
    this.formattedAddress,
  ]);

  Map<String, Object> toMap() {
    return {
      'id': this.id,
      'image': this.image,
      'latitude': this.latitude,
      'longitude': this.longitude,
      'description': this.description,
      'formattedAddress': this.formattedAddress,
    };
  }
}
