import 'package:delni_rms/features/auth/data/models/Repository/signup_repository.dart';
import 'package:delni_rms/features/auth/view/SignupScreen.dart';
import 'package:delni_rms/features/auth/view/register_first_step.dart';
import 'package:delni_rms/features/auth/view_model/bloc/signup_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/features/auth/data/models/Repository/signin_repository.dart'
    show SigninRepository;
import '/features/auth/view/login_screen.dart';
import '/features/auth/view_model/bloc/login_bloc.dart';
import '../ViewModel/profile_bloc.dart'
    show LoadProfileEvent, ProfileBloc, ProfileError, ProfileGuestMode, ProfileInitial, ProfileLoaded, ProfileLoading, ProfileState;
import 'change_email_view.dart';
import 'change_password_view.dart';
import 'edit_profile_view.dart';

class ProfileView extends StatelessWidget {
  final bool isGuest;
  const ProfileView({super.key, this.isGuest = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          print("Current Profile State: $state");

          // if (state is ProfileInitial) {
          //   return const Center(
          //     child:
          //       Text("please Enter your credentials to view profile."),
              
          //   );
          // }

          if (state is ProfileGuestMode) return _buildGuestView(context);

          if (state is ProfileLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF6B2D5C)),
            );
          }

          if (state is ProfileLoaded) {
            final user = state.user;
            return SingleChildScrollView(
              child: Column(
                children: [
                  _buildHeader(context, user.firstName, user.lastName),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        _buildInfoField('Email', user.email),
                        _buildInfoField('Number', user.phone),
                        _buildInfoField('Governorate', user.governorate),
                        _buildInfoField('City', user.city),

                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Do you Want change '),
                            GestureDetector(
                              onTap:
                                  () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const ChangeEmailView(),
                                    ),
                                  ),
                              child: const Text(
                                'Email',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Text(' or '),
                            GestureDetector(
                              onTap:
                                  () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => const ChangePasswordView(),
                                    ),
                                  ),
                              child: const Text(
                                'password',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const Text(' ?'),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          // return const Center(child: Text('Something went wrong.'));
          return _buildGuestView(context);
        },
      ),
    );
  }

  Widget _buildGuestView(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.storefront, size: 80, color: Color(0xFF6B2D5C)),
          const SizedBox(height: 16),
          const Text(
            'Guest Mode Active',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Please login to view and edit your profile.'),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6B2D5C),
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (_) => BlocProvider(
                        create: (context) => LoginBloc(SigninRepository()),
                        child: const LoginScreen(),
                      ),
                ),
              );
            },
            child: const Text('Login', style: TextStyle(color: Colors.white)),
          ),
          TextButton(onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider(
                  create: (BuildContext context) { 
                    return SignupBloc(SignupRepository());
                  },
                  child:  RegisterFirstStep(),
                ),
              ),
            );
          }, child: Text('Sign Up', style: TextStyle(color: Color(0xFF6B2D5C)))),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String fName, String lName) {
    return ClipPath(
      clipper: CustomHeaderClipper(),
      child: Container(
        height: 250,
        width: double.infinity,
        color: const Color(0xFF6B2D5C),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: 1,
                left: 1,
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 130,
                  width: 130,
                  fit: BoxFit.contain,
                ),
              ),

              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Welcome',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
             Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$fName $lName',
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => BlocProvider.value(
                                      value: context.read<ProfileBloc>(),
                                      child: const EditProfileView(),
                                    ),
                              ),
                            );

                            if (context.mounted) {
                              context.read<ProfileBloc>().add(
                                LoadProfileEvent(),
                              );
                            }
                          },
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF6B2D5C),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: const TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 50,
      size.width,
      size.height - 50,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
