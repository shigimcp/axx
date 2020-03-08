package com.armaniexchange;

import flash.display.Sprite;

class SunglassesInfo extends Sprite {
    
    public function new() {
        super();
    }
    
    public function updateInfo(_xml : FastXML) {
        txt_descr.text = _xml.node.description.innerData.node.text.innerData().toUpperCase();
        
        var link = _xml.nodes.link.get(0).node.copy.innerData();
        link.appendChild("BUY NOW $" + _xml.node.price.innerData.node.text.innerData());
        link_btn.source = link;
    }
}