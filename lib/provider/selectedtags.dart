import 'package:flutter/material.dart';

class Tags with ChangeNotifier {
  List<String> selectedTags = [];
  List<String> selectedTagsUser = [];

  void addTag({String? tagName, int? index}) {
    // selectedTags[index!] = tagName!;
    selectedTags.add(tagName!);

    notifyListeners();
  }

  void addTagUser({String? tagName, int? index}) {
    // selectedTags[index!] = tagName!;
    selectedTagsUser.add(tagName!);

    notifyListeners();
  }

  void deleteTagName({String? tagName, int? index}) {
    selectedTags[index!] = "nothing";
    notifyListeners();
  }

  void deleteTagNameUser({String? tagName, int? index}) {
    selectedTagsUser[index!] = "nothing";
    notifyListeners();
  }
}
