import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/viewmodels/signin_viewmodel.dart';
import 'package:frontend_app_stagi/views/widgets/WidgetSignUp/custom_text_field.dart';
import 'package:frontend_app_stagi/views/Profil/Student_view.dart';
import 'package:provider/provider.dart';
import 'package:frontend_app_stagi/views/authentification/signin_view.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  _SignInViewState createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool hidePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SignInViewModel>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background_auth.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 150),
                            const Text(
                              "Welcome Back!",
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 30),
                            CustomTextField(
                              labelText: 'Email Address',
                              hintText: 'Enter your email',
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              obscureText: false,
                              onChanged: viewModel.setEmail,
                              suffixIcon: null,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter an email';
                                }
                                final RegExp emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                                if (!emailRegex.hasMatch(value)) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            CustomTextField(
                              labelText: 'Password',
                              hintText: 'Enter your password',
                              controller: _passwordController,
                              obscureText: hidePassword,
                              onChanged: viewModel.setPassword,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    hidePassword = !hidePassword;
                                  });
                                },
                                icon: Icon(
                                  hidePassword ? Icons.visibility_off : Icons.visibility,
                                  color: Colors.black.withOpacity(0.7),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a password';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF4267B2)),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    side: const BorderSide(color: Colors.white),
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState?.validate() ?? false) {
                                  await viewModel.signIn();

                                  if (viewModel.errorMessage.isNotEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(viewModel.errorMessage)),
                                    );
                                  } else {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => StudentProfileView(userId: viewModel.email), // Change as necessary
                                      ),
                                    );
                                  }
                                }
                              },
                              child: const Text('Sign In', style: TextStyle(color: Colors.white)),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    side: const BorderSide(color: Colors.grey),
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                await viewModel.signInWithGoogle();

                                if (viewModel.errorMessage.isNotEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(viewModel.errorMessage)),
                                  );
                                } else {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StudentProfileView(userId: viewModel.email), // Change as necessary
                                    ),
                                  );
                                }
                              },
                              icon: Image.asset('assets/google_logo.png', height: 24),
                              label: const Text('Sign In with Google', style: TextStyle(color: Colors.black)),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Don't have an account?", style: TextStyle(color: Colors.black)),
                                const SizedBox(width: 5),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/signup');
                                  },
                                  child: const Text(
                                    'Sign Up Now',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontStyle: FontStyle.italic,
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
              );
            },
          ),
        ],
      ),
    );
  }
}
