import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @selectLanguageDescription.
  ///
  /// In en, this message translates to:
  /// **'Let’s get started! Pick a language you’re most comfortable with'**
  String get selectLanguageDescription;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Get Started with our App'**
  String get loginTitle;

  /// No description provided for @loginSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to your Account'**
  String get loginSubTitle;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Your Doctor Booking Account'**
  String get registerTitle;

  /// No description provided for @registerSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Join us and schedule appointments effortlessly'**
  String get registerSubTitle;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterEmail;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @enterConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your confirm password'**
  String get enterConfirmPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @forgetPassword.
  ///
  /// In en, this message translates to:
  /// **'Forget Password?'**
  String get forgetPassword;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'Or Continue With'**
  String get orContinueWith;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @continueWithApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get continueWithApple;

  /// No description provided for @enterFirstName.
  ///
  /// In en, this message translates to:
  /// **'Enter your first name'**
  String get enterFirstName;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @enterLastName.
  ///
  /// In en, this message translates to:
  /// **'Enter your last name'**
  String get enterLastName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @enterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get enterPhoneNumber;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'home'**
  String get home;

  /// No description provided for @appointments.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get appointments;

  /// No description provided for @education.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get education;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @searchCountry.
  ///
  /// In en, this message translates to:
  /// **'Search Country'**
  String get searchCountry;

  /// No description provided for @patientCorner.
  ///
  /// In en, this message translates to:
  /// **'Patient Corner'**
  String get patientCorner;

  /// No description provided for @educationSubTopics.
  ///
  /// In en, this message translates to:
  /// **'Education Sub Topics'**
  String get educationSubTopics;

  /// No description provided for @myAccount.
  ///
  /// In en, this message translates to:
  /// **'My Account'**
  String get myAccount;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsAndConditions;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @personDetails.
  ///
  /// In en, this message translates to:
  /// **'Person Details'**
  String get personDetails;

  /// No description provided for @yourEmail.
  ///
  /// In en, this message translates to:
  /// **'Your Email'**
  String get yourEmail;

  /// No description provided for @forgetPasswordSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Don’t worry! Just enter your email and we’ll help you reset your password.'**
  String get forgetPasswordSubTitle;

  /// No description provided for @sendOTP.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOTP;

  /// No description provided for @enterVerificationCode.
  ///
  /// In en, this message translates to:
  /// **'Enter Verification Code'**
  String get enterVerificationCode;

  /// No description provided for @otpSubTitle.
  ///
  /// In en, this message translates to:
  /// **'we\'ve sent you a code to verify your email on '**
  String get otpSubTitle;

  /// No description provided for @receiveCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the code?'**
  String get receiveCode;

  /// No description provided for @tapToResend.
  ///
  /// In en, this message translates to:
  /// **'Tap to Resend'**
  String get tapToResend;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @topics.
  ///
  /// In en, this message translates to:
  /// **'Topics'**
  String get topics;

  /// No description provided for @articles.
  ///
  /// In en, this message translates to:
  /// **'Articles'**
  String get articles;

  /// No description provided for @subTopics.
  ///
  /// In en, this message translates to:
  /// **'Sub Topics'**
  String get subTopics;

  /// No description provided for @changePasswordSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter your new password below and confirm it to update your account credentials.'**
  String get changePasswordSubTitle;

  /// No description provided for @passwordChangeSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Password Updated Successfully'**
  String get passwordChangeSuccessTitle;

  /// No description provided for @passwordChangeSuccessSubTitle.
  ///
  /// In en, this message translates to:
  /// **'Your password has been updated successfully. You can now use your new password to sign in securely.'**
  String get passwordChangeSuccessSubTitle;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back To Login'**
  String get backToLogin;

  /// No description provided for @logoutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Logout Confirmation'**
  String get logoutConfirmation;

  /// No description provided for @logoutConfirmationDescription.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out of your account?'**
  String get logoutConfirmationDescription;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @selectGender.
  ///
  /// In en, this message translates to:
  /// **'Select Gender'**
  String get selectGender;

  /// No description provided for @selectBloodGroup.
  ///
  /// In en, this message translates to:
  /// **'Select Blood Group'**
  String get selectBloodGroup;

  /// No description provided for @bloodGroup.
  ///
  /// In en, this message translates to:
  /// **'Blood Group'**
  String get bloodGroup;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date Of Birth'**
  String get dateOfBirth;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select your date of birth'**
  String get selectDate;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// No description provided for @enterHeight.
  ///
  /// In en, this message translates to:
  /// **'Enter height in cm'**
  String get enterHeight;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @enterWeight.
  ///
  /// In en, this message translates to:
  /// **'Enter weight in kg'**
  String get enterWeight;

  /// No description provided for @addPersonalDetails.
  ///
  /// In en, this message translates to:
  /// **'Add Person Details'**
  String get addPersonalDetails;

  /// No description provided for @enterOldPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your old password'**
  String get enterOldPassword;

  /// No description provided for @oldPassword.
  ///
  /// In en, this message translates to:
  /// **'Old Password'**
  String get oldPassword;

  /// No description provided for @enterNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password'**
  String get enterNewPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @periOperative.
  ///
  /// In en, this message translates to:
  /// **'Peri-Operative'**
  String get periOperative;

  /// No description provided for @postOperative.
  ///
  /// In en, this message translates to:
  /// **'Post-Operative'**
  String get postOperative;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @startForm.
  ///
  /// In en, this message translates to:
  /// **'Start Form'**
  String get startForm;

  /// No description provided for @openSurvey.
  ///
  /// In en, this message translates to:
  /// **'Open Survey'**
  String get openSurvey;

  /// No description provided for @operativeForms.
  ///
  /// In en, this message translates to:
  /// **'Operative Forms'**
  String get operativeForms;

  /// No description provided for @doctorName.
  ///
  /// In en, this message translates to:
  /// **'Dr. Meshal AlHadhoud'**
  String get doctorName;

  /// No description provided for @meetOurExpert.
  ///
  /// In en, this message translates to:
  /// **'Meet Our International Expert'**
  String get meetOurExpert;

  /// No description provided for @designation.
  ///
  /// In en, this message translates to:
  /// **'Dr. Meshal Alhadhoud, MBBCh, SB-Orth, MBA, MPH Orthopaedic Consultant.'**
  String get designation;

  /// No description provided for @designationDescription.
  ///
  /// In en, this message translates to:
  /// **'Orthopedic Trauma Surgery, Reconstructive Foot & Ankle Surgery and Orthopedic Surgery Research Master of Business Administration, Master of Public Health.'**
  String get designationDescription;

  /// No description provided for @continueWord.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueWord;

  /// No description provided for @noItemsFound.
  ///
  /// In en, this message translates to:
  /// **'No Items Found'**
  String get noItemsFound;

  /// No description provided for @passwordChangeSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Password Changed Successfully'**
  String get passwordChangeSuccessful;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Login Successful'**
  String get loginSuccess;

  /// No description provided for @registerDate.
  ///
  /// In en, this message translates to:
  /// **'Register Date'**
  String get registerDate;

  /// No description provided for @enterBloodGroup.
  ///
  /// In en, this message translates to:
  /// **'Enter your blood group'**
  String get enterBloodGroup;

  /// No description provided for @enterGender.
  ///
  /// In en, this message translates to:
  /// **'Enter gender'**
  String get enterGender;

  /// No description provided for @civilId.
  ///
  /// In en, this message translates to:
  /// **'Civil Id'**
  String get civilId;

  /// No description provided for @enterCivilId.
  ///
  /// In en, this message translates to:
  /// **'Enter Civil Id'**
  String get enterCivilId;

  /// No description provided for @internetConnection.
  ///
  /// In en, this message translates to:
  /// **'No Internet Connection'**
  String get internetConnection;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @alertSurveyFormTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit?'**
  String get alertSurveyFormTitle;

  /// No description provided for @alertSurveyFormDescription.
  ///
  /// In en, this message translates to:
  /// **'Your form progress will be lost if you leave this page. Do you want to continue?'**
  String get alertSurveyFormDescription;

  /// No description provided for @languageSelected.
  ///
  /// In en, this message translates to:
  /// **'Language Selected Successfully'**
  String get languageSelected;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @typeYourMessage.
  ///
  /// In en, this message translates to:
  /// **'Type your message'**
  String get typeYourMessage;

  /// No description provided for @chats.
  ///
  /// In en, this message translates to:
  /// **'Chats'**
  String get chats;

  /// No description provided for @emailEmpty.
  ///
  /// In en, this message translates to:
  /// **'Email cannot be empty'**
  String get emailEmpty;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get emailInvalid;

  /// No description provided for @passwordEmpty.
  ///
  /// In en, this message translates to:
  /// **'Password cannot be empty'**
  String get passwordEmpty;

  /// No description provided for @firstNameEmpty.
  ///
  /// In en, this message translates to:
  /// **'First name cannot be empty'**
  String get firstNameEmpty;

  /// No description provided for @lastNameEmpty.
  ///
  /// In en, this message translates to:
  /// **'Last name cannot be empty'**
  String get lastNameEmpty;

  /// No description provided for @phoneNumberEmpty.
  ///
  /// In en, this message translates to:
  /// **'Phone number cannot be empty'**
  String get phoneNumberEmpty;

  /// No description provided for @confirmPasswordEmpty.
  ///
  /// In en, this message translates to:
  /// **'Confirm password cannot be empty'**
  String get confirmPasswordEmpty;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @doctorList.
  ///
  /// In en, this message translates to:
  /// **'Doctors List'**
  String get doctorList;

  /// No description provided for @searchDoctors.
  ///
  /// In en, this message translates to:
  /// **'Search Doctors'**
  String get searchDoctors;

  /// No description provided for @noChatsFound.
  ///
  /// In en, this message translates to:
  /// **'No Chats Found'**
  String get noChatsFound;

  /// No description provided for @noDoctorsFound.
  ///
  /// In en, this message translates to:
  /// **'No Doctors Found'**
  String get noDoctorsFound;

  /// No description provided for @codeExpiresIn.
  ///
  /// In en, this message translates to:
  /// **'Code expires in:'**
  String get codeExpiresIn;

  /// No description provided for @codeExpired.
  ///
  /// In en, this message translates to:
  /// **'Code expired'**
  String get codeExpired;

  /// No description provided for @timerIsRunning.
  ///
  /// In en, this message translates to:
  /// **'Timer is running'**
  String get timerIsRunning;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @areYouSure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure'**
  String get areYouSure;

  /// No description provided for @cancelOTPVerifyProcess.
  ///
  /// In en, this message translates to:
  /// **'You want to cancel this process'**
  String get cancelOTPVerifyProcess;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get goodEvening;

  /// No description provided for @periOperativeScore.
  ///
  /// In en, this message translates to:
  /// **'Peri Operative Score'**
  String get periOperativeScore;

  /// No description provided for @totalFormSubmit.
  ///
  /// In en, this message translates to:
  /// **'Total Form Submit'**
  String get totalFormSubmit;

  /// No description provided for @preOpSubmit.
  ///
  /// In en, this message translates to:
  /// **'Pre-op Submit'**
  String get preOpSubmit;

  /// No description provided for @postOpSubmit.
  ///
  /// In en, this message translates to:
  /// **'Post-op Submit'**
  String get postOpSubmit;

  /// No description provided for @logoutSuccess.
  ///
  /// In en, this message translates to:
  /// **'Logout Success'**
  String get logoutSuccess;

  /// No description provided for @logoutFailed.
  ///
  /// In en, this message translates to:
  /// **'Logout Failed'**
  String get logoutFailed;

  /// No description provided for @consultDoctor.
  ///
  /// In en, this message translates to:
  /// **'Consult Doctor'**
  String get consultDoctor;

  /// No description provided for @noInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your network settings.'**
  String get noInternet;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @viewForm.
  ///
  /// In en, this message translates to:
  /// **'View Form'**
  String get viewForm;

  /// No description provided for @patientName.
  ///
  /// In en, this message translates to:
  /// **'Patient Name'**
  String get patientName;

  /// No description provided for @formStatus.
  ///
  /// In en, this message translates to:
  /// **'Form Status'**
  String get formStatus;

  /// No description provided for @submittedDate.
  ///
  /// In en, this message translates to:
  /// **'Submitted Date'**
  String get submittedDate;

  /// No description provided for @profileImage.
  ///
  /// In en, this message translates to:
  /// **'Profile Image'**
  String get profileImage;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGallery;

  /// No description provided for @preOperativeSummary.
  ///
  /// In en, this message translates to:
  /// **'Pre Operative Summary'**
  String get preOperativeSummary;

  /// No description provided for @postOperativeSummary.
  ///
  /// In en, this message translates to:
  /// **'Post Operative Summary'**
  String get postOperativeSummary;

  /// No description provided for @dashboardSummary.
  ///
  /// In en, this message translates to:
  /// **'Dashboard Summary'**
  String get dashboardSummary;

  /// No description provided for @operativeSummary.
  ///
  /// In en, this message translates to:
  /// **'Operative Summary'**
  String get operativeSummary;

  /// No description provided for @formSerialNo.
  ///
  /// In en, this message translates to:
  /// **'Form Serial No'**
  String get formSerialNo;

  /// No description provided for @formTitle.
  ///
  /// In en, this message translates to:
  /// **'Form Title'**
  String get formTitle;

  /// No description provided for @formType.
  ///
  /// In en, this message translates to:
  /// **'Form Type'**
  String get formType;

  /// No description provided for @formStatusSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Form Status Submitted'**
  String get formStatusSubmitted;

  /// No description provided for @formSubmittedDate.
  ///
  /// In en, this message translates to:
  /// **'Form Submitted Date'**
  String get formSubmittedDate;

  /// No description provided for @formTotalPoints.
  ///
  /// In en, this message translates to:
  /// **'Form Total Points'**
  String get formTotalPoints;

  /// No description provided for @formCreatedAt.
  ///
  /// In en, this message translates to:
  /// **'Form Created At'**
  String get formCreatedAt;

  /// No description provided for @searchPeriOperativeForms.
  ///
  /// In en, this message translates to:
  /// **'Search Peri Operative Forms...'**
  String get searchPeriOperativeForms;

  /// No description provided for @searchPostOperativeForms.
  ///
  /// In en, this message translates to:
  /// **'Search Post Operative Forms...'**
  String get searchPostOperativeForms;

  /// No description provided for @form.
  ///
  /// In en, this message translates to:
  /// **'Form'**
  String get form;

  /// No description provided for @submittedCounts.
  ///
  /// In en, this message translates to:
  /// **'Submitted Counts'**
  String get submittedCounts;

  /// No description provided for @reSubmittedCounts.
  ///
  /// In en, this message translates to:
  /// **'ReSubmitted Counts'**
  String get reSubmittedCounts;

  /// No description provided for @reviewedCounts.
  ///
  /// In en, this message translates to:
  /// **'Reviewed Counts'**
  String get reviewedCounts;

  /// No description provided for @approvedCounts.
  ///
  /// In en, this message translates to:
  /// **'Approved Counts'**
  String get approvedCounts;

  /// No description provided for @rejectedCounts.
  ///
  /// In en, this message translates to:
  /// **'Rejected Counts'**
  String get rejectedCounts;

  /// No description provided for @totalPatient.
  ///
  /// In en, this message translates to:
  /// **'Total Patient\nCount'**
  String get totalPatient;

  /// No description provided for @totalEducationArticles.
  ///
  /// In en, this message translates to:
  /// **'Total Education Articles'**
  String get totalEducationArticles;

  /// No description provided for @patients.
  ///
  /// In en, this message translates to:
  /// **'Patients'**
  String get patients;

  /// No description provided for @patientStatus.
  ///
  /// In en, this message translates to:
  /// **'Patient Status'**
  String get patientStatus;

  /// No description provided for @doctorStatus.
  ///
  /// In en, this message translates to:
  /// **'Doctor Status'**
  String get doctorStatus;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @localization.
  ///
  /// In en, this message translates to:
  /// **'Localization'**
  String get localization;

  /// No description provided for @bio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bio;

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get services;

  /// No description provided for @doctorInfo.
  ///
  /// In en, this message translates to:
  /// **'Doctor Info'**
  String get doctorInfo;

  /// No description provided for @patientFeedbacks.
  ///
  /// In en, this message translates to:
  /// **'Patient Feedbacks'**
  String get patientFeedbacks;

  /// No description provided for @writeFeedback.
  ///
  /// In en, this message translates to:
  /// **'Write your Feedback'**
  String get writeFeedback;

  /// No description provided for @enterFeedback.
  ///
  /// In en, this message translates to:
  /// **'Enter Feedback'**
  String get enterFeedback;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @viewPatientFeedback.
  ///
  /// In en, this message translates to:
  /// **'View Patient Feedback'**
  String get viewPatientFeedback;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @traumaService1.
  ///
  /// In en, this message translates to:
  /// **'All kinds of Shoulder, Clavicle, Scapula, Humerus, Elbow, Forearm, Wrist fracture or dislocation and soft tissue trauma.'**
  String get traumaService1;

  /// No description provided for @traumaService2.
  ///
  /// In en, this message translates to:
  /// **'Acromioclavicular and Sternoclavicular joint dislocations.'**
  String get traumaService2;

  /// No description provided for @traumaService3.
  ///
  /// In en, this message translates to:
  /// **'Pelvis and acetabulum fractures.'**
  String get traumaService3;

  /// No description provided for @traumaService4.
  ///
  /// In en, this message translates to:
  /// **'All kinds of Hip, Femur, Tibia fractures or dislocation, and soft tissue trauma.'**
  String get traumaService4;

  /// No description provided for @traumaService5.
  ///
  /// In en, this message translates to:
  /// **'Ankle fracture.'**
  String get traumaService5;

  /// No description provided for @traumaService6.
  ///
  /// In en, this message translates to:
  /// **'Dislocation of bones.'**
  String get traumaService6;

  /// No description provided for @traumaService7.
  ///
  /// In en, this message translates to:
  /// **'Stress fractures.'**
  String get traumaService7;

  /// No description provided for @traumaService8.
  ///
  /// In en, this message translates to:
  /// **'Complex fractures of the upper and lower extremity.'**
  String get traumaService8;

  /// No description provided for @traumaService9.
  ///
  /// In en, this message translates to:
  /// **'Intra-articular and periarticular fractures.'**
  String get traumaService9;

  /// No description provided for @traumaService10.
  ///
  /// In en, this message translates to:
  /// **'Fracture nonunions.'**
  String get traumaService10;

  /// No description provided for @traumaService11.
  ///
  /// In en, this message translates to:
  /// **'Fracture malunions.'**
  String get traumaService11;

  /// No description provided for @traumaService12.
  ///
  /// In en, this message translates to:
  /// **'Bone infections.'**
  String get traumaService12;

  /// No description provided for @traumaService13.
  ///
  /// In en, this message translates to:
  /// **'Complex Regional Pain Syndrome.'**
  String get traumaService13;

  /// No description provided for @traumaService14.
  ///
  /// In en, this message translates to:
  /// **'Peri-prosthetic fractures of upper and lower limb.'**
  String get traumaService14;

  /// No description provided for @traumaService15.
  ///
  /// In en, this message translates to:
  /// **'Post-traumatic deformity and arthritis.'**
  String get traumaService15;

  /// No description provided for @traumaService16.
  ///
  /// In en, this message translates to:
  /// **'Minimally-invasive fracture stabilization.'**
  String get traumaService16;

  /// No description provided for @traumaService17.
  ///
  /// In en, this message translates to:
  /// **'Arthroscopically assisted fracture care.'**
  String get traumaService17;

  /// No description provided for @traumaService18.
  ///
  /// In en, this message translates to:
  /// **'Joint dislocation and ligamentous injuries.'**
  String get traumaService18;

  /// No description provided for @traumaService19.
  ///
  /// In en, this message translates to:
  /// **'Osteoporosis.'**
  String get traumaService19;

  /// No description provided for @traumaService20.
  ///
  /// In en, this message translates to:
  /// **'All kinds of geriatric fractures.'**
  String get traumaService20;

  /// No description provided for @footAnkleService1.
  ///
  /// In en, this message translates to:
  /// **'All kinds of non-operative treatment of foot and ankle pathologies.'**
  String get footAnkleService1;

  /// No description provided for @footAnkleService2.
  ///
  /// In en, this message translates to:
  /// **'All kinds of surgeries of Forefoot, Midfoot, Hindfoot, and Ankle.'**
  String get footAnkleService2;

  /// No description provided for @footAnkleService3.
  ///
  /// In en, this message translates to:
  /// **'Hallux valgus.'**
  String get footAnkleService3;

  /// No description provided for @footAnkleService4.
  ///
  /// In en, this message translates to:
  /// **'Lesser Toe deformity.'**
  String get footAnkleService4;

  /// No description provided for @footAnkleService5.
  ///
  /// In en, this message translates to:
  /// **'Keratosis Disorder.'**
  String get footAnkleService5;

  /// No description provided for @footAnkleService6.
  ///
  /// In en, this message translates to:
  /// **'Bunionette.'**
  String get footAnkleService6;

  /// No description provided for @footAnkleService7.
  ///
  /// In en, this message translates to:
  /// **'Sesamoid and accessory bone issues.'**
  String get footAnkleService7;

  /// No description provided for @footAnkleService8.
  ///
  /// In en, this message translates to:
  /// **'Disorders of foot and ankle nerves.'**
  String get footAnkleService8;

  /// No description provided for @footAnkleService9.
  ///
  /// In en, this message translates to:
  /// **'Plantar heel pain.'**
  String get footAnkleService9;

  /// No description provided for @footAnkleService10.
  ///
  /// In en, this message translates to:
  /// **'Diabetic foot and infections.'**
  String get footAnkleService10;

  /// No description provided for @footAnkleService11.
  ///
  /// In en, this message translates to:
  /// **'Charcot foot.'**
  String get footAnkleService11;

  /// No description provided for @footAnkleService12.
  ///
  /// In en, this message translates to:
  /// **'Benign foot and ankle tumors.'**
  String get footAnkleService12;

  /// No description provided for @footAnkleService13.
  ///
  /// In en, this message translates to:
  /// **'Forefoot, Midfoot, Hindfoot and Ankle arthritis.'**
  String get footAnkleService13;

  /// No description provided for @footAnkleService14.
  ///
  /// In en, this message translates to:
  /// **'Total ankle replacement.'**
  String get footAnkleService14;

  /// No description provided for @footAnkleService15.
  ///
  /// In en, this message translates to:
  /// **'Pes Cavus deformities.'**
  String get footAnkleService15;

  /// No description provided for @footAnkleService16.
  ///
  /// In en, this message translates to:
  /// **'Pes Planus deformities.'**
  String get footAnkleService16;

  /// No description provided for @footAnkleService17.
  ///
  /// In en, this message translates to:
  /// **'Congenital and acquired neurological disorders.'**
  String get footAnkleService17;

  /// No description provided for @footAnkleService18.
  ///
  /// In en, this message translates to:
  /// **'Tendon disorders.'**
  String get footAnkleService18;

  /// No description provided for @footAnkleService19.
  ///
  /// In en, this message translates to:
  /// **'Foot and ankle sports injuries.'**
  String get footAnkleService19;

  /// No description provided for @footAnkleService20.
  ///
  /// In en, this message translates to:
  /// **'Arthroscopy of foot and ankle.'**
  String get footAnkleService20;

  /// No description provided for @footAnkleService21.
  ///
  /// In en, this message translates to:
  /// **'Minimal invasive foot and ankle surgery.'**
  String get footAnkleService21;

  /// No description provided for @footAnkleService22.
  ///
  /// In en, this message translates to:
  /// **'All kinds of foot and ankle fractures and dislocations.'**
  String get footAnkleService22;

  /// No description provided for @traumaServicesTitle.
  ///
  /// In en, this message translates to:
  /// **'Trauma Services'**
  String get traumaServicesTitle;

  /// No description provided for @traumaServicesDescription.
  ///
  /// In en, this message translates to:
  /// **'All forms of fractures ranging from minor to severe, high complexity fractures, or fractures with complications.'**
  String get traumaServicesDescription;

  /// No description provided for @footAnkleServicesTitle.
  ///
  /// In en, this message translates to:
  /// **'Foot & Ankle Services'**
  String get footAnkleServicesTitle;

  /// No description provided for @footAnkleServicesDescription.
  ///
  /// In en, this message translates to:
  /// **'All forms of foot & ankle pathology ranging from minor to severe, high complex cases, or cases with complications.'**
  String get footAnkleServicesDescription;

  /// No description provided for @notificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notificationTitle;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @meshalApp.
  ///
  /// In en, this message translates to:
  /// **'Dr. Meshal App'**
  String get meshalApp;

  /// No description provided for @doctorBioName.
  ///
  /// In en, this message translates to:
  /// **'Dr. Meshal Ahmad Alhadhoud MBBCh, SB-Orth, MBA, MPH'**
  String get doctorBioName;

  /// No description provided for @specialization.
  ///
  /// In en, this message translates to:
  /// **'Orthopaedic Consultant\nOrthopedic Trauma Surgery, Reconstructive Foot & Ankle Surgery, and Orthopaedic Surgery Research'**
  String get specialization;

  /// No description provided for @academicCertificate1.
  ///
  /// In en, this message translates to:
  /// **'Master of Public Health (MPH), Walden University, Minneapolis, Minnesota, United States of America.'**
  String get academicCertificate1;

  /// No description provided for @academicCertificate2.
  ///
  /// In en, this message translates to:
  /// **'Master of Business Administration International Healthcare Management (IHM-MBA), Frankfurt School of Finance and Management.'**
  String get academicCertificate2;

  /// No description provided for @academicCertificate3.
  ///
  /// In en, this message translates to:
  /// **'Orthopedic Foot & Ankle Reconstructive Clinical Research Fellowship, Queen Elizabeth II Hospital, Dalhousie University, Halifax, Canada.'**
  String get academicCertificate3;

  /// No description provided for @academicCertificate4.
  ///
  /// In en, this message translates to:
  /// **'Orthopedic Foot & Ankle Reconstructive Surgery Fellowship, Queen Elizabeth II Hospital, Dalhousie University, Halifax, Canada.'**
  String get academicCertificate4;

  /// No description provided for @academicCertificate5.
  ///
  /// In en, this message translates to:
  /// **'Orthopedic Trauma Surgery Fellowship, King Abdelaziz Medical City, National Guard Hospital, King Saud bin Abdelaziz University for Health Sciences, Riyadh, Saudi Arabia.'**
  String get academicCertificate5;

  /// No description provided for @academicCertificate6.
  ///
  /// In en, this message translates to:
  /// **'Orthopedic Surgery Residency, Saudi Commission for Health Specialties, King Abdelaziz Medical City, National Guard Hospital, Riyadh, Saudi Arabia.'**
  String get academicCertificate6;

  /// No description provided for @academicCertificate7.
  ///
  /// In en, this message translates to:
  /// **'Bachelor of Medicine and Bachelor of Surgery, Cairo University Faculty of Medicine, Cairo, Egypt.'**
  String get academicCertificate7;

  /// No description provided for @cvHighlight1.
  ///
  /// In en, this message translates to:
  /// **'Evidence-Based Medicine Committee Member in American Orthopedic Foot and Ankle Society (AOFAS).'**
  String get cvHighlight1;

  /// No description provided for @cvHighlight2.
  ///
  /// In en, this message translates to:
  /// **'AO Trauma Faculty Member.'**
  String get cvHighlight2;

  /// No description provided for @cvHighlight3.
  ///
  /// In en, this message translates to:
  /// **'AOPEER Clinical Research Faculty Member.'**
  String get cvHighlight3;

  /// No description provided for @cvHighlight4.
  ///
  /// In en, this message translates to:
  /// **'International OTA Committee Member.'**
  String get cvHighlight4;

  /// No description provided for @cvHighlight5.
  ///
  /// In en, this message translates to:
  /// **'IBRA International Bone Research Association Faculty.'**
  String get cvHighlight5;

  /// No description provided for @cvHighlight6.
  ///
  /// In en, this message translates to:
  /// **'American Orthopedic Foot & Ankle (AOFAS) International Speaker Bureau.'**
  String get cvHighlight6;

  /// No description provided for @cvHighlight7.
  ///
  /// In en, this message translates to:
  /// **'30+ International guest lectures across USA, UK, Switzerland, Germany, Saudi Arabia, Dubai, Egypt, and Italy.'**
  String get cvHighlight7;

  /// No description provided for @cvHighlight8.
  ///
  /// In en, this message translates to:
  /// **'20 peer-reviewed paper publications.'**
  String get cvHighlight8;

  /// No description provided for @cvHighlight9.
  ///
  /// In en, this message translates to:
  /// **'2 textbook chapters.'**
  String get cvHighlight9;

  /// No description provided for @academicCertificateTitle.
  ///
  /// In en, this message translates to:
  /// **'Academic Certificate & Training'**
  String get academicCertificateTitle;

  /// No description provided for @cvHighlightsTitle.
  ///
  /// In en, this message translates to:
  /// **'CV Highlights'**
  String get cvHighlightsTitle;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
