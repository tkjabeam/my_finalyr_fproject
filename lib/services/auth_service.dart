// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:logger/logger.dart';
// import 'dart:async';

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final Logger _logger = Logger();

//   // Sign up with email and password
//   Future<User?> signUpWithEmailPassword(String email, String password) async {
//     try {
//       UserCredential userCredential =
//           await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       await userCredential.user?.sendEmailVerification();
//       return userCredential.user;
//     } on FirebaseAuthException catch (e) {
//       _logger.e("FirebaseAuthException: ${e.message}");
//       return null;
//     } catch (e) {
//       _logger.e("Exception: ${e.toString()}");
//       return null;
//     }
//   }

//   // Sign in with email and password
//   Future<User?> signInWithEmailPassword(String email, String password) async {
//     try {
//       UserCredential userCredential = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//       if (userCredential.user?.emailVerified == true) {
//         return userCredential.user;
//       } else {
//         await _auth.signOut();
//         throw FirebaseAuthException(
//           code: 'email-not-verified',
//           message: 'Email is not verified.',
//         );
//       }
//     } on FirebaseAuthException catch (e) {
//       _logger.e("FirebaseAuthException: ${e.message}");
//       return null;
//     } catch (e) {
//       _logger.e("Exception: ${e.toString()}");
//       return null;
//     }
//   }

//   // Resend email verification
//   Future<void> sendEmailVerification(User user) async {
//     await user.sendEmailVerification();
//   }

//   // Sign out
//   Future<void> signOut() async {
//     await _auth.signOut();
//   }

//   // Get current user
//   User? getCurrentUser() {
//     return _auth.currentUser;
//   }
// }



import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'dart:async';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger _logger = Logger();

  // Sign up with email and password
  Future<User?> signUpWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      // Send email verification
      await user?.sendEmailVerification();

      // Save user data in Firestore
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'email': email,
          'createdAt': Timestamp.now(),
          'uid': user.uid,
        });
      }

      return user;
    } on FirebaseAuthException catch (e) {
      _logger.e("FirebaseAuthException: ${e.message}");
      return null;
    } catch (e) {
      _logger.e("Exception: ${e.toString()}");
      return null;
    }
  }

  // Sign in with email and password
  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      // Check if email is verified
      if (user?.emailVerified == true) {
        return user;
      } else {
        await _auth.signOut();
        throw FirebaseAuthException(
          code: 'email-not-verified',
          message: 'Email is not verified.',
        );
      }
    } on FirebaseAuthException catch (e) {
      _logger.e("FirebaseAuthException: ${e.message}");
      return null;
    } catch (e) {
      _logger.e("Exception: ${e.toString()}");
      return null;
    }
  }

  // Resend email verification
  Future<void> sendEmailVerification(User user) async {
    try {
      await user.sendEmailVerification();
    } catch (e) {
      _logger.e("Exception: ${e.toString()}");
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      _logger.e("Exception: ${e.toString()}");
    }
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Email validation
  bool isValidEmail(String email) {
    String pattern =
        r'^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z0-9]+';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }
}