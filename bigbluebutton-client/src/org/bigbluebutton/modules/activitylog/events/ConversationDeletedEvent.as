package org.bigbluebutton.modules.activitylog.events
{
  import flash.events.Event;
  
  public class ConversationDeletedEvent extends Event
  {
    public static const CONVERSTATION_DELETED:String = "activitylog conversation deleted event";
    
    public var convId:String;
    
    public function ConversationDeletedEvent(conversationId:String)
    {
      super(CONVERSTATION_DELETED, true, false);
      convId = conversationId;
    }
  }
}