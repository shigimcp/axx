package com.armaniexchange;

import com.greensock.TweenLite;
import flash.display.Sprite;
import flash.display.MovieClip;
import flash.display.Loader;
import flash.net.URLRequest;
import flash.events.Event;

class ContentLoader extends Sprite {
    
    public var current_loader : Loader;
    public var previous_loader : Loader;
    
    public function new() {
        super();
    }
    
    public function load(_req : URLRequest) {
        var _loader = new Loader();
        _loader.load(_req);
        _loader.contentLoaderInfo.addEventListener(Event.COMPLETE, finished);
        _loader.alpha = 0;
        
        addChild(_loader);
        
        current_loader = _loader;
    }
    
    private function finished(e : Event) {
        if (previous_loader != null) {
            if (cast((previous_loader.content), MovieClip).exists("onClose")) {
                cast((previous_loader.content), MovieClip).onClose();
            }
            TweenLite.to(previous_loader, .5, {
                        alpha : 0,
                        onComplete : removeLoader,
                        onCompleteParams : [previous_loader]
                    });
        }
        TweenLite.to(current_loader, .5, {
                    alpha : 1,
                    delay : .5
                });
        previous_loader = current_loader;
        dispatchEvent(new Event(Event.COMPLETE));
    }
    
    private function removeLoader(_loader : Loader) {
        removeChild(_loader);
    }
    
    public function clear() {
        var _func = function() {
            while (numChildren > 0) {
                removeChildAt(0);
            }
        }
        
        if (cast((current_loader.content), MovieClip).exists("onClose")) {
            cast((current_loader.content), MovieClip).onClose();
        }
        TweenLite.to(current_loader, .5, {
                    alpha : 0,
                    onComplete : _func
                });
        current_loader = null;
        previous_loader = null;
    }
}