import 'package:flutter/material.dart';
import 'package:untitled/db_helper.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> _allData = [];

  bool _isLoading = true;

  void _refreshData() async {
    final data = await SQLHelper.getAllData();
    setState(() {
      _allData = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshData();
  }

  Future<void> _addData() async {
    await SQLHelper.createData(
      _brandController.text,
      _modelController.text,
      _colorController.text,
      _priceController.text
    );
    _refreshData();
  }

  Future<void> _updateData(int id) async {
    await SQLHelper.updateData(
      id,
      _brandController.text,
      _modelController.text,
      _colorController.text,
      _priceController.text
    );
    _refreshData();
  }

  void _deleteData(int id) async {
    await SQLHelper.deleteData(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.redAccent, content: Text("Data Deleted")));
    _refreshData();
  }

  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _colorController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  void showBottomSheet(int? id) async {
    if (id != null) {
      final existingData =
      _allData.firstWhere((element) => element['id'] == id);
      _brandController.text = existingData['brand'];
      _modelController.text = existingData['model'];
      _colorController.text = existingData['color'];
      _priceController.text = existingData['price'];
    }
    showModalBottomSheet(
      elevation: 5,
      isScrollControlled: true,
      context: context,
      builder: (_) => Container(
        padding: EdgeInsets.only(
          top: 30,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 50,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              controller: _brandController,
              decoration: const InputDecoration(
                label: Text("Brand"),
                border: OutlineInputBorder(),
                hintText: "Brand",
              ),
            ),
            const SizedBox(height: 4),
            TextField(
              controller: _modelController,
              decoration: const InputDecoration(
                  label: Text("Model"),
                  border: OutlineInputBorder(),
                  hintText: "Model"
              ),
            ),
            const SizedBox(height: 4),
            TextField(
              controller: _colorController,
              decoration: const InputDecoration(
                  label: Text("Color"),
                  border: OutlineInputBorder(),
                  hintText: "Color"
              ),
            ),
            const SizedBox(height: 4),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(
                  label: Text("Price"),
                  border: OutlineInputBorder(),
                  hintText: "Price"
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  if (id == null) {
                    await _addData();
                  }
                  if (id != null) {
                    await _updateData(id);
                  }
                  _brandController.text = "";
                  _modelController.text = "";
                  _colorController.text = "";
                  _priceController.text = "";
                  Navigator.of(context).pop();
                  print("Data Added");
                },
                child: Padding(
                  padding: EdgeInsets.all(18),
                  child: Text(
                    id == null ? "Add Data" : "Update",
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECEAF4),
      appBar: AppBar(title: const Text("CRUD Operations")),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _allData.length,
              itemBuilder: (context, index) => Card(
                margin: const EdgeInsets.all(15),
                child: ListTile(
                  title:
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Brand: ",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                            Text(
                            _allData[index]['brand'],
                            style: const TextStyle(
                                fontSize: 20
                            ),
                          ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              "Model: ",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                            Text(
                              _allData[index]['model'],
                              style: const TextStyle(
                                  fontSize: 20
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              "Color: ",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                            Text(
                              _allData[index]['color'],
                              style: const TextStyle(
                                  fontSize: 20
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  subtitle: Text(_allData[index]['price']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          showBottomSheet(_allData[index]['id']);
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.indigo,
                        )
                      ),
                      IconButton(
                        onPressed: (){
                          _deleteData(_allData[index]['id']);
                        },
                        icon: const Icon(
                            Icons.delete,
                          color: Colors.redAccent,
                        )
                      )
                    ],
                  )
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => showBottomSheet(null),
          child: const Icon(Icons.add)
      ),
    );
  }
}
