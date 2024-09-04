import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReportProductModel {
  String? address;
  String? inStockBy;
  DateTime? inStockTime;
  double? latitude;
  double? longitude;
  DateTime? outStockTime;
  String? productCode;
  String? productName;
  String? id;
  String? email;
  String? userUid;
  ReportProductModel(
      {this.address,
      this.inStockBy,
      this.inStockTime,
      this.latitude,
      this.longitude,
      this.outStockTime,
        this.userUid,
        this.email,
        this.id,
        this.productName,
      this.productCode});

  Map<String, dynamic> toMap() {
    return {
      'address': this.address,
      'inStockBy': this.inStockBy,
      'inStockTime': this.inStockTime,
      'latitude': this.latitude,
      'longitude': this.longitude,
      'outStockTime': this.outStockTime,
      'productCode': this.productCode,
      'id': this.id,
      'productName' : this.productName,
      'email' : this.email,
      'userUid' : this.userUid
    };
  }

  factory ReportProductModel.fromMap(Map<String, dynamic> map) {
    return ReportProductModel(
      address: map['address'],
      inStockBy: map['inStockBy'] ,
      inStockTime:(map['inStockTime'] != null)? (map['inStockTime'] as Timestamp).toDate() : null,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      outStockTime: (map['outStockTime'] as Timestamp).toDate() ,
      productCode: map['productCode'] ,
      productName: map['productName'] ,
      email: map['email'] ,
      userUid: map['userUid'] ,
      id: map['id'],
    );
  }
}
