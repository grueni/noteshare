// Keep active table of content item centered
// in table of contents panel.  Uses 'scrollintoview.js'
//  Good for long tables of content,



$(document).ready(function(){

    $.scrollIndex = function() {

        console.log('ENTER: scrollIndex');

        $('.active').scrollintoview({
            duration: 40,
            direction: "vertical"
        });
    };

    $.scrollIndex();

});

