class HallModel {
  List? images;
  String? userID;
  String? ownerName;
  late var ownerContact;
  String? ownerEmail;
  String? hallAddress;
  late var hallCapacity;
  late var pricePerHead;
  late var cateringPerHead;
  String? hallOwnerId;
  String? hallid;
  double? rating;
  String? hallname;

  HallModel.fromMap(dynamic data) {
    images = data["images"];
    userID = data.toString();
    ownerName = data["OwnerName"];
    ownerContact = data["OwnerContact"];
    ownerEmail = data["OwnerEmail"];
    hallAddress = data["HallAddress"];
    hallCapacity = data["HallCapacity"];
    pricePerHead = data["PricePerHead"];
    cateringPerHead = data["CateringPerHead"];
    hallOwnerId = data["hallOwnerId"];
    hallid = data["hall_id"];
    hallname = data["hallName"];
  }
}
