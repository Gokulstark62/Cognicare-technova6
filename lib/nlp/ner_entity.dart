/// A single named entity detected in text.
class NerEntity {
  final NerType type;
  final String value; // the matched text
  final int startIndex;
  final int endIndex;

  NerEntity({
    required this.type,
    required this.value,
    required this.startIndex,
    required this.endIndex,
  });

  @override
  String toString() =>
      '${type.name}("$value") @[$startIndex-$endIndex]';
}

enum NerType {
  date,
  time,
  person,
  place,
  task,
  number,
}