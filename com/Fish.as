package com
{
	import com.config.AppConfig;
	import com.controller.AppController;
	import com.events.ApplicationEvent;
	import com.model.AppModel;
    import flash.display.*;
    import flash.events.*;
	import flash.external.ExternalInterface;
    import flash.utils.getDefinitionByName;
	
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	
	//import flashx.textLayout.operations.MoveChildrenOperation;
	
    import com.utils.Utils;
	import com.events.RemoveOtherFishes;
	import flash.utils.Timer;
	import com.model.FishSolvedModel;
	import com.fishes.happyFishes.HappyFish_2;
	import com.events.RemoveFishes;
	import com.events.AddActions;
	import com.events.AddPopUp;

   public class Fish extends MovieClip
   {
       private var speed:int = 0;
	   private var swimDirection:String = "left";
	   private var dir:Number
	   private var dir1:Number
	   private var dir2:Number
	   private var boundary:MovieClip;
	   private var fishInAction:MovieClip;
	   private var myPopUp:MovieClip;
	   private var yourPopUp:MovieClip;
	   private var fishName:String;
	   private var count:Number = 0;
	   private var currentlySelectedFish:MovieClip;
	   private var fishCategory:String;
	   private var popUps:MovieClip
	   private var fishModel:FishSolvedModel = FishSolvedModel.getInstance();
	   private var controller:AppController = new AppController();
	   private var model:AppModel = AppModel.getInstance();

        public function Fish( mc:MovieClip )
        {
			if(mc.valueOf() is Fish)
			{
				fishInAction = mc;
				
				fishInAction.scaleX = Utils.fishScaleX;
				fishInAction.scaleY = Utils.fishScaleY;
				
				if(mc.valueOf() is HappyFish_2)
				{
					prepareFishToSwimInAquarium();
				}
				else
				{
					fishModel.fishInLake = fishInAction;
					prepareFishToSwim();
				}
				
				if (model.lakeType == "1" || model.lakeType == "2")
					fishInAction.addEventListener(AddActions.ADD_ACTIONS_TO_FISHES, addActions);
			}
			else
				trace("Not a Fish..")
		} 
		
		private function prepareFishToSwim():void
		{
			setRandomPositions();
		  	getRandomSpeed();
			addActionsToFish();
			setSwimDirection();
		}
		
		private function prepareFishToSwimInAquarium():void
		{
			setAquariumPositions();
		  	getRandomSpeed();
			addActionsToFish();
			setSwimDirection();
		}
		
		private function setAquariumPositions():void
	    {
			fishInAction.x = randomRange(900, 50);
			fishInAction.y = randomRange(490, 290);
	    }
		
		private function setRandomPositions():void
	    {
			fishInAction.x = randomRange(800, 50);
			fishInAction.y = randomRange(400, 50);
	    }
		
		private function randomRange(max:Number, min:Number = 0):Number
		{
			 return Math.random() * (max - min) + min;
		}

		
		private function setSwimDirection():void
		{
			dir = randomDir(2);
			dir1 = randomDir(3);
			dir2 = randomDir(3);

			if(dir == 1)
				swimDirection = "left";
			else
				swimDirection = "right";
			
		}
		
		private function getRandomSpeed():void
	    {
			speed = Math.floor(Math.random())+1;
	    }
		
		private var myTimer:Timer;
		private function addActionsToFish():void
		{
			if (fishInAction.valueOf() is HappyFish_2)
			{
				fishInAction.addEventListener(Event.ENTER_FRAME, onHappyMove); trace("hi... In happy")
			}
			else
				fishInAction.addEventListener(Event.ENTER_FRAME, onMove);
				
			fishInAction.addEventListener(MouseEvent.CLICK, onClick);
			
			
			initTimer();
		}
		
		private function initTimer():void
		{
			myTimer = new Timer(7000); // 7 seconds
			myTimer.addEventListener(TimerEvent.TIMER, swim);
			myTimer.start();
		}
		
		protected function addActionsToTheFish( mcFish:MovieClip):void
		{
			if (mcFish.valueOf() is HappyFish_2)
				mcFish.addEventListener(Event.ENTER_FRAME, onHappyMove);	
			else
				mcFish.addEventListener(Event.ENTER_FRAME, onMove);	
				
			mcFish.addEventListener(MouseEvent.CLICK, onClick);
			
			initTimer();
		}
		
		protected function removeActionsFromFish( mcFish:MovieClip ):void
		{
			if (mcFish.valueOf() is HappyFish_2)
				mcFish.removeEventListener(Event.ENTER_FRAME, onHappyMove);
			else
				mcFish.removeEventListener(Event.ENTER_FRAME, onMove);
				
			mcFish.addEventListener(MouseEvent.CLICK, onClick);
			myTimer.removeEventListener(TimerEvent.TIMER, swim);
			myTimer.stop();
		}
		
		private function swim(event:TimerEvent):void {
			setSwimDirection();
		}
	   
	    private function randomDir(num:Number):Number
	    {
		   var dir:Number = Math.floor(Math.random()* (num));
		   return dir;
	    }
		
		private function onHappyMove(e:Event):void
		{
			updateHappyDirection();
		   
		   if(swimDirection == "left")
		   {
			   this.x -= speed;
			   this.scaleX = 1;
			   
			   if(dir1 == 1)
			   {
			   		 this.y -= (speed/2);
			   }
			   else if(dir1 == 2)
			   {
			   		 this.y += (speed/2);
			   }
		   }
		   else if(swimDirection == "right")
		   {
			  this.x += speed; 
			  this.scaleX = -1;
			  
			  if(dir2 == 1)
			  {
			   		 this.y -= (speed/2);
			  }
			   else if(dir2 == 2)
			   {
			   		 this.y += (speed/2);
			   }
		   }
		}
		
        private function onMove(e:Event):void
        {
		   updateDirection();
		   
		   if(swimDirection == "left")
		   {
			   this.x -= speed;
			   this.scaleX = 1;
			   
			   if(dir1 == 1)
			   {
			   		 this.y -= (speed/2);
			   }
			   else if(dir1 == 2)
			   {
			   		 this.y += (speed/2);
			   }
		   }
		   else if(swimDirection == "right")
		   {
			  this.x += speed; 
			  this.scaleX = -1;
			  
			  if(dir2 == 1)
			  {
			   		 this.y -= (speed/2);
			  }
			   else if(dir2 == 2)
			   {
			   		 this.y += (speed/2);
			   }
		   }
       }
	   
	   private function updateHappyDirection():void
	   {
		   getRandomSpeed();
		   
		   var xMax:Number = 850;
		   var xMin:Number = 100;
		   
		   var yMax:Number = 490;
		   var yMin:Number = 350;

		   if((fishInAction.x) < xMin)
		   {
			   	swimDirection = "right";
				fishInAction.scaleX = -1*fishInAction.scaleX;
				
				dir2 = randomDir(3);
				dir1 = randomDir(3);
				
				if((fishInAction.y + (fishInAction.height)) < (yMin))
			    {
					fishInAction.y += (speed);
					dir2 = randomDir(3);
					dir1 = randomDir(3);
			    }
				else if((fishInAction.y + (fishInAction.height)) > (yMax))
			    {
					fishInAction.y -= (speed);
					dir2 = randomDir(3);
					dir1 = randomDir(3);
			    }
		   }
		   else if((fishInAction.x) > (xMax))
		    {
			   	swimDirection = "left";
				fishInAction.scaleX = 1*fishInAction.scaleX;
				
				dir2 = randomDir(3);
				dir1 = randomDir(3);
				
				if((fishInAction.y + (fishInAction.height)) < (yMin))
			    {
					fishInAction.y += (speed);
					dir2 = randomDir(3);
					dir1 = randomDir(3);
			    }
				else if((fishInAction.y + (fishInAction.height)) > (yMax))
			    {
					fishInAction.y -= (speed);
					dir2 = randomDir(3);
					dir1 = randomDir(3);
			    }
		    }
		   
			if((fishInAction.y + (fishInAction.height)) < (yMin))
			{
				fishInAction.y += (speed);
				dir2 = randomDir(3);
				dir1 = randomDir(3);
				dir = randomDir(2);
			}
			else if((fishInAction.y + (fishInAction.height)) > (yMax))
			{
				fishInAction.y -= (speed);
				dir2 = randomDir(3);
				dir1 = randomDir(3);
				dir = randomDir(2);
			}
	   }
	   
	   private function updateDirection():void
	   {
		   getRandomSpeed();

		   if((fishInAction.x) < 100)
		   {
			   	swimDirection = "right";
				fishInAction.scaleX = -1*fishInAction.scaleX;
				
				dir2 = randomDir(3);
				dir1 = randomDir(3);
				
				if((fishInAction.y + (fishInAction.height/2)) < (150))
			    {
					fishInAction.y += (speed);
					dir2 = randomDir(3);
					dir1 = randomDir(3);
			    }
				else if((fishInAction.y + (fishInAction.height/2)) > (611 - 200))
			    {
					fishInAction.y -= (speed);
					dir2 = randomDir(3);
					dir1 = randomDir(3);
			    }
		   }
		   else if((fishInAction.x) > (900))
		    {
			   	swimDirection = "left";
				fishInAction.scaleX = 1*fishInAction.scaleX;
				
				dir2 = randomDir(3);
				dir1 = randomDir(3);
				
				if((fishInAction.y + (fishInAction.height/2)) < (150))
			    {
					fishInAction.y += (speed);
					dir2 = randomDir(3);
					dir1 = randomDir(3);
			    }
				else if((fishInAction.y + (fishInAction.height/2)) > (611 - 200))
			    {
					fishInAction.y -= (speed);
					dir2 = randomDir(3);
					dir1 = randomDir(3);
			    }
		    }
		   
			if((fishInAction.y + (fishInAction.height/2)) < (150))
			{
				fishInAction.y += (speed);
				dir2 = randomDir(3);
				dir1 = randomDir(3);
				dir = randomDir(2);
			}
			else if((fishInAction.y + (fishInAction.height/2)) > (611 - 200))
			{
				fishInAction.y -= (speed);
				dir2 = randomDir(3);
				dir1 = randomDir(3);
				dir = randomDir(2);
			}
	   }
	   
	   protected function onClick(evt:MouseEvent=null):void
		{
			controller.doAction(AppConfig.CLOSE_SCORE_CARD, AppModel.getInstance().myScoreCard);
			
			intimateFishesAboutAction("INACTIVE_THIS_FISH");
			enableAllFishes();
			removePopUps();
			//ExternalInterface.call('alert', 'Hi..')
			//Utils.moveToTop(evt.target as MovieClip);
			addPop(evt.target as MovieClip);
		}
		
		private function recordUpdate(e:Event):void
		{
			trace("hi..")
		}
		
		private function intimateFishesAboutAction(action:String):void
		{
			if (fishInAction is HappyFish_2)
			{
				var arrLenAqua:Number = AppModel.getInstance().aquaFishArray.length;
				
				for(var j:Number=0; j<arrLenAqua; j++)
				{
					(AppModel.getInstance().aquaHappyFishArray[j] as MovieClip).dispatchEvent(new Event(action));
				}
			}
			else
			{
				var arrLen:Number = fishModel.fishInLakeArray.length
				
				for(var i:Number=0; i<arrLen; i++)
				{
					(fishModel.fishInLakeArray[i] as MovieClip).dispatchEvent(new Event(action));
				}
			}
		}
		
		private function addPop(targetFish:MovieClip):void
		{
			this.dispatchEvent(new AddPopUp(AddPopUp.ADD_POPUP));
			fishInAction.addEventListener(AddActions.ADD_ACTIONS_TO_FISHES, addActions);
			fishInAction.addEventListener(RemoveFishes.REMOVE_FISHES, fishRemoved);
		}
		
		private function addActions(evt:Event):void
		{
			intimateFishesAboutAction("ACTIVE_THIS_FISH");
		}
		
		private function fishRemoved(evt:Event):void
		{
			this.dispatchEvent(new RemoveFishes(RemoveFishes.REMOVE_FISHES));
		}
		
		private function removePopUps():void
		{			
			if (!(fishInAction.valueOf() is HappyFish_2))
			{
				Utils.removeNoFishPopUp(FishSolvedModel.getInstance().mainStage);
				
				this.dispatchEvent(new ApplicationEvent(ApplicationEvent.HIDE_COMMENTS_EVENT));
				this.dispatchEvent(new ApplicationEvent(ApplicationEvent.REMOVE_SOLVE_PROB_POPUP_EVENT));
			
				var arrLen:Number = fishModel.allPopuUps.length;
				//ExternalInterface.call('alert', arrLen)
				if(arrLen > 0)
				{
					for(var i:Number=0; i<arrLen; i++)
					{
						(fishModel.lakeMc).removeChild(fishModel.allPopuUps[i]);
						fishModel.allPopuUps.pop();
					}
				}
			}
			else 
			{
				this.dispatchEvent(new ApplicationEvent(ApplicationEvent.HIDE_COMMENTS_AQUA_EVENT));
				this.dispatchEvent(new ApplicationEvent(ApplicationEvent.HIDE_SOLUTION_EVENT));
			}
		}
		
		private function enableAllFishes():void
		{
			var addPopUpList:ApplicationEvent = new ApplicationEvent(ApplicationEvent.ADD_POPUP_LISTENER_EVENT);
			this.dispatchEvent(addPopUpList);
		}
    } 

} 