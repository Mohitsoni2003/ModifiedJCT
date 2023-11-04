import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'otp.dart';

class BranchLogin extends StatefulWidget {
  const BranchLogin({super.key});
  static String verify = "";

  @override
  State<BranchLogin> createState() => _BranchLoginState();
}

class _BranchLoginState extends State<BranchLogin> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  String errorMessage = '';
  final phoneNumber = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade300,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25),
          child: Form(
            key: _key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Staff Login',
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
                SizedBox(height: screen.height * 0.025),
                TextFormField(
                  validator: validatePhone,
                  controller: phoneNumber,
                  decoration: const InputDecoration(
                    hintText: 'Enter Phone Number',
                    filled: true,
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                SizedBox(height: screen.height * 0.025),
                Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_key.currentState!.validate()) {
                        var phone = phoneNumber.text;
                        await FirebaseAuth.instance.verifyPhoneNumber(
                          phoneNumber: '+91$phone',
                          verificationCompleted:
                              (PhoneAuthCredential credential) {},
                          verificationFailed: (FirebaseAuthException e) {
                            errorMessage = '';
                            errorMessage = e.message!;
                            if (errorMessage == 'This request is missing a valid app identifier, meaning that Play Integrity checks, and reCAPTCHA checks were unsuccessful. Please try again, or check the logcat for more details.' ||
                                errorMessage ==
                                    'The format of the phone number provided is incorrect. Please enter the phone number in a format that can be parsed into E.164 format. E.164 phone numbers are written in the format [+][country code][subscriber number including area code].' ||
                                errorMessage ==
                                    'The format of the phone number provided is incorrect. Please enter the phone number in a format that can be parsed into E.164 format. E.164 phone numbers are written in the format [+][country code][subscriber number including area code]. [ TOO_SHORT ]' ||
                                errorMessage ==
                                    'The format of the phone number provided is incorrect. Please enter the phone number in a format that can be parsed into E.164 format. E.164 phone numbers are written in the format [+][country code][subscriber number including area code]. [ TOO_LONG ]' ||
                                errorMessage ==
                                    'We have blocked all requests from this device due to unusual activity. Try again later.') {
                              errorMessage =
                                  'This Phone Number do not belong to a staff member';
                            }
                            setState(() {});
                          },
                          codeSent: (String verificationId, int? resendToken) {
                            BranchLogin.verify = verificationId;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const OtpVerification(),
                              ),
                            );
                          },
                          codeAutoRetrievalTimeout: (String verificationId) {},
                        );
                        setState(() {});
                      }
                    },
                    child: const Text(
                      "Verify Phone Number",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: screen.height * 0.025),
                const Text(
                  'Only staff are allowed',
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? validatePhone(String? formPhone) {
    if (formPhone == null || formPhone.isEmpty) {
      return 'Phone Number is required';
    }
    String pattern = r'^(?=.*?[0-9]).{10,}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(formPhone)) {
      return 'Invalid Phone Number Format';
    }
    return null;
  }
}
