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
  final locationServices = Get.put(LocationServices());
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
  @override
  void initState() {
    //subscribe
    if (isAdmin) {
      FirebaseMessaging.instance.subscribeToTopic("Admin");
    }

    // TODO: implement initState
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
    if (ownerName.text.isEmpty &&
        hallName.text.isEmpty &&
        ownerContact.text.isEmpty &&
        ownerEmail.text.isEmpty &&
        hallAddress.text.isEmpty &&
        hallCapacity.text.isEmpty &&
        pricePerHead.text.isEmpty &&
        cateringPerHead.text.isEmpty &&
        areaName.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("All Field Are Empty"),
        ),
      );
    } else if (hallName.text.isEmpty) {
      displayValidationError(context, "Hall Name");
    } else if (areaName.text.isEmpty) {
      displayValidationError(context, "Area Name");
    } else if (ownerName.text.isEmpty) {
      displayValidationError(context, "Owner Name");
    } else if (ownerContact.text.isEmpty) {
      displayValidationError(context, "Owner's Contact");
    } else if (ownerEmail.text.isEmpty) {
      displayValidationError(context, "Owner's Email");
    } else if (!regExp.hasMatch(ownerEmail.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please Try Vaild Email"),
        ),
      );
    } else if (hallAddress.text.isEmpty) {
      displayValidationError(context, "Hall Address");
    } else if (hallCapacity.text.isEmpty) {
      displayValidationError(context, "Hall Capacity");
    } else if (pricePerHead.text.isEmpty) {
      displayValidationError(context, "Price");
    } else if (cateringPerHead.text.isEmpty) {
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
        // "longitiude": longitude.value,
        // "latitude": latitude.value,
        "CateringPerHead": cateringPerHead,
        // kep for testing to fetch in place of longitude and latitude
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
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const ReusableBigText(text: "Create Hall Details"),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      // FutureBuilder(
                      //   future: locationServices.fetchLocationArea(),
                      //   builder:
                      //       (context, AsyncSnapshot<LocationModel?> snapshot) {
                      //     if (snapshot.connectionState ==
                      //             ConnectionState.done &&
                      //         snapshot.hasData &&
                      //         snapshot.data != null) {
                      //       return SizedBox(
                      //         width: 400.w,
                      //         child: Center(
                      //           child: DropdownButton<String?>(
                      //             elevation: 20,
                      //             value: AreaName,
                      //             hint: Text(
                      //               "Please Select the Location",
                      //               style:
                      //                   TextStyle(fontWeight: FontWeight.bold),
                      //             ),
                      //             items: snapshot.data!.data!.map((value) {
                      //               return DropdownMenuItem(
                      //                 value: value.id,
                      //                 child: Padding(
                      //                   padding: const EdgeInsets.symmetric(
                      //                       horizontal: 50.0),
                      //                   child: Text(
                      //                     "${value.areaName}",
                      //                     style: TextStyle(
                      //                         fontWeight: FontWeight.bold),
                      //                   ),
                      //                 ),
                      //               );
                      //             }).toList(),
                      //             onChanged: (_) {
                      //               setState(() {
                      //                 AreaName = _!;
                      //               });
                      //               print('drop down id  ${_}');
                      //             },
                      //           ),
                      //         ),
                      //       );
                      //     }

                      //     return Center(child: CircularProgressIndicator());
                      //   },
                      // ),

                      SizedBox(
                        height: height * 0.01,
                      ),
                      // FutureBuilder(
                      //   future: locationServices.getHallOwner(),
                      //   builder:
                      //       (context, AsyncSnapshot<HallOwnerModel?> snapshot) {
                      //     if (snapshot.connectionState ==
                      //             ConnectionState.done &&
                      //         snapshot.hasData &&
                      //         snapshot.data != null) {
                      //       return SizedBox(
                      //         width: 400.w,
                      //         child: Center(
                      //           child: DropdownButton<String?>(
                      //             elevation: 20,
                      //             value: UserName,
                      //             hint: Text(
                      //               "Please Select the User Name ",
                      //               style:
                      //                   TextStyle(fontWeight: FontWeight.bold),
                      //             ),
                      //             items: snapshot.data!.data!.map((value) {
                      //               return DropdownMenuItem(
                      //                 value: value.id,
                      //                 child: Padding(
                      //                   padding: const EdgeInsets.symmetric(
                      //                       horizontal: 50.0),
                      //                   child: Text(
                      //                     "${value.userName}",
                      //                     style: TextStyle(
                      //                         fontWeight: FontWeight.bold),
                      //                   ),
                      //                 ),
                      //               );
                      //             }).toList(),
                      //             onChanged: (_) {
                      //               setState(() {
                      //                 UserName = _!;
                      //               });
                      //               print('drop down id  ${_}');
                      //             },
                      //           ),
                      //         ),
                      //       );
                      //     }

                      //     return Center(child: CircularProgressIndicator());
                      //   },
                      // ),

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
                      ReusableTextField(
                        controller: areaName,
                        hintText: 'Area Name',
                        keyboardType: TextInputType.emailAddress,
                      ),
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
                        controller: ownerEmail,
                        hintText: 'Owner Email',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: ReusableTextField(
                      //         controller: hallAddress,
                      //         hintText: 'Hall Address',
                      //         keyboardType: TextInputType.text,
                      //         enabled: false,
                      //       ),
                      //     ),
                      //     const SizedBox(width: 5),
                      //     IconButton(
                      //         onPressed: () async {
                      //           // await showPlacePicker(context);
                      //           // await locationServices.determinePosition();
                      //           Get.to(() => const CustomGoogleMap());
                      //         },
                      //         icon: const Icon(Icons.location_on)),
                      //   ],
                      // ),
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
                                    child: GridView.builder(
                                        itemCount: _selectedFiles.length,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 3),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Padding(
                                            padding: const EdgeInsets.all(3.0),
                                            child: Image.file(
                                                File(
                                                    _selectedFiles[index].path),
                                                fit: BoxFit.cover),
                                          );
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
                          validation(context);
                        },
                        child: const ReusableTextIconButton(
                          text: "Submit",
                        ),
                      ),
                      SizedBox(
                        height: height * 0.15,
                      ),
                    ],
                  )),
            ),
          ),
        ),
      ),
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
    // await reference.getDownloadURL();
    // print("111 ${await reference.getDownloadURL()}");
    // img_url = await reference.getDownloadURL();

    // print('function print ${img_url}');
    // return img_url;
    return await reference.getDownloadURL();
  }
  //Finish Upload Images in Firestore Storage

//Select Image From Gallery
  Future<void> selectImage() async {
    _selectedFiles.clear();

    try {
      final List<XFile>? imgs = await _imagePicker.pickMultiImage(
          imageQuality: 50, maxWidth: 400, maxHeight: 400);
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
