// import 'package:auto_app/model/key_store.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserAuthentication {
  UserAuthentication({
    required this.accessToken,
    required this.refreshToken,
    required this.phone,
    required this.name,
    required this.sex,
    required this.birthday,
    required this.email,
    required this.password,
  });

  String accessToken = '';
  String refreshToken = '';
  String? name = '';
  String phone = '';
  String sex;
  String? birthday = '';
  String? email = '';
  String password;

  static void wipeData() {
    user = UserAuthentication(
      accessToken: '',
      refreshToken: '',
      name: '',
      phone: '',
      sex: '',
      birthday: '',
      email: '',
      password: '',
    );
    // const FlutterSecureStorage().delete(key: refreshStorageKey);
  }
}

UserAuthentication user = UserAuthentication(
  accessToken: '',
  refreshToken: '',
  name: '',
  phone: '',
  sex: '',
  birthday: '',
  email: '',
  password: '',
);
