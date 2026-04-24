import 'user.dart';
class UserManagementScreen extends HookWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final users = useState<List<UserEntity>>([]);
    final isLoading = useState(false);
    final error = useState<String?>(null);
    Future<void> fetchUsers() async {
      if (isLoading.value) return;

      isLoading.value = true;
      error.value = null;

      try {
        final authState = BlocProvider.of<AuthBloc>(context).state;

        if (authState is! AuthAuthenticated) {
          throw Exception('Chưa đăng nhập');
        }

        final token = authState.authToken.token;
        final repo = sl<AdminRepository>();

        final fetchedUsers = await repo.getAllUsers(token);
        users.value = fetchedUsers;
      } catch (e) {
        error.value = e.toString();
      } finally {
        isLoading.value = false;
      }
    }
    useEffect(() {
      fetchUsers();
      return null;
    }, []);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Quản lý người dùng'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            icon: isLoading.value
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : const Icon(Icons.refresh),
            onPressed: isLoading.value ? null : fetchUsers,
          ),
        ],
      ),
      body: _buildBody(context, isLoading.value, error.value, users.value, fetchUsers),
    );
  }

  Widget _buildBody(
      BuildContext context,
      bool loading,
      String? errorMsg,
      List<UserEntity> userList,
      VoidCallback onRetry
      ) {
    if (loading && userList.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMsg != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Lỗi: $errorMsg', textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: onRetry, child: const Text('Thử lại')),
          ],
        ),
      );
    }

    if (userList.isEmpty) {
      return const Center(child: Text('Không có người dùng nào.'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: userList.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final user = userList[index];

        return ListTile(
          tileColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          leading: CircleAvatar(
            backgroundColor: Colors.blue.shade100,
            child: Text(
              user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
              style: TextStyle(color: Colors.blue.shade900, fontWeight: FontWeight.bold),
            ),
          ),
          title: Text(
            user.name.isEmpty ? "Người dùng chưa tên" : user.name,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(user.email),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserDetailScreen(user: user),
              ),
            );
          },
        );
      },
    );
  }
}