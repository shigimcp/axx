package com.armaniexchange;

import flash.display.Sprite;
import flash.display.Loader;
import com.greensock.TweenLite;
import com.greensock.easing.*;
import flash.events.Event;
import flash.display.MovieClip;

class Slideshow extends Sprite {
    public var currentSlide(get, never);
    public var album(get, set) : String;
    public var automatic(get, set);

    
    @:allow(com.armaniexchange)
    private var current_album : String;
    @:allow(com.armaniexchange)
    private var current_slide : Slide = null;
    @:allow(com.armaniexchange)
    private var previous_slide : Slide = null;
    @:allow(com.armaniexchange)
    private var slide_container : Sprite;
    @:allow(com.armaniexchange)
    private var current_slides : Array<Dynamic>;
    @:allow(com.armaniexchange)
    private var albums_arr : Array<Dynamic>;
    @:allow(com.armaniexchange)
    private var showWhenLoaded : Bool = true;
    
    public var fadeSpeed : Float = 2;
    
    private var _tween;
    
    public var _hidden : Bool = false;
    
    public var _auto : Bool = false;
    public var first_loaded;
    public var waiting = false;
    private var next_int;
    public var delay = 3;
    
    
    public function new() {
        super();
        albums_arr = new Array<Dynamic>();
        slide_container = new Sprite();
        addChild(slide_container);
    }
    
    public function jumpTo(_num) {
        previous_slide = current_slide;
        
        current_slide = current_slides[((_num % current_slides.length) + current_slides.length) % current_slides.length];
        
        display(current_slide);
    }
    
    public function display(_slide : Slide) {
        var tween_obj;
        _slide.alpha = 0;
        tween_obj = {
                    alpha : 1
                };
        
        slide_container.addChild(_slide);
        if (previous_slide != null) {
            tween_obj.onComplete = hideOld;
        }
        
        if (automatic) {
            tween_obj.onComplete = auto_next;
        }
        
        if (_tween) {
            _tween.vars.onComplete = null;
        }
        _tween = TweenLite.to(_slide, fadeSpeed, tween_obj);
        if (previous_slide != null) {
            for (i in 0...slide_container.numChildren - 1) {
                var _slide = cast((slide_container.getChildAt(i)), Slide);
                TweenLite.to(_slide, fadeSpeed, {
                            alpha : 0
                        });
            }
        }
    }
    
    private function hideOld() {
        while (slide_container.numChildren > 1) {
            slide_container.removeChildAt(0);
        }
    }
    
    private function auto_next() {
        hideOld();
        
        next_int = as3hx.Compat.setTimeout(next, 1000 * delay);
    }
    public function addAlbum(_xml : FastXML) {
        albums_arr.push({
                    id : Std.string(_xml.att.id),
                    slides : createSlides(_xml.node.children.innerData())
                });
    }
    
    public function viewAlbum(_album : String, _num) {
        album = _album;
        jumpTo(_num);
    }
    
    @:allow(com.armaniexchange)
    private function createSlides(_list) {
        var _arr = new Array<Dynamic>();
        
        for (item/* AS3HX WARNING could not determine type for var: item exp: EIdent(_list) type: null */ in _list) {
            _arr.push(new Slide(item));
        }
        
        return _arr;
    }
    
    public function slide_loaded(e : Event) {
        var _s = e.target;
        
        current_slide = _s;
        if (showWhenLoaded) {
            display(_s);
        }
        _s.removeEventListener(Event.COMPLETE, slide_loaded);
        
        if (!first_loaded) {
            dispatchEvent(new Event("first_loaded"));
            first_loaded = true;
        }
    }
    
    public function start() {
        if (!_hidden) {
            var _s = current_slides[0];
            if (_s.loaded) {
                current_slide = _s;
                display(_s);
            }
            else {
                _s.addEventListener(Event.COMPLETE, slide_loaded);
                first_loaded = false;
            }
        }
    }
    public function stop() {
        if (_tween) {
            _tween.vars.onComplete = null;
        }
        as3hx.Compat.clearTimeout(next_int);
        TweenLite.killDelayedCallsTo(start);
    }
    
    public function next() {
        var _num;
        if (current_slide == null) {
            _num = 0;
        }
        else {
            _num = Lambda.indexOf(current_slides, current_slide) + 1;
        }
        
        jumpTo(_num % current_slides.length);
    }
    public function prev() {
        var _num = Lambda.indexOf(current_slides, current_slide) - 1;
        jumpTo((_num + current_slides.length) % current_slides.length);
    }
    
    public function show() {
        if (_hidden) {
            TweenLite.to(this, 1, {
                        alpha : 1
                    });
            _hidden = false;
        }
    }
    
    public function hide() {
        if (!_hidden) {
            stop();
            TweenLite.to(this, 1, {
                        alpha : 0
                    });
            _hidden = true;
        }
    }
    
    private function get_currentSlide() {
        return current_slide;
    }
    
    private function set_album(_val : String) : String {
        current_album = _val;
        for (item in albums_arr) {
            if (item.id == _val) {
                current_slides = item.slides;
                break;
            }
        }
        return _val;
    }
    
    private function get_album() : String {
        return current_album;
    }
    
    private function set_automatic(_val) {
        _auto = _val;
        if (!_auto) {
            stop();
        }
        return _val;
    }
    private function get_automatic() {
        return _auto;
    }
}