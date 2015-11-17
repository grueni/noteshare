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

    $('input[name=select_tool_panel]:checked') {

        console.log('TOOL PANEL CHECKED')

    }


    $('.openblock.click').find('.content').hide()

    $('.openblock.click').click(function() {

        $(this).find('.content').slideToggle('200');
    });

});



