import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gluco_care/src/features/authentication/controllers/signup/firebase_exceptions.dart';
import 'package:gluco_care/src/features/authentication/controllers/signup/user_model.dart';

class UserRepository extends GetxController{
  static UserRepository get instance => Get.find();
  final FirebaseFirestore _db = FirebaseFirestore.instance;


  //funcion que guarda los datos del usuario en Firestore
  Future<void> saveUserRecord(UserModel user) async {
    try{
      await _db.collection("Users").doc(user.id).set(user.toJson());
    }on FirebaseException catch (e){
      throw TFirebaseException(e.code);
    }on FormatException catch (_){
      throw const TFormatException();
    }on PlatformException catch (e){
      throw TPlatformException(e.code).message;
    }catch(e){
      throw 'Algo salio mal. Porfavor vuelva a intentar';
    }
  }
}