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

        var data = localStorage.getItem('toc_permutation');
        var url = "/editor/update_toc/0?" + data;
        $.post(url, 'foo');

    });

    $('#done_button').click(function() {
        $.get('/', 'foo');
    });


    $('#select_local_search').change(function () {
        console.log('select_local_search');
        localStorage.search_selector = 'local'
        $.post('set_search_type?local', 'local');
    });

    $('#select_global_search').change(function () {
        //$.post()
        console.log('select_global_search');
        localStorage.search_selector = 'global'
        $.post('set_search_type?global', 'global');
    });

    $('#select_all_search').change(function () {
        //$.post()
        console.log('select_all_search');
        localStorage.search_selector = 'all'
        $.post('set_search_type?all', 'all');
    });

    $.setup_search_selector = function () {

        if (localStorage.search_selector == 'local') {
            $('input:radio[id=select_local_search]').prop('checked', true);
            $('input:radio[id=select_global_search]').prop('checked', false);
            $('input:radio[id=select_all_search]').prop('checked', false);
        } else if (localStorage.search_selector == 'global') {
            $('input:radio[id=select_local_search]').prop('checked', false);
            $('input:radio[id=select_global_search]').prop('checked', true);
            $('input:radio[id=select_all_search]').prop('checked', false);
        } else {
            $('input:radio[id=select_local_search]').prop('checked', false);
            $('input:radio[id=select_global_search]').prop('checked', false);
            $('input:radio[id=select_all_search]').prop('checked', true);
        }
    }

    $.setup_search_selector();

    /**
    $(".lined").linedtextarea({
        selectedLine: 10,
    });
     **/
});