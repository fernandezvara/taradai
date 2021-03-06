// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

/* jQuery doTimeout: Like setTimeout, but better! - v1.0 - 3/3/2010 - http://benalman.com/projects/jquery-dotimeout-plugin/  http://benalman.com/about/license/  */
(function($){var a={},c="doTimeout",d=Array.prototype.slice;$[c]=function(){return b.apply(window,[0].concat(d.call(arguments)))};$.fn[c]=function(){var f=d.call(arguments),e=b.apply(this,[c+f[0]].concat(f));return typeof f[0]==="number"||typeof f[1]==="number"?this:e};function b(l){var m=this,h,k={},g=l?$.fn:$,n=arguments,i=4,f=n[1],j=n[2],p=n[3];if(typeof f!=="string"){i--;f=l=0;j=n[1];p=n[2]}if(l){h=m.eq(0);h.data(l,k=h.data(l)||{})}else{if(f){k=a[f]||(a[f]={})}}k.id&&clearTimeout(k.id);delete k.id;function e(){if(l){h.removeData(l)}else{if(f){delete a[f]}}}function o(){k.id=setTimeout(function(){k.fn()},j)}if(p){k.fn=function(q){if(typeof p==="string"){p=g[p]}p.apply(m,d.call(n,i))===true&&!q?o():e()};o()}else{if(k.fn){j===undefined?e():k.fn(j===false);return true}else{e()}}}})(jQuery);

/*

 FullCalendar v1.4.10
 http://arshaw.com/fullcalendar/

 Use fullcalendar.css for basic styling.
 For event drag & drop, requires jQuery UI draggable.
 For event resizing, requires jQuery UI resizable.

 Copyright (c) 2010 Adam Shaw
 Dual licensed under the MIT and GPL licenses, located in
 MIT-LICENSE.txt and GPL-LICENSE.txt respectively.

 Date: Sat Jan 1 23:46:27 2011 -0800

*/
(function(l,ha){function hb(a){l.extend(true,Oa,a)}function Db(a,b,f){function e(q){if(I){s();r();ka();N(q)}else g()}function g(){P=b.theme?"ui":"fc";a.addClass("fc");b.isRTL&&a.addClass("fc-rtl");b.theme&&a.addClass("ui-widget");I=l("<div class='fc-content "+P+"-widget-content' style='position:relative'/>").prependTo(a);L=new Eb(Y,b);(D=L.render())&&a.prepend(D);y(b.defaultView);l(window).resize(ia);t()||h()}function h(){setTimeout(function(){!v.start&&t()&&N()},0)}function m(){l(window).unbind("resize",
ia);L.destroy();I.remove();a.removeClass("fc fc-rtl fc-ui-widget")}function o(){return Q.offsetWidth!==0}function t(){return l("body")[0].offsetWidth!==0}function y(q){if(!v||q!=v.name){p++;z();var A=v,J;if(A){(A.beforeHide||ib)();Ra(I,I.height());A.element.hide()}else Ra(I,1);I.css("overflow","hidden");if(v=i[q])v.element.show();else v=i[q]=new Fa[q](J=j=l("<div class='fc-view fc-view-"+q+"' style='position:absolute'/>").appendTo(I),Y);A&&L.deactivateButton(A.name);L.activateButton(q);N();I.css("overflow",
"");A&&Ra(I,1);J||(v.afterShow||ib)();p--}}function N(q){if(o()){p++;z();E===ha&&s();var A=false;if(!v.start||q||u<v.start||u>=v.end){v.render(u,q||0);Z(true);A=true}else if(v.sizeDirty){v.clearEvents();Z();A=true}else if(v.eventsDirty){v.clearEvents();A=true}v.sizeDirty=false;v.eventsDirty=false;da(A);k=a.outerWidth();L.updateTitle(v.title);q=new Date;q>=v.start&&q<v.end?L.disableButton("today"):L.enableButton("today");p--;v.trigger("viewDisplay",Q)}}function O(){r();if(o()){s();Z();z();v.clearEvents();
v.renderEvents(U);v.sizeDirty=false}}function r(){l.each(i,function(q,A){A.sizeDirty=true})}function s(){E=b.contentHeight?b.contentHeight:b.height?b.height-(D?D.height():0)-Sa(I[0]):Math.round(I.width()/Math.max(b.aspectRatio,0.5))}function Z(q){p++;v.setHeight(E,q);if(j){j.css("position","relative");j=null}v.setWidth(I.width(),q);p--}function ia(){if(!p)if(v.start){var q=++d;setTimeout(function(){if(q==d&&!p&&o())if(k!=(k=a.outerWidth())){p++;O();v.trigger("windowResize",Q);p--}},200)}else h()}
function da(q){if(!b.lazyFetching||w(v.visStart,v.visEnd))X();else q&&aa()}function X(){K(v.visStart,v.visEnd)}function la(q){U=q;aa()}function oa(q){aa(q)}function aa(q){ka();if(o()){v.clearEvents();v.renderEvents(U,q);v.eventsDirty=false}}function ka(){l.each(i,function(q,A){A.eventsDirty=true})}function ca(q,A,J){v.select(q,A,J===ha?true:J)}function z(){v&&v.unselect()}function V(){N(-1)}function c(){N(1)}function B(){Ta(u,-1);N()}function F(){Ta(u,1);N()}function G(){u=new Date;N()}function ga(q,
A,J){if(q instanceof Date)u=C(q);else jb(u,q,A,J);N()}function ma(q,A,J){q!==ha&&Ta(u,q);A!==ha&&Ua(u,A);J!==ha&&S(u,J);N()}function ja(){return C(u)}function H(){return v}function T(q,A){if(A===ha)return b[q];if(q=="height"||q=="contentHeight"||q=="aspectRatio"){b[q]=A;O()}}function va(q,A){if(b[q])return b[q].apply(A||Q,Array.prototype.slice.call(arguments,2))}var Y=this;Y.options=b;Y.render=e;Y.destroy=m;Y.refetchEvents=X;Y.reportEvents=la;Y.reportEventChange=oa;Y.changeView=y;Y.select=ca;Y.unselect=
z;Y.prev=V;Y.next=c;Y.prevYear=B;Y.nextYear=F;Y.today=G;Y.gotoDate=ga;Y.incrementDate=ma;Y.formatDate=function(q,A){return Ha(q,A,b)};Y.formatDates=function(q,A,J){return Va(q,A,J,b)};Y.getDate=ja;Y.getView=H;Y.option=T;Y.trigger=va;Fb.call(Y,b,f);var w=Y.isFetchNeeded,K=Y.fetchEvents,Q=a[0],L,D,I,P,v,i={},k,E,j,d=0,p=0,u=new Date,U=[],$;jb(u,b.year,b.month,b.date);b.droppable&&l(document).bind("dragstart",function(q,A){var J=q.target,fa=l(J);if(!fa.parents(".fc").length){var na=b.dropAccept;if(l.isFunction(na)?
na.call(J,fa):fa.is(na)){$=J;v.dragStart($,q,A)}}}).bind("dragstop",function(q,A){if($){v.dragStop($,q,A);$=null}})}function Eb(a,b){function f(){r=b.theme?"ui":"fc";var s=b.header;if(s)return O=l("<table class='fc-header'/>").append(l("<tr/>").append(l("<td class='fc-header-left'/>").append(g(s.left))).append(l("<td class='fc-header-center'/>").append(g(s.center))).append(l("<td class='fc-header-right'/>").append(g(s.right))))}function e(){O.remove()}function g(s){if(s){var Z=l("<tr/>");l.each(s.split(" "),
function(ia){ia>0&&Z.append("<td><span class='fc-header-space'/></td>");var da;l.each(this.split(","),function(X,la){if(la=="title"){Z.append("<td><h2 class='fc-header-title'>&nbsp;</h2></td>");da&&da.addClass(r+"-corner-right");da=null}else{var oa;if(a[la])oa=a[la];else if(Fa[la])oa=function(){aa.removeClass(r+"-state-hover");a.changeView(la)};if(oa){da&&da.addClass(r+"-no-right");var aa;X=b.theme?Wa(b.buttonIcons,la):null;var ka=Wa(b.buttonText,la);if(X)aa=l("<div class='fc-button-"+la+" ui-state-default'><a><span class='ui-icon ui-icon-"+
X+"'/></a></div>");else if(ka)aa=l("<div class='fc-button-"+la+" "+r+"-state-default'><a><span>"+ka+"</span></a></div>");if(aa){aa.click(function(){aa.hasClass(r+"-state-disabled")||oa()}).mousedown(function(){aa.not("."+r+"-state-active").not("."+r+"-state-disabled").addClass(r+"-state-down")}).mouseup(function(){aa.removeClass(r+"-state-down")}).hover(function(){aa.not("."+r+"-state-active").not("."+r+"-state-disabled").addClass(r+"-state-hover")},function(){aa.removeClass(r+"-state-hover").removeClass(r+
"-state-down")}).appendTo(l("<td/>").appendTo(Z));da?da.addClass(r+"-no-right"):aa.addClass(r+"-corner-left");da=aa}}}});da&&da.addClass(r+"-corner-right")});return l("<table/>").append(Z)}}function h(s){O.find("h2.fc-header-title").html(s)}function m(s){O.find("div.fc-button-"+s).addClass(r+"-state-active")}function o(s){O.find("div.fc-button-"+s).removeClass(r+"-state-active")}function t(s){O.find("div.fc-button-"+s).addClass(r+"-state-disabled")}function y(s){O.find("div.fc-button-"+s).removeClass(r+
"-state-disabled")}var N=this;N.render=f;N.destroy=e;N.updateTitle=h;N.activateButton=m;N.deactivateButton=o;N.disableButton=t;N.enableButton=y;var O=l([]),r}function Fb(a,b){function f(c,B){return!oa||c<oa||B>aa}function e(c,B){oa=c;aa=B;V=[];c=++ka;ca=B=b.length;for(var F=0;F<B;F++)g(b[F],c)}function g(c,B){h(c,function(F){if(B==ka){for(var G=0;G<F.length;G++){Z(F[G]);F[G].source=c}V=V.concat(F);ca--;ca||la(V)}})}function h(c,B){if(typeof c=="string"){var F={};F[a.startParam]=Math.round(oa.getTime()/
1E3);F[a.endParam]=Math.round(aa.getTime()/1E3);if(a.cacheParam)F[a.cacheParam]=(new Date).getTime();r();l.ajax({url:c,dataType:"json",data:F,cache:a.cacheParam||false,success:function(G){s();B(G)}})}else if(l.isFunction(c)){r();c(C(oa),C(aa),function(G){s();B(G)})}else B(c)}function m(c){b.push(c);ca++;g(c,ka)}function o(c){b=l.grep(b,function(B){return B!=c});V=l.grep(V,function(B){return B.source!=c});la(V)}function t(c){var B,F=V.length,G,ga=X().defaultEventEnd,ma=c.start-c._start,ja=c.end?c.end-
(c._end||ga(c)):0;for(B=0;B<F;B++){G=V[B];if(G._id==c._id&&G!=c){G.start=new Date(+G.start+ma);G.end=c.end?G.end?new Date(+G.end+ja):new Date(+ga(G)+ja):null;G.title=c.title;G.url=c.url;G.allDay=c.allDay;G.className=c.className;G.editable=c.editable;Z(G)}}Z(c);la(V)}function y(c,B){Z(c);if(!c.source){if(B){b[0].push(c);c.source=b[0]}V.push(c)}la(V)}function N(c){if(c){if(!l.isFunction(c)){var B=c+"";c=function(G){return G._id==B}}V=l.grep(V,c,true);for(F=0;F<b.length;F++)if(typeof b[F]=="object")b[F]=
l.grep(b[F],c,true)}else{V=[];for(var F=0;F<b.length;F++)if(typeof b[F]=="object")b[F]=[]}la(V)}function O(c){if(l.isFunction(c))return l.grep(V,c);else if(c){c+="";return l.grep(V,function(B){return B._id==c})}return V}function r(){z++||da("loading",null,true)}function s(){--z||da("loading",null,false)}function Z(c){c._id=c._id||(c.id===ha?"_fc"+Gb++:c.id+"");if(c.date){if(!c.start)c.start=c.date;delete c.date}c._start=C(c.start=Xa(c.start,a.ignoreTimezone));c.end=Xa(c.end,a.ignoreTimezone);if(c.end&&
c.end<=c.start)c.end=null;c._end=c.end?C(c.end):null;if(c.allDay===ha)c.allDay=a.allDayDefault;if(c.className){if(typeof c.className=="string")c.className=c.className.split(/\s+/)}else c.className=[]}var ia=this;ia.isFetchNeeded=f;ia.fetchEvents=e;ia.addEventSource=m;ia.removeEventSource=o;ia.updateEvent=t;ia.renderEvent=y;ia.removeEvents=N;ia.clientEvents=O;ia.normalizeEvent=Z;var da=ia.trigger,X=ia.getView,la=ia.reportEvents,oa,aa,ka=0,ca=0,z=0,V=[];b.unshift([])}function Hb(a,b){function f(o,t){if(t){Ua(o,
t);o.setDate(1)}o=C(o,true);o.setDate(1);t=Ua(C(o),1);var y=C(o),N=C(t),O=g("firstDay"),r=g("weekends")?0:1;if(r){ta(y);ta(N,-1,true)}S(y,-((y.getDay()-Math.max(O,r)+7)%7));S(N,(7-N.getDay()+Math.max(O,r))%7);O=Math.round((N-y)/(kb*7));if(g("weekMode")=="fixed"){S(N,(6-O)*7);O=6}e.title=m(o,g("titleFormat"));e.start=o;e.end=t;e.visStart=y;e.visEnd=N;h(O,r?5:7,true)}var e=this;e.render=f;Ya.call(e,a,b,"month");var g=e.opt,h=e.renderBasic,m=b.formatDate}function Ib(a,b){function f(o,t){t&&S(o,t*7);
o=S(C(o),-((o.getDay()-g("firstDay")+7)%7));t=S(C(o),7);var y=C(o),N=C(t),O=g("weekends");if(!O){ta(y);ta(N,-1,true)}e.title=m(y,S(C(N),-1),g("titleFormat"));e.start=o;e.end=t;e.visStart=y;e.visEnd=N;h(1,O?7:5,false)}var e=this;e.render=f;Ya.call(e,a,b,"basicWeek");var g=e.opt,h=e.renderBasic,m=b.formatDates}function Jb(a,b){function f(o,t){if(t){S(o,t);g("weekends")||ta(o,t<0?-1:1)}e.title=m(o,g("titleFormat"));e.start=e.visStart=C(o,true);e.end=e.visEnd=S(C(e.start),1);h(1,1,false)}var e=this;e.render=
f;Ya.call(e,a,b,"basicDay");var g=e.opt,h=e.renderBasic,m=b.formatDate}function Ya(a,b,f){function e(j,d,p){w=j;K=d;if(ja=V("isRTL")){H=-1;T=K-1}else{H=1;T=0}va=V("firstDay");Y=V("weekends")?0:1;var u=V("theme")?"ui":"fc",U=V("columnFormat"),$=z.start.getMonth(),q=Ga(new Date),A,J=C(z.visStart);if(P){B();d=P.find("tr").length;if(w<d)P.find("tr:gt("+(w-1)+")").remove();else if(w>d){j="";for(d=d;d<w;d++){j+="<tr class='fc-week"+d+"'>";for(A=0;A<K;A++){j+="<td class='fc-"+Ca[J.getDay()]+" "+u+"-state-default fc-new fc-day"+
(d*K+A)+(A==T?" fc-leftmost":"")+"'>"+(p?"<div class='fc-day-number'></div>":"")+"<div class='fc-day-content'><div style='position:relative'>&nbsp;</div></div></td>";S(J,1);Y&&ta(J)}j+="</tr>"}P.append(j)}m(P.find("td.fc-new").removeClass("fc-new"));J=C(z.visStart);P.find("td").each(function(){var na=l(this);if(w>1)J.getMonth()==$?na.removeClass("fc-other-month"):na.addClass("fc-other-month");+J==+q?na.removeClass("fc-not-today").addClass("fc-today").addClass(u+"-state-highlight"):na.addClass("fc-not-today").removeClass("fc-today").removeClass(u+
"-state-highlight");na.find("div.fc-day-number").text(J.getDate());S(J,1);Y&&ta(J)});if(w==1){J=C(z.visStart);I.find("th").each(function(na,W){l(W).text(ma(J,U));W.className=W.className.replace(/^fc-\w+(?= )/,"fc-"+Ca[J.getDay()]);S(J,1);Y&&ta(J)});J=C(z.visStart);P.find("td").each(function(na,W){W.className=W.className.replace(/^fc-\w+(?= )/,"fc-"+Ca[J.getDay()]);S(J,1);Y&&ta(J)})}}else{var fa=l("<table/>").appendTo(a);j="<thead><tr>";for(d=0;d<K;d++){j+="<th class='fc-"+Ca[J.getDay()]+" "+u+"-state-default"+
(d==T?" fc-leftmost":"")+"'>"+ma(J,U)+"</th>";S(J,1);Y&&ta(J)}I=l(j+"</tr></thead>").appendTo(fa);j="<tbody>";J=C(z.visStart);for(d=0;d<w;d++){j+="<tr class='fc-week"+d+"'>";for(A=0;A<K;A++){j+="<td class='fc-"+Ca[J.getDay()]+" "+u+"-state-default fc-day"+(d*K+A)+(A==T?" fc-leftmost":"")+(w>1&&J.getMonth()!=$?" fc-other-month":"")+(+J==+q?" fc-today "+u+"-state-highlight":" fc-not-today")+"'>"+(p?"<div class='fc-day-number'>"+J.getDate()+"</div>":"")+"<div class='fc-day-content'><div style='position:relative'>&nbsp;</div></div></td>";
S(J,1);Y&&ta(J)}j+="</tr>"}P=l(j+"</tbody>").appendTo(fa);m(P.find("td"));v=l("<div style='position:absolute;z-index:8;top:0;left:0'/>").appendTo(a)}}function g(j){D=j;j=P.find("tr td:first-child");var d=D-I.height(),p;if(V("weekMode")=="variable")p=d=Math.floor(d/(w==1?2:6));else{p=Math.floor(d/w);d=d-p*(w-1)}if(Za===ha){var u=P.find("tr:first").find("td:first");u.height(p);Za=p!=u.height()}if(Za){j.slice(0,-1).height(p);j.slice(-1).height(d)}else{Pa(j.slice(0,-1),p);Pa(j.slice(-1),d)}}function h(j){L=
j;E.clear();Q=Math.floor(L/K);Ia(I.find("th").slice(0,-1),Q)}function m(j){j.click(o).mousedown(ga)}function o(j){if(!V("selectable")){var d=parseInt(this.className.match(/fc\-day(\d+)/)[1]);d=S(C(z.visStart),Math.floor(d/K)*7+d%K);c("dayClick",this,d,true,j)}}function t(j,d,p){p&&i.build();p=C(z.visStart);for(var u=S(C(p),K),U=0;U<w;U++){var $=new Date(Math.max(p,j)),q=new Date(Math.min(u,d));if($<q){var A;if(ja){A=za(q,p)*H+T+1;$=za($,p)*H+T+1}else{A=za($,p);$=za(q,p)}m(y(U,A,U,$-1))}S(p,7);S(u,
7)}}function y(j,d,p,u){j=i.rect(j,d,p,u,a);return F(j,a)}function N(j){return C(j)}function O(j,d){t(j,S(C(d),1),true)}function r(){G()}function s(j,d){k.start(function(p){G();p&&y(p.row,p.col,p.row,p.col)},d)}function Z(j,d,p){var u=k.stop();G();if(u){u=aa(u);c("drop",j,u,true,d,p)}}function ia(j){return C(j.start)}function da(j){return E.left(j)}function X(j){return E.right(j)}function la(j){return(j-Math.max(va,Y)+K)%K}function oa(j){return{row:Math.floor(za(j,z.visStart)/7),col:la(j.getDay())*
H+T}}function aa(j){return S(C(z.visStart),j.row*7+j.col*H+T)}function ka(j){return P.find("tr:eq("+j+")")}function ca(){return{left:0,right:L}}var z=this;z.renderBasic=e;z.setHeight=g;z.setWidth=h;z.renderDayOverlay=t;z.defaultSelectionEnd=N;z.renderSelection=O;z.clearSelection=r;z.dragStart=s;z.dragStop=Z;z.defaultEventEnd=ia;z.getHoverListener=function(){return k};z.colContentLeft=da;z.colContentRight=X;z.dayOfWeekCol=la;z.dateCell=oa;z.cellDate=aa;z.cellIsAllDay=function(){return true};z.allDayTR=
ka;z.allDayBounds=ca;z.getRowCnt=function(){return w};z.getColCnt=function(){return K};z.getColWidth=function(){return Q};z.getDaySegmentContainer=function(){return v};lb.call(z,a,b,f);mb.call(z);nb.call(z);Kb.call(z);var V=z.opt,c=z.trigger,B=z.clearEvents,F=z.renderOverlay,G=z.clearOverlays,ga=z.daySelectionMousedown,ma=b.formatDate,ja,H,T,va,Y,w,K,Q,L,D,I,P,v,i,k,E;ob(a.addClass("fc-grid"));i=new pb(function(j,d){var p,u,U,$=P.find("tr:first td");if(ja)$=l($.get().reverse());$.each(function(q,
A){p=l(A);u=p.offset().left;if(q)U[1]=u;U=[u];d[q]=U});U[1]=u+p.outerWidth();P.find("tr").each(function(q,A){p=l(A);u=p.offset().top;if(q)U[1]=u;U=[u];j[q]=U});U[1]=u+p.outerHeight()});k=new qb(i);E=new rb(function(j){return P.find("td:eq("+j+") div div")})}function Kb(){function a(ca,z){t(ca);aa(f(ca),z)}function b(){y();Z().empty()}function f(ca){var z=la(),V=oa(),c=C(h.visStart);V=S(C(c),V);var B=l.map(ca,Na),F,G,ga,ma,ja,H,T=[];for(F=0;F<z;F++){G=$a(ab(ca,B,c,V));for(ga=0;ga<G.length;ga++){ma=
G[ga];for(ja=0;ja<ma.length;ja++){H=ma[ja];H.row=F;H.level=ga;T.push(H)}}S(c,7);S(V,7)}return T}function e(ca,z,V){N(ca,z);if(ca.editable||ca.editable===ha&&m("editable")){g(ca,z);V.isEnd&&ka(ca,z,V)}}function g(ca,z){if(!m("disableDragging")&&z.draggable){var V=ia(),c;z.draggable({zIndex:9,delay:50,opacity:m("dragOpacity"),revertDuration:m("dragRevertDuration"),start:function(B,F){o("eventDragStart",z,ca,B,F);r(ca,z);V.start(function(G,ga,ma,ja){z.draggable("option","revert",!G||!ma&&!ja);X();if(G){c=
ma*7+ja*(m("isRTL")?-1:1);da(S(C(ca.start),c),S(Na(ca),c))}else c=0},B,"drag")},stop:function(B,F){V.stop();X();o("eventDragStop",z,ca,B,F);if(c){z.find("a").removeAttr("href");s(this,ca,c,0,ca.allDay,B,F)}else{l.browser.msie&&z.css("filter","");O(ca,z)}}})}}var h=this;h.renderEvents=a;h.compileDaySegs=f;h.clearEvents=b;h.bindDaySeg=e;sb.call(h);var m=h.opt,o=h.trigger,t=h.reportEvents,y=h.reportEventClear,N=h.eventElementHandlers,O=h.showEvents,r=h.hideEvents,s=h.eventDrop,Z=h.getDaySegmentContainer,
ia=h.getHoverListener,da=h.renderDayOverlay,X=h.clearOverlays,la=h.getRowCnt,oa=h.getColCnt,aa=h.renderDaySegs,ka=h.resizableDayEvent}function Lb(a,b){function f(o,t){t&&S(o,t*7);o=S(C(o),-((o.getDay()-g("firstDay")+7)%7));t=S(C(o),7);var y=C(o),N=C(t),O=g("weekends");if(!O){ta(y);ta(N,-1,true)}e.title=m(y,S(C(N),-1),g("titleFormat"));e.start=o;e.end=t;e.visStart=y;e.visEnd=N;h(O?7:5)}var e=this;e.render=f;tb.call(e,a,b,"agendaWeek");var g=e.opt,h=e.renderAgenda,m=b.formatDates}function Mb(a,b){function f(o,
t){if(t){S(o,t);g("weekends")||ta(o,t<0?-1:1)}t=C(o,true);var y=S(C(t),1);e.title=m(o,g("titleFormat"));e.start=e.visStart=t;e.end=e.visEnd=y;h(1)}var e=this;e.render=f;tb.call(e,a,b,"agendaDay");var g=e.opt,h=e.renderAgenda,m=b.formatDate}function tb(a,b,f){function e(n){d=n;fa=T("theme")?"ui":"fc";W=T("weekends")?0:1;na=T("firstDay");if(sa=T("isRTL")){ea=-1;pa=d-1}else{ea=1;pa=0}Aa=bb(T("minTime"));Ba=bb(T("maxTime"));n=sa?S(C(H.visEnd),-1):C(H.visStart);var x=C(n),M=Ga(new Date),R=T("columnFormat");
if(v){Y();v.find("tr:first th").slice(1,-1).each(function(Ja,xa){l(xa).text(P(x,R));xa.className=xa.className.replace(/^fc-\w+(?= )/,"fc-"+Ca[x.getDay()]);S(x,ea);W&&ta(x,ea)});x=C(n);j.find("td").each(function(Ja,xa){xa.className=xa.className.replace(/^fc-\w+(?= )/,"fc-"+Ca[x.getDay()]);+x==+M?l(xa).removeClass("fc-not-today").addClass("fc-today").addClass(fa+"-state-highlight"):l(xa).addClass("fc-not-today").removeClass("fc-today").removeClass(fa+"-state-highlight");S(x,ea);W&&ta(x,ea)})}else{var ba,
ua,Da=T("slotMinutes")%15==0,qa="<div class='fc-agenda-head' style='position:relative;z-index:4'><table style='width:100%'><tr class='fc-first"+(T("allDaySlot")?"":" fc-last")+"'><th class='fc-leftmost "+fa+"-state-default'>&nbsp;</th>";for(ba=0;ba<d;ba++){qa+="<th class='fc-"+Ca[x.getDay()]+" "+fa+"-state-default'>"+P(x,R)+"</th>";S(x,ea);W&&ta(x,ea)}qa+="<th class='"+fa+"-state-default'>&nbsp;</th></tr>";if(T("allDaySlot"))qa+="<tr class='fc-all-day'><th class='fc-axis fc-leftmost "+fa+"-state-default'>"+
T("allDayText")+"</th><td colspan='"+d+"' class='"+fa+"-state-default'><div class='fc-day-content'><div style='position:relative'>&nbsp;</div></div></td><th class='"+fa+"-state-default'>&nbsp;</th></tr><tr class='fc-divider fc-last'><th colspan='"+(d+2)+"' class='"+fa+"-state-default fc-leftmost'><div/></th></tr>";qa+="</table></div>";v=l(qa).appendTo(a);y(v.find("td"));ub=l("<div style='position:absolute;z-index:8;top:0;left:0'/>").appendTo(v);x=vb();var cb=ra(C(x),Ba);ra(x,Aa);qa="<table>";for(ba=
0;x<cb;ba++){ua=x.getMinutes();qa+="<tr class='"+(!ba?"fc-first":!ua?"":"fc-minor")+"'><th class='fc-axis fc-leftmost "+fa+"-state-default'>"+(!Da||!ua?P(x,T("axisFormat")):"&nbsp;")+"</th><td class='fc-slot"+ba+" "+fa+"-state-default'><div style='position:relative'>&nbsp;</div></td></tr>";ra(x,T("slotMinutes"));p++}qa+="</table>";i=l("<div class='fc-agenda-body' style='position:relative;z-index:2;overflow:auto'/>").append(k=l("<div style='position:relative;overflow:hidden'>").append(E=l(qa))).appendTo(a);
N(i.find("td"));wb=l("<div style='position:absolute;z-index:8;top:0;left:0'/>").appendTo(k);x=C(n);qa="<div class='fc-agenda-bg' style='position:absolute;z-index:1'><table style='width:100%;height:100%'><tr class='fc-first'>";for(ba=0;ba<d;ba++){qa+="<td class='fc-"+Ca[x.getDay()]+" "+fa+"-state-default "+(!ba?"fc-leftmost ":"")+(+x==+M?fa+"-state-highlight fc-today":"fc-not-today")+"'><div class='fc-day-content'><div>&nbsp;</div></div></td>";S(x,ea);W&&ta(x,ea)}qa+="</tr></table></div>";j=l(qa).appendTo(a)}}
function g(n,x){if(n===ha)n=A;A=n;db={};n=n-v.height();n=Math.min(n,E.height());i.height(n);$=i.find("tr:first div").height()+1;x&&m()}function h(n){q=n;Qa.clear();i.width(n).css("overflow","auto");E.width("");var x=v.find("tr:first th"),M=v.find("tr.fc-all-day th:last"),R=j.find("td"),ba=i[0].clientWidth;E.width(ba);ba=i[0].clientWidth;E.width(ba);u=0;Ia(v.find("tr:lt(2) th:first").add(i.find("tr:first th")).width(1).each(function(){u=Math.max(u,l(this).outerWidth())}),u);U=Math.floor((ba-u)/d);
Ia(R.slice(0,-1),U);Ia(x.slice(1,-2),U);if(n!=ba){Ia(x.slice(-2,-1),ba-u-U*(d-1));x.slice(-1).show();M.show()}else{i.css("overflow","hidden");x.slice(-2,-1).width("");x.slice(-1).hide();M.hide()}j.css({top:v.find("tr").height(),left:u,width:ba-u,height:A})}function m(){var n=vb(),x=C(n);x.setHours(T("firstHour"));var M=oa(n,x)+1;n=function(){i.scrollTop(M)};n();setTimeout(n,0)}function o(){J=i.scrollTop()}function t(){i.scrollTop(J)}function y(n){n.click(O).mousedown(D)}function N(n){n.click(O).mousedown(ga)}
function O(n){if(!T("selectable")){var x=Math.min(d-1,Math.floor((n.pageX-j.offset().left)/U));x=S(C(H.visStart),x*ea+pa);var M=this.className.match(/fc-slot(\d+)/);if(M){M=parseInt(M[1])*T("slotMinutes");var R=Math.floor(M/60);x.setHours(R);x.setMinutes(M%60+Aa);va("dayClick",this,x,false,n)}else va("dayClick",this,x,true,n)}}function r(n,x,M){M&&wa.build();var R=C(H.visStart);if(sa){M=za(x,R)*ea+pa+1;n=za(n,R)*ea+pa+1}else{M=za(n,R);n=za(x,R)}M=Math.max(0,M);n=Math.min(d,n);M<n&&y(s(0,M,0,n-1))}
function s(n,x,M,R){n=wa.rect(n,x,M,R,v);return w(n,v)}function Z(n,x){for(var M=C(H.visStart),R=S(C(M),1),ba=0;ba<d;ba++){var ua=new Date(Math.max(M,n)),Da=new Date(Math.min(R,x));if(ua<Da){var qa=ba*ea+pa;qa=wa.rect(0,qa,0,qa,k);ua=oa(M,ua);Da=oa(M,Da);qa.top=ua;qa.height=Da-ua;N(w(qa,k))}S(M,1);S(R,1)}}function ia(n){return u+Qa.left(n)}function da(n){return u+Qa.right(n)}function X(n){return(n-Math.max(na,W)+d)%d*ea+pa}function la(n){return{row:Math.floor(za(n,H.visStart)/7),col:X(n.getDay())}}
function oa(n,x){n=C(n,true);if(x<ra(C(n),Aa))return 0;if(x>=ra(C(n),Ba))return k.height();n=T("slotMinutes");x=x.getHours()*60+x.getMinutes()-Aa;var M=Math.floor(x/n),R=db[M];if(R===ha)R=db[M]=i.find("tr:eq("+M+") td div")[0].offsetTop;return Math.max(0,Math.round(R-1+$*(x%n/n)))}function aa(n){var x=S(C(H.visStart),n.col*ea+pa);n=n.row;T("allDaySlot")&&n--;n>=0&&ra(x,Aa+n*T("slotMinutes"));return x}function ka(n){return T("allDaySlot")&&!n.row}function ca(){return{left:u,right:q}}function z(){return v.find("tr.fc-all-day")}
function V(n){var x=C(n.start);if(n.allDay)return x;return ra(x,T("defaultEventMinutes"))}function c(n,x){if(x)return C(n);return ra(C(n),T("slotMinutes"))}function B(n,x,M){if(M)T("allDaySlot")&&r(n,S(C(x),1),true);else F(n,x)}function F(n,x){var M=T("selectHelper");wa.build();if(M){var R=za(n,H.visStart)*ea+pa;if(R>=0&&R<d){R=wa.rect(0,R,0,R,k);var ba=oa(n,n),ua=oa(n,x);if(ua>ba){R.top=ba;R.height=ua-ba;R.left+=2;R.width-=5;if(l.isFunction(M)){if(n=M(n,x)){R.position="absolute";R.zIndex=8;ya=l(n).css(R).appendTo(k)}}else{ya=
l(I({title:"",start:n,end:x,className:[],editable:false},R,"fc-event fc-event-vert fc-corner-top fc-corner-bottom "));l.browser.msie&&ya.find("span.fc-event-bg").hide();ya.css("opacity",T("dragOpacity"))}if(ya){N(ya);k.append(ya);Ia(ya,R.width,true);Pa(ya,R.height,true)}}}}else Z(n,x)}function G(){K();if(ya){ya.remove();ya=null}}function ga(n){if(n.which==1&&T("selectable")){L(n);var x=this,M;Ka.start(function(R,ba){G();if(R&&R.col==ba.col&&!ka(R)){ba=aa(ba);R=aa(R);M=[ba,ra(C(ba),T("slotMinutes")),
R,ra(C(R),T("slotMinutes"))].sort(eb);F(M[0],M[3])}else M=null},n);l(document).one("mouseup",function(R){Ka.stop();if(M){+M[0]==+M[1]&&va("dayClick",x,M[0],false,R);Q(M[0],M[3],false,R)}})}}function ma(n,x){Ka.start(function(M){K();if(M)if(ka(M))s(M.row,M.col,M.row,M.col);else{M=aa(M);var R=ra(C(M),T("defaultEventMinutes"));Z(M,R)}},x)}function ja(n,x,M){var R=Ka.stop();K();R&&va("drop",n,aa(R),ka(R),x,M)}var H=this;H.renderAgenda=e;H.setWidth=h;H.setHeight=g;H.beforeHide=o;H.afterShow=t;H.defaultEventEnd=
V;H.timePosition=oa;H.dayOfWeekCol=X;H.dateCell=la;H.cellDate=aa;H.cellIsAllDay=ka;H.allDayTR=z;H.allDayBounds=ca;H.getHoverListener=function(){return Ka};H.colContentLeft=ia;H.colContentRight=da;H.getDaySegmentContainer=function(){return ub};H.getSlotSegmentContainer=function(){return wb};H.getMinMinute=function(){return Aa};H.getMaxMinute=function(){return Ba};H.getBodyContent=function(){return k};H.getRowCnt=function(){return 1};H.getColCnt=function(){return d};H.getColWidth=function(){return U};
H.getSlotHeight=function(){return $};H.defaultSelectionEnd=c;H.renderDayOverlay=r;H.renderSelection=B;H.clearSelection=G;H.dragStart=ma;H.dragStop=ja;lb.call(H,a,b,f);mb.call(H);nb.call(H);Nb.call(H);var T=H.opt,va=H.trigger,Y=H.clearEvents,w=H.renderOverlay,K=H.clearOverlays,Q=H.reportSelection,L=H.unselect,D=H.daySelectionMousedown,I=H.slotSegHtml,P=b.formatDate,v,i,k,E,j,d,p=0,u,U,$,q,A,J,fa,na,W,sa,ea,pa,Aa,Ba,wa,Ka,Qa,db={},ya,ub,wb;ob(a.addClass("fc-agenda"));wa=new pb(function(n,x){function M(xa){return Math.max(qa,
Math.min(cb,xa))}var R,ba,ua;j.find("td").each(function(xa,Ob){R=l(Ob);ba=R.offset().left;if(xa)ua[1]=ba;ua=[ba];x[xa]=ua});ua[1]=ba+R.outerWidth();if(T("allDaySlot")){R=v.find("td");ba=R.offset().top;n[0]=[ba,ba+R.outerHeight()]}for(var Da=k.offset().top,qa=i.offset().top,cb=qa+i.outerHeight(),Ja=0;Ja<p;Ja++)n.push([M(Da+$*Ja),M(Da+$*(Ja+1))])});Ka=new qb(wa);Qa=new rb(function(n){return j.find("td:eq("+n+") div div")})}function Nb(){function a(i,k){da(i);var E,j=i.length,d=[],p=[];for(E=0;E<j;E++)i[E].allDay?
d.push(i[E]):p.push(i[E]);if(s("allDaySlot")){G(f(d),k);oa()}h(e(p),k)}function b(){X();aa().empty();ka().empty()}function f(i){i=$a(ab(i,l.map(i,Na),r.visStart,r.visEnd));var k,E=i.length,j,d,p,u=[];for(k=0;k<E;k++){j=i[k];for(d=0;d<j.length;d++){p=j[d];p.row=0;p.level=k;u.push(p)}}return u}function e(i){var k=ma(),E=V(),j=z(),d=ra(C(r.visStart),E),p=l.map(i,g),u,U,$,q,A,J,fa=[];for(u=0;u<k;u++){U=$a(ab(i,p,d,ra(C(d),j-E)));Pb(U);for($=0;$<U.length;$++){q=U[$];for(A=0;A<q.length;A++){J=q[A];J.col=
u;J.level=$;fa.push(J)}}S(d,1,true)}return fa}function g(i){return i.end?C(i.end):ra(C(i.start),s("defaultEventMinutes"))}function h(i,k){var E,j=i.length,d,p,u,U,$,q,A,J,fa,na,W="",sa,ea,pa={},Aa={},Ba=ka(),wa;E=ma();if(sa=s("isRTL")){ea=-1;wa=E-1}else{ea=1;wa=0}for(E=0;E<j;E++){d=i[E];p=d.event;u="fc-event fc-event-vert ";if(d.isStart)u+="fc-corner-top ";if(d.isEnd)u+="fc-corner-bottom ";U=c(d.start,d.start);$=c(d.start,d.end);q=d.col;A=d.level;J=d.forward||0;fa=B(q*ea+wa);na=F(q*ea+wa)-fa;na=Math.min(na-
6,na*0.95);q=A?na/(A+J+1):J?(na/(J+1)-6)*2:na;A=fa+na/(A+J+1)*A*ea+(sa?na-q:0);d.top=U;d.left=A;d.outerWidth=q;d.outerHeight=$-U;W+=m(p,d,u)}Ba[0].innerHTML=W;sa=Ba.children();for(E=0;E<j;E++){d=i[E];p=d.event;W=l(sa[E]);ea=Z("eventRender",p,p,W);if(ea===false)W.remove();else{if(ea&&ea!==true){W.remove();W=l(ea).css({position:"absolute",top:d.top,left:d.left}).appendTo(Ba)}d.element=W;if(p._id===k)t(p,W,d);else W[0]._fci=E;va(p,W)}}xb(Ba,i,t);for(E=0;E<j;E++){d=i[E];if(W=d.element){p=pa[k=d.key=yb(W[0])];
d.vsides=p===ha?(pa[k]=Sa(W[0],true)):p;p=Aa[k];d.hsides=p===ha?(Aa[k]=fb(W[0],true)):p;k=W.find("span.fc-event-title");if(k.length)d.titleTop=k[0].offsetTop}}for(E=0;E<j;E++){d=i[E];if(W=d.element){W[0].style.width=Math.max(0,d.outerWidth-d.hsides)+"px";pa=Math.max(0,d.outerHeight-d.vsides);W[0].style.height=pa+"px";p=d.event;if(d.titleTop!==ha&&pa-d.titleTop<10){W.find("span.fc-event-time").text(P(p.start,s("timeFormat"))+" - "+p.title);W.find("span.fc-event-title").remove()}Z("eventAfterRender",
p,p,W)}}}function m(i,k,E){return"<div class='"+E+i.className.join(" ")+"' style='position:absolute;z-index:8;top:"+k.top+"px;left:"+k.left+"px'><a"+(i.url?" href='"+La(i.url)+"'":"")+"><span class='fc-event-bg'></span><span class='fc-event-time'>"+La(v(i.start,i.end,s("timeFormat")))+"</span><span class='fc-event-title'>"+La(i.title)+"</span></a>"+((i.editable||i.editable===ha&&s("editable"))&&!s("disableResizing")&&l.fn.resizable?"<div class='ui-resizable-handle ui-resizable-s'>=</div>":"")+"</div>"}
function o(i,k,E){la(i,k);if(i.editable||i.editable===ha&&s("editable")){y(i,k,E.isStart);E.isEnd&&ga(i,k,E)}}function t(i,k,E){la(i,k);if(i.editable||i.editable===ha&&s("editable")){var j=k.find("span.fc-event-time");N(i,k,j);E.isEnd&&O(i,k,j)}}function y(i,k,E){if(!s("disableDragging")&&k.draggable){var j,d=true,p,u=s("isRTL")?-1:1,U=ca(),$=ja(),q=H(),A=V();k.draggable({zIndex:9,opacity:s("dragOpacity","month"),revertDuration:s("dragRevertDuration"),start:function(fa,na){Z("eventDragStart",k,i,
fa,na);w(i,k);j=k.width();U.start(function(W,sa,ea,pa){k.draggable("option","revert",!W||!ea&&!pa);D();if(W){p=pa*u;if(W.row){if(E&&d){Pa(k.width($-10),q*Math.round((i.end?(i.end-i.start)/Qb:s("defaultEventMinutes"))/s("slotMinutes")));k.draggable("option","grid",[$,1]);d=false}}else{L(S(C(i.start),p),S(Na(i),p));J()}}},fa,"drag")},stop:function(fa,na){var W=U.stop();D();Z("eventDragStop",k,i,fa,na);if(W&&(!d||p)){k.find("a").removeAttr("href");W=0;d||(W=Math.round((k.offset().top-T().offset().top)/
q)*s("slotMinutes")+A-(i.start.getHours()*60+i.start.getMinutes()));K(this,i,p,W,d,fa,na)}else{J();l.browser.msie&&k.css("filter","");Y(i,k)}}});function J(){if(!d){k.width(j).height("").draggable("option","grid",null);d=true}}}}function N(i,k,E){if(!s("disableDragging")&&k.draggable){var j,d=false,p,u,U,$=s("isRTL")?-1:1,q=ca(),A=ma(),J=ja(),fa=H();k.draggable({zIndex:9,scroll:false,grid:[J,fa],axis:A==1?"y":false,opacity:s("dragOpacity"),revertDuration:s("dragRevertDuration"),start:function(sa,
ea){Z("eventDragStart",k,i,sa,ea);w(i,k);l.browser.msie&&k.find("span.fc-event-bg").hide();j=k.position();u=U=0;q.start(function(pa,Aa,Ba,wa){k.draggable("option","revert",!pa);D();if(pa){p=wa*$;if(s("allDaySlot")&&!pa.row){if(!d){d=true;E.hide();k.draggable("option","grid",null)}L(S(C(i.start),p),S(Na(i),p))}else W()}},sa,"drag")},drag:function(sa,ea){u=Math.round((ea.position.top-j.top)/fa)*s("slotMinutes");if(u!=U){d||na(u);U=u}},stop:function(sa,ea){var pa=q.stop();D();Z("eventDragStop",k,i,sa,
ea);if(pa&&(p||u||d))K(this,i,p,d?0:u,d,sa,ea);else{W();k.css(j);na(0);l.browser.msie&&k.css("filter","").find("span.fc-event-bg").css("display","");Y(i,k)}}});function na(sa){var ea=ra(C(i.start),sa),pa;if(i.end)pa=ra(C(i.end),sa);E.text(v(ea,pa,s("timeFormat")))}function W(){if(d){E.css("display","");k.draggable("option","grid",[J,fa]);d=false}}}}function O(i,k,E){if(!s("disableResizing")&&k.resizable){var j,d,p=H();k.resizable({handles:{s:"div.ui-resizable-s"},grid:p,start:function(u,U){j=d=0;
w(i,k);l.browser.msie&&l.browser.version=="6.0"&&k.css("overflow","hidden");k.css("z-index",9);Z("eventResizeStart",this,i,u,U)},resize:function(u,U){j=Math.round((Math.max(p,k.height())-U.originalSize.height)/p);if(j!=d){E.text(v(i.start,!j&&!i.end?null:ra(ia(i),s("slotMinutes")*j),s("timeFormat")));d=j}},stop:function(u,U){Z("eventResizeStop",this,i,u,U);if(j)Q(this,i,0,s("slotMinutes")*j,u,U);else{k.css("z-index",8);Y(i,k)}}})}}var r=this;r.renderEvents=a;r.compileDaySegs=f;r.clearEvents=b;r.slotSegHtml=
m;r.bindDaySeg=o;sb.call(r);var s=r.opt,Z=r.trigger,ia=r.eventEnd,da=r.reportEvents,X=r.reportEventClear,la=r.eventElementHandlers,oa=r.setHeight,aa=r.getDaySegmentContainer,ka=r.getSlotSegmentContainer,ca=r.getHoverListener,z=r.getMaxMinute,V=r.getMinMinute,c=r.timePosition,B=r.colContentLeft,F=r.colContentRight,G=r.renderDaySegs,ga=r.resizableDayEvent,ma=r.getColCnt,ja=r.getColWidth,H=r.getSlotHeight,T=r.getBodyContent,va=r.reportEventElement,Y=r.showEvents,w=r.hideEvents,K=r.eventDrop,Q=r.eventResize,
L=r.renderDayOverlay,D=r.clearOverlays,I=r.calendar,P=I.formatDate,v=I.formatDates}function Pb(a){var b,f,e,g,h,m;for(b=a.length-1;b>0;b--){g=a[b];for(f=0;f<g.length;f++){h=g[f];for(e=0;e<a[b-1].length;e++){m=a[b-1][e];if(zb(h,m))m.forward=Math.max(m.forward||0,(h.forward||0)+1)}}}}function lb(a,b,f){function e(c,B){c=V[c];if(typeof c=="object")return Wa(c,B||f);return c}function g(c,B){return b.trigger.apply(b,[c,B||X].concat(Array.prototype.slice.call(arguments,2),[X]))}function h(c){ka={};var B,
F=c.length,G;for(B=0;B<F;B++){G=c[B];if(ka[G._id])ka[G._id].push(G);else ka[G._id]=[G]}}function m(c){return c.end?C(c.end):la(c)}function o(c,B){ca.push(B);if(z[c._id])z[c._id].push(B);else z[c._id]=[B]}function t(){ca=[];z={}}function y(c,B){B.click(function(F){if(!B.hasClass("ui-draggable-dragging")&&!B.hasClass("ui-resizable-resizing"))return g("eventClick",this,c,F)}).hover(function(F){g("eventMouseover",this,c,F)},function(F){g("eventMouseout",this,c,F)})}function N(c,B){r(c,B,"show")}function O(c,
B){r(c,B,"hide")}function r(c,B,F){c=z[c._id];var G,ga=c.length;for(G=0;G<ga;G++)if(!B||c[G][0]!=B[0])c[G][F]()}function s(c,B,F,G,ga,ma,ja){var H=B.allDay,T=B._id;ia(ka[T],F,G,ga);g("eventDrop",c,B,F,G,ga,function(){ia(ka[T],-F,-G,H);aa(T)},ma,ja);aa(T)}function Z(c,B,F,G,ga,ma){var ja=B._id;da(ka[ja],F,G);g("eventResize",c,B,F,G,function(){da(ka[ja],-F,-G);aa(ja)},ga,ma);aa(ja)}function ia(c,B,F,G){F=F||0;for(var ga,ma=c.length,ja=0;ja<ma;ja++){ga=c[ja];if(G!==ha)ga.allDay=G;ra(S(ga.start,B,true),
F);if(ga.end)ga.end=ra(S(ga.end,B,true),F);oa(ga,V)}}function da(c,B,F){F=F||0;for(var G,ga=c.length,ma=0;ma<ga;ma++){G=c[ma];G.end=ra(S(m(G),B,true),F);oa(G,V)}}var X=this;X.element=a;X.calendar=b;X.name=f;X.opt=e;X.trigger=g;X.reportEvents=h;X.eventEnd=m;X.reportEventElement=o;X.reportEventClear=t;X.eventElementHandlers=y;X.showEvents=N;X.hideEvents=O;X.eventDrop=s;X.eventResize=Z;var la=X.defaultEventEnd,oa=b.normalizeEvent,aa=b.reportEventChange,ka={},ca=[],z={},V=b.options}function sb(){function a(w,
K){var Q=ma(),L=ka(),D=ca(),I=0,P,v,i=w.length,k,E;Q[0].innerHTML=f(w);e(w,Q.children());g(w);h(w,Q,K);m(w);o(w);t(w);K=y();for(Q=0;Q<L;Q++){P=[];for(v=0;v<D;v++)P[v]=0;for(;I<i&&(k=w[I]).row==Q;){v=Ab(P.slice(k.startCol,k.endCol));k.top=v;v+=k.outerHeight;for(E=k.startCol;E<k.endCol;E++)P[E]=v;I++}K[Q].height(Ab(P))}O(w,N(K))}function b(w,K,Q){var L=l("<div/>"),D=ma(),I=w.length,P;L[0].innerHTML=f(w);L=L.children();D.append(L);e(w,L);m(w);o(w);t(w);O(w,N(y()));L=[];for(D=0;D<I;D++)if(P=w[D].element){w[D].row===
K&&P.css("top",Q);L.push(P[0])}return l(L)}function f(w){var K=Z("isRTL"),Q,L=w.length,D,I,P;Q=V();var v=Q.left,i=Q.right,k=[],E,j,d="";for(Q=0;Q<L;Q++){D=w[Q];I=D.event;P="fc-event fc-event-hori ";if(K){if(D.isStart)P+="fc-corner-right ";if(D.isEnd)P+="fc-corner-left ";k[0]=F(D.end.getDay()-1);k[1]=F(D.start.getDay());E=D.isEnd?c(k[0]):v;j=D.isStart?B(k[1]):i}else{if(D.isStart)P+="fc-corner-left ";if(D.isEnd)P+="fc-corner-right ";k[0]=F(D.start.getDay());k[1]=F(D.end.getDay()-1);E=D.isStart?c(k[0]):
v;j=D.isEnd?B(k[1]):i}d+="<div class='"+P+I.className.join(" ")+"' style='position:absolute;z-index:8;left:"+E+"px'><a"+(I.url?" href='"+La(I.url)+"'":"")+">"+(!I.allDay&&D.isStart?"<span class='fc-event-time'>"+La(H(I.start,I.end,Z("timeFormat")))+"</span>":"")+"<span class='fc-event-title'>"+La(I.title)+"</span></a>"+(D.isEnd&&(I.editable||I.editable===ha&&Z("editable"))&&!Z("disableResizing")?"<div class='ui-resizable-handle ui-resizable-"+(K?"w":"e")+"'></div>":"")+"</div>";D.left=E;D.outerWidth=
j-E;k.sort(eb);D.startCol=k[0];D.endCol=k[1]+1}return d}function e(w,K){var Q,L=w.length,D,I,P;for(Q=0;Q<L;Q++){D=w[Q];I=D.event;P=l(K[Q]);I=ia("eventRender",I,I,P);if(I===false)P.remove();else{if(I&&I!==true){I=l(I).css({position:"absolute",left:D.left});P.replaceWith(I);P=I}D.element=P}}}function g(w){var K,Q=w.length,L,D;for(K=0;K<Q;K++){L=w[K];(D=L.element)&&X(L.event,D)}}function h(w,K,Q){var L,D=w.length,I,P,v;for(L=0;L<D;L++){I=w[L];if(P=I.element){v=I.event;if(v._id===Q)ja(v,P,I);else P[0]._fci=
L}}xb(K,w,ja)}function m(w){var K,Q=w.length,L,D,I,P,v={};for(K=0;K<Q;K++){L=w[K];if(D=L.element){I=L.key=yb(D[0]);P=v[I];if(P===ha)P=v[I]=fb(D[0],true);L.hsides=P}}}function o(w){var K,Q=w.length,L,D;for(K=0;K<Q;K++){L=w[K];if(D=L.element)D[0].style.width=Math.max(0,L.outerWidth-L.hsides)+"px"}}function t(w){var K,Q=w.length,L,D,I,P,v={};for(K=0;K<Q;K++){L=w[K];if(D=L.element){I=L.key;P=v[I];if(P===ha)P=v[I]=Bb(D[0]);L.outerHeight=D[0].offsetHeight+P}}}function y(){var w,K=ka(),Q=[];for(w=0;w<K;w++)Q[w]=
z(w).find("td:first div.fc-day-content > div");return Q}function N(w){var K,Q=w.length,L=[];for(K=0;K<Q;K++)L[K]=w[K][0].offsetTop;return L}function O(w,K){var Q,L=w.length,D,I;for(Q=0;Q<L;Q++){D=w[Q];if(I=D.element){I[0].style.top=K[D.row]+(D.top||0)+"px";D=D.event;ia("eventAfterRender",D,D,I)}}}function r(w,K,Q){if(!Z("disableResizing")&&Q.isEnd){var L=Z("isRTL"),D=L?"w":"e";K.find("div.ui-resizable-"+D).mousedown(function(I){function P(q){ia("eventResizeStop",this,w,q);l("body").css("cursor","auto");
v.stop();va();p&&aa(this,w,p,0,q)}if(I.which==1){var v=s.getHoverListener(),i=ka(),k=ca(),E=L?-1:1,j=L?k:0,d=K.css("top"),p,u,U=l.extend({},w),$=G(w.start);Y();l("body").css("cursor",D+"-resize").one("mouseup",P);ia("eventResizeStart",this,w,I);v.start(function(q,A){if(q){var J=Math.max($.row,q.row);q=q.col;if(i==1)J=0;if(J==$.row)q=L?Math.min($.col,q):Math.max($.col,q);p=J*7+q*E+j-(A.row*7+A.col*E+j);A=S(da(w),p,true);if(p){U.end=A;J=u;u=b(ga([U]),Q.row,d);u.find("*").css("cursor",D+"-resize");J&&
J.remove();oa(w)}else if(u){la(w);u.remove();u=null}va();T(w.start,S(C(A),1))}},I)}})}}var s=this;s.renderDaySegs=a;s.resizableDayEvent=r;var Z=s.opt,ia=s.trigger,da=s.eventEnd,X=s.reportEventElement,la=s.showEvents,oa=s.hideEvents,aa=s.eventResize,ka=s.getRowCnt,ca=s.getColCnt,z=s.allDayTR,V=s.allDayBounds,c=s.colContentLeft,B=s.colContentRight,F=s.dayOfWeekCol,G=s.dateCell,ga=s.compileDaySegs,ma=s.getDaySegmentContainer,ja=s.bindDaySeg,H=s.calendar.formatDates,T=s.renderDayOverlay,va=s.clearOverlays,
Y=s.clearSelection}function nb(){function a(O,r,s){b();r||(r=o(O,s));t(O,r,s);f(O,r,s)}function b(O){if(N){N=false;y();m("unselect",null,O)}}function f(O,r,s,Z){N=true;m("select",null,O,r,s,Z)}function e(O){var r=g.cellDate,s=g.cellIsAllDay,Z=g.getHoverListener();if(O.which==1&&h("selectable")){b(O);var ia=this,da;Z.start(function(X,la){y();if(X&&s(X)){da=[r(la),r(X)].sort(eb);t(da[0],da[1],true)}else da=null},O);l(document).one("mouseup",function(X){Z.stop();if(da){+da[0]==+da[1]&&m("dayClick",ia,
da[0],true,X);f(da[0],da[1],true,X)}})}}var g=this;g.select=a;g.unselect=b;g.reportSelection=f;g.daySelectionMousedown=e;var h=g.opt,m=g.trigger,o=g.defaultSelectionEnd,t=g.renderSelection,y=g.clearSelection,N=false;h("selectable")&&h("unselectAuto")&&l(document).mousedown(function(O){var r=h("unselectCancel");if(r)if(l(O.target).parents(r).length)return;b(O)})}function mb(){function a(h,m){var o=g.shift();o||(o=l("<div class='fc-cell-overlay' style='position:absolute;z-index:3'/>"));o[0].parentNode!=
m[0]&&o.appendTo(m);e.push(o.css(h).show());return o}function b(){for(var h;h=e.shift();)g.push(h.hide().unbind())}var f=this;f.renderOverlay=a;f.clearOverlays=b;var e=[],g=[]}function pb(a){var b=this,f,e;b.build=function(){f=[];e=[];a(f,e)};b.cell=function(g,h){var m=f.length,o=e.length,t,y=-1,N=-1;for(t=0;t<m;t++)if(h>=f[t][0]&&h<f[t][1]){y=t;break}for(t=0;t<o;t++)if(g>=e[t][0]&&g<e[t][1]){N=t;break}return y>=0&&N>=0?{row:y,col:N}:null};b.rect=function(g,h,m,o,t){t=t.offset();return{top:f[g][0]-
t.top,left:e[h][0]-t.left,width:e[o][1]-e[h][0],height:f[m][1]-f[g][0]}}}function qb(a){function b(o){o=a.cell(o.pageX,o.pageY);if(!o!=!m||o&&(o.row!=m.row||o.col!=m.col)){if(o){h||(h=o);g(o,h,o.row-h.row,o.col-h.col)}else g(o,h);m=o}}var f=this,e,g,h,m;f.start=function(o,t,y){g=o;h=m=null;a.build();b(t);e=y||"mousemove";l(document).bind(e,b)};f.stop=function(){l(document).unbind(e,b);return m}}function rb(a){function b(m){return e[m]=e[m]||a(m)}var f=this,e={},g={},h={};f.left=function(m){return g[m]=
g[m]===ha?b(m).position().left:g[m]};f.right=function(m){return h[m]=h[m]===ha?f.left(m)+b(m).width():h[m]};f.clear=function(){e={};g={};h={}}}function Ta(a,b,f){a.setFullYear(a.getFullYear()+b);f||Ga(a);return a}function Ua(a,b,f){if(+a){b=a.getMonth()+b;var e=C(a);e.setDate(1);e.setMonth(b);a.setMonth(b);for(f||Ga(a);a.getMonth()!=e.getMonth();)a.setDate(a.getDate()+(a<e?1:-1))}return a}function S(a,b,f){if(+a){b=a.getDate()+b;var e=C(a);e.setHours(9);e.setDate(b);a.setDate(b);f||Ga(a);gb(a,e)}return a}
function gb(a,b){if(+a)for(;a.getDate()!=b.getDate();)a.setTime(+a+(a<b?1:-1)*Rb)}function ra(a,b){a.setMinutes(a.getMinutes()+b);return a}function Ga(a){a.setHours(0);a.setMinutes(0);a.setSeconds(0);a.setMilliseconds(0);return a}function C(a,b){if(b)return Ga(new Date(+a));return new Date(+a)}function vb(){var a=0,b;do b=new Date(1970,a++,1);while(b.getHours());return b}function ta(a,b,f){for(b=b||1;!a.getDay()||f&&a.getDay()==1||!f&&a.getDay()==6;)S(a,b);return a}function za(a,b){return Math.round((C(a,
true)-C(b,true))/kb)}function jb(a,b,f,e){if(b!==ha&&b!=a.getFullYear()){a.setDate(1);a.setMonth(0);a.setFullYear(b)}if(f!==ha&&f!=a.getMonth()){a.setDate(1);a.setMonth(f)}e!==ha&&a.setDate(e)}function Xa(a,b){if(typeof a=="object")return a;if(typeof a=="number")return new Date(a*1E3);if(typeof a=="string"){if(a.match(/^\d+$/))return new Date(parseInt(a,10)*1E3);if(b===ha)b=true;return Cb(a,b)||(a?new Date(a):null)}return null}function Cb(a,b){a=a.match(/^([0-9]{4})(-([0-9]{2})(-([0-9]{2})([T ]([0-9]{2}):([0-9]{2})(:([0-9]{2})(\.([0-9]+))?)?(Z|(([-+])([0-9]{2}):([0-9]{2})))?)?)?)?$/);
if(!a)return null;var f=new Date(a[1],0,1);if(b||!a[14]){b=new Date(a[1],0,1,9,0);if(a[3]){f.setMonth(a[3]-1);b.setMonth(a[3]-1)}if(a[5]){f.setDate(a[5]);b.setDate(a[5])}gb(f,b);a[7]&&f.setHours(a[7]);a[8]&&f.setMinutes(a[8]);a[10]&&f.setSeconds(a[10]);a[12]&&f.setMilliseconds(Number("0."+a[12])*1E3);gb(f,b)}else{f.setUTCFullYear(a[1],a[3]?a[3]-1:0,a[5]||1);f.setUTCHours(a[7]||0,a[8]||0,a[10]||0,a[12]?Number("0."+a[12])*1E3:0);b=Number(a[16])*60+Number(a[17]);b*=a[15]=="-"?1:-1;f=new Date(+f+b*60*
1E3)}return f}function bb(a){if(typeof a=="number")return a*60;if(typeof a=="object")return a.getHours()*60+a.getMinutes();if(a=a.match(/(\d+)(?::(\d+))?\s*(\w+)?/)){var b=parseInt(a[1],10);if(a[3]){b%=12;if(a[3].toLowerCase().charAt(0)=="p")b+=12}return b*60+(a[2]?parseInt(a[2],10):0)}}function Ha(a,b,f){return Va(a,null,b,f)}function Va(a,b,f,e){e=e||Oa;var g=a,h=b,m,o=f.length,t,y,N,O="";for(m=0;m<o;m++){t=f.charAt(m);if(t=="'")for(y=m+1;y<o;y++){if(f.charAt(y)=="'"){if(g){O+=y==m+1?"'":f.substring(m+
1,y);m=y}break}}else if(t=="(")for(y=m+1;y<o;y++){if(f.charAt(y)==")"){m=Ha(g,f.substring(m+1,y),e);if(parseInt(m.replace(/\D/,""),10))O+=m;m=y;break}}else if(t=="[")for(y=m+1;y<o;y++){if(f.charAt(y)=="]"){t=f.substring(m+1,y);m=Ha(g,t,e);if(m!=Ha(h,t,e))O+=m;m=y;break}}else if(t=="{"){g=b;h=a}else if(t=="}"){g=a;h=b}else{for(y=o;y>m;y--)if(N=Sb[f.substring(m,y)]){if(g)O+=N(g,e);m=y-1;break}if(y==m)if(g)O+=t}}return O}function Na(a){return a.end?Tb(a.end,a.allDay):S(C(a.start),1)}function Tb(a,b){a=
C(a);return b||a.getHours()||a.getMinutes()?S(a,1):Ga(a)}function Ub(a,b){return(b.msLength-a.msLength)*100+(a.event.start-b.event.start)}function zb(a,b){return a.end>b.start&&a.start<b.end}function ab(a,b,f,e){var g=[],h,m=a.length,o,t,y,N,O;for(h=0;h<m;h++){o=a[h];t=o.start;y=b[h];if(y>f&&t<e){if(t<f){t=C(f);N=false}else{t=t;N=true}if(y>e){y=C(e);O=false}else{y=y;O=true}g.push({event:o,start:t,end:y,isStart:N,isEnd:O,msLength:y-t})}}return g.sort(Ub)}function $a(a){var b=[],f,e=a.length,g,h,m,
o;for(f=0;f<e;f++){g=a[f];for(h=0;;){m=false;if(b[h])for(o=0;o<b[h].length;o++)if(zb(b[h][o],g)){m=true;break}if(m)h++;else break}if(b[h])b[h].push(g);else b[h]=[g]}return b}function xb(a,b,f){a.unbind("mouseover").mouseover(function(e){for(var g=e.target,h;g!=this;){h=g;g=g.parentNode}if((g=h._fci)!==ha){h._fci=ha;h=b[g];f(h.event,h.element,h);l(e.target).trigger(e)}e.stopPropagation()})}function Ia(a,b,f){a.each(function(e,g){g.style.width=Math.max(0,b-fb(g,f))+"px"})}function Pa(a,b,f){a.each(function(e,
g){g.style.height=Math.max(0,b-Sa(g,f))+"px"})}function fb(a,b){return(parseFloat(l.curCSS(a,"paddingLeft",true))||0)+(parseFloat(l.curCSS(a,"paddingRight",true))||0)+(parseFloat(l.curCSS(a,"borderLeftWidth",true))||0)+(parseFloat(l.curCSS(a,"borderRightWidth",true))||0)+(b?Vb(a):0)}function Vb(a){return(parseFloat(l.curCSS(a,"marginLeft",true))||0)+(parseFloat(l.curCSS(a,"marginRight",true))||0)}function Sa(a,b){return(parseFloat(l.curCSS(a,"paddingTop",true))||0)+(parseFloat(l.curCSS(a,"paddingBottom",
true))||0)+(parseFloat(l.curCSS(a,"borderTopWidth",true))||0)+(parseFloat(l.curCSS(a,"borderBottomWidth",true))||0)+(b?Bb(a):0)}function Bb(a){return(parseFloat(l.curCSS(a,"marginTop",true))||0)+(parseFloat(l.curCSS(a,"marginBottom",true))||0)}function Ra(a,b){b=typeof b=="number"?b+"px":b;a[0].style.cssText+=";min-height:"+b+";_height:"+b}function ib(){}function eb(a,b){return a-b}function Ab(a){return Math.max.apply(Math,a)}function Ma(a){return(a<10?"0":"")+a}function Wa(a,b){if(a[b]!==ha)return a[b];
b=b.split(/(?=[A-Z])/);for(var f=b.length-1,e;f>=0;f--){e=a[b[f].toLowerCase()];if(e!==ha)return e}return a[""]}function La(a){return a.replace(/&/g,"&amp;").replace(/</g,"&lt;").replace(/>/g,"&gt;").replace(/'/g,"&#039;").replace(/"/g,"&quot;").replace(/\n/g,"<br />")}function yb(a){return a.id+"/"+a.className+"/"+a.style.cssText.replace(/(^|;)\s*(top|left|width|height)\s*:[^;]*/ig,"")}function ob(a){a.attr("unselectable","on").css("MozUserSelect","none").bind("selectstart.ui",function(){return false})}
var Oa={defaultView:"month",aspectRatio:1.35,header:{left:"title",center:"",right:"today prev,next"},weekends:true,allDayDefault:true,ignoreTimezone:true,lazyFetching:true,startParam:"start",endParam:"end",titleFormat:{month:"MMMM yyyy",week:"MMM d[ yyyy]{ '&#8212;'[ MMM] d yyyy}",day:"dddd, MMM d, yyyy"},columnFormat:{month:"ddd",week:"ddd M/d",day:"dddd M/d"},timeFormat:{"":"h(:mm)t"},isRTL:false,firstDay:0,monthNames:["January","February","March","April","May","June","July","August","September",
"October","November","December"],monthNamesShort:["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"],dayNames:["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"],dayNamesShort:["Sun","Mon","Tue","Wed","Thu","Fri","Sat"],buttonText:{prev:"&nbsp;&#9668;&nbsp;",next:"&nbsp;&#9658;&nbsp;",prevYear:"&nbsp;&lt;&lt;&nbsp;",nextYear:"&nbsp;&gt;&gt;&nbsp;",today:"today",month:"month",week:"week",day:"day"},theme:false,buttonIcons:{prev:"circle-triangle-w",next:"circle-triangle-e"},
unselectAuto:true,dropAccept:"*"},Wb={header:{left:"next,prev today",center:"",right:"title"},buttonText:{prev:"&nbsp;&#9658;&nbsp;",next:"&nbsp;&#9668;&nbsp;",prevYear:"&nbsp;&gt;&gt;&nbsp;",nextYear:"&nbsp;&lt;&lt;&nbsp;"},buttonIcons:{prev:"circle-triangle-e",next:"circle-triangle-w"}},Ea=l.fullCalendar={version:"1.4.10"},Fa=Ea.views={};l.fn.fullCalendar=function(a){if(typeof a=="string"){var b=Array.prototype.slice.call(arguments,1),f;this.each(function(){var g=l.data(this,"fullCalendar");if(g&&
l.isFunction(g[a])){g=g[a].apply(g,b);if(f===ha)f=g;a=="destroy"&&l.removeData(this,"fullCalendar")}});if(f!==ha)return f;return this}var e=a.eventSources||[];delete a.eventSources;if(a.events){e.push(a.events);delete a.events}a=l.extend(true,{},Oa,a.isRTL||a.isRTL===ha&&Oa.isRTL?Wb:{},a);this.each(function(g,h){g=l(h);h=new Db(g,a,e);g.data("fullCalendar",h);h.render()});return this};var Gb=1;Fa.month=Hb;Fa.basicWeek=Ib;Fa.basicDay=Jb;var Za;hb({weekMode:"fixed"});Fa.agendaWeek=Lb;Fa.agendaDay=Mb;
hb({allDaySlot:true,allDayText:"all-day",firstHour:6,slotMinutes:30,defaultEventMinutes:120,axisFormat:"h(:mm)tt",timeFormat:{agenda:"h:mm{ - h:mm}"},dragOpacity:{agenda:0.5},minTime:0,maxTime:24});Ea.addDays=S;Ea.cloneDate=C;Ea.parseDate=Xa;Ea.parseISO8601=Cb;Ea.parseTime=bb;Ea.formatDate=Ha;Ea.formatDates=Va;var Ca=["sun","mon","tue","wed","thu","fri","sat"],kb=864E5,Rb=36E5,Qb=6E4,Sb={s:function(a){return a.getSeconds()},ss:function(a){return Ma(a.getSeconds())},m:function(a){return a.getMinutes()},
mm:function(a){return Ma(a.getMinutes())},h:function(a){return a.getHours()%12||12},hh:function(a){return Ma(a.getHours()%12||12)},H:function(a){return a.getHours()},HH:function(a){return Ma(a.getHours())},d:function(a){return a.getDate()},dd:function(a){return Ma(a.getDate())},ddd:function(a,b){return b.dayNamesShort[a.getDay()]},dddd:function(a,b){return b.dayNames[a.getDay()]},M:function(a){return a.getMonth()+1},MM:function(a){return Ma(a.getMonth()+1)},MMM:function(a,b){return b.monthNamesShort[a.getMonth()]},
MMMM:function(a,b){return b.monthNames[a.getMonth()]},yy:function(a){return(a.getFullYear()+"").substring(2)},yyyy:function(a){return a.getFullYear()},t:function(a){return a.getHours()<12?"a":"p"},tt:function(a){return a.getHours()<12?"am":"pm"},T:function(a){return a.getHours()<12?"A":"P"},TT:function(a){return a.getHours()<12?"AM":"PM"},u:function(a){return Ha(a,"yyyy-MM-dd'T'HH:mm:ss'Z'")},S:function(a){a=a.getDate();if(a>10&&a<20)return"th";return["st","nd","rd"][a%10-1]||"th"}}})(jQuery);

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
		
		alert("contentH = " + contentH);
		alert("contentH = " + contentW);
		
		
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
