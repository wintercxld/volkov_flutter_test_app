import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:volkov_flutter_test_app/domain/models/card.dart';
import 'package:volkov_flutter_test_app/data/repositories/weather_repository.dart';
import 'package:volkov_flutter_test_app/presentation/details_page/details_page.dart';
import 'package:volkov_flutter_test_app/presentation/dialogs/show_dialog.dart';

part 'card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<CardData>?> searchData;
  final searchController = TextEditingController();
  final repo = WeatherRepository();

  final Set<String> favoriteCities = {};
  List<String> trustedCities = [
    'New York',
    'London',
    'Paris',
    'Berlin',
    'Moscow',
    'Tokyo',
    'Sydney',
    'Los Angeles',
    'Chicago',
    'San Francisco',
    'Rome',
    'Barcelona',
    'Dubai'
  ];

  @override
  void initState() {
    super.initState();
    _loadTrustedCitiesWeather();
  }

  void _loadTrustedCitiesWeather() {
    searchData = repo.getWeatherForCities(
      cities: trustedCities,
      onError: (e) => showErrorDialog(context, error: e),
    );
  }

  void _updateSearchData(String search) {
    searchData = repo.loadData(q: search);
    setState(() {});
  }

  void _toggleFavorite(String city) {
    setState(() {
      if (favoriteCities.contains(city)) {
        favoriteCities.remove(city);
      } else {
        favoriteCities.add(city);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: CupertinoSearchTextField(
                controller: searchController,
                onChanged: (search) {
                  _updateSearchData(search);
                },
              ),
            ),
            Expanded(
              child: Center(
                child: FutureBuilder<List<CardData>?>(
                  future:
                      searchController.text.isEmpty ? searchData : searchData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var data = snapshot.data!;
                      return SingleChildScrollView(
                        child: Column(
                          children: data.map((city) {
                            return _Card.fromData(
                              city,
                              onFavorite: (String title, bool isFavorite) {
                                _toggleFavorite(city.text);
                                _showSnackBar(context, city.text,
                                    favoriteCities.contains(city.text));
                              },
                              onTap: () => _navToDetails(context, city),
                              isFavorite: favoriteCities.contains(city.text),
                            );
                          }).toList(),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    return const CircularProgressIndicator();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navToDetails(BuildContext context, CardData data) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => DetailsPage(data)),
    );
  }

  void _showSnackBar(BuildContext context, String title, bool isFavorite) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          '$title ${isFavorite ? 'в избранном!' : 'не в избранном :('}',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        backgroundColor: Colors.orangeAccent,
        duration: const Duration(seconds: 1),
      ));
    });
  }
}
