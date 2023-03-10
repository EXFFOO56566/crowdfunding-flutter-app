// To parse this JSON data, do
//
//     final campaignByCategoryModel = campaignByCategoryModelFromJson(jsonString);

import 'dart:convert';

CampaignByCategoryModel campaignByCategoryModelFromJson(String str) =>
    CampaignByCategoryModel.fromJson(json.decode(str));

String campaignByCategoryModelToJson(CampaignByCategoryModel data) =>
    json.encode(data.toJson());

class CampaignByCategoryModel {
  CampaignByCategoryModel({
    required this.data,
  });

  Data data;

  factory CampaignByCategoryModel.fromJson(Map<String, dynamic> json) =>
      CampaignByCategoryModel(
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
      };
}

class Data {
  Data({
    this.currentPage,
    this.lastPage,
    this.perPage,
    this.path,
    required this.links,
    required this.data,
  });

  int? currentPage;
  int? lastPage;
  int? perPage;
  String? path;
  List<String> links;
  List<Datum> data;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        currentPage: json["current_page"],
        lastPage: json["last_page"],
        perPage: json["per_page"],
        path: json["path"],
        links: List<String>.from(json["links"].map((x) => x)),
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "last_page": lastPage,
        "per_page": perPage,
        "path": path,
        "links": List<dynamic>.from(links.map((x) => x)),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.id,
    this.title,
    this.amount,
    this.raised,
    this.image,
  });

  int? id;
  String? title;
  String? amount;
  String? raised;
  String? image;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        title: json["title"],
        amount: json["amount"],
        raised: json["raised"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "amount": amount,
        "raised": raised,
        "image": image,
      };
}
