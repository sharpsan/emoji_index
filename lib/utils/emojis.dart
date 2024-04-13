import 'dart:async';
import 'dart:convert';

import 'package:emoji_index/models/emoji.dart';
import 'package:flutter/services.dart';

class Emojis {
  static final Emojis _emojis = Emojis._internal();

  factory Emojis() {
    return _emojis;
  }

  Emojis._internal() {
    _loadEmojis();
  }

  final _completer = Completer<void>();
  late final List<Emoji> _emojiEntries;

  List<Emoji> get emojis => _emojiEntries;

  Map<String, Set<String>> get groupsWithSubgroups {
    final Map<String, Set<String>> groupsWithSubgroups = {};
    for (final emoji in _emojiEntries) {
      if (!groupsWithSubgroups.containsKey(emoji.group)) {
        groupsWithSubgroups[emoji.group] = {};
      }
      groupsWithSubgroups[emoji.group]!.add(emoji.subGroup);
    }
    return groupsWithSubgroups;
  }

  Set<String> get groups {
    final Set<String> groups = {};
    for (final emoji in _emojiEntries) {
      groups.add(emoji.group);
    }
    return groups;
  }

  Set<String> get subGroups {
    final Set<String> subGroups = {};
    for (final emoji in _emojiEntries) {
      subGroups.add(emoji.subGroup);
    }
    return subGroups;
  }

  Future<void> ready() async {
    if (!_completer.isCompleted) {
      await _completer.future;
    }
  }

  Future<void> _loadEmojis() async {
    _emojiEntries = await _getEmojis();
    _completer.complete();
  }

  Future<List<Emoji>> _getEmojis() async {
    final jsonString = await rootBundle.loadString('assets/emoji_dataset.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    final List<Emoji> emojis = List<Emoji>.from(
      jsonMap['emojis'].map((x) => Emoji.fromMap(x)),
    );
    return emojis;
  }
}
