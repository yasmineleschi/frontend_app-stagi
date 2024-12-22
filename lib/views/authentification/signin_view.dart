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
      body: SingleChildScrollView(
        child: Container(
          color: const Color(0xFF1B3B6D),
          child: Padding(
            padding: const EdgeInsets.only(top: 90),
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Welcome Back !",
                            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold , color: Colors.black, fontFamily: 'Roboto Slab',),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Join to Stagi.tn",
                            style: TextStyle(
                              fontFamily: "Roboto Slab",
                              fontSize: 20,
                            ),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {},
                                child: const Text(
                                  "Forget Password ?",
                                  style: TextStyle(
                                    fontFamily: "Roboto Slab",
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
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
                                      builder: (context) => HomeView(token: viewModel.token, userId: viewModel.userId,role: viewModel.role,),
                                    ),
                                  );
                                }
                              }
                            },

                            child: const Text('Login',
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
            ),
          ),
        ),
      ),
    );

  }
}
