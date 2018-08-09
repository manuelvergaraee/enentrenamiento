/* Ckeditor global configuration file */

CKEDITOR.editorConfig = function (config) {
    // Define changes to default configuration here.
    // For complete reference see:
    // http://docs.ckeditor.com/#!/api/CKEDITOR.config

    // Remove some buttons provided by the standard plugins, which are
    // not needed in the Standard(s) toolbar.
    //config.removeButtons = 'Underline,Subscript,Superscript';

    // Set the most common block elements.
    config.format_tags = 'p;h1;h2;h3;h4;h5;h6;pre';

    config.templates_files  = [
        '{{ _p.web_main ~ 'inc/lib/elfinder/templates.php'}}'
    ];
    //Style for default CKEditor Chamilo LMS
    config.stylesSet = [
        {
            name : 'Titulo',
            element : 'h2',
            attributes : { 'class': 'titulogeneralcont'}
        },
        {
            name : 'Subtitulo Uno',
            element : 'h3',
            attributes : { 'class': 'subtitulouno' }
        },
        {
            name : 'Subtitulo Dos',
            element : 'h4',
            attributes : { 'class': 'subtitulodos' }
        },
        {
            name : 'Sub-Videos',
            element : 'h4',
            attributes : { 'class': 'subtitulovideo' }
        },
        {
            name : 'Sub-Lecturas',
            element : 'h4',
            attributes : { 'class': 'subtitulolecturas' }
        },
        {
            name : 'Mensaje del Castor' ,
            element : 'div',
            attributes: { 'class':'telecastor informando'}
        }
    ];


    {% if moreButtonsInMaximizedMode %}
        config.toolbar = 'maxToolbar';
        config.smallToolbar = 'maxToolbar';
        config.maximizedToolbar = 'maxToolbar';
    {% endif %}

    // File manager (elFinder)
    config.filebrowserBrowseUrl = '{{ _p.web_lib ~ 'elfinder/filemanager.php?' }}{{ course_condition }}';

    // Allows to use "class" attribute inside divs and spans.
    config.allowedContent = true;
    config.contentsCss = '{{ cssEditor }}';
    config.customConfig = '{{ _p.web_main ~ 'inc/lib/javascript/ckeditor/config_js.php'}}';
};
