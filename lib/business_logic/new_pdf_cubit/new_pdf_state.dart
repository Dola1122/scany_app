part of 'new_pdf_cubit.dart';

@immutable
abstract class NewPdfState {}

class NewPdfInitial extends NewPdfState {}
class NewPdfToggleFABState extends NewPdfState {}
class NewPdfReorderPagesState extends NewPdfState {}
