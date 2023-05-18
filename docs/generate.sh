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

# CSS folder name
readonly CSS_FOLDER="css"

# JS folder name
readonly JS_FOLDER="js"

# Markdown folder name
readonly MD_FOLDER="md"

# Special folder name
readonly SPECIAL_FOLDER="$IMG_FOLDER,$CSS_FOLDER,$JS_FOLDER,$MD_FOLDER"

# Array of supported languages
LANGUAGES=()

# Array of sections names
SECTION_NAMES=()

# Array of sections titles
SECTION_TITLES=()

# Array of tags to remove in table of content
TOC_TAG_REMOVE=("strong" "pre" "u" "ins" "p" "em")

#############
# FUNCTIONS #
#############
# Get file/folder without full path
# $1 = File or folder
get_relpath() {
	# Extract last part
	local paths=($(echo "$1" | tr '/' '\n'))
	local last_part="${paths[-1]}"
	
	# Remove /
	last_part=$(echo "${last_part}" | sed 's/\///g')
	
	# Return result
    echo "$last_part"
}

# Get file id (first part of filename)
# $1 = File to extract id
get_fileid() {
	# Extract filename witout path
	local filename=$(get_relpath $1)
    
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
	local filename=$(get_relpath $1)
    
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
    for file in "$(echo $1)$MD_FOLDER"/*; do    	
    	# Get index of the file (last 2 numbers)
    	local index=$(get_fileindex "$file")
    	
    	# Section headers index is 00
    	if [[ "$index" == "00" ]]; then
    		local fileid=$(get_fileid "$file")
			local section=$(get_section "$file")
			
			# Read first line to get section name
			local section_name=$(get_section_name "$file")

			if [[ "$fileid" == "0000" ]]; then 
				sidemenu="$sidemenu<a class=\"sidelink _${section}\" href=\"index.html\">${section_name^}</a>"
			else
				sidemenu="$sidemenu<a class=\"sidelink _${section}\" href=\"$section.html\">${section_name^}</a>"
			fi
		fi
		
	done
	
	echo "$sidemenu"
}

# Read the first line and return section name
# $1 = File to get section name
get_section_name() {
	# Read first line to get section name
	local section_name=$(head -n 1 "$1")

	# Remove # and trim section name
	section_name=$(echo "${section_name}" | sed 's/#//g')
	section_name=$(echo "${section_name}" | sed 's/ *$//g')

	echo $section_name
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

# Generate css .min and js.min
generate_min_files(){
	local css="";
	local js="";

	# Generate css mins
	for css in "$(echo $CSS_FOLDER)"/*; do
		# Get css name
		local css_min_name=$(get_fileid $css)
		css_min_name="${css_min_name}.min.css"
		local min_content=$(yui-compressor $css)

		# Write to file
		echo "Generating $(echo $CSS_FOLDER)/$css_min_name ..."
		echo "$min_content" > "$(echo $CSS_FOLDER)/$css_min_name"
	done


	# Generate js mins
	for js in "$(echo $JS_FOLDER)"/*; do
		# Get js name
		local js_min_name=$(get_fileid $js)
		js_min_name="${js_min_name}.min.js"
		local js_content=$(yui-compressor $js)

		# Write to file
		echo "Generating $(echo $JS_FOLDER)/$js_min_name ..."
		echo "$js_content" > "$(echo $JS_FOLDER)/$js_min_name"
	done

}

# Get section files and names
# $1 = Directory to fetch sections files and names
get_section_files_and_names(){
	# Reset arrays
	SECTION_TITLES=()
	SECTION_NAMES=()

	for file in "$(echo $1)$MD_FOLDER"/*; do    

		# Get section and add to SECTION SECTION_NAMES
		local section=$(get_section "$file")
		SECTION_NAMES+=("${section}")

		# Read first line to get section name and add to SECTION_TITLES
		local section_name=$(get_section_name "$file")
		SECTION_TITLES+=("${section_name}")
		
	done
}

# Write previous and next section in top bar
write_previous_next_section(){
	# Length of elements in section names
	local section_len=${#SECTION_NAMES[@]}

	for (( i=0; i<$section_len; i++ )); do 
		if [[ "$f_section" == "${SECTION_NAMES[$i]}" ]]; then
			if (( $i > 0 )) ; then	# Write previous
				local index=$i-1
				if (( $index == 0 )) ; then		# Index 0 is always index.html
					f_html=$(echo "${f_html//%prev_link/index.html}") 
				else
					f_html=$(echo "${f_html//%prev_link/${SECTION_NAMES[$index]}.html}") 
				fi
				
				f_html=$(echo "${f_html//%previous/&lt; ${SECTION_TITLES[$index]}}") 
			else	# Empty previous
				f_html=$(echo "${f_html//%previous/''}") 
			fi

			if (( $i < $section_len-1 )) ; then	# Write next
				local index=$i+1
				f_html=$(echo "${f_html//%next_link/${SECTION_NAMES[$index]}.html}") 
				f_html=$(echo "${f_html//%next/${SECTION_TITLES[$index]} &gt;}") 
			else	# Empty next
				f_html=$(echo "${f_html//%next/''}") 
			fi
		fi
	done

}

# Get table of content
get_table_of_content() {
	local headers=( $(echo "$f_content" | grep -P '<h[1-3].*>.*<\/h[1-3]>') )

	# Accumulate and concatenete headers
	local toc=""
	for h in "${headers[@]}"
	do 
		toc="${toc}${h} "
	done

	# Remove tags
	for tag in "${TOC_TAG_REMOVE[@]}"
	do 
		toc=$(echo "${toc//<$tag>/''}") 
		toc=$(echo "${toc//<\/$tag>/''}") 
	done

	# Write headers
	for (( i=0; i<6; i++ )); do 
		toc=$(echo "${toc//h${i} id=\"/a class=\"s h${i}\" href=\"#}") 
		toc=$(echo "${toc//<\/h${i}>/<\/a>}") 
	done

	
	echo $toc
}

############
# GENERATE #
############
# Generate .min of css and js
generate_min_files

# For each version directory
for directory in */ ; do

	f_version=$(echo "${directory}" | sed 's/\///g')

	if [[ "$SPECIAL_FOLDER" != *"$f_version"* ]]; then # Make sure it isnt an special folder	
		# Init supported languages
		init_languages $directory
		
		# For each supported languages
		for language in "${LANGUAGES[@]}"
		do
			dir="$directory$language/"

			# Get array of sections files and names
			get_section_files_and_names "$dir"

			

			# All documentation
			f_all=""

			# Generate side bar
			f_sidebar="$(generate_sidebar $dir)"
			
			 # For each markdown file
			for file in "$(echo $dir)$MD_FOLDER"/*; do
				# Get id of the file
				f_id=$(get_fileid "$file")
			
				# Get index of the file (last 2 numbers)
				f_index=$(get_fileindex "$file")
				
				# Get section name
				f_section=$(get_section "$file")

				# Get section name
				f_section_name=$(get_section_name "$file")			
				
				# Generate content html with pandoc
				f_content=$(pandoc -f gfm "$file")	

				# Path of the file
				f_path="$f_section.html"
				if [[ "$f_id" == "0000" ]]; then # Written to index.html
					f_path="index.html"
				else
					# Add pandoc content to all.html
					f_all="${f_all}${f_content}"
				fi
				
				# Generate file html from template
				f_html=$(echo "${TEMPLATE//%section/${f_section_name^}}") 

				# Generate side bar
				f_sidebar_section=$(echo "${f_sidebar//_${f_section}/active}") 
				f_html=$(echo "${f_html//%sidebar/$f_sidebar_section}") 

				#write_table_of_content	# Write table of content
				toc_content=$(get_table_of_content)
				f_html=$(echo "${f_html//%toc/$toc_content}") 

				# Generate language
				f_lng=""
				for lng in "${LANGUAGES[@]}"
				do
					if [[ "$lng" == "$language" ]]; then # Current language
						f_lng="${f_lng}<a href="../$(echo $lng)/$f_path" class=\"lng active\">${lng^^}</a>"
					else
						f_lng="${f_lng}<a href="../$(echo $lng)/$f_path" class=\"lng\">${lng^^}</a>"
					fi
				done
				f_html=$(echo "${f_html//%languages/$f_lng}") 
				f_html=$(echo "${f_html//%content/$f_content}") 
				f_html=$(echo "${f_html//%version/$f_version}") 

				# Write previous and next section in top bar
				write_previous_next_section

				echo "Generating $(echo $dir)$f_path ..."
				echo "$f_html" > "$(echo $dir)$f_path"
			done
			
			# Generate file html from template for all.html
			f_html=$(echo "${TEMPLATE//%section/\"\"}") 
			f_html=$(echo "${f_html//%sidebar/$f_sidebar}") 

			# Generate language
			f_lng=""
			for lng in "${LANGUAGES[@]}"
			do
				if [[ "$lng" == "$language" ]]; then # Current language
					f_lng="${f_lng}<a href="../$(echo $lng)/all.html" class=\"lng active\">${lng^^}</a>"
				else
					f_lng="${f_lng}<a href="../$(echo $lng)/all.html" class=\"lng\">${lng^^}</a>"
				fi
			done

			# Remove previous and next
			f_html=$(echo "${f_html//%previous/''}") 
			f_html=$(echo "${f_html//%next/''}") 

			f_html=$(echo "${f_html//%languages/$f_lng}") 
			f_html=$(echo "${f_html//%content/$f_all}") 
			f_html=$(echo "${f_html//%version/$f_version}") 
			f_html=$(echo "${f_html//%toc/''}") 

			echo "Generating $language/all.html ..."
			echo "$f_html" > "$(echo $dir)all.html"
		done
	fi
done





