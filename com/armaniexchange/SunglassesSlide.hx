package com.armaniexchange;

import com.greensock.TweenLite;

class SunglassesSlide extends Slide {
    
    
    public var maskWidth : Float = 55;
    public var maskTrans : Float = .5;
    public var maskDelay : Float = 0;
    public var maskIncr : Float = .0625;
    
    public function new(path : String) {
        super(path);
        _loader.mask = Reflect.field(this, "mask_mc");
        for (item/* AS3HX WARNING could not determine type for var: item exp: EArray(EIdent(this),EConst(CString(mask_mc))) type: null */ in Reflect.field(this, "mask_mc")) {
            item.width = 0;
        }
    }
    
    public function show() {
        var clip;
        for (i in 0...Reflect.field(this, "mask_mc").numChildren) {
            clip = Reflect.field(this, "mask_mc")["mc_mask" + i];
            TweenLite.to(clip, maskTrans, {
                        width : maskWidth,
                        delay : maskDelay
                    });
            maskDelay += maskIncr;
        }
        maskDelay = 0;
    }
    
    public function hide() {
        var clip;
        for (i in 0...Reflect.field(this, "mask_mc").numChildren) {
            clip = Reflect.field(this, "mask_mc")["mc_mask" + i];
            TweenLite.to(clip, maskTrans, {
                        width : 0,
                        delay : maskDelay
                    });
            maskDelay += maskIncr;
        }
        maskDelay = 0;
    }
}