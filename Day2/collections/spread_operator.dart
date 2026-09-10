void main() {
  List<String> first = ['Flutter', 'Dart'];
  List<String> second = ['Firebase', 'Git'];

  List<String> skills = [...first, ...second];

  print(skills);
}