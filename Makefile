# Find all markdown files in the content directory
MD_FILES := $(shell find ./content -name '*.md')

# Generate corresponding HTML file names
MD_GEN := $(MD_FILES:%.md=%.html)

# Default target: convert all markdown files to HTML
all: $(MD_GEN)

# Find all files in the pandoc directory
PANDOC_FILES := $(shell find pandoc -type f)

# Ensure the site directory exists before generating HTML files
$(shell mkdir -p site/contents/)

# Clean target: remove all generated HTML files
clean:
	rm -f $(MD_GEN)

# Pattern rule to convert markdown files to HTML using Pandoc
%.html: %.md $(PANDOC_FILES)
	@echo "Converting $< to $@"
	pandoc --defaults pandoc/defaults.yml --template=pandoc/template.html $< -o ./$@

# Display the variables for debugging purposes
print:
	@echo "Markdown files: $(MD_FILES)"
	@echo "Generated HTML files: $(MD_GEN)"

