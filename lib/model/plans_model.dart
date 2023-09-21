class PlansModel {
  String? id;
  String? displayName;
  String? planName;
  String? validity;
  String? data;
  String? incoming;
  num? price;

  PlansModel(
      {this.id,
        this.displayName,
        this.planName,
        this.validity,
        this.data,
        this.incoming,
        this.price});

  PlansModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    displayName = json['displayName'];
    planName = json['planName'];
    validity = json['validity'];
    data = json['data'];
    incoming = json['incoming'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['displayName'] = this.displayName;
    data['planName'] = this.planName;
    data['validity'] = this.validity;
    data['data'] = this.data;
    data['incoming'] = this.incoming;
    data['price'] = this.price;
    return data;
  }
}
