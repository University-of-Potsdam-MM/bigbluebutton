package org.bigbluebutton.modules.activitylog.model
{
  
  import com.asfusion.mate.events.Dispatcher;
  
  import org.bigbluebutton.modules.activitylog.events.ConversationDeletedEvent;
  import org.bigbluebutton.modules.activitylog.vo.ActivitylogMessageVO;

  public class ActivitylogConverstations
  {
    private var convs:Object = new Object();
    
    private var dispatcher:Dispatcher = new Dispatcher();
    
    public function getConvId(from:String, to: String):String {
      if (from < to) {
        return from + "-" to;
      }
      return to + "-" from;
    }
    
    public function newActivitylogMessage(msg:ActivitylogMessageVO):void {
      var convId:String = getConvId(msg.fromUserID, msg.toUserID);
      
      if (convs.hasOwnProperty(convId)) {
        var cm:ActivitylogConversation = convs[convId] as ActivitylogConversation;
        cm.newActivitylogMessage(msg);
      } else {
        var cm:ActivitylogConversation = new ActivitylogConversation();
        cm.newActivitylogMessage(msg);
        convs[convId] = cm;
      }
    }
    
    public function userLeft(userid:String):void {
      for (var convId:String in convs){
        if (convId.indexOf(userid) > 0) {
          delete convs[convId];
          dispatcher.dispatchEvent(new ConversationDeletedEvent(convId));
        }
      }
    }
    
    public function getActivitylogConversation(convId:String):ActivitylogConversation {
      if (convs.hasOwnProperty(convId)) {
        return convs[convId];
      }
      return new ActivitylogConversation();
    }
  }
}
