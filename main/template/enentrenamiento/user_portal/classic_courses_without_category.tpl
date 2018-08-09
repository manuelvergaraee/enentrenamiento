{% if not courses is empty %}
    <div class="classic-courses">
    {% for item in courses %}
        <div class="panel panel-default">
            <div class="panel-body">
                        {% if item.visibility == constant('COURSE_VISIBILITY_CLOSED') and not item.current_user_is_teacher %}
                            <span class="image_classic">
                                {% if item.image != '' %}
                                    <img src="{{ item.image }}" title="{{ item.title }}"
                                         alt="{{ item.title }}"/>
                                {% else %}
                                    {{ 'blackboard.png' | img(48, item.title ) }}
                                {% endif %}
                            </span>
                        {% else %}
                            <a href="{{ item.link }}" class="image_classic">
                                {% if item.image != '' %}
                                    <img src="{{ item.image }}" title="{{ item.title }}"
                                         alt="{{ item.title }}"/>
                                {% else %}
                                    {{ 'blackboard.png' | img(48, item.title ) }}
                                {% endif %}
                            </a>
                        {% endif %}
                    
                        {% if item.edit_actions != '' %}
                            <div class="pull-right">
                                {% if item.document == '' %}
                                    <a class="btn btn-default btn-sm" href="{{ item.edit_actions }}">
                                        <i class="fa fa-pencil" aria-hidden="true"></i>
                                    </a>
                                {% else %}
                                    <div class="btn-group" role="group">
                                        <a class="btn btn-default btn-sm" href="{{ item.edit_actions }}">
                                            <i class="fa fa-pencil" aria-hidden="true"></i>
                                        </a>
                                        {{ item.document }}
                                    </div>
                                {% endif %}
                            </div>
                        {% endif %}
                        <h4 class="course-items-title">
                            {% if item.visibility == constant('COURSE_VISIBILITY_CLOSED') and not item.current_user_is_teacher %}
                                {{ item.title }} {{ item.code_course }}
                            {% else %}
                                <a href="{{ item.link }}">
                                    {{ item.title }} {{ item.code_course }}
                                </a>
                                
                            {% endif %}
                        </h4>
                        <div class="course-items-session">
                            {{ item.notifications }}
                                {% if item.is_special_course %}
                                    {{ 'klipper.png' | img(22, 'CourseAutoRegister'|get_lang ) }}
                                {% endif %}

                                {{ item.scorms }}
                            <div class="list-teachers">
                                {% if item.teachers|length > 0 %}
                                    {{ 'teacher.png' | img(16, 'Professor'|get_lang ) }}
                                    {% for teacher in item.teachers %}
                                        {% set counter = counter + 1 %}
                                        {% if counter > 1 %} | {% endif %}
                                        <a href="{{ teacher.url }}" class="ajax"
                                        data-title="{{ teacher.firstname }} {{ teacher.lastname }}">
                                            {{ teacher.firstname }} {{ teacher.lastname }}
                                        </a>
                                    {% endfor %}
                                {% endif %}
                            </div>

                            {% if item.student_info %}
                                {% if (item.student_info.progress is not null) and (item.student_info.score is not null) %}
                                    <div class="course-student-info">
                                        <div class="student-info">

                                            {% if (item.student_info.progress is not null) %}
                                            {{ "StudentCourseProgressX" | get_lang | format(item.student_info.progress) }}
                                            {% endif %}

                                            {% if (item.student_info.score is not null) %}
                                            {{ "StudentCourseScoreX" | get_lang | format(item.student_info.score) }}
                                            {% endif %}

                                            {% if (item.student_info.certificate is not null) %}
                                            {{ "StudentCourseCertificateX" | get_lang | format(item.student_info.certificate) }}
                                            {% endif %}

                                        </div>
                                    </div>
                                {% endif %}
                            {% endif %}
                        </div>
            </div>
        </div>
    {% endfor %}
    <div class="panel panel-default panel-compraotro">
        <a href="https://www.enentrenamiento.com/cursos/"><img src="data:image/svg+xml;utf8;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iaXNvLTg4NTktMSI/Pgo8c3ZnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgeG1sbnM6eGxpbms9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkveGxpbmsiIHZlcnNpb249IjEuMSIgdmlld0JveD0iMCAwIDQ0IDQ0IiBlbmFibGUtYmFja2dyb3VuZD0ibmV3IDAgMCA0NCA0NCIgd2lkdGg9IjI1NnB4IiBoZWlnaHQ9IjI1NnB4Ij4KICA8cGF0aCBkPSJNMjIsMEM5LjgsMCwwLDkuOCwwLDIyczkuOCwyMiwyMiwyMnMyMi05LjgsMjItMjJTMzQuMiwwLDIyLDB6IE0zNCwyM2MwLDAuNi0wLjQsMS0xLDFoLTguNWMtMC4zLDAtMC41LDAuMi0wLjUsMC41VjMzICBjMCwwLjYtMC40LDEtMSwxaC0yYy0wLjYsMC0xLTAuNC0xLTF2LTguNWMwLTAuMy0wLjItMC41LTAuNS0wLjVIMTFjLTAuNiwwLTEtMC40LTEtMXYtMmMwLTAuNiwwLjQtMSwxLTFoOC41ICBjMC4zLDAsMC41LTAuMiwwLjUtMC41VjExYzAtMC42LDAuNC0xLDEtMWgyYzAuNiwwLDEsMC40LDEsMXY4LjVjMCwwLjMsMC4yLDAuNSwwLjUsMC41SDMzYzAuNiwwLDEsMC40LDEsMVYyM3oiIGZpbGw9IiNiZmMzY2UiLz4KPC9zdmc+Cg==" /></a>
        <a href="https://www.enentrenamiento.com/cursos/"><span>Compra otro curso</span></a>
    </div>
    </div>
{% endif %}