// To parse this JSON data, do
//
//     final peopleWhoDonatedModel = peopleWhoDonatedModelFromJson(jsonString);

import 'dart:convert';

PeopleWhoDonatedModel peopleWhoDonatedModelFromJson(String str) =>
    PeopleWhoDonatedModel.fromJson(json.decode(str));

String peopleWhoDonatedModelToJson(PeopleWhoDonatedModel data) =>
    json.encode(data.toJson());

class PeopleWhoDonatedModel {
  PeopleWhoDonatedModel({
    required this.peopleWhoDonated,
  });

  PeopleWhoDonated peopleWhoDonated;

  factory PeopleWhoDonatedModel.fromJson(Map<String, dynamic> json) =>
      PeopleWhoDonatedModel(
        peopleWhoDonated: PeopleWhoDonated.fromJson(json["people_who_donated"]),
      );

  Map<String, dynamic> toJson() => {
        "people_who_donated": peopleWhoDonated.toJson(),
      };
}

class PeopleWhoDonated {
  PeopleWhoDonated({
    this.currentPage,
    required this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  int? currentPage;
  List<Datum> data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Link> links;
  dynamic nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  factory PeopleWhoDonated.fromJson(Map<String, dynamic> json) =>
      PeopleWhoDonated(
        currentPage: json["current_page"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "links": List<dynamic>.from(links.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class Datum {
  Datum({
    this.id,
    this.name,
    this.amount,
    this.createdAt,
  });

  int? id;
  String? name;
  String? amount;
  DateTime? createdAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        amount: json["amount"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "amount": amount,
        "created_at": createdAt?.toIso8601String(),
      };
}

class Link {
  Link({
    this.url,
    this.label,
    this.active,
  });

  String? url;
  String? label;
  bool? active;

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"] ?? null,
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "url": url ?? null,
        "label": label,
        "active": active,
      };
}
