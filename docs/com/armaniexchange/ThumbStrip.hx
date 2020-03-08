package com.armaniexchange;

import flash.display.Sprite;
import flash.events.MouseEvent;

class ThumbStrip extends Sprite {
    public var source(never, set);

    
    public var padding;
    public var thumbSymbol : Class<Dynamic>;
    public function new(_arr : Array<Dynamic> = null, _padding _symbol) {
        super();
        padding = _padding;
        thumbSymbol = _symbol || SunglassesThumb;
        if (_arr != null) {
            generateThumbs(_arr);
        }
    }
    
    public function generateThumbs(_arr : Array<Dynamic>) {
        var tn : SunglassesThumb;
        var nextX = 0;
        var _func = function(item id arr) {
            tn = Type.createInstance(thumbSymbol, [item]);
            tn.id = id;
            tn.x = nextX;
            nextX += tn.width + padding;
            addChild(tn);
        }
        _arr.forEach(_func);
    }
    
    private function set_source(_val) {
        generateThumbs(_val);
        return _val;
    }
}