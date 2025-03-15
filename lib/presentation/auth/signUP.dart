// import 'package:caseflow/presentation/auth/login.dart';
// import 'package:caseflow/presentation/home.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/gestures.dart';
 

// class SignUpPage extends StatefulWidget {
//   const SignUpPage({Key? key}) : super(key: key);

//   @override
//   _SignUpPageState createState() => _SignUpPageState();
// }

// class _SignUpPageState extends State<SignUpPage> {
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController =
//       TextEditingController();
//   final _formKey = GlobalKey<FormState>();
 
//   bool _isLoading = false;
//   bool _obscurePassword = true;
//   bool _obscureConfirmPassword = true;
//   bool _acceptTerms = false;
//   String? _errorMessage;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(24.0),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 50),
//                   // Header
//                   const Text(
//                     "Create Account",
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   const Text(
//                     "Fill in the form to create your account",
//                     style: TextStyle(color: Colors.grey, fontSize: 16),
//                   ),
//                   const SizedBox(height: 40),

//                   // Error Message
//                   if (_errorMessage != null)
//                     Container(
//                       padding: const EdgeInsets.all(12),
//                       margin: const EdgeInsets.only(bottom: 20),
//                       decoration: BoxDecoration(
//                         color: Colors.red.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Row(
//                         children: [
//                           const Icon(Icons.error_outline, color: Colors.red),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: Text(
//                               _errorMessage!,
//                               style: const TextStyle(color: Colors.red),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),

//                   // Name Field
//                   TextFormField(
//                     controller: _nameController,
//                     style: const TextStyle(color: Colors.white),
//                     decoration: InputDecoration(
//                       labelText: "Full Name",
//                       labelStyle: const TextStyle(color: Colors.grey),
//                       prefixIcon: const Icon(
//                         Icons.person_outline,
//                         color: Colors.grey,
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: const BorderSide(color: Colors.grey),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: const BorderSide(color: Colors.white),
//                       ),
//                       filled: true,
//                       fillColor: Colors.grey.withOpacity(0.1),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your name';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 20),

//                   // Email Field
//                   TextFormField(
//                     controller: _emailController,
//                     style: const TextStyle(color: Colors.white),
//                     decoration: InputDecoration(
//                       labelText: "Email Address",
//                       labelStyle: const TextStyle(color: Colors.grey),
//                       prefixIcon: const Icon(
//                         Icons.email_outlined,
//                         color: Colors.grey,
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: const BorderSide(color: Colors.grey),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: const BorderSide(color: Colors.white),
//                       ),
//                       filled: true,
//                       fillColor: Colors.grey.withOpacity(0.1),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your email';
//                       }
//                       if (!RegExp(
//                         r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
//                       ).hasMatch(value)) {
//                         return 'Please enter a valid email';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 20),

//                   // Password Field
//                   TextFormField(
//                     controller: _passwordController,
//                     obscureText: _obscurePassword,
//                     style: const TextStyle(color: Colors.white),
//                     decoration: InputDecoration(
//                       labelText: "Password",
//                       labelStyle: const TextStyle(color: Colors.grey),
//                       prefixIcon: const Icon(
//                         Icons.lock_outline,
//                         color: Colors.grey,
//                       ),
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           _obscurePassword
//                               ? Icons.visibility_off
//                               : Icons.visibility,
//                           color: Colors.grey,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             _obscurePassword = !_obscurePassword;
//                           });
//                         },
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: const BorderSide(color: Colors.grey),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: const BorderSide(color: Colors.white),
//                       ),
//                       filled: true,
//                       fillColor: Colors.grey.withOpacity(0.1),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your password';
//                       }
//                       if (value.length < 6) {
//                         return 'Password must be at least 6 characters';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 20),

//                   // Confirm Password Field
//                   TextFormField(
//                     controller: _confirmPasswordController,
//                     obscureText: _obscureConfirmPassword,
//                     style: const TextStyle(color: Colors.white),
//                     decoration: InputDecoration(
//                       labelText: "Confirm Password",
//                       labelStyle: const TextStyle(color: Colors.grey),
//                       prefixIcon: const Icon(
//                         Icons.lock_outline,
//                         color: Colors.grey,
//                       ),
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           _obscureConfirmPassword
//                               ? Icons.visibility_off
//                               : Icons.visibility,
//                           color: Colors.grey,
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             _obscureConfirmPassword = !_obscureConfirmPassword;
//                           });
//                         },
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: const BorderSide(color: Colors.grey),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: const BorderSide(color: Colors.white),
//                       ),
//                       filled: true,
//                       fillColor: Colors.grey.withOpacity(0.1),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please confirm your password';
//                       }
//                       if (value != _passwordController.text) {
//                         return 'Passwords do not match';
//                       }
//                       return null;
//                     },
//                   ),
//                   const SizedBox(height: 20),

//                   // Terms and Conditions
//                   Row(
//                     children: [
//                       SizedBox(
//                         height: 24,
//                         width: 24,
//                         child: Checkbox(
//                           value: _acceptTerms,
//                           onChanged: (value) {
//                             setState(() {
//                               _acceptTerms = value ?? false;
//                             });
//                           },
//                           fillColor: MaterialStateProperty.resolveWith<Color>((
//                             Set<MaterialState> states,
//                           ) {
//                             if (states.contains(MaterialState.selected)) {
//                               return Colors.green;
//                             }
//                             return Colors.grey;
//                           }),
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Expanded(
//                         child: Text.rich(
//                           TextSpan(
//                             text: 'I agree to the ',
//                             style: const TextStyle(color: Colors.grey),
//                             children: [
//                               TextSpan(
//                                 text: 'Terms & Conditions',
//                                 style: const TextStyle(
//                                   color: Colors.green,
//                                   decoration: TextDecoration.underline,
//                                 ),
//                                 recognizer:
//                                     TapGestureRecognizer()
//                                       ..onTap = () {
//                                         // Handle Terms & Conditions tap
//                                       },
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 24),

//                   // Sign Up Button
//                   SizedBox(
//                     width: double.infinity,
//                     height: 50,
//                     child: ElevatedButton(
//                       onPressed:
//                           _isLoading || !_acceptTerms ? null : _handleSignUp,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.green,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         elevation: 0,
//                       ),
//                       child:
//                           _isLoading
//                               ? const SizedBox(
//                                 height: 20,
//                                 width: 20,
//                                 child: CircularProgressIndicator(
//                                   valueColor: AlwaysStoppedAnimation<Color>(
//                                     Colors.white,
//                                   ),
//                                   strokeWidth: 2,
//                                 ),
//                               )
//                               : const Text(
//                                 "Create Account",
//                                 style: TextStyle(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                     ),
//                   ),
//                   const SizedBox(height: 24),

//                   // Login Link
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text(
//                         "Already have an account? ",
//                         style: TextStyle(color: Colors.grey),
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => LoginPage(),
//                             ),
//                           );
//                         },
//                         child: const Text(
//                           "Login",
//                           style: TextStyle(
//                             color: Colors.green,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _handleSignUp() async {
//     if (!_formKey.currentState!.validate()) return;

//     if (!_acceptTerms) {
//       setState(() {
//         _errorMessage = 'Please accept the Terms & Conditions';
//       });
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });

//     try {
//       // TODO: Implement actual sign up logic
//       await Future.delayed(
//         const Duration(seconds: 2),
//       ); // Simulate network request

//       // Navigate to home page on success
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => HomeScreen()),
//       );
//     } catch (e) {
//       setState(() {
//         _errorMessage = 'Failed to create account. Please try again.';
//       });
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }
// }
