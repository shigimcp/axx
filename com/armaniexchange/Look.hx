package com.armaniexchange;

import com.greensock.TweenLite;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flash.display.Sprite;
import flash.display.Loader;
import flash.net.URLRequest;
import flash.events.Event;
import flash.display.Bitmap;
import flash.filters.DropShadowFilter;
import flash.events.MouseEvent;
import flash.text.TextField;

class Look extends Sprite {
    public var start_pos(get, never);
    public var end_pos(get, never);

    
    
    public var info_clip;
    public var img_loader;
    public var info_visible : Bool;
    public var my_shadow : DropShadowFilter;
    public var my_hilite : DropShadowFilter;
    public var zoomText : TextField;
    
    private var look_src;
    
    
    public function new(_src : FastXML) {
        super();
        look_src = _src;
        my_shadow = new DropShadowFilter();
        my_shadow.color = 0x000000;
        my_shadow.blurY = 15;
        my_shadow.blurX = 15;
        my_shadow.angle = 45;
        my_shadow.alpha = 1;
        my_shadow.strength = .25;
        my_shadow.distance = 5;
        my_shadow.quality = 3;
        
        my_hilite = new DropShadowFilter();
        my_hilite.color = 0xFFFFFF;
        my_hilite.blurY = 5;
        my_hilite.blurX = 5;
        my_hilite.angle = 45;
        my_hilite.alpha = 1;
        my_hilite.strength = 1;
        my_hilite.distance = 0;
        my_hilite.quality = 3;
        
        
        info_clip = new McInfo();
        info_clip.y = 350;
        info_clip.alpha = 0;
        info_clip.txt_descr.text = Std.string(_src.node.description.innerData.node.text.innerData()).toUpperCase();
        info_clip.txt_price.text = Std.string(_src.node.price.innerData.node.text.innerData()).toUpperCase();
        
        info_clip.btn_shop.source = _src.node.link.innerData;
        info_clip.btn_shop.buttonMode = true;
        
        addChild(info_clip);
        
        img_loader = new Loader();
        img_loader.filters = [my_shadow];
        img_loader.load(new URLRequest(_src.node.img.innerData.node.text.innerData()));
        img_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, img_loaded);
        addChild(img_loader);
        
        img_loader.addEventListener(MouseEvent.ROLL_OVER, roll_over);
        img_loader.addEventListener(MouseEvent.ROLL_OUT, roll_out);
        img_loader.addEventListener(MouseEvent.CLICK, click);
        
        
        var format : TextFormat = new TextFormat();
        format.size = 15;
        format.leading = 2;
        format.align = TextFormatAlign.RIGHT;
        format.font = "Gotham Book";
        format.bold = false;
        format.color = 0xCCCCCC;
        
        zoomText = new TextField();
        zoomText.embedFonts = true;
        zoomText.defaultTextFormat = format;
        zoomText.selectable = false;
        zoomText.mouseEnabled = false;
        zoomText.antiAliasType = flash.text.AntiAliasType.ADVANCED;
        zoomText.multiline = true;
        zoomText.wordWrap = true;
        zoomText.width = 423;
        zoomText.y = 20;
        
        addChild(zoomText);
    }
    
    public function showInfo() {
        info_visible = true;
        TweenLite.to(info_clip, .5, {
                    x : 425,
                    alpha : 1
                });
    }
    
    public function hideInfo() {
        info_visible = false;
        TweenLite.to(info_clip, .5, {
                    x : 0,
                    alpha : 0
                });
    }
    
    private function roll_over(e : MouseEvent = null) {
        if (!info_visible) {
            img_loader.filters = [my_hilite];
            zoomText.text = "CLICK IMAGE\nTO ZOOM";
        }
        else {
            zoomText.text = "CLICK IMAGE\nTO RETURN";
            img_loader.filters = [my_shadow];
        }
    }
    
    private function roll_out(e : MouseEvent = null) {
        if (!info_visible) {
            img_loader.filters = [my_shadow];
            zoomText.text = "";
        }
    }
    private function click(e : MouseEvent) {
        (info_visible) ? hideInfo() : showInfo();
        zoomText.text = (info_visible) ? "CLICK IMAGE\nTO RETURN" : "CLICK IMAGE\nTO ZOOM";
        img_loader.filters = [my_shadow];
        dispatchEvent(new Event("image_clicked"));
    }
    private function img_loaded(e : Event) {
        cast((e.target.loader.content), Bitmap).smoothing = true;
        dispatchEvent(new Event("image_loaded"));
    }
    
    private function get_start_pos() {
        return {
            x : as3hx.Compat.parseFloat(look_src.start.att.x),
            y : as3hx.Compat.parseFloat(look_src.start.att.y)
        };
    }
    
    private function get_end_pos() {
        return {
            x : as3hx.Compat.parseFloat(look_src.end.att.x),
            y : as3hx.Compat.parseFloat(look_src.end.att.y)
        };
    }
}