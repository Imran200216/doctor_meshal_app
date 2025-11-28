part of 'view_submitted_form_details_section_bloc.dart';

sealed class ViewSubmittedFormDetailsSectionState extends Equatable {
  const ViewSubmittedFormDetailsSectionState();
}

final class ViewSubmittedFormDetailsSectionInitial
    extends ViewSubmittedFormDetailsSectionState {
  @override
  List<Object> get props => [];
}

final class GetViewSubmittedFormDetailsSectionLoading
    extends ViewSubmittedFormDetailsSectionState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

final class GetViewSubmittedFormDetailsSectionSuccess
    extends ViewSubmittedFormDetailsSectionState {

  final ViewPatientSubmittedFormDetailsModel formDetails;

const   GetViewSubmittedFormDetailsSectionSuccess({required this.formDetails});



  @override
  List<Object?> get props => [formDetails];
}

final class GetViewSubmittedFormDetailsSectionFailure
    extends ViewSubmittedFormDetailsSectionState {

  final String message;

  const GetViewSubmittedFormDetailsSectionFailure({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
