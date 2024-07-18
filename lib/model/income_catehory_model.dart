class IncomeCategoryModel {
  late String categoryName;
  late String categoryDescription;

  IncomeCategoryModel({
    required this.categoryName,
    required this.categoryDescription,
  });

  IncomeCategoryModel.fromJson(Map<dynamic, dynamic> json) {
    categoryName = json['categoryName'] as String;
    categoryDescription = json['categoryDescription'] as String;
  }

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'categoryName': categoryName,
        'categoryDescription': categoryDescription,
      };
}
