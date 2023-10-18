import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:google_maps_webservice/places.dart';

import '../../models/user.dart';


const googleMapsAPIKey =
    String.fromEnvironment('AIzaSyB0mM2GzFzyEynGun8ez0IKFvrStuYjOu0', defaultValue: "AIzaSyB0mM2GzFzyEynGun8ez0IKFvrStuYjOu0");

const countryPref = "countryPref";
const loggedInPref = "loggedIn";
const authPref = "id";
FirebaseFirestore firebaseFiretore = FirebaseFirestore.instance;
FirebaseAuth auth = FirebaseAuth.instance;
FirebaseMessaging fcm = FirebaseMessaging.instance;
GoogleMapsPlaces places = GoogleMapsPlaces(apiKey: googleMapsAPIKey);

final navigatorKey = GlobalKey<NavigatorState>();
// const showPref = "SHOW_STATUS";
const requestIdPref = "REQUEST_ID";
const driverIdPref = "DRIVER_ID";
const STORAGE_ROOT = 'users';
