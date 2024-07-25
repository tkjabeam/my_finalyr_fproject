// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'services/auth_service.dart';
// import 'homepage_screen.dart';
// import 'signup_screen.dart';
// import 'forgot_password_screen.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   LoginScreenState createState() => LoginScreenState();
// }

// class LoginScreenState extends State<LoginScreen> {
//   final AuthService _authService = AuthService();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   bool _obscureText = true;
//   String _errorMessage = '';

//   void _togglePasswordVisibility() {
//     setState(() {
//       _obscureText = !_obscureText;
//     });
//   }

//   Future<void> _login() async {
//     try {
//       User? user = await _authService.signInWithEmailPassword(
//         _emailController.text,
//         _passwordController.text,
//       );
//       if (user != null) {
//         if (mounted) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (context) => const HomePageScreen()),
//           );
//         }
//       }
//     } on FirebaseAuthException catch (e) {
//       if (e.code == 'email-not-verified') {
//         setState(() {
//           _errorMessage = 'Email is not verified. Please check your email.';
//         });
//       } else {
//         setState(() {
//           _errorMessage = 'Login failed. Please try again.';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _errorMessage = e.toString();
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               'Welcome',
//               style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'Enter your email and password to login',
//               style: TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: _emailController,
//               decoration: const InputDecoration(
//                 labelText: 'Email',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               controller: _passwordController,
//               obscureText: _obscureText,
//               decoration: InputDecoration(
//                 labelText: 'Password',
//                 border: const OutlineInputBorder(),
//                 suffixIcon: IconButton(
//                   icon: Icon(
//                     _obscureText ? Icons.visibility : Icons.visibility_off,
//                   ),
//                   onPressed: _togglePasswordVisibility,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             Align(
//               alignment: Alignment.centerRight,
//               child: TextButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const ForgotPasswordScreen(),
//                     ),
//                   );
//                 },
//                 child: const Text('Forgotten password?'),
//               ),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _login,
//               child: const Text('Login'),
//             ),
//             const SizedBox(height: 16),
//             Text(
//               _errorMessage,
//               style: const TextStyle(color: Colors.red),
//             ),
//             const SizedBox(height: 16),
//             const Text('or login with'),
//             const SizedBox(height: 8),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 IconButton(
//                   icon: Image.asset('assets/icons/google_logo.png'),
//                   iconSize: 25,
//                   onPressed: () {
//                     // Perform login with Google
//                   },
//                 ),
//                 const SizedBox(width: 16),
//                 IconButton(
//                   icon: Image.asset('assets/icons/facebook_logo.png'),
//                   iconSize: 25,
//                   onPressed: () {
//                     // Perform login with Facebook
//                   },
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Text("Don't have an account?"),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const SignUpScreen(),
//                       ),
//                     );
//                   },
//                   child: const Text('Sign up'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/auth_service.dart';
import 'homepage_screen.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;
  String _errorMessage = '';

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> _login() async {
    try {
      User? user = await _authService.signInWithEmailPassword(
        _emailController.text,
        _passwordController.text,
      );

      if (user != null && user.emailVerified) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePageScreen()),
          );
        }
      } else if (user != null && !user.emailVerified) {
        setState(() {
          _errorMessage = 'Email is not verified. Please check your email.';
        });
      } else {
        setState(() {
          _errorMessage = 'Login failed. Please try again.';
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        setState(() {
          _errorMessage = 'No user found for that email.';
        });
      } else if (e.code == 'wrong-password') {
        setState(() {
          _errorMessage = 'Wrong password provided for that user.';
        });
      } else if (e.code == 'invalid-email') {
        setState(() {
          _errorMessage = 'The email address is not valid.';
        });
      } else {
        setState(() {
          _errorMessage = 'Login failed. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Enter your email and password to login',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: _obscureText,
              decoration: InputDecoration(
                labelText: 'Password',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: _togglePasswordVisibility,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ForgotPasswordScreen(),
                    ),
                  );
                },
                child: const Text('Forgotten password?'),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 16),
            const Text('or login with'),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Image.asset('assets/icons/google_logo.png'),
                  iconSize: 25,
                  onPressed: () {
                    // Perform login with Google
                  },
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: Image.asset('assets/icons/facebook_logo.png'),
                  iconSize: 25,
                  onPressed: () {
                    // Perform login with Facebook
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpScreen(),
                      ),
                    );
                  },
                  child: const Text('Sign up'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
