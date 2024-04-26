import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String url = "http://127.0.0.1:8000";
  final List<Map<String, dynamic>> phoneNum = [];

  Future<void> fetchPhone() async {
    try {
      final response = await http.get(Uri.parse('$url/phone_number'));

      if (response.statusCode == 200) {
        final List<dynamic> dataList = json.decode(response.body);

        // Clear phoneNumList before adding new data
        phoneNum.clear();

        // Iterate over the list of objects and add each object to phoneNumList
        for (var data in dataList) {
          if (data is Map<String, dynamic>) {
            phoneNum.add(data);
          }
        }
      } else {
        throw Exception('Failed to fetch phone: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that occur during the HTTP request
      print('Error fetching phone: $e');
      // Optionally, you can rethrow the exception if you want to propagate it
      // throw e;
    }
  }

  Future<void> removeNum(String phone) async {
    try {
      final response = await http.delete(Uri.parse('$url/phone_number/$phone'));
      print(response.statusCode);
      if (response.statusCode == 200) {
        print("successfully deleted phone number");
        setState(() {
          phoneNum.remove(phone);
        });
      } else {
        throw Exception('Failed to fetch phone: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any exceptions that occur during the HTTP request
      print('Error fetching phone: $e');
      // Optionally, you can rethrow the exception if you want to propagate it
      // throw e;
    }
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    fetchPhone();
  }
  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Profile'),
    ),
    body: Container(
      child: FutureBuilder(
        future: fetchPhone(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 100, // Adjust the height of the SizedBox as needed
                  child: phoneNum.isEmpty
                      ? Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  addPhone();
                                },
                                icon: Icon(Icons.add),
                              ),
                              Text("Add phone number"),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: phoneNum.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(phoneNum[index].values.elementAt(1)),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(phoneNum[index]
                                      .values
                                      .elementAt(0)
                                      .toString()),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      removeNum(
                                          phoneNum[index].values.elementAt(0));
                                      setState(() {
                                        phoneNum.remove(
                                            phoneNum[index].keys.elementAt(0));
                                      });
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
                // Additional widgets can be added below the ListView.builder
                // For example:
               SizedBox(
                height: 20,
               ),
               Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    
                  )
                ],
               )
              ],
            ),
          );
        },
      ),
    ),
  );
}


void addPhone() {
  TextEditingController phoneNumController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Add phone number"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(hintText: "Name"),
            ),
            TextField(
              controller: phoneNumController,
              decoration: InputDecoration(hintText: "Phone number"),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              try {
                final response = await http.post(
                  Uri.parse('$url/phone'),
                  headers: {
                    "Content-Type": "application/json",
                    "accept": "application/json",
                  },
                  body: json.encode({
                    "name": nameController.text,
                    "phoneNumber": phoneNumController.text,
                  }),
                );

                if (response.statusCode == 200) {
                  // Add the new phone number to the list
                  setState(() {
                    phoneNum.add({
                      "name": nameController.text,
                      "phone": phoneNumController.text,
                    });
                  });
                  // Close the dialog
                  Navigator.of(context).pop();
                } else {
                  throw Exception('Failed to add phone: ${response.statusCode}');
                }
              } catch (e) {
                print('Error adding phone: $e');
              }
            },
            child: Text("Add"),
          ),
        ],
      );
    },
  );
}
}
