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
package org.bigbluebutton.modules.chat.services
{
  import flash.events.IEventDispatcher;
  
  import org.bigbluebutton.common.LogUtil;
  import org.bigbluebutton.core.BBB;
  import org.bigbluebutton.core.EventConstants;
  import org.bigbluebutton.core.events.CoreEvent;
  import org.bigbluebutton.main.model.users.IMessageListener;
  import org.bigbluebutton.modules.chat.ChatConstants;
    import org.bigbluebutton.modules.activitylog.ActivitylogConstants;
  import org.bigbluebutton.modules.chat.events.PrivateChatMessageEvent;
  import org.bigbluebutton.modules.chat.events.PublicChatMessageEvent;
    import org.bigbluebutton.modules.activitylog.events.PublicActivitylogMessageEvent;
  import org.bigbluebutton.modules.chat.events.TranscriptEvent;
  import org.bigbluebutton.modules.chat.vo.ChatMessageVO;
    import org.bigbluebutton.modules.activitylog.vo.ActivitylogMessageVO;

  import flash.external.ExternalInterface;
  
  public class MessageReceiver implements IMessageListener
  {
    
    private static const LOG:String = "Chat::MessageReceiver - ";
    
    public var dispatcher:IEventDispatcher;
    
    private var alogOn:Boolean = true;
    
    public function MessageReceiver()
    {
      BBB.initConnectionManager().addMessageListener(this);
    }
    
    public function onMessage(messageName:String, message:Object):void
    {
      switch (messageName) {
        case "ChatReceivePublicMessageCommand":
          handleChatReceivePublicMessageCommand(messageName,message);
          break;			
        case "ChatReceivePrivateMessageCommand":
          handleChatReceivePrivateMessageCommand(messageName,message);
          break;	
        case "ChatRequestMessageHistoryReply":
          handleChatRequestMessageHistoryReply(messageName,message);
          break;	
        default:
          //   LogUtil.warn("Cannot handle message [" + messageName + "]");
      }
    }
    
    private function handleChatRequestMessageHistoryReply(messageName:String, message:Object):void {
      trace(LOG + "Handling chat history message [" + message.msg + "]");
      var chats:Array = JSON.parse(message.msg) as Array;
      alogOn = false; // unset flag to pass this chat events in the activitylog
      for (var i:int = 0; i < chats.length; i++) {
        handleChatReceivePublicMessageCommand(messageName, chats[i]);
      }
      alogOn = true; // set flag back
      var pcEvent:TranscriptEvent = new TranscriptEvent(TranscriptEvent.TRANSCRIPT_EVENT);
      dispatcher.dispatchEvent(pcEvent);
    }
        
    private function handleChatReceivePublicMessageCommand(messageName:String, message:Object):void {
      trace(LOG + "Handling public chat message [" + message.message + "]");
      
      var msg:ChatMessageVO = new ChatMessageVO();
      msg.chatType = message.chatType;
      msg.fromUserID = message.fromUserID;
      msg.fromUsername = message.fromUsername;
      msg.fromColor = message.fromColor;
      msg.fromLang = message.fromLang;
      msg.fromTime = message.fromTime;
      msg.fromTimezoneOffset = message.fromTimezoneOffset;
      msg.toUserID = message.toUserID;
      msg.toUsername = message.toUsername;
      msg.message = message.message;
      
      var pcEvent:PublicChatMessageEvent = new PublicChatMessageEvent(PublicChatMessageEvent.PUBLIC_CHAT_MESSAGE_EVENT);
      pcEvent.message = msg;
      dispatcher.dispatchEvent(pcEvent);
      
      var pcCoreEvent:CoreEvent = new CoreEvent(EventConstants.NEW_PUBLIC_CHAT);
      pcCoreEvent.message = message;
      dispatcher.dispatchEvent(pcCoreEvent);

      // dispatch activitylog event only if flag is set
      if (alogOn) {
      
	var msg2:ActivitylogMessageVO = new ActivitylogMessageVO();
        msg2.activitylogType = ActivitylogConstants.PUBLIC_ACTIVITYLOG;
        msg2.fromUserID = " ";
        msg2.fromUsername = "Public Chat";
        msg2.fromColor = "86187";
        msg2.fromLang = "en";
        msg2.fromTime = new Date().getTime();
        msg2.fromTimezoneOffset = new Date().getTimezoneOffset();
        msg2.toUserID = " ";
        msg2.toUsername = " ";
	msg2.message = message.fromUsername + ": " + message.message; 
        var pcEventc:PublicActivitylogMessageEvent = new PublicActivitylogMessageEvent(PublicActivitylogMessageEvent.PUBLIC_ACTIVITYLOG_MESSAGE_EVENT);
        pcEventc.message = msg2;
        dispatcher.dispatchEvent(pcEventc);

      }
    }
    
    private function handleChatReceivePrivateMessageCommand(messageName:String, message:Object):void {
      trace(LOG + "Handling private chat message");
      
      var msg:ChatMessageVO = new ChatMessageVO();
      msg.chatType = message.chatType;
      msg.fromUserID = message.fromUserID;
      msg.fromUsername = message.fromUsername;
      msg.fromColor = message.fromColor;
      msg.fromLang = message.fromLang;
      msg.fromTime = message.fromTime;
      msg.fromTimezoneOffset = message.fromTimezoneOffset;
      msg.toUserID = message.toUserID;
      msg.toUsername = message.toUsername;
      msg.message = message.message;
      
      var pcEvent:PrivateChatMessageEvent = new PrivateChatMessageEvent(PrivateChatMessageEvent.PRIVATE_CHAT_MESSAGE_EVENT);
      pcEvent.message = msg;
      dispatcher.dispatchEvent(pcEvent);
      
      var pcCoreEvent:CoreEvent = new CoreEvent(EventConstants.NEW_PRIVATE_CHAT);
      pcCoreEvent.message = message;
      dispatcher.dispatchEvent(pcCoreEvent);  

      // dispatch activitylog event only if flag is set
      if (alogOn) {
      
	var msg3:ActivitylogMessageVO = new ActivitylogMessageVO();
        msg3.activitylogType = ActivitylogConstants.PUBLIC_ACTIVITYLOG;
        msg3.fromUserID = " ";
        msg3.fromUsername = "Private Chat";
        msg3.fromColor = "86187";
        msg3.fromLang = "en";
        msg3.fromTime = new Date().getTime();
        msg3.fromTimezoneOffset = new Date().getTimezoneOffset();
        msg3.toUserID = " ";
        msg3.toUsername = " ";
	msg3.message = message.fromUsername + ": " + message.message; 
        var pcEventc:PublicActivitylogMessageEvent = new PublicActivitylogMessageEvent(PublicActivitylogMessageEvent.PUBLIC_ACTIVITYLOG_MESSAGE_EVENT);
        pcEventc.message = msg3;
        dispatcher.dispatchEvent(pcEventc);    
        
      }
    }
  }
}
