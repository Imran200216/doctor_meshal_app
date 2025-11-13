import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'operative_selected_chip_state.dart';

class OperativeSelectedChipCubit extends Cubit<OperativeSelectedChipState> {
  OperativeSelectedChipCubit() : super(OperativeSelectedChipInitial());

  String? selectedChip;

  void selectOperativeChips(String selectedChip) {
    this.selectedChip = selectedChip;
    emit(OperativeSelectedChip(selectedChip: selectedChip));
  }
}
