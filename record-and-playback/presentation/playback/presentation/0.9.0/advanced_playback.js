var USER_NOTES_XML = "";
var chatAndMedia_height;

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

askUserForNotesId();
