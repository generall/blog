$(function () {
  function fixMenu() {
    var prevPos = 0;
    // per each scroll event
    $(window).scroll(function () {
      // how many pixels are from top
      var curPos = $(this).scrollTop(),
      wrapper = $('.wrapper'),
      header = $('.js-header');
      if (curPos == 0) {
        header.removeClass('scrolled').css({
          'position': 'relative',
          'top': '0'
        });         
        wrapper.css({
          'margin-top' : '0'
        });
      } else if (curPos < prevPos) { // scroll up
        var topOffset = header.offset().top, // 0 iff scroll up first time 
          headerHeight = header.innerHeight() - 5;

        if (curPos - topOffset > headerHeight) {//coming out is complete; Yes, my english is not so good
          var headerPos = curPos - headerHeight;

          wrapper.css({
            'margin-top' : header.outerHeight(true)
          });
          header.addClass('scrolled').css({
            'position': 'absolute',
            'top': headerPos + 'px'
          });
        } else if (curPos < topOffset) {
          header.addClass('scrolled').css({
            'position': 'fixed',
            'top': 0 + 'px'
          });
        } 
      } else if(header.css('position') == 'fixed') {
        header.addClass('scrolled').css({
          'position': 'absolute',
          'top': curPos + 'px'
        });
      }
      prevPos = curPos;
    });
  }

  function goToTop() {
    var topOfs = $(".toTop").offset().top;
    var myScreen = $(window).height();
    if( myScreen < topOfs ) {
      $(".toTop").fadeTo(0,0.8);
    }

    $(window).scroll(function () { 
      var topScreen = $(window).scrollTop();
      if(topScreen > (myScreen / 2)) {
        $(".toTop").fadeTo(0, 0.8);
      }
      else {
        $(".toTop").fadeTo(0, 0);
      }
      $(".toTop").blur();
    });
  }

  var load_tweeter = function(d,s,id)
  {
    var js,
    p=/^http:/.test(d.location)?'http':'https';
    if(!d.getElementById(id)){
      js=d.createElement(s);
      js.id=id;
      js.src=p+'://platform.twitter.com/widgets.js';
      var tweet = d.getElementById("tweet");
      if(tweet){
        tweet.appendChild(js);
      }
    }
  }


  $(document).ready(function () {
    fixMenu();
    goToTop();
    $(".toTop").click(function() {
      $("html, body").animate({"scrollTop": "0"}, "800");
    });
    $(".fancybox").fancybox({
      type: 'ajax',
    });
    hljs.initHighlighting.called = false;
    hljs.initHighlighting();
    var vk_share = $("#vkshare");
    if(vk_share.length){
      vk_share.html(VK.Share.button())
    }
    load_tweeter(document, 'script', 'twitter-wjs');
  });
}); 
