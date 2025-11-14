part of 'operative_selected_chip_cubit.dart';

sealed class OperativeSelectedChipState extends Equatable {
  const OperativeSelectedChipState();
}

final class OperativeSelectedChipInitial extends OperativeSelectedChipState {
  @override
  List<Object> get props => [];
}

final class OperativeSelectedChip extends OperativeSelectedChipState {
  final String selectedChip;

  const OperativeSelectedChip({required this.selectedChip});

  @override
  List<Object> get props => [selectedChip];
}
