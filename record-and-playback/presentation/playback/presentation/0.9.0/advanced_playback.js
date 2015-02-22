var USER_NOTES_XML = "";
var chatAndMedia_height;
var PUBLIC_NOTES_EXIST;

function change_chatarea()
{
	var chatarea_type = document.getElementsByName("chatarea_type");
	if (typeof chatAndMedia_height === 'undefined') {
		chatAndMedia_height = document.getElementById('chat').clientHeight;
	}
	if(chatarea_type[0].checked){ //chat
		chat.style.height = chatAndMedia_height+"px";
		notes.style.height = "0px";
		activitylog.style.height = "0px";
		chat.setAttribute('aria-hidden', false);
		chat.style.display = "block";
		notes.setAttribute('aria-hidden', true);
		notes.style.display = "none";
		activitylog.setAttribute('aria-hidden', true);
		activitylog.style.display = "none";
		showChat();
	} else if(chatarea_type[1].checked){ //notes
		notes.style.height = chatAndMedia_height+"px";
		chat.style.height = "0px";
		chat.setAttribute('aria-hidden', true);
		activitylog.style.height = "0px";
		activitylog.setAttribute('aria-hidden', true);
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
		if(PUBLIC_NOTES_EXIST == true){
			showNotes();
		}
	} else if(chatarea_type[2].checked){ //activitylog
		activitylog.style.height = chatAndMedia_height+"px";
		chat.style.height = "0px";
		chat.setAttribute('aria-hidden', true);
		notes.style.height = "0px";
		notes.setAttribute('aria-hidden', true);
		//chat.style.display = "none";
		activitylog.setAttribute('aria-hidden', false);
		activitylog.style.display = "block";
		var i = 1;
		contentDiv = document.getElementById("timelineDiv" + i);
		while (contentDiv) {
			contentDiv.setAttribute('aria-hidden', true);
			contentDiv.style.display = "none";
			i++;
			contentDiv = document.getElementById("timelineDiv" + i);
		}
		showActivitylog();
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

function showNotes()
{
	$.ajax({
		type:    "GET",
		url:     USER_NOTES_XML,
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
				contentDiv = document.getElementById("notesTimelineDiv" + i);
				contentDiv.setAttribute('aria-hidden', false);
				contentDiv.style.display = "block";
				i++;
			}
		},
		error:   function() {
			alert("error while retrieving notes-content");
		}
	});
}


function showActivitylog()
{
	$.ajax({
		type:    "GET",
		url:     ACTIVITYLOG_XML,
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
				contentDiv = document.getElementById("activitylogTimelineDiv" + i);
				contentDiv.setAttribute('aria-hidden', false);
				contentDiv.style.display = "block";
				i++;
			}
		},
		error:   function() {
			alert("error while retrieving activity-content");
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

function UrlExists(url)
{ //http://stackoverflow.com/questions/3646914/how-do-i-check-if-file-exists-in-jquery-or-javascript
    var http = new XMLHttpRequest();
    http.open('HEAD', url, false);
    http.send();
    return http.status==200;
}

function askUserForNotesId() {
	var notesId;
	USER_NOTES_XML = "";
	while(USER_NOTES_XML == ""){
		notesId = prompt("If you want to load your private notes enter your user Id:");
		if(notesId == null){
			break;
		}
		if(UrlExists(RECORDINGS+"/"+notesId.trim()+"-notes.xml")){
			USER_NOTES_XML = RECORDINGS+"/"+notesId.trim()+"-notes.xml";	
		}else{
			alert("File dosn't exist!");
		}	
	}
}

function change_showOptions(){
	contentDiv = document.getElementById("media-area-options");
	if ($("#showOptions").is(':checked')){
		contentDiv.setAttribute('aria-hidden', false);
		contentDiv.style.display = "block";
	}else{
		contentDiv.setAttribute('aria-hidden', true);
		contentDiv.style.display = "none";
	}
}

PUBLIC_NOTES_EXIST = UrlExists(NOTES_XML);
askUserForNotesId();
