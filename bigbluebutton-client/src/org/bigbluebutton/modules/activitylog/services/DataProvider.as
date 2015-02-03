package org.bigbluebutton.modules.activitylog.services
{   

import org.bigbluebutton.util.i18n.ResourceUtil;

public class DataProvider
{

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


    public static function setSaveWithQueries(val:Boolean):void {
	cbSaveWithQueries = val;
    }

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

    private static function str(s:String):String {
	return ResourceUtil.getInstance().getString("bbb.activitylog.ActivitylogConversation."+s);
    }


}
}
