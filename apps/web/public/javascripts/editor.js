$(document).ready(function(){



  $('#update_source_button').click(update_document);

  window.setInterval(auto_update_document, 5000);



});


update_rendered_content = function(data, status) {

  $('#rendered_content').html(data);

  console.log('update_rendered_content');

  reloadMathJax();

}


auto_update_document = function () {

  console.log('\n------\nAuto_update_document');

  var element = document.getElementById('document-updated-text');
  var source_text = element.value;

  console.log('source: ' + source_text.slice(0,20));
  local_storage = localStorage.getItem('source')
  if (local_storage == null) {
    console.log('local storage is NULL');
  } else {
    console.log('local storage: ' + local_storage.slice(0,20));
  }
  localStorage.setItem('source', source_text)

  var element2 = document.getElementById('document-document-id');
  var id = element2.value;


  $.post( '/editor/json_update/' + id, { source: source_text }, update_rendered_content );
}

update_document = function () {

  console.log('Update_document');

  var element = document.getElementById('document-updated-text');
  var source_text = element.value;

  var element2 = document.getElementById('document-document-id');
  var id = element2.value;

  console.log('update_document with id = ' + id);
  // console.log('update_document with csrf_token ' + csrfToken()); /* DANGER */


  $.post( '/editor/json_update/' + id, { source: source_text }, update_rendered_content );
}