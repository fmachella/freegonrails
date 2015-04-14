FreegoMagnet = (function($){

    function bind_ga_on_click(){
        $('#mc-embedded-subscribe').click(function(){
            ga('send', 'event', 'button', 'click');
        });
    }

    function init(){
        bind_ga_on_click();
    }

    return {
        init : init
    }

})(jQuery);


$(document).ready(function(){
    FreegoMagnet.init();
});
