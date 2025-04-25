// lib/features/map/data/recycling_point_model.dart

class RecyclingPoint {
  // Campos comunes a lista y detalle
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String address;

  // Campos que trae la lista (ya estaban mapeados)
  final String residuoNombre;
  final String horario;

  // Campos extra que trae el detalle
  final String? fecha;
  final String? imagenUrl;
  final int? localidadId;
  final String? localidadNombre;
  final List<int>? residuoId;
  final String? resourceUri;
  final int? sectorcatastralId;
  final String? sectorcatastralNombre;
  final String? telefono;

  // Para ordenar por cercanía
  double? distanceMeters;

  RecyclingPoint({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.residuoNombre,
    required this.horario,
    this.fecha,
    this.imagenUrl,
    this.localidadId,
    this.localidadNombre,
    this.residuoId,
    this.resourceUri,
    this.sectorcatastralId,
    this.sectorcatastralNombre,
    this.telefono,
    this.distanceMeters,
  });

  /// Constructor para la lista (/api/points)
  factory RecyclingPoint.fromListJson(Map<String, dynamic> json) {
    return RecyclingPoint(
      id: json['id'].toString(),
      name: json['name'] ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] ?? '',
      residuoNombre: json['description'] ?? '',
      horario: json['horario'] ?? '',          // asegúrate que el repo mapea este campo
      // el resto queda nulo
      fecha: null,
      imagenUrl: null,
      localidadId: null,
      localidadNombre: null,
      residuoId: null,
      resourceUri: null,
      sectorcatastralId: null,
      sectorcatastralNombre: null,
      telefono: null,
    );
  }

  /// Constructor para el detalle completo (/api/points/{id})
  factory RecyclingPoint.fromDetailJson(Map<String, dynamic> json) {
    // extraemos coords de geom
    final coords = (json['geom']?['coordinates'] as List).cast<num>();
    return RecyclingPoint(
      id: json['gid'].toString(),
      name: json['nombre'] ?? '',
      latitude: coords.length >= 2 ? coords[1].toDouble() : 0.0,
      longitude: coords.length >= 2 ? coords[0].toDouble() : 0.0,
      address: json['direccion'] ?? '',
      residuoNombre: json['residuo_nombre'] ?? '',
      horario: json['horario'] ?? '',
      fecha: json['fecha'],
      imagenUrl: json['imagen_url'],
      localidadId: json['localidad_id'] is int
          ? json['localidad_id'] as int
          : int.tryParse(json['localidad_id'].toString()),
      localidadNombre: json['localidad_nombre'],
      residuoId: (json['residuo_id'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      resourceUri: json['resource_uri'],
      sectorcatastralId: json['sectorcatastral_id'] is int
          ? json['sectorcatastral_id'] as int
          : int.tryParse(json['sectorcatastral_id'].toString()),
      sectorcatastralNombre: json['sectorcatastral_nombre'],
      telefono: json['telefono'],
    );
  }
}
