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
package org.bigbluebutton.modules.activitylog.maps {
	import com.asfusion.mate.events.Dispatcher;
	import flash.events.IEventDispatcher;	
	import org.bigbluebutton.common.LogUtil;
	import org.bigbluebutton.common.events.CloseWindowEvent;
	import org.bigbluebutton.common.events.OpenWindowEvent;
	import org.bigbluebutton.core.BBB;
	import org.bigbluebutton.modules.activitylog.events.ActivitylogOptionsEvent;
	import org.bigbluebutton.modules.activitylog.events.StartActivitylogModuleEvent;
	import org.bigbluebutton.modules.activitylog.model.ActivitylogOptions;
	import org.bigbluebutton.modules.activitylog.views.ActivitylogWindow;
	import org.bigbluebutton.util.i18n.ResourceUtil;
	
	public class ActivitylogEventMapDelegate {
		private var dispatcher:IEventDispatcher;

		private var _activitylogWindow:ActivitylogWindow;
		private var _activitylogWindowOpen:Boolean = false;
		private var globalDispatcher:Dispatcher;
		
		private var translationEnabled:Boolean;
		private var translationOn:Boolean;
		private var activitylogOptions:ActivitylogOptions;
				
		public function ActivitylogEventMapDelegate() {
			this.dispatcher = dispatcher;
			_activitylogWindow = new ActivitylogWindow();
			globalDispatcher = new Dispatcher();
      openActivitylogWindow();
		}

		private function getActivitylogOptions():void {
			activitylogOptions = new ActivitylogOptions();
		}
		
		public function openActivitylogWindow():void {	
			getActivitylogOptions();
			_activitylogWindow.activitylogOptions = activitylogOptions;
		   	_activitylogWindow.title = ResourceUtil.getInstance().getString("bbb.activitylog.title");
		   	_activitylogWindow.showCloseButton = false;
		   	
		   	// Use the GLobal Dispatcher so that this message will be heard by the
		   	// main application.		   	
			var event:OpenWindowEvent = new OpenWindowEvent(OpenWindowEvent.OPEN_WINDOW_EVENT);
			event.window = _activitylogWindow; 
			globalDispatcher.dispatchEvent(event);		   	
		   	_activitylogWindowOpen = true;			
			dispatchTranslationOptions();			
		}
		
		public function closeActivitylogWindow():void {
			var event:CloseWindowEvent = new CloseWindowEvent(CloseWindowEvent.CLOSE_WINDOW_EVENT);
			event.window = _activitylogWindow;
			globalDispatcher.dispatchEvent(event);
		   	
		   	_activitylogWindowOpen = false;
		}
		
		public function setTranslationOptions(e:StartActivitylogModuleEvent):void{
			translationEnabled = e.translationEnabled;
			translationOn = e.translationOn;
		}
		
		private function dispatchTranslationOptions():void{
			var enableEvent:ActivitylogOptionsEvent = new ActivitylogOptionsEvent(ActivitylogOptionsEvent.TRANSLATION_OPTION_ENABLED);
			enableEvent.translationEnabled = translationEnabled;
			enableEvent.translateOn = translationOn;
			globalDispatcher.dispatchEvent(enableEvent);
		}
	}
}
