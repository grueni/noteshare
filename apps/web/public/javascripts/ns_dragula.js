

$(document).ready(function() {
    function $(id) {
        return document.getElementById(id);
    }

    dragula([$('drag-elements')], {
        revertOnSpill: true
    });

});


/**
 $(".lined").linedtextarea({
        selectedLine: 10,
    });
 **/
