class Vehicle {
  final String name;
  final String vin;
  final double kilometers;
  final int year;
  final double engineSize;
  final String color;
  final int doors;
  final String fuelType;
  final String driveTrain;
  final int enginePower;
  final int length;
  final int width;
  final int height;
  final int cylinders;
  final String manufacturer;
  final List<String> images;

  Vehicle({
    required this.name,
    required this.vin,
    required this.kilometers,
    required this.year,
    required this.engineSize,
    required this.color,
    required this.doors,
    required this.fuelType,
    required this.driveTrain,
    required this.enginePower,
    required this.length,
    required this.width,
    required this.height,
    required this.cylinders,
    required this.manufacturer,
    required this.images,
  });

  Map<String, dynamic> toMap() => {
        'name': name,
        'vin': vin,
        'kilometers': kilometers,
        'year': year,
        'engine_size': engineSize,
        'color': color,
        'doors': doors,
        'fuel_type': fuelType,
        'drivetrain': driveTrain,
        'engine_power': enginePower,
        'length': length,
        'width': width,
        'height': height,
        'cylinders': cylinders,
        'manufacturer': manufacturer,
        'images': images,
      };
}
