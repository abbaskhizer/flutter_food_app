// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Food {
  String imageURL;
  String name;
  num price;
  num? quentity;
  DateTime? dateTime;
  String? email; 
  String? detail;
  String id;
  
  Food({
    required this.imageURL,
    required this.name,
    required this.price,
    this.quentity=1,
    this.dateTime,
    this.email,
    this.detail,
    required this.id,
  });

  Food copyWith({
    String? imageURL,
    String? name,
    num? price,
    num? quentity,
    DateTime? dateTime,
    String? email,
    String? detail,
    String? id,
  }) {
    return Food(
      imageURL: imageURL ?? this.imageURL,
      name: name ?? this.name,
      price: price ?? this.price,
      quentity: quentity ?? this.quentity,
      dateTime: dateTime ?? this.dateTime,
      email: email ?? this.email,
      detail: detail ?? this.detail,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'imageURL': imageURL,
      'name': name,
      'price': price,
      'quentity': quentity,
      'dateTime': dateTime?.millisecondsSinceEpoch,
      'email': email,
      'detail': detail,
      'id': id,
    };
  }

  factory Food.fromMap(Map<String, dynamic> map) {
    return Food(
      imageURL: map['imageURL'] as String,
      name: map['name'] as String,
      price: map['price'] as num,
      quentity: map['quentity'] != null ? map['quentity'] as num : null,
      dateTime: map['dateTime'] != null ? DateTime.fromMillisecondsSinceEpoch(map['dateTime'] as int) : null,
      email: map['email'] != null ? map['email'] as String : null,
      detail: map['detail'] != null ? map['detail'] as String : null,
      id: map['id'].toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Food.fromJson(String source) => Food.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Food(imageURL: $imageURL, name: $name, price: $price, quentity: $quentity, dateTime: $dateTime, email: $email, detail: $detail, id: $id)';
  }

  @override
  bool operator ==(covariant Food other) {
    if (identical(this, other)) return true;
  
    return 
      other.imageURL == imageURL &&
      other.name == name &&
      other.price == price &&
      other.quentity == quentity &&
      other.dateTime == dateTime &&
      other.email == email &&
      other.detail == detail &&
      other.id == id;
  }

  @override
  int get hashCode {
    return imageURL.hashCode ^
      name.hashCode ^
      price.hashCode ^
      quentity.hashCode ^
      dateTime.hashCode ^
      email.hashCode ^
      detail.hashCode ^
      id.hashCode;
  }
}
