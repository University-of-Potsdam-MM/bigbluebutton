package org.bigbluebutton.modules.activitylog.services
{   

import org.bigbluebutton.util.i18n.ResourceUtil;

public class DataProvider
{

    // static information for global access

    // filtertags checkbox values 
    [Bindable]
    public static var cbUser:Boolean = true;

    [Bindable]
    public static var cbBoard:Boolean = true;

    [Bindable]
    public static var cbQuery:Boolean = true;

    [Bindable]
    public static var cbMeeting:Boolean = true;

    [Bindable]
    public static var cbPubChat:Boolean = true;

    [Bindable]
    public static var cbPrivChat:Boolean = true;

    [Bindable]
    public static var cbSaveWithQueries:Boolean = true;

    // save with queries checkbox value 
    public static function setSaveWithQueries(val:Boolean):void {
	cbSaveWithQueries = val;
    }

    // set new bool values to checkboxes on changed checked state
    public static function setTag(tag:String, val:Boolean):void {
	switch (tag) {			
		case str("tag.USER"):
			cbUser = val;
			break;
		case str("tag.BOARD"):
			cbBoard = val;
			break;
		case str("tag.QUERY"):
			cbQuery = val;
			break;
		case str("tag.MEETING"):
			cbMeeting = val;
			break;
		case str("tag.PUBCHAT"):
			cbPubChat = val;
			break;
		case str("tag.PRIVCHAT"):
			cbPrivChat = val;
			break;
		default:
	}
    }

    // help function to get shorter strings from locales
    private static function str(s:String):String {
	return ResourceUtil.getInstance().getString("bbb.activitylog.ActivitylogConversation."+s);
    }

    // object and strings which are sended from messageservice to server 
    public static var logToServer:Object = new Object(); //.tag and .msg properties available
    public static var cur_doc:String = "";
    public static var cur_page:String = "";

}
}
