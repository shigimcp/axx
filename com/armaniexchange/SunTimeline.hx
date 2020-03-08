package com.armaniexchange;

import com.greensock.TweenLite;
import flash.filters.DropShadowFilter;
import flash.display.MovieClip;
import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.events.MouseEvent;

class SunTimeline extends MovieClip {
    
    public var sun_xml_path : String = "xml/sun.xml";
    public var sun_xml_loader : URLLoader;
    public var sun_xml : FastXML;
    public var thumbStrip;
    public var sunglasses_slideshow : SunglassesSlideshow;
    public var my_shadow;
    public var current_id;
    
    public function new() {
        super();
        addEventListener(Event.ADDED_TO_STAGE, playIntro);
        
        sun_xml_loader = new URLLoader();
        sun_xml_loader.load(new URLRequest(sun_xml_path));
        sun_xml_loader.addEventListener(Event.COMPLETE, populateSunglasses);
        
        my_shadow = new DropShadowFilter();
        my_shadow.color = 0x000000;
        my_shadow.blurY = 35;
        my_shadow.blurX = 35;
        my_shadow.angle = 30;
        my_shadow.alpha = 1;
        my_shadow.strength = .5;
        my_shadow.distance = 15;
    }
    
    public function playIntro(e : Event = null) {
        TweenLite.to(mc_hed, .5, {
                    alpha : 1
                });
        TweenLite.to(mc_image, .5, {
                    alpha : 1
                });
        //TweenLite.to(mc_info,.5,{alpha:1});
        
        removeEventListener(Event.ADDED_TO_STAGE, playIntro);
    }
    
    public function populateSunglasses(e : Event) {
        sun_xml = new FastXML(e.target.data);
        
        var _album : FastXML = FastXML.parse("<album id=\"sunglasses\" />");
        _album.node.setChildren.innerData(sun_xml.node.item.innerData.node.img.innerData.copy());
        var filtersArray : Array<Dynamic> = new Array<Dynamic>(my_shadow);
        
        var thumbs_list = sun_xml.node.item.innerData.node.thumb.innerData.text();
        var thumbs_arr = new Array<Dynamic>();
        
        for (item/* AS3HX WARNING could not determine type for var: item exp: EIdent(thumbs_list) type: null */ in thumbs_list) {
            thumbs_arr.push(item);
        }
        
        thumbStrip = new ThumbStrip(thumbs_arr);
        
        
        thumbStrip.y = 445;
        thumbStrip.x = 875 - thumbStrip.width;
        thumbStrip.alpha = 0;
        addChild(thumbStrip);
        
        sunglasses_slideshow = new SunglassesSlideshow();
        sunglasses_slideshow.addAlbum(_album);
        sunglasses_slideshow.album = Std.string(_album.att.id);
        
        sunglasses_slideshow.filters = filtersArray;
        sunglasses_slideshow.x = 60;
        sunglasses_slideshow.y = 230;
        addChild(sunglasses_slideshow);
        
        
        sunglasses_slideshow.start();
        sunglasses_slideshow.addEventListener("first_loaded", showInfo);
        
        mc_info.updateInfo(sun_xml.nodes.item.get(0));
        current_id = 0;
    }
    
    public function showInfo(e : Event) {
        TweenLite.to(mc_info, .5, {
                    alpha : 1
                });
        TweenLite.to(thumbStrip, .5, {
                    alpha : 1
                });
        thumbStrip.addEventListener(MouseEvent.CLICK, updateSunglasses);
        sunglasses_slideshow.removeEventListener("first_loaded", showInfo);
    }
    
    public function updateSunglasses(e : MouseEvent) {
        var id = e.target.id;
        if (current_id != id) {
            mc_info.updateInfo(sun_xml.nodes.item.get(id));
            sunglasses_slideshow.jumpTo(id);
            current_id = id;
        }
    }
    
    public function onClose() {
    }
}