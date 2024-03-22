import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// LocationView displays location-related information and options to the user
class LocationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildLocationHeader(),
                SizedBox(height: 33),
                _buildLocationImage(),
                SizedBox(height: 36),
                _buildWelcomeText(),
                SizedBox(height: 20),
                IconText(
                  imagePath: 'assets/magic-wand.png',
                  title: 'Location Access',
                  content: 'Location only used when the app is open for feature enhancement',
                ),
                SizedBox(height: 24),
                IconText(
                  imagePath: 'assets/shield.png',
                  title: 'Privacy First',
                  content: 'No background tracking. Your location helps us tailor the app\'s features to you',
                ),
                SizedBox(height: 24),
                IconText(
                  imagePath: 'assets/padlock.png',
                  title: 'Secure',
                  content: 'No data collection or sharing. Your privacy is our priority',
                ),
                SizedBox(height: 20),
                _buildContinueButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 48),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          'Your Location',
          style: GoogleFonts.istokWeb(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildLocationImage() {
    return Center(
      child: SizedBox(
        width: 350,
        height: 239,
        child: Image.asset('assets/document.jpg', fit: BoxFit.cover),
      ),
    );
  }

  Widget _buildWelcomeText() {
    return Center(
      child: Text(
        'Welcome to Restazo!',
        style: GoogleFonts.istokWeb(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return Center(
      child: SizedBox(
        width: 318,
        height: 47,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color.fromARGB(255, 79, 79, 79),
            shadowColor: Colors.black,
            elevation: 4,
          ),
          child: Text(
            'Continue',
            style: GoogleFonts.istokWeb(fontSize: 16),
          ),
        ),
      ),
    );
  }
}

// IconText is a reusable widget that combines an icon with a title and content text, ensuring alignment
class IconText extends StatelessWidget {
  final String imagePath;
  final String title;
  final String content;

  const IconText({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start, // Align items at the start vertically
            children: [
              Image.asset(imagePath, width: 24, height: 24),
              SizedBox(width: 8), // Spacing between the icon and the text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align text to start horizontally
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.istokWeb(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8), // Spacing between the title and content
                    Text(
                      content,
                      style: GoogleFonts.istokWeb(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }
}
