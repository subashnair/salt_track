
import 'dart:convert';
import 'package:http/http.dart';

class Tracking {

  Future<LoginResult> getLogin(String credential) async {
    try {
      Response response = await get(Uri.parse('http://bizzapp.trident-freight.com/trf-serv.sit/api/status-update/v1.0/login?username=jacob&password=jacobksa'));
      //Response response = await get(Uri.parse('https://rhslremote.rhslogisticsdwc.com/GeneralApi/ecomm/login/$credential'));

      print(response);

      Map data = jsonDecode(response.body);
      print(data);
      LoginResult _result = LoginResult();
      _result.Success = data['Success'];
      _result.Code = data['Code'];
      _result.Message = data['Message'];
      _result.UserID = data['UserID'];
      return _result;
    }
    catch(e) {}
    throw(){ new ArgumentError.notNull(); };
  }
  Future<Order> getTrack(String storerKey,String trackNumber) async {
    try {
      Response response = await get(Uri.parse('https://rhslremote.rhslogisticsdwc.com/GeneralApi/ecomm/StatusTracker/$trackNumber/$storerKey'));
      Map<String, dynamic>  data = Map<String, dynamic>.from(jsonDecode(response.body));
      Order order = Order.fromJson(data);
      return order;
    }
    catch(e) { }
    throw(){ new ArgumentError.notNull(); };
  }
}
class LoginResult {
  bool  Success=false;
  int Code=200;
  String Message='OK';
  String UserID='';
}

class OrderStatus
{
  String status='' ;
  String detail='' ;
  DateTime timeStamp = DateTime.now() ;
  OrderStatus.fromJson(Map<String, dynamic> json)
  : status = json['Status'], detail = json['Detail'], timeStamp = DateTime.parse(json['TimeStamp']);
}

class Order
{
  Party? customer ;
  String orderNumber ='';
  String lmdPartner ='';
  String airwayBillNumber ='';
  String orderCustomerRef ='';
  List<OrderStatus>? statuses ;
  Order() {}
  Order.fromJson(Map<String, dynamic> json)
      : customer = Party.fromJson(json['Customer']), orderNumber = json['OrderNumber'],
        lmdPartner = json['LmdPartner'], airwayBillNumber = json['AirwayBillNumber'],
        orderCustomerRef= json['OrderCustomerRef'], statuses = json['Statuses'].map<OrderStatus>((x) => OrderStatus.fromJson(x))
        .toList();
}

class Party
{
  String firstName ='';
  String lastName ='';
  String phone ='';
  Address? contactAddress ;
  Party(){}
  Party.fromJson(Map<String, dynamic> json)
      : firstName = json['FirstName'], lastName = json['LastName'],
        phone = json['Phone'], contactAddress =  Address.fromJson(json['ContactAddress']);
}
class Address
{
  String addressLine1 ='';
  String addressLine2='' ;
  String city ='';
  String stateCode='' ;
  String countryCode='' ;
  Address.fromJson(Map<String, dynamic> json)
      : addressLine1 = json['AddressLine1'], addressLine2 = json['AddressLine1'],
        city = json['City'], stateCode = json['StateCode'], countryCode = json['CountryCode'];
}