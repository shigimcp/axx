package com.armaniexchange;

import com.greensock.TweenLite;
import flash.display.MovieClip;
import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.events.MouseEvent;
import flash.display.DisplayObject;

class LooksTimeline extends MovieClip {
    
    public var looks_xml_path : String = "xml/looks.xml";
    public var looks_xml : FastXML;
    public var looks_loader : URLLoader;
    public var looks_arr : Array<Dynamic>;
    
    public function new() {
        super();
        addEventListener(Event.ADDED_TO_STAGE, playIntro);
        
        looks_loader = new URLLoader(new URLRequest(looks_xml_path));
        looks_loader.addEventListener(Event.COMPLETE, populateLooks);
    }
    
    public function playIntro(e : Event = null) {
        TweenLite.to(mc_hed, .5, {
                    alpha : 1
                });
        
        removeEventListener(Event.ADDED_TO_STAGE, playIntro);
    }
    
    public function populateLooks(e : Event = null) {
        looks_xml = new FastXML(e.target.data);
        var look;
        looks_arr = new Array<Dynamic>();
        for (l in looks_xml.nodes.look) {
            look = new Look(l);
            look.x = as3hx.Compat.parseFloat(l.node.start.innerData.att.x);
            look.y = as3hx.Compat.parseFloat(l.node.start.innerData.att.y);
            look.scaleX = .45;
            look.scaleY = .45;
            look.alpha = 0;
            look.addEventListener("image_loaded", tweenLook);
            looks_arr.push(look);
            addChild(look);
        }
    }
    
    private function tweenLook(e : Event) {
        var _func = function() {
            e.target.addEventListener(MouseEvent.ROLL_OVER, setFront);
            e.target.addEventListener("image_clicked", toggleImage);
        }
        TweenLite.to(e.target, 1.5, {
                    x : e.target.end_pos.x,
                    y : e.target.end_pos.y,
                    alpha : 1,
                    onComplete : _func
                });
    }
    private function setFront(e : MouseEvent) {
        addChild(try cast(e.target, DisplayObject) catch(e:Dynamic) null);
    }
    
    private function toggleImage(e : Event) {
        if (e.target.info_visible) {
            TweenLite.to(e.target, .5, {
                        x : 0,
                        y : 0,
                        scaleX : 1,
                        scaleY : 1
                    });
            disableOthers();
        }
        else {
            TweenLite.to(e.target, .5, {
                        x : e.target.start_pos.x,
                        y : e.target.start_pos.y,
                        scaleX : .45,
                        scaleY : .45
                    });
            enableOthers();
        }
    }
    
    public function disableOthers() {
        var _func = function(item a b) {
            if (!item.info_visible) {
                item.mouseEnabled = false;
                item.mouseChildren = false;
            }
        }
        looks_arr.forEach(_func);
    }
    
    public function enableOthers() {
        var _func = function(item a b) {
            if (!item.info_visible) {
                item.mouseEnabled = true;
                item.mouseChildren = true;
            }
        }
        looks_arr.forEach(_func);
    }
    
    public function onClose() {
    }
}