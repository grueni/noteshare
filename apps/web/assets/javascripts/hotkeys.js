$(document).ready(function(){


    $('#document-updated-text').bind('keydown', 'ctrl+u', function(){
        console.log('PRESSED: ctrl-U');
        $('#update_source_button' ).trigger( "click" );
    });

    $('#document-updated-text').bind('keydown', 'ctrl+t', function(){
        console.log('PRESSED: ctrl-T');
        $('#toclink' ).trigger( "click" );
    });


    $('#editor-body').bind('keydown', 'ctrl+t', function(){
        console.log('PRESSED: ctrl-T');
        $('#toclink' ).trigger( "click" );
    });


});


