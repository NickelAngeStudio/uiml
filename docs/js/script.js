/// Show windows print
function print_section(){
    window.print();
}

/// Toggle side menu when using top bar
function toggle_menu(){
    var sidebar = document.getElementById("sidebar");
    var content = document.getElementById("content");

    if (sidebar.classList.contains('hide')) {
        sidebar.classList.remove('hide');
        content.classList.remove('fill');
        sidebar.classList.remove('showed');
    } else {
        sidebar.classList.add('hide');
        content.classList.add('fill');
        sidebar.classList.add('showed');
    }
}

/// Toggle table of content bar for full layout
function toggle_ftoc(){

    var collapse = document.getElementById("colf_icon");
    var tocbar = document.getElementById("tocbar");

    if (collapse.classList.contains('flipTY')) {
        collapse.classList.remove('flipTY');
        tocbar.classList.add('hide');
    } else {
        collapse.classList.add('flipTY');
        tocbar.classList.remove('hide');
    }
}

/// Toggle table of content bar for partial layout
function toggle_ptoc(){

    var collapse = document.getElementById("colp_icon");
    var tocbar = document.getElementById("tocbar");

    if (collapse.classList.contains('flipTY')) {
        collapse.classList.remove('flipTY');
        tocbar.classList.remove('showed');
    } else {
        collapse.classList.add('flipTY');
        tocbar.classList.add('showed');
    }
}