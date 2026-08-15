import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/features/auth/data/models/Repository/signin_repository.dart';
import '/features/auth/data/models/Repository/signup_repository.dart';
import '/features/auth/view/login_screen.dart';
import '/features/auth/view/register_first_step.dart';
import '/features/auth/view_model/bloc/login_bloc.dart';
import '/features/auth/view_model/bloc/signup_bloc.dart';
import '../ViewModel/profile_bloc.dart';
import 'change_email_view.dart';
import 'change_password_view.dart';
import 'edit_profile_view.dart';

class ProfileView extends StatefulWidget {
  final bool isGuest;
  const ProfileView({super.key, this.isGuest = false});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  void initState() {
    super.initState();
    final bloc = context.read<ProfileBloc>();
    if (bloc.state is ProfileInitial) {
      bloc.add(LoadProfileEvent(isGuest: widget.isGuest));
    }
  }

  // Future<void> _logout(BuildContext context) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.clear();

  //   if (context.mounted) {
  //     Navigator.of(context).pushAndRemoveUntil(
  //       MaterialPageRoute(
  //         builder:
  //             (_) => BlocProvider(
  //               create: (_) => LoginBloc(SigninRepository()),
  //               child: const LoginScreen(),
  //             ),
  //       ),
  //       (route) => false,
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) async {
          if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message.tr()),
                backgroundColor: Colors.red,
              ),
            );
          }

          if (state is ProfileActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message.tr()),
                backgroundColor: Colors.green,
              ),
            );

            if (state.requiresRelogin) {
              try {
                await SigninRepository().logout();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder:
                        (_) => BlocProvider(
                          create: (_) => LoginBloc(SigninRepository()),
                          child: const LoginScreen(),
                        ),
                  ),
                  (route) => false,
                );
              } catch (e) {
                // Even if an exception is thrown, tokens are already cleared
                print(e);
              }
            }
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading || state is ProfileInitial) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF6B2D5C)),
            );
          }

          if (state is ProfileGuestMode) {
            return _buildGuestView(context);
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
                        _buildInfoField('Email'.tr(), user.email),
                        _buildInfoField('Phone Number'.tr(), user.phone),
                        _buildInfoField('Governorate'.tr(), user.governorate),
                        _buildInfoField('City'.tr(), user.city),
                        const SizedBox(height: 20),

                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text('Do you want to change '.tr()),
                            GestureDetector(
                              onTap:
                                  () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const ChangeEmailView(),
                                    ),
                                  ),
                              child: Text(
                                'Email'.tr(),
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(' or '.tr()),
                            GestureDetector(
                              onTap:
                                  () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => const ChangePasswordView(),
                                    ),
                                  ),
                              child: Text(
                                'Password'.tr(),
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text('?'.tr()),
                          ],
                        ),
                        const SizedBox(height: 30),

                        TextButton.icon(
                          onPressed: () async {
                            try {
                              await SigninRepository().logout();
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder:
                                      (_) => BlocProvider(
                                        create:
                                            (_) =>
                                                LoginBloc(SigninRepository()),
                                        child: const LoginScreen(),
                                      ),
                                ),
                                (route) => false,
                              );
                            } catch (e) {
                              // Even if an exception is thrown, tokens are already cleared
                              print(e);
                            }
                          },
                          icon: const Icon(
                            Icons.logout,
                            color: Colors.red,
                            size: 24,
                          ),
                          label: Text(
                            'Log out'.tr(),
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

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
          Text(
            'Guest Mode Active'.tr(),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text('Please login to view and edit your profile.'.tr()),
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
                        create: (_) => LoginBloc(SigninRepository()),
                        child: const LoginScreen(),
                      ),
                ),
              );
            },
            child: Text('Login'.tr(), style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (_) => BlocProvider(
                        create: (_) => SignupBloc(SignupRepository()),
                        child: RegisterFirstStep(),
                      ),
                ),
              );
            },
            child: Text(
              'Sign up'.tr(),
              style: TextStyle(color: Color(0xFF6B2D5C)),
            ),
          ),
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
                    Text(
                      'Welcome'.tr(),
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
                    ),
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
            label.tr(),
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
            child: Text(
              value.tr(),
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
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
