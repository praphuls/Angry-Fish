package com.components  {
	
	import com.config.AppConfig;
	import com.controller.AppController;
	import com.events.ApplicationEvent;
	import com.model.AppModel;
	import com.model.FishSolvedModel;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import fl.transitions.*;
	import fl.transitions.easing.Regular;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ScoreCard extends MovieClip {
		
		private var isOpen:Boolean = false;
		private var mWidth:Number;
		private var SHOW_SCORE:String = "show";
		private var HIDE_SCORE:String = "hide";
		private var controller:AppController = new AppController();
		private var model:AppModel = AppModel.getInstance();
		private var mainStage:MovieClip;
		
		public function ScoreCard() {
			// constructor code
			model.myScoreCard = this;
			
			mWidth = this.width - scoreBtn.width;
			scoreBtn.addEventListener(MouseEvent.CLICK, showHideScore);
			this.addEventListener(ApplicationEvent.CLOSE_SCORE_CARD_EVENT, closeScoreCard);
		}
		
		private function showHideScore(e:MouseEvent):void
		{
			trace("ScoreCard Clicked......")
			
			e.target.mouseEnabled = false;
			
			if (!isOpen)
			{
				showScoreCard();
				isOpen = true;
			}
			else
			{
				hideScoreCard();
				isOpen = false;
			}
		}
		
		private function showScoreCard():void
		{
			controller.doAction(AppConfig.GET_MY_SCORE, this);
			controller.addEventListener(ApplicationEvent.GET_MY_SCORE_EVENT, getMyScore);
		}
		
		private function getMyScore(e:ApplicationEvent):void
		{
			this.highestScoreTxt.text = "Score: " + model.currentCreditCount;
			
			if(model.showFlag == 0)
				this.reqCreditsTxt.text = "You already have an egg available. You can click and feed a fish to earn more points";
			else if(model.showFlag == 1)
				this.reqCreditsTxt.text = "You need " + model.requiredCreditCount + " more points to earn an egg."; 
				
			showAnimateMC(SHOW_SCORE);
			trace("in show")
		}
		
		private function hideScoreCard():void
		{
			hideAnimateMC(HIDE_SCORE);
			trace("in hide")
		}
		
		private function showAnimateMC(direction:String):void
		{
			trace("SHOW")
			
			if (direction == "show")
			{
				this.x = this.x - mWidth;
				//var myTweenScaleX_SHOW:Tween = new Tween(this, "x", Regular.easeOut, this.x, this.x - mWidth, 0.10, true);
				//myTweenScaleX_SHOW.addEventListener(TweenEvent.MOTION_FINISH, onTweenComplete);
			}
			
			scoreBtn.mouseEnabled = true;
		}
		
		private function hideAnimateMC(direction:String):void
		{
			trace("HIDE")
			
			if (direction == "hide")
			{
				this.x = this.x + mWidth;
				
				//var myTweenScaleX_HIDE:Tween = new Tween(this, "x", Regular.easeOut, this.x, this.x + mWidth, 0.10, true);
				//myTweenScaleX_HIDE.addEventListener(TweenEvent.MOTION_FINISH, onHideComplete);
			}
			scoreBtn.mouseEnabled = true;
		}
		
		private function closeScoreCard(e:ApplicationEvent):void
		{
			trace("close called ******")
			
			if(isOpen)
			{
				this.x = this.x + mWidth;
				isOpen = false;
				
				//var myTweenScaleX_CLOSE:Tween = new Tween(this, "x", Regular.easeOut, this.x, this.x + mWidth, 0.10, true);
				//myTweenScaleX_CLOSE.addEventListener(TweenEvent.MOTION_FINISH, onCloseComplete);
			}
			scoreBtn.mouseEnabled = true;
		}
		
		private function onTweenComplete(e:Event):void
		{	
			trace("Show complete")
			this.x = 775.85;
			scoreBtn.addEventListener(MouseEvent.CLICK, showHideScore);
			// call to service // to implement here...
		}
		
		private function onHideComplete(e:Event):void
		{	
			trace("Hide complete")
			this.x = 918.85;
			scoreBtn.addEventListener(MouseEvent.CLICK, showHideScore);
			// call to service // to implement here...
		}
		
		private function onCloseComplete(e:Event):void
		{	
			trace("Close complete")
			this.x = 918.85;
			scoreBtn.addEventListener(MouseEvent.CLICK, showHideScore);
			// call to service // to implement here...
		}
	}
	
}
