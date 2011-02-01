// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

/* jQuery doTimeout: Like setTimeout, but better! - v1.0 - 3/3/2010 - http://benalman.com/projects/jquery-dotimeout-plugin/  http://benalman.com/about/license/  */
(function($){var a={},c="doTimeout",d=Array.prototype.slice;$[c]=function(){return b.apply(window,[0].concat(d.call(arguments)))};$.fn[c]=function(){var f=d.call(arguments),e=b.apply(this,[c+f[0]].concat(f));return typeof f[0]==="number"||typeof f[1]==="number"?this:e};function b(l){var m=this,h,k={},g=l?$.fn:$,n=arguments,i=4,f=n[1],j=n[2],p=n[3];if(typeof f!=="string"){i--;f=l=0;j=n[1];p=n[2]}if(l){h=m.eq(0);h.data(l,k=h.data(l)||{})}else{if(f){k=a[f]||(a[f]={})}}k.id&&clearTimeout(k.id);delete k.id;function e(){if(l){h.removeData(l)}else{if(f){delete a[f]}}}function o(){k.id=setTimeout(function(){k.fn()},j)}if(p){k.fn=function(q){if(typeof p==="string"){p=g[p]}p.apply(m,d.call(n,i))===true&&!q?o():e()};o()}else{if(k.fn){j===undefined?e():k.fn(j===false);return true}else{e()}}}})(jQuery);

/* Jquery GMap3 */
(function ($) {

    $.fn.gmap3 = function (options) {
        var defaults = {
            lat: 0.0,
            lng: 0.0,
            zoom: 4,
            navControl: true
        };
        var options = $.extend(defaults, options);

        // Allows multiple elements to be selected.
        if (this.length > 1) {
            this.each(function () { $(this).gmap(options) });
            return this;
        }

        // global var to access the google map object
        this.map;

        // overlay hash used for clearing
        this.overlays = [];

        // Initializes the map
        this.initialize = function () {
            var latlng = new google.maps.LatLng(options.lat, options.lng);
            var settings = {
                zoom: options.zoom,
                center: latlng,
                mapTypeControl: true,
                mapTypeControlOptions: { style: google.maps.MapTypeControlStyle.DROPDOWN_MENU },
                navigationControl: options.navControl,
                navigationControlOptions: { style: google.maps.NavigationControlStyle.SMALL },
                mapTypeId: google.maps.MapTypeId.SATELLITE
            }
            this.map = new google.maps.Map($(this)[0], settings);
            return this;
        };

        // set map type
        this.setTypeRoadMap = function () {
            this.map.setMapTypeId(google.maps.MapTypeId.ROADMAP);
        }
        this.setTypeSatellite = function () {
            this.map.setMapTypeId(google.maps.MapTypeId.SATELLITE);
        }
        this.setTypeHybrid = function () {
            this.map.setMapTypeId(google.maps.MapTypeId.HYBRID);
        }
        this.setTypeTerrain = function () {
            this.map.setMapTypeId(google.maps.MapTypeId.TERRAIN);
        }

        // set the map center
        this.setCenter = function (lat, lng) {
            this.map.setCenter(new google.maps.LatLng(lat, lng));
        }

        // zoom methods
        this.getZoom = function () {
            return this.map.getZoom();
        }
        this.setZoom = function (level) {
            this.map.setZoom(level);
        }

        // add a marker to the map by address
        this.addMarkerByAddress = function (address, title, html) {
            var localmap = this.map;
            $.fn.gmap3.geoCodeAddress(address, function (latlng) {
                return _addMarkerByLatLng(latlng, title, html, localmap);
            });
        }
        // add a marker to the map by lat / lng
        this.addMarkerByLatLng = function (lat, lng, title, html) {
            var latlng = new google.maps.LatLng(lat, lng);
            return _addMarkerByLatLng(latlng, title, html, this.map, this.overlays);
        }

        // add a path to the map
        this.addPath = function (data, opts) {
            var defOpts = {
                color: "#ff0000",
                opacity: 1.0,
                strokeWeight: 2.0
            };
            var opts = $.extend(defOpts, opts);

            if (data != undefined) {

                var path = new google.maps.Polyline({
                    path: _convertData(data),
                    strokeColor: opts.color,
                    strokeOpacity: opts.opacity,
                    strokeWeight: opts.strokeWeight
                });

                path.setMap(this.map);
                this.overlays.push(path);
            }
            return this;
        }

        // add a polygon to the map
        this.addPolygon = function (data, opts) {
            return _addPolygonToMap(data, null, opts, this.map, this.overlays);
        };

        // add a polygon to the map
        this.addClickablePolygon = function (data, html, opts) {
            return _addPolygonToMap(data, html, opts, this.map, this.overlays);
        };

        // clear the overlays
        this.clear = function () {
            if (this.overlays != undefined) {
                for (var i = 0; i < this.overlays.length; i++) {
                    this.overlays[i].setMap(null);
                }
                this.overlays = [];
            }
        }

        this.toggleDebug = function () {

            // Create new control to display latlng and coordinates under mouse.
            var latLngControl = new _latLngControl(this.map);

            // Register event listeners
            google.maps.event.addListener(this.map, 'mouseover', function (mEvent) {
                latLngControl.set('visible', true);
            });
            google.maps.event.addListener(this.map, 'mouseout', function (mEvent) {
                latLngControl.set('visible', false);
            });
            google.maps.event.addListener(this.map, 'mousemove', function (mEvent) {
                latLngControl.updatePosition(mEvent.latLng);
            });

            return this;
        }

        this.onclickReverseGeocode = function (callback) {
            geocode = google.maps.event.addListener(this.map, 'click', function (me) {
                $.fn.gmap3.geoCodeLatLng(me.latLng.lat(), me.latLng.lng(), function (address) {
                    if (callback != undefined) {
                        callback(address);
                    }
                });
            });
        }

        this.onclickGetLatLng = function (callback) {
            geocode = google.maps.event.addListener(this.map, 'click', function (me) {
                var result = [me.latLng.lat(), me.latLng.lng()];
                if (callback != undefined) {
                    callback(result);
                }
            });
        }

        /* ------------- Globals functions ------------------ */

        // Updates a registered element with the address (reverse geocode)
        $.fn.gmap3.geocoder = new google.maps.Geocoder();
        $.fn.gmap3.geoCodeLatLng = function (lat, lng, callback) {
            var latlng = new google.maps.LatLng(lat, lng);
            $.fn.gmap3.geocoder.geocode({ 'latLng': latlng }, function (results, status) {
                if (status == google.maps.GeocoderStatus.OK) {
                    var str = results[0].formatted_address;
                    /*                            $.each(results, function () {
                    str += "<h4>" + this.formatted_address + "</h4>";
                    str += "types: " + this.types.join(", ") + "<br />";
                    str += "address components: <ul>"
                    $.each(this.address_components, function () {
                    str += "<li>" + this.types.join(", ") + ": " + this.long_name + "</li>";
                    });
                    str += "</ul>";
                    });*/
                    callback(str);
                } else {
                    alert("Geocoder failed due to: " + status);
                }
            });
        }

        $.fn.gmap3.geoCodeAddress = function (address, callback) {
            $.fn.gmap3.geocoder.geocode({ 'address': address }, function (results, status) {
                if (status == google.maps.GeocoderStatus.OK) {
                    if (callback != undefined) {
                        callback(results[0].geometry.location);
                    }
                    else {
                        return results;
                    }
                } else {
                    alert("Geocoder failed due to: " + status);
                }
            });
        }



        /* ------------- Private functions ------------------ */

        // Adds a marker to the map
        function _addMarkerByLatLng(latlng, title, html, theMap, overlays) {
            var marker = new google.maps.Marker({
                position: latlng,
                map: theMap,
                title: title
            });
            overlays.push(marker);

            if (html != undefined) {
                var infowindow = new google.maps.InfoWindow();
                google.maps.event.addListener(marker, 'click', function () {
                    infowindow.setContent(html);
                    infowindow.open(theMap, marker);
                });
            }
            return this;
        }

        // Adds a polygon to the map
        function _addPolygonToMap(data, html, opts, theMap, overlays) {
            var defOpts = {
                strokeColor: "#ff0000",
                strokeOpacity: 0.8,
                strokeWeight: 2.0,
                fillColor: "#ff0000",
                fillOpacity: 0.35
            };
            var opts = $.extend(defOpts, opts);

            if (data != undefined) {

                var polygon = new google.maps.Polygon({
                    paths: _convertData(data),
                    strokeColor: opts.strokeColor,
                    strokeOpacity: opts.strokeOpacity,
                    strokeWeight: opts.strokeWeight,
                    fillColor: opts.fillColor,
                    fillOpacity: opts.fillOpacity
                });

                polygon.setMap(theMap);
                overlays.push(polygon);

                if (html != undefined) {
                    var infowindow = new google.maps.InfoWindow();
                    google.maps.event.addListener(polygon, 'click', function (event) {
                        infowindow.setContent(html);
                        infowindow.setPosition(event.latLng);
                        infowindow.open(theMap);
                    });
                }
            }

            return this;
        }

        // Converts array of JSON lat/lng into google array
        function _convertData(data) {
            var pts = [];
            for (var i = 0; i < data.length; i++) {
                pts[i] = new google.maps.LatLng(data[i].lat, data[i].lng);
            }
            return pts;
        }

        // Creates html that follows the mouse and displays lat/lng.
        function _latLngControl(map) {
            /**
            * Offset the control container from the mouse by this amount.
            */
            this.ANCHOR_OFFSET_ = new google.maps.Point(8, 8);

            /**
            * Pointer to the HTML container.
            */
            this.node_ = this.createHtmlNode_();

            // Add control to the map. Position is irrelevant.
            map.controls[google.maps.ControlPosition.TOP].push(this.node_);

            // Bind this OverlayView to the map so we can access MapCanvasProjection
            // to convert LatLng to Point coordinates.
            this.setMap(map);

            // Register an MVC property to indicate whether this custom control
            // is visible or hidden. Initially hide control until mouse is over map.
            this.set('visible', false);
        }

        // Extend OverlayView so we can access MapCanvasProjection.
        _latLngControl.prototype = new google.maps.OverlayView();
        _latLngControl.prototype.draw = function () { };

        _latLngControl.prototype.createHtmlNode_ = function () {
            var divNode = document.createElement('div');
            divNode.id = 'latlng-control';
            divNode.index = 100;
            return divNode;
        };

        _latLngControl.prototype.visible_changed = function () {
            this.node_.style.display = this.get('visible') ? '' : 'none';
        };

        _latLngControl.prototype.updatePosition = function (latLng) {
            var projection = this.getProjection();
            var point = projection.fromLatLngToContainerPixel(latLng);

            // Update control position to be anchored next to mouse position.
            this.node_.style.left = point.x + this.ANCHOR_OFFSET_.x + 'px';
            this.node_.style.top = point.y + this.ANCHOR_OFFSET_.y + 'px';

            // Update control to display latlng and coordinates.
            this.node_.innerHTML = [
                          latLng.toUrlValue(4),
                          '<br/>',
                          point.x,
                          'px, ',
                          point.y,
                          'px'
                        ].join('');
        };

        // Initialize the map
        return this.initialize();
    };

})(jQuery);

/* Jquery GMap3 */


(function($){
	$.fn.extend({
		counter: function(maxChars) {
			return this.each(function(){
				var $this = $(this);
				$this.bind('keydown keyup keypress', function() { setTimeout(makeCount(maxChars), 20); })
				     .bind('focus paste', function() { setTimeout(makeCount(maxChars), 20); });
				
				function makeCount(maxChars) {
					var val = $this.val();
					var length = val.length;
					
					if(length >= maxChars) {
						$this.val(val.substring(0, maxChars));
					}
					$('span#counter').html('Caracteres: ' + $this.val().length + "/" + maxChars);
				};
			});
		}
	});
})(jQuery);

function flashBar(text, cssClass, options) {
	$('div.flash').remove();
	var opts = $.extend({}, flashBarDefaults, options);
	flashDiv = $(document.createElement('div')).prependTo('body');
	flashDiv.html(text).addClass(cssClass).addClass('flash').fadeTo(0,0);
	flashDiv.fadeTo(opts.speed, opts.opacity);
	setTimeout(function(){
		flashDiv.fadeOut(opts.speed);
	}, opts.timeOut);
};

var flashBarDefaults = {
	timeOut: 10000,
	speed: 1000,
	opacity: 0.8
};


function modalWindow(title, text, buttons, options) {
	var opts = $.extend({}, modalWindowDefaults, options);
	wWidth = $(window).width();
	wHeight = $(window).height();
	dHeight = $(document).height();
	mTop = (wHeight - opts.height)/2;
	mLeft = (wWidth - opts.width)/2;
	
	$('div#modalMask').css('width', wWidth).css('height', dHeight).css('background-color', opts.maskBackground);
	$('div#modalWindow').css('top', mTop).css('height', opts.height).css('left', mLeft).css('width', opts.width).css('background-color', opts.modalBackground).addClass('radius4');
	
	$('div#modalMask').fadeTo(opts.speed, opts.opacity);
	$('div#modalWindow').fadeTo(opts.speed, 1);
	if (title != "") {
		$('p#modalTitle').css('font-size', '150%').html(title);
	} else {
		$('p#modalTitle').css('font-size', '0%').html("");
	}
	$('p#modalText').html(text);
	$('div#modalButtons').html('');
	
	$.each(buttons, function(txt, link) {
		$(document.createElement('a')).addClass('button').html(txt).attr('href',link).appendTo('div#modalButtons');
	});
	$(document.createElement('a')).addClass('button').html(opts.closeText).addClass('closeModal').appendTo('div#modalButtons');
}

$('.closeModal').live('click', function() {
	$('div#modalWindow').fadeOut();
	$('div#modalMask').fadeOut();
	return false;
});

var modalWindowDefaults = {
	speed: 400,
	opacity: 0.8,
	width: 400,
	height: 200,
	maskBackground: '#000',
	modalBackground: '#fff',
	titleBackground: '',
	closeText: 'Cerrar'
}

function setImage(err) {
	obj = $('img[err=' + err + ']')
	if(obj.attr('retry')) {
		retry = parseInt(obj.attr('retry'));
	} else {
		retry = 0;
	}
	
	if (retry < 3) {
		obj.attr('src',  obj.attr('old_src'));
		obj.attr('retry', retry + 1);
		return true;
	} else
	{
		return false;
	}
}


$(document).ready(function() {
	/*$('[type=modal]').click(function(e) {
		e.preventDefault();
		ref = $(this).attr('href');
		$('div#mWindowContent').load(ref, function() {
			openModal();
		});
	}); */

	$('a').live('click', function(e) {
		type = $(this).attr('type');
		if (type != '') {
			e.preventDefault();
			ref = $(this).attr('href');
			if (type == 'modal'){
				$('div#mWindowContent').load(ref, function() {
					openModal();
				});
			}
			
			if (type == 'stay')	{
				$('body').load(ref);
			}
		}
	});
	
	function openModal() {
		var contentH = $('div#mWindowContent').height();
		var contentW = $('div#mWindowContent').width();
		
		var maskH = $(document).height();
		var winW = $(window).width();
		var winH = $(window).height();
		
		$('div#mask').css({height:maskH, width:winW});
		$('div#mWindow').height(contentH + 10);
		$('div#mWindow').width(contentW + 10);
		$('div#mWindow').css('top', winH/2-(contentH + 10)/2);
		$('div#mWindow').css('left', winW/2-(contentW + 10)/2);
		$('div#mWindowContent').css('top', winH/2-(contentH)/2);
		$('div#mWindowContent').css('left', winW/2-(contentW)/2);

		$('div#mask').fadeTo(400, 0.4);
		$('div#mask').fadeIn(400);
		/* $('div#mWindow').fadeTo(400, 0.4); */
		$('div#mWindow').fadeIn(400);
		$('div#mWindowContent').fadeIn(400);
	}
	
	$('div#mWindowContent .close').live('click', function(e){
		e.preventDefault();
		$('div#mask').fadeOut(300);
		$('div#mWindow').fadeOut(300);
		$('div#mWindowContent').fadeOut(300);
	});
	
	$('div#mask').click(function() {
		return false;
	});
	
	/* show hideable parts */
	$('li').live("mouseover mouseout", function(event) {
		if (event.type == "mouseover") {
			$(this).find('div#hideable').show();
		} 
		if (event.type == "mouseout"){
			$(this).find('div#hideable').hide();
		}
			
		/*function() {
			$(this).find('div#hideable').fadeIn(300);
		},
		function() {
			$(this).find('div#hideable').fadeOut(300);
		} */
	});
	
	$(".pagination a").live('click', function(){
		$(".pagination").html("Buscando...");
		$.get(this.href, null, null, "script");
		return false;
	});
	
	$('img').error(function(){
		url = "http://assets.taradai.com/images/portal/default/";
		
		type = $(this).attr('type');
		if (type == undefined) {
			type = "undefined"
		}
		old_src = $(this).attr('src');
		$(this).attr('old_src', old_src);
		switch(type) {
			case "undefined":
				alert($(this).attr('src') + " es undefined...... ARREGLALO!");
				break;
			case "p180":
				$(this).attr('src', url + '180_default.gif');
				break;
			case "p50":
				$(this).attr('src', url + '50_default.gif');
				break;
			case "p30":
				$(this).attr('src', url + '30_default.gif');
				break;
			case "pht":
				$(this).attr('src', url + 't_default.gif');
				break;
		}

		$(this).doTimeout(20000, function() {
			if(this.attr('retry')) {
				retry = parseInt(this.attr('retry'));
			} else {
				retry = 0;
			}

			if (retry < 3) {
				this.attr('src',  this.attr('old_src'));
				this.attr('retry', retry + 1);
				return true;
			} else {
				return false;
			}
		})
	
	});
	
});
