import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop/models/auth.dart';

enum AuhtMode { Signup, Login }

class AuhtForm extends StatefulWidget {
  const AuhtForm({super.key});

  @override
  State<AuhtForm> createState() => _AuhtFormState();
}

class _AuhtFormState extends State<AuhtForm>
    with SingleTickerProviderStateMixin {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  var _auhtMode = AuhtMode.Login;
  final Map<String, String> _auhtData = {
    'email': '',
    'password': '',
  };

  AnimationController? _controller;
  Animation<double>? _opacityAnimation;
  Animation<Offset>? _slideAnimation;

  bool _isLogin() => _auhtMode == AuhtMode.Login;
  bool _isSignup() => _auhtMode == AuhtMode.Signup;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 500,
        ));

    _opacityAnimation = Tween(
      begin: 0.0,
      end: 9.0,
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.linear,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.5),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.linear,
      ),
    );

    //_heightAnimation?.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  void _switchAuthMode() {
    setState(() {
      if (_isLogin()) {
        _auhtMode = AuhtMode.Signup;
        _controller?.forward();
      } else {
        _auhtMode = AuhtMode.Login;
        _controller?.reverse();
      }
    });
  }

  Future<void> _onSubmit() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    void showErrorDialog(String msg) {
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('Ocorreu um error'),
                content: Text(msg),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Fechar'),
                  ),
                ],
              ));
    }

    setState(() => _isLoading = true);

    _formKey.currentState?.save();

    Auth auth = Provider.of(context, listen: false);

    try {
      if (_isLogin()) {
        //login
        await auth.login(_auhtData['email']!, _auhtData['password']!);
      } else {
        //Registrar
        await auth.signup(_auhtData['email']!, _auhtData['password']!);
      }
    } catch (error) {
      //print(error);
      showErrorDialog(error.toString());
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 8,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300), curve: Curves.easeIn,
        padding: const EdgeInsets.all(20),
        height: _isLogin() ? 310 : 400,
//          height: _heightAnimation?.value.height ?? (_isLogin() ? 310 : 400),
        width: deviceSize.width * 0.75,
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (emial) => _auhtData['email'] = emial ?? '',
                  validator: _isLogin()
                      ? null
                      : (value) {
                          final email = value ?? '';
                          if (email.trim().isEmpty || !email.contains('@')) {
                            return ' E-mail inválido';
                          }
                          return null;
                        },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Senha'),
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  controller: _passwordController,
                  onSaved: (password) => _auhtData['password'] = password ?? '',
                  validator: (senha) {
                    final password = senha ?? '';
                    if (password.isEmpty || password.length < 5) {
                      return 'Infomre uma senha válida';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                _isSignup()
                    ? AnimatedContainer(
                        constraints: BoxConstraints(
                          minHeight: _isLogin() ? 0 : 60,
                          maxHeight: _isLogin() ? 0 : 120,
                        ),
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.linear,
                        child: FadeTransition(
                          opacity: _opacityAnimation!,
                          child: SlideTransition(
                            position: _slideAnimation!,
                            child: TextFormField(
                              decoration: const InputDecoration(
                                  labelText: 'Confirme a senha'),
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              validator: (senha) {
                                final password = senha ?? '';

                                if (password != _passwordController.text) {
                                  return 'Senhas informadas não conferem!';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(
                        height: 0,
                      ),
                const SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: () {
                      _onSubmit();
                    },
                    child: Text(
                      _auhtMode == AuhtMode.Login ? 'Entrar' : 'Cadastrar',
                      style: const TextStyle(
                        color: Colors.purple,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                const Spacer(),
                TextButton(
                    onPressed: _switchAuthMode,
                    child: Text(
                        _isLogin() ? 'Deseja registrar?' : 'Já possui conta?'))
              ],
            )),
      ),
    );
  }
}
