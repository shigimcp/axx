package com.armaniexchange;

import com.greensock.TweenLite;

class WatchSlide extends SunglassesSlide {
    
    public function new(path : String) {
        super(path);
        maskTrans = 1;
    }
    
    override public function show() {
        var clip;
        for (i in 0...Reflect.field(this, "mask_mc").numChildren) {
            clip = Reflect.field(this, "mask_mc")["mc_mask" + i];
            TweenLite.to(clip, maskTrans, {
                        width : maskWidth
                    });
        }
    }
    
    override public function hide() {
        var clip;
        for (i in 0...Reflect.field(this, "mask_mc").numChildren) {
            clip = Reflect.field(this, "mask_mc")["mc_mask" + i];
            TweenLite.to(clip, maskTrans, {
                        width : 0
                    });
        }
    }
}