/**
 * BigBlueButton open source conferencing system - http://www.bigbluebutton.org/
 * 
 * Copyright (c) 2012 BigBlueButton Inc. and by respective authors (see below).
 *
 * This program is free software; you can redistribute it and/or modify it under the
 * terms of the GNU Lesser General Public License as published by the Free Software
 * Foundation; either version 3.0 of the License, or (at your option) any later
 * version.
 * 
 * BigBlueButton is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
 * PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License along
 * with BigBlueButton; if not, see <http://www.gnu.org/licenses/>.
 *
 */
package org.bigbluebutton.modules.activitylog.model
{
  import mx.collections.ArrayCollection;

  import flash.events.*;
  import flash.net.FileReference;
  import flash.utils.ByteArray;

  import org.bigbluebutton.modules.activitylog.ActivitylogUtil;
  import org.bigbluebutton.modules.activitylog.vo.ActivitylogMessageVO;
  import org.bigbluebutton.modules.activitylog.services.DataProvider;
  import org.bigbluebutton.util.i18n.ResourceUtil;

  import org.bigbluebutton.core.managers.UserManager;
  import org.bigbluebutton.main.model.users.BBBUser;
  import org.bigbluebutton.main.model.users.Conference;
  import org.bigbluebutton.common.Role;
  import org.bigbluebutton.modules.present.model.PresentationModel;
  import org.bigbluebutton.modules.present.model.Page;

  public class ActivitylogConversation
  { 
    [Bindable]
    public var messages:ArrayCollection = new ArrayCollection();
    public var history:ArrayCollection = new ArrayCollection();

    private var result:String = str("cmd.unknown");

    private var possibleTags:Array = [str("tag.USER"),str("tag.BOARD"),str("tag.QUERY"),str("tag.PUBCHAT"),str("tag.PRIVCHAT"),str("tag.MEETING")];
    private var filtertags:Array = [str("tag.USER"),str("tag.BOARD"),str("tag.QUERY"),str("tag.PUBCHAT"),str("tag.PRIVCHAT"),str("tag.MEETING")];

    public function numMessages():int {
	return messages.length;
    }

    private function str(s:String):String {
	return ResourceUtil.getInstance().getString("bbb.activitylog.ActivitylogConversation."+s);
    }
	
    public function newAlogQuery(message:String):void {
	result = solveQuery(message);
	if (result != null)
		writeResult();
    }

    private function writeResult():void {
	var msg:ActivitylogMessageVO = new ActivitylogMessageVO();
	msg.fromUsername = str("tag.QUERY");
	msg.message = result; 
	newActivitylogMessage(msg);
    }

    private function solveQuery(query:String):String {
	var tags:Array;
	var qryflag:Boolean = true;
	if (query.substring(0,5) == str("cmd.echo")+" ") {
		var text:String = query.substring(5,query.length);
		query = str("cmd.echo");
	}

	if (query.substring(0,7) == str("cmd.filter")+" ") {
		tags = query.substring(7,query.length).split(" ");
		query = str("cmd.filter");
	}

	if (query.substring(0,8) == str("cmd.filtadd")+" ") {
		tags = query.substring(8,query.length).split(" ");
		query = str("cmd.filtadd");
	}

	if (query.substring(0,8) == str("cmd.filtdel")+" ") {
		tags = query.substring(8,query.length).split(" ");
		query = str("cmd.filtdel");
	}

	if (query.substring(0,5) == str("cmd.save")+" ") {	
		if (query.substring(5,query.length) == str("cmd.save.noqueries"))
			qryflag = false;
		DataProvider.setSaveWithQueries(qryflag);
		query = str("cmd.save");
	}

	switch (query) {
	case str("cmd.amimoderator"):
	  result = handleCMDamimoderator();
          break;
	case str("cmd.amimuted"):
	  result = handleCMDamimuted();
          break;
	case str("cmd.amipresenter"):
	  result = handleCMDamipresenter();
          break;
	case str("cmd.amivoicejoined"):
	  result = handleCMDamivoicejoined();
          break;
        case str("cmd.clear"):
	  messages.removeAll();
          result = null;
          break;
        case str("cmd.clearhistory"):
	  history.removeAll();
          result = null;
          break;
	case str("cmd.currentslide"):
	  result = handleCMDcurrentslide();
          break;
	case str("cmd.date"):
          result = str("txt.date") + new Date().toString();
          break;
	case str("cmd.echo"):
          result = str("txt.echo") + " " + text;
          break;
	case str("cmd.filter"):
	  prepareFilterCMD(tags);
	  applyFilter();
          result = null;
          break;
	case str("cmd.filtadd"):
	  prepareFilterCMDadd(tags);
	  applyFilter();
          result = null;
          break;
	case str("cmd.filtdel"):
	  prepareFilterCMDdel(tags);
	  applyFilter();
          result = null;
          break;
	case str("cmd.help"):
          result = str("help");
          break;
	case str("cmd.ismyhandraised"):
	  result = handleCMDismyhandraised();
          break;
	case str("cmd.listusers"):
	  result = handleCMDlistusers();
          break;
	case str("cmd.lowermyhand"):
	  result = handleCMDlowermyhand();
          break;
	case str("cmd.muteme"):
	  result = handleCMDmuteme();
          break;
	case str("cmd.raisemyhand"):
	  result = handleCMDraisemyhand();
          break;
	case str("cmd.save"):
	  writeToLogFile(qryflag);
	  result = null;
          break;
	case str("cmd.unmuteme"):
	  result = handleCMDunmuteme();
          break;
	case str("cmd.whatsmyrole"):
	  result = handleCMDwhatsmyrole();
          break;
	case str("cmd.whoami"):
	  result = handleCMDwhoami();
          break;
	case str("cmd.whoismoderator"):
	  result = handleCMDwhoismoderator();
          break;
	case str("cmd.whoispresenter"):
	  result = handleCMDwhoispresenter();
          break;
        default:
          result = str("cmd.unknown");
      	}

	return result;
    }

    public function newActivitylogMessage(msg:ActivitylogMessageVO):void {
	if (msg.fromUsername == "Save File") {
		writeToLogFile(DataProvider.cbSaveWithQueries);
		return;//new070115
	}
	if (msg.fromUsername == "Help Info") {
		msg.fromUsername = str("tag.QUERY");
		msg.message = str("help");
		// can't scroll in activitylog box if help message is too long.
		// splitting in single messages works, but looks bad because of too large gaps between the lines.
			//splitHelpMessagesAndSend(str("tag.QUERY"),str("help"));
			//return;
	}
	if (msg.fromUsername == "Public Chat") {
		msg.fromUsername = str("tag.PUBCHAT");
	}
	if (msg.fromUsername == "Private Chat") {
		msg.fromUsername = str("tag.PRIVCHAT");
	}	
	if (msg.fromUsername == "Filter") {
		prepareFilter(msg.message.split(","))
		applyFilter();
	}
	else {
		var cm:ActivitylogMessage = new ActivitylogMessage();	      
		cm.name = msg.fromUsername; //as tag
		cm.time = ActivitylogUtil.getHours(new Date()) + ":" + ActivitylogUtil.getMinutes(new Date());
		cm.senderText = "("+cm.time+") ["+cm.name+"] " + msg.message;
		cm.translatedText = cm.senderText;
		
		history.addItem([cm.name, cm]);
		if (filtertags.indexOf(cm.name) >= 0)
			messages.addItem(cm);
	}
	

    }

	private function splitHelpMessagesAndSend(tag:String,help:String):void{
		var lines:Array = help.split(" \n ");
		for (var i:int = 0; i < lines.length; i++){
			var cms:ActivitylogMessage = new ActivitylogMessage();	      
			cms.name = tag;
			cms.time = ActivitylogUtil.getHours(new Date()) + ":" + ActivitylogUtil.getMinutes(new Date());
			if (i == 0)
				cms.senderText = "("+cms.time+") ["+cms.name+"] " + lines[i];
			else
				cms.senderText = lines[i];
			cms.translatedText = cms.senderText;
		
			history.addItem([cms.name, cms]);
			if (filtertags.indexOf(cms.name) >= 0)
				messages.addItem(cms);
		}
	}

        private var fileRef:FileReference; 
	
	public function writeToLogFile(qryflag:Boolean):void{
		fileRef = new FileReference();
		fileRef.addEventListener(Event.SELECT, onSaveFileSelected);
		var saveinfo:String =  str("txt.save.info").split("<name>").join(conf().getMyName()).split("<time>").join(new Date().toString());
        	fileRef.save(saveinfo + "\n" + getHistoryAsString(qryflag), str("txt.save.filename"));
       }

	public function onSaveFileSelected(evt:Event):void 
        { 
            fileRef.addEventListener(ProgressEvent.PROGRESS, onSaveProgress); 
            fileRef.addEventListener(Event.COMPLETE, onSaveComplete); 
            fileRef.addEventListener(Event.CANCEL, onSaveCancel); 
        } 
 
        public function onSaveProgress(evt:ProgressEvent):void { } 
         
        public function onSaveComplete(evt:Event):void 
        { 
            fileRef.removeEventListener(Event.SELECT, onSaveFileSelected); 
            fileRef.removeEventListener(ProgressEvent.PROGRESS, onSaveProgress); 
            fileRef.removeEventListener(Event.COMPLETE, onSaveComplete); 
            fileRef.removeEventListener(Event.CANCEL, onSaveCancel); 
        } 
 
        public function onSaveCancel(evt:Event):void { } 




    public function getAllMessageAsString():String{
      var allText:String = "";
      for (var i:int = 0; i < messages.length; i++){
        var item:ActivitylogMessage = messages.getItemAt(i) as ActivitylogMessage;
        allText += "\n" + item.name + " - " + item.time + " : " + item.translatedText;
      }
      return allText;
    }

    public function getHistoryAsString(qryflag:Boolean):String{
      var allHistory:String = "";
      for (var i:int = 0; i < history.length; i++){
	if (!qryflag) {
		if (history.getItemAt(i)[0] != str("tag.QUERY")) {
		        var item:ActivitylogMessage = history.getItemAt(i)[1] as ActivitylogMessage;
			allHistory += item.translatedText + "\n";
		}
	}
	else {
		var item:ActivitylogMessage = history.getItemAt(i)[1] as ActivitylogMessage;
		allHistory += item.translatedText + "\n";
	}
      }
      return allHistory;
    }

    public function prepareFilter(choice:Array):void {
	if (choice[1] == "true")	
		if (filtertags.indexOf(choice[0]) == -1){	
			filtertags.push(choice[0]);//add tag
		}
	if (choice[1] == "false")
		if (filtertags.indexOf(choice[0]) >= 0){
			filtertags.splice(filtertags.indexOf(choice[0]),1);//rm tag
		}
    }

    public function prepareFilterCMD(tags:Array):void {
	// rm not supported filter tags	
	var newTags:Array = [];
	for (var j:int = 0; j < tags.length; j++){
		if (possibleTags.indexOf(tags[j]) >= 0)
			newTags.push(tags[j]);
	}
	if (newTags.length > 0)
		filtertags = newTags;

	for (var i:int = 0; i < possibleTags.length; i++){
		if (filtertags.indexOf(possibleTags[i]) >= 0)
			DataProvider.setTag(possibleTags[i], true);
		else
			DataProvider.setTag(possibleTags[i], false);
	}
    }

    public function prepareFilterCMDadd(tags:Array):void {
	for (var i:int = 0; i < tags.length; i++){
		if (possibleTags.indexOf(tags[i]) >= 0)
			if (filtertags.indexOf(tags[i]) == -1) {
				DataProvider.setTag(tags[i], true);
				filtertags.push(tags[i]);//add tag
			}
	}
    }

    public function prepareFilterCMDdel(tags:Array):void {
	for (var i:int = 0; i < tags.length; i++){
		if (possibleTags.indexOf(tags[i]) >= 0)
			if (filtertags.indexOf(tags[i]) >= 0) {
				DataProvider.setTag(tags[i], false);
				filtertags.splice(filtertags.indexOf(tags[i]),1);//rm tag
			}
	}
    }

    public function applyFilter():void {
	messages.removeAll();
	var tag:String
	var item:ActivitylogMessage;
	for (var i:int = 0; i < history.length; i++){
		tag = history.getItemAt(i)[0] as String;
		if (filtertags.indexOf(tag) >= 0) {
			item = history.getItemAt(i)[1] as ActivitylogMessage;
			messages.addItem(item);
		}
	}		
    }

    private function conf():Conference {
	return UserManager.getInstance().getConference();
    }

    private function handleCMDwhoispresenter():String {
	var presenter:BBBUser = conf().getPresenter();
	if (presenter != null)
		return str("txt.whoispresenter").split("<name>").join(presenter.name);
	else
		return null;
    }

    private function handleCMDwhoismoderator():String {
	var s:String = str("txt.whoismoderator");
	for (var i:int = 0; i < conf().users.length; i++) {				
		if (conf().users.getItemAt(i).role == Role.MODERATOR)
			if (i != conf().users.length-1)
				s = s + " " + conf().users.getItemAt(i).name + ",";
			else
				s = s + " " + conf().users.getItemAt(i).name;
	}
	return s;
    }

    private function handleCMDlistusers():String {
	var s:String = str("txt.listusers");
	for (var i:int = 0; i < conf().users.length; i++)
		if (i != conf().users.length-1)
			s = s + " " + conf().users.getItemAt(i).name + ",";
		else
			s = s + " " + conf().users.getItemAt(i).name;				
	return s;
    }

    private function handleCMDwhatsmyrole():String {
	return str("txt.whatsmyrole." + conf().whatsMyRole());
    }

    private function handleCMDamipresenter():String {
	return str("txt.amipresenter." + conf().amIPresenter);
    }

    private function handleCMDamimoderator():String {
	if (conf().whatsMyRole() == Role.MODERATOR)
		return str("txt.amimoderator.true");
	else
		return str("txt.amimoderator.false");
    }

    private function handleCMDamimuted():String {
	return str("txt.amimuted." + conf().isMyVoiceMuted());
    }

    private function handleCMDamivoicejoined():String {
	return str("txt.amivoicejoined." + conf().amIVoiceJoined());
    }

    private function handleCMDwhoami():String {
	return str("txt.whoami").split("<name>").join(conf().getMyName());
    }

    private function handleCMDmuteme():String {
	conf().muteMyVoice(true);
	return str("txt.muteme");
    }

    private function handleCMDunmuteme():String {
	conf().muteMyVoice(false);
	return str("txt.unmuteme");
    }

    private function handleCMDismyhandraised():String {
	return str("txt.ismyhandraised." + conf().isMyHandRaised);
    }

    private function handleCMDraisemyhand():String {
	conf().isMyHandRaised = true;
	return str("txt.raisemyhand");
    }

    private function handleCMDlowermyhand():String {
	conf().isMyHandRaised = false;
	return str("txt.lowermyhand");
    }

    private function handleCMDcurrentslide():String {
	var slidename:String = PresentationModel.getInstance().getCurrentPresentationName();
	var slidenum:String = PresentationModel.getInstance().getCurrentPage().num.toString();
	var slidepages:String = PresentationModel.getInstance().getNumberOfPages().toString();
	return str("txt.currentslide").split("<slidename>").join(slidename).split("<slidenum>").join(slidenum).split("<slidepages>").join(slidepages);
    }

  }
}
