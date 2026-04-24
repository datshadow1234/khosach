import '../../../data/repositories/repositories.dart';
import 'app_shimmer.dart';

class AppLoader extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const AppLoader({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return child;

    return AppShimmer(
      child: child,
    );
  }
}