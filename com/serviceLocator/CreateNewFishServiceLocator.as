package com.serviceLocator
{
	import com.controller.commands.ICommand;
	import flash.display.MovieClip;
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
	public class CreateNewFishServiceLocator extends MovieClip 
	{
		private var uvars:URLVariables;
		private var ureq:URLRequest;
		private var callBackObj:ICommand;
		private var services:String;
		private const APP_TYPE:String = "application/json";
		private const PROBLEM_DESC:String = "problemDescription";
		private const ASSOCIATE_ID:String = "reportedBy";
		private const CATEGORY_ID:String = "categoryId";
		private const KEYWORDS:String = "keywords";
		private const ASSOCIATE_NAME:String = "associateName";
		private var model:AppModel = AppModel.getInstance();

		public function CreateNewFishServiceLocator(obj:ICommand, service:String) {
			callBackObj = obj;
			services = service;
			connectToService();
		}
		
		public function connectToService():void
		{
			uvars = new URLVariables();
			
			ureq = new URLRequest();
			ureq.url = services + PROBLEM_DESC + "=" + model.problemDescriptionStr + "&" + ASSOCIATE_ID + "=" + model.assocaiteID + "&" + CATEGORY_ID + "=" + model.categoryID + "&" + KEYWORDS + "=" + model.keywordsStr + "&" + ASSOCIATE_NAME + "=" + model.associateName;
			
			trace(ureq.url);
			
			ureq.method = URLRequestMethod.POST;
			ureq.data = JSON.encode(uvars);
			ureq.contentType = APP_TYPE;
		
			var uload:URLLoader = new URLLoader();
			uload.addEventListener(Event.COMPLETE, this.complete);
			uload.load(ureq);
		}
		
		private function complete(e:Event):void 
		{
			var doObj:Object = JSON.decode(e.currentTarget.data as String);
			callBackObj.callBackCommand(doObj);
		}
	}
	
}