$(document).ready(function(){
	$("#lp-view-expand-toggle").attr("title","Mostrar/Ocultar Barra Lateral");
	$("a#home-course").attr("title","Ir a página principal del curso");
	$("a#stats_link").attr("title","Ver Estado del Curso");
	$("a#scorm-previous").attr("title","Lección Anterior");
	$("a#scorm-next").attr("title","Siguiente Lección");

	if( $("title:contains('Remote University')").length) {
		$("html").addClass("remoteUni");
	}

	$("#istooldesc_16").html(" Mis Calificaciones");

	$('title').each(function () {
    if ($(this).text() == 'FaceIT - Enentrenamiento - LikeU University') {
    $('head').append( $('<link rel="stylesheet" type="text/css" />').attr('href', 'https://www.enentrenamiento.com/comunidad/web/css/themes/LikeUUniversity/default.css') );
	}
	});

	if($("#learning_path_toc .scorm-body").height() > 400 ) {
		$("#learning_path_toc").addClass("solonger");
	}

	$(".navbar-right").prependTo(".section-notifications");

	$("#count_message_li").prependTo(".dropdown.avatar-user");

	/*
	//Para poner cabeceras con Banners
	if( $(".breadcrumb img").attr("title") == "Competencias para el Teletrabajo" ){
		
		$(".breadcrumb img").attr("src","https://www.enentrenamiento.com/wp-content/uploads/2017/05/D-Banner-curso-Teletrabajo.jpg");
	}

	*/

});

iFrameResize();     


