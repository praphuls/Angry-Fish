package com.serviceLocator  {
	import com.controller.commands.ICommand;
	import com.model.AppModel;
	import flash.display.MovieClip;
	import flash.external.ExternalInterface;
	import flash.net.URLVariables;
	import flash.net.URLRequest;
	import com.adobe.serialization.json.JSON;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequestMethod;
	
	public class SolveProblemServiceLocator extends MovieClip 
	{
		
		private var uvars:URLVariables;
		private var ureq:URLRequest;
		private var callBackObj:ICommand;
		private var services:String;
		private var PROBLEM_ID:String = "problemId";
		private var ASSOCIATE_ID:String = "associateId";
		private var COMMENTS:String = "comments";
		private var PROBDESC:String = "problemdescription";
		private var ASSOCIATE_NAME:String = "associateName";
		private const APP_TYPE:String = "application/json";
		private var model:AppModel = AppModel.getInstance();

		public function SolveProblemServiceLocator(obj:ICommand, service:String) {
			callBackObj = obj;
			services = service;
			connectToService();
		}
		
		public function connectToService():void
		{
			uvars = new URLVariables();
			
			ureq = new URLRequest();
			ureq.url = services + PROBLEM_ID + "=" + model.problemIDForFeed + "&" + ASSOCIATE_ID + "=" + model.assocaiteID + "&" + COMMENTS + "=" + model.solutionComments + "&" + PROBDESC + "=" + model.problemDescriptionToSolve + "&" + ASSOCIATE_NAME + "=" + model.associateName;
			
			trace(ureq.url);
			ureq.method = URLRequestMethod.POST;
			ureq.data = JSON.encode(uvars);
			ureq.contentType = APP_TYPE;
		
			var uload:URLLoader = new URLLoader();
			uload.addEventListener(Event.COMPLETE, this.complete);
			uload.load(ureq);
		}
		
		private function complete(e:Event):void {
			var doObj:Object = JSON.decode(e.currentTarget.data as String);
			callBackObj.callBackCommand(doObj);
		}
    }
}
	

