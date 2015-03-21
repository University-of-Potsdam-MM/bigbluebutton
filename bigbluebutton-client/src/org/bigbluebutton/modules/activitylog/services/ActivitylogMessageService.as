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
//  import flash.events.IEventDispatcher;
//  import flash.external.ExternalInterface;
//  import org.bigbluebutton.common.LogUtil;
//  import org.bigbluebutton.core.BBB;
//  import org.bigbluebutton.core.UsersUtil;
//  import org.bigbluebutton.core.model.MeetingModel;
//  import org.bigbluebutton.modules.activitylog.ActivitylogConstants;
//  import org.bigbluebutton.modules.activitylog.events.PublicActivitylogMessageEvent;
  import org.bigbluebutton.modules.activitylog.vo.ActivitylogMessageVO;

  public class ActivitylogMessageService
  {
//    private static const LOG:String = "Activitylog::ActivitylogMessageService - ";
    
    public var sender:MessageSender;
//    public var receiver:MessageReceiver;
//    public var dispatcher:IEventDispatcher;
    
//    public function sendPublicMessageFromApi(message:Object):void
//    {
//      trace(LOG + "sendPublicMessageFromApi");
//      var msgVO:ActivitylogMessageVO = new ActivitylogMessageVO();
//      msgVO.activitylogType = ActivitylogConstants.PUBLIC_ACTIVITYLOG;
//      msgVO.fromUserID = message.fromUserID;
//      msgVO.fromUsername = message.fromUsername;
//      msgVO.fromColor = message.fromColor;
//      msgVO.fromLang = message.fromLang;
//      msgVO.fromTime = message.fromTime;
//      msgVO.fromTimezoneOffset = message.fromTimezoneOffset;

//      msgVO.message = message.message;
//      
//      sendPublicMessage(msgVO);
//    }    
    
//    public function sendPrivateMessageFromApi(message:Object):void
//    {
//      trace(LOG + "sendPrivateMessageFromApi");
//      var msgVO:ActivitylogMessageVO = new ActivitylogMessageVO();
//      msgVO.activitylogType = ActivitylogConstants.PUBLIC_ACTIVITYLOG;
//      msgVO.fromUserID = message.fromUserID;
//      msgVO.fromUsername = message.fromUsername;
//      msgVO.fromColor = message.fromColor;
//      msgVO.fromLang = message.fromLang;
//      msgVO.fromTime = message.fromTime;
//      msgVO.fromTimezoneOffset = message.fromTimezoneOffset;
//      
//      msgVO.toUserID = message.toUserID;
//      msgVO.toUsername = message.toUsername;
//      
//      msgVO.message = message.message;
//      
//      sendPrivateMessage(msgVO);

//    }
    
    public function sendPublicMessage(message:ActivitylogMessageVO):void {
      sender.sendPublicMessage(message);
    }
    
//    public function sendPrivateMessage(message:ActivitylogMessageVO):void {
//      sender.sendPrivateMessage(message);
//    }
    
//    public function getPublicActivitylogMessages():void {
//      sender.getPublicActivitylogMessages();
//    }
    
//    private static const SPACE:String = " ";
//    
//    public function sendWelcomeMessage():void {}
  }
}
