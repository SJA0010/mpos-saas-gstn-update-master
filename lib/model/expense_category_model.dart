class ExpenseCategoryModel {
  late String categoryName;
  late String categoryDescription;

  ExpenseCategoryModel({
    required this.categoryName,
    required this.categoryDescription,
  });

  ExpenseCategoryModel.fromJson(Map<dynamic, dynamic> json) {
    categoryName = json['categoryName'] as String;
    categoryDescription = json['categoryDescription'] as String;
  }

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'categoryName': categoryName,
        'categoryDescription': categoryDescription,
      };
}
