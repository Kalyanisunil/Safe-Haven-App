import 'package:flutter/material.dart';
import 'package:safehaven/home_screen.dart';
import 'package:safehaven/main.dart';
// import 'package:safehaven/sendsms.dart';
import 'login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                _buildPage(
                  image: 'assets/landingpage_0 2.png',
                  title: "Welcome!",
                  description:
                      "Safe Haven is all about women safety. This app is designed to ensure your safety at all times.",
                ),
                _buildPage(
                  image: 'assets/landing1 1.png',
                  title: "Emergency Alert",
                  description:
                      "Emergency alert functionality can call and send SMS to saved contacts in panic situations.",
                ),
                _buildPage(
                  image: 'assets/landing page 2 1.png',
                  title: "Spy Camera Feature",
                  description:
                      "Discreetly capture images or videos as evidence for law enforcement.",
                ),
              ],
            ),
          ),
          // Stack to overlap the image, navigation dots, and buttons
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Image at the bottom
              Image.asset(
                'assets/Ellipse 3.png', // Change this to your image path
                width: double.infinity,
                height: 180, // Adjust the height as per your requirement
                fit: BoxFit.cover, // Make sure image covers the area
              ),

              // The navigation dots on top of the image
              Positioned(
                bottom: 80, // Adjust the distance from the bottom as needed
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 12 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? Colors.pinkAccent
                            : Colors.white,
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                ),
              ),

              // Positioned buttons on top of the image
              Positioned(
                bottom: 20, // Adjust the distance from the bottom as needed
                child: _currentPage == 2
                    ? ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                                // builder: (context) => ()),
                          );
                        },
                        child: Text("Get Started"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pinkAccent,
                          padding: EdgeInsets.symmetric(
                              horizontal: 40, vertical: 10),
                        ),
                      )
                    : TextButton(
                        onPressed: () {
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        },
                        child: Text(
                          "Next",
                          style: TextStyle(color: Colors.pinkAccent),
                        ),
                      ),
              ),
            ],
          ),
          SizedBox(height: 0),
        ],
      ),
    );
  }

  Widget _buildPage(
      {required String image,
      required String title,
      required String description}) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: 200),
          SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.pinkAccent,
            ),
          ),
          SizedBox(height: 10),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
