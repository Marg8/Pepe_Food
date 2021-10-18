// To parse this JSON data, do
//
//     final CpModel = CpModelFromJson(jsonString);

import 'dart:convert';

List<Map<String, CpModel>> cpModelFromJson(String str) => List<Map<String, CpModel>>.from(json.decode(str).map((x) => Map.from(x).map((k, v) => MapEntry<String, CpModel>(k, CpModel.fromJson(v)))));

String cpModelToJson(List<Map<String, CpModel>> data) => json.encode(List<dynamic>.from(data.map((x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())))));

class CpModel {
    CpModel({
        this.asentamiento,
        this.nombreAsentamiento,
        this.municipio,
        this.estado,
        this.cdigoPostal,
        this.costo,
        this.zonas,
    });

    Asentamiento asentamiento;
    String nombreAsentamiento;
    Municipio municipio;
    Estado estado;
    int cdigoPostal;
    int costo;
    int zonas;

    factory CpModel.fromJson(Map<String, dynamic> json) => CpModel(
        asentamiento: asentamientoValues.map[json["Asentamiento"]],
        nombreAsentamiento: json["Nombre Asentamiento"],
        municipio: municipioValues.map[json["Municipio"]],
        estado: estadoValues.map[json["Estado"]],
        cdigoPostal: json["Código Postal"],
        costo: json["Costo"],
        zonas: json["Zonas"],
    );

    Map<String, dynamic> toJson() => {
        "Asentamiento": asentamientoValues.reverse[asentamiento],
        "Nombre Asentamiento": nombreAsentamiento,
        "Municipio": municipioValues.reverse[municipio],
        "Estado": estadoValues.reverse[estado],
        "Código Postal": cdigoPostal,
        "Costo": costo,
        "Zonas": zonas,
    };
}

enum Asentamiento { COLONIA, FRACCIONAMIENTO, UNIDAD_HABITACIONAL, ZONA_COMERCIAL, ZONA_INDUSTRIAL, EJIDO, AEROPUERTO, BARRIO, EQUIPAMIENTO, PUEBLO, RANCHERA, PUERTO }

final asentamientoValues = EnumValues({
    "Aeropuerto": Asentamiento.AEROPUERTO,
    "Barrio": Asentamiento.BARRIO,
    "Colonia": Asentamiento.COLONIA,
    "Ejido": Asentamiento.EJIDO,
    "Equipamiento": Asentamiento.EQUIPAMIENTO,
    "Fraccionamiento": Asentamiento.FRACCIONAMIENTO,
    "Pueblo": Asentamiento.PUEBLO,
    "Puerto": Asentamiento.PUERTO,
    "Ranchería": Asentamiento.RANCHERA,
    "Unidad habitacional": Asentamiento.UNIDAD_HABITACIONAL,
    "Zona comercial": Asentamiento.ZONA_COMERCIAL,
    "Zona industrial": Asentamiento.ZONA_INDUSTRIAL
});

enum Estado { TAMAULIPAS }

final estadoValues = EnumValues({
    "Tamaulipas": Estado.TAMAULIPAS
});

enum Municipio { MATAMOROS }

final municipioValues = EnumValues({
    "Matamoros": Municipio.MATAMOROS
});

class EnumValues<T> {
    Map<String, T> map;
    Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        if (reverseMap == null) {
            reverseMap = map.map((k, v) => new MapEntry(v, k));
        }
        return reverseMap;
    }
}
