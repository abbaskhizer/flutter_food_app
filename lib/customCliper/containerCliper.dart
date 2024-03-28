// ignore: file_names
import 'package:flutter/material.dart';

class ContainerClipper extends CustomClipper<Path> {

  @override
  Path getClip(Size size) {
    Path path=Path();
    var screenHeight=size.height;
    var screenWidth=size.width;
 
    var centerWidth=screenWidth/2;
  
    path.moveTo(screenWidth*0.3, screenHeight*0.3);
    path.lineTo(screenWidth*0.3, screenHeight*0.6);
    
   path.lineTo(centerWidth, screenHeight*0.7);
    path.lineTo(screenWidth*0.7, screenHeight*0.6);
    path.lineTo(screenWidth*0.7, screenHeight*0.3);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}