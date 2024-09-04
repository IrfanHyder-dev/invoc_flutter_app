import 'package:get/get.dart';
import 'package:invoc/src/language/language_keys.dart';
import 'package:invoc/v3/auth/app/sign_in/validator.dart';
import 'package:invoc/v3/auth/services/auth_service.dart';
import 'package:flutter/foundation.dart';

enum EmailPasswordSignInFormType { signIn, register, forgotPassword }

class EmailPasswordSignInModel with EmailAndPasswordValidators, ChangeNotifier {
  EmailPasswordSignInModel({
    required this.auth,
    this.email = '',
    this.password = '',
    this.formType = EmailPasswordSignInFormType.signIn,
    this.isLoading = false,
    this.submitted = false,
  });

  final AuthService auth;

  String email;
  String password;
  EmailPasswordSignInFormType formType;
  bool isLoading;
  bool submitted;

  Future<bool> submit() async {
    try {
      updateWith(submitted: true);
      if (!canSubmit) {
        return false;
      }
      updateWith(isLoading: true);
      switch (formType) {
        case EmailPasswordSignInFormType.signIn:
          await auth.signInWithEmailAndPassword(email, password);
          break;
        case EmailPasswordSignInFormType.register:
          await auth.createUserWithEmailAndPassword(email, password);
          break;
        case EmailPasswordSignInFormType.forgotPassword:
          await auth.sendPasswordResetEmail(email);
          updateWith(isLoading: false, submitted: null);
          break;
      }
      return true;
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePassword(String password) => updateWith(password: password);

  void updateFormType(EmailPasswordSignInFormType formType) {
    updateWith(
      email: '',
      password: '',
      formType: formType,
      isLoading: false,
      submitted: false,
    );
  }

  void updateWith({
    String? email,
    String? password,
    EmailPasswordSignInFormType? formType,
   bool? isLoading,
     bool? submitted,
  }) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }

  String get passwordLabelText {
    if (formType == EmailPasswordSignInFormType.register) {
      return password8CharactersLabelKey.tr;
    }
    return passwordLabelKey.tr;
  }

  // Getters
  String? get primaryButtonText {
    return <EmailPasswordSignInFormType, String>{
      EmailPasswordSignInFormType.register: createAnAccountKey.tr,
      EmailPasswordSignInFormType.signIn: signInKey.tr,
      EmailPasswordSignInFormType.forgotPassword: sendResetLinkKey.tr,
    }[formType];
  }

  String? get secondaryButtonText {
    return <EmailPasswordSignInFormType, String>{
      EmailPasswordSignInFormType.register: haveAnAccountKey.tr,
      EmailPasswordSignInFormType.signIn: needAnAccountKey.tr,
      EmailPasswordSignInFormType.forgotPassword: backToSignInKey.tr,
    }[formType];
  }

  EmailPasswordSignInFormType? get secondaryActionFormType {
    return <EmailPasswordSignInFormType, EmailPasswordSignInFormType>{
      EmailPasswordSignInFormType.register: EmailPasswordSignInFormType.signIn,
      EmailPasswordSignInFormType.signIn: EmailPasswordSignInFormType.register,
      EmailPasswordSignInFormType.forgotPassword:
          EmailPasswordSignInFormType.signIn,
    }[formType];
  }

  String? get errorAlertTitle {
    return <EmailPasswordSignInFormType, String>{
      EmailPasswordSignInFormType.register: registrationFailedKey.tr,
      EmailPasswordSignInFormType.signIn: signInFailedKey.tr,
      EmailPasswordSignInFormType.forgotPassword: passwordResetFailedKey.tr,
    }[formType];
  }

  String? get title {
    return <EmailPasswordSignInFormType, String>{
      EmailPasswordSignInFormType.register: registerKey.tr,
      EmailPasswordSignInFormType.signIn: signInKey.tr,
      EmailPasswordSignInFormType.forgotPassword: forgotPasswordKey.tr,
    }[formType];
  }

  bool get canSubmitEmail {
    return emailSubmitValidator.isValid(email);
  }

  bool get canSubmitPassword {
    if (formType == EmailPasswordSignInFormType.register) {
      return passwordRegisterSubmitValidator.isValid(password);
    }
    return passwordSignInSubmitValidator.isValid(password);
  }

  bool get canSubmit {
    final bool canSubmitFields =
        formType == EmailPasswordSignInFormType.forgotPassword
            ? canSubmitEmail
            : canSubmitEmail && canSubmitPassword;
    return canSubmitFields && !isLoading;
  }

  String? get emailErrorText {
    final bool showErrorText = submitted && !canSubmitEmail;
    final String errorText =
        email.isEmpty ? invalidEmailEmptyKey.tr : invalidEmailErrorTextKey.tr;
    return showErrorText ? errorText : null;
  }

  String? get passwordErrorText {
    final bool showErrorText = submitted && !canSubmitPassword;
    final String errorText = password.isEmpty
        ? invalidPasswordEmptyKey.tr
        : invalidPasswordTooShortKey.tr;
    return showErrorText ? errorText : null;
  }

  @override
  String toString() {
    return 'email: $email, password: $password, formType: $formType, isLoading: $isLoading, submitted: $submitted';
  }
}
