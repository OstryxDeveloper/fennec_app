
import 'package:flutter/widgets.dart';

double getHeight(context) => MediaQuery.of(context).size.height;
double getWidth(context) => MediaQuery.of(context).size.width;

// set height
double getProportionalHeight(BuildContext context, double inputHeight) {
  return (inputHeight / getHeight(context)) * getHeight(context);
}

double getProportionalWidth(BuildContext context, double inputWidth) {
  return (inputWidth / getWidth(context)) * MediaQuery.of(context).size.width;
}
