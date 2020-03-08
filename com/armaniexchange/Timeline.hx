package com.armaniexchange;

import com.greensock.TweenLite;
import flash.events.Event;
import flash.net.URLLoader;
import flash.display.MovieClip;
import flash.net.URLRequest;
import flash.display.Sprite;
import flash.display.DisplayObject;

class Timeline extends MovieClip {
    
    public var timeline_xml_path : String = "xml/timeline.xml";
    public var timeline_xml_loader : URLLoader;
    public var timeline_xml : FastXML;
    
    public var items_arr;
    public var item_container;
    
    public function new() {
        super();
        addEventListener(Event.ADDED_TO_STAGE, playIntro);
        
        timeline_xml_loader = new URLLoader(new URLRequest(timeline_xml_path));
        timeline_xml_loader.addEventListener(Event.COMPLETE, populateItems);
        
        item_container = new Sprite();
        addChildAt(item_container, getChildIndex(mc_hed));
    }
    
    public function populateItems(e : Event) {
        timeline_xml = new FastXML(e.target.data);
        items_arr = new Array<Dynamic>();
        while (item_container.numChildren < timeline_xml.nodes.item.length()) {
            var ti = new TimelineItem(timeline_xml.nodes.item.get(item_container.numChildren));
            ti.x = 500;
            ti.y = 300;
            ti.scaleX = .01;
            ti.scaleY = .01;
            ti.alpha = 0;
            ti.mouseChildren = false;
            ti.addEventListener("over", moveFront);
            ti.addEventListener("out", moveBack);
            ti.addEventListener("clicked", position_item);
            
            item_container.addChild(ti);
            
            items_arr.push(ti);
        }
        
        items_arr[0].addEventListener("ready", slideIn);
    }
    
    private function slideIn(e : Dynamic) {
        if (e.target.loaded)
        
        //				var burstX = Math.floor(Math.random() * 900) - 200;{
            
            //				var burstY = Math.floor(Math.random() * 300) + 100;
            var burstX = Math.floor(Math.random() * 800) - 75;
            var burstY = Math.floor(Math.random() * 400) + 50;
            
            e.target.save_pos = {
                        x : burstX,
                        y : burstY
                    };
            TweenLite.to(e.target, 1.5, {
                        alpha : 1,
                        scaleX : 1,
                        scaleY : 1,
                        x : burstX,
                        y : burstY
                    });
            TweenLite.delayedCall(1.5, e.target.roll_out);
        }
        else {
            e.target.addEventListener("ready", slideIn);
            return;
        }
        
        if (e.target != items_arr[items_arr.length - 1]) {
            TweenLite.delayedCall(.125, slideIn, [{
                        target : items_arr[items_arr.indexOf(e.target) + 1]
                    }]);
        }
        else {
            TweenLite.delayedCall(1.5, enableItems);
        }
    }
    
    public function moveFront(e : Event) {
        addChild(try cast(e.target, DisplayObject) catch(e:Dynamic) null);
    }
    
    public function moveBack(e : Event) {
        addChild(mc_hed);
    }
    
    public function position_item(e : Event) {
        if (e.target.state == "zoom") {
            TweenLite.to(e.target, .25, {
                        x : 0,
                        y : 120,
                        scaleX : 4,
                        scaleY : 4
                    });
            disableOthers();
        }
        else {
            TweenLite.to(e.target, .25, {
                        x : e.target.save_pos.x,
                        y : e.target.save_pos.y,
                        scaleX : 1,
                        scaleY : 1
                    });
            enableItems();
        }
    }
    
    public function enableItems() {
        var _func = function(item id arr) {
            item.mouseChildren = true;
        }
        items_arr.forEach(_func);
    }
    
    public function disableOthers() {
        var _func = function(item id arr) {
            if (item.state == "normal") {
                item.mouseChildren = false;
            }
        }
        items_arr.forEach(_func);
    }
    
    public function playIntro(e : Event = null) {
        TweenLite.to(mc_hed, .5, {
                    alpha : 1
                });
        
        removeEventListener(Event.ADDED_TO_STAGE, playIntro);
    }
    
    public function onClose() {
    }
}