<div id="navigation" class="notification-panel">
    {{ help_content }}
    {{ bug_notification }}
</div>
{% block topbar %}
    {% include template ~ "/layout/topbar.tpl" %}
{% endblock %}
<div class="extra-header">{{ header_extra_content }}</div>
<header id="header-section" class="header-movil">
    <div class="containerHeader">
        <div class="row">
            <div class="col-md-4 col-xs-9">
                        <div class="logo">
                           <a href="https://www.enentrenamiento.com/" class="logoPrincipal"></a>
                        </div>
                                            
            </div>
                    <div class="col-md-8 col-xs-3">
                        <div class="row">
                        {% block menu %}
                            {% include template ~ "/layout/menu.tpl" %}
                        {% endblock %}
                        <script>
                            $(document).on('ready', function () {
                                $("#notifications").load("{{ _p.web_main }}inc/ajax/online.ajax.php?a=get_users_online");
                            });
                        </script>
                        <div class="section-notifications">
                            <ul id="notifications" class="nav nav-pills pull-right"></ul>
                        </div>
                        {{ accessibility }}                       
                        </div>
                    </div>
            </div>
        </div>
</header>


{% include template ~ "/layout/course_navigation.tpl" %}

