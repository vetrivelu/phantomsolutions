import 'package:flutter/material.dart';
import 'package:phantomsolutions/country.dart';
import 'package:phantomsolutions/services/location_controller.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    fetchLoactions();

    super.initState();
  }

  int pageNumber = 1;
  bool isLoadin = false;

  void fetchLoactions() {
    setState(() {
      isLoadin = true;
      countries = LocationController().fetchLocations(search.text, pageNumber);
      isLoadin = false;
    });
  }

  List<Country> countries = [];
  final TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Countries"),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(100.0), // here the desired height
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: search,
                      decoration: const InputDecoration(border: OutlineInputBorder()),
                      onChanged: (val) {
                        if (val.isEmpty) {
                          pageNumber = 1;
                          fetchLoactions();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  FloatingActionButton(onPressed: fetchLoactions, child: const Icon(Icons.search))
                ],
              ),
            ),
          ),
        ),
        body: LazyLoadScrollView(
            isLoading: isLoadin,
            child: ListView.builder(
                itemCount: countries.length,
                itemBuilder: (context, index) {
                  return getCountryTie(countries[index]);
                }),
            onEndOfPage: () {
              pageNumber++;
              fetchLoactions();
            }));
  }

  getCountryTie(Country e) => ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(e.flagUrl),
        ),
        trailing: IconButton(
            onPressed: () {
              e.delete().then((value) {
                fetchLoactions();
              });
              setState(() {});
            },
            icon: const Icon(Icons.delete)),
        title: Text("${e.name} (${e.countryCode})"),
        subtitle: Text(e.currencies.fold('', (previousValue, element) => "$previousValue, ${element.code}").replaceFirst(",", '')),
      );
}
