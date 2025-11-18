part of 'doctor_list_bloc.dart';

sealed class DoctorListState extends Equatable {
  const DoctorListState();
}

final class DoctorListInitial extends DoctorListState {
  @override
  List<Object> get props => [];
}

// Get Doctor List Loading
class GetDoctorListLoading extends DoctorListState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

// Get Doctor List Success
class GetDoctorListSuccess extends DoctorListState {
  final List<DoctorModel> doctorList;

  const GetDoctorListSuccess({required this.doctorList});

  @override
  // TODO: implement props
  List<Object?> get props => [doctorList];
}

// Get Doctor List Failure
class GetDoctorListFailure extends DoctorListState {
  final String message;

  const GetDoctorListFailure({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

// Search Doctor List Loading
class SearchDoctorListLoading extends DoctorListState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

// Search Doctor List Success
class SearchDoctorListSuccess extends DoctorListState {
  final List<DoctorModel> doctorList;

  const SearchDoctorListSuccess({required this.doctorList});

  @override
  // TODO: implement props
  List<Object?> get props => [doctorList];
}

// Search Doctor List Failure
class SearchDoctorListFailure extends DoctorListState {
  final String message;

  const SearchDoctorListFailure({required this.message});

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}
