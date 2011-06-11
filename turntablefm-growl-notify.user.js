// ==UserScript==
// @name           turntablefm-growl-notify
// @namespace      http://twitter.com/kyanny
// @include        http://turntable.fm/*
// ==/UserScript==
(function(window){
    var $ = window.$;
    var console = window.console;
    var count = 0;
    var f = function(){
        var messages = $('.message');
        if (messages.length > count){
            var message = $(messages).last();
            var speaker = $(message).find('.speaker').text();
            var text = $(message).find('span').last().text();
            $.getJSON('http://localhost:5000?callback=?', {title:speaker,message:text}, function(data){});
        }
        count = messages.length;
    };
    setInterval(f, 1000);
})(unsafeWindow);
