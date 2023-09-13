import 'package:covid_tracker/Services/states_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shimmer/shimmer.dart';

class CountriesListScreen extends StatefulWidget {
  const CountriesListScreen({Key? key}) : super(key: key);

  @override
  State<CountriesListScreen> createState() => _CountriesListScreenState();
}

class _CountriesListScreenState extends State<CountriesListScreen> {
  TextEditingController searchController = TextEditingController();
  List<dynamic>? countriesData;
  List<dynamic> filteredCountriesData = [];

  @override
  Widget build(BuildContext context) {
    StatesServices statesServices = StatesServices();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme
            .of(context)
            .scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    // Update the filtered list when the search text changes
                    filteredCountriesData = filterCountries(value);
                  });
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 20),
                  hintText: "Search with countries",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: statesServices.countriesListApi(),
                builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildLoadingList();
                  } else if (snapshot.hasError) {
                    return _buildErrorWidget();
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return _buildEmptyList();
                  } else {
                    countriesData = snapshot.data;
                    filteredCountriesData =
                    countriesData!; // Initially show all countries
                    return _buildCountryList(filteredCountriesData);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Filter countries based on search text
  List<dynamic> filterCountries(String searchText) {
    return countriesData!.where((country) {
      String name = country['country'].toString().toLowerCase();
      return name.contains(searchText.toLowerCase());
    }).toList();
  }

  Widget _buildLoadingList() {
    return ListView.builder(
      itemCount: 12,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey.shade700,
          highlightColor: Colors.grey.shade100,
          child: Column(
            children: [
              ListTile(
                title: Container(height: 10, width: 89, color: Colors.white),
                subtitle: Container(height: 10, width: 89, color: Colors.white),
                leading: Container(height: 50, width: 50, color: Colors.white),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Text("Error loading data"),
    );
  }

  Widget _buildEmptyList() {
    return Center(
      child: Text("No data available"),
    );
  }

  Widget _buildCountryList(List<dynamic> countries) {
    return ListView.builder(
      itemCount: countries.length,
      itemBuilder: (context, index) {
        String name = countries[index]['country'];
        if (searchController.text.isEmpty ||
            name.toLowerCase().contains(searchController.text.toLowerCase())) {
          return Column(
            children: [
              ListTile(
                title: Text(name),
                subtitle: Text(countries[index]['cases'].toString()),
                leading: Image(
                  height: 50,
                  width: 50,
                  image: NetworkImage(countries[index]['countryInfo']['flag']),
                ),
              ),
            ],
          );
        } else {
          return Container(); // Return an empty container for non-matching items
        }
      },
    );
  }
}







// import 'package:covid_tracker/Services/states_services.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:shimmer/shimmer.dart';
//
// class CountriesListScreen extends StatefulWidget {
//   const CountriesListScreen({Key? key}) : super(key: key);
//
//   @override
//   State<CountriesListScreen> createState() => _CountriesListScreenState();
// }
//
// class _CountriesListScreenState extends State<CountriesListScreen> {
//
//   TextEditingController searchController = TextEditingController();
//   List<dynamic>? countriesData;
//
//   @override
//   Widget build(BuildContext context) {
//     StatesServices statesServices = StatesServices();
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Theme
//             .of(context)
//             .scaffoldBackgroundColor,
//       ),
//       body: SafeArea(
//         child: Column(
//           children: [
//             Padding(
//               padding: EdgeInsets.all(8.0),
//               child: TextFormField(
//                 controller: searchController,
//                 onChanged: (value){
//                   setState(() {
//
//                   });
//                 },
//                 decoration: InputDecoration(
//                     contentPadding: EdgeInsets.symmetric(horizontal: 20),
//                     hintText: "Search with countries",
//                     border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(50)
//                     )
//                 ),
//               ),
//             ),
//
//             Expanded(
//               child: FutureBuilder(
//                 future: statesServices.countriesListApi(),
//                 builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return _buildLoadingList();
//                   } else if (snapshot.hasError) {
//                     return _buildErrorWidget();
//                   } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                     return _buildEmptyList();
//                   } else {
//                     countriesData = snapshot.data;
//                     return _buildCountryList(countriesData, searchController);
//                   }
//                 },
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
// Widget _buildLoadingList() {
//   return ListView.builder(
//     itemCount: 12,
//     itemBuilder: (context, index) {
//       return Shimmer.fromColors(
//         baseColor: Colors.grey.shade700,
//         highlightColor: Colors.grey.shade100,
//         child: Column(
//           children: [
//             ListTile(
//               title: Container(height: 10, width: 89, color: Colors.white),
//               subtitle: Container(height: 10, width: 89, color: Colors.white),
//               leading: Container(height: 50, width: 50, color: Colors.white),
//             ),
//           ],
//         ),
//       );
//     },
//   );
// }
//
// Widget _buildErrorWidget() {
//   return Center(
//     child: Text("Error loading data"),
//   );
// }
//
// Widget _buildEmptyList() {
//   return Center(
//     child: Text("No data available"),
//   );
// }
//
// Widget _buildCountryList(List? countriesData, TextEditingController searchController) {
//   return ListView.builder(
//     itemCount: countriesData!.length,
//     itemBuilder: (context, index) {
//       String name = countriesData![index]['country'];
//       if (searchController.text.isEmpty ||
//           name.toLowerCase().contains(searchController.text.toLowerCase())) {
//         return Column(
//           children: [
//             ListTile(
//               title: Text(countriesData![index]['country'].toString()),
//               subtitle: Text(countriesData![index]['cases'].toString()),
//               leading: Image(
//                 height: 50,
//                 width: 50,
//                 image: NetworkImage(countriesData![index]['countryInfo']['flag']),
//               ),
//             ),
//           ],
//         );
//       } else {
//         return Container();
//       }
//     },
//   );
// }
