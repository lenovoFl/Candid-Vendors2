import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DataDisplayScreen extends StatefulWidget {
  final String sellerId;
  final String sellerName;
  final String city;
  final String state;
  final String address;
  final String address2;
  final List<Map<String, dynamic>> dataList;

  const DataDisplayScreen({
    super.key,
    this.sellerId = '',
    this.sellerName = '',
    this.city = '',
    this.state = '',
    this.address = '',
    this.address2 = '',
    required this.dataList,
  });

  @override
  DataDisplayScreenState createState() => DataDisplayScreenState();
}

class DataDisplayScreenState extends State<DataDisplayScreen> {
  List<Map<String, dynamic>> addedDataList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DATA DISPLAY'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              initialValue: widget.sellerId,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                labelText: 'Seller ID',
              ),
              readOnly: true,
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              initialValue: widget.sellerName,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                labelText: 'Seller Name',
              ),
              readOnly: true,
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              initialValue: widget.city,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                labelText: 'City',
              ),
              readOnly: true,
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              initialValue: widget.state,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                labelText: 'State',
              ),
              readOnly: true,
            ),
            const SizedBox(height: 16.0),
            Column(
              children: [
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Perform add functionality
                        _addDataToList();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade900, // Set the background color
                      ),
                      child: const Text(
                        'Add',
                        style: TextStyle(
                          color: Colors.white, // Set the text color
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Perform list functionality
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ListViewScreen(dataList: widget.dataList),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade900, // Set the background color
                      ),
                      child: const Text(
                        'List',
                        style: TextStyle(
                          color: Colors.white, // Set the text color
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            addedDataList.isNotEmpty ? _buildAddedDataList() : const SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _buildAddedDataList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Added Data:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        ListView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: addedDataList.length,
          itemBuilder: (context, index) {
            final data = addedDataList[index];
            return ListTile(
              title: Text('Seller ID: ${data['sellerId']}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Seller Name: ${data['sellerName']}'),
                  Text('City: ${data['city']}'),
                  Text('State: ${data['state']}'),
                  Text('Address: ${data['address']}'),
                  Text('Address Line 2: ${data['address2']}'),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  void _addDataToList() {
    final newData = {
      'sellerId': widget.sellerId,
      'sellerName': widget.sellerName,
      'city': widget.city,
      'state': widget.state,
      'address': widget.address,
      'address2': widget.address2,
    };

    setState(() {
      addedDataList.add(newData);
    });
  }
}

class ListViewScreen extends StatelessWidget {
  final List<Map<String, dynamic>> dataList;

  const ListViewScreen({super.key, required this.dataList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DATA LIST'),
      ),
      body: ListView(
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Perform add functionality
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade900,
                  ),
                  child: const Text(
                    'Add',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // Perform list functionality
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade900,
                  ),
                  child: const Text(
                    'List',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: dataList.length,
            itemBuilder: (context, index) {
              final data = dataList[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text('Seller ID: ${data['sellerId']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Seller Name: ${data['sellerName']}'),
                        Text('City: ${data['city']}'),
                        Text('State: ${data['state']}'),
                        Text('Address: ${data['address']}'),
                        Text('Address Line 2: ${data['address2']}'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ListTile(
                    title: ElevatedButton(
                      onPressed: () {
                        // Perform track order functionality
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade900,
                      ),
                      child: const Text(
                        'Track Sales',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                ],
              );
            },
          ),
          const SizedBox(height: 8.0),
          ElevatedButton(
            onPressed: () {
              // Perform download functionality
              downloadAllData(dataList);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade900,
            ),
            child: const Text(
              'Download All Data',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void downloadAllData(List<Map<String, dynamic>> dataList) async {
    const downloadUrl = 'https://example.com/download';

    if (await canLaunch(downloadUrl)) {
      await launch(downloadUrl);
    } else {
      throw 'Could not launch $downloadUrl';
    }
  }
}
