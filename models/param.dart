class Param{
  
  String paramName;
	int intVal;
	String stringVal;
	String dateTimeVal;

  Param(this.paramName, this.intVal, this.dateTimeVal, this.stringVal);
  factory Param.defaultParam(){
    return Param('', 0, '', '');
  }
  
  Map<String, dynamic> toMap() {
    return {
      'paramName' : paramName,
      'intVal': intVal,
      'stringVal' : stringVal,
      'dateTimeVal' : dateTimeVal
    };
  }

  factory Param.fromMap(Map<String, dynamic> json) {
    return Param(
        json['paramName'],
        json['intVal'],
        json['dateTimeVal'],
        json['stringVal'],
    );
  }
}