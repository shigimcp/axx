package com.armaniexchange;

import com.greensock.TweenLite;
import flash.display.Bitmap;
import flash.display.Sprite;
import flash.display.Loader;
import flash.events.MouseEvent;
import flash.net.URLRequest;
import flash.events.Event;

class NavigationItem extends Sprite {
    
    private var bgLoader : Loader;
    
    public var id : Int;
    public var mouseOver = false;
    
    public function new(_label : String, _bg : String, _id : Int) {
        super();
        buttonMode = true;
        mouseChildren = false;
        
        _txt.htmlText = _label;
        
        id = _id;
        
        bgLoader = new Loader();
        bgLoader.mask = bgMask;
        bgLoader.load(new URLRequest(_bg));
        bgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, smoothImage);
        
        addChildAt(bgLoader, 0);
        addEventListener(MouseEvent.ROLL_OVER, roll_over);
        addEventListener(MouseEvent.ROLL_OUT, roll_out);
    }
    
    private function smoothImage(e : Event) {
        cast((bgLoader.content), Bitmap).smoothing = true;
    }
    public function roll_over(e : MouseEvent = null) {
        var tween_obj : Dynamic = { };
        tween_obj.alpha = 1;
        
        TweenLite.to(bgLoader, .25, tween_obj);
        if (e != null) {
            mouseOver = true;
        }
    }
    public function roll_out(e : MouseEvent = null) {
        var tween_obj : Dynamic = { };
        tween_obj.alpha = .45;
        
        TweenLite.to(bgLoader, .25, tween_obj);
        if (e != null) {
            mouseOver = false;
        }
    }
}