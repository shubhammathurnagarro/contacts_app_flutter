import '../data/database.dart';

class Contact {
  final int id;
  final String name, mobile;
  final String? landline, photoPath;
  bool isFavorite;

  Contact(
      {this.id = -1,
      required this.name,
      required this.mobile,
      this.landline,
      this.photoPath,
      this.isFavorite = false});

  factory Contact.fromMap(Map<String, Object?> json) => Contact(
      id: json[ColumnNames.id] as int,
      name: json[ColumnNames.name] as String,
      mobile: json[ColumnNames.mobile] as String,
      landline: json[ColumnNames.landline] as String?,
      photoPath: json[ColumnNames.photoPath] as String?,
      isFavorite: (json[ColumnNames.isFavorite] as int) == 1 ? true : false);

  Map<String, Object?> toMap() => {
        ColumnNames.name: name,
        ColumnNames.mobile: mobile,
        ColumnNames.landline: landline,
        ColumnNames.photoPath: photoPath,
        ColumnNames.isFavorite: isFavorite ? 1 : 0,
      };

  @override
  String toString() {
    return 'Contact{id: $id, name: $name, mobile: $mobile, landline: $landline, photoPath: $photoPath, isFavorite: $isFavorite}';
  }
}
