# There are three important markers in the CSS for the source and rendered
# editor panes:
#
#   - #OriginalContentTextArea
#   - #rendered_content_container
#   - .editor_rendered
#
#



ready = ->

  if true
    $('#OriginalContentTextArea').scroll ->
      source_scroll_top = $(this).scrollTop()
      source_height = $(this).innerHeight()
      text_area_height = Math.round($(this)[0].scrollHeight)
      rendered_height = $('#rendered_content_container').innerHeight()
      scrollRatio = (1.0)*(source_scroll_top / text_area_height)
      position_rendered = scrollRatio * (rendered_height)
      $('.editor_rendered').scrollTop position_rendered
      $('#1').text('s: ' + source_scroll_top.toString() + ', r: ' + (Math.round(scrollRatio*100)/100.0).toString() + ', t: ' + text_area_height.toString())
      $('#2').text('sh: ' + source_height.toString() + ', rh: ' + rendered_height.toString())
      return
  else
    console.log('in sync, flag is FALSE')


  if false
    $('#editor_rendered').scroll ->
      rendered_scroll_top = $(this).scrollTop()
      rendered_height = $('#rendered_content_container').innerHeight()
      text_area_height = Math.round($(this)[0].scrollHeight)
      scrollRatio = (1.0)*(rendered_scroll_top / rendered_height)
      position_source = scrollRatio * (text_area_height)
      $('#OriginalContentTextArea').scrollTop position_source
      $('#1').text('re: ' + rendered_scroll_top.toString() + ', ra: ' + (Math.round(scrollRatio*10)/10.0).toString() + ', t: ' + text_area_height.toString())
      $('#2').text('sh: ' + text_area_height.toString() + ', rh: ' + rendered_height.toString())
      return

  # synchronize source and rendered text
  $('#source_version').scroll ->
    source_scroll_top = $(this).scrollTop()
    source_height = $(this).innerHeight()
    source_height = Math.round($(this)[0].scrollHeight)
    rendered_height = $('#rendered_version').innerHeight()
    scrollRatio = (1.0)*(source_scroll_top / source_height)
    position_rendered = scrollRatio * (rendered_height)
    $('#rendered_versionxx').scrollTop position_rendered
    console.log('sh: ' + source_height + ', rh: ' + rendered_height)
    console.log('s: ' + source_scroll_top.toString() + ', r: ' + (Math.round(scrollRatio*100)/100.0).toString())
    return

$(document).ready(ready)
$(document).on('page:load', ready)