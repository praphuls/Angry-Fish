package com.lakeview
{
	import com.config.AppConfig;
	import com.utils.Utils;
	import flash.display.MovieClip;
	import com.model.AppModel;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.net.NetGroupSendMode;
	import flash.utils.Timer;
	import fl.transitions.*;
	import fl.transitions.easing.Regular;
	
	/**
	 * ...
	 * @author
	 */
	public class ContextHelper extends MovieClip 
	{
		private var mainStage:MovieClip;
		private var model:AppModel = AppModel.getInstance();
		private var helpTimer:Timer;
		
		//----------- SINGLETON - start -----------------------
		
		private static var _instance:ContextHelper = new ContextHelper();
		
		public function ContextHelper() 
		{
			if(_instance)
				throw new Error("Singleton Class");
		}
		
		public static function getInstance():ContextHelper
		{
			return _instance;
		}
		
		//----------- SINGLETON - end -----------------------
		
		public function startContextHelper(mainStage:MovieClip):void
		{
			this.mainStage = mainStage;
			addContextualHelp(findHelperIndex());
			trace(findHelperIndex(), "findHelperIndex()");
		}
		
		private function findHelperIndex():Number
		{
			var arrLen:Number = model.fishesArray.length; trace(arrLen, " arrLen++");
			
			var helperIndex:Number;
			var finalOwnerArray:Array = new Array();
			var isFinalOwner:Boolean;
			var avialableEggToHatch:Number = model.availableEggCount;
			
			for (var i:Number = 0; i < arrLen; i++ )
			{
				finalOwnerArray.push((model.fishesArray[i].isOwner) as Boolean);
			}
			
			if (finalOwnerArray.length > 0)
			{
				if (finalOwnerArray.length > 2)
				{
					isFinalOwner = finalOwnerArray[0] || finalOwnerArray[1];
					
					for (var j:Number = 2; j < finalOwnerArray.length; j++ )
					{
						isFinalOwner = isFinalOwner || finalOwnerArray[j];
						trace(isFinalOwner, "FINAL BOOL 2+");
					}
				}
				else if (finalOwnerArray.length > 1)
				{
					isFinalOwner = finalOwnerArray[0] || finalOwnerArray[1];
					trace(isFinalOwner, "FINAL BOOL 2=");
				}
				else	
				{
					isFinalOwner = finalOwnerArray[0];
					trace(isFinalOwner, "FINAL BOOL 1+");
				}
				
				
			}
			
			if (!isFinalOwner)
					helperIndex = 1;
			else
			{
				if (finalOwnerArray.length < 1)
					helperIndex = 1;
				else if (avialableEggToHatch < 1)
					helperIndex = 2;
			}
			
			return helperIndex;
			
		}
		
		private function addContextualHelp(index:Number):void
		{
			hideContextHelper();
			
			switch(index)
			{
				case 0: 
					{
						trace("No Fishes In Lake");
						break;
					}
					
				case 1: 
					{
						addContextHelp_1();
						initTimer();
						break;
					}
					
				case 2: 
					{
						addContextHelp_2();
						initTimer();
						break;
					}
			}
		}
		
		private var contextHelp_1:MovieClip;
		private function addContextHelp_1():void
		{
			trace("IN 1")
			contextHelp_1 = Utils.addMovieFromLibrary("ContextHelp_1", mainStage);
			contextHelp_1.contextTxt.text = AppConfig.CONTECTUAL_HELP_1_TXT;
			
			contextHelp_1.x = 84.60;
			contextHelp_1.y = 538.15;
			
			Utils.animateMC(contextHelp_1);
		}
		
		private var contextHelp_2:MovieClip;
		private function addContextHelp_2():void
		{
			trace("IN 2")
			contextHelp_2 = Utils.addMovieFromLibrary("ContextHelp_2", mainStage);
			contextHelp_2.contextTxt.text = getContextString();
			
			contextHelp_2.x = 83.60;
			contextHelp_2.y = 540.65;
			
			Utils.animateMC(contextHelp_2);
		}
		
		private function getContextString():String
		{
			var context:String = AppConfig.CONTECTUAL_HELP_2_TXT;
			var contextArr:Array = context.split("_");
			
			var finalContextText:String = contextArr[0] + model.requiredCredits + contextArr[1]
			return finalContextText;
		}
		
		private function hideContextHelper():void
		{
			if (contextHelp_1)
			{
				mainStage.removeChild(contextHelp_1);
				contextHelp_1 = null;
			}
			
			if (contextHelp_2)
			{
				mainStage.removeChild(contextHelp_2);
				contextHelp_2 = null;
			}
			
			
			//mainStage.contextHelp_1.visible = false;
			//mainStage.contextHelp_2.visible = false;
		}
		
		private function initTimer():void
		{
			helpTimer = new Timer(10000); // 10 seconds
			helpTimer.addEventListener(TimerEvent.TIMER, removeContextHelper);
			helpTimer.start();
		}
		
		private function removeContextHelper(e:TimerEvent):void
		{
			helpTimer.removeEventListener(TimerEvent.TIMER, removeContextHelper);
			helpTimer.stop();
			
			if (contextHelp_1)
			{
				mainStage.removeChild(contextHelp_1);
				contextHelp_1 = null;
			}
			
			if (contextHelp_2)
			{
				mainStage.removeChild(contextHelp_2);
				contextHelp_2 = null;
			}
			
			
			//mainStage.contextHelp_1.visible = false;
			//mainStage.contextHelp_2.visible = false;
		}
		
		private function onTweenComplete(e:Event):void
		{	
			//if (mainStage.contextHelp_1.visible)
			//{
				//var myTweenScale1:Tween = new Tween(mainStage.contextHelp_1, "alpha", Regular.easeOut, 1, 0, 0.35, true);
				//myTweenScale1.addEventListener(TweenEvent.MOTION_FINISH, onTweenComplete);
			//}
			//
			//if (mainStage.contextHelp_2.visible)
			//{
				//var myTweenScale2:Tween = new Tween(mainStage.contextHelp_2, "alpha", Regular.easeOut, 1, 0, 0.35, true);
				//myTweenScale2.addEventListener(TweenEvent.MOTION_FINISH, onTweenComplete);
			//}
		}
		
		public function hideContext():void
		{
			if(contextHelp_1)
				contextHelp_1.visible = false;
			
			if(contextHelp_2)
			contextHelp_2.visible = false;
		}
		
	}
	
}