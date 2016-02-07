$(document).ready(function(){

    $(window).on('unload', function() {
        console.log('EDITOR UNLOADED')
        clearInterval(auto_update_interval);
    });

    $(window).on('load', function () {
        console.log("EDITOR LOADED event fired!");
    });


  $('#document-updated-text').on('input', mark_text_as_dirty )

  /* Do manual update/refresh */
  $('#update_source_button').click(update_document);

  $( "#slider" ).slider({
    value: 4.167,
    min: 0,
    max: 100
  });

    auto_update_interval = setInterval(auto_update_document, 1000*auto_update_delay());


  /* The slider sets the auto-refresh interval; the initial value is 3 seconds. */
  $('#slider_value').html("<span>auto-refresh: " + 3 + " seconds</span>")

  $( "#slider" ).slider({
      max: 60,
      min: 1,
      change: function( event, ui ) {

          var delay =  auto_update_delay();
          $('#slider_value').html("<span>auto-refresh: " + delay + " seconds</span>");
          clearInterval(auto_update_interval);
          auto_update_interval = setInterval(auto_update_document, 1000*auto_update_delay());

    }
  });

  setup_editor();

  $('#image_id_control').click(insert_image_link);


});

setup_editor = function() {

    var element = document.getElementById('document-updated-text');
    var source_text = element.value;
    console.log(count_words(source_text) + ' words');
    $('#count_words').html("<span>" + count_words(source_text) + "</span>");
}

mark_text_as_dirty = function() {

    localStorage.setItem('text_is_dirty', 'yes');
    var is_dirty = localStorage.getItem('text_is_dirty');
    console.log('mark, text_is_dirty: ' + is_dirty );
    //console.log('text marked as DIRTY');
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
    return delay

}

/*  auto_update_document stores the last-used version
 of the edited text.  It compares this with the currnt
 text.  If there are different, then we POST to
 /editor/json_update/' to update the text and its
 rendered verson. See the notes below for 'update_document'.
 */
auto_update_document = function () {


  var is_dirty = localStorage.getItem('text_is_dirty');

  console.log('auto_update, text_is_dirty: ' + is_dirty );

  if (is_dirty == 'yes') {

      console.log('auto_update_document --UPDATE')

      update_document();

      var element = document.getElementById('document-updated-text');
      var source_text = element.value;
      $('#count_words').html("<span>" + count_words(source_text) + "</span>");

      localStorage.setItem('text_is_dirty', 'no');

      console.log('text marked as CLEAN');

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


// http://stackoverflow.com/questions/15976574/how-to-add-a-text-to-a-textbox-from-the-current-position-of-the-pointer-with-jqu
jQuery.fn.extend({
    insertAtCaret: function(myValue){
        return this.each(function(i) {
            if (document.selection) {
                //For browsers like Internet Explorer
                this.focus();
                sel = document.selection.createRange();
                sel.text = myValue;
                this.focus();
            }
            else if (this.selectionStart || this.selectionStart == '0') {
                //For browsers like Firefox and Webkit based
                var startPos = this.selectionStart;
                var endPos = this.selectionEnd;
                var scrollTop = this.scrollTop;
                this.value = this.value.substring(0, startPos)+myValue+this.value.substring(endPos,this.value.length);
                this.focus();
                this.selectionStart = startPos + myValue.length;
                this.selectionEnd = startPos + myValue.length;
                this.scrollTop = scrollTop;
            } else {
                this.value += myValue;
                this.focus();
            }
        })
    }
});


insert_image_link = function() {

    var text = 'image::'+ $('#current_image_id').html() + '[]'
    $('#document-updated-text').insertAtCaret(text);
    update_document();

}