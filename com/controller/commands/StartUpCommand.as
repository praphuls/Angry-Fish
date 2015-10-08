package com.controller.commands
{
	import com.config.ServiceConfig;
	import com.events.ApplicationEvent;
	import com.model.AppModel;
	import com.serviceLocator.AppServiceLocator;
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author ...
	 */
	public class StartUpCommand extends MovieClip implements ICommand
	{
		private var model:AppModel = AppModel.getInstance();
		private var callBackObj:MovieClip;
		
		public function StartUpCommand(obj:MovieClip):void
		{
			callBackObj = obj;
		}
		
		public function execute():void
		{
			var service:AppServiceLocator = new AppServiceLocator(this, ServiceConfig.STARTUP_SERVICE);
		}
		
		public function callBackCommand(obj:Object):void
		{
			model.JSONModel = obj;
			model.startUpArray = new Array();
			
			var availableEgg:Number = Number(obj.AvailableEggs);	
			model.startUpArray.push(availableEgg);

			callBackObj.notifyUpdate(new ApplicationEvent(ApplicationEvent.STARTUP_UPDATE));
		}
	}
	
}