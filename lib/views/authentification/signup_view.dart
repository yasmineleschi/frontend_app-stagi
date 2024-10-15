import 'package:flutter/material.dart';
import 'package:frontend_app_stagi/views/Profil/Student_view.dart';
import 'package:frontend_app_stagi/views/Profil/create_studentprofile_view.dart';
import 'package:frontend_app_stagi/widgets/WidgetSignUp/CustomDropdown.dart';
import 'package:frontend_app_stagi/widgets/WidgetSignUp/custom_text_field.dart';
import 'package:frontend_app_stagi/widgets/WidgetSignUp/label_text.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/signup_viewmodel.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool hidePassword = true;

  String role = "Student";
  final List<String> roles = ["Student", "Company"];

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<SignUpViewModel>(context);

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
                              "Let's get you registered",
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 30),
                            const LabeledText(label: "Username"),
                            const SizedBox(height: 10),
                            CustomTextField(
                              hintText: 'Enter your username',
                              controller: _usernameController,
                              obscureText: false,
                              onChanged: viewModel.setUsername,
                              suffixIcon: null,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a username';
                                }
                                final RegExp usernameRegex = RegExp(r'^[a-zA-Z0-9_]{3,20}$');
                                if (!usernameRegex.hasMatch(value)) {
                                  return 'Username must be 3-20 characters and can contain only letters, numbers, and underscores';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 14),
                            const LabeledText(label: "Email"),
                            const SizedBox(height: 10),
                            CustomTextField(
                              hintText: 'Enter your email@gmail.com',
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
                            const SizedBox(height: 14),
                            const LabeledText(label: "Password"),
                            const SizedBox(height: 10),
                            CustomTextField(
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
                                if (value.length < 8) {
                                  return 'Password must be at least 8 characters';
                                }
                                if (value.contains(' ')) {
                                  return 'Password cannot contain spaces';
                                }
                                return null; // Valide si aucune condition n'est violée
                              },
                            ),
                            const SizedBox(height: 14),
                            const LabeledText(label: "Sign up As "),
                            const SizedBox(height: 10),
                            CustomDropdown(
                              value: role,
                              items: roles,
                              onChanged: (value) {
                                setState(() {
                                  role = value!;
                                  viewModel.setRole(role);
                                });
                              },
                            ),
                            const SizedBox(height: 14),
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
                                  await viewModel.signUp();

                                  if (viewModel.errorMessage.isNotEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(viewModel.errorMessage)),
                                    );
                                  } else {
                                    final userId = await viewModel.getUserId();
                                    if (userId != null && userId.isNotEmpty) {

                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProfileStepper(userId: userId),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Failed to retrieve user ID')),
                                      );
                                    }
                                  }
                                }
                              },

                              child: const Text('Create my account', style: TextStyle(color: Colors.white)),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(height: 1, width: 100, color: Colors.white),
                                const SizedBox(width: 10),
                                const Text("or sign up with", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                const SizedBox(width: 10),
                                Container(height: 1, width: 100, color: Colors.white),
                              ],
                            ),
                            const SizedBox(height: 14),
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
                              // Démarrer le processus d'inscription avec Google, sans validation de formulaire
                              await viewModel.signUpWithGoogle();

                              // Afficher un message d'erreur ou de succès selon le résultat
                              if (viewModel.errorMessage.isNotEmpty) {
                                // En cas d'erreur
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(viewModel.errorMessage),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } else {

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Signed up successfully!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );



                              }
                            },
                            icon: Image.asset('assets/google_logo.png', height: 24), // Icône Google
                            label: const Text(
                              'Sign Up with Google',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),


                          const SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("You Already Have An Account?", style: TextStyle(color: Colors.black)),
                                const SizedBox(width: 5),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/login');
                                  },
                                  child: const Text(
                                    'LogIn Now',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ],
                            )
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


