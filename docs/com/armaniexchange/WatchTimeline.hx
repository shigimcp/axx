package com.armaniexchange;

import com.greensock.TweenLite;
import flash.display.MovieClip;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.filters.DropShadowFilter;

class WatchTimeline extends MovieClip {
    
    public var watch_xml_path = "xml/watch.xml";
    public var watch_xml_loader : URLLoader;
    public var watch_xml;
    
    public var my_shadow : DropShadowFilter;
    public var watch_slideshow;
    public var model_slideshow;
    public var thumbStrip;
    public var slideshows_loaded = 0;
    public var current_id;
    
    public function new() {
        super();
        addEventListener(Event.ADDED_TO_STAGE, playIntro);
        
        watch_xml_loader = new URLLoader(new URLRequest(watch_xml_path));
        watch_xml_loader.addEventListener(Event.COMPLETE, populateWatches);
        
        my_shadow = new DropShadowFilter();
        my_shadow.color = 0x000000;
        my_shadow.blurY = 35;
        my_shadow.blurX = 35;
        my_shadow.angle = 30;
        my_shadow.alpha = 1;
        my_shadow.strength = 1.25;
        my_shadow.distance = 10;
    }
    
    public function populateWatches(e : Event = null) {
        watch_xml = new FastXML(e.target.data);
        
        var watch_album : FastXML = FastXML.parse("<album id=\"watches\" />");
        watch_album.node.setChildren.innerData(watch_xml.item.img.copy());
        
        var model_album : FastXML = FastXML.parse("<album id=\"watches\" />");
        model_album.node.setChildren.innerData(watch_xml.item.model.copy());
        
        var filtersArray : Array<Dynamic> = new Array<Dynamic>(my_shadow);
        
        var thumbs_list = watch_xml.item.thumb.text();
        var thumbs_arr = new Array<Dynamic>();
        
        for (item/* AS3HX WARNING could not determine type for var: item exp: EIdent(thumbs_list) type: null */ in thumbs_list) {
            thumbs_arr.push(item);
        }
        
        thumbStrip = new ThumbStrip(thumbs_arr, 10, WatchThumb);
        
        
        thumbStrip.y = 5;
        thumbStrip.x = 800 - thumbStrip.width;
        mc_info.addChild(thumbStrip);
        
        watch_slideshow = new WatchSlideshow();
        watch_slideshow.showWhenLoaded = false;
        watch_slideshow.slideSymbol = WatchSlide;
        watch_slideshow.addAlbum(watch_album);
        watch_slideshow.album = Std.string(watch_album.att.id);
        
        watch_slideshow.filters = filtersArray;
        watch_slideshow.x = 125;
        watch_slideshow.y = 100;
        addChild(watch_slideshow);
        
        setChildIndex(mc_hed, numChildren - 1);
        
        watch_slideshow.start();
        watch_slideshow.addEventListener("first_loaded", showInfo);
        
        model_slideshow = new WatchSlideshow();
        model_slideshow.showWhenLoaded = false;
        model_slideshow.slideSymbol = ModelSlide;
        model_slideshow.addAlbum(model_album);
        model_slideshow.album = Std.string(model_album.att.id);
        
        model_slideshow.filters = filtersArray;
        model_slideshow.x = 430;
        //			addChildAt(model_slideshow,getChildIndex(mc_info));
        
        model_slideshow.start();
        model_slideshow.addEventListener("first_loaded", showInfo);
        
        mc_info.updateInfo(watch_xml.item[0]);
        current_id = 0;
    }
    
    public function playIntro(e : Event = null) {
        TweenLite.to(mc_hed, .5, {
                    alpha : 1
                });
        TweenLite.to(mc_couple, .5, {
                    alpha : 1
                });
        
        removeEventListener(Event.ADDED_TO_STAGE, playIntro);
    }
    
    public function showInfo(e : Event) {
        slideshows_loaded++;
        if (slideshows_loaded == 2) {
            TweenLite.to(mc_info, .5, {
                        alpha : 1
                    });
            watch_slideshow.display(watch_slideshow.currentSlide);
            model_slideshow.display(model_slideshow.currentSlide);
            thumbStrip.addEventListener(MouseEvent.CLICK, updateWatches);
        }
        e.target.removeEventListener("first_loaded", showInfo);
    }
    
    public function updateWatches(e : MouseEvent) {
        var id = e.target.id;
        if (current_id != id) {
            mc_info.updateInfo(watch_xml.item[id]);
            watch_slideshow.jumpTo(id);
            model_slideshow.jumpTo(id);
            current_id = id;
        }
    }
    
    public function onClose() {
    }
}


