import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class PTexts {
  // OnBoarding Texts
  // ...

  // -- Home
  static const String homeAppBarTitle = "Good day";
  static const String homeAppBarSubTitle = "...";

  // -- Authentication Form Text
  static const String username = "Имя пользователя";
  static const String firstName = "Имя";
  static const String lastName = "Фамилия";
  static const String gender = "Пол";
  static const String dateOfBirth = "Дата рождения";
  static const String height = "Рост, см";
  static const String weight = "Вес, кг";
  static const String phoneNo = "Телефон";
  static const String password = "Пароль";
  static const String signIn = "Войти";
  static const String createAccount = "Создать аккаунт";
  static const String iAgreeTo = "///";

  // -- Authentication Heading Text
  static const String signupTitle = "Создание аккаунта";
  static const String loginTitle = "Добро пожаловать";
  static const String logininSubTitle =
      "Укажите номер телефона и пароль, чтобы войти";
  static const String profileMenuTitle1 = "Учётная запись";
  static const String profileMenuTitle2 = "Мои данные";

  // -- OnBoarding Texts

  static const String OnBoardingTitle1 = "Начни тренироваться";
  static const String OnBoardingTitle2 = "Начни тренироваться";
  static const String OnBoardingTitle3 = "Начни тренироваться";

  static const String OnBoardingSubTitle1 =
      "Выбери собственный режим занятий и шагай к цели ещё быстрее!";
  static const String OnBoardingSubTitle2 =
      "Выбери собственный режим занятий и шагай к цели ещё быстрее!";
  static const String OnBoardingSubTitle3 =
      "Выбери собственный режим занятий и шагай к цели ещё быстрее!";

  static List<String> genderItems = [
    'Мужской',
    'Женский',
  ];
}

var maskFormatter = MaskTextInputFormatter(
    mask: '##/##/####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy);


