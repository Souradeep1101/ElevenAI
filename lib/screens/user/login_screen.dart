import 'package:eleven_ai/core/firebase/user/auth.dart';
import 'package:eleven_ai/core/main_app.dart';
import 'package:eleven_ai/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:eleven_ai/screens/user/forgot_password_screen.dart';
import 'package:eleven_ai/screens/user/register_screen.dart';
import 'package:flutter/services.dart';
import 'package:line_icons/line_icons.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  dynamic user;

  void _toggleObscurePassword() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: AutofillGroup(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),
                    Text(
                      'Welcome back!',
                      style: Theme.of(context).textTheme.headline2,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Please sign in to continue',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    const SizedBox(height: 40),
                    TextFormField(
                      autofillHints: const [AutofillHints.email],
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email address',
                        labelStyle: Theme.of(context).textTheme.bodyText2,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      autofillHints: const [AutofillHints.password],
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? LineIcons.eyeSlash
                                : LineIcons.eye,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: _toggleObscurePassword,
                        ),
                        labelText: 'Password',
                        labelStyle: Theme.of(context).textTheme.bodyText2,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    CustomElevatedButton(
                      isLoading: _isLoading,
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          TextInput.finishAutofillContext();
                          setState(() {
                            _isLoading = true;
                          });
                          user = await Auth().loginUser(
                              email: _emailController.text,
                              password: _passwordController.text,
                              context: context);
                          if (user != null) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MainApp(),
                              ),
                            );
                          } else {
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        }
                      },
                      text: 'Sign In',
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account?',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onBackground,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 5),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Sign up',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
