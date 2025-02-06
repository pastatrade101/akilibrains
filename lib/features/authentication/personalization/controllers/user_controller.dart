import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';


import '../../../../data/repositories/user/user_repository.dart';

import '../../../../utils/loader/loader.dart';
import '../../../library/models/user_model.dart';

class UserController extends GetxController {
  Rx<UserModel> user = UserModel.empty().obs;
  final profileLoading = false.obs;
  final imageUploading = false.obs;
  final profileImageUrl = ''.obs;

  static UserController get instance => Get.find();
  final userRepository = Get.put(
    UserRepository(),
  );

  @override
  void onInit() {
    fetchUserRecord();
    super.onInit();
  }

  Future<void> fetchUserRecord() async {
    try {
      profileLoading.value = true;
      final user = await userRepository.fetchUserDetails();
      this.user(user);
    } catch (e) {
      user(UserModel.empty());
    } finally {
      profileLoading.value = false;
    }
  }

  Future<void> saveUserRecord({UserModel? user, UserCredential? userCredentials}) async {
    try {
      // First UPDATE Rx User and then check if user data is already stored. If not store new data
      await fetchUserRecord();

      // If no record already stored.
      if (this.user.value.id.isEmpty) {
        if (userCredentials != null) {
          // Convert Name to First and Last Name
          final nameParts = UserModel.nameParts(userCredentials.user!.displayName ?? '');
          final customUsername = UserModel.generateUserName(userCredentials.user!.displayName ?? '');

          // Map data
          final newUser = UserModel(
            id: userCredentials.user!.uid,
            firstName: nameParts[0],
            lastName: nameParts.length > 1 ? nameParts.sublist(1).join(' ') : "",
            userName: customUsername,
            email: userCredentials.user!.email ?? '',
            phoneNumber: userCredentials.user!.phoneNumber ?? '',
            profilePicture: userCredentials.user!.photoURL ?? '',
          );

          // Save user data
          await userRepository.saveUserRecord(newUser);

          // Assign new user to the RxUser so that we can use it through out the app.
          this.user(newUser);
        } else if (user != null) {
          // Save Model when user registers using Email and Password
          await userRepository.saveUserRecord(user);

          // Assign new user to the RxUser so that we can use it through out the app.
          this.user(user);
        }
      }
    } catch (e) {
      TLoaders.warningSnackBar(
        title: 'Data not saved',
        message: 'Something went wrong while saving your information. You can re-save your data in your Profile.',
      );
    }
  }

  uploadProfilePicture()async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 70, maxHeight: 512, maxWidth: 512);
      if (image != null) {
        imageUploading.value = true;
        final uploadedImage = await userRepository.uploadImage('Users/Images/Profile/', image);
        profileImageUrl.value = uploadedImage;
        Map<String, dynamic> newImage = {'ProfilePicture': uploadedImage};
        await userRepository.updateSingleField(newImage);
        user.value.profilePicture = uploadedImage;
        user.refresh();

        imageUploading.value = false;
        TLoaders.successSnackBar(title: 'Congratulations', message: 'Your Profile Image has been updated!');
      }
    } catch (e) {
      imageUploading.value = false;
      TLoaders.errorSnackBar(title: 'OhSnap', message: 'Something went wrong: $e');
    }
  }
}
