import 'package:hive_flutter/hive_flutter.dart';
import 'recycling_point_model.dart';
import 'recycling_point_adapter.dart';

class RecyclingCacheService {
  static const String _boxName = 'recyclingPointsBox';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(RecyclingPointHiveAdapter());
    await Hive.openBox<RecyclingPointHive>(_boxName);
  }

  static Future<void> saveRecyclingPoints(List<RecyclingPoint> points) async {
    final box = Hive.box<RecyclingPointHive>(_boxName);
    await box.clear();

    final hivePoints = points.map((p) => RecyclingPointHive(
      id: p.id,
      name: p.name,
      latitude: p.latitude,
      longitude: p.longitude,
      address: p.address,
      residuoNombre: p.residuoNombre,
      horario: p.horario,
      fecha: p.fecha,
      imagenUrl: p.imagenUrl,
      localidadId: p.localidadId,
      localidadNombre: p.localidadNombre,
      residuoId: p.residuoId,
      resourceUri: p.resourceUri,
      sectorcatastralId: p.sectorcatastralId,
      sectorcatastralNombre: p.sectorcatastralNombre,
      telefono: p.telefono,
      distanceMeters: p.distanceMeters,
    )).toList();

    await box.addAll(hivePoints);
  }

  static List<RecyclingPoint> getRecyclingPoints() {
    final box = Hive.box<RecyclingPointHive>(_boxName);
    return box.values.map((hivePoint) => RecyclingPoint(
      id: hivePoint.id,
      name: hivePoint.name,
      latitude: hivePoint.latitude,
      longitude: hivePoint.longitude,
      address: hivePoint.address,
      residuoNombre: hivePoint.residuoNombre,
      horario: hivePoint.horario,
      fecha: hivePoint.fecha,
      imagenUrl: hivePoint.imagenUrl,
      localidadId: hivePoint.localidadId,
      localidadNombre: hivePoint.localidadNombre,
      residuoId: hivePoint.residuoId,
      resourceUri: hivePoint.resourceUri,
      sectorcatastralId: hivePoint.sectorcatastralId,
      sectorcatastralNombre: hivePoint.sectorcatastralNombre,
      telefono: hivePoint.telefono,
      distanceMeters: hivePoint.distanceMeters,
    )).toList();
  }

  static Future<void> clearCache() async {
    final box = Hive.box<RecyclingPointHive>(_boxName);
    await box.clear();
  }
}
