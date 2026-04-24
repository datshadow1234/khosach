import 'package:package_info_plus/package_info_plus.dart';

import 'personal.dart';

class PersonalAdminScreen extends HookWidget {
  static const routeName = '/personal-admin';
  const PersonalAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final birthController = useTextEditingController();
    final packageInfo = useState<PackageInfo?>(null);
    final data = useMemoized(() => {
          'email': '',
          'phone': '',
          'name': '',
          'birthday': '',
          'address': '',
        });

    useEffect(() {
      PackageInfo.fromPlatform().then((info) {
        packageInfo.value = info;
      });

      final authState = BlocProvider.of<AuthBloc>(context).state;
      if (authState is AuthAuthenticated) {
        BlocProvider.of<AdminProfileBloc>(context).add(
          FetchAdminProfileEvent(
            authState.authToken.userId,
            authState.authToken.token,
          ),
        );
      }
      return null;
    }, const []);

    void submit(UserEntity currentAdmin) {
      if (!formKey.currentState!.validate()) return;
      formKey.currentState!.save();

      final authState = BlocProvider.of<AuthBloc>(context).state;
      if (authState is AuthAuthenticated) {
        final updatedAdmin = currentAdmin.copyWith(
          name: data['name'],
          phone: data['phone'],
          address: data['address'],
        );

        BlocProvider.of<AdminProfileBloc>(context).add(
          UpdateAdminProfileEvent(updatedAdmin, authState.authToken.token),
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Hồ sơ hệ thống', style: TextStyle(fontSize: 18)),
        elevation: 0.5,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: BlocConsumer<AdminProfileBloc, AdminProfileState>(
        listener: (context, state) {
          if (state is AdminProfileUpdatedSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Cập nhật thành công'),
                  backgroundColor: Colors.green),
            );
          }
        },
        builder: (context, state) {
          if (state is AdminProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AdminProfileLoaded || state is AdminProfileUpdating) {
            final admin = (state is AdminProfileLoaded)
                ? state.admin
                : (state as AdminProfileUpdating).admin;
            final isSubmitting = state is AdminProfileUpdating;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("THÔNG TIN CƠ BẢN",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            fontSize: 11)),
                    const SizedBox(height: 12),
                    _buildInputGroup([
                      _buildTextField(
                        label: 'Họ và tên',
                        initialValue: admin.name,
                        onSaved: (v) => data['name'] = v!,
                      ),
                      _buildTextField(
                        label: 'Email',
                        initialValue: admin.email,
                        enabled: false,
                        onSaved: (v) => data['email'] = v!,
                      ),
                      _buildTextField(
                        label: 'Số điện thoại',
                        initialValue: admin.phone,
                        onSaved: (v) => data['phone'] = v!,
                      ),
                    ]),
                    const SizedBox(height: 24),
                    const Text("ĐỊA CHỈ & NGÀY SINH",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            fontSize: 11)),
                    const SizedBox(height: 12),
                    _buildInputGroup([
                      _buildDateField(
                        context: context,
                        controller: birthController,
                        initialValue: "",
                        onSaved: (v) => data['birthday'] = v!,
                      ),
                      _buildTextField(
                        label: 'Địa chỉ hiện tại',
                        initialValue: admin.address,
                        onSaved: (v) => data['address'] = v!,
                      ),
                    ]),
                    const SizedBox(height: 40),
                    if (isSubmitting)
                      const Center(child: CircularProgressIndicator())
                    else ...[
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () => submit(admin),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
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
                          onPressed: () {
                            BlocProvider.of<LogoutBloc>(context)
                                .add(LogoutSubmitted());
                          },
                          child: const Text('Đăng xuất',
                              style: TextStyle(color: Colors.redAccent)),
                        ),
                      ),
                    ],
                    if (packageInfo.value != null) ...[
                      const SizedBox(height: 24),
                      Center(
                        child: Text(
                          'Phiên bản ${packageInfo.value!.version} (${packageInfo.value!.buildNumber})',
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ]
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

  Widget _buildTextField({
    required String label,
    required String initialValue,
    bool enabled = true,
    required Function(String?) onSaved,
  }) {
    return TextFormField(
      initialValue: initialValue,
      enabled: enabled,
      style: TextStyle(color: enabled ? Colors.black : Colors.grey),
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

  Widget _buildDateField({
    required BuildContext context,
    required TextEditingController controller,
    required String initialValue,
    required Function(String?) onSaved,
  }) {
    if (controller.text.isEmpty) controller.text = initialValue;
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: const InputDecoration(
        labelText: 'Ngày sinh',
        labelStyle: TextStyle(fontSize: 13, color: Colors.blueGrey),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: InputBorder.none,
        suffixIcon: Icon(Icons.chevron_right, size: 20),
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
