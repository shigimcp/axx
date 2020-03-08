package com.armaniexchange;

import com.greensock.TweenLite;
import flash.display.Sprite;
import flash.display.Loader;
import flash.net.URLRequest;
import flash.events.Event;
import flash.display.Bitmap;
import flash.events.MouseEvent;

class TimelineItem extends Sprite {
    
    public var image_loader : Loader;
    public var loaded = false;
    public var save_pos;
    
    public var state : String;
    
    public function new(_src : FastXML) {
        super();
        
        mc_descrBG.mouseEnabled = false;
        txt_descr.mouseEnabled = false;
        //txt_year.mouseEnabled = false;
        
        image_loader = new Loader();
        image_loader.load(new URLRequest(_src.node.img.innerData.node.text.innerData()));
        image_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, image_loaded);
        image_loader.scaleY = .25;
        image_loader.scaleX = .25;
        
        image_loader.addEventListener(MouseEvent.ROLL_OVER, roll_over);
        image_loader.addEventListener(MouseEvent.ROLL_OUT, roll_out);
        image_loader.addEventListener(MouseEvent.CLICK, click);
        
        txt_year.addEventListener(MouseEvent.ROLL_OVER, roll_over);
        txt_year.addEventListener(MouseEvent.ROLL_OUT, roll_out);
        txt_year.addEventListener(MouseEvent.CLICK, click);
        
        addChildAt(image_loader, 0);
        
        txt_year.text = _src.node.year.innerData.node.text.innerData();
        txt_descr.text = _src.node.description.innerData.node.text.innerData();
        txt_descr.width = 1;
        txt_descr.height = 1;
        txt_descr.alpha = 0;
        
        save_pos = { };
        state = "normal";
    }
    
    public function roll_over(e : MouseEvent = null) {
        if (state == "normal") {
            TweenLite.to(image_loader, .25, {
                        alpha : .75
                    });
            TweenLite.to(txt_year, .25, {
                        alpha : 1
                    });
            TweenLite.to(txt_descr, .25, {
                        width : 300,
                        height : 150,
                        alpha : 1
                    });
            dispatchEvent(new Event("over"));
        }
    }
    
    public function roll_out(e : MouseEvent = null) {
        if (state == "normal") {
            if (!image_loader.hitTestPoint(stage.mouseX, stage.mouseY)) {
                TweenLite.to(image_loader, .25, {
                            alpha : .125
                        });
                TweenLite.to(txt_year, .25, {
                            alpha : .5
                        });
                TweenLite.to(txt_descr, .25, {
                            width : 1,
                            height : 1,
                            alpha : 0
                        });
                dispatchEvent(new Event("out"));
            }
        }
    }
    
    public function click(e : MouseEvent) {
        (state == "normal") ? zoom() : normal();
        dispatchEvent(new Event("clicked"));
    }
    
    public function zoom() {
        TweenLite.to(image_loader, .25, {
                    alpha : 1
                });
        TweenLite.to(txt_descr, .25, {
                    x : 10,
                    y : 98,
                    width : 500,
                    height : 300,
                    scaleY : .25,
                    scaleX : .25
                });
        TweenLite.to(mc_descrBG, .25, {
                    width : 400,
                    alpha : .5
                });
        
        state = "zoom";
    }
    
    public function normal() {
        TweenLite.to(image_loader, .25, {
                    alpha : .125
                });
        TweenLite.to(txt_descr, .25, {
                    x : 0,
                    y : 130,
                    width : 1,
                    height : 1,
                    scaleY : 1,
                    scaleX : 1,
                    alpha : 0
                });
        TweenLite.to(txt_year, .25, {
                    alpha : .5
                });
        TweenLite.to(mc_descrBG, .25, {
                    width : 0,
                    alpha : 0
                });
        
        state = "normal";
    }
    
    public function image_loaded(e : Event) {
        loaded = true;
        cast((e.target.loader.content), Bitmap).smoothing = true;
        dispatchEvent(new Event("ready"));
    }
}