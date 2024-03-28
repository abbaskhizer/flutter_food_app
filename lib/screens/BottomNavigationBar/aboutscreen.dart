import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});
  static const pagename = '/aboutScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.white),
        backgroundColor: Colors.red,
        title: const Text(
          'About',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 10,
          ),
          child: SingleChildScrollView(
            child: Column(children: [
              Text.rich(TextSpan(children: [
                TextSpan(
                  text: 'About Us\n',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.red),
                ),
                TextSpan(
                    text:
                        'Hello, I\'m Khizar Abbas, a student of Software Engineering with a strong background in app development. I have two years of experience as a Flutter Developer.',
                    style: Theme.of(context).textTheme.bodyLarge),
                TextSpan(
                    text: '\n Our Mission\n',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.red)),
                TextSpan(
                    text:
                        'Our goal is to offer a seamless and enjoyable food ordering experience through our Food App. We aim to connect users with their favorite food quickly and conveniently.',
                    style: Theme.of(context).textTheme.bodyLarge),
                TextSpan(
                    text: '\n What Sets Us Apar \n',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.red)),
                TextSpan(
                    text:
                        'We stand out by providing unique features and a wide range of choices, all with a commitment to delivering delicious food to your doorstep. We are dedicated to continuous improvement to make your food ordering experience exceptional.',
                    style: Theme.of(context).textTheme.bodyLarge),
                TextSpan(
                    text: '\n Meet the Team\n',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.red)),
                TextSpan(
                    text:
                        'Our passionate team works diligently to ensure the success of our app. We are tech enthusiasts with a deep love for good food, and we are thrilled to share our creations with you.',
                    style: Theme.of(context).textTheme.bodyLarge),
                TextSpan(
                    text: '\n Get in Touch \n',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.red)),
                TextSpan(
                    text:
                        'If you have questions, suggestions, or just want to connect with us, feel free to reach out. Contact us via email at email or follow us on our social media profiles.',
                    style: Theme.of(context).textTheme.bodyLarge),
                    TextSpan(
                    text: '\n[khizer2abbas1000@gmail.com]',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.red)),
                TextSpan(
                    text: '\n Stay Updated \n',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.red)),
                TextSpan(
                    text:
                        'To stay informed about our latest updates, offers, and news, visit our website and subscribe to our newsletter. We are eager to share the latest happenings in the world of food delivery.',
                    style: Theme.of(context).textTheme.bodyLarge),
                TextSpan(
                    text: '\n Legal Information \n',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.red)),
                TextSpan(
                    text:
                        'For more details about our policies and terms, please read our Privacy Policy and Terms of Service.Thank you for choosing our app for your food delivery needs. We look forward to serving you delicious meals with the convenience and ease you deserve.',
                    style: Theme.of(context).textTheme.bodyLarge)
              ]))
            ]),
          ),
        ),
      ),
    );
  }
}
