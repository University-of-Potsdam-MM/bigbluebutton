// PLUGIN: ActivitylogTimeline
(function ( Popcorn ) {

  /**
     * mostly a copy of popcorn.chattimeline.js
     * activitylog-timeline popcorn plug-in
     * Adds data associated with a certain time in the video, which creates a scrolling view of each item as the video progresses
     * Options parameter will need a start, target, title, and text
     * -Start is the time that you want this plug-in to execute
     * -End is the time that you want this plug-in to stop executing, tho for this plugin an end time may not be needed ( optional )
     * -Target is the id of the DOM element that you want the timeline to appear in. This element must be in the DOM
     * -Name is the name of the current chat message sender
     * -Text is text is simply related text that will be displayed
     * -direction specifies whether the timeline will grow from the top or the bottom, receives input as "UP" or "DOWN"
     * @param {Object} options
     *
     * Example:
      var p = Popcorn("#video")
        .timeline( {
         start: 5, // seconds
         target: "timeline",
         name: "Seneca",
         text: "Welcome to seneca",
      } )
    *
  */

  var i = 1;
 Popcorn.plugin( "activitylogTimeline" , function( options ) {
    var target = document.getElementById( options.target ),
        contentDiv = document.createElement( "div" ),
        goingUp = true;

    contentDiv.style.display = "none";
    contentDiv.setAttribute('aria-hidden', true);
    contentDiv.id = "activitylogTimelineDiv" + i;
    contentDiv.onclick = function() {goToSlide(options.start);Popcorn('#video').pause();};
    
    //  Default to up if options.direction is non-existant or not up or down
    options.direction = options.direction || "up";
    if ( options.direction.toLowerCase() === "down" ) {

      goingUp = false;
    }

    if ( target ) {
      // if this isnt the first div added to the target div
      if( goingUp ){
        // insert the current div before the previous div inserted
        target.insertBefore( contentDiv, target.firstChild );
      }
      else {

        target.appendChild( contentDiv );
      }

    }

    i++;

    //  Default to empty if not used
    //options.innerHTML = options.innerHTML || "";

    contentDiv.innerHTML = "<strong>"+options.activity+" "+options.value+": </strong>" + options.message;

    return {

      start: function( event, options ) {
        switch(options.activity){
        	case "[Chat]":
        		showContent(contentDiv, ($("#activitylog_chat").is(':checked')));
        		break;
        	case "[AddShape]":
        		showContent(contentDiv, ($("#activitylog_addShape").is(':checked')));
        		break;        		
        	case "[ModifyText]":
        		showContent(contentDiv, ($("#activitylog_modifyText").is(':checked')));
        		break;
        	case "[GotoSlide]":
        		showContent(contentDiv, ($("#activitylog_gotoSlide").is(':checked')));
        		break;        		
        	case "[ParticipantStatus]":
        		showContent(contentDiv, ($("#activitylog_participantStatus").is(':checked')));
        		break;
        	case "[Deskshare]":
        		showContent(contentDiv, ($("#activitylog_deskshare").is(':checked')));
        		break;
        	default:
        		showContent(contentDiv, true);       	        	        	
        }
        if( options.direction === "down" ) {
          target.scrollTop = target.scrollHeight;
        }
	
        if ($("#accEnabled").is(':checked'))
          addTime(7);
      },

      end: function( event, options ) {
        contentDiv.style.display = "none";
        contentDiv.setAttribute('aria-hidden', true);
      },

      _teardown: function( options ) {

        ( target && contentDiv ) && target.removeChild( contentDiv ) && !target.firstChild
      }
    };
  },
  {

    options: {
      start: {
        elem: "input",
        type: "number",
        label: "Start"
      },
      end: {
        elem: "input",
        type: "number",
        label: "End"
      },
      target: "feed-container",
      name: {
        elem: "input",
        type: "text",
        label: "Name"
      },
      message: {
        elem: "input",
        type: "text",
        label: "Message"
      },
      activity: {
        elem: "input",
        type: "text",
        label: "Message"
      },
      value: {
        elem: "input",
        type: "text",
        label: "Message"
      },
      direction: {
        elem: "select",
        options: [ "DOWN", "UP" ],
        label: "Direction",
        optional: true
      }
    }
  });

})( Popcorn );

function showContent(content, show){
	content.setAttribute('aria-hidden', !show);
	if(show){
		content.style.display = "block";
	}else{
		content.style.display = "none";
	}
}
