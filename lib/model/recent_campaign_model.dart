// To parse this JSON data, do
//
//     final recentCampaignModel = recentCampaignModelFromJson(jsonString);

import 'dart:convert';

RecentCampaignModel recentCampaignModelFromJson(String str) =>
    RecentCampaignModel.fromJson(json.decode(str));

String recentCampaignModelToJson(RecentCampaignModel data) =>
    json.encode(data.toJson());

class RecentCampaignModel {
  RecentCampaignModel({
    required this.donationRecent,
  });

  DonationRecent donationRecent;

  factory RecentCampaignModel.fromJson(Map<String, dynamic> json) =>
      RecentCampaignModel(
        donationRecent: DonationRecent.fromJson(json["donation_recent"]),
      );

  Map<String, dynamic> toJson() => {
        "donation_recent": donationRecent.toJson(),
      };
}

class DonationRecent {
  DonationRecent({
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

  factory DonationRecent.fromJson(Map<String, dynamic> json) => DonationRecent(
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
    this.raised,
    this.amount,
    this.image,
  });

  int? id;
  String? title;
  String? raised;
  String? amount;
  String? image;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        title: json["title"],
        raised: json["raised"],
        amount: json["amount"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "raised": raised,
        "amount": amount,
        "image": image,
      };
}
