import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scany/business_logic/camera_cubit/camera_cubit.dart';
import 'package:scany/business_logic/new_pdf_cubit/new_pdf_cubit.dart';
import 'app_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp(
    appRouter: AppRouter(),
  ));
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;

  const MyApp({Key? key, required this.appRouter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CameraCubit(),
        ),
        BlocProvider(
          create: (context) => NewPdfCubit(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: appRouter.generateRoute,
        theme: ThemeData(primarySwatch: Colors.deepPurple),
      ),
    );
  }
}
