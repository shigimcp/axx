package com.armaniexchange;

import flash.display.Sprite;
import flash.net.URLRequest;
import flash.display.Loader;
import flash.events.Event;

class Slide extends Sprite {
    public var loaded(get, never);

    
    @:allow(com.armaniexchange)
    private var _loader : Loader;
    private var _loaded : Bool = false;
    
    public function new(path : String) {
        super();
        _loader = new Loader();
        _loader.load(new URLRequest(path));
        _loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _complete);
        
        addChild(_loader);
    }
    
    private function _complete(e : Event) {
        _loaded = true;
        dispatchEvent(new Event(Event.COMPLETE));
    }
    
    private function get_loaded() {
        return _loaded;
    }
}