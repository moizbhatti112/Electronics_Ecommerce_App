import 'package:cloud_firestore/cloud_firestore.dart';


class Database {
  Future adduserdetails(Map<String, dynamic> userinfomap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc()
        .set(userinfomap);
  }
}
