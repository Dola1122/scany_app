part of 'form_camera_cubit.dart';

@immutable
abstract class FromCameraState {}

class CameraInitial extends FromCameraState {}

class ControllerInitializedState extends FromCameraState {}
class TakeImageState extends FromCameraState {}
class RotateImageState extends FromCameraState {}
class ToggleSelectionState extends FromCameraState {}
class ProcessImageState extends FromCameraState {}
class FinishImageState extends FromCameraState {}
class AddCurrentImageSuccessState extends FromCameraState {}
class CameraStartFocusState extends FromCameraState {}
class CameraEndFocusState extends FromCameraState {}
class CameraChangeFlashModeState extends FromCameraState {}
class CameraRotatedState extends FromCameraState {}
class ImageModelRotatedState extends FromCameraState {}
class ToggleDetectionState extends FromCameraState {}
