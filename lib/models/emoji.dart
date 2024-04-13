import 'dart:convert';

class Emoji {
  final String emoji;
  final String name;
  final String group;
  final String subGroup;
  final String codepoints;

  Emoji({
    required this.emoji,
    required this.name,
    required this.group,
    required this.subGroup,
    required this.codepoints,
  });

  /// return any match regardless of words order, i.e. "face grinning" will match "grinning face"
  bool contains(String query) {
    List<String> queryWords = query.toLowerCase().split(' ');

    String allFields = ("$name $group $subGroup $emoji").toLowerCase();

    return queryWords.every((word) => allFields.contains(word));
  }

  Map<String, dynamic> toMap() {
    return {
      'emoji': emoji,
      'name': name,
      'group': group,
      'sub_group': subGroup,
      'codepoints': codepoints,
    };
  }

  factory Emoji.fromMap(Map<String, dynamic> map) {
    return Emoji(
      emoji: map['emoji'],
      name: map['name'],
      group: map['group'],
      subGroup: map['sub_group'],
      codepoints: map['codepoints'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Emoji.fromJson(String source) => Emoji.fromMap(json.decode(source));
}
