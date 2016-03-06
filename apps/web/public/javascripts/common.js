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

function inset_window_height(inset) {

    var val = $(window).height() - inset;
    console.log('inset_window_height = ' + val);
    return val;
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
        localStorage.search_scope_selector = 'local'
        var csrf_token = document.getElementsByName("_csrf_token")[0].value;
        $.post("set_search_type", { search_scope: "local", _csrf_token: csrf_token });
    });

    $('#select_global_search').change(function () {
        localStorage.search_scope_selector = 'global'
        var csrf_token = document.getElementsByName("_csrf_token")[0].value;
        $.post("set_search_type", { search_scope: "global", _csrf_token: csrf_token });
    });

    $('#select_all_search').change(function () {
        localStorage.search_scope_selector = 'all'
        var csrf_token = document.getElementsByName("_csrf_token")[0].value;
        $.post("set_search_type", { search_scope: "all", _csrf_token: csrf_token });
    });


    $('#select_document_search').change(function () {
        localStorage.search_mode_selector = 'document'
        var csrf_token = document.getElementsByName("_csrf_token")[0].value;
        $.post("set_search_type", { search_mode: "document", _csrf_token: csrf_token });
    });

    $('#select_section_search').change(function () {
        localStorage.search_mode_selector = 'section'
        var csrf_token = document.getElementsByName("_csrf_token")[0].value;
        $.post("set_search_type", { search_mode: "section", _csrf_token: csrf_token });
    });

    $('#select_text_search').change(function () {
        localStorage.search_mode_selector = 'text'
        var csrf_token = document.getElementsByName("_csrf_token")[0].value;
        $.post("set_search_type", { search_mode: "text", _csrf_token: csrf_token });
    });

    $.setup_search_selector = function () {

        if (localStorage.search_scope_selector == 'local') {
            $('input:radio[id=select_local_search]').prop('checked', true);
            $('input:radio[id=select_global_search]').prop('checked', false);
            $('input:radio[id=select_all_search]').prop('checked', false);
        } else if (localStorage.search_scope_selector == 'global') {
            $('input:radio[id=select_local_search]').prop('checked', false);
            $('input:radio[id=select_global_search]').prop('checked', true);
            $('input:radio[id=select_all_search]').prop('checked', false);
        } else if (localStorage.search_scope_selector == 'all') {
            $('input:radio[id=select_local_search]').prop('checked', false);
            $('input:radio[id=select_global_search]').prop('checked', false);
            $('input:radio[id=select_all_search]').prop('checked', true);
        } else {
            $('input:radio[id=select_local_search]').prop('checked', false);
            $('input:radio[id=select_global_search]').prop('checked', false);
            $('input:radio[id=select_all_search]').prop('checked', true);
        }

        if (localStorage.search_mode_selector == 'document') {
            $('input:radio[id=select_document_search]').prop('checked', true);
            $('input:radio[id=select_section_search]').prop('checked', false);
            $('input:radio[id=select_text_search]').prop('checked', false);
        } else if (localStorage.search_mode_selector == 'section') {
            $('input:radio[id=select_document_search]').prop('checked', false);
            $('input:radio[id=select_section_search]').prop('checked', true);
            $('input:radio[id=select_text_search]').prop('checked', false);
        } else if (localStorage.search_mode_selector == 'text') {
            $('input:radio[id=select_document_search]').prop('checked', false);
            $('input:radio[id=select_section_search]').prop('checked', false);
            $('input:radio[id=select_text_search]').prop('checked', true);
        } else {
            $('input:radio[id=select_document_search]').prop('checked', true);
            $('input:radio[id=select_section_search]').prop('checked', false);
            $('input:radio[id=select_text_search]').prop('checked', false);
        }
    }

    $.setup_search_selector();

    $('.openblock.click').find('.content').hide();

    $('.openblock.click').click(function() {
        return $(this).find('.content').slideToggle('200');
    });



    /**
    $(".lined").linedtextarea({
        selectedLine: 10,
    });
     **/
});