import 'package:http/http.dart' as http;
import 'dart:convert';

final String key = 'AIzaSyCp0x0kxSPj2nk-oiOGjeEo7hc7PIDjoaY';


Future<http.Response> signup(Map<String, dynamic> authData) async {
  return await http.post(
      "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$key",
      body: json.encode(authData),
      headers: {"Content-Type": "application/json"});
}

Future<http.Response> login(Map<String, dynamic> authData) async {
  return await http.post(
      "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$key",
      body: json.encode(authData),
      headers: {"Content-Type": "application/json"});
}