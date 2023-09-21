class BrandsModel {
  String? flag;
  String? id;
  String? brandName;
  String? displayName;
  String? countryCode;
  String? countryId;

  BrandsModel({this.flag, this.id, this.brandName, this.displayName, this.countryCode, this.countryId});

  BrandsModel.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    id = json['id'];
    brandName = json['brandName'];
    displayName = json['displayName'];
    countryCode = json['country_code'];
    countryId = json['countryId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['flag'] = this.flag;
    data['id'] = this.id;
    data['brandName'] = this.brandName;
    data['displayName'] = this.displayName;
    data['country_code'] = this.countryCode;
    data['countryId'] = this.countryId;
    return data;
  }
}
