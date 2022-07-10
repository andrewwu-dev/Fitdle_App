abstract class Response {
  late int code;
  Object? data;
}
class Success extends Response {
  Success({code=success, data}){
    this.code = code;
    this.data = data;
  }
}

class Failure extends Response {
  Failure(code, data) {
    this.code = code;
    this.data = data;
  }
}

const success = 200;

// Errors
const custom = 0;