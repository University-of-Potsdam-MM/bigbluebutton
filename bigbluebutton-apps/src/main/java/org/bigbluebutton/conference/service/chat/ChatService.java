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
package org.bigbluebutton.conference.service.chat;

import java.util.HashMap;
import java.util.Map;
import java.io.*;
import java.util.ArrayList;
import com.google.gson.Gson;
import org.slf4j.Logger;
import org.bigbluebutton.conference.BigBlueButtonSession;
import org.bigbluebutton.conference.Constants;
import org.red5.logging.Red5LoggerFactory;
import org.red5.server.api.Red5;

public class ChatService {	
	private static Logger log = Red5LoggerFactory.getLogger( ChatService.class, "bigbluebutton" );
	
	private ChatApplication application;

	public void sendPublicChatHistory() {
		String meetingID = Red5.getConnectionLocal().getScope().getName();
		String requesterID = getBbbSession().getInternalUserID();
		application.sendPublicChatHistory(meetingID, requesterID);
	}

	public void sendAlog(Map<String, Object> msg) {
		String myMsg = msg.get("msg").toString();
		String myTag = msg.get("tag").toString();  
		String meetingID = Red5.getConnectionLocal().getScope().getName();
		String requesterID = getBbbSession().getInternalUserID();
		writeText(meetingID, myTag + " -/- " + myMsg);
		application.sendAlog(meetingID, requesterID);
	}

	public void sendAlogHistory(String msg) {
		String meetingID = Red5.getConnectionLocal().getScope().getName();
		String requesterID = getBbbSession().getInternalUserID();
		String answer = readPublicAlogFile(meetingID);
		application.sendAlogHistory(meetingID, requesterID, answer);
	}

	public void sendAlogSlide(String msg) {
		String meetingID = Red5.getConnectionLocal().getScope().getName();
		String requesterID = getBbbSession().getInternalUserID();
		String slidecontent = readSlideFile(meetingID, msg);
		application.sendAlogSlide(meetingID, requesterID, slidecontent);
	}
	
	public void writeText(String meetingID, String text){
          FileWriter fw = null;
          try {
            File f = new File("/tmp/bbb/"+meetingID);
	    f.getParentFile().mkdirs();
            fw = new FileWriter(f, true);
            fw.write(text);
            fw.write("\n");
            
          }
          catch (IOException e) {
            System.err.println("Failed to write alog file");
          } 
          finally {
            if(fw != null)
                try {
                    fw.close();
                } 
                catch (IOException e) {
		  System.err.println("Failed to close alog file");
                }
	  }
	}

    
	public String readPublicAlogFile(String meetingID){
		String line = null;
		ArrayList<Map<String, String>> list = new ArrayList<Map<String, String>>();
		Map<String, String> map = new HashMap<String, String>();
		String[] parts = null;
		 
		try{
			File f = new File("/tmp/bbb/"+meetingID);
			if(f.exists() && !f.isDirectory()) {
				BufferedReader br = new BufferedReader(new FileReader("/tmp/bbb/"+meetingID));
				while ((line = br.readLine()) != null) {
					//System.out.println(thisLine);
					parts = line.split(" -/- ");
					map = new HashMap<String, String>();
					map.put("tag", parts[0]);
					map.put("msg", parts[1]);
					list.add(map);
				}
				br = null;
			} 
		} catch(Exception e){
			e.printStackTrace();
		}
		Gson gson = new Gson();
		return gson.toJson(list);
	}

	public String readSlideFile(String meetingID, String pageAndDoc){
		String line = null;
		String result = "";
		String[] parts = pageAndDoc.split(" -/- ");
		String path = "/var/bigbluebutton/" + meetingID + "/" + meetingID + "/" + parts[1] + "/textfiles/slide-" + parts[0] + ".txt";
		 
		try{
			File f = new File(path);
			if(f.exists() && !f.isDirectory()) {
				BufferedReader br = new BufferedReader(new FileReader(path));
				while ((line = br.readLine()) != null) {
					result = result + line + "\n";
				}
				br = null;
			} 
		} catch(Exception e){
			e.printStackTrace();
		}
		return result;
	}

	private BigBlueButtonSession getBbbSession() {
		return (BigBlueButtonSession) Red5.getConnectionLocal().getAttribute(Constants.SESSION);
	}
	
	public void sendPublicMessage(Map<String, Object> msg) {
		String chatType = msg.get(ChatKeyUtil.CHAT_TYPE).toString(); 
		String fromUserID = msg.get(ChatKeyUtil.FROM_USERID).toString();
		String fromUsername = msg.get(ChatKeyUtil.FROM_USERNAME ).toString();
		String fromColor = msg.get(ChatKeyUtil.FROM_COLOR).toString();
		String fromTime = msg.get(ChatKeyUtil.FROM_TIME).toString();   
		String fromTimezoneOffset = msg.get(ChatKeyUtil.FROM_TZ_OFFSET).toString();
		String fromLang = msg.get(ChatKeyUtil.FROM_LANG).toString(); 	 
		String toUserID = msg.get(ChatKeyUtil.TO_USERID).toString();
		String toUsername = msg.get(ChatKeyUtil.TO_USERNAME).toString();
		String chatText = msg.get(ChatKeyUtil.MESSAGE).toString();
		
		Map<String, String> message = new HashMap<String, String>();
		message.put(ChatKeyUtil.CHAT_TYPE, chatType); 
		message.put(ChatKeyUtil.FROM_USERID, fromUserID);
		message.put(ChatKeyUtil.FROM_USERNAME, fromUsername);
		message.put(ChatKeyUtil.FROM_COLOR, fromColor);
		message.put(ChatKeyUtil.FROM_TIME, fromTime);   
		message.put(ChatKeyUtil.FROM_TZ_OFFSET, fromTimezoneOffset);
		message.put(ChatKeyUtil.FROM_LANG, fromLang);
		message.put(ChatKeyUtil.TO_USERID, toUserID);
		message.put(ChatKeyUtil.TO_USERNAME, toUsername);
		message.put(ChatKeyUtil.MESSAGE, chatText);
	
		String meetingID = Red5.getConnectionLocal().getScope().getName();
		String requesterID = getBbbSession().getInternalUserID();
		
		application.sendPublicMessage(meetingID, requesterID, message);
	}
	
	public void setChatApplication(ChatApplication a) {
		application = a;
	}

	public void sendPrivateMessage(Map<String, Object> msg){
		String chatType = msg.get(ChatKeyUtil.CHAT_TYPE).toString(); 
		String fromUserID = msg.get(ChatKeyUtil.FROM_USERID).toString();
		String fromUsername = msg.get(ChatKeyUtil.FROM_USERNAME ).toString();
		String fromColor = msg.get(ChatKeyUtil.FROM_COLOR).toString();
		String fromTime = msg.get(ChatKeyUtil.FROM_TIME).toString();   
		String fromTimezoneOffset = msg.get(ChatKeyUtil.FROM_TZ_OFFSET).toString();
		String fromLang = msg.get(ChatKeyUtil.FROM_LANG).toString(); 	 
		String toUserID = msg.get(ChatKeyUtil.TO_USERID).toString();
		String toUsername = msg.get(ChatKeyUtil.TO_USERNAME).toString();
		String chatText = msg.get(ChatKeyUtil.MESSAGE).toString();
		
		Map<String, String> message = new HashMap<String, String>();
		message.put(ChatKeyUtil.CHAT_TYPE, chatType); 
		message.put(ChatKeyUtil.FROM_USERID, fromUserID);
		message.put(ChatKeyUtil.FROM_USERNAME, fromUsername);
		message.put(ChatKeyUtil.FROM_COLOR, fromColor);
		message.put(ChatKeyUtil.FROM_TIME, fromTime);   
		message.put(ChatKeyUtil.FROM_TZ_OFFSET, fromTimezoneOffset);
		message.put(ChatKeyUtil.FROM_LANG, fromLang);
		message.put(ChatKeyUtil.TO_USERID, toUserID);
		message.put(ChatKeyUtil.TO_USERNAME, toUsername);
		message.put(ChatKeyUtil.MESSAGE, chatText);
	
		String meetingID = Red5.getConnectionLocal().getScope().getName();
		String requesterID = getBbbSession().getInternalUserID();
		
		application.sendPrivateMessage(meetingID, requesterID, message);

	}
}
