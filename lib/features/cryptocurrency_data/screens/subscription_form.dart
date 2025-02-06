import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants/sizes.dart';
import '../../../utils/validators/validation.dart';
import '../controller/subscription_controller.dart';
import '../controller/subscription_form_controller.dart';

class SubscribeForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final SubscriberController subscriberController;
  final TextEditingController phoneNumberController;
  final TextEditingController emailController;
  final SubscriptionController subscriptionController;

  const SubscribeForm({
    required this.formKey,
    required this.subscriberController,
    required this.phoneNumberController,
    required this.emailController,
    required this.subscriptionController,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: phoneNumberController,
            decoration: const InputDecoration(labelText: 'Phone Number'),
            validator: (value) => TValidator.validatePhoneNumber(value),
          ),
          const SizedBox(
            height: TSizes.spaceBtwInputFields,
          ),
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            validator: (value) => TValidator.validateEmail(value),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  String uid = subscriptionController.userId;
                  String phoneNumber = phoneNumberController.text.trim();
                  String email = emailController.text.trim();
                  subscriberController.addSubscriber(uid, phoneNumber, email);
                }
              },
              child: const Text('Subscribe'),
            ),
          ),
        ],
      ),
    );
  }
}

class SubscribePage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SubscriberController _subscriberController =
      Get.put(SubscriberController());
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final SubscriptionController subscriptionController =
      SubscriptionController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: SubscribeForm(
        formKey: _formKey,
        subscriberController: _subscriberController,
        phoneNumberController: _phoneNumberController,
        emailController: _emailController,
        subscriptionController: subscriptionController,
      ),
    );
  }
}
