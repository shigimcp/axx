package com.armaniexchange.ui;

import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.display.MovieClip;
import flash.geom.Rectangle;
import flash.events.Event;

class ScrollBar extends Sprite {
    public var position(get, never);
    public var target(get, set);
    public var scrollHeight(never, set);

    
    
    public var scrubDistance;
    public var pos;
    public var _target;
    public var _targetY;
    public var _targetDistance;
    
    public function new() {
        super();
        visible = false;
        scrub.buttonMode = true;
        init();
    }
    
    private function init() {
        scrubDistance = scrub_bg.height - scrub.height;
        scrub.addEventListener(MouseEvent.MOUSE_DOWN, onscroll);
    }
    
    private function onscroll(e : MouseEvent) {
        var bounds = new Rectangle(0, scrub_bg.y, 0, scrubDistance);
        scrub.startDrag(false, bounds);
        stage.addEventListener(MouseEvent.MOUSE_MOVE, update);
        stage.addEventListener(MouseEvent.MOUSE_UP, stopscroll);
    }
    private function stopscroll(e : MouseEvent) {
        stopDrag();
        update();
        stage.removeEventListener(MouseEvent.MOUSE_MOVE, update);
        stage.removeEventListener(MouseEvent.MOUSE_UP, stopscroll);
    }
    
    public function update(e : MouseEvent = null) {
        pos = (scrub.y - scrub_bg.y) / scrubDistance;
        _target.y = _targetY - _targetDistance * pos;
    }
    
    private function get_position() {
        return pos;
    }
    
    private function get_target() {
        return _target;
    }
    private function set_target(_val : Dynamic) : Dynamic {
        _target = _val;
        _targetY = _val.y;
        var h;
        
        if (_target.mask) {
            h = _target.mask.height;
        }
        else {
            h = scrub_bg.height;
        }
        
        var perc = h / _val.getBounds(_val).bottom;
        
        if (perc < 1) {
            _targetDistance = _val.getBounds(_val).bottom - h;
            //scrub.height = Math.floor(scrub_bg.height * h);
            visible = true;
        }
        else {
            _targetDistance = 0;
            visible = false;
        }
        
        reset();
        return _val;
    }
    
    public function evaluate() {
        var h;
        
        if (_target.mask) {
            h = _target.mask.height;
        }
        else {
            h = scrub_bg.height;
        }
        
        var perc = h / _target.getBounds(_target).bottom;
        
        if (perc < 1) {
            _targetDistance = _target.getBounds(_target).bottom - h;
            //scrub.height = Math.floor(scrub_bg.height * h);
            visible = true;
        }
        else {
            visible = false;
        }
        
        scrub.y = Math.min(scrubDistance, scrubDistance * ((_targetY - _target.y) / _targetDistance));
        update();
    }
    
    public function reset() {
        scrub.y = scrub_bg.y;
        update();
    }
    
    private function set_scrollHeight(_val) {
        scrub_bg.height = _val;
        if (hasOwnProperty("down_arrow")) {
            Reflect.setField(this, "down_arrow", scrub_bg.y + scrub_bg.height + 5).y;
        }
        scrubDistance = scrub_bg.height - scrub.height;
        return _val;
    }
}



