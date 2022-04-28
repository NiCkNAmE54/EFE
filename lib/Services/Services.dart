import 'package:http/http.dart' as http;

class Service {
  static String url = "https://countriesnow.space/api/v0.1";

  static Map<String, String> headers = Map<String, String>();

  static Future<String> getCountriesInfo(String columns) async {
    var response = await http.get(Uri.parse(url +  "/countries/info?returns=" + columns), headers: headers);
    return response.body;
  }

}