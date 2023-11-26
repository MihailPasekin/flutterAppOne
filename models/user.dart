class User {
  int empId;
  String firstName;
  String lastName;
  String middleName;
  String sex;
  String jobTitle;
  int dept;
  String birthDay;
  String mobile;
  String homeTel;
  String email;
  String workStreet;
  String workCity;
  String password;
  String password2;
  String photo;
  
  User( this.empId, 
    this.firstName, 
    this.lastName,
    this.middleName, 
    this.sex, 
    this.jobTitle,
    this.dept,
    this.birthDay, 
    this.mobile, 
    this.homeTel, 
    this.workCity, 
    this.workStreet,
    this.email, 
    this.password, 
    this.password2,  
    this.photo );

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      int.parse(json['empId'].toString()),
      json['firstName'],
      json['lastName'],
      json['middleName'],
      json['sex'],
      json['jobTitle'],
      json['dept'],
      json['birthDay'],
      json['mobile'],
      json['homeTel'],
      json['workCity'],
      json['workStreet'],
      json['email'],
      json['password'],
      json['password2'],
      json['photo']
    );
  }

  factory User.defaultUser() {
    return User(0, '', '', '','','',0,'','','','','','','','','');
  }
  
  Map<String, dynamic> toMap() {
    return {
      'empId' : empId, 
      'firstName' : firstName, 
      'lastName' : lastName,
      'middleName': middleName, 
      'sex' : sex, 
      'jobTitle' : jobTitle,
      'dept' : dept,
      'birthDay' : birthDay, 
      'mobile' : mobile, 
      'homeTel': homeTel, 
      'workCity' : workCity, 
      'workStreet': workStreet,
      'email' : email, 
      'password' : password, 
      'password2' : password2,  
      'photo' : photo
    };
  }

}