import 'auth.dart';

class AppBanner extends StatelessWidget {
  const AppBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30.0, top: 40),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 104.0),
      child: Hero(
        tag: 'app_logo',
        child: Material(
          type: MaterialType.transparency,
          child: Image.asset('assets/Images/image.png'),
        ),
      ),
    );
  }
}
