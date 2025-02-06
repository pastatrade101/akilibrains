import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';



import '../../../features/authentication/login/screens/login.dart';
import '../../../features/authentication/onboarding/onboarding.dart';
import '../../../features/authentication/signup/screens/verify_email.dart';
import '../../../home_menu.dart';
import '../../../utils/local_storage/storage_utility.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

//   variable
  final deviceStorage = GetStorage();
  late final Rx<User?> _firebaseUser;
  final _auth = FirebaseAuth.instance;
  // Get authenticated user data
  User? get authUser => _auth.currentUser;


  /// Getters
  User? get firebaseUser => _firebaseUser.value;

  String get getUserID => _firebaseUser.value?.uid ?? "";

  String get getUserEmail => _firebaseUser.value?.email ?? "";

  String get getDisplayName => _firebaseUser.value?.displayName ?? "";

  String get getPhoneNo => _firebaseUser.value?.phoneNumber ?? "";
  // called from the main,dart when app launch
  @override
  void onReady() {
    _firebaseUser = Rx<User?>(_auth.currentUser);
    _firebaseUser.bindStream(_auth.userChanges());
    FlutterNativeSplash.remove();
    screenRedirect(_firebaseUser.value);
  }

  // Function to show a relevant screen
  screenRedirect(User? user) async {
    final user = _auth.currentUser;
    if (user != null) {
      if (user.emailVerified) {
        await TLocalStorage.init(user.uid);
        Get.offAll(() => const HomeMenu());
      } else {
        Get.offAll(() => VerifyEmailScreen(
              email: _auth.currentUser?.email,
            ));
      }
    } else {
      deviceStorage.writeIfNull('isFirstTime', true);
      deviceStorage.read('isFirstTime') != true
          ? Get.offAll(() => const LoginScreen())
          : Get.offAll(() => const OnBoardingScreen());
    }

//   Local storage
  }

  // [EmailAuthentication] Register

  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (e) {
      throw TFormatException().message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong please try again';
    }
  }

  // [EmailAuthentication] Login
  Future<UserCredential> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw TFormatException().message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong please try again';
    }
  }

  //   [Google Authentication] - Google-login

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // trigger the authentication flow
      final GoogleSignInAccount? userAccount = await GoogleSignIn().signIn();
      // Obtain oath details from the request

      final GoogleSignInAuthentication? googleAuth =
          await userAccount?.authentication;

      //   Create a new credential
      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

      //    Once sign in, return userCredential
      return await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw TFormatException().message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      if (kDebugMode) print('Something went wrong! $e');
      return null;
    }
  }

//   [Email Verification] - Mail Verification
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong, please try again!';
    }
  }

//Logout User
  Future<void> logOut() async {
    try {
      await GoogleSignIn().signOut();

      await FirebaseAuth.instance.signOut();
      Get.offAll(() => const LoginScreen());
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong, please try again!';
    }
  } // [Email Authentication] Forget password

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);

    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong, please try again!';
    }
  }
}

class TFirebaseException implements Exception {
  final String message;

  TFirebaseException(this.message);
}

class TFirebaseAuthException implements Exception {
  final String code;

// Constructor that take error code
  TFirebaseAuthException(this.code);

  String get message {
    switch (code) {
      case 'email-already-in-use':
        throw 'The email address is already registered. Please use a different email';
      case 'invalid-email':
        throw 'The email provided is invalid. Please enter a valid email';
      case 'weak-password':
        throw 'The password is too weak. Please choose a strong password';
      case 'user-disabled':
        throw 'This user account has been disabled. Please contact support for assistance';
      case 'user-not-found':
        throw 'Invalid login details. User not found';
      case 'wrong-password':
        throw 'Incorrect password. Please check your password and try again';
      case 'invalid-verification-code':
        throw 'Invalid code. Please enter a valid code';
      case 'invalid-verification-id':
        throw 'Invalid ID. Please request a new verification code ID';
      case 'quota-exceeded':
        throw 'Quota exceeded. Please try again later';
      case 'email-already-exists':
        throw 'Email address already exists. Please use a different email';
      case 'provider-already-linked':
        throw 'The account is already linked with another provider';

      case 'invalid-credential':
        return 'Invalid login details. Please check your password and try again';

      default:
        throw 'An unexpected Firebase error occurred!';
    }
  }
}

class TFormatException implements Exception {
  final String message;

  TFormatException({this.message = 'Invalid format'});

  @override
  String toString() => message;
}

class TPlatformException implements Exception {
  final String message;

  TPlatformException(this.message);
}
