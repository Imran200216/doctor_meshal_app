import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'bottom_nav_state.dart';

class BottomNavCubit extends Cubit<BottomNavState> {
  BottomNavCubit() : super(const BottomNavSelected(selectedIndex: 0));

  int selectedIndex = 0;

  void selectBottomNav(int index) {
    if (state is BottomNavSelected &&
        (state as BottomNavSelected).selectedIndex == index) {
      return;
    }

    emit(BottomNavSelected(selectedIndex: index));
  }
}
