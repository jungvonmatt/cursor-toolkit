#!/bin/bash

# AI DevKit Update Script
#
# This script updates the AI DevKit submodule to the latest version and
# propagates any changes to the main project's .cursor directory (rules and prompts).
#
# Usage: ./ai-devkit-update.sh
#
# Requirements:
# - bash shell
# - git
# - For Windows users: Use Git Bash, WSL, or similar bash environment

set -e  # Exit on any error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

print_error() {
    print_status "$RED" "❌ Error: $1"
}

print_success() {
    print_status "$GREEN" "✅ $1"
}

print_info() {
    print_status "$BLUE" "📂 $1"
}

print_file() {
    print_status "$YELLOW" "📄 $1"
}

# Function to copy and update files from source to target directory
copy_and_update_files() {
    local source_dir=$1
    local target_dir=$2
    local description=$3
    local copied_files=0
    local updated_files=0
    
    # Verify source directory exists
    if [ ! -d "$source_dir" ]; then
        print_error "Source directory '$source_dir' not found"
        return 1
    fi
    
    # Check if source directory has files
    if [ ! "$(ls -A "$source_dir" 2>/dev/null)" ]; then
        print_error "Source directory '$source_dir' is empty or inaccessible"
        return 1
    fi
    
    print_info "Updating $description..."
    print_info "Source: $(realpath "$source_dir")"
    print_info "Target: $(realpath "$target_dir" 2>/dev/null || echo "$(pwd)/$target_dir")"
    
    # Create target directory structure if it doesn't exist
    if ! mkdir -p "$target_dir"; then
        print_error "Failed to create target directory: $target_dir"
        return 1
    fi
    
    # Copy each file from source to target
    for file in "$source_dir"/*; do
        if [ -f "$file" ]; then
            filename=$(basename "$file")
            target_file="$target_dir/$filename"
            
            # Check if file exists and has changed
            if [ -f "$target_file" ]; then
                if ! cmp -s "$file" "$target_file"; then
                    if cp "$file" "$target_file"; then
                        print_file "Updated: $filename"
                        ((updated_files++))
                    else
                        print_error "Failed to update: $filename"
                        return 1
                    fi
                else
                    ((copied_files++))
                fi
            else
                if cp "$file" "$target_file"; then
                    print_file "Added new: $filename"
                    ((updated_files++))
                else
                    print_error "Failed to copy: $filename"
                    return 1
                fi
            fi
        fi
    done
    
    # Summary for this operation
    if [ $updated_files -eq 0 ]; then
        print_info "All $description are already up to date ($copied_files files unchanged)"
    else
        print_success "Updated $updated_files $description"
        if [ $copied_files -gt 0 ]; then
            print_info "$copied_files files were already up to date"
        fi
    fi
    
    # Return the number of updated files for overall summary
    return $updated_files
}

main() {
    print_status "$BLUE" "🚀 AI DevKit Update Starting..."
    
    # Verify we're running from the .ai-devkit directory
    current_dir=$(basename "$PWD")
    if [ "$current_dir" != ".ai-devkit" ]; then
        print_error "This script must be run from within the .ai-devkit directory"
        echo "   Current directory: $PWD"
        echo "   Please cd into the .ai-devkit directory and run the script again"
        exit 1
    fi
    
    # Save current HEAD to detect changes
    initial_commit=$(git rev-parse HEAD 2>/dev/null || echo "unknown")
    print_info "Current AI DevKit version: ${initial_commit:0:7}"
    
    # Update the submodule from parent directory
    print_info "Updating AI DevKit submodule..."
    cd ..
    if git submodule update --remote .ai-devkit; then
        print_success "Submodule updated successfully"
    else
        print_error "Failed to update submodule"
        exit 1
    fi
    cd .ai-devkit
    
    # Check if there were any updates
    new_commit=$(git rev-parse HEAD 2>/dev/null || echo "unknown")
    if [ "$initial_commit" = "$new_commit" ]; then
        print_info "AI DevKit is already up to date (${new_commit:0:7})"
        print_info "No updates needed for cursor rules or prompts"
        exit 0
    fi
    
    print_success "Updated AI DevKit from ${initial_commit:0:7} to ${new_commit:0:7}"
    
    # Now propagate updates to cursor rules and prompts
    local total_updated=0
    local total_operations=2
    local operation_success=0
    
    # Update cursor rules
    print_status "$BLUE" "\n📋 Step 1/2: Updating cursor rules..."
    if copy_and_update_files "cursor/cursor-rules" "../.cursor/rules/general-use" "cursor rules"; then
        local rules_updated=$?
        total_updated=$((total_updated + rules_updated))
        ((operation_success++))
    fi
    
    # Update prompts
    print_status "$BLUE" "\n📝 Step 2/2: Updating prompts..."
    if copy_and_update_files "prompts" "../.cursor/prompts/general-use" "prompts"; then
        local prompts_updated=$?
        total_updated=$((total_updated + prompts_updated))
        ((operation_success++))
    fi
    
    # Final summary
    print_status "$BLUE" "\n📊 Update Summary:"
    print_info "Operations completed: $operation_success/$total_operations"
    print_info "Total files updated: $total_updated"
    
    if [ $operation_success -eq $total_operations ]; then
        print_status "$GREEN" "🎉 Update complete! AI DevKit resources are now up to date."
        print_info "- Cursor rules: .cursor/rules/general-use/"
        print_info "- Prompts: .cursor/prompts/general-use/"
        
        # Show git status reminder
        print_status "$BLUE" "\n📝 Next steps:"
        print_info "Don't forget to commit the submodule update:"
        echo "   cd .."
        echo "   git add .ai-devkit"
        echo "   git commit -m \"Update AI DevKit to latest version\""
    else
        print_status "$YELLOW" "⚠️  Update completed with some errors. Please check the output above."
        exit 1
    fi
}

# Help function
show_help() {
    cat << EOF
AI DevKit Update Script

USAGE:
    ./ai-devkit-update.sh [OPTIONS]

OPTIONS:
    -h, --help    Show this help message

DESCRIPTION:
    This script updates the AI DevKit submodule to the latest version and
    propagates any changes to the main project's .cursor directory:
    - Cursor rules → .cursor/rules/general-use/
    - Prompts → .cursor/prompts/general-use/

    It must be run from within the .ai-devkit directory.

REQUIREMENTS:
    - bash shell
    - git
    - For Windows users: Use Git Bash, WSL, or similar bash environment

EXAMPLES:
    cd .ai-devkit
    ./ai-devkit-update.sh

EOF
}

# Parse command line arguments
case "${1:-}" in
    -h|--help)
        show_help
        exit 0
    ;;
    "")
        main
    ;;
    *)
        print_error "Unknown option: $1"
        echo "Use -h or --help for usage information"
        exit 1
    ;;
esac