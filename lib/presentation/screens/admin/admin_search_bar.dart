import 'dart:async';
import 'admin.dart';

class AdminSearchBar extends HookWidget {
  const AdminSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final debounce = useRef<Timer?>(null);

    void onSearchChanged(String value) {
      if (debounce.value?.isActive ?? false) {
        debounce.value!.cancel();
      }

      debounce.value = Timer(const Duration(milliseconds: 300), () {
        if (context.mounted) {
          BlocProvider.of<AdminProductBloc>(
            context,
          ).add(SearchAdminProducts(value));
        }
      });
    }

    useEffect(() {
      return () {
        debounce.value?.cancel();
      };
    }, []);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SearchBar(
        hintText: 'Nhập tên sách...',
        leading: const Icon(Icons.search),
        onChanged: onSearchChanged,
      ),
    );
  }
}
