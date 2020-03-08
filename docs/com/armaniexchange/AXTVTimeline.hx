package com.armaniexchange;

import flash.events.AsyncErrorEvent;
import flash.net.NetConnection;
import flash.net.NetStream;
import flash.media.Video;
import flash.geom.Matrix;
import flash.display.MovieClip;
import com.flashandmath.dg.display.RetroTV;
import com.greensock.TweenLite;
import com.greensock.TweenMax;
import flash.events.Event;
import com.greensock.OverwriteManager;
import com.greensock.easing.*;

class AXTVTimeline extends MovieClip {
    
    public var TV : RetroTV;
    public var noiseAmount : Float;
    public var nc : NetConnection;
    public var ns : NetStream;
    public var vid : Video;
    
    
    public var delayedCalls;
    public function new() {
        super();
        addEventListener(Event.ADDED_TO_STAGE, init);
        addEventListener(Event.REMOVED_FROM_STAGE, destroyAll);
        
        //OverwriteManager.init();
        //TweenLite.defaultEase = Sine.easeOut;
        delayedCalls = new Array<Dynamic>();
    }
    
    public function init(e : Event = null) {
        TV = new RetroTV(333, 200);
        TV.x = 0;
        TV.y = 0;
        TV.alpha = 0;
        TV.mask = mc_mask;
        
        TV.redOffsetX = 1.5;
        TV.redOffsetY = 0.75;
        TV.greenOffsetX = -0.5;
        TV.greenOffsetY = 0;
        TV.blueOffsetX = -0.25;
        TV.blueOffsetY = 0;
        
        TV.warping = true;
        TV.noiseAmount = 40;
        
        noiseAmount = 40;
        
        addChild(TV);
        
        setUpScene();
        removeEventListener(Event.ADDED_TO_STAGE, init);
        
        TV.addEventListener(Event.ENTER_FRAME, onEnter);
        
        addChild(mc_ko);
        playIntro();
        loadFLV();
    }
    
    
    public function onEnter(evt : Event) : Void {
        TV.noiseAmount = noiseAmount;
        TV.update();
    }
    
    public function setUpScene() : Void
    //draw background: {
        
        var testPattern : McTestPattern200 = new McTestPattern200();
        TV.scene.addChild(testPattern);
        
        TV.scene.graphics.beginFill(0x000000);
        TV.scene.graphics.drawRect(0, 0, TV.sceneWidth, TV.sceneHeight);
        TV.scene.graphics.endFill();
        
        var mat : Matrix = new Matrix();
        mat.createGradientBox(45, 45, 0, -23, -23);
    }
    
    public function playIntro() {
        TweenLite.to(mc_AXTVlogo, .5, {
                    alpha : 1
                });
        TweenLite.to(mc_hed, .5, {
                    alpha : 1
                });
        //			TweenLite.to(mc_soon,.5,{alpha:1,delay:1});
        
        var _func = function(_y _scaleX _scaleY _alpha) {
            TV.y = _y;
            TV.scaleX = _scaleX;
            TV.scaleY = _scaleY;
            
            if (TV.alpha != _alpha) {
                TV.alpha = _alpha;
            }
        }
        
        delayedCalls.push(TweenLite.delayedCall(2.875, _func, [-900, 4, 4]));
        delayedCalls.push(TweenLite.delayedCall(3.25, _func, [0, 1, 1]));
        delayedCalls.push(TweenLite.delayedCall(3.375, _func, [-350, 1.5, 2]));
        
        delayedCalls.push(TweenLite.delayedCall(3.75, function() {
                            _func(0, 1, 1);
                            TweenLite.to(mc_ko, 3, {
                                        alpha : 1,
                                        delay : .5,
                                        onComplete : destroyTV
                                    });
                            mc_AXTVlogo.alpha = 0;
                            mc_hed.alpha = 0;
                        }));
        
        TweenLite.to(mc_ko, .375, {
                    y : 300,
                    height : 1,
                    delay : 7,
                    ease : Expo.easeIn
                });
        TweenLite.to(mc_spot, .75, {
                    alpha : 1,
                    width : 100,
                    height : 100,
                    delay : 7,
                    ease : Expo.easeIn
                });
        TweenLite.to(mc_ko, .25, {
                    x : 500,
                    width : 1,
                    delay : 7.375,
                    ease : Expo.easeIn
                });
        TweenLite.to(mc_spot, 2, {
                    alpha : 0,
                    width : 10,
                    height : 10,
                    delay : 7.75,
                    ease : Expo.easeIn,
                    onComplete : showFLV
                });
        TweenLite.to(mc_ko, 1, {
                    alpha : 0,
                    delay : 8.25,
                    ease : Expo.easeIn
                });
    }
    
    public function destroyTV() {
        TweenLite.killTweensOf(TV);
        TV.removeEventListener(Event.ENTER_FRAME, onEnter);
        removeChild(TV);
    }
    
    private function asyncErrorHandler(event : AsyncErrorEvent) : Void {  // ignore error  
        
    }
    
    private function loadFLV() : Void {
        nc = new NetConnection();
        nc.connect(null);
        
        ns = new NetStream(nc);
        ns.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler);
        ns.play("images/axtv/SU1120YEARS.flv");
        ns.pause();
        
        vid = new Video();
        vid.attachNetStream(ns);
        vid.visible = false;
        
        addChild(vid);
        vid.y = 18;
        vid.width = 1000;
        vid.height = 564;
    }
    
    public function showFLV() {
        vid.visible = true;
        ns.resume();
    }
    public function onClose() {
        delayedCalls.forEach(function(item a b) {
                    item.kill();
                });
    }
    public function destroyAll(e : Event = null) {
        ns.close();
        nc.close();
        TweenMax.killChildTweensOf(this);
        removeEventListener(Event.REMOVED_FROM_STAGE, destroyAll);
    }
}


