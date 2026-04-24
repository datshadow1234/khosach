import 'auth.dart';

enum AuthMode { signup, login }

class AuthCard extends HookWidget {
  const AuthCard({super.key});

  @override
  Widget build(BuildContext context) {
    final authMode = useState(AuthMode.login);
    final formKey = useMemoized(() => GlobalKey<FormState>());

    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    final phoneController = useTextEditingController();
    final nameController = useTextEditingController();
    final addressController = useTextEditingController();
    final isPasswordHidden = useState(true);
    final isConfirmPasswordHidden = useState(true);

    void handleAuthSubmit() {
      if (!formKey.currentState!.validate()) return;

      if (authMode.value == AuthMode.login) {
        BlocProvider.of<LoginBloc>(context).add(
          LoginSubmitted(emailController.text, passwordController.text),
        );
      } else {
        if (passwordController.text != confirmPasswordController.text) {
          showErrorDialog(context, 'Mật khẩu không khớp!');
          return;
        }

        BlocProvider.of<SignupBloc>(context).add(
          SignupSubmitted(
            emailController.text,
            passwordController.text,
            phoneController.text,
            nameController.text,
            addressController.text,
          ),
        );
      }
    }

    return MultiBlocListener(
      listeners: [
        BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginFailure) {
              showErrorDialog(context, state.message);
            } else if (state is LoginSuccess) {
              BlocProvider.of<AuthBloc>(context)
                  .add(AuthLoggedIn(authToken: state.authToken));
            }
          },
        ),
        BlocListener<SignupBloc, SignupState>(
          listener: (context, state) {
            if (state is SignupFailure) {
              showErrorDialog(context, state.message);
            } else if (state is SignupSuccess) {
              BlocProvider.of<AuthBloc>(context)
                  .add(AuthLoggedIn(authToken: state.authToken));
            }
          },
        ),
      ],
      child: Form(
        key: formKey,
        child: Column(
          children: [
            _buildModernField(
              controller: emailController,
              hint: "E-Mail",
              icon: Icons.alternate_email,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value!.isEmpty || !value.contains('@')) {
                  return 'Email không hợp lệ!';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),
            _buildModernField(
              controller: passwordController,
              hint: "Mật Khẩu",
              icon: Icons.lock_outline,
              isPassword: true,
              obscureText: isPasswordHidden.value,
              textInputAction: authMode.value == AuthMode.login
                  ? TextInputAction.done
                  : TextInputAction.next,
              onFieldSubmitted: authMode.value == AuthMode.login
                  ? (_) => handleAuthSubmit()
                  : null,
              suffixIcon: IconButton(
                icon: Icon(
                  isPasswordHidden.value
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
                onPressed: () {
                  isPasswordHidden.value = !isPasswordHidden.value;
                },
              ),
              validator: (value) {
                if (value == null || value.length < 5) {
                  return 'Mật khẩu quá ngắn!';
                }
                return null;
              },
            ),

            if (authMode.value == AuthMode.signup) ...[
              const SizedBox(height: 16),
              _buildModernField(
                controller: confirmPasswordController,
                hint: "Xác Nhận Mật Khẩu",
                icon: Icons.lock_reset,
                isPassword: true,
                obscureText: isConfirmPasswordHidden.value,
                suffixIcon: IconButton(
                  icon: Icon(
                    isConfirmPasswordHidden.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    isConfirmPasswordHidden.value =
                    !isConfirmPasswordHidden.value;
                  },
                ),
                validator: (value) {
                  if (value != passwordController.text) {
                    return 'Mật khẩu không khớp!';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              _buildModernField(
                controller: nameController,
                hint: "Họ Tên",
                icon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.length < 5) {
                    return 'Tên không hợp lệ';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              _buildModernField(
                controller: phoneController,
                hint: "Số Điện Thoại",
                icon: Icons.phone_iphone,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  String pattern = r'^(?:[+0]9)?[0-9]{10}$';
                  RegExp regex = RegExp(pattern);
                  if (!regex.hasMatch(value!)) {
                    return 'Số điện thoại không hợp lệ!';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              _buildModernField(
                controller: addressController,
                hint: "Địa chỉ",
                icon: Icons.location_on_outlined,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => handleAuthSubmit(),
                validator: (value) {
                  if (value == null || value.length < 5) {
                    return 'Địa chỉ không hợp lệ';
                  }
                  return null;
                },
              ),
            ],

            const SizedBox(height: 10),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  authMode.value = authMode.value == AuthMode.login
                      ? AuthMode.signup
                      : AuthMode.login;
                  formKey.currentState?.reset();
                },
                child: Text(
                  authMode.value == AuthMode.login
                      ? "Đăng ký tài khoản mới"
                      : "Đã có tài khoản",
                  style: const TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            Builder(builder: (context) {
              final isLoginLoading =
              context.watch<LoginBloc>().state is LoginLoading;
              final isSignupLoading =
              context.watch<SignupBloc>().state is SignupLoading;

              if (isLoginLoading || isSignupLoading) {
                return const CircularProgressIndicator(color: Colors.black);
              }

              return SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: (isLoginLoading || isSignupLoading)
                      ? null
                      : handleAuthSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 0,
                    disabledBackgroundColor: Colors.grey.shade400,
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 800),
                    child: (isLoginLoading || isSignupLoading)
                        ? const SizedBox(
                      key: ValueKey("loading"),
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : Text(
                      key: const ValueKey("text"),
                      authMode.value == AuthMode.login
                          ? "ĐĂNG NHẬP"
                          : "ĐĂNG KÝ",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
  Widget _buildModernField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required String? Function(String?) validator,
    bool isPassword = false,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction? textInputAction,
    void Function(String)? onFieldSubmitted,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? obscureText : false,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.grey, size: 22),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        contentPadding:
        const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      ),
      validator: validator,
    );
  }
}