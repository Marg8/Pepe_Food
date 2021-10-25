class AddressModel {
  String locacion;
  String colonia;
  String ciudad;
  String estado;
  String addressID;

  AddressModel({
    this.locacion,
    this.colonia,
    this.ciudad,
    this.estado,
    this.addressID
  });

  AddressModel.fromJson(Map<String, dynamic> json) {
    locacion = json['locacion'];
    colonia = json['colonia'];
    ciudad = json['ciudad'];
    estado = json['estado'];
    addressID = json['addressID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['locacion'] = this.locacion;
    data['colonia'] = this.colonia;
    data['ciudad'] = this.ciudad;
    data['estado'] = this.estado;
    data['addressID'] = this.addressID;
    return data;
  }
}
