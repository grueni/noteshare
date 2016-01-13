$(document).ready(function(){



  $('#update_source_button').click(update_document);

  window.setInterval(auto_update_document, 2500);



});


update_rendered_content = function(data, status) {

  console.log('update_rendered_content');

  $('#rendered_content').html(data);

  // console.log('update_rendered_content');

  reloadMathJax();

}


auto_update_document = function () {

  console.log('Auto_update_document');

  var element = document.getElementById('document-updated-text');
  var source_text = element.value;
  var element2 = document.getElementById('document-document-id');
  var id = element2.value;

  console.log('source: ' + source_text.length);
  local_storage = localStorage.getItem('source')
  if (local_storage == null) {
    console.log('local storage is NULL');
    localStorage.setItem('source', source_text)
  } else if (local_storage != source_text) {
    console.log('local storage: ' + local_storage.length);
    $.post( '/editor/json_update/' + id, { source: source_text }, update_rendered_content );
    localStorage.setItem('source', source_text);
    $('#count_words').html("<span>" + count_words(source_text) + "</span>")
  }

}

update_document = function () {

  console.log('Update_document');

  var element = document.getElementById('document-updated-text');
  var source_text = element.value;

  var element2 = document.getElementById('document-document-id');
  var id = element2.value;

  // console.log('update_document with id = ' + id);
  // console.log('update_document with csrf_token ' + csrfToken()); /* DANGER */


  $.post( '/editor/json_update/' + id, { source: source_text }, update_rendered_content );
}

count_words = function(text) {

  var message = "word count: " + text.split(" ").length
  console.log(message);
  return message
}