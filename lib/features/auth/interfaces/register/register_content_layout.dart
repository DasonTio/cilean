import 'package:cilean/constants/config/size_config.dart';
import 'package:cilean/features/auth/bloc/auth_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegisterContentLayout extends StatefulWidget {
  const RegisterContentLayout({Key? key, required this.controller})
      : super(key: key);

  final AnimationController controller;
  @override
  _RegisterContentLayoutState createState() => _RegisterContentLayoutState();
}

class _RegisterContentLayoutState extends State<RegisterContentLayout> {
  late final Animation<Offset> _offsetFirstFormFieldAnimation;
  late final Animation<Offset> _offsetSecondFormFieldAnimation;
  late final Animation<Offset> _offsetThirdFormFieldAnimation;
  late final Animation<Offset> _offsetButtonAnimation;

  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  @override
  void initState() {
    super.initState();

    widget.controller.forward();

    _offsetFirstFormFieldAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: widget.controller,
      curve: const Interval(
        0.0,
        0.6,
        curve: Curves.easeInOut,
      ),
      reverseCurve: const Interval(
        0.0,
        0.6,
        curve: Curves.easeInOut,
      ),
    ));

    _offsetSecondFormFieldAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: widget.controller,
      curve: const Interval(
        0.2,
        0.8,
        curve: Curves.easeInOut,
      ),
      reverseCurve: const Interval(
        0.2,
        0.8,
        curve: Curves.easeInOut,
      ),
    ));

    _offsetThirdFormFieldAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: widget.controller,
      curve: const Interval(
        0.4,
        0.8,
        curve: Curves.easeInOut,
      ),
      reverseCurve: const Interval(
        0.4,
        0.8,
        curve: Curves.easeInOut,
      ),
    ));

    _offsetButtonAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: const Interval(
          0.4,
          0.8,
          curve: Curves.easeInOut,
        ),
        reverseCurve: const Interval(
          0.4,
          0.8,
          curve: Curves.easeInOut,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig(context);
    return Expanded(
      child: Form(
        child: Column(
          children: [
            SizedBox(
              height: SizeConfig.blockHeight * 8,
              child: ClipRRect(
                child: SlideTransition(
                  position: _offsetFirstFormFieldAnimation,
                  child: TextFormField(
                    controller: _controllerName,
                    textInputAction: TextInputAction.next,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      fillColor: Theme.of(context)
                          .colorScheme
                          .onPrimary
                          .withOpacity(0.1),
                      focusColor: Theme.of(context).colorScheme.onPrimary,
                      prefixIcon: const Icon(Icons.person),
                      hintText: "example",
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: SizeConfig.blockHeight * 3),
            SizedBox(
              height: SizeConfig.blockHeight * 8,
              child: ClipRRect(
                child: SlideTransition(
                  position: _offsetSecondFormFieldAnimation,
                  child: TextFormField(
                    controller: _controllerEmail,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      fillColor: Theme.of(context)
                          .colorScheme
                          .onPrimary
                          .withOpacity(0.1),
                      focusColor: Theme.of(context).colorScheme.onPrimary,
                      prefixIcon: const Icon(Icons.mail_rounded),
                      hintText: "example@gmail.com",
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: SizeConfig.blockHeight * 3),
            SizedBox(
              height: SizeConfig.blockHeight * 8,
              child: ClipRRect(
                child: SlideTransition(
                  position: _offsetThirdFormFieldAnimation,
                  child: TextFormField(
                    controller: _controllerPassword,
                    textInputAction: TextInputAction.done,
                    obscureText: true,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      fillColor: Theme.of(context)
                          .colorScheme
                          .onPrimary
                          .withOpacity(0.1),
                      focusColor: Theme.of(context).colorScheme.onPrimary,
                      prefixIcon: const Icon(Icons.lock_rounded),
                      hintText: "supersecret123",
                    ),
                  ),
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              height: SizeConfig.blockHeight * 8,
              child: ClipRRect(
                child: SlideTransition(
                  position: _offsetButtonAnimation,
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            context
                                .read<AuthBloc>()
                                .add(SignUpWithEmailAndPasswordEvent(
                                  name: _controllerName.text,
                                  email: _controllerEmail.text,
                                  password: _controllerPassword.text,
                                ));
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: SizeConfig.blockHeight * 2,
                            ),
                          ),
                          child: BlocConsumer<AuthBloc, AuthState>(
                            listener: (context, state) async {
                              if (state is AuthLoadded) {
                                if (FirebaseAuth.instance.currentUser == null) {
                                  return;
                                }
                                if (FirebaseAuth
                                    .instance.currentUser!.emailVerified) {
                                  Navigator.of(context)
                                      .pushReplacementNamed('/');
                                }
                              }
                              if (state is AuthError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    margin: EdgeInsets.only(
                                      left: SizeConfig.blockWidth * 6,
                                      right: SizeConfig.blockWidth * 6,
                                      bottom: SizeConfig.blockHeight * 24,
                                    ),
                                    duration: const Duration(
                                      milliseconds: 1800,
                                    ),
                                    backgroundColor: Colors.red.shade400,
                                    dismissDirection: DismissDirection.up,
                                    showCloseIcon: true,
                                    closeIconColor: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    content: const Text(
                                      'You are not authorized yet',
                                    ),
                                  ),
                                );
                              }
                              if (state is AuthLoading) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    margin: EdgeInsets.only(
                                      left: SizeConfig.blockWidth * 6,
                                      right: SizeConfig.blockWidth * 6,
                                      bottom: SizeConfig.blockHeight * 24,
                                    ),
                                    duration: const Duration(
                                      milliseconds: 1800,
                                    ),
                                    backgroundColor: Colors.grey.shade500,
                                    dismissDirection: DismissDirection.up,
                                    showCloseIcon: true,
                                    closeIconColor: Theme.of(context)
                                        .colorScheme
                                        .background,
                                    content: const Text(
                                      'Loading ...',
                                    ),
                                  ),
                                );
                              }
                            },
                            builder: (context, state) {
                              return Text(
                                'Sign Up',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                    ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: SizeConfig.blockHeight),
            Row(
              children: [
                SizedBox(
                  height: SizeConfig.blockHeight * 7,
                  child: ClipRRect(
                    child: SlideTransition(
                      position: _offsetButtonAnimation,
                      child: Container(
                        width: SizeConfig.blockWidth * 42.5,
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Sign In Event
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: FaIcon(
                            FontAwesomeIcons.google,
                            color: Theme.of(context).colorScheme.background,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  height: SizeConfig.blockHeight * 7,
                  child: ClipRRect(
                    child: SlideTransition(
                      position: _offsetButtonAnimation,
                      child: Container(
                        width: SizeConfig.blockWidth * 42.5,
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Sign In Event
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.onSecondary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: FaIcon(
                            FontAwesomeIcons.facebook,
                            color: Theme.of(context).colorScheme.background,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
