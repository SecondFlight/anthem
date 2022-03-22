part of 'pattern_picker_cubit.dart';

@immutable
class PatternPickerState {
  final List<PatternModel> patterns;

  const PatternPickerState({required this.patterns});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PatternPickerState && other.patterns == patterns;

  @override
  int get hashCode => patterns.hashCode;

  PatternPickerState copyWith({List<PatternModel>? patterns}) {
    return PatternPickerState(patterns: patterns ?? this.patterns);
  }
}
