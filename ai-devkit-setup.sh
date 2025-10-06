#!/bin/bash

# AI DevKit Setup Script (Shell Version)
#
# This script copies cursor rules and prompts from the AI DevKit to the main project's .cursor directory.
# Run this script from the root of the .ai-devkit directory.
#
# Usage: ./ai-devkit-setup.sh
#
# Requirements:
# - bash shell
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

print_warning() {
    print_status "$YELLOW" "⚠️  $1"
}

# Function to copy files from source to target directory
copy_files() {
    local source_dir=$1
    local target_dir=$2
    local description=$3
    local copied_files=0
    
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
    
    print_info "Copying $description..."
    print_info "Source: $(realpath "$source_dir")"
    print_info "Target: $(realpath "$target_dir" 2>/dev/null || echo "$(pwd)/$target_dir")"
    
    # Create target directory structure
    if ! mkdir -p "$target_dir"; then
        print_error "Failed to create target directory: $target_dir"
        return 1
    fi
    
    # Copy each file from source to target
    for file in "$source_dir"/*; do
        if [ -f "$file" ]; then
            filename=$(basename "$file")
            target_file="$target_dir/$filename"
            
            if cp "$file" "$target_file"; then
                print_file "Copied: $filename"
                ((copied_files++))
            else
                print_error "Failed to copy: $filename"
                return 1
            fi
        fi
    done
    
    if [ $copied_files -eq 0 ]; then
        print_error "No files were copied from $source_dir"
        return 1
    fi
    
    print_success "Successfully copied $copied_files $description"
    return 0
}

# Function to handle MCP configuration file
copy_mcp_config() {
    local source_file="mcp/mcp.json"
    local target_file="../.cursor/mcp.json"
    
    # Check if source MCP file exists
    if [ ! -f "$source_file" ]; then
        print_info "No MCP configuration file found in AI DevKit (skipping)"
        return 0
    fi
    
    # Check if target MCP file already exists
    if [ -f "$target_file" ]; then
        print_warning "MCP configuration file already exists at .cursor/mcp.json"
        print_info "The existing MCP configuration was NOT overwritten."
        print_info "We recommend reviewing the AI DevKit's mcp.json file at:"
        print_info "  .ai-devkit/mcp/mcp.json"
        print_info "to see if there are any MCP servers you'd like to add to your project."
        return 0
    fi
    
    # Create target directory if it doesn't exist
    local target_dir=$(dirname "$target_file")
    if ! mkdir -p "$target_dir"; then
        print_error "Failed to create target directory: $target_dir"
        return 1
    fi
    
    # Copy the MCP configuration file
    if cp "$source_file" "$target_file"; then
        print_success "Copied MCP configuration file to .cursor/mcp.json"
        print_info "The AI DevKit's recommended MCP servers are now available in your project."
        return 0
    else
        print_error "Failed to copy MCP configuration file"
        return 1
    fi
}

main() {
    print_status "$BLUE" "🚀 AI DevKit Setup Starting..."
    
    # Verify we're running from the .ai-devkit directory
    current_dir=$(basename "$PWD")
    if [ "$current_dir" != ".ai-devkit" ]; then
        print_error "This script must be run from within the .ai-devkit directory"
        echo "   Current directory: $PWD"
        echo "   Please cd into the .ai-devkit directory and run the script again"
        exit 1
    fi
    
    local total_success=0
    local total_operations=3
    
    # Copy cursor rules
    print_status "$BLUE" "\n📋 Step 1/3: Copying cursor rules..."
    if copy_files "cursor/cursor-rules" "../.cursor/rules/general-use" "cursor rules"; then
        ((total_success++))
    fi
    
    # Copy prompts
    print_status "$BLUE" "\n📝 Step 2/3: Copying prompts..."
    if copy_files "prompts" "../.cursor/prompts/general-use" "prompts"; then
        ((total_success++))
    fi
    
    # Copy MCP configuration
    print_status "$BLUE" "\n🔧 Step 3/3: Setting up MCP configuration..."
    if copy_mcp_config; then
        ((total_success++))
    fi
    
    # Final summary
    print_status "$BLUE" "\n📊 Setup Summary:"
    print_info "Operations completed: $total_success/$total_operations"
    
    if [ $total_success -eq $total_operations ]; then
        print_status "$GREEN" "🎉 Setup complete! AI DevKit resources are now available in your project."
        print_info "- Cursor rules: .cursor/rules/general-use/"
        print_info "- Prompts: .cursor/prompts/general-use/"
        print_info "- MCP config: .cursor/mcp.json (if newly created)"
    else
        print_status "$YELLOW" "⚠️  Setup completed with some errors. Please check the output above."
        exit 1
    fi
}

# Help function
show_help() {
    cat << EOF
AI DevKit Setup Script (Shell Version)

USAGE:
    ./ai-devkit-setup.sh [OPTIONS]

OPTIONS:
    -h, --help    Show this help message

DESCRIPTION:
    This script copies cursor rules and prompts from the AI DevKit to the main
    project's .cursor directory:
    - Cursor rules → .cursor/rules/general-use/
    - Prompts → .cursor/prompts/general-use/
    - MCP config → .cursor/mcp.json (only if it doesn't already exist)

    It must be run from within the .ai-devkit directory.

REQUIREMENTS:
    - bash shell
    - For Windows users: Use Git Bash, WSL, or similar bash environment

EXAMPLES:
    cd .ai-devkit
    ./ai-devkit-setup.sh

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