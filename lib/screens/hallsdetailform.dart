import 'dart:async';
import 'dart:io';

import 'package:barat/screens/custom_google_map.dart';
import 'package:barat/widgets/reusableBigText.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:image_picker/image_picker.dart';
import '../services/locationservices.dart';
import '../utils/color.dart';
import '../widgets/reusableTextField.dart';
import '../widgets/reusableTextIconButton.dart';
import 'admin.dart';

class HallsDetailForm extends StatefulWidget {
  const HallsDetailForm({Key? key}) : super(key: key);
  static const routeName = '/hall-details-form';

  @override
  State<HallsDetailForm> createState() => _HallsDetailFormState();
}

class _HallsDetailFormState extends State<HallsDetailForm> {
  final areaid = Get.arguments[0]['areaid'];
  final hallid = Get.arguments[1]['hallid'];

  final locationServices = Get.find<LocationServices>();
  // LocationServices locationServices = LocationServices();
  final ImagePicker _imagePicker = ImagePicker();
  final List<XFile> _selectedFiles = [];
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  List<String> arrimgsUrl = [];
  int uploadItem = 0;
  bool _upLoading = false;
  var img_url;

  String? AreaName;
  String? UserName;
  List<String>? AreaListArray = ['A', 'B', 'C', 'D'];
  RegExp regExp = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  final TextEditingController ownerName = TextEditingController();
  final TextEditingController hallName = TextEditingController();
  final TextEditingController ownerContact = TextEditingController();
  final TextEditingController ownerEmail = TextEditingController();
  final TextEditingController hallAddress = TextEditingController();
  final TextEditingController hallCapacity = TextEditingController();
  final TextEditingController pricePerHead = TextEditingController();
  final TextEditingController cateringPerHead = TextEditingController();
  final TextEditingController areaName = TextEditingController();
  bool isLoading = true;
  bool eventPlanner = false;
  bool isAdmin = true;
  bool isload = false;

  Future<void> _asyncMethod() async {
    await FirebaseFirestore.instance
        .collection("admin")
        .doc(areaid)
        .collection('halls')
        .doc(hallid)
        .get()
        .then((DocumentSnapshot docsnapshot) {
      Map<String, dynamic> data = docsnapshot.data()! as Map<String, dynamic>;
      hallName.text = data["hallName"];
      // areaName.text = data["areaName"];
      ownerName.text = data["OwnerName"];
      ownerContact.text = data["OwnerContact"].toString();
      ownerEmail.text = data["OwnerEmail"];
      hallAddress.text = data["HallAddress"];
      hallCapacity.text = data["HallCapacity"].toString();
      pricePerHead.text = data["PricePerHead"].toString();
      cateringPerHead.text = data["CateringPerHead"].toString();
      eventPlanner = data["EventPlanner"];
    }).whenComplete(() {
      if (eventPlanner) {
        eventPlanner == true;
      }
      setState(() {
        isload = true;
      });
    });
  }

  @override
  void initState() {
    print("Hall id : $hallid");
    //subscribe
    if (isAdmin) {
      FirebaseMessaging.instance.subscribeToTopic("Admin");
    }
    if (hallid != null) {
      _asyncMethod().whenComplete(() {});
    } else {
      setState(() {
        isload = true;
      });
    }
    super.initState();
    LocationServices().fetchLocationArea();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    ownerName.dispose();
    hallName.dispose();
    ownerContact.dispose();
    ownerEmail.dispose();
    hallAddress.dispose();
    hallCapacity.dispose();
    pricePerHead.dispose();
    cateringPerHead.dispose();
    areaName.dispose();
  }

  Future<void> showPlacePicker(BuildContext context) async {
    const apiKey = "AIzaSyBqbPKtyaIo4H85J5or0lCZ7Lyipc8nxSY";
    const LatLng initialPosition = LatLng(31.5116835, 74.3330131);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlacePicker(
          apiKey: apiKey,
          onPlacePicked: (result) {
            print('AAAAAAA :${result.formattedAddress}');
            Navigator.of(context).pop();
            setState(() {
              hallAddress.value =
                  TextEditingValue(text: result.formattedAddress ?? '');
            });
          },
          initialPosition: initialPosition,
          useCurrentLocation: true,
        ),
      ),
    );
  }

  displayValidationError(BuildContext context, String errorname) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$errorname is Empty"),
      ),
    );
  }

  void validation(BuildContext context) {
    if (ownerName.text.trim().isEmpty &&
        hallName.text.trim().isEmpty &&
        ownerContact.text.trim().isEmpty &&
        ownerEmail.text.trim().isEmpty &&
        hallAddress.text.trim().isEmpty &&
        hallCapacity.text.trim().isEmpty &&
        pricePerHead.text.trim().isEmpty &&
        cateringPerHead.text.trim().isEmpty &&
        areaName.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("All Field Are Empty"),
        ),
      );
    } else if (hallName.text.trim().isEmpty) {
      displayValidationError(context, "Hall Name");
    } else if (areaName.text.trim().isEmpty) {
      displayValidationError(context, "Area Name");
    } else if (ownerName.text.trim().isEmpty) {
      displayValidationError(context, "Owner Name");
    } else if (ownerContact.text.trim().isEmpty) {
      displayValidationError(context, "Owner's Contact");
    } else if (ownerEmail.text.trim().isEmpty) {
      displayValidationError(context, "Owner's Email");
    } else if (!regExp.hasMatch(ownerEmail.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please Try Vaild Email"),
        ),
      );
    } else if (hallAddress.text.trim().isEmpty) {
      displayValidationError(context, "Hall Address");
    } else if (hallCapacity.text.trim().isEmpty) {
      displayValidationError(context, "Hall Capacity");
    } else if (pricePerHead.text.trim().isEmpty) {
      displayValidationError(context, "Price");
    } else if (cateringPerHead.text.trim().isEmpty) {
      displayValidationError(context, "Catering Price");
    } else if (_selectedFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please Select Image"),
        ),
      );
    } else {
      if (_selectedFiles.isNotEmpty) {
        postHallsByAdmin(
            listImages: arrimgsUrl,
            areaName: areaName.text.toString().toLowerCase(),
            halladdress: hallAddress.text.toString(),
            ownerName: ownerName.text.toString(),
            hallName: hallName.text.toString(),
            ownerContact: int.tryParse(ownerContact.text) ?? 1,
            ownerEmail: ownerEmail.text.toString().toLowerCase(),
            hallCapacity: int.parse(hallCapacity.text),
            pricePerHead: int.parse(pricePerHead.text),
            cateringPerHead: int.parse(cateringPerHead.text),
            eventPlanner: eventPlanner,
            context: context);
        // Get.to(() => const AdminPage());
      }
    }
  }

  Future<void> postHallsByAdmin(
      {required List listImages,
      required String ownerName,
      required String hallName,
      required String halladdress,
      required int ownerContact,
      required String ownerEmail,
      required String areaName,
      required int hallCapacity,
      required int pricePerHead,
      required int cateringPerHead,
      required bool eventPlanner,
      required BuildContext context}) async {
    var db = FirebaseFirestore.instance;
    bool? checkOwnerEmail;
    bool? checklawn;
    var ownerid;
    var areaid;
    print("Owner email is $ownerEmail");

    // get user from Firebase
    QuerySnapshot userdata =
        await db.collection('User').where('email', isEqualTo: ownerEmail).get();

    // get area from Firebase
    // check if area exist in Firebase
    QuerySnapshot area = await db
        .collection('admin')
        .where('areaName', isEqualTo: areaName)
        .get();
    print("Getting user data : $userdata and  Area $area");
    if (userdata.size > 0 && area.size > 0) {
      userdata.docs.forEach((doc) {
        ownerid = doc.get("userId");
        print("Owner email is $ownerEmail");
      });
      area.docs.forEach((doc) {
        print("The Data is F0ollowing : ${userdata.docs[0].get("email")}");
        areaid = doc.get("id");
      });
      print("The Area Name is $areaid");
      await uploadFunction(_selectedFiles);
      var halldoc = await FirebaseFirestore.instance
          .collection("admin")
          .doc(areaid)
          .collection("halls")
          .doc();
      print("The Hall id is ${halldoc}");

      await FirebaseFirestore.instance
          .collection("admin")
          .doc(areaid)
          .collection("halls")
          .doc(halldoc.id)
          .set({
        "areaId": area.docs[0].id,
        "hallName": hallName,
        "hall_id": halldoc.id,
        "EventPlanner": eventPlanner,
        "CateringPerHead": cateringPerHead,
        "HallAddress": halladdress,
        "HallCapacity": hallCapacity,
        "OwnerContact": ownerContact,
        "OwnerEmail": ownerEmail,
        "OwnerName": ownerName,
        "PricePerHead": pricePerHead,
        "createdAt": Timestamp.now(),
        "images": listImages,
        "updatedAt": Timestamp.now(),
        "hallOwnerId": ownerid,
      });
      _selectedFiles.clear();
      print("Hall Created");
      Get.back();
    } else if (userdata.docs.isEmpty) {
      print("The Email is ${ownerEmail}");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 3),
          content: Text("Owner Email is Invalid"),
        ),
      );
    } else if (area.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Area is Invalid"),
        ),
      );
    } else {
      print("Something went Wrong");
    }
  }

  Future<void> existHallvalidation(BuildContext context) async {
    if (ownerName.text.trim().isEmpty &&
        hallName.text.trim().isEmpty &&
        ownerContact.text.trim().isEmpty &&
        hallAddress.text.trim().isEmpty &&
        hallCapacity.text.trim().isEmpty &&
        pricePerHead.text.trim().isEmpty &&
        cateringPerHead.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("All Field Are Empty"),
        ),
      );
    } else if (hallName.text.trim().isEmpty) {
      displayValidationError(context, "Hall Name");
    } else if (ownerName.text.trim().isEmpty) {
      displayValidationError(context, "Owner Name");
    } else if (ownerContact.text.trim().isEmpty) {
      displayValidationError(context, "Owner's Contact");
    } else if (hallAddress.text.trim().isEmpty) {
      displayValidationError(context, "Hall Address");
    } else if (hallCapacity.text.trim().isEmpty) {
      displayValidationError(context, "Hall Capacity");
    } else if (pricePerHead.text.trim().isEmpty) {
      displayValidationError(context, "Price");
    } else if (cateringPerHead.text.trim().isEmpty) {
      displayValidationError(context, "Catering Price");
    } else if (_selectedFiles.isEmpty) {
      // If Images are not updated, Only Text is updated
      updateHallByAdmin(
          listImages: arrimgsUrl,
          halladdress: hallAddress.text.toString(),
          ownerName: ownerName.text.toString(),
          hallName: hallName.text.toString(),
          ownerContact: int.tryParse(ownerContact.text) ?? 1,
          hallCapacity: int.parse(hallCapacity.text),
          pricePerHead: int.parse(pricePerHead.text),
          cateringPerHead: int.parse(cateringPerHead.text),
          eventPlanner: eventPlanner,
          context: context);
    } else if (_selectedFiles.isNotEmpty) {
      // If Images are updated
      await uploadFunction(_selectedFiles);
      updateHallByAdmin(
          listImages: arrimgsUrl,
          halladdress: hallAddress.text.toString(),
          ownerName: ownerName.text.toString(),
          hallName: hallName.text.toString(),
          ownerContact: int.tryParse(ownerContact.text) ?? 1,
          hallCapacity: int.parse(hallCapacity.text),
          pricePerHead: int.parse(pricePerHead.text),
          cateringPerHead: int.parse(cateringPerHead.text),
          eventPlanner: eventPlanner,
          context: context);
    }
  }

// Update Hall
  Future<void> updateHallByAdmin(
      {required List listImages,
      required String ownerName,
      required String hallName,
      required String halladdress,
      required int ownerContact,
      required int hallCapacity,
      required int pricePerHead,
      required int cateringPerHead,
      required bool eventPlanner,
      required BuildContext context}) async {
    await FirebaseFirestore.instance
        .collection("admin")
        .doc(areaid)
        .collection("halls")
        .doc(hallid)
        .update({
      "hallName": hallName,
      "EventPlanner": eventPlanner,
      "CateringPerHead": cateringPerHead,
      "HallAddress": halladdress,
      "HallCapacity": hallCapacity,
      "OwnerContact": ownerContact,
      "OwnerName": ownerName,
      "PricePerHead": pricePerHead,
      "images": listImages,
      "updatedAt": Timestamp.now(),
    });
    _selectedFiles.clear();
    print("Hall Updated");
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    print('49 ${locationServices.fetchLocationArea()}');

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
          child: Container(
        width: 500.w,
        color: primaryColor,
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(50),
              padding: EdgeInsets.only(top: 20.h),
              decoration: BoxDecoration(
                  color: whiteColor, borderRadius: BorderRadius.circular(8)),
              child: isload == true
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const ReusableBigText(text: "Create Hall Details"),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        ReusableTextField(
                          controller: hallName,
                          hintText: 'Hall Name',
                          keyboardType: TextInputType.text,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        hallid == null
                            ? ReusableTextField(
                                controller: areaName,
                                hintText: 'Area Name',
                                keyboardType: TextInputType.emailAddress,
                              )
                            : const SizedBox(width: 0.0, height: 0.0),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        ReusableTextField(
                          controller: ownerName,
                          hintText: 'Owner Name',
                          keyboardType: TextInputType.text,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        ReusableTextField(
                          controller: ownerContact,
                          hintText: 'Owner Contact',
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        ReusableTextField(
                          readonly: hallid != null ? true : false,
                          controller: ownerEmail,
                          hintText: 'Owner Email',
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        ReusableTextField(
                          controller: hallAddress,
                          hintText: 'Hall Address',
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        ReusableTextField(
                          controller: hallCapacity,
                          hintText: 'Hall Capacity',
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        ReusableTextField(
                          controller: pricePerHead,
                          hintText: 'Price Per Head',
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        ReusableTextField(
                          controller: cateringPerHead,
                          hintText: 'Catering Per Head',
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Row(
                          children: [
                            CupertinoSwitch(
                              value: eventPlanner,
                              onChanged: (value) {
                                setState(() {
                                  eventPlanner = value;
                                });
                              },
                            ),
                            const Text('Event Planner')
                          ],
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        SizedBox(
                          height: height * 0.3,
                          child: _upLoading
                              ? showLoading()
                              : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Center(
                                      child: OutlinedButton(
                                          onPressed: () {
                                            selectImage();
                                          },
                                          child: const Text('Select Files')),
                                    ),
                                    Center(
                                      child: _selectedFiles.length == null
                                          ? const Text("No Images Selected")
                                          : Text(
                                              'Image is Selected : ${_selectedFiles.length.toString()}'),
                                    ),
                                    Expanded(
                                      child: hallid == null ||
                                              _selectedFiles.isNotEmpty
                                          ? GridView.builder(
                                              itemCount:
                                                  _selectedFiles.length + 1,
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 3),
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return index == 0
                                                    ? Center(
                                                        child: IconButton(
                                                          icon: Icon(Icons.add),
                                                          onPressed: () {
                                                            pickImage();
                                                          },
                                                        ),
                                                      )
                                                    : Container(
                                                        height: double.infinity,
                                                        alignment:
                                                            Alignment.center, //
                                                        child: Stack(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Image.file(
                                                                  File(_selectedFiles[
                                                                          index -
                                                                              1]
                                                                      .path),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  width: 210,
                                                                  height: 210),
                                                            ),
                                                            Positioned(
                                                              top: 0,
                                                              right: 0,
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  _selectedFiles
                                                                      .removeAt(
                                                                          index -
                                                                              1);
                                                                  setState(
                                                                      () {});
                                                                  print(
                                                                      'delete image from List');
                                                                },
                                                                child:
                                                                    const Icon(
                                                                  Icons.cancel,
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                              })
                                          : StreamBuilder<DocumentSnapshot>(
                                              stream: FirebaseFirestore.instance
                                                  .collection("admin")
                                                  .doc(areaid)
                                                  .collection('halls')
                                                  .doc(hallid)
                                                  .snapshots(),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<
                                                          DocumentSnapshot>
                                                      snapshot) {
                                                if (snapshot.connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                    color: Colors.green,
                                                  ));
                                                } else if (!snapshot.hasData ||
                                                    !snapshot.data!.exists) {
                                                  return const Center(
                                                    child: Text(
                                                      "No Image",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  Map<String, dynamic> data =
                                                      snapshot.data!.data()
                                                          as Map<String,
                                                              dynamic>;
                                                  arrimgsUrl = data['images']
                                                      .cast<String>();

                                                  return GridView.builder(
                                                      itemCount:
                                                          arrimgsUrl.length,
                                                      gridDelegate:
                                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                                              crossAxisCount:
                                                                  3),
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(3.0),
                                                          child: Image.network(
                                                            arrimgsUrl[index],
                                                            fit: BoxFit.cover,
                                                            height:
                                                                double.infinity,
                                                            width:
                                                                double.infinity,
                                                          ),
                                                        );
                                                      });
                                                }
                                              }),
                                    )
                                  ],
                                ),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        InkWell(
                          onTap: () async {
                            hallid == null
                                ?
                                // Create New Hall
                                validation(context)
                                :
                                // Update Existing Hall
                                existHallvalidation(context);
                          },
                          child: const ReusableTextIconButton(
                            text: "Submit",
                          ),
                        ),
                        SizedBox(
                          height: height * 0.15,
                        ),
                      ],
                    )
                  : SizedBox(
                      height: height,
                      width: 20.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text("Please Wait..."),
                          SizedBox(
                            height: 15,
                          ),
                          CircularProgressIndicator(),
                          SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ),
      )),
    );
  }

  //showLoading Login()
  Widget showLoading() {
    return Center(
      child: Column(
        children: [
          Text(
            "Uploading : " +
                uploadItem.toString() +
                "/" +
                _selectedFiles.length.toString(),
          ),
          const SizedBox(height: 30),
          const CircularProgressIndicator()
        ],
      ),
    );
  }
  //Finish showLoading Login()

  //upload ImageFile One by one
  Future<List> uploadFunction(List<XFile> _images) async {
    for (int i = 0; i < _images.length; i++) {
      var imageUrl = await uploadFile(_images[i]);
      arrimgsUrl.add(imageUrl.toString());
    }

    print("93 $arrimgsUrl");
    return arrimgsUrl;
  }
  //Finish upload ImageFile One by one

  //Upload Images in Firestore Storage
  Future<String> uploadFile(XFile _image) async {
    setState(() {
      _upLoading = true;
    });
    Reference reference =
        _firebaseStorage.ref().child("areaImages").child(_image.name);
    await reference.putFile(File(_image.path)).whenComplete(() async {
      setState(() {
        uploadItem += 1;
        if (uploadItem == _selectedFiles.length) {
          _upLoading = false;
          uploadItem = 0;
        }
      });
    });

    return await reference.getDownloadURL();
  }
  //Finish Upload Images in Firestore Storage

  Future<void> pickImage() async {
    try {
      final List<XFile>? imgs = await _imagePicker.pickMultiImage(
        imageQuality: 50,
        maxWidth: 400,
        maxHeight: 400,
      );

      if (imgs!.isNotEmpty) {
        _selectedFiles.addAll(imgs);
      }
      print("List of Images : " + imgs.length.toString());
    } catch (e) {
      print("Something Wrong" + e.toString());
    }
    setState(() {});
  }

//Select Image From Gallery
  Future<void> selectImage() async {
    _selectedFiles.clear();

    try {
      final List<XFile>? imgs = await _imagePicker.pickMultiImage(
        imageQuality: 50,
        maxWidth: 400,
        maxHeight: 400,
      );

      if (imgs!.isNotEmpty) {
        _selectedFiles.addAll(imgs);
      }
      print("List of Images : " + imgs.length.toString());
    } catch (e) {
      print("Something Wrong" + e.toString());
    }
    setState(() {});
  }
//Finish Select Image From Gallery

}
