import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  String title;
  String shortInfo;
  Timestamp publishedDate;
  String thumbnailUrl;
  String longDescription;
  String status;
  int price;
  int cartPrice;
  int qtyitems;
  String productId;
  String color;
  String category;
  String extra;
  String nota;

  ItemModel(
      {this.title,
      this.shortInfo,
      this.publishedDate,
      this.thumbnailUrl,
      this.longDescription,
      this.status,
      this.qtyitems,
      this.productId,
      this.color,
      this.price,
      this.cartPrice,
      this.category,
      this.extra,
      this.nota,});

  ItemModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    shortInfo = json['shortInfo'];
    publishedDate = json['publishedDate'];
    thumbnailUrl = json['thumbnailUrl'];
    longDescription = json['longDescription'];
    status = json['status'];
    price = json['price'];
    cartPrice = json["cartPrice"];
    qtyitems = json["qtyitems"];
    productId = json["productId"];
    color = json["color"];
    category = json["category"];
    extra = json["extra"];
    nota = json["nota"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['shortInfo'] = this.shortInfo;
    data['price'] = this.price;
    data["cartPrice"] = this.cartPrice;
    if (this.publishedDate != null) {
      data['publishedDate'] = this.publishedDate;
    }
    data['thumbnailUrl'] = this.thumbnailUrl;
    data['longDescription'] = this.longDescription;
    data['status'] = this.status;
    data["qtyitems"] = this.qtyitems;
    data["productId"] = this.productId;
    data["color"] = this.color;
    data["extra"] = this.extra;
    data["nota"] = this.nota;
    return data;
  }
}

class PublishedDate {
  String date;

  PublishedDate({this.date});

  PublishedDate.fromJson(Map<String, dynamic> json) {
    date = json['$date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$date'] = this.date;
    return data;
  }
}



