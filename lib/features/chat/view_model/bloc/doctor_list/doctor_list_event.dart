part of 'doctor_list_bloc.dart';

sealed class DoctorListEvent extends Equatable {
  const DoctorListEvent();
}

class GetDoctorListEvent extends DoctorListEvent {
  final String userId;

  const GetDoctorListEvent({required this.userId});

  @override
  // TODO: implement props
  List<Object?> get props => [userId];
}

class SearchDoctorListEvent extends DoctorListEvent {
  final String search;
  final String userId;

  const SearchDoctorListEvent({required this.search, required this.userId});

  @override
  // TODO: implement props
  List<Object?> get props => [search, userId];
}
