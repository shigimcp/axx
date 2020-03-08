package com.armaniexchange;

import com.greensock.TweenLite;
import flash.display.MovieClip;
import flash.events.Event;
import flash.text.TextFieldAutoSize;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.display.Bitmap;
import flash.display.Loader;
import flash.display.Sprite;
import flash.text.TextFormat;
import flash.events.MouseEvent;

class BlogTimeline extends MovieClip {
    
    public var axx_blog_xml_path = "http://styletraxx.com/feeds/news/";
    public var axx_blog_xml;
    public var axx_blog_xml_loader;
    public var image_container : Sprite;
    public var image_loader : Loader;
    public var post_list_container : Sprite;
    public var numOfPosts = 10;
    
    
    public function new() {
        super();
        
        body_txt.autoSize = TextFieldAutoSize.LEFT;
        body_txt.mask = body_mask;
        body_scrollbar.target = body_txt;
        
        recent_scrollbar.scrollHeight = 70;
        
        axx_blog_xml_loader = new URLLoader(new URLRequest(axx_blog_xml_path));
        axx_blog_xml_loader.addEventListener(Event.COMPLETE, xml_complete);
        
        addEventListener(Event.ADDED_TO_STAGE, playIntro);
        
        image_container = new Sprite();
        image_container.y = 34;
        addChildAt(image_container, 1);
        
        post_list_container = new Sprite();
        post_list_container.x = list_mask.x;
        post_list_container.y = list_mask.y;
        post_list_container.mask = list_mask;
        addChild(post_list_container);
        recent_scrollbar.target = post_list_container;
    }
    
    public function xml_complete(e : Event) {
        axx_blog_xml = new FastXML(e.target.data);
        
        populateList();
        
        showPost(0);
    }
    
    public function playIntro(e : Event = null) {
        TweenLite.to(mc_hed, .5, {
                    alpha : 1
                });
        //TweenLite.to(mc_info,.5,{alpha:1});
        
        removeEventListener(Event.ADDED_TO_STAGE, playIntro);
    }
    
    public function updateImage(path) {
        if (image_loader != null) {
            fadeOut(image_loader);
        }
        if (Std.string(path) != "") {
            image_loader = new Loader();
            image_loader.load(new URLRequest(path));
            image_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, fadeIn);
            image_loader.alpha = 0;
            image_container.addChild(image_loader);
        }
    }
    
    public function populateList() {
        var nextY = 0;
        var txtF : TextFormat = new TextFormat();
        txtF.underline = true;
        
        var total = Math.min(numOfPosts, axx_blog_xml.channel.item.length());
        
        for (id in 0...total) {
            var item = axx_blog_xml.channel.item[id];
            var p_item = new PostItem();
            p_item.id = id;
            p_item.mouseChildren = false;
            p_item.buttonMode = true;
            p_item.addEventListener(MouseEvent.CLICK, list_click);
            p_item._txt.width = 290;
            //				p_item._txt.autoSize = TextFieldAutoSize.LEFT;
            p_item._txt.htmlText = item.title.text().toUpperCase();
            p_item._txt.setTextFormat(txtF);
            p_item.y = nextY;
            post_list_container.addChild(p_item);
            
            nextY += p_item.height + 5;
        }
        recent_scrollbar.evaluate();
        recent_scrollbar.reset();
    }
    
    public function showPost(_val) {
        heading_txt.htmlText = axx_blog_xml.channel.item[_val].title.text().toUpperCase();
        body_txt.htmlText = axx_blog_xml.channel.item[_val].description.text();
        
        body_scrollbar.evaluate();
        body_scrollbar.reset();
        var _path;
        if (axx_blog_xml.channel.item[_val].photo != "") {
            _path = axx_blog_xml.channel.item[_val].photo.text();
            _path = (((_path.indexOf("/images") == 0)) ? "http://styletraxx.com" : "") + _path;
        }
        updateImage(_path || "");
    }
    public function list_click(e : MouseEvent) {
        showPost(e.currentTarget.id);
    }
    
    public function fadeIn(e : Event) {
        cast((image_loader.content), Bitmap).smoothing = true;
        image_loader.width = 400;
        image_loader.scaleY = image_loader.scaleX;
        image_loader.height = Math.round(image_loader.height);
        if (image_loader.height > 533) {
            image_loader.height = 533;
            image_loader.scaleX = image_loader.scaleY;
            image_loader.width = Math.round(image_loader.width);
        }
        
        TweenLite.to(image_loader, .5, {
                    alpha : 1
                });
    }
    
    public function fadeOut(_target) {
        TweenLite.to(_target, .5, {
                    alpha : 0
                });
        if (image_container.contains(_target)) {
            TweenLite.delayedCall(.5, image_container.removeChild, [_target]);
        }
    }
}