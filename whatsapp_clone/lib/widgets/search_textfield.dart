import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  const SearchField({ Key? key }) : super(key: key);

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {

  bool clearEnabled = false;
  TextEditingController searchField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
              controller: searchField,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        width: 0.8,
                        color: Colors.grey,
                      )),
                  hintText: 'Search Food or Restaurants',
                  hintStyle: const TextStyle(
                    overflow: TextOverflow.visible,
                  ),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.fromLTRB(17, 0, 10, 0),
                    child: Icon(Icons.search),
                  ),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: clearEnabled
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                searchField.clear();
                                clearEnabled = false;
                              });
                            },
                          )
                        : null,
                  )),
              maxLength: 100,
              onChanged: (value) {
                setState(() {
                  value.isNotEmpty ? clearEnabled = true : clearEnabled = false;
                });
              },
            );
  }
}