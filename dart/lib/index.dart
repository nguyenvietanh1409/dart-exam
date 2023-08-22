import 'dart:convert';
import 'dart:io';

void main() {
  while (true) {
    print('Select an option:');
    print('1. Add Customer');
    print('2. Get All Customers');
    print('3. Exit');

    String choice = stdin.readLineSync() ?? '';

    switch (choice) {
      case '1':
        addCustomer();
        break;
      case '2':
        getAllCustomers();
        break;
      case '3':
        exit(0);
        break;
      default:
        print('Invalid choice. Please select again.');
    }
  }
}

void addCustomer() {
  print('Enter Full Name:');
  String fullName = stdin.readLineSync() ?? '';

  print('Enter Birthday (YYYY-MM-DD):');
  String birthday = stdin.readLineSync() ?? '';

  print('Enter Address:');
  String address = stdin.readLineSync() ?? '';

  print('Enter Phone Number:');
  String phoneNumber = stdin.readLineSync() ?? '';

  Map<String, dynamic> customerData = {
    'fullName': fullName,
    'birthday': birthday,
    'address': address,
    'phoneNumber': phoneNumber,
  };

  HttpClient()
      .post('localhost', 8080, '/api/customers')
      .then((HttpClientRequest request) {
    request.headers.contentType = ContentType.json;
    request.write(jsonEncode(customerData));
    return request.close();
  }).then((HttpClientResponse response) {
    if (response.statusCode == HttpStatus.created) {
      print('Customer added successfully.');
    } else {
      print('Error adding customer. Status code: ${response.statusCode}');
    }
  });
}

void getAllCustomers() {
  HttpClient()
      .get('localhost', 8080, '/api/customers')
      .then((HttpClientRequest request) => request.close())
      .then((HttpClientResponse response) async {
    if (response.statusCode == HttpStatus.ok) {
      String responseBody = await response.transform(utf8.decoder).join();
      List<dynamic> customers = jsonDecode(responseBody);

      for (var customer in customers) {
        print('ID: ${customer['id']}');
        print('Full Name: ${customer['fullName']}');
        print('Birthday: ${customer['birthday']}');
        print('Address: ${customer['address']}');
        print('Phone Number: ${customer['phoneNumber']}');
        print('-----------------------');
      }
    } else {
      print('Error fetching customers. Status code: ${response.statusCode}');
    }
  });
}