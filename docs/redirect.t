<script>
    // Latest version of document
    const latest = "%latest/";

    // List of currently supported translations
    const supported = ["en"];

    // Redirection according to user navigator language
    // Ref = https://stackoverflow.com/questions/1043339/javascript-for-detecting-browser-language-preference/46514247#46514247
    let lang = window.navigator.languages ? window.navigator.languages[0] : null;
    lang = lang || window.navigator.language || window.navigator.browserLanguage || window.navigator.userLanguage;

    let shortLang = lang;
    if (shortLang.indexOf('-') !== -1)
        shortLang = shortLang.split('-')[0];

    if (shortLang.indexOf('_') !== -1)
        shortLang = shortLang.split('_')[0];

    // Redirect to most recent specifications according to language.
    if(supported.includes(shortLang))
        location.href= latest + shortLang;  // Language is supported, redirect to it
    else
        location.href= latest + supported[0];    // Language isn't supported, redirect to first supported language
</script>

<!DOCTYPE html><html><head><title>User interface modeling language specifications</title>
    <meta charset="UTF-8">
    <meta name="description" content="User interface modeling language specifications">
    <meta name="keywords" content="UIML User interface modeling language specifications">
    <meta name="author" content="NickelAngeStudio">
    <meta name="generator" content="Github workflow with generate.sh">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body>

Redirecting to latest version... <a href="%latest/en">Click here if nothing happen</a>

</body>
</html>



