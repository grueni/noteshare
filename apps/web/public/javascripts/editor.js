$(document).ready(function(){



  $('#update_source_button').click(update_document);

  window.setInterval(auto_update_document, 2500  +   text.split(" ").length/1000.0)
  );



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

  console.log('source_text: ' + source_text.length);
  source_text_local = localStorage.getItem('source_text')
  if (source_text_local == null) {
    console.log('source_text_local is NULL');
    localStorage.setItem('source_text', source_text)
  } else if (source_text_local != source_text) {
    console.log('DOING AUTO UPDATE')
    console.log('source_text_local: ' + source_text_local.length);
    $.post( '/editor/json_update/' + id, { source: source_text }, update_rendered_content );
    localStorage.setItem('source_text', source_text);
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