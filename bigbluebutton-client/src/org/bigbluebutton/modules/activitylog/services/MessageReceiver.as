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
package org.bigbluebutton.modules.activitylog.services
{
  import flash.events.IEventDispatcher;
  import org.bigbluebutton.util.i18n.ResourceUtil;
  import org.bigbluebutton.core.BBB;
  import org.bigbluebutton.core.EventConstants;
  import org.bigbluebutton.core.events.CoreEvent;
  import org.bigbluebutton.core.managers.UserManager;
  import org.bigbluebutton.main.model.users.IMessageListener;
  import org.bigbluebutton.main.model.users.BBBUser;
  import org.bigbluebutton.modules.activitylog.ActivitylogConstants;
  import org.bigbluebutton.modules.activitylog.events.PrivateActivitylogMessageEvent;
  import org.bigbluebutton.modules.activitylog.events.PublicActivitylogMessageEvent;
  import org.bigbluebutton.modules.activitylog.events.TranscriptEvent;
  import org.bigbluebutton.modules.activitylog.vo.ActivitylogMessageVO;
  
  public class MessageReceiver implements IMessageListener
  {
    
    public var dispatcher:IEventDispatcher;
    
    public function MessageReceiver() {
      BBB.initConnectionManager().addMessageListener(this);
    }
    
    private function str(s:String):String {
	return ResourceUtil.getInstance().getString("bbb.activitylog.MessageReceiver."+s);
    }

    public function onMessage(messageName:String, message:Object):void
    {
	var result:String;
	var tag:String;
	switch (messageName) {
		case "assignPresenterCallback":
			tag = str("tag.USER");
			result = handleassignPresenterCallback(JSON.parse(message.msg));
			break;
//		case "ChatReceivePrivateMessageCommand":
//			tag = null
//			result = null; //ignore, chat handled other way
//			break;
//		case "ChatReceivePublicMessageCommand":
//			tag = null
//			result = null; //ignore, chat handled other way
//			break;
		case "goToSlideCallback":
			tag = str("tag.BOARD");
			result = handlegoToSlideCallback(JSON.parse(message.msg));
			break;
		case "meetingMuted":
			tag = str("tag.MEETING");
			result = handlemeetingMuted(JSON.parse(message.msg));
			break;
		case "moveCallback":
			tag = null;
			result = null; //ignore
			break;
		case "participantJoined":
			tag = str("tag.USER");
			result = handleparticipantJoined(JSON.parse(message.msg));
			break;	
		case "participantLeft":
			tag = str("tag.USER");
			result = handleparticipantLeft(JSON.parse(message.msg));
			break;	
		case "PresentationCursorUpdateCommand":
			tag = null;
			result = null; //ignore
			break;
		case "sharePresentationCallback":
			tag = str("tag.BOARD");
			result = handlesharePresentationCallback(JSON.parse(message.msg));
			break;
		case "userLoweredHand":
			tag = str("tag.USER");
			result = handleUserLoweredHand(JSON.parse(message.msg));
			break;
		case "userRaisedHand":
			tag = str("tag.USER");
			result = handleUserRaisedHand(JSON.parse(message.msg));
			break;
		case "WhiteboardClearCommand":
			tag = str("tag.BOARD");
			result = handleWhiteboardClearCommand(JSON.parse(message.msg));
			break;
		case "WhiteboardNewAnnotationCommand":
			tag = str("tag.BOARD");
			result = handleWhiteboardNewAnnotationCommand(JSON.parse(message.msg));
			break;
		case "WhiteboardUndoCommand":
			tag = str("tag.BOARD");
			result = handleWhiteboardUndoCommand(JSON.parse(message.msg));
			break;
		default:
			tag = str("tag.BOARD");
			result = null;//messageName + ": " + message.msg; //null; //ignore others
	}
	if (result != null) {
		handleEvent(messageName, tag, result);
	}
    }

    private function handleEvent(messageName:String, tag:String, result:String): void {
        var msg:ActivitylogMessageVO = new ActivitylogMessageVO();
        msg.activitylogType = ActivitylogConstants.PUBLIC_ACTIVITYLOG;
        msg.fromUsername = tag;//name as tag
        msg.fromTime = new Date().getTime();
	msg.message = result;
        var e:PublicActivitylogMessageEvent = new PublicActivitylogMessageEvent(PublicActivitylogMessageEvent.PUBLIC_ACTIVITYLOG_MESSAGE_EVENT);
        e.message = msg;
        dispatcher.dispatchEvent(e);
    }

    private function handleUserRaisedHand(map:Object): String {    
	var user:BBBUser = new BBBUser();
	user = UserManager.getInstance().getConference().getUser(map.userId);
	return str("msg.userRaisedHand").split("<user>").join(user.name);	
	//return str("msg.userRaisedHand").split("<user>").join(user.name).split("<which>").join("left");
    }

    private function handleUserLoweredHand(map:Object): String {    
	var lowereduser:BBBUser = new BBBUser();
	var byuser:BBBUser = new BBBUser();
	lowereduser = UserManager.getInstance().getConference().getUser(map.userId);
	byuser = UserManager.getInstance().getConference().getUser(map.loweredBy);
	if (lowereduser.name == byuser.name)
		return str("msg.userLoweredHand.self").split("<user>").join(lowereduser.name);
	else
		//this is not yet supported by bbb-dev team, but we are ready when it comes
		return str("msg.userLoweredHand.byuser").split("<lowereduser>").join(lowereduser.name).split("<byuser>").join(byuser.name);
    }

    private function handleWhiteboardNewAnnotationCommand(map:Object): String {
	if (map.shape.status == "DRAW_END") {
		return str("msg.WhiteboardNewAnnotationCommand.draw").split("<shape>").join(str("msg.WhiteboardNewAnnotationCommand.draw."+map.shape.type)).split("<color>").join(str("msg.WhiteboardNewAnnotationCommand.color."+map.shape.shape.color));
	}
	if (map.shape.status == "textPublished") {
		return str("msg.WhiteboardNewAnnotationCommand.text").split("<text>").join(map.shape.shape.text).split("<fontsize>").join(map.shape.shape.fontSize).split("<fontcolor>").join(str("msg.WhiteboardNewAnnotationCommand.color."+map.shape.shape.fontColor));
	}
	return null;
    }

    private function handleWhiteboardUndoCommand(map:Object): String {
	return str("msg.WhiteboardUndoCommand");
    }

    private function handleWhiteboardClearCommand(map:Object): String {
	return str("msg.WhiteboardClearCommand");
    }

    private function handlegoToSlideCallback(map:Object): String {
	return str("msg.goToSlideCallback").split("<slidenumber>").join(map.num);
    }

    private function handlesharePresentationCallback(map:Object): String {
	return str("msg.sharePresentationCallback").split("<name>").join(map.presentation.name).split("<slidecount>").join(map.presentation.pages.length);
    }

    private function handlemeetingMuted(map:Object): String {
	return str("msg.meetingMuted."+map.meetingMuted);
    }

    private function handleassignPresenterCallback(map:Object): String {
	return str("msg.assignPresenterCallback").split("<name>").join(map.newPresenterName);
    }

    private function handleparticipantLeft(map:Object): String {
	return str("msg.participantLeft").split("<name>").join(map.user.name);
    }

    private function handleparticipantJoined(map:Object): String {
	var out:String = str("msg.participantJoined").split("<name>").join(map.user.name);	
	if (map.user.phoneUser == true)
		out = out + " " + str("msg.participantJoined.phoneUser.true");
	else
		out = out + " " + str("msg.participantJoined.phoneUser.false");
	if (map.user.role == "MODERATOR")
		out = out + " " + str("msg.participantJoined.moderator.true");
	else
		out = out + " " + str("msg.participantJoined.moderator.false");
	if (map.user.presenter == true)
		out = out + " " + str("msg.participantJoined.presenter.true");
	else
		out = out + " " + str("msg.participantJoined.presenter.false");
	if (map.user.hasStream == true)
		out = out + " " + str("msg.participantJoined.hasStream.true").split("<name>").join(map.user.name);
	else
		out = out + " " + str("msg.participantJoined.hasStream.false").split("<name>").join(map.user.name);
	if (map.user.voiceUser.talking == true)
		out = out + " " + str("msg.participantJoined.talking.true");
	else
		out = out + " " + str("msg.participantJoined.talking.false");

	if (map.user.permissions.disablePubChat == true)
		out = out + " " + str("msg.participantJoined.permissions.pubChat.false");
	else
		out = out + " " + str("msg.participantJoined.permissions.pubChat.true");
	if (map.user.permissions.disablePrivChat == true)
		out = out + ", " + str("msg.participantJoined.permissions.privChat.false");
	else
		out = out + ", " + str("msg.participantJoined.permissions.privChat.true");
	if (map.user.voiceUser.talking == true)	
		if (map.user.permissions.disableMic == true)
			out = out + ", " + str("msg.participantJoined.permissions.mic.false");
		else
			out = out + ", " + str("msg.participantJoined.permissions.mic.true");
	if (map.user.hasStream == true)	
		if (map.user.permissions.disableCam == true)
			out = out + ", " + str("msg.participantJoined.permissions.cam.false");
		else
			out = out + ", " + str("msg.participantJoined.permissions.cam.true");
	else
		out = out + ".";

	return out;
    }
  }
}
