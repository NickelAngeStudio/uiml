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