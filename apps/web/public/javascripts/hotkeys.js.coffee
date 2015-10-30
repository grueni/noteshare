#####################################################################
#
#   HOTKEYS
#
#####################################################################


# Press ctrl+u to update (refresh) rendered content
$('#document-updated-text').bind 'keydown', 'ctrl+u', ->
  $('#text_update_button' ).trigger( "click" );


##

$('#document-updated-text').bind 'keydown', 'ctrl+x', ->
  $('#save_edits_button a')[0].click()



############################################

$(document).bind 'keydown', 'ctrl+e', ->
  $.debounce 250, $('#edit_button a')[0].click()

$(document).bind 'keydown', 'ctrl+a', ->
  $.debounce 250, $('#edit_aside_button a')[0].click()

$(document).bind 'keydown', 'ctrl+n', ->
  $.debounce 250, $('#new_section_button a')[0].click()

############################################

$(document).bind 'keydown', 'ctrl+h', ->
  $.debounce 250, $('#home_button a')[0].click()

$(document).bind 'keydown', 'ctrl+b', ->
  $.debounce 250, $('#select_browse a')[0].click()

$(document).bind 'keydown', 'ctrl+r', ->
  $.debounce 250, $('#select_read a')[0].click()

$(document).bind 'keydown', 'ctrl+w', ->
  $.debounce 250, $('#select_write a')[0].click()

$(document).bind 'keydown', 'ctrl+m', ->
  $.debounce 250, $('#select_media a')[0].click()

$(document).bind 'keydown', 'ctrl+p', ->
  $.debounce 250, $('#select_print_doc a')[0].click()

$(document).bind 'keypress', 'ctrl-t', ->
  console.log('shift pressed')
  if localStorage['use_editor_sync'] == undefined
    localStorage['use_editor_sync'] = true
  else
    localStorage['use_editor_sync'] = !localStorage['use_editor_sync']
  console.log('use_editor_sync is ' + localStorage['use_editor_sync'] )

$('#document-updated-text').bind 'keydown', 'ctrl+i', ->
  console.log('ctrl-i pressed: windows scroll independently')
  $('.editor_rendered').removeClass('editor_rendered').addClass('editor_rendered_no_scroll');

$('#document-updated-text').bind 'keydown', 'ctrl+y', ->
  console.log('ctrl-y pressed (yoke)')
  $('.editor_rendered_no_scroll').removeClass('editor_rendered_no_scroll').addClass('editor_rendered');

#####################################################################
