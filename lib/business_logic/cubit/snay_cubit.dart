import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'snay_state.dart';

class SnayCubit extends Cubit<SnayState> {
  SnayCubit() : super(SnayInitial());
}
