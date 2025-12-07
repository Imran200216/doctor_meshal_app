import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meshal_doctor_booking_app/commons/widgets/widgets.dart';
import 'package:meshal_doctor_booking_app/core/bloc/connectivity/connectivity_bloc.dart';
import 'package:meshal_doctor_booking_app/core/constants/constants.dart';
import 'package:meshal_doctor_booking_app/core/utils/utils.dart';
import 'package:meshal_doctor_booking_app/features/feedback/feedback.dart';
import 'package:meshal_doctor_booking_app/l10n/app_localizations.dart';
import 'package:meshal_doctor_booking_app/core/service/service.dart';
import 'package:meshal_doctor_booking_app/features/auth/auth.dart';

class WriteFeedbackScreen extends StatefulWidget {
  const WriteFeedbackScreen({super.key});

  @override
  State<WriteFeedbackScreen> createState() => _WriteFeedbackScreenState();
}

class _WriteFeedbackScreenState extends State<WriteFeedbackScreen> {
  // Form Key
  final _formKey = GlobalKey<FormState>();

  // UserId
  String? userId;

  // Controllers
  final TextEditingController _feedbackController = TextEditingController();

  @override
  void initState() {
    _fetchUserId();
    super.initState();
  }

  // Fetch User Id
  Future<void> _fetchUserId() async {
    try {
      // Fetch stored userAuthData
      final storedUserMapRaw = await HiveService.getData(
        boxName: AppDBConstants.userBox,
        key: AppDBConstants.userAuthData,
      );

      if (storedUserMapRaw != null) {
        // Safely convert dynamic map → Map<String, dynamic>
        final storedUserMap = Map<String, dynamic>.from(storedUserMapRaw);

        // Convert Map → UserAuthModel
        final storedUser = UserAuthModel.fromJson(storedUserMap);
        setState(() {
          userId = storedUser.id;
        });

        AppLoggerHelper.logInfo("User ID from userAuthData: $userId");
      } else {
        AppLoggerHelper.logError("No user data found in Hive");
      }
    } catch (e, stackTrace) {
      AppLoggerHelper.logError("Error fetching user ID: $e");
      AppLoggerHelper.logError("Stack trace: $stackTrace");
    }
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // App Localization
    final appLoc = AppLocalizations.of(context)!;

    // Responsive
    final isTablet = Responsive.isTablet(context);
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      appBar: KAppBar(
        title: appLoc.writeFeedback,
        onBack: () => GoRouter.of(context).pop(),
        backgroundColor: AppColorConstants.primaryColor,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile
                ? 20
                : isTablet
                ? 30
                : 40,
            vertical: isMobile
                ? 20
                : isTablet
                ? 30
                : 40,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 50,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Feedback Controller
                KTextFormField(
                  maxLength: 100,
                  controller: _feedbackController,
                  hintText: appLoc.enterFeedback,
                  labelText: appLoc.feedback,
                  maxLines: 8,
                  keyboardType: TextInputType.multiline,
                  autofillHints: [AutofillHints.email],
                  validator: (value) =>
                      AppValidators.empty(context, value, appLoc.enterFeedback),
                ),

                // Submit
                BlocListener<DoctorFeedbackBloc, DoctorFeedbackState>(
                  listener: (context, state) {
                    if (state is WriteDoctorFeedbackSuccess) {
                      // Success Snack bar
                      KSnackBar.success(context, "Feedback has been sent");

                      // Pop Back
                      GoRouter.of(context).pop();

                      // Clear Controller
                      _feedbackController.clear();
                    } else if (state is WriteDoctorFeedbackFailure) {
                      KSnackBar.error(context, state.message);
                    }
                  },
                  child: BlocBuilder<DoctorFeedbackBloc, DoctorFeedbackState>(
                    builder: (context, state) {
                      return KFilledBtn(
                        isLoading: state is WriteDoctorFeedbackLoading,
                        btnTitle: appLoc.submit,
                        btnBgColor: AppColorConstants.primaryColor,
                        btnTitleColor: AppColorConstants.secondaryColor,
                        onTap: () {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }

                          final connectivityState = context
                              .read<ConnectivityBloc>()
                              .state;

                          final rootContext = GoRouter.of(
                            context,
                          ).routerDelegate.navigatorKey.currentContext!;

                          if (connectivityState is ConnectivityFailure ||
                              (connectivityState is ConnectivitySuccess &&
                                  connectivityState.isConnected == false)) {
                            KSnackBar.error(rootContext, appLoc.noInternet);
                            return;
                          }

                          // Write Doctor Feedback Event
                          context.read<DoctorFeedbackBloc>().add(
                            WriteDoctorFeedbackEvent(
                              userId: userId!,
                              feedBack: _feedbackController.text,
                            ),
                          );
                        },
                        borderRadius: 12,
                        fontSize: isMobile
                            ? 16
                            : isTablet
                            ? 18
                            : 20,
                        btnHeight: isMobile
                            ? 50
                            : isTablet
                            ? 52
                            : 54,
                        btnWidth: double.maxFinite,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
