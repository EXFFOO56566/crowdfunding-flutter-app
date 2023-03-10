// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';

CategoryModel categoryModelFromJson(String str) =>
    CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
  CategoryModel({
    required this.donationCategory,
  });

  DonationCategory donationCategory;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        donationCategory: DonationCategory.fromJson(json["donation_category"]),
      );

  Map<String, dynamic> toJson() => {
        "donation_category": donationCategory.toJson(),
      };
}

class DonationCategory {
  DonationCategory({
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

  factory DonationCategory.fromJson(Map<String, dynamic> json) =>
      DonationCategory(
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
    this.image,
  });

  int? id;
  String? title;
  String? image;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        title: json["title"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": image,
      };
}
