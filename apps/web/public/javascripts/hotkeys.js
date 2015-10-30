$('#document-updated-text').bind('keydown', 'ctrl+u', function(){
    console.log('PRESSED: ctrl-U');
    $('#text_update_button' ).trigger( "click" );
});
