import 'dart:io';

void main() async {
  final libDir = Directory('lib');
  if (!await libDir.exists()) {
    print('lib directory not found');
    return;
  }
  
  // Get all Dart files
  final dartFiles = <File>[];
  await for (final entity in libDir.list(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      dartFiles.add(entity);
    }
  }
  
  // Create a mapping of old paths to new paths
  final pathMapping = <String, String>{};
  for (final file in dartFiles) {
    final relativePath = file.path.replaceFirst('lib/', '');
    final fileName = file.path.split('/').last;
    
    // Determine the new path based on file name and content
    String newPath = relativePath; // Default to current path
    
    if (fileName.contains('_model') || fileName.contains('model.dart')) {
      newPath = 'models/$fileName';
    } else if (fileName.contains('_screen') || fileName.contains('_page') || fileName.contains('_view')) {
      newPath = 'views/$fileName';
    } else if (fileName.contains('_viewmodel') || fileName.contains('viewmodel') || 
               fileName.contains('_cubit') || fileName.contains('controller')) {
      newPath = 'viewmodels/$fileName';
    } else if (fileName.contains('_repository') || fileName.contains('repository')) {
      newPath = 'repositories/$fileName';
    } else if (fileName.contains('_service') || fileName.contains('service')) {
      newPath = 'services/$fileName';
    } else if (fileName.contains('_utils') || fileName.contains('utils') || 
               fileName.contains('_helper') || fileName.contains('helper')) {
      newPath = 'utils/$fileName';
    } else if (fileName.contains('_constants') || fileName.contains('constants') || 
               fileName == 'colors.dart' || fileName == 'themes.dart') {
      newPath = 'constants/$fileName';
    }
    
    if (newPath != relativePath) {
      pathMapping[relativePath] = newPath;
    }
  }
  
  // Update imports in all Dart files
  int filesUpdated = 0;
  for (final file in dartFiles) {
    bool fileChanged = false;
    final content = await file.readAsString();
    String updatedContent = content;
    
    for (final entry in pathMapping.entries) {
      final oldImport = "import 'package:Herfa/${entry.key}';";
      final newImport = "import 'package:Herfa/${entry.value}';";
      
      if (updatedContent.contains(oldImport)) {
        updatedContent = updatedContent.replaceAll(oldImport, newImport);
        fileChanged = true;
      }
      
      // Also handle relative imports
      final oldRelativeImport = "import '../${entry.key.split('/').last}';";
      final newRelativeImport = "import 'package:Herfa/${entry.value}';";
      
      if (updatedContent.contains(oldRelativeImport)) {
        updatedContent = updatedContent.replaceAll(oldRelativeImport, newRelativeImport);
        fileChanged = true;
      }
    }
    
    if (fileChanged) {
      await file.writeAsString(updatedContent);
      filesUpdated++;
    }
  }
  
  print('Updated imports in $filesUpdated files');
}