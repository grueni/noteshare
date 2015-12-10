/*

 Code for toggling between tool panel and table of contents (toc)

 */

$('#select_tool_panel').change(function () {
    $('#tools_panel').show();
    $('#toc_panel').hide();
    localStorage.editor_tools = 'show'
    console.log('choose show, localStorage.editor_tools = ' + localStorage.editor_tools)
});

$('#select_toc_panel').change(function () {
    $('#tools_panel').hide();
    $('#toc_panel').show();
    localStorage.editor_tools = 'hide'
    console.log('choose hide, localStorage.editor_tools = ' + localStorage.editor_tools)
});

$.setup_editor = function () {
    console.log('setup_editor, localStorage.editor_tools = ' + localStorage.editor_tools)
    if (localStorage.editor_tools == 'hide') {
        $('#tools_panel').hide();
        $('#toc_panel').show();
        $('input:radio[id=select_tool_panel]').prop('checked', false);
        $('input:radio[id=select_toc_panel]').prop('checked', true);
    } else if (localStorage.editor_tools == 'show') {
        $('#tools_panel').show();
        $('#toc_panel').hide();
        $('input:radio[id=select_tool_panel]').prop('checked', true);
        $('input:radio[id=select_toc_panel]').prop('checked', false);
    } else {
        $('#tools_panel').hide();
        $('#toc_panel').show();
        $('input:radio[id=select_tool_panel]').prop('checked', false);
        $('input:radio[id=select_toc_panel]').prop('checked', true);
    }
}

$.setup_editor();
