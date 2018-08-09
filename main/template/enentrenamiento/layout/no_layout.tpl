<!DOCTYPE html>
<!--[if lt IE 7]> <html lang="{{document_language}}" class="no-js lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
<!--[if IE 7]>    <html lang="{{document_language}}" class="no-js lt-ie9 lt-ie8"> <![endif]-->
<!--[if IE 8]>    <html lang="{{document_language}}" class="no-js lt-ie9"> <![endif]-->
<!--[if gt IE 8]><!-->
<html lang="{{document_language}}" class="no-js"> <!--<![endif]-->
<head>
{% block head %}
{% include template ~ "/layout/head.tpl" %}
{% endblock %}
</head>
<body dir="{{text_direction}}" class="{{section_name}} {{ login_class }}">
	<noscript>{{ "NoJavascript"|get_lang }}</noscript>
    {% include template ~ "/layout/page_header.tpl" %}
    
    {% if show_course_shortcut is not null %}
        <div class="nav-tools">
            {{ show_course_shortcut }}
        </div>
    {% endif %}

<section id="content-scorm">
{% block body %}
    {{ content }}
{% endblock %}

{% include template ~ '/layout/footer.js.tpl' %}

{% include template ~ '/layout/footer.tpl' %}
</body>
</html>