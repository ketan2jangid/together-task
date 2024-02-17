class DataModel {
  int? id;
  String? title;
  String? description;
  String? imageUrl;

  DataModel({this.id, this.title, this.description, this.imageUrl});

  DataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['image_url'] = imageUrl;

    return data;
  }
}
