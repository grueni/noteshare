$(document).ready(function(){



  $('#update_source_button').click(update_document);

  refresh_auto_updater = setInterval(auto_update_document, 3000);
  // window.setInterval(auto_update_document, 2000  +   localStorage.getItem('source_text').split(" ").length/500.0);

  $( "#slider" ).slider({
    value: 4.167,
    min: 0,
    max: 100
  });

  $( "#slider" ).slider({
    change: function( event, ui ) {

      var delay =  auto_update_delay();
      console.log('in CHANGE, computed delay: ' + delay);
      clearInterval(refresh_auto_updater);
      refresh_auto_updater = setInterval(auto_update_document, delay);
      $('#slider_value').html("<span>delay: " + delay/1000.0 + " seconds</span>")

    }
  });


});


update_rendered_content = function(data, status) {

  console.log('update_rendered_content');

  $('#rendered_content').html(data);

  // console.log('update_rendered_content');

  reloadMathJax();

}

// Delay ranges from 0.5 seconds to 1 minute 0.5 seconds
auto_update_delay = function() {

  var val = $('#slider').slider("option", "value");
  delay = parseFloat(val);
  delay = 500 + delay*600;
  return delay

}


auto_update_document = function () {

  console.log('Auto_update_document!!');
  console.log('computed delay: ' + auto_update_delay());

  var element = document.getElementById('document-updated-text');
  var source_text = element.value;
  var element2 = document.getElementById('document-document-id');
  var id = element2.value;

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