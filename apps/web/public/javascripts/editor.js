$(document).ready(function(){



  $('#update_source_button').click(update_document);

  refresh_auto_updater = setInterval(auto_update_document, 3000);

  $( "#slider" ).slider({
    value: 4.167,
    min: 0,
    max: 100
  });

  $('#slider_value').html("<span>auto-refresh: " + 3 + " seconds</span>")

  $( "#slider" ).slider({
    change: function( event, ui ) {

      var delay =  auto_update_delay();
      clearInterval(refresh_auto_updater);
      refresh_auto_updater = setInterval(auto_update_document, delay);
      $('#slider_value').html("<span>auto-refresh: " + delay/1000.0 + " seconds</span>")

    }
  });


});


update_rendered_content = function(data, status) {

  $('#rendered_content').html(data);

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



    localStorage;

  var element = document.getElementById('document-updated-text');
  var source_text = element.value;
  var element2 = document.getElementById('document-document-id');
  var id = element2.value;
  /****** GGG *****/
  var local_source_text  =  localStorage.getItem('local_source_text');

  if (local_source_text == null) {

      local_source_text ='';
  }


  if (local_source_text != source_text) {

      console.log('(1) lengths: ' + local_source_text.length + ", " + source_text.length);
      // console.log('1:' + local_source_text);
      // console.log('2:' + source_text);


      /****** SSS *****/
      localStorage.getItem('local_source_text');
      localStorage.setItem('local_source_text', source_text);
      local_source_text  =  localStorage.getItem('local_source_text');
      console.log('(2) lengths: ' + local_source_text.length + ", " + source_text.length);

      $.post( '/editor/json_update/' + id, { source: source_text }, update_rendered_content );

      $('#count_words').html("<span>" + count_words(source_text) + "</span>")

  }

}

update_document = function () {

  console.log('Update_document');

  var element = document.getElementById('document-updated-text');
  var source_text = element.value;

  var element2 = document.getElementById('document-document-id');
  var id = element2.value;

  $.post( '/editor/json_update/' + id, { source: source_text }, update_rendered_content );
}

count_words = function(text) {

  var message = "word count: " + text.split(" ").length
  return message
}