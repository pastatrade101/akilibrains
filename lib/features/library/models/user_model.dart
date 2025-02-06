import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../utils/formatters/formatter.dart';


class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String userName;
  final String email;
  final String phoneNumber;
  String profilePicture;
  final bool? isSubscribed;



  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.profilePicture,
    this.isSubscribed, // Initialize the list in the constructor
  });

  // Helper function to get the full name
  String get fullName => '$firstName $lastName';

  //  Helper function to format phone number
  String get formatedPhoneNo => TFormatter.formatPhoneNumber(phoneNumber);

  // Static function to split full name into first name and last name
  static List<String> nameParts(fullName) => fullName.split(' ');

//   Static function to generate a username from full name
  static String generateUserName(fullName) {
    List<String> nameParts = fullName.split(' ');
    String firstName = nameParts[0].toLowerCase();
    String lastName = nameParts.length > 1 ? nameParts[1].toLowerCase() : '';
    String camelCaseUserName = '$firstName$lastName';
    String useNameWithPrefix = '$camelCaseUserName';
    return useNameWithPrefix;
  }

// Static function to create empty user model

  static UserModel empty() =>
      UserModel(
          id: '',
          firstName: '',
          lastName: '',
          userName: '',
          email: '',
          phoneNumber: '',
          profilePicture: '',
         );


  //Convert model to JSON structure for sorting data in Firebase
//Convert model to JSON structure for sorting data in Firebase
  Map<String, dynamic> toJson() {

    return {
      'FirstName': firstName,
      'LastName': lastName,
      'UserName': userName,
      'Email': email,
      'PhoneNumber': phoneNumber,
      'ProfilePicture': profilePicture,

    };
  }

  factory UserModel.fromSnapShot(
      DocumentSnapshot<Map<String, dynamic>> document){

    if (document.data() != null) {
      final data = document.data()!;
      return UserModel(id: document.id,
          firstName: data['FirstName'??''],
          lastName: data['LastName'??''],
          userName: data['UserName'??''],
          email: data['Email'??''],
          phoneNumber: data['PhoneNumber'??''],
          profilePicture: data['ProfilePicture'??''],

      );
    }else {
      return UserModel.empty();
    }
  }



}


