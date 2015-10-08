package com.serviceLocator
{
	import com.controller.commands.ICommand;
	import flash.display.MovieClip;
	import flash.external.ExternalInterface;
	import flash.net.URLVariables;
	import flash.net.URLRequest;
	import com.adobe.serialization.json.JSON;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequestMethod;
	import flash.text.ime.CompositionAttributeRange;
	import com.model.AppModel;
	
	/**
	 * ...
	 * @author ...
	 */
	public class FeedFishServiceLocator extends MovieClip 
	{
		private var uvars:URLVariables;
		private var ureq:URLRequest;
		private var callBackObj:ICommand;
		private var services:String;
		private const APP_TYPE:String = "application/json";
		private const PROBLEM_ID:String = "problemId";
		private const ASSOCIATE_ID:String = "associateId";
		private const PROBLEM_DESCRIPTION:String = "problemDescription";
		private const ASSOCIATE_NAME:String = "AssociateName";
		private const FISH_LEVEL:String = "FishLevel";
		private var model:AppModel = AppModel.getInstance();

		public function FeedFishServiceLocator(obj:ICommand, service:String) {
			callBackObj = obj;
			services = service;
			connectToService();
		}
		
		public function connectToService():void
		{
			uvars = new URLVariables();
		
			ureq = new URLRequest();
			ureq.url = services + PROBLEM_ID + "=" + model.problemIDForFeed + "&" + ASSOCIATE_ID + "=" + model.assocaiteID + "&"+ FISH_LEVEL + "=" + model.fishCurrentLevel +"&" + PROBLEM_DESCRIPTION + "=" + model.problemDescriptionToFeed + "&" + ASSOCIATE_NAME + "=" + model.associateName;
			trace(ureq.url, "UUUUUURRRRRRRRRLLLLLLLLLL")
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