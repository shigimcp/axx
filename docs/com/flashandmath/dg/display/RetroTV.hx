package com.flashandmath.dg.display;

import flash.display.*;
import flash.geom.*;
import flash.filters.*;

class RetroTV extends Sprite {
    public var redOffsetX(never, set) : Float;
    public var redOffsetY(never, set) : Float;
    public var greenOffsetX(never, set) : Float;
    public var greenOffsetY(never, set) : Float;
    public var blueOffsetX(never, set) : Float;
    public var blueOffsetY(never, set) : Float;
    public var brightenFactor(never, set) : Float;
    public var TVWidth(get, never) : Float;
    public var TVHeight(get, never) : Float;

    
    public var phosphorWidth : Float;
    public var _brightenFactor : Float;
    public var preBlur : BlurFilter;
    public var warping : Bool;
    public var scene : Sprite;
    public var sceneWidth : Float;
    public var sceneHeight : Float;
    public var _redOffsetX : Float;
    public var _redOffsetY : Float;
    public var _greenOffsetX : Float;
    public var _greenOffsetY : Float;
    public var _blueOffsetX : Float;
    public var _blueOffsetY : Float;
    public var minPhosphorLevel : Float;
    public var displacementBitmapData : BitmapData;
    public var noiseAmount : Float;
    public var usePreBlurRed : Bool;
    public var usePreBlurGreen : Bool;
    public var usePreBlurBlue : Bool;
    
    private var TVPic : Bitmap;
    private var sceneData : BitmapData;
    private var TVPicData : BitmapData;
    private var origin : Point;
    private var verticalLine : Rectangle;
    private var destPoint : Point;
    private var noiseData : BitmapData;
    private var noiseBitmap : Bitmap;
    private var raiseFloor : ColorTransform;
    private var dmfilter : DisplacementMapFilter;
    private var redOffsetMatrix : Matrix;
    private var greenOffsetMatrix : Matrix;
    private var blueOffsetMatrix : Matrix;
    private var brighten : ColorTransform;
    
    
    public function new(sceneW sceneH phosphorW) {
        super();
        
        phosphorWidth = phosphorW;
        //weird things happen if phosphorWidth is not set to an integer > 0.
        phosphorWidth = Math.max(1, Math.floor(phosphorWidth));
        
        sceneWidth = sceneW;
        sceneHeight = sceneH;
        
        //The 'scene' is the sprite that will be the source image for the TV effect.
        //you can add any display object (including video) to the scene as a child.
        scene = new Sprite();
        //make a background for the scene to make empty parts of the sprite black.
        scene.graphics.beginFill(0x000000);
        scene.graphics.drawRect(0, 0, sceneWidth, sceneHeight);
        scene.graphics.endFill();
        
        noiseAmount = 45;
        
        usePreBlurRed = false;
        usePreBlurGreen = false;
        usePreBlurBlue = false;
        preBlur = new BlurFilter(2, 2);
        
        _redOffsetX = 0;
        _redOffsetY = 0;
        _greenOffsetX = 0;
        _greenOffsetY = 0;
        _blueOffsetX = 0;
        _blueOffsetY = 0;
        redOffsetMatrix = new Matrix(1, 0, 0, 1, _redOffsetX, _redOffsetY);
        greenOffsetMatrix = new Matrix(1, 0, 0, 1, _greenOffsetX, _greenOffsetY);
        blueOffsetMatrix = new Matrix(1, 0, 0, 1, _blueOffsetX, _blueOffsetY);
        
        
        minPhosphorLevel = 16;
        raiseFloor = new ColorTransform(1 - minPhosphorLevel / 255, 1 - minPhosphorLevel / 255, 1 - minPhosphorLevel / 255, 1, minPhosphorLevel, minPhosphorLevel, minPhosphorLevel, 0);
        
        _brightenFactor = 1.15;
        brighten = new ColorTransform(_brightenFactor, _brightenFactor, _brightenFactor);
        
        warping = true;
        
        //sceneData is the BitmapData that the scene will be drawn to for pixel reading:
        sceneData = new BitmapData(sceneWidth, sceneHeight, false);
        
        //TVPic is the bitmap which will be displayed:
        TVPicData = new BitmapData(sceneWidth * 3, sceneHeight, false);
        TVPic = new Bitmap(TVPicData);
        TVPic.scaleX = phosphorWidth;
        TVPic.scaleY = 3 * phosphorWidth;
        
        //noiseData will create the noise effect over the top
        noiseData = new BitmapData(3 * sceneWidth, sceneHeight, false);
        noiseBitmap = new Bitmap(noiseData);
        noiseBitmap.scaleX = phosphorWidth;
        noiseBitmap.scaleY = 3 * phosphorWidth;
        
        this.addChild(TVPic);
        this.addChild(noiseBitmap);
        //We use the ADD blend mode so that the noiseBitmap will lighten underlying pixels.
        noiseBitmap.blendMode = BlendMode.ADD;
        
        createDisplacementMap();
        
        //point to use for filters:
        origin = new Point();
        
        verticalLine = new Rectangle(0, 0, 1, sceneData.height);
        destPoint = new Point();
    }
    
    private function set_redOffsetX(n : Float) : Float {
        _redOffsetX = n;
        redOffsetMatrix = new Matrix(1, 0, 0, 1, _redOffsetX, _redOffsetY);
        return n;
    }
    private function set_redOffsetY(n : Float) : Float {
        _redOffsetY = n;
        redOffsetMatrix = new Matrix(1, 0, 0, 1, _redOffsetX, _redOffsetY);
        return n;
    }
    private function set_greenOffsetX(n : Float) : Float {
        _greenOffsetX = n;
        greenOffsetMatrix = new Matrix(1, 0, 0, 1, _greenOffsetX, _greenOffsetY);
        return n;
    }
    private function set_greenOffsetY(n : Float) : Float {
        _greenOffsetY = n;
        greenOffsetMatrix = new Matrix(1, 0, 0, 1, _greenOffsetX, _greenOffsetY);
        return n;
    }
    private function set_blueOffsetX(n : Float) : Float {
        _blueOffsetX = n;
        blueOffsetMatrix = new Matrix(1, 0, 0, 1, _blueOffsetX, _blueOffsetY);
        return n;
    }
    private function set_blueOffsetY(n : Float) : Float {
        _blueOffsetY = n;
        blueOffsetMatrix = new Matrix(1, 0, 0, 1, _blueOffsetX, _blueOffsetY);
        return n;
    }
    
    private function set_brightenFactor(n : Float) : Float {
        _brightenFactor = n;
        brighten = new ColorTransform(_brightenFactor, _brightenFactor, _brightenFactor);
        return n;
    }
    private function get_TVWidth() : Float {
        return sceneWidth * phosphorWidth * 3;
    }
    private function get_TVHeight() : Float {
        return sceneHeight * phosphorWidth * 3;
    }
    
    
    private function createDisplacementMap() : Void {
        var numLines : Float = 8;
        var lineThicknessMax : Float = 4;
        var i : Float;
        
        displacementBitmapData = new BitmapData(sceneWidth, sceneHeight, false, 0x808080);
        
        var gradMatrix : Matrix = new Matrix();
        var bottomWarpHeight : Float = 0.15 * sceneHeight;
        var bottomWarp : Shape = new Shape();
        gradMatrix.createGradientBox(sceneWidth, bottomWarpHeight, -Math.PI / 2, 0, sceneHeight - bottomWarpHeight);
        bottomWarp.graphics.beginGradientFill(GradientType.LINEAR, [0xaaaaaa, 0x808080], [1, 1], [0, 255], gradMatrix);
        bottomWarp.graphics.drawRect(0, sceneHeight - bottomWarpHeight, sceneWidth, bottomWarpHeight);
        bottomWarp.graphics.endFill();
        displacementBitmapData.draw(bottomWarp);
        
        for (i in 0...7) {
            var line : Shape = new Shape();
            var posY : Float = 5 + Math.random() * (sceneHeight - 10);
            var grayLevel : Float = 128 + 90 * (2 * Math.random() - 1);
            var color : Int = as3hx.Compat.parseInt(grayLevel << 16 | grayLevel << 8) | as3hx.Compat.parseInt(grayLevel);
            line.graphics.lineStyle(1 + 2 * Math.random(), color);
            line.graphics.moveTo(0, posY);
            line.graphics.lineTo(sceneWidth, posY);
            displacementBitmapData.draw(line);
        }
        
        var dmblur : BlurFilter = new BlurFilter(0, 7, 3);
        displacementBitmapData.applyFilter(displacementBitmapData, displacementBitmapData.rect, new Point(0, 0), dmblur);
        dmfilter = new DisplacementMapFilter(displacementBitmapData, origin, BitmapDataChannel.RED, BitmapDataChannel.BLUE, 2, 0, DisplacementMapFilterMode.COLOR, 0x000000);
    }
    
    
    public function update() : Void
    //update warping amount {
        
        if (warping) {
            dmfilter.scaleX = 25 * (0.5 + 0.5 * Math.cos(Math.round(haxe.Timer.stamp() * 1000) * 0.001027 + Math.cos(Math.round(haxe.Timer.stamp() * 1000) * 0.001324))) * (0.5 + 0.5 * Math.cos(Math.round(haxe.Timer.stamp() * 1000) * 0.005227 + Math.cos(Math.round(haxe.Timer.stamp() * 1000) * 0.072324)));
            if (dmfilter.scaleX < 5) {
                dmfilter.scaleX = 5;
            }
        }
        
        //change noise
        noiseData.noise(as3hx.Compat.parseInt(Math.random() * as3hx.Compat.INT_MAX), 0, noiseAmount, 7, true);
        
        //draw TVPicData
        TVPicData.lock();
        
        TVPicData.fillRect(TVPicData.rect, 0x000000);
        var i : Float;
        
        //draw scene to bitmap for copying
        sceneData.draw(scene, redOffsetMatrix);
        if (warping) {
            sceneData.applyFilter(sceneData, sceneData.rect, origin, dmfilter);
        }
        sceneData.colorTransform(sceneData.rect, brighten);
        sceneData.applyFilter(sceneData, sceneData.rect, origin, preBlur);
        for (i in 0...sceneData.width + 1)
        
        //red line{
            
            verticalLine.x = i;
            destPoint.x = 3 * i;
            TVPicData.copyChannel(sceneData, verticalLine, destPoint, BitmapDataChannel.RED, BitmapDataChannel.RED);
        }
        
        //draw scene to bitmap for copying
        sceneData.draw(scene, greenOffsetMatrix);
        if (warping) {
            sceneData.applyFilter(sceneData, sceneData.rect, origin, dmfilter);
        }
        sceneData.colorTransform(sceneData.rect, brighten);
        for (i in 0...sceneData.width + 1)
        
        //green line{
            
            verticalLine.x = i;
            destPoint.x = 3 * i + 1;
            TVPicData.copyChannel(sceneData, verticalLine, destPoint, BitmapDataChannel.GREEN, BitmapDataChannel.GREEN);
        }
        
        //draw scene to bitmap for copying
        sceneData.draw(scene, blueOffsetMatrix);
        if (warping) {
            sceneData.applyFilter(sceneData, sceneData.rect, origin, dmfilter);
        }
        sceneData.colorTransform(sceneData.rect, brighten);
        for (i in 0...sceneData.width + 1)
        
        //blue line{
            
            verticalLine.x = i;
            destPoint.x = 3 * i + 2;
            TVPicData.copyChannel(sceneData, verticalLine, destPoint, BitmapDataChannel.BLUE, BitmapDataChannel.BLUE);
        }
        
        //raise floor to minimum phosphor level
        TVPicData.colorTransform(TVPicData.rect, raiseFloor);
        TVPicData.unlock();
    }
}