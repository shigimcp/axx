package com.armaniexchange;

import com.greensock.TweenLite;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.events.Event;

class HomeNavigation extends Sprite {
    public var mode(get, set) : String;
    public var source(never, set) : Array<Dynamic>;
    public var selectedIndex(get, set) : Int;
    public var enabled(never, set) : Bool;

    
    private var _mode : String = "grid";
    
    private var nav_clips : Array<Dynamic>;
    
    private var nav_objs : Array<Dynamic>;
    private var selected_index : Int;
    
    private var maxColumns : Int = 4;
    
    private var item_width : Int = 200;
    private var item_height : Int = 200;
    
    public function new() {
        super();
        nav_objs = new Array<Dynamic>();
        nav_clips = new Array<Dynamic>();
        
        mouseEnabled = false;
    }
    
    public function animate() {
        var temp_arr = nav_clips.copy();
        var displayInterval = .125;
        
        var _len = temp_arr.length;
        var el;
        var tmp;
        var i;
        var rn;
        
        mouseChildren = false;
        
        for (i in 0..._len) {
            el = temp_arr[i];
            temp_arr[i] = temp_arr[rn = as3hx.Compat.parseInt(Math.random() * _len)];
            temp_arr[rn] = el;
        }
        
        var _func = function(item id arr) {
            TweenLite.delayedCall(id * displayInterval, item.roll_over);
            TweenLite.to(item, .25, {
                        alpha : 1,
                        delay : id * displayInterval
                    });
        }
        
        var _func2 = function() {
            temp_arr.forEach(function(item id arr) {
                        item.roll_out();
                    });
            mouseChildren = true;
        }
        TweenLite.delayedCall(_len * .25 - displayInterval * _len + .75, _func2);
        
        temp_arr.forEach(_func);
    }
    
    private function idleBehavior() {
        var _delay = 0;
        for (clip in nav_clips) {
            TweenLite.delayedCall(_delay, clip.roll_over);
            TweenLite.delayedCall(_delay + .5, clip.roll_out);
            _delay += .125;
        }
        TweenLite.delayedCall(_delay + 1 + 3, idleBehavior);
    }
    
    private function startIdleBehavior(e : MouseEvent = null) {
        addEventListener(MouseEvent.ROLL_OVER, stopIdleBehavior);
        removeEventListener(MouseEvent.ROLL_OUT, startIdleBehavior);
        
        TweenLite.delayedCall(3, idleBehavior);
    }
    
    
    
    private function stopIdleBehavior(e : MouseEvent = null) {
        addEventListener(MouseEvent.ROLL_OUT, startIdleBehavior);
        removeEventListener(MouseEvent.ROLL_OVER, stopIdleBehavior);
        TweenLite.killDelayedCallsTo(idleBehavior);
        for (clip in nav_clips) {
            TweenLite.killDelayedCallsTo(clip.roll_over);
            TweenLite.killDelayedCallsTo(clip.roll_out);
        }
        for (clip in nav_clips) {
            if (!clip.mouseOver) {
                clip.roll_out();
            }
        }
    }
    
    private function set_mode(__DOLLAR__mode : String) : String {
        if (__DOLLAR__mode == mode) {
            return __DOLLAR__mode;
        }
        
        var _func;
        
        if (__DOLLAR__mode == "singleRow") {
            _func = function(item id arr) {
                        var tween_obj = {
                            x : item.id * item_width
                        };
                        tween_obj.y = (item.y > 0) ? 0 : null;
                        
                        TweenLite.to(item, .5, tween_obj);
                        TweenLite.to(item._txt, .5, {
                                    alpha : 0
                                });
                    };
            _mode = __DOLLAR__mode;
            
            nav_clips.forEach(_func);
            TweenLite.delayedCall(.5, startIdleBehavior);
        }
        else if (__DOLLAR__mode == "grid") {
            _func = function(item id arr) {
                        var pos = nav_objs[id].position.split(",");
                        
                        var tween_obj = { };
                        tween_obj.y = (as3hx.Compat.parseInt(pos[0]) > 0) ? item_height * as3hx.Compat.parseInt(pos[0]) : null;
                        tween_obj.x = (as3hx.Compat.parseInt(pos[1]) * item_width != item.x) ? item_width * as3hx.Compat.parseInt(pos[1]) : null;
                        
                        TweenLite.to(item, .5, tween_obj);
                        TweenLite.to(item._txt, .5, {
                                    alpha : 1
                                });
                    };
            _mode = __DOLLAR__mode;
            
            nav_clips.forEach(_func);
            stopIdleBehavior();
            removeEventListener(MouseEvent.ROLL_OUT, startIdleBehavior);
        }
        return __DOLLAR__mode;
    }
    
    private function get_mode() {
        return _mode;
    }
    
    public function addItem(_obj) {
        var lab = _obj.label;
        var bg = _obj.background;
        var id = _obj.id;
        var pos = _obj.position.split(",");
        
        var btn = new NavigationItem(lab, bg, id);
        btn.alpha = 0;
        btn.addEventListener(MouseEvent.CLICK, itemClicked);
        btn.y = item_height * as3hx.Compat.parseInt(pos[0]);
        btn.x = item_width * as3hx.Compat.parseInt(pos[1]);
        
        addChild(btn);
        
        nav_clips.push(btn);
        nav_objs.push(_obj);
    }
    
    private function itemClicked(e : MouseEvent) {
        selectedIndex = e.target.id;
    }
    
    private function set_source(_val : Array<Dynamic>) : Array<Dynamic> {
        for (item in _val) {
            addItem(item);
        }
        return _val;
    }
    
    private function get_selectedIndex() : Int {
        return selected_index;
    }
    
    private function set_selectedIndex(_val : Int) : Int {
        selected_index = _val;
        dispatchEvent(new Event(Event.SELECT));
        return _val;
    }
    
    private function set_enabled(_val : Bool) : Bool {
        mouseEnabled = _val;
        mouseChildren = _val;
        return _val;
    }
}