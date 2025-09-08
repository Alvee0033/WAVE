import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  bool _isLoading = false;
  bool _isSignUp = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _floatController;
  
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _floatAnimation;

  // Muted color palette
  static const Color _mutedBlue = Color(0xFF6B7B8C);
  static const Color _mutedPurple = Color(0xFF8B7B9C);
  static const Color _mutedGray = Color(0xFF4A5568);
  static const Color _mutedSlate = Color(0xFF2D3748);
  static const Color _mutedWhite = Color(0xFFF7FAFC);
  static const Color _mutedDark = Color(0xFF1A202C);
  static const Color _glassWhite = Color(0x1AFFFFFF);
  static const Color _glassDark = Color(0x1A000000);

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _floatController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    // Initialize animations
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic));
    
    _floatAnimation = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
    
    // Start animations
    _fadeController.forward();
    _slideController.forward();
    _floatController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  Future<void> _signInWithGoogle() async {
    setState(() => _isLoading = true);
    
    try {
      // Google Sign-In temporarily disabled for web build
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        context.go('/dashboard');
      }
    } catch (e) {
      debugPrint('Google sign-in error: $e');
      _showErrorSnackBar('Google sign-in failed. Using guest mode...');
      // Fallback to guest mode
      await _signInAsGuest();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithEmailPassword() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    try {
      // Email/Password authentication temporarily disabled for web build
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        context.go('/dashboard');
      }
    } catch (e) {
      String message = 'Authentication failed: ${e.toString()}';
      _showErrorSnackBar(message);
      await _signInAsGuest();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInAsGuest() async {
    setState(() => _isLoading = true);
    
    try {
      // Anonymous sign-in temporarily disabled for web build
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        context.go('/dashboard');
      }
    } catch (e) {
      debugPrint('Anonymous sign-in error: $e');
      _showErrorSnackBar('Guest mode failed. Please try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _mutedSlate.withOpacity(0.9),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _mutedDark,
              _mutedSlate,
              _mutedGray,
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Animated background elements
            _buildAnimatedBackground(),
            
            // Main content - Single screen layout
            SafeArea(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: IntrinsicHeight(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  const SizedBox(height: 20),
                                  
                                  // Compact Header
                                  _buildCompactHeader(),
                                  
                                  // Compact Form
                                  _buildCompactForm(),
                                  
                                  // Compact Buttons
                                  _buildCompactButtons(),
                                  
                                  // Compact Toggle
                                  _buildCompactToggle(),
                                  
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _floatAnimation,
      builder: (context, child) {
        return Stack(
          children: [
            // Smaller floating orbs for compact design
            Positioned(
              top: 80 + _floatAnimation.value,
              left: 30,
              child: _buildFloatingOrb(_mutedBlue.withOpacity(0.08), 60),
            ),
            Positioned(
              top: 150 - _floatAnimation.value * 0.5,
              right: 50,
              child: _buildFloatingOrb(_mutedPurple.withOpacity(0.06), 80),
            ),
            Positioned(
              bottom: 120 + _floatAnimation.value * 0.7,
              left: 60,
              child: _buildFloatingOrb(_mutedGray.withOpacity(0.05), 70),
            ),
            Positioned(
              bottom: 200 - _floatAnimation.value,
              right: 40,
              child: _buildFloatingOrb(_mutedBlue.withOpacity(0.04), 50),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFloatingOrb(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color,
            color.withOpacity(0.0),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: 15,
            spreadRadius: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildCompactHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _glassWhite.withOpacity(0.2),
          width: 1,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _glassWhite.withOpacity(0.1),
            _glassDark.withOpacity(0.1),
          ],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Column(
            children: [
              // Compact WAVE Logo
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _glassWhite.withOpacity(0.3),
                    width: 1,
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _mutedBlue.withOpacity(0.3),
                      _mutedPurple.withOpacity(0.3),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _mutedBlue.withOpacity(0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.waves,
                  size: 30,
                  color: _mutedWhite,
                ),
              ),
              const SizedBox(height: 16),
              
              // Compact App Title
              Text(
                'WAVE',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: _mutedWhite,
                  letterSpacing: 1.5,
                  shadows: [
                    Shadow(
                      color: _mutedBlue.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              
              // Compact Subtitle
              Text(
                'AI-Powered World Analysis & Visualization',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: _mutedWhite.withOpacity(0.8),
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactForm() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _glassWhite.withOpacity(0.2),
          width: 1,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _glassWhite.withOpacity(0.1),
            _glassDark.withOpacity(0.1),
          ],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: _buildForm(),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildCompactTextField(
            controller: _emailController,
            labelText: 'Email',
            hintText: 'Enter your email',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Please enter a valid email address';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildCompactTextField(
            controller: _passwordController,
            labelText: 'Password',
            hintText: 'Enter your password',
            prefixIcon: Icons.lock_outline,
            obscureText: !_isPasswordVisible,
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: _mutedWhite.withOpacity(0.7),
                size: 18,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters long';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          _buildCompactButton(
            onPressed: _isLoading ? null : _signInWithEmailPassword,
            child: _isLoading
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(_mutedWhite),
                    ),
                  )
                : Text(
                    _isSignUp ? 'Create Account' : 'Sign In',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: _mutedWhite,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData prefixIcon,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _glassWhite.withOpacity(0.2),
          width: 1,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _glassWhite.withOpacity(0.05),
            _glassDark.withOpacity(0.05),
          ],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            style: const TextStyle(
              color: _mutedWhite,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              labelText: labelText,
              hintText: hintText,
              prefixIcon: Icon(
                prefixIcon,
                color: _mutedWhite.withOpacity(0.7),
                size: 18,
              ),
              suffixIcon: suffixIcon,
              labelStyle: TextStyle(
                color: _mutedWhite.withOpacity(0.8),
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              hintStyle: TextStyle(
                color: _mutedWhite.withOpacity(0.5),
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
              filled: true,
              fillColor: Colors.transparent,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: _mutedBlue.withOpacity(0.5),
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.red.withOpacity(0.5),
                  width: 1,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.red.withOpacity(0.7),
                  width: 2,
                ),
              ),
              errorStyle: TextStyle(
                color: Colors.red.withOpacity(0.8),
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
            validator: validator,
          ),
        ),
      ),
    );
  }

  Widget _buildCompactButton({
    required VoidCallback? onPressed,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _glassWhite.withOpacity(0.2),
          width: 1,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: onPressed != null
              ? [
                  _mutedBlue.withOpacity(0.3),
                  _mutedPurple.withOpacity(0.3),
                ]
              : [
                  _mutedGray.withOpacity(0.2),
                  _mutedSlate.withOpacity(0.2),
                ],
        ),
        boxShadow: onPressed != null
            ? [
                BoxShadow(
                  color: _mutedBlue.withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                alignment: Alignment.center,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactButtons() {
    return Column(
      children: [
        _buildCompactButton(
          onPressed: _isLoading ? null : _signInWithGoogle,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                child: const Icon(
                  Icons.g_mobiledata,
                  color: _mutedWhite,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Continue with Google',
                style: TextStyle(
                  color: _mutedWhite,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _buildCompactButton(
          onPressed: _isLoading ? null : _signInAsGuest,
          child: _isLoading
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(_mutedWhite),
                  ),
                )
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 18,
                      color: _mutedWhite,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Continue as Guest',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: _mutedWhite,
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildCompactToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _glassWhite.withOpacity(0.1),
          width: 1,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _glassWhite.withOpacity(0.05),
            _glassDark.withOpacity(0.05),
          ],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _isSignUp ? 'Already have an account?' : 'Don\'t have an account?',
                style: TextStyle(
                  color: _mutedWhite.withOpacity(0.8),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isSignUp = !_isSignUp;
                    _formKey.currentState?.reset();
                    _emailController.clear();
                    _passwordController.clear();
                  });
                },
                child: Text(
                  _isSignUp ? 'Sign In' : 'Sign Up',
                  style: TextStyle(
                    color: _mutedBlue.withOpacity(0.9),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}