package com.armaniexchange;

import com.greensock.OverwriteManager;
import com.greensock.TweenLite;
import com.greensock.easing.Linear;
import flash.display.MovieClip;
import flash.events.Event;
import flash.events.MouseEvent;

class SocialTimeline extends MovieClip {
    
    public var socialFeedManager : SocialFeedManager;
    public var current_post = 0;
    
    public function new() {
        super();
        
        OverwriteManager.init();
        socialFeedManager = new SocialFeedManager();
        socialFeedManager.addEventListener(Event.COMPLETE, displayPosts);
        socialFeedManager.fetch();
        
        TweenLite.to(mc_twitterIMG, .5, {
                    alpha : 1
                });
        TweenLite.to(mc_twitterHED, .5, {
                    alpha : 1,
                    delay : .25
                });
    }
    
    public function displayPosts(e : Event) {
        showPost(0);
    }
    
    public function showPost(_val) {
        current_post = _val;
        var post_data = socialFeedManager.post(_val);
        var post = new SocialPost(post_data);
        
        post.addEventListener(MouseEvent.ROLL_OVER, stopDisplay);
        post.addEventListener(MouseEvent.ROLL_OUT, startDisplay);
        
        var burstX = Math.floor(Math.random() * (400 + 50)) - 50;
        var burstY = Math.floor(Math.random() * (600 - 150 - post.height)) + 150;
        
        post.x = post.startX = burstX;
        post.y = post.startY = burstY;
        
        post.alpha = 0;
        addChild(post);
        
        TweenLite.to(post, 1.5, {
                    alpha : 1
                });
        TweenLite.to(post, .5, {
                    alpha : .75,
                    x : post.x + (post.width - post.width * .9) / 2,
                    scaleY : .9,
                    scaleX : .9,
                    delay : 2
                });
        TweenLite.to(post, 5, {
                    alpha : 0,
                    delay : 4,
                    ease : Linear.easeOut,
                    onComplete : function() {
                        removeChild(post);
                    }
                });
        
        TweenLite.delayedCall(2, showPost, [(current_post + 1) % socialFeedManager.total]);
    }
    
    public function stopDisplay(e : MouseEvent = null) {
        var post = e.currentTarget;
        addChild(post);
        TweenLite.killTweensOf(post);
        TweenLite.killDelayedCallsTo(showPost);
        TweenLite.to(post, .5, {
                    alpha : 1,
                    x : post.startX,
                    scaleY : 1,
                    scaleX : 1
                });
    }
    
    public function startDisplay(e : MouseEvent = null) {
        var post = e.currentTarget;
        TweenLite.to(post, .5, {
                    alpha : .75,
                    x : post.x + (post.width - post.width * .9) / 2,
                    scaleY : .9,
                    scaleX : .9,
                    delay : .5
                });
        TweenLite.to(post, 5, {
                    alpha : 0,
                    delay : 2,
                    ease : Linear.easeOut,
                    onComplete : function() {
                        removeChild(post);
                    }
                });
        TweenLite.delayedCall(.5, showPost, [(current_post + 1) % socialFeedManager.total]);
    }
}