class UnitModel {
  late String unitName;

  UnitModel(this.unitName);

  UnitModel.fromJson(Map<dynamic, dynamic> json) : unitName = json['unitName'].toString();

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'unitName': unitName,
      };
}
