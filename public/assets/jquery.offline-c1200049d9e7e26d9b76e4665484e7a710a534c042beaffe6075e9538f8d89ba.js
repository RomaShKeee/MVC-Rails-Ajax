/*!
 * jQuery Offline
 * Version 1.0.0
 *
 * http://github.com/wycats/jquery-offline
 *
 * Copyright 2010, Yehuda Katz
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * Date: Fri Jul 9 10:20:00 2010 -0800
 */
!function(e){function t(a,n,i){e.isFunction(n)&&(i=n,n=null);var l=a+"?"+e.param(n||{});return r[l]?!1:(r[l]=!0,e.ajax({type:"GET",url:a,data:n,success:function(e,c){return delete r[l],void 0===e?void(window.navigator.onLine||(o=function(){t(a,n,i)})):void i(e,c)},error:function(){delete r[l]},dataType:"json",ifModified:!0}))}var a="offline.jquery:",o=null,r={};"undefined"==typeof e.support.localStorage&&(e.support.localStorage=!!window.localStorage),e.support.localStorage?(e(window).bind("online",function(){o&&o()}),e(window).bind("offline",function(){e.event.trigger("ajaxStop")}),e.retrieveJSON=function(r,n,i){function l(){for(var e=[],t=0;t<localStorage.length;++t){var a=localStorage.key(t);/:date$/.test(a)&&e.push(a)}e.sort(function(e,t){var a=localStorage[e],o=localStorage[t];return o>a?-1:a>o?1:0});for(var t=0;t<e.length/2;++t){var a=e[t];delete localStorage[a],delete localStorage[a.substr(0,a.length-5)]}}function c(){return t(r,n,function(e,t){if("notmodified"==t)return!1;for(;;)try{localStorage[f]=JSON.stringify(e),localStorage[f+":date"]=new Date;break}catch(a){("QUOTA_EXCEEDED_ERR"==a.name||"NS_ERROR_DOM_QUOTA_REACHED"==a.name)&&l()}var o=g&&{cachedAt:v,retrievedAt:u};i(e,t,o)})}e.isFunction(n)&&(i=n,n={});var u=new Date,d=e.param(n),f=a+r+":"+d,g=localStorage[f],S=localStorage[f+":date"],v=new Date(Date.parse(S));if(g){var p=e.parseJSON(g),s=i(p,"cached",{cachedAt:v});if(s===!1){var w=e.Deferred().promise();return w.done=function(e){e(p)},w}}return window.navigator.onLine?c():(o=c,!0)},e.clearJSON=function(t,o){var r=e.param(o||{});delete localStorage[a+t+":"+r],delete localStorage[a+t+":"+r+":date"]}):(e.retrieveJSON=t,e.clearJSON=e.noop)}(jQuery);