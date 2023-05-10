# User interface [modeling language](https://en.wikipedia.org/wiki/Modeling_language)

UIML (not to be confounded by user interface markup language), is a set of platform neutral artificial languages used to develop scalable graphical user interface.

It notably uses states and styles to provide an highly customizable and modulable environment.

## Motivation
I created this standard as a guideline to create my own native, portable, multi-platform user interface engine and want to share my work to the open source community.

This standard can be used either by retained or immediate mode.

## Defining a user interface
TODO : Rewrite below :
>User interface are usually defined by a [MVC pattern](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller). 
>UIML controller is different and define how each component interact with the user via states. The model is all the components. The view are the components choosen. It also define localization as something important.

### Components
Define elements, value, states and transitions of a component.

### Styles
Define how component are displayed according to their states and platform target. Style should be swapable on runtime.

### Dataset
Set of data tuples used by components.

### Localization
Define interface orientation, text orientation, text content and icons for a set of language.

### View
Define components and data showed to the user.


## Inspirations
Multiple elements are inspired from those language :
* C++ for definition
* Rust for components
* CSS for styles
* XML for views
* Android for localization

## Version
TBD : Currently developping the standard.


## License
MIT



