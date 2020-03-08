package com.armaniexchange;

import com.greensock.TweenLite;
import flash.events.MouseEvent;

class WatchThumb extends SunglassesThumb {
    
    public function new(_path : String) {
        super(_path);
        
        _loader.x = 0;
        _loader.y = 0;
    }
}