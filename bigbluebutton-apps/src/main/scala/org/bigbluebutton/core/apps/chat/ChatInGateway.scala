package org.bigbluebutton.core.apps.chat

import org.bigbluebutton.core.BigBlueButtonGateway
import org.bigbluebutton.core.api._

class ChatInGateway(bbbGW: BigBlueButtonGateway) {

  def getChatHistory(meetingID: String, requesterID: String, replyTo: String) {
    bbbGW.accept(new GetChatHistoryRequest(meetingID, requesterID, replyTo))
  }

  def getAlog(meetingID: String, requesterID: String, replyTo: String) {
    bbbGW.accept(new AlogRequest(meetingID, requesterID, replyTo))
  }

  def getAlogHistory(meetingID: String, requesterID: String, replyTo: String, answer: String) {
    bbbGW.accept(new AlogHistoryRequest(meetingID, requesterID, replyTo, answer))
  }

  def getAlogSlide(meetingID: String, requesterID: String, replyTo: String, answer: String) {
    bbbGW.accept(new AlogSlideRequest(meetingID, requesterID, replyTo, answer))
  }
  
  def sendPrivateMessage(meetingID: String, requesterID: String, msg: Map[String, String]) {
    bbbGW.accept(new SendPrivateMessageRequest(meetingID, requesterID, msg))
  }
  
  def sendPublicMessage(meetingID: String, requesterID: String, msg: Map[String, String]) {
    bbbGW.accept(new SendPublicMessageRequest(meetingID, requesterID, msg))
  }
}
