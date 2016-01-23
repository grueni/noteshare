$(document).ready(function(){

  $('#document-updated-text').on('input', auto_update_document )

  /* Do manual update/refresh */
  $('#update_source_button').click(update_document);

  $( "#slider" ).slider({
    value: 4.167,
    min: 0,
    max: 100
  });


  /* The slider sets the auto-refresh interval; the initial value is 3 seconds. */
  $('#slider_value').html("<span>auto-refresh: " + 3 + " seconds</span>")

  $( "#slider" ).slider({
      max: 60,
      min: 1,
      change: function( event, ui ) {

         var delay =  auto_update_delay();
         // localStorage.setItem('minimum_editing_update_delay', delay);
          $('#slider_value').html("<span>auto-refresh: " + delay + " seconds</span>")

    }
  });


});

report_text_has_changed = function() {

    console.log('text has changed' );
}


/* Replace the rendered content with the updated rendered content */
update_rendered_content = function(data, status) {

  $('#rendered_content').html(data);

  reloadMathJax();

}

// Get the auto-upodate delay; its minimum value is 0.5 seconds
auto_update_delay = function() {

    var val = $('#slider').slider("option", "value");
    var delay = parseFloat(val);
    console.log('delay: ' + delay + 'seconds');
    // if (delay < 500) { delay = 500; }
    return delay

}

/*  auto_update_document stores the last-used version
 of the edited text.  It compares this with the currnt
 text.  If there are different, then we POST to
 /editor/json_update/' to update the text and its
 rendered verson. See the notes below for 'update_document'.
 */
auto_update_document = function () {

    var elapsed_time;
    var current_time = new Date()   ;
    var last_edit_update_time_string = localStorage.getItem('last_edit_update_time');

    if (last_edit_update_time_string == null) {
        console.log('last_edit_update_time is NULL');
        localStorage.setItem('last_edit_update_time', current_time.toString());
        elapsed_time = 1000.0*60*60; /* one hour -- a large elapsed time*/
    } else {
        var last_edit_update_time = Date.parse(last_edit_update_time_string);
        elapsed_time = current_time.getTime() - last_edit_update_time;
        console.log('elapsed_time = ' + elapsed_time + ' ms');
    }


    // elapsed_time is in milliseconds, auto_update_delay
    // is in seconds
  if (elapsed_time > 1000*auto_update_delay()) {

      var element = document.getElementById('document-updated-text');
      var source_text = element.value;
      var element2 = document.getElementById('document-document-id');
      var id = element2.value;

      $.post( '/editor/json_update/' + id, { source: source_text }, update_rendered_content );

      $('#count_words').html("<span>" + count_words(source_text) + "</span>");

      localStorage.setItem('last_edit_update_time', current_time.toString());

      console.log('SET last_edit_update_time');

  }

}

/* Send the updated text to the server by POST.
The action '/editor/json_update/' will render
the Asciidoc text received as HTML and place
it in data using the statement

 self.body = @document.rendered_content

The callback 'update_rendered_content'
will then use this HTML to update the rendered
text in the client's browser.
 */
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