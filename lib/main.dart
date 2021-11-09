import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:moor_app/database.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mood demo"),
      ),
      body: const CategoryList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CategoryDetail()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CategoryList extends StatefulWidget {
  const CategoryList({Key? key}) : super(key: key);

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  Future<List> categories = Database().fetchCategories();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
        future: categories,
        builder: (builder, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const CategoryDetail()),
                      );
                    },
                    child: ListTile(
                      title: Text(snapshot.data?[index].description),
                    ),
                  );
                });
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}

class CategoryDetail extends StatefulWidget {
  const CategoryDetail({Key? key}) : super(key: key);

  @override
  _CategoryDetailState createState() => _CategoryDetailState();
}

class _CategoryDetailState extends State<CategoryDetail> {
  TextEditingController categoryNameController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update category"),
      ),
      body: Column(
        children: [
          TextField(
            decoration: const InputDecoration(hintText: 'Category name'),
            keyboardType: TextInputType.text,
            controller: categoryNameController,
          ),
          ElevatedButton(
            onPressed: () {
              Database().insertCategory(CategoriesCompanion(
                  description: drift.Value(categoryNameController.text)));
              Navigator.pop(context);
            },
            child: const Text("Add category"),
          )
        ],
      ),
    );
  }
}
