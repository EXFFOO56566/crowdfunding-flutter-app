// To parse this JSON data, do
//
//     final followedUserCampaignModel = followedUserCampaignModelFromJson(jsonString);

import 'dart:convert';

FollowedUserCampaignModel followedUserCampaignModelFromJson(String str) =>
    FollowedUserCampaignModel.fromJson(json.decode(str));

String followedUserCampaignModelToJson(FollowedUserCampaignModel data) =>
    json.encode(data.toJson());

class FollowedUserCampaignModel {
  FollowedUserCampaignModel({
    required this.data,
    this.campaignUserId,
  });

  Data data;
  String? campaignUserId;

  factory FollowedUserCampaignModel.fromJson(Map<String, dynamic> json) =>
      FollowedUserCampaignModel(
        data: Data.fromJson(json["data"]),
        campaignUserId: json["campaign_user_id"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "campaign_user_id": campaignUserId,
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
