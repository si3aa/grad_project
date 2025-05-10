#!/bin/bash

# Create MVVM directory structure if it doesn't exist
mkdir -p lib/models
mkdir -p lib/views
mkdir -p lib/viewmodels
mkdir -p lib/services
mkdir -p lib/repositories
mkdir -p lib/utils
mkdir -p lib/constants

# Move files to appropriate directories based on MVVM pattern

# 1. Move model files
echo "Moving model files..."
find lib -name "*_model.dart" -not -path "lib/models/*" -exec mv {} lib/models/ \;
find lib -name "*model.dart" -not -path "lib/models/*" -exec mv {} lib/models/ \;

# 2. Move view files
echo "Moving view files..."
find lib -name "*_screen.dart" -not -path "lib/views/*" -exec mv {} lib/views/ \;
find lib -name "*_page.dart" -not -path "lib/views/*" -exec mv {} lib/views/ \;
find lib -name "*_view.dart" -not -path "lib/views/*" -exec mv {} lib/views/ \;

# 3. Move viewmodel files
echo "Moving viewmodel files..."
find lib -name "*_viewmodel.dart" -not -path "lib/viewmodels/*" -exec mv {} lib/viewmodels/ \;
find lib -name "*viewmodel.dart" -not -path "lib/viewmodels/*" -exec mv {} lib/viewmodels/ \;
find lib -name "*_cubit.dart" -not -path "lib/viewmodels/*" -exec mv {} lib/viewmodels/ \;
find lib -name "*controller.dart" -not -path "lib/viewmodels/*" -exec mv {} lib/viewmodels/ \;

# 4. Move repository files
echo "Moving repository files..."
find lib -name "*_repository.dart" -not -path "lib/repositories/*" -exec mv {} lib/repositories/ \;
find lib -name "*repository.dart" -not -path "lib/repositories/*" -exec mv {} lib/repositories/ \;

# 5. Move service files
echo "Moving service files..."
find lib -name "*_service.dart" -not -path "lib/services/*" -exec mv {} lib/services/ \;
find lib -name "*service.dart" -not -path "lib/services/*" -exec mv {} lib/services/ \;

# 6. Move utility files
echo "Moving utility files..."
find lib -name "*_utils.dart" -not -path "lib/utils/*" -exec mv {} lib/utils/ \;
find lib -name "*utils.dart" -not -path "lib/utils/*" -exec mv {} lib/utils/ \;
find lib -name "*_helper.dart" -not -path "lib/utils/*" -exec mv {} lib/utils/ \;
find lib -name "*helper.dart" -not -path "lib/utils/*" -exec mv {} lib/utils/ \;

# 7. Move constant files
echo "Moving constant files..."
find lib -name "*_constants.dart" -not -path "lib/constants/*" -exec mv {} lib/constants/ \;
find lib -name "*constants.dart" -not -path "lib/constants/*" -exec mv {} lib/constants/ \;
find lib -name "colors.dart" -not -path "lib/constants/*" -exec mv {} lib/constants/ \;
find lib -name "themes.dart" -not -path "lib/constants/*" -exec mv {} lib/constants/ \;

# Find and remove duplicate files
echo "Finding duplicate files..."

# Function to get file content hash
get_hash() {
  md5sum "$1" | awk '{ print $1 }'
}

# Find duplicate files based on content
declare -A file_hashes
find lib -type f -name "*.dart" | while read file; do
  hash=$(get_hash "$file")
  if [[ -n "${file_hashes[$hash]}" ]]; then
    echo "Duplicate found: $file is identical to ${file_hashes[$hash]}"
    # Keep the file in the correct MVVM directory and remove the other
    if [[ "$file" == lib/models/* || "$file" == lib/views/* || "$file" == lib/viewmodels/* || "$file" == lib/services/* || "$file" == lib/repositories/* || "$file" == lib/utils/* || "$file" == lib/constants/* ]]; then
      echo "Removing duplicate: ${file_hashes[$hash]}"
      rm "${file_hashes[$hash]}"
    else
      echo "Removing duplicate: $file"
      rm "$file"
    fi
  else
    file_hashes[$hash]="$file"
  fi
done

# Remove example_usage.dart
echo "Removing example_usage.dart..."
rm -f example_usage.dart

# Remove unused platform-specific directories
# Uncomment the lines for platforms you're not targeting
echo "Removing unused platform directories..."
# rm -rf ios/
# rm -rf macos/
# rm -rf linux/
# rm -rf windows/

# Remove temporary files
echo "Removing temporary files..."
find . -name "*.log" -type f -delete
find . -name ".DS_Store" -type f -delete
find . -name "*.swp" -type f -delete

# Remove any empty directories
echo "Removing empty directories..."
find lib -type d -empty -delete

echo "MVVM reorganization complete. Files have been moved to appropriate directories and duplicates removed."