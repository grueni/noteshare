var ready;

ready = function() {
    $.scrollIndex = function() {
        console.log('ENTER: scrollIndex');
        if (infoDiv === null) {
            return;
        }
        return $('.active').scrollintoview({
            duration: 40,
            direction: "vertical"
        });
    };
    return $.scrollIndex();
};
