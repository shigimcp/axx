package com.armaniexchange;

import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.events.Event;
import flash.events.EventDispatcher;

class SocialFeedManager extends EventDispatcher {
    public var total(get, never);

    
    
    private var feed_xml : FastXML;
    private var feeds_arr : Array<Dynamic>;
    
    public function new() {
        super();
        feeds_arr = new Array<Dynamic>();
    }
    
    public function fetch() {
        var _urlLoader = new URLLoader(new URLRequest("http://www.ax-beta.com/axx-microsite/fetchFeeds.php"));
        _urlLoader.addEventListener(Event.COMPLETE, setupFeeds);
    }
    
    private function setupFeeds(e : Event) {
        feed_xml = new FastXML(e.target.data);
        dispatchEvent(new Event(Event.COMPLETE));
    }
    
    public function post(_val) {
        return feed_xml.nodes.post.get(_val);
    }
    private function get_total() {
        return feed_xml.nodes.post.length();
    }
}