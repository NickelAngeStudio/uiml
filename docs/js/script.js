/// Show windows print
function print_section(){
    window.print();
}

/// Toggle side menu when using top bar
function toggle_menu(){
    var sidebar = document.getElementById("sidebar");
    if (sidebar.classList.contains('showed')) {
        sidebar.classList.remove('showed');
    } else {
        sidebar.classList.add('showed');
    }
}

/// Toggle table of content
function toggle_toc(){
    var toc = document.getElementById("toc_content");
    var active = document.getElementById("sdactive");
    if (toc.classList.contains('collapse')) {
        toc.classList.remove('collapse');
        active.classList.remove('collapse');
    } else {
        toc.classList.add('collapse');
        active.classList.add('collapse');
    }
}

/// Toggle table of content
function toggle_tb_toc(){
    var toc = document.getElementById("tocbar");
    var icon = document.getElementById("collapse_icon");
    if (toc.classList.contains('showed')) {
        toc.classList.remove('showed');
        icon.classList.remove('flipTY');
    } else {
        toc.classList.add('showed');
        icon.classList.add('flipTY');
    }
}