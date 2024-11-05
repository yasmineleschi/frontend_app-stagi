import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/views/Home/Home_view.dart';
import 'package:frontend_app_stagi/widgets/WidgetSignUp/label_text.dart';
import 'package:provider/provider.dart';
import 'package:frontend_app_stagi/viewmodels/signin_viewmodel.dart';
import 'package:frontend_app_stagi/widgets/WidgetSignUp/custom_text_field.dart';

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
                image: AssetImage("assets/img_3.png"),
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
                      padding: const EdgeInsets.only(right: 60.0,left: 20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Welcome Back !",
                              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold , color: Colors.black, fontFamily: 'Roboto Slab',),
                            ),
                            const SizedBox(height: 40),
                            const LabeledText(label: "Email"),
                            const SizedBox(height: 10),
                            CustomTextField(
                              hintText: 'Enter your email@gamil.com',
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              obscureText: false,
                              onChanged: viewModel.setEmail,
                              suffixIcon: null,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter an email';
                                }
                                final RegExp emailRegex =
                                RegExp(r'^[^@]+@[^@]+\.[^@]+');
                                if (!emailRegex.hasMatch(value)) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            const LabeledText(label: "Password"),
                            const SizedBox(height: 10),
                            CustomTextField (
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
                                  hidePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
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
                                backgroundColor:
                                MaterialStateProperty.all<Color>(
                                    const Color(0xFF012E65)),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
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
                                        builder: (context) => HomeView(token: viewModel.token),
                                      ),
                                    );
                                  }
                                }
                              },

                              child: const Text('Sign In',
                                  style: TextStyle(color: Colors.white,fontFamily: 'Roboto Slab', fontSize:  18,)),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Don't have an account?",
                                    style: TextStyle(color: Colors.black,fontFamily: 'Roboto Slab',fontSize: 15 ,)),
                                const SizedBox(width:2),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/signup');
                                  },
                                  child: const Text(
                                    'Sign Up Now',
                                    style: TextStyle(
                                      color: Color(0xFF012E65),
                                      fontSize: 18,
                                      fontWeight:  FontWeight.bold,
                                      fontFamily: 'Roboto Slab',
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
