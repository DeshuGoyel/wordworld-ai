import 'dart:io';

void main() {
  final dir = Directory('lib');
  int totalReplaced = 0;
  
  for (final file in dir.listSync(recursive: true)) {
    if (file is File && file.path.endsWith('.dart')) {
      String content = file.readAsStringSync();
      if (content.contains('.withOpacity(')) {
        int replacedInFile = 0;
        final newContent = content.replaceAllMapped(
          RegExp(r'\.withOpacity\(([^)]+)\)'),
          (match) {
            replacedInFile++;
            totalReplaced++;
            return '.withValues(alpha: ${match.group(1)})';
          }
        );
        file.writeAsStringSync(newContent);
        print('Updated ${file.path} ($replacedInFile replacements)');
      }
    }
  }
  print('Total replacements: $totalReplaced');
}
