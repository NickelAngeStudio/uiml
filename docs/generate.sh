####################################################
# FILE
# generate.sh
#
# DESCRIPTION
# Automatically generate html file and menus from .md.
# Also generate a all.html with all .md for printing.
#
# USAGE
# $ bash generate.sh
#
# COPYRIGHT
# MIT
#
# NickelAnge.Studio
# 2023-05-11
####################################################

clear

# Change working directory for where the script is located.
cd "$(dirname "$0")"

#############
# CONSTANTS #
#############
# Page template located in template.html
readonly TEMPLATE=$(<template.html)

# Image folder name
readonly IMG_FOLDER="img"

# Markdown folder name
readonly MD_FOLDER="md"

# Array of supported languages
LANGUAGES=()

#############
# FUNCTIONS #
#############
# Get file id (first part of filename)
# $1 = File to extract id
get_fileid() {
	# Extract filename witout path
	local filename=($(echo "$file" | tr '/' '\n'))
    filename="${filename[-1]}"
    
    # Get filename parts by splitting with .
	filename=($(echo "$filename" | tr '.' '\n'))
	
	# Get file id
	echo "${filename[0]}"
}

# Get file index (last ## of first part)
# $1 = File to extract index
get_fileindex() {
	local file_id=$(get_fileid "$1")
	
	# Get index of the file (last 2 numbers)
	echo $(echo "${file_id}" | cut -c 3-4)
}

# Get section name from file
# $1 = File to extract section from
get_section() {
	# Extract filename witout path
	local filename=($(echo "$file" | tr '/' '\n'))
    filename="${filename[-1]}"
    
    # Get filename parts by splitting with .
	filename=($(echo "$filename" | tr '.' '\n'))
	
	# Get section name
	echo "${filename[1]}"
}

# Generate side bar template from folder.
# $1 = Folder to generate side bar template from.
generate_sidebar() {
	local sidemenu=""
	
	# For each file
    for file in "$(echo $1)md"/*; do    	
    	# Get index of the file (last 2 numbers)
    	local index=$(get_fileindex "$file")
    	
    	# Section headers index is 00
    	if [[ "$index" == "00" ]]; then
    		local fileid=$(get_fileid "$file")
			local section=$(get_section "$file")
			
			if [[ "$fileid" == "0000" ]]; then 
				sidemenu="$sidemenu<a class=\"_${section}\" href=\"index.html\">${section^}</a><div class=\"\"></div>"
			else
				sidemenu="$sidemenu<a class=\"_${section}\" href=\"$section.html\">${section^}</a>"
			fi
		fi
		
	done
	
	echo "$sidemenu"
}


# Init supported languages
# $1 = Folder of version
init_languages() {
	LANGUAGES=() 	# Reset languages array
	
	# Fetch each language
	for lang in "$(echo $1)"*; do
		local dirname=($(echo "$lang" | tr '/' '\n'))
		if [[ "${dirname[1]}" != "$IMG_FOLDER" ]]; then 
			LANGUAGES+=("${dirname[1]}")
		fi
	done
}


############
# GENERATE #
############


# For each version directory
for directory in */ ; do
    
    # Init supported languages
    init_languages $directory
    
    # For each supported languages
    for language in "${LANGUAGES[@]}"
	do
		dir="$directory$language/"

		# Generate side bar
    	f_sidebar="$(generate_sidebar $dir)"
    	
    	 # For each markdown file
		for file in "$(echo $dir)md"/*; do
			# Get id of the file
			f_id=$(get_fileid "$file")
		
			# Get index of the file (last 2 numbers)
			f_index=$(get_fileindex "$file")
			
			# Get section name
			f_section=$(get_section "$file")			
			
			# Generate content html with pandoc
			f_content=$(pandoc -f gfm "$file")
			
			# Generate file html from template
			f_sidebar_section=$(echo "${f_sidebar//_${f_section}/active}") 
			
			f_html=$(echo "${TEMPLATE//%section/${f_section^}}") 
			f_html=$(echo "${f_html//%sidebar/$f_sidebar_section}") 
			f_html=$(echo "${f_html//%content/$f_content}") 
			
			if [[ "$f_id" == "0000" ]]; then # Written to index.html
				echo "Generating $language/index.html ..."
				echo "$f_html" > "$(echo $dir)index.html"
			else
				echo "Generating $language/$f_section.html ..."
				echo "$f_html" > "$(echo $dir)$f_section.html"
			fi
		done
		
		# TODO:Generate all.html
	done
done





