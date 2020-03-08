package com.armaniexchange;


class WatchSlideshow extends SunglassesSlideshow {
    
    public var slideSymbol : Class<Dynamic>;
    
    public function new() {
        super();
    }
    
    @:allow(com.armaniexchange)
    override private function createSlides(_list) {
        var _arr = new Array<Dynamic>();
        
        for (item/* AS3HX WARNING could not determine type for var: item exp: EIdent(_list) type: null */ in _list) {
            _arr.push(Type.createInstance(slideSymbol, [item]));
        }
        
        return _arr;
    }
}