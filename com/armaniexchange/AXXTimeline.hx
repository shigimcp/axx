package com.armaniexchange;

import flash.display.Sprite;
import com.greensock.TweenLite;
import com.greensock.easing.Sine;
import com.greensock.OverwriteManager;
import flash.display.StageScaleMode;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.filters.DropShadowFilter;

class AXXTimeline extends Sprite {
    
    public static var serverPath : String;
    public var main_xml : FastXML = null;
    
    public var grid_animation_container : Sprite;
    public var cell_height = 200;
    public var cell_width = 200;
    
    public var grid_animations = [{
            col : 9,
            row : 1,
            delay : 0
		},
		{
            col : 7,
            row : 0,
            delay : .5
		},
		{
            col : 6,
            row : 2,
            delay : 1
		},
		{
            col : 5,
            row : 1,
            delay : 1.5
		},
		{
            col : 3,
            row : 0,
            delay : 2
		},
		{
            col : 2,
            row : 2,
            delay : 2.5
		},
		{
            col : 0,
            row : 1,
            delay : 3
		}
    ];
    
    public var axx_nav : HomeNavigation;
    public var axx_ss : Slideshow;
    public var axx_content : ContentLoader;
    public var axx_signature;
    public var nav_constructed : Bool = false;
    
    public function new() {
        super();
        OverwriteManager.init();
        TweenLite.defaultEase = Sine.easeOut;
        stage.scaleMode = StageScaleMode.NO_SCALE;
        
        if (!loaderInfo.parameters.exists("serverPath")) {
            serverPath = "";
        }
        else {
            serverPath = loaderInfo.parameters.serverPath;
        }
        
        mc_logo.mask = mc_axxMASK;
        
        mini_txt.mouseEnabled = false;
        home_btn.buttonMode = true;
        home_btn.addEventListener(MouseEvent.CLICK, gotoHome);
        
        var _xmlLoader : URLLoader = new URLLoader(new URLRequest(serverPath + "xml/main.xml"));
        _xmlLoader.addEventListener(Event.COMPLETE, createGrid);
        
        
        startOpeningAnimation();
        
        axx_signature = new ArmaniSignature();
        axx_signature.mouseEnabled = false;
        axx_signature.mouseChildren = false;
        axx_signature.mc_sig.stop();
        axx_signature.x = 875;
        axx_signature.y = 430;
        addChild(axx_signature);
    }
    
    private function createGrid(e : Event) {
        main_xml = new FastXML(e.target.data);
        createNavigation();
        createSlideshow();
        
        axx_content = new ContentLoader();
        axx_content.x = 500;
        addChildAt(axx_content, getChildIndex(axx_nav) - 1);
    }
    
    private function startOpeningAnimation() {
        grid_animation_container = new Sprite();
        grid_animation_container.mouseChildren = false;
        grid_animation_container.mouseEnabled = false;
        addChildAt(grid_animation_container, getChildIndex(mc_axx));
        
        
        TweenLite.to(mc_axx, 7, {
                    x : -1910
                });
        TweenLite.to(mc_axxMASK, 7, {
                    x : -236
                });
        
        var box_anim : BoxAnimation;
        for (item/* AS3HX WARNING could not determine type for var: item exp: EIdent(grid_animations) type: null */ in grid_animations) {
            box_anim = new BoxAnimation();
            box_anim.x = cell_width * item.col - 100;
            box_anim.y = cell_height * item.row;
            grid_animation_container.addChild(box_anim);
            
            TweenLite.delayedCall(item.delay, box_anim.animate);
        }
        
        TweenLite.delayedCall(4, showNav);
        TweenLite.delayedCall(4, animateSignature);
    }
    
    private function createNavigation() {
        var nav_objs = new Array<Dynamic>();
        for (item in main_xml.nodes.item) {
            nav_objs.push({
                        label : Std.string(item.node.label.innerData.text()),
                        background : Std.string(item.node.img.innerData.text()),
                        id : item.node.childIndex.innerData(),
                        position : item.att.grid_position
                    });
        }
        axx_nav = new HomeNavigation();
        axx_nav.visible = false;
        
        axx_nav.x = 500;
        addChildAt(axx_nav, getChildIndex(mc_axx));
        axx_nav.source = nav_objs;
        
        axx_nav.addEventListener(Event.SELECT, updateContent);
        nav_constructed = true;
    }
    
    private function createSlideshow() {
        var slideshow_list = main_xml.node.slideshow.innerData.node.img.innerData.text();
        var images_arr = new Array<Dynamic>();
        
        for (img/* AS3HX WARNING could not determine type for var: img exp: EIdent(slideshow_list) type: null */ in slideshow_list) {
            images_arr.push(Std.string(img));
        }
        
        var my_shadow : DropShadowFilter = new DropShadowFilter();
        my_shadow.color = 0x000000;
        my_shadow.blurY = 35;
        my_shadow.blurX = 35;
        my_shadow.angle = 135;
        my_shadow.alpha = 1;
        my_shadow.strength = 1.25;
        my_shadow.distance = 10;
        
        axx_ss = new Slideshow();
        axx_ss.filters = [my_shadow];
        axx_ss.x = 1380;
        axx_ss.y = 80;
        axx_ss.automatic = true;
        addChild(axx_ss);
        
        
        
        var nav_images : FastXMLList = main_xml.node.item.innerData.node.model.innerData.copy();
        
        var nav_xml : FastXML = FastXML.parse("<album id=\"nav\" />");
        nav_xml.node.setChildren.innerData(nav_images);
        
        axx_ss.addAlbum(main_xml.nodes.slideshow.get(0));
        axx_ss.addAlbum(nav_xml);
        
        axx_ss.album = "homepage";
        //axx_ss.source = images_arr;
        
        TweenLite.delayedCall(5, axx_ss.start);
    }
    
    private function showNav() {
        if (nav_constructed) {
            axx_nav.visible = true;
            axx_nav.animate();
        }
    }
    private function animateSignature() {
        axx_signature.mc_sig.play();
    }
    
    private function clearMiniTxt(e : MouseEvent = null) {
        mini_txt.htmlText = "";
    }
    
    private function updateMiniTxt(e : Event) {
        var _x = cast((e.target), NavigationItem).localToGlobal(new Point(0, 0)).x;
        mini_txt.x = _x + 2;
        mini_txt.htmlText = main_xml.nodes.item.get(e.target.id).node.mini_label.innerData.text().toUpperCase();
    }
    
    private function gotoHome(e : Event = null) {
        axx_nav.selectedIndex = -1;
    }
    
    private function updateContent(e : Event) {
        axx_nav.enabled = false;
        var _func = function() {
            axx_nav.enabled = true;
        }
        if (e.target.selectedIndex > -1 && axx_nav.mode != "singleRow") {
            TweenLite.to(axx_nav, .5, {
                        x : 1100,
                        scaleY : .25,
                        scaleX : .25
                    });
            TweenLite.to(home_btn, .5, {
                        alpha : 1,
                        y : 60
                    });
            mini_txt.y = 5;
            
            axx_nav.mode = "singleRow";
            axx_nav.addEventListener(MouseEvent.MOUSE_OVER, updateMiniTxt);
            axx_nav.addEventListener(MouseEvent.MOUSE_OUT, clearMiniTxt);
            TweenLite.to(axx_signature, .25, {
                        alpha : 0
                    });
        }
        else if (e.target.selectedIndex < 0 && axx_nav.mode != "grid") {
            TweenLite.to(axx_nav, .5, {
                        x : 500,
                        scaleY : 1,
                        scaleX : 1
                    });
            TweenLite.to(home_btn, .5, {
                        alpha : 0,
                        y : -30
                    });
            
            mini_txt.y = -30;
            mini_txt.text = "";
            
            axx_nav.mode = "grid";
            axx_nav.removeEventListener(MouseEvent.MOUSE_OVER, updateMiniTxt);
            axx_nav.removeEventListener(MouseEvent.MOUSE_OUT, clearMiniTxt);
            TweenLite.to(axx_signature, .25, {
                        alpha : 1,
                        delay : .5
                    });
        }
        
        TweenLite.delayedCall(.5, _func);
        
        if (axx_nav.mode == "singleRow") {
            if (axx_ss.album != "nav") {
                axx_ss.automatic = false;
                axx_ss.fadeSpeed = .25;
                axx_ss.viewAlbum("nav", axx_nav.selectedIndex);
            }
            else {
                axx_ss.jumpTo(axx_nav.selectedIndex);
            }
            axx_content.load(new URLRequest(Std.string(main_xml.nodes.item.get(e.target.selectedIndex).node.content.innerData.text())));
        }
        else if (axx_nav.mode == "grid") {
            axx_ss.automatic = true;
            axx_ss.viewAlbum("homepage");
            axx_ss.fadeSpeed = 2;
            
            axx_content.clear();
        }
    }
}



