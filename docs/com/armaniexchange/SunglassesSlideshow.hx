package com.armaniexchange;

import com.armaniexchange.Slideshow;
import com.armaniexchange.SunglassesSlide;

class SunglassesSlideshow extends Slideshow {
    
    public function new() {
        super();
    }
    
    @:allow(com.armaniexchange)
    override private function createSlides(_list) {
        var _arr = new Array<Dynamic>();
        
        for (item/* AS3HX WARNING could not determine type for var: item exp: EIdent(_list) type: null */ in _list) {
            _arr.push(new SunglassesSlide(item));
        }
        
        return _arr;
    }
    
    override public function display(_slide : Slide) {
        slide_container.addChild(_slide);
        
        /*if (_tween) {
				_tween.vars.onComplete = null;
			}*/
        
        cast((_slide), SunglassesSlide).show();
        
        if (previous_slide) {
            cast((previous_slide), SunglassesSlide).hide();
        }
    }
}