import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/datasources/auth_local_data_source.dart';
import '../../../domain/repositories/user_repository.dart';
import '../../../injection_container.dart';
import '../../blocs/auth_bloc/auth_bloc.dart';
import '../../blocs/auth_bloc/auth_event.dart';
import '../../blocs/user_bloc/user_bloc.dart';
import '../../blocs/user_bloc/user_event.dart';
import '../../blocs/user_bloc/user_state.dart';
import '../shared/dialog_utils.dart';

class PersonalScreen extends StatefulWidget {
  static const routeName = '/personal';

  const PersonalScreen({super.key});

  @override
  State<PersonalScreen> createState() => _PersonalScreenState();
}

class _PersonalScreenState extends State<PersonalScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final Map<String, dynamic> _data = {
    'email': '',
    'phone': '',
    'name': '',
    'birthday': '',
    'address': '',
    'imageUrl': '', // Thêm để xử lý avatar
  };

  final _isSubmitting = ValueNotifier<bool>(false);
  final _birthFieldController = ValueNotifier<TextEditingController>(TextEditingController());

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final uid = await sl<AuthLocalDataSource>().getUid();
    final token = await sl<AuthLocalDataSource>().getToken();
    if (uid != null && token != null && mounted) {
      context.read<UserBloc>().add(FetchUserInfoEvent(uid: uid, token: token));
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    _isSubmitting.value = true;

    try {
      final uid = await sl<AuthLocalDataSource>().getUid();
      final token = await sl<AuthLocalDataSource>().getToken();

      if (uid != null && token != null) {
        await sl<UserRepository>().createUser(
          uid,
          token,
          _data['email'],
          _data['phone'],
          _data['name'],
          _data['address'],
          // Gửi thêm imageUrl nếu bạn đã cập nhật UserRepository
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Cập nhật thành công!')),
          );
          _loadUserInfo();
        }
      }
    } catch (error) {
      if (mounted) showErrorDialog(context, 'Có lỗi xảy ra');
    }

    _isSubmitting.value = false;
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('Thông tin cá nhân')),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading || state is UserInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UserLoaded) {
            final user = state.user;
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
                        _buildAvatar(user.imageUrl), // Thêm avatar lên đầu
                        _buildEmailField(user.email),
                        _buildNameField(user.name),
                        _buildPhoneField(user.phone),
                        _buildBirthField(''),
                        _buildAddressField(user.address),
                        const SizedBox(height: 20),
                        ValueListenableBuilder<bool>(
                          valueListenable: _isSubmitting,
                          builder: (context, isSubmitting, child) {
                            if (isSubmitting) {
                              return const CircularProgressIndicator();
                            }
                            return _buildSubmitButton();
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildLogoutButton()
                      ],
                    ),
                  ),
                ),
              ),
            );
          }

          if (state is UserError) {
            return Center(child: Text(state.message));
          }

          return const SizedBox();
        },
      ),
    );
  }

  // --- PHẦN DƯỚI ĐÂY GIỮ NGUYÊN CẤU TRÚC HÀM RIÊNG BIỆT NHƯ CŨ ---

  Widget _buildAvatar(String? imageUrl) {
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey.shade200,
              backgroundImage: (imageUrl != null && imageUrl.isNotEmpty)
                  ? NetworkImage(imageUrl)
                  : const AssetImage('assets/images/default_user.png') as ImageProvider,
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: CircleAvatar(
                backgroundColor: Theme.of(context).primaryColor,
                radius: 18,
                child: IconButton(
                  icon: const Icon(Icons.camera_alt, size: 18, color: Colors.black),
                  onPressed: () {
                    // Logic ImagePicker
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _submit,
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
      onPressed: () {
        context.read<AuthBloc>().add(const AuthLoggedOut());
      },
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
          child: ValueListenableBuilder(
              valueListenable: _birthFieldController,
              builder: (context, controller, child) {
                return TextFormField(
                  controller: controller,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      prefixIcon: Icon(Icons.calendar_month)),
                  style: const TextStyle(fontSize: 18),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    DateTime? datePicked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100));
                    if (datePicked != null) {
                      _birthFieldController.value.text = datePicked.toString().split(' ')[0];
                    }
                  },
                  onSaved: (value) => _data['birthday'] = _birthFieldController.value.text,
                );
              }),
        ),
      ],
    );
  }
}