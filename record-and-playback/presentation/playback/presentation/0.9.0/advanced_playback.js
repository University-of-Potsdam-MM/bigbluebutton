var chatAndMedia_height;

function change_chatarea()
{
	var chatarea_type = document.getElementsByName("chatarea_type");
	if (typeof chatAndMedia_height === 'undefined') {
		chatAndMedia_height = document.getElementById('chat').clientHeight;
	}
	if(chatarea_type[0].checked){ //chat
		chat.style.backgroundColor = "yellow";
		chat.style.height = chatAndMedia_height+"px";
		notes.style.height = "0px";
		chat.setAttribute('aria-hidden', false);
		chat.style.display = "block";
		notes.setAttribute('aria-hidden', true);
		notes.style.display = "none";
		showChat();
	} else if(chatarea_type[1].checked){ //notes
		notes.style.backgroundColor = "red";
		notes.style.height = chatAndMedia_height+"px";
		chat.style.height = "0px";
		chat.setAttribute('aria-hidden', true);
		//chat.style.display = "none";
		notes.setAttribute('aria-hidden', false);
		notes.style.display = "block";
		var i = 1;
		contentDiv = document.getElementById("timelineDiv" + i);
		while (contentDiv) {
			contentDiv.setAttribute('aria-hidden', true);
			contentDiv.style.display = "none";
			i++;
			contentDiv = document.getElementById("timelineDiv" + i);
		} 
	} else {
		chat.style.backgroundColor = "blue";
	}
}

function showChat()
{
	$.ajax({
		type:    "GET",
		url:     SLIDES_XML,
		success: function(text) {
			var timeStamps = new Array();
			for (var i=0;i<text.children[0].children.length;i++) {
				var child = text.children[0].children[i];
				timeStamps.push(child.attributes.getNamedItem("in").value);
			}
			var pop2 = Popcorn("#video");
			var j = getLastChatId(timeStamps, pop2.currentTime());
			var i = 1;
			while (i <= j) {
				contentDiv = document.getElementById("timelineDiv" + i);
				contentDiv.setAttribute('aria-hidden', false);
				contentDiv.style.display = "block";
				i++;
			}
		},
		error:   function() {
			alert("error while retrieving chat-content");
		}
	});
}

function getLastChatId(noteTimes, currentTime){
	for(var j = 0; j < noteTimes.length; j++){
		if(noteTimes[j] > currentTime){
			break;
		}
	}
	return j;
}

