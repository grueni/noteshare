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

function getLineNumber(textarea, indicator) {

    indicator.innerHTML = textarea.value.substr(0, textarea.selectionStart).split("\n").length;
}

$(document).ready(function() {

    $('#document-updated-text').onkeyup="getLineNumber(this, document.getElementById('document-updated-text'))"
    $('#document-updated-text').onmouseup="getLineNumber(this, document.getElementById('document-updated-text'))"


    $('#Yak').click(yak);


    $('#update_toc_button').click(function() {

        console.log('button clicked')

        var data = localStorage.getItem('toc_permutation');

        console.log('AGAIN: ' + data);
        var url = "/editor/update_toc/0?" + data;
        $.post(url, 'foo');
    });


    /**
    $(".lined").linedtextarea({
        selectedLine: 10,
    });
     **/
});