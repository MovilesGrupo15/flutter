import 'package:hive/hive.dart';
import 'recycling_point_model.dart';

part 'recycling_point_adapter.g.dart';

@HiveType(typeId: 0)
class RecyclingPointHive extends RecyclingPoint {
  RecyclingPointHive({
    required String id,
    required String name,
    required double latitude,
    required double longitude,
    required String address,
    required String residuoNombre,
    required String horario,
    String? fecha,
    String? imagenUrl,
    int? localidadId,
    String? localidadNombre,
    List<int>? residuoId,
    String? resourceUri,
    int? sectorcatastralId,
    String? sectorcatastralNombre,
    String? telefono,
    double? distanceMeters,
  }) : super(
          id: id,
          name: name,
          latitude: latitude,
          longitude: longitude,
          address: address,
          residuoNombre: residuoNombre,
          horario: horario,
          fecha: fecha,
          imagenUrl: imagenUrl,
          localidadId: localidadId,
          localidadNombre: localidadNombre,
          residuoId: residuoId,
          resourceUri: resourceUri,
          sectorcatastralId: sectorcatastralId,
          sectorcatastralNombre: sectorcatastralNombre,
          telefono: telefono,
          distanceMeters: distanceMeters,
        );

  @override
  @HiveField(0)
  String get id => super.id;

  @override
  @HiveField(1)
  String get name => super.name;

  @override
  @HiveField(2)
  double get latitude => super.latitude;

  @override
  @HiveField(3)
  double get longitude => super.longitude;

  @override
  @HiveField(4)
  String get address => super.address;

  @override
  @HiveField(5)
  String get residuoNombre => super.residuoNombre;

  @override
  @HiveField(6)
  String get horario => super.horario;

  @override
  @HiveField(7)
  String? get fecha => super.fecha;

  @override
  @HiveField(8)
  String? get imagenUrl => super.imagenUrl;

  @override
  @HiveField(9)
  int? get localidadId => super.localidadId;

  @override
  @HiveField(10)
  String? get localidadNombre => super.localidadNombre;

  @override
  @HiveField(11)
  List<int>? get residuoId => super.residuoId;

  @override
  @HiveField(12)
  String? get resourceUri => super.resourceUri;

  @override
  @HiveField(13)
  int? get sectorcatastralId => super.sectorcatastralId;

  @override
  @HiveField(14)
  String? get sectorcatastralNombre => super.sectorcatastralNombre;

  @override
  @HiveField(15)
  String? get telefono => super.telefono;

  @override
  @HiveField(16)
  double? get distanceMeters => super.distanceMeters;
}
