function reloadMathJax() {

    MathJax.Hub.Queue(["Typeset",MathJax.Hub]);

    console.log("reloadMathJax called");

}

function yak() {

   alert('Yak yak yak yak!');
   // console.log('Yak yak yak yak!');

}


// Up-to-date Cross-Site Request Forgery token
// See: https://github.com/rails/jquery-ujs/blob/master/src/rails.js#L59




function csrfToken() {

    return $('meta[name=csrf-token]').attr('content');
}



$(document).ready(function(){


    $('#Yak').click(yak);

    $('#select_tool_panel').change(function() {
        $('#tools_panel').show();
        $('#toc_panel').hide();

    });




    $('#select_toc_panel').change(function() {
        $('#tools_panel').hide();
        $('#toc_panel').show();
    });

    $.setup_editor = function() {
        $('#tools_panel').hide();
        $('#toc_panel').show();
    }

    $.setup_editor();


    $('.openblock.click').find('.content').hide()

    $('.openblock.click').click(function() {

        $(this).find('.content').slideToggle('200');
    });

});



