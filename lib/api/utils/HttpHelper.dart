import 'package:invoc/api/InvocAPIClient.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'package:invoc/api/model/Status.dart';
import 'package:invoc/api/model/User.dart';
import 'package:invoc/api/model/Product.dart';

/// General functions for sending http requests (post, get, multipart, ...)
class HttpHelper {
  static final HttpHelper _singleton = new HttpHelper._internal();
  factory HttpHelper() => _singleton;
  HttpHelper._internal();


  /// use the basic authentication credentials "off:off" to switch to the test server via htaccess
  bool isTestMode = false;

  static const String USER_AGENT = "Dart API";
  static const String FROM = "anonymous";

  /// Send a http get request to the specified uri.
  /// The data of the request (if any) has to be provided as parameter within the uri.
  /// The result of the request will be returned as string.
  Future<http.Response> doGetRequest(Uri uri, {required User user}) async {
    http.Response response =
    await http.get(uri, headers: _buildHeaders(user));

    return response;
  }

  Future<http.Response> doGetNormalRequest(Uri uri) async{
    http.Response response =
    await http.get(uri);
    return response;
  }

  /// Send a http post request to the specified uri.
  /// The data / body of the request has to be provided as map. (key, value)
  /// The result of the request will be returned as string.
  Future<http.Response> doPostRequest(
      Uri uri, Map<String, String> body, User user) async {
    http.Response response = await http.post(
      uri,headers:_buildHeaders(user),body: body );
    return response;
  }

  Future<http.Response> doPostRequestNormal(
      Uri uri, Map<String, dynamic> body) async {



    http.Response response = await http.post(
      uri,
      headers:{
        'Content-type' : 'application/json',
      },
      body: json.encode(body),
    );
//    print("${jsonEncode(body)}");
//    print("${response.headers}");
//    print("${response.request.toString()}");
//    print("${response.statusCode}");
//    print("${response.body}");

    return response;
  }


  Future<HttpClientResponse> doPost( Uri uri, Map<String, dynamic> body) async{

    HttpClient httpClient = new HttpClient();
    String jsonString = json.encode(body);
    List<int> bodyBytes = utf8.encode(jsonString);
    HttpClientRequest request = await httpClient.postUrl(uri);
    request.headers.set('Content-Type', 'application/json');
    request.headers.set('Content-Length', bodyBytes.length.toString());
    request.add(bodyBytes);

    print("${request}");
    return await request.close();

  }

  /// Send a multipart post request to the specified uri.
  /// The data / body of the request has to be provided as map. (key, value)
  /// The files to send have to be provided as map containing the source file uri.
  /// As result a json object of the "type" Status is expected.
  Future<Status> doMultipartRequest(Uri uri, Map<String, String> body,
      Map<String, Uri> files, User user) async {
    var request = new http.MultipartRequest("POST", uri);
    request.headers.addAll(_buildHeaders(user));
    request.headers.addAll({'Content-Type': 'multipart/form-data'});
    request.fields.addAll(body);

    // add all file entries to the request
    for (MapEntry<String, Uri> entry in files.entries) {
      List<int> fileBytes = await File.fromUri(entry.value).readAsBytes();
      //print(fileBytes.toString());

      var multipartFile = new http.MultipartFile.fromBytes(entry.key, fileBytes,
          filename: basename(entry.value.toString()));
      request.files.add(multipartFile);
    }

    print("body " + body.toString());
    print("files " + files.toString());

    // get the response status
    Status status = await request.send().then((response) {
      if (response.statusCode == 200) {
        return response.stream.first.then((responseBody) {
          //print(utf8.decode(responseBody));
          return Status.fromJson(json.decode(utf8.decode(responseBody)));
        });
      } else {
        print("Error: " + response.statusCode.toString());
        return Status(status: response.statusCode);
      }
    });
    print(status.toJson().toString());
    return status;
  }

  Map<String,String> _buildNormalHeaders(){
    var headers = new Map<String, String>();
    headers.addAll({'Accept': 'application/json'});
    //headers.addAll({'Content-Type': 'application/x-www-form-urlencoded'});
    return headers;
  }

  /// build the request headers
  Map<String, String> _buildHeaders(User user) {
    var headers = new Map<String, String>();
    headers.addAll({'Accept': 'application/json'});
    headers.addAll({'UserAgent': user != null ? user.comment! : USER_AGENT});
    headers.addAll({'From': user != null ? user.userId! : FROM});

    if (isTestMode) {
      var token = 'Basic ' + base64Encode(utf8.encode('off:off'));
      headers.addAll({'authorization': token});
      print("TEST-MODE");
    }

    return headers;
  }
}