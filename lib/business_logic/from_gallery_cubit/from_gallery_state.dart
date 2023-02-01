part of 'from_gallery_cubit.dart';

@immutable
abstract class FromGalleryState {}

class FromGalleryInitial extends FromGalleryState {}

class RotateImageState extends FromGalleryState {}
class ToggleSelectionState extends FromGalleryState {}
class ProcessImageState extends FromGalleryState {}
class FinishImageState extends FromGalleryState {}
class AddCurrentImageSuccessState extends FromGalleryState {}
class FromGalleryRotatedState extends FromGalleryState {}
class FromGalleryImagesPickedState extends FromGalleryState {}
class ImageModelRotatedState extends FromGalleryState {}
class ToggleDetectionState extends FromGalleryState {}