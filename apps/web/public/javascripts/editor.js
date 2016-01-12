$(document).ready(function(){



  $('#update_source_button').click($.update_document);



});


$.update_rendered_content = function(data, status) {

  $('#rendered_content').html(data);

  console.log('update_rendered_content');

  reloadMathJax();

}


$.update_document = function () {

  console.log('$.update_document');

  var element = document.getElementById('document-updated-text');
  var source_text = element.value;

  var element2 = document.getElementById('document-document-id');
  var id = element2.value;

  console.log('update_document with id = ' + id);
  // console.log('update_document with csrf_token ' + csrfToken()); /* DANGER */


  $.post( '/editor/json_update/' + id, { source: source_text }, $.update_rendered_content );
}