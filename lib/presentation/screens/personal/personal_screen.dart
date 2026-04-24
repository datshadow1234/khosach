import 'package:image_picker/image_picker.dart';
import 'personal.dart';
import 'dart:typed_data';
class PersonalScreen extends HookWidget {
  static const routeName = '/personal';
  const PersonalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final birthController = useTextEditingController();
    final isSubmitting = useState(false);

    final selectedImageBytes = useState<Uint8List?>(null);
    final selectedImageFile = useState<XFile?>(null);

    final data = useMemoized(() => {
      'email': '',
      'phone': '',
      'name': '',
      'birthday': '',
      'address': '',
      'imageUrl': '',
    });

    useEffect(() {
      Future.microtask(() async {
        final uid = await sl<AuthLocalDataSource>().getUid();
        final token = await sl<AuthLocalDataSource>().getToken();
        if (uid != null && token != null) {
          BlocProvider.of<UserBloc>(context)
              .add(FetchUserInfoEvent(uid: uid, token: token));
        }
      });
      return null;
    }, const []);

    Future<void> pickImage() async {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        selectedImageFile.value = image;
        selectedImageBytes.value = (await image.readAsBytes()) as Uint8List?;
      }
    }

    Future<void> submit(dynamic currentUser) async {
      if (!formKey.currentState!.validate()) return;
      formKey.currentState!.save();

      isSubmitting.value = true;
      try {
        final uid = await sl<AuthLocalDataSource>().getUid();
        final token = await sl<AuthLocalDataSource>().getToken();

        if (uid != null && token != null) {

          String finalImageUrl = currentUser.imageUrl;
          if (selectedImageFile.value != null) {
            finalImageUrl = "https://link-anh.com/img.jpg";
          }
          data['imageUrl'] = finalImageUrl;

          await sl<UserRepository>().createUser(
            uid,
            token,
            data['email']!,
            data['phone']!,
            data['name']!,
            data['address']!,
            data['imageUrl']!,
          );

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Cập nhật thành công!'),
                  backgroundColor: Colors.green),
            );
            BlocProvider.of<UserBloc>(context)
                .add(FetchUserInfoEvent(uid: uid, token: token));
          }
        }
      } catch (error) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Có lỗi xảy ra: $error')),
          );
        }
      } finally {
        isSubmitting.value = false;
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Thông tin cá nhân',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading || state is UserInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UserLoaded) {
            final user = state.user;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(14),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                        child: _buildAvatar(
                          context: context,
                          imageUrl: user.imageUrl,
                          localImageBytes: selectedImageBytes.value,
                          onTap: pickImage,
                        )
                    ),
                    const SizedBox(height: 24),
                    const Text("THÔNG TIN CƠ BẢN",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            fontSize: 11)),
                    const SizedBox(height: 24),
                    _buildInputGroup([
                      _buildTextField(
                        label: 'Họ và tên',
                        initialValue: user.name,
                        onSaved: (v) => data['name'] = v!,
                      ),
                      _buildTextField(
                        label: 'Email',
                        initialValue: user.email,
                        enabled: false,
                        onSaved: (v) => data['email'] = v!,
                      ),
                      _buildTextField(
                        label: 'Số điện thoại',
                        initialValue: user.phone,
                        onSaved: (v) => data['phone'] = v!,
                      ),
                    ]),
                    const SizedBox(height: 24),
                    const Text("ĐỊA CHỈ & NGÀY SINH",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            fontSize: 11)),
                    const SizedBox(height: 24),
                    _buildInputGroup([
                      _buildDateField(
                        context: context,
                        controller: birthController,
                        initialValue: "",
                        onSaved: (v) => data['birthday'] = v!,
                      ),
                      _buildTextField(
                        label: 'Địa chỉ',
                        initialValue: user.address,
                        onSaved: (v) => data['address'] = v!,
                      ),
                    ]),
                    const SizedBox(height: 24),
                    if (isSubmitting.value)
                      const Center(child: CircularProgressIndicator())
                    else ...[
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () => submit(user),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          child: const Text('Lưu thay đổi',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () => BlocProvider.of<AuthBloc>(context)
                              .add(const AuthLoggedOut()),
                          child: const Text('Đăng xuất',
                              style: TextStyle(color: Colors.redAccent)),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }
          return const Center(child: Text('Không thể tải dữ liệu'));
        },
      ),
    );
  }
  Widget _buildAvatar({
    required BuildContext context,
    required String? imageUrl,
    required Uint8List? localImageBytes,
    required VoidCallback onTap,
  }) {

    ImageProvider imageProvider;
    if (localImageBytes != null) {
      imageProvider = MemoryImage(localImageBytes);
    } else if (imageUrl != null && imageUrl.isNotEmpty) {
      imageProvider = NetworkImage(imageUrl);
    } else {
      imageProvider = const AssetImage('assets/images/default_user.png');
    }

    return Stack(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: const Color(0xFFF5F5F7),
          backgroundImage: imageProvider,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: onTap,
            child: const CircleAvatar(
              backgroundColor: Colors.black,
              radius: 16,
              child: Icon(Icons.camera_alt, size: 14, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildInputGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F7),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: List.generate(children.length, (index) {
          return Column(
            children: [
              children[index],
              if (index != children.length - 1)
                const Divider(
                    height: 1, indent: 16, endIndent: 16, color: Colors.white),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildTextField(
      {required String label,
      required String initialValue,
      bool enabled = true,
      required Function(String?) onSaved}) {
    return TextFormField(
      initialValue: initialValue,
      enabled: enabled,
      style:
          TextStyle(fontSize: 15, color: enabled ? Colors.black : Colors.grey),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 13, color: Colors.blueGrey),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: InputBorder.none,
      ),
      onSaved: onSaved,
    );
  }

  Widget _buildDateField(
      {required BuildContext context,
      required TextEditingController controller,
      required String initialValue,
      required Function(String?) onSaved}) {
    if (controller.text.isEmpty) controller.text = initialValue;
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: const InputDecoration(
        labelText: 'Ngày sinh',
        labelStyle: TextStyle(fontSize: 13, color: Colors.blueGrey),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: InputBorder.none,
        suffixIcon: Icon(Icons.chevron_right, size: 20, color: Colors.grey),
      ),
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (picked != null) controller.text = picked.toString().split(' ')[0];
      },
      onSaved: (v) => onSaved(v),
    );
  }
}
