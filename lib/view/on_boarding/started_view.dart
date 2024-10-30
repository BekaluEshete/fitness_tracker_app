import 'package:fitness/common/colo_extension.dart';
import 'package:fitness/view/on_boarding/on_boarding_view.dart';
import 'package:flutter/material.dart';

import '../../common_widget/round_button.dart';

class StartedView extends StatefulWidget {
  const StartedView({super.key});

  @override
  State<StartedView> createState() => _StartedViewState();
}

class _StartedViewState extends State<StartedView> {
  bool isChangeColor = false;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            "assets/img/start.jpg",
            fit: BoxFit.cover,
            width: media.width,
            height: media.height,
          ),

          if (isChangeColor)
            Container(
              color: Colors.green.withOpacity(0.8), // Adjust opacity as needed
            ),

          // Main Content
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Text(
                "Tracking Fitness",
                style: TextStyle(
                    color: TColor.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w700),
              ),
              Text(
                "Everybody Can Train, and Become Healthy",
                style: TextStyle(
                  color: TColor.white,
                  fontSize: 18,
                ),
              ),
              const Spacer(),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: RoundButton(
                    title: "Get Started",
                    type: isChangeColor
                        ? RoundButtonType.textGradient
                        : RoundButtonType.bgGradient,
                    onPressed: () {
                      if (isChangeColor) {
                        // GO Next Screen
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const OnBoardingView()));
                      } else {
                        // Change Color
                        setState(() {
                          isChangeColor = true;
                        });
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
