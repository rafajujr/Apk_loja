class AuthExeption implements Exception {
  static const Map<String, String> errors = {
    'EMAIL_EXISTS': 'E-mail já cadastrado',
    'OPERATION_NOT_ALLOWED': 'Operação não permitida',
    'TOO_MANY_ATTEMPTS_TRY_LATER':
        'Acesso bloqueado temporariamente. Tente mais tarde',
    'EMAIL_NOT_FOUND': 'E-mail não encontrado',
    'INVALID_PASSWORD': 'Senha inválida',
    'USER_DISABLED': 'A conta do usuário foi desabilitadda',
  };

  final String Key;

  AuthExeption(this.Key);

  @override
  String toString() {
    //print(errors[key]);
    return errors[Key] ?? 'credenciais inválidas';
  }
}
