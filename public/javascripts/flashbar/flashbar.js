/*
(function($){
	$.fn.flashBar = function(options) {
		var opts = $.extend({}, $.fn.flashBar.defaults, options)
		alert(opts.text);
	};
	
	$.fn.flashBar = {
		text: "",
		timeOut: 10000,
		speed: 1000,
		cssClass: ""	
	}
	
})(jQuery);
*/

function flashBar(text, cssClass, options) {
	$('div.flash').remove();
	var opts = $.extend({}, flashBarDefaults, options);
	flashDiv = $(document.createElement('div')).appendTo('body');
	flashDiv.html(text).addClass(cssClass).addClass('flash');
	flashDiv.fadeTo(0, opts.opacity);
	setTimeout(function(){
		flashDiv.fadeOut(opts.speed);
	}, opts.timeOut);
};

var flashBarDefaults = {
	timeOut: 10000,
	speed: 1000,
	opacity: 0.8
};