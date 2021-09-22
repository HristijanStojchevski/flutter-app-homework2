import 'package:flutter/material.dart';
import 'package:homework2/shared/constants.dart';

class MainStep extends StatelessWidget {
  final Function updateParams;
  String category;
  String name;
  String description;
  MainStep({required this.updateParams, required this.category, required this.name, required this.description});


  @override
  Widget build(BuildContext context) {
    List<String> categories = [
      "Cleaning",
      "Construction",
      "Gardening",
      "Maintainance", //TODO change to Maintenance here and firebase and Swift
      "Repairs",
      "Shopping",
      "quickFix"
    ];

    if(!categories.contains(category)){
      category = '';
    }

    return Container(
      height: 400,
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          DropdownButtonFormField<String>(
            value: category.isEmpty ? null : category,
            items: categories.map((String cat) => DropdownMenuItem(
                value: cat,
                child: Row( mainAxisAlignment: MainAxisAlignment.center, children: [ Icon(Icons.category),SizedBox(width: 20,), Text(cat, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),)],),
            )).toList(),
            onChanged: (String? val) {
              category = val!;
              updateParams(category, name, description);
            },
            icon: const Icon(Icons.arrow_drop_down),
            iconSize: 40,
            style: const TextStyle(color: Colors.blueAccent, fontSize: 16, fontWeight: FontWeight.bold),
            elevation: 14,
            hint: Text('Select a category'),
            decoration: textInputDecoration,
            validator: (val) {
              if (val == null || val.isEmpty) {
                return 'You must select a category !';
              }
            },
          ),
          SizedBox(height: 20.0,),
          TextFormField(
            initialValue: name,
            decoration: textInputDecoration.copyWith(hintText: 'Unique name'),
            validator: (val) {
              if (val == null || val.isEmpty || val.length <= 3) {
                return 'You must enter a name with more than 3 characters!';
              }
            },
            onChanged: (val) {
              name = val;
              updateParams(category, name, description);
            },
          ),
          SizedBox(height: 20.0,),
          TextFormField(
            initialValue: description,
            decoration: textInputDecoration.copyWith(hintText: 'Description'),
            validator: (val) => val == null || val.isEmpty || val.length <= 5 ? 'You must enter a description with more than 5 characters !' : null,
            onChanged: (val) {
              description = val;
              updateParams(category, name, description);
            },
          ),
        ],
      ),
    );
  }
}
