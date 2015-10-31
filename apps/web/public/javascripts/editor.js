$(document).ready(function(){


  function update_rendered_content(data, status) {

    console.log('status: ' + status);
    console.log('DATA:' + data  );

    $('#rendered_content').html = data;     

    console.log('status:2 ' + status);
  }

  function udpate_document() {

    var element = document.getElementById('document-updated-text');
    var source_text = element.value;

    var element2 = document.getElementById('document-document-id');
    var id = element2.value;

    console.log('I will post for id: ' + id);
    console.log('I will post this: ' + source_text);

    $.post( 'http://localhost:2300/editor/json_update/' + id, { source: source_text}, update_rendered_content );
  }

$('#test_button').click(udpate_document);



});
