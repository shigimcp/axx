package com.armaniexchange;

import flash.display.Sprite;
import flash.text.TextFieldAutoSize;

class SocialPost extends Sprite {
    
    private var _src : FastXML;
    
    public var startX;
    public var startY;
    
    public function new(src : FastXML) {
        super();
        
        _src = src;
        heading_txt.text = Std.string(src.node.name.innerData) + " says:";
        
        message_txt.autoSize = TextFieldAutoSize.LEFT;
        message_txt.text = Std.string(src.node.message.innerData);
        
        _icon.gotoAndStop(src.att.type);
        
        bg.height = Math.max(bg.height, message_txt.getBounds(this).bottom + 4);
    }
}