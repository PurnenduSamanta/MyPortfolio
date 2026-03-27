import 'package:flutter/material.dart';

class MainViewModel extends ChangeNotifier {
  bool isDesktop(double maxWidth) => maxWidth > 600;
}
