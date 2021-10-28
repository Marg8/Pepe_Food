import 'package:cloud_firestore/cloud_firestore.dart';

class Request {
  String user;
  String locacion;
  Timestamp time;


  Request(
      {this.user,
      this.locacion,
      this.time,
     });

  Request.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    locacion = json['locacion'];
    time= json['time'];
    
   
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user'] = this.user;
    data['locacion'] = this.locacion;
    data['time'] = this.time;
    
    return data;
  }
}




