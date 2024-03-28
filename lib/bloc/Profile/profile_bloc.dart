import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import 'package:shared_preferences/shared_preferences.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  late String nameValue;
  late String emailValue;
  String imageURL = '';
  final picker = ImagePicker();
  ProfileBloc() : super(ProfileInitialState()) {
   getSharedPrefranceValue().then((value) {
     _loadUserProfile();
   });

    on<GetImageFromGalleryEvent>(_getImageFromGallery);
    on<GetImageFromCamaraEvent>(_getImageFromCamera);
  }
  Future<void> _loadUserProfile() async {
    try {
      var sharedPreferences = await SharedPreferences.getInstance();
      var userId = sharedPreferences.getString('uuId');

      await FirebaseStorage.instance.ref().child(userId.toString()).getDownloadURL().then((imageUrl) {
        // ignore: invalid_use_of_visible_for_testing_member
        emit(ProfileLoadedState(imageURL: imageUrl, nameValue: nameValue, emailValue: emailValue));
      });
    } catch (e) {
      // ignore: invalid_use_of_visible_for_testing_member
      emit(ProfileLoadedState(imageURL: '', nameValue: nameValue, emailValue: emailValue));
    }
  }

  Future<void> _getImageFromGallery(GetImageFromGalleryEvent event, Emitter<ProfileState> emit) async {
    try {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      var userId = sharedPreferences.getString('uuId');
      final pickedImage = await picker.pickImage(source: ImageSource.gallery, imageQuality: 100);

      if (pickedImage != null) {
        await firebaseStorage.ref().child(userId.toString()).putFile(File(pickedImage.path)).then((p0) async {
          await firebaseStorage.ref().child(userId.toString()).getDownloadURL().then((imageUrl) async {
            await FirebaseFirestore.instance.collection('user').doc(userId).set({'imageURL': imageUrl}, SetOptions(merge: true)).then((value) {
              emit(ProfileLoadedState(imageURL: imageUrl, nameValue: nameValue, emailValue: emailValue));
            });
          });
        });
      } else {
        emit(ProfileLoadedState(imageURL: '', emailValue: emailValue, nameValue: nameValue));
      }
    } catch (e) {
      emit(ProfileErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> _getImageFromCamera(GetImageFromCamaraEvent event, Emitter<ProfileState> emit) async {
    try {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      var userId = sharedPreferences.getString('uuId');
      final pickedImage = await picker.pickImage(source: ImageSource.camera, imageQuality: 100);

      if (pickedImage != null) {
        await firebaseStorage.ref().child(userId.toString()).putFile(File(pickedImage.path)).then((p0) async {
          await firebaseStorage.ref().child(userId.toString()).getDownloadURL().then((imageUrl) async {
            await FirebaseFirestore.instance.collection('user').doc(userId).set({'imageURL': imageUrl}, SetOptions(merge: true)).then((value) {
              emit(ProfileLoadedState(imageURL: imageUrl, nameValue: nameValue, emailValue: emailValue));
            });
          });
        });
      } else {
        emit(ProfileLoadedState(imageURL: '', emailValue: emailValue, nameValue: nameValue));
      }
    } catch (e) {
      emit(ProfileErrorState(errorMessage: e.toString()));
    }
  }

  Future<void> getSharedPrefranceValue() async {
    var sharedprefrance = await SharedPreferences.getInstance();
    var getUsername = sharedprefrance.getString('name');
    var getUserEmail = sharedprefrance.getString('email');
    nameValue = getUsername ?? 'No user found';
    emailValue = getUserEmail ?? 'No user found';
  }
}
