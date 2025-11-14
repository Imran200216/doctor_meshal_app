part of 'bottom_nav_cubit.dart';

sealed class BottomNavState extends Equatable {
  const BottomNavState();
}

final class BottomNavInitial extends BottomNavState {
  @override
  List<Object> get props => [];
}

final class BottomNavSelected extends BottomNavState {

  final int selectedIndex;

  const BottomNavSelected({required this.selectedIndex});

  @override
  // TODO: implement props
  List<Object?> get props => [selectedIndex];

}