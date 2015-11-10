// There are three important markers in the CSS for the source and rendered
// editor panes:
//
//  - #document-updated-text
//  - #rendered_content_container
//   - .editor_rendered
//
//


$(document).ready(function() {

  $('#document-updated-text').scroll(function () {
    var position_rendered, rendered_height, scrollRatio, source_height, source_scroll_top, text_area_height;
    source_scroll_top = $(this).scrollTop();
    source_height = $(this).innerHeight();
    text_area_height = Math.round($(this)[0].scrollHeight);
    rendered_height = $('#rendered_content').innerHeight();
    scrollRatio = 1.0 * (source_scroll_top / text_area_height);
    position_rendered = scrollRatio * rendered_height;
    $('.rendered').scrollTop(position_rendered);
    $('#1').text('s: ' + source_scroll_top.toString() + ', r: ' + (Math.round(scrollRatio*100)/100.0).toString() + ', t: ' + text_area_height.toString())
    $('#2').text('sh: ' + source_height.toString() + ', rh: ' + rendered_height.toString())
    console.log('s: ' + source_scroll_top.toString() + ', r: ' + (Math.round(scrollRatio * 100) / 100.0).toString() + ', t: ' + text_area_height.toString());
    console.log('sh: ' + source_height.toString() + ', rh: ' + rendered_height.toString());

  });

});

// ---
// generated by coffee-script 1.9.2