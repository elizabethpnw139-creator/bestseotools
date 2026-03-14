#!/bin/bash
# Simple validation script for static HTML site

echo "🔍 Validating HTML files..."

# Check all HTML files exist and are readable
for file in *.html; do
    if [ -f "$file" ]; then
        echo "✅ $file exists"
        # Basic HTML validation - check for DOCTYPE and closing tags
        if grep -q "<!DOCTYPE html>" "$file" && grep -q "</html>" "$file"; then
            echo "✅ $file has valid HTML structure"
        else
            echo "❌ $file missing DOCTYPE or closing HTML tag"
            exit 1
        fi
    else
        echo "❌ $file not found"
        exit 1
    fi
done

# Check for broken internal links
echo "🔍 Checking internal links..."
for file in *.html; do
    # Extract href links to .html files (excluding external URLs)
    links=$(grep -o 'href="[^"]*\.html"' "$file" | grep -v "https://" | sed 's/href="//g' | sed 's/"//g')
    for link in $links; do
        if [ -f "$link" ]; then
            echo "✅ Link $link in $file is valid"
        else
            echo "❌ Broken link $link in $file"
            exit 1
        fi
    done
done

echo "🎉 All validations passed!"