package com.armaniexchange;

import flash.display.Sprite;
import flash.display.MovieClip;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.events.MouseEvent;
import flash.net.URLRequest;

class ProductLinkButton extends Sprite {
    public var source(never, set);

    
    public var arrow : MovieClip;
    public var txt : TextField;
    public var bg : MovieClip;
    
    private var _href : String;
    private var _target : String;
    
    public function new() {
        super();
        addEventListener(MouseEvent.ROLL_OVER, roll_over);
        addEventListener(MouseEvent.ROLL_OUT, roll_out);
        addEventListener(MouseEvent.CLICK, _click);
        mouseChildren = false;
        buttonMode = true;
    }
    
    private function set_source(_v) {
        _href = _v.att.href;
        _target = _v.att.target;
        
        txt.autoSize = TextFieldAutoSize.LEFT;
        txt.htmlText = _v.text();
        txt.embedFonts = true;
        arrow.height = txt.height;
        arrow.scaleY = arrow.scaleX;
        arrow.x = txt.x + txt.textWidth + 2;
        
        bg.width = arrow.x + arrow.width * 2;
        bg.height = txt.height;
        return _v;
    }
    
    private function roll_over(e : MouseEvent) {
        arrow.gotoAndPlay("in");
    }
    
    private function roll_out(e : MouseEvent) {
        arrow.gotoAndPlay("out");
    }
    
    private function _click(e : MouseEvent) {
        var req : URLRequest = new URLRequest(_href);
        flash.Lib.getURL(req, _target);
    }
}