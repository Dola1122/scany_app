part of 'camera_cubit.dart';

@immutable
abstract class CameraState {}

class CameraInitial extends CameraState {}

class ControllerInitializedState extends CameraState {}
class TakeImageState extends CameraState {}
class RotateImageState extends CameraState {}
class ToggleSelectionState extends CameraState {}
class ProcessImageState extends CameraState {}
class FinishImageState extends CameraState {}
class AddCurrentImageSuccessState extends CameraState {}
class CameraStartFocusState extends CameraState {}
class CameraEndFocusState extends CameraState {}
class CameraChangeFlashModeState extends CameraState {}
