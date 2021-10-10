import 'package:flutter/material.dart';

class BackgroundImageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: -56,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 120),
        child: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: MediaQuery.of(context).size.height / 2,
          alignment: Alignment.bottomCenter,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                "assets/icons/background-tree.png",
              ),
              fit: BoxFit.cover,
              alignment: Alignment.center,
            ),
          ),
        ),
      ),
    );
  }
}

class BackgroundColorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
      ),
    );
  }
}
