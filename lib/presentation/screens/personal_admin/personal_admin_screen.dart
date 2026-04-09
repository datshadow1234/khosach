import 'personal_admin_screen_widget.dart';

class PersonalAdminScreen extends StatefulWidget {
  static const routeName = '/personal-admin';
  const PersonalAdminScreen({super.key});

  @override
  State<PersonalAdminScreen> createState() => _PersonalAdminScreenState();
}

class _PersonalAdminScreenState extends State<PersonalAdminScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _birthFieldController = TextEditingController();

  final Map<String, dynamic> _data = {
    'email': '',
    'phone': '',
    'name': '',
    'birthday': '',
    'address': '',
  };

  @override
  void initState() {
    super.initState();
    _loadAdminData();
  }

  void _loadAdminData() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<AdminProfileBloc>().add(FetchAdminProfileEvent(
        authState.authToken.userId,
        authState.authToken.token,
      ));
    }
  }

  void _submit(UserEntity currentAdmin) {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      final updatedAdmin = currentAdmin.copyWith(
        name: _data['name'],
        phone: _data['phone'],
        address: _data['address'],
      );

      context.read<AdminProfileBloc>().add(UpdateAdminProfileEvent(
        updatedAdmin,
        authState.authToken.token,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('Thông tin cá nhân')),
      body: BlocConsumer<AdminProfileBloc, AdminProfileState>(
        listener: (context, state) {
          if (state is AdminProfileUpdatedSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Cập nhật thành công!'), backgroundColor: Colors.green),
            );
          } else if (state is AdminProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
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

            return Center(
              child: Container(
                alignment: Alignment.topCenter,
                width: deviceSize.width * 0.95,
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        _buildEmailField(admin.email),
                        _buildNameField(admin.name),
                        _buildPhoneField(admin.phone),
                        _buildBirthField(""),
                        _buildAddressField(admin.address),
                        const SizedBox(height: 20),
                        isSubmitting
                            ? const CircularProgressIndicator()
                            : _buildSubmitButton(() => _submit(admin)),
                        const SizedBox(height: 20),
                        _buildLogoutButton()
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          return const Center(child: Text('Không thể tải dữ liệu'));
        },
      ),
    );
  }
  Widget _buildSubmitButton(VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: Theme.of(context).primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
      ),
      child: const Text('Lưu thay đổi', style: TextStyle(color: Colors.black)),
    );
  }

  Widget _buildLogoutButton() {
    return ElevatedButton(
      onPressed: () => context.read<LogoutBloc>().add(LogoutSubmitted()),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: Theme.of(context).primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
      ),
      child: const Text('Đăng xuất', style: TextStyle(color: Colors.black)),
    );
  }

  Widget _buildEmailField(initValue) {
    return Column(
      children: [
        Container(
          height: 40,
          alignment: Alignment.centerLeft,
          child: const Text('Địa chỉ email:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        Container(
          height: 40,
          margin: const EdgeInsets.only(bottom: 8),
          child: TextFormField(
            enabled: false,
            initialValue: initValue,
            decoration: const InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                prefixIcon: Icon(Icons.email)),
            style: const TextStyle(fontSize: 18, color: Colors.grey),
            onSaved: (value) => _data['email'] = value!,
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneField(initValue) {
    return Column(
      children: [
        Container(
          height: 40,
          alignment: Alignment.centerLeft,
          child: const Text('Số điện thoại:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        Container(
          height: 40,
          margin: const EdgeInsets.only(bottom: 8),
          child: TextFormField(
            initialValue: initValue,
            decoration: const InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                prefixIcon: Icon(Icons.phone)),
            style: const TextStyle(fontSize: 18),
            keyboardType: TextInputType.phone,
            onSaved: (value) => _data['phone'] = value!,
          ),
        ),
      ],
    );
  }

  Widget _buildNameField(initValue) {
    return Column(
      children: [
        Container(
          height: 40,
          alignment: Alignment.centerLeft,
          child: const Text('Họ Tên', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        Container(
            height: 40,
            margin: const EdgeInsets.only(bottom: 8),
            child: TextFormField(
                initialValue: initValue,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    prefixIcon: Icon(Icons.person)),
                style: const TextStyle(fontSize: 18),
                onSaved: (value) => _data['name'] = value!)),
      ],
    );
  }

  Widget _buildAddressField(initValue) {
    return Column(
      children: [
        Container(
          height: 40,
          alignment: Alignment.centerLeft,
          child: const Text('Địa chỉ:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        Container(
            height: 40,
            margin: const EdgeInsets.only(bottom: 8),
            child: TextFormField(
                initialValue: initValue,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    prefixIcon: Icon(Icons.location_on)),
                style: const TextStyle(fontSize: 18),
                onSaved: (value) => _data['address'] = value!)),
      ],
    );
  }

  Widget _buildBirthField(initValue) {
    _birthFieldController.text = initValue;
    return Column(
      children: [
        Container(
          height: 40,
          alignment: Alignment.centerLeft,
          child: const Text('Ngày sinh:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        Container(
          height: 40,
          margin: const EdgeInsets.only(bottom: 8),
          child: TextFormField(
            controller: _birthFieldController,
            readOnly: true,
            decoration: const InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                prefixIcon: Icon(Icons.calendar_month)),
            style: const TextStyle(fontSize: 18),
            onTap: () async {
              DateTime? datePicked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100));
              if (datePicked != null) {
                _birthFieldController.text = datePicked.toString().split(' ')[0];
                _data['birthday'] = _birthFieldController.text;
              }
            },
          ),
        ),
      ],
    );
  }
}