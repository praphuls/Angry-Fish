package com.controller.commands
{
	import com.config.ServiceConfig;
	import com.events.ApplicationEvent;
	import com.model.AppModel;
	import com.serviceLocator.AppServiceLocator;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GetIsHelpCommmand extends MovieClip implements ICommand
	{
		private var model:AppModel = AppModel.getInstance();
		private var callBackObj:MovieClip;
		
		public function GetIsHelpCommmand(obj:MovieClip):void
		{
			callBackObj = obj;
		}
		
		public function execute():void
		{
			var service:AppServiceLocator = new AppServiceLocator(this, ServiceConfig.SHOW_HELP);
		}
		
		public function callBackCommand(obj:Object):void
		{
			//ExternalInterface.call('alert', Boolean(obj));	
			model.isShowHelp = Boolean(obj);

			callBackObj.notifyUpdate(new ApplicationEvent(ApplicationEvent.IS_HELP_DATA_EVENT));
		}
	}
	
}