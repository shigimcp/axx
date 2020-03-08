package com.armaniexchange;

import com.greensock.TweenLite;
import flash.display.Sprite;
import flash.display.Loader;
import flash.net.URLRequest;
import flash.events.MouseEvent;

class SunglassesThumb extends Sprite {
    
    
    private var alphaOver : Float = .625;
    private var alphaRest : Float = .25;
    private var alphaDown : Float = 1;
    private var alphaClick : Float = .625;
    @:allow(com.armaniexchange)
    private var _loader : Loader;
    
    public var id : Int;
    
    public function new(_path : String) {
        super();
        mouseChildren = false;
        
        _loader = new Loader();
        _loader.load(new URLRequest(_path));
        addChild(_loader);
        
        addEventListener(MouseEvent.ROLL_OVER, roll_over);
        addEventListener(MouseEvent.ROLL_OUT, roll_out);
    }
    
    @:allow(com.armaniexchange)
    private function roll_over(e : MouseEvent = null) {
        TweenLite.to(Reflect.field(this, "mc_iconBG"), .25, {
                    alpha : .625
                });
    }
    
    @:allow(com.armaniexchange)
    private function roll_out(e : MouseEvent = null) {
        TweenLite.to(Reflect.field(this, "mc_iconBG"), .25, {
                    alpha : .25
                });
    }
}