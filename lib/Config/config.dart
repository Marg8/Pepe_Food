import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:shared_preferences/shared_preferences.dart';

class EcommerceApp
{
   static const String appName = '';

   static SharedPreferences sharedPreferences;
   static User user;
   static FirebaseAuth auth;
   static FirebaseFirestore firestore ;

   static String collectionUser = "users";
   static String collectionOrders = "orders";
   static String userCartList = 'userCart';
   static String userCartList2 = 'userCart2';
   static String userCartListID = 'userCartID';
   static String subCollectionAddress = 'userAddress';
   static String subCollectionItemColor = 'colorItems';

   static final String userName = 'name';
   static final String userEmail = 'email';
   static final String userPhotoUrl = 'photoUrl';
   static final String userUID = 'uid';
   static final String userAvatarUrl = 'url';

   static final String addressID = 'addressID';
   static final String totalAmount = 'totalAmount';
   static final String productID = 'productIDs';
   static final String paymentDetails ='paymentDetails';
   static final String orderTime ='orderTime';
   static final String isSuccess ='isSuccess';
   static final String qtyItems ='qtyItems';

}