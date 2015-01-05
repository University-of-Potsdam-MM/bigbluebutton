function change_chatarea()
{
	var chatarea_type = document.getElementsByName("chatarea_type");
	if(chatarea_type[0].checked){ //chat
		chat.style.backgroundColor = "yellow";
	showChat();
	} else if(chatarea_type[1].checked){ //notes
		chat.style.backgroundColor = "red";
		var i = 1;
	do {
		changeBlockVisibility("timelineDiv" + i, false);
		i++;
	} while (contentDiv!=null);
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
				changeBlockVisibility("timelineDiv" + i, true);
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

function changeBlockVisibility(blockName, visible) {
	if (visible) {
		contentDiv = document.getElementById(blockName);
		contentDiv.setAttribute('aria-hidden', false);
		contentDiv.style.display = "block";
	} else {
		contentDiv = document.getElementById(blockName);
		contentDiv.setAttribute('aria-hidden', true);
		contentDiv.style.display = "none";
	}
}
