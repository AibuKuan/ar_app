class Equipment {
  String name;
  String modelPath;
  String? category;
  String? specifications;
  String? function;
  String? usage;
  String? maintenance;
  String? warning;

  Equipment(
    this.name, 
    this.modelPath,
    this.category, 
    this.function, 
    this.specifications, 
    this.usage, 
    this.maintenance, 
    this.warning
  );

  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      json['name'],
      json['modelPath'],
      json['category'],
      json['function'],
      json['specifications'],
      json['usage'],
      json['maintenance'],
      json['warning'],
    );
  }
}