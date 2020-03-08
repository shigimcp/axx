package com.armaniexchange;

import com.greensock.TweenLite;
import flash.display.Sprite;

class BoxAnimation extends Sprite {
    
    public function new() {
        super();
    }
    
    public function animate() {
        TweenLite.to(mc_axx, 3.5, {
                    x : -635
                });
    }
}