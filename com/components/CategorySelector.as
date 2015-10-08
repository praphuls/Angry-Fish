package com.components {
	
	import com.config.AppConfig;
	import com.controller.AppController;
	import com.events.ApplicationEvent;
	import com.model.AppModel;
	import com.model.FishSolvedModel;
	import com.utils.Utils;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.engine.FontWeight;
	
	
	public class CategorySelector extends MovieClip {
		
		private var catArray:Array;
		private var positionCounter:Number = 1;
		private var htDiff:Number;
		private var model:AppModel;
		private var controller:AppController;
		private var isALL:Boolean = true;
		
		
		public function CategorySelector() {
			controller = new AppController();
			model = AppModel.getInstance();
			
			if(model.categoriesArray.length > 0)
				catArray = model.categoriesArray;
			
			fillContentsInMC();
			
			htDiff = this.contentMC.content_2.y - this.contentMC.content_1.y;
			
			this.upBtn.addEventListener(MouseEvent.CLICK, upContent);
			this.downBtn.addEventListener(MouseEvent.CLICK, downContent);
			
			this.upBtn.mouseEnabled = false;
			this.upBtn.visible = false;
			this.contentMC.markerMC.visible = false;
		}
		
		public function get showIsALL():Boolean
		{
			return isALL;
		}
		
		public function set showIsALL(val:Boolean):void
		{
			isALL = val;
		}
		
		private var contentLength:Number = 0;
		private function fillContentsInMC():void
		{
			for(var i:Number=0; i<catArray.length; i++)
			{
				this.contentMC["content_" + (i + 1)].text = catArray[i].categoryName;
				this.contentMC["content_" + (i + 1)].addEventListener(MouseEvent.CLICK, onTxtClick);
				this.contentMC["content_" + (i + 1)].addEventListener(MouseEvent.ROLL_OVER, onTxtRollOver);
				this.contentMC["content_" + (i + 1)].addEventListener(MouseEvent.ROLL_OUT, onTxtRollOut);
			}
			
			if (isALL)
			{
				this.contentMC["content_" + (catArray.length + 1)].text = "ALL";
				this.contentMC["content_" + (catArray.length + 1)].addEventListener(MouseEvent.CLICK, onTxtClick);
				this.contentMC["content_" + (catArray.length + 1)].addEventListener(MouseEvent.ROLL_OVER, onTxtRollOver);
				this.contentMC["content_" + (catArray.length + 1)].addEventListener(MouseEvent.ROLL_OUT, onTxtRollOut);
				
				contentLength = catArray.length + 1;
			}
			else
				contentLength = catArray.length;
		}
		
		private function onTxtRollOver(e:MouseEvent):void
		{
			var contentId:String = e.target.name.split("_")[1]
			positionCounter = Number(e.target.name.split("_")[1]);
			
			this.contentMC.markerMC.visible = true;
			
			contentMC.markerMC.y = this.contentMC["content_" + contentId].y;
		}
		
		private function onTxtRollOut(e:MouseEvent):void
		{
			this.contentMC.markerMC.visible = false;
		}
		
		private function onTxtClick(e:MouseEvent):void
		{
			model.categoryText = e.target.text;
			controller.doAction(AppConfig.CATEGORY_SELECETOR, this.parent);
		}
		
		private function upContent(e:MouseEvent):void
		{
			if(positionCounter <= 5)
			{
				e.target.visible = false;
				e.target.mouseEnabled = false;
				this.downBtn.mouseEnabled = true;
				this.downBtn.visible = true;
			}
			else
			{
				this.downBtn.mouseEnabled = true;
				this.downBtn.visible = true;
				
				e.target.mouseEnabled = true;
				e.target.visible = true;
			}
				
			if(positionCounter > 1)
			{
				positionCounter--;
				for(var j:Number=0; j<contentLength; j++)
				{
					this.contentMC["content_"+(j+1)].y += htDiff;
				}
			}
			
			sendContent();
		}
		
		private function downContent(e:MouseEvent):void
		{
			
			if(positionCounter < contentLength)
				positionCounter++;
			
			if(positionCounter == contentLength)
			{
				e.target.mouseEnabled = false;
				e.target.visible = false;
				
				this.upBtn.mouseEnabled = true;
				this.upBtn.visible = true;
			}
			else
			{
				this.upBtn.mouseEnabled = true;
				this.upBtn.visible = true;
				
				e.target.mouseEnabled = true;
				e.target.visible = true;
			}
			
			if(positionCounter <= contentLength)
			{
				for(var i:Number=0; i<contentLength; i++)
				{
					this.contentMC["content_"+(i+1)].y -= htDiff;
				}
			}
			
			sendContent();
		}
		
		private function sendContent():void
		{
			trace("category Selected: " + this.contentMC["content_" + (positionCounter)].text);
		}
		
		private function changeFontStyle():void
		{
			for(var j:Number=0; j<catArray.length+1; j++)
			{
				setUnSelectedTxtFormat(this.contentMC["content_"+(j+1)] as TextField)
			}
			setSelectedTxtFormat(contentMC["content_"+(positionCounter)] as TextField);
		}
		
		private function setSelectedTxtFormat(txt:TextField):void
		{
			txt.alpha = 1;
		}
		
		private function setUnSelectedTxtFormat(txt:TextField):void
		{
			txt.alpha = 0.3;
		}
	}
	
}
