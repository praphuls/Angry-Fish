package com.serviceLocator  {
	import com.controller.commands.ICommand;
	import com.model.AppModel;
	import flash.display.MovieClip;
	import flash.errors.IOError;
	import flash.net.URLVariables;
	import flash.net.URLRequest;
	import com.adobe.serialization.json.JSON;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequestMethod;
	import flash.events.IOErrorEvent;
	import flash.external.ExternalInterface;

	
	public class AppServiceLocator extends MovieClip 
	{
		
		private var uvars:URLVariables;
		private var ureq:URLRequest;
		private var callBackObj:ICommand;
		private var services:String;
		private const APP_TYPE:String = "application/json";
		private var model:AppModel = AppModel.getInstance();

		public function AppServiceLocator(obj:ICommand, service:String) {
			callBackObj = obj;
			services = service;
			connectToService();
		}
		
		public function connectToService():void
		{
			uvars = new URLVariables();
		
			ureq = new URLRequest();
			ureq.url = services + model.assocaiteID;
			ureq.method = URLRequestMethod.POST;
			ureq.data = JSON.encode(uvars);
			ureq.contentType = APP_TYPE;
		
			var uload:URLLoader = new URLLoader();
			uload.addEventListener(Event.COMPLETE, complete);
			uload.addEventListener(IOErrorEvent.IO_ERROR, handleError);
			uload.load(ureq);
		}
		
		private function complete(e:Event):void {
			var doObj:Object = JSON.decode(e.currentTarget.data as String);
			callBackObj.callBackCommand(doObj);
		}
		
		private function handleError(e:IOErrorEvent):void
		{
			trace("IO ERROR: Error opening URL "+ureq.url);
		}
    }
}
	

