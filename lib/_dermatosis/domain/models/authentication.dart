class Authentication {
  var id = 0;
  var name = 'Adn';
  var password = '1234';
  var email = 'adn@gmail.com';
  var userType = UserType.doctor;
  bool get authenticated => id != 0;
}

enum UserType { doctor, patient }
