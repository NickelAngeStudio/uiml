# Documentation

Documentation web pages are automatically generated via the bash script `generate.md`.

For each version, it generate documentation for each language using the `md` files and wrap them using `template.html`.

# Nomenclature
## Folders
The `version` is always the base folder in `docs/`. In that folder, we add supported languages and an `img` folder. the `img` folder is used to stored images and diagrams for that version only.

### Example
```
1.0.0/en
1.0.0/fr
1.0.0/img
```

In each language folder, we add a folder called `md` which will contains the documentation to be generated.

### Example
```
1.0.0/en/md
1.0.0/fr/md
```

## Markdown files
Each markdown filenames start with 4 digits to put section in orders. The 2 firsts represent the section and the 2 lasts the sub-section. File `0000` is usually the home file and is translated to `index.html`.

The first line of each `md` is used as section name.

Each language must have the same `md` filenames.

## template.html

The template file has multiples sections that are filled by the bash script. All those section name start with modulo `%`.

- **%section** : Name of the section.
- **%sidebar** : Links generated in the sidebar.
- **%toc** : Table of content.
- **%languages** : Languages links.
- **%content** : Content of the section generated via [pandoc](https://pandoc.org/).
- **%version** : Version of the specifications (taken from folder name).
- **%previous** : Label of previous link.
- **%prev_link** : Link to previous section.
- **%next** : Label of next link.
- **%next_link** : Link to next section.