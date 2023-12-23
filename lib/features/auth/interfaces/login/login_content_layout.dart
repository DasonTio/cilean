import 'package:cilean/constants/config/size_config.dart';
import 'package:cilean/features/auth/bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginContentLayout extends StatefulWidget {
  const LoginContentLayout({Key? key, required this.controller})
      : super(key: key);

  final AnimationController controller;
  @override
  _LoginContentLayoutState createState() => _LoginContentLayoutState();
}

class _LoginContentLayoutState extends State<LoginContentLayout> {
  late final Animation<Offset> _offsetFirstFormFieldAnimation;
  late final Animation<Offset> _offsetSecondFormFieldAnimation;
  late final Animation<Offset> _offsetButtonAnimation;

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
                      hintText: "example@name.me",
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
                    controller: _controllerPassword,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
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
                            if (_controllerEmail.text == "" ||
                                _controllerPassword.text == "") {
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
                                  dismissDirection: DismissDirection.up,
                                  showCloseIcon: true,
                                  closeIconColor:
                                      Theme.of(context).colorScheme.background,
                                  content: const Text(
                                    'Please fill all the input box',
                                  ),
                                ),
                              );
                              return;
                            }
                            context
                                .read<AuthBloc>()
                                .add(SignInWithEmailAndPasswordEvent(
                                  email: _controllerEmail.text,
                                  password: _controllerPassword.text,
                                ));
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            fixedSize: Size(
                              SizeConfig.screenWidth,
                              SizeConfig.blockHeight * 7,
                            ),
                            padding: EdgeInsets.symmetric(
                              vertical: SizeConfig.blockHeight * 2,
                            ),
                          ),
                          child: BlocConsumer<AuthBloc, AuthState>(
                            listener: (context, state) {
                              if (state is AuthLoadded) {
                                Navigator.pushReplacementNamed(context, '/');
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
                            builder: (context, AuthState state) {
                              return Text(
                                'Sign In',
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
                            // TODO: fix Sign In With Google
                            // context.read<AuthBloc>().add(SignInWithGoogle());

                            // Dummy
                            Navigator.of(context).pushReplacementNamed('/');
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

                            // Dummy
                            Navigator.of(context).pushReplacementNamed('/');
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
