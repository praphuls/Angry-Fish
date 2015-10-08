package com.components {
	
	import com.config.AppConfig;
	import com.controller.AppController;
	import com.events.ApplicationEvent;
	import com.model.AppModel;
	import com.model.FishSolvedModel;
	import com.utils.Utils;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.engine.FontWeight;
	import flash.text.TextFormat;
	
	
	public class CategorySelectorNewFish extends MovieClip {
		
		private var catArray:Array;
		private var positionCounter:Number = 6;
		private var htDiff:Number;
		private var model:AppModel;
		private var controller:AppController;
		private var isALL:Boolean = true;
		
		
		public function CategorySelectorNewFish() {
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
			
			contentLength = catArray.length;
		}
		
		private function onTxtRollOver(e:MouseEvent):void
		{
			var contentId:String = e.target.name.split("_")[1]
			positionCounter = Number(e.target.name.split("_")[1]);
			
			this.contentMC.markerMC.visible = true;
			contentMC.markerMC.y = this.contentMC["content_" + contentId].y;
			//setSelectedTxtFormat(this.contentMC["content_" + contentId]);
		}
		
		private function onTxtRollOut(e:MouseEvent):void
		{
			this.contentMC.markerMC.visible = false;
			
			var contentId:String = e.target.name.split("_")[1]
			positionCounter = Number(e.target.name.split("_")[1]);
			
			//setUnSelectedTxtFormat(this.contentMC["content_" + contentId]);
		}
		
		private var markedContentID:String;
		private function markSelectedCategory(e:MouseEvent):void
		{
			var contentId:String = e.target.name.split("_")[1]
			positionCounter = Number(e.target.name.split("_")[1]);
			
			this.contentMC.markerMC.visible = true;
			
			markedContentID = contentId;
			
			setUnSelectedTxtFormatToAll();
			setSelectedTxtFormat(this.contentMC["content_" + contentId]);
			//contentMC.markerMC.y = this.contentMC["content_" + contentId].y;
		}
		
		private function onTxtClick(e:MouseEvent):void
		{
			markSelectedCategory(e);
			model.categoryText = e.target.text;
			
			var evt:ApplicationEvent = new ApplicationEvent(ApplicationEvent.CAT_SELECTED_EVENT);
			evt.categoryName = this.contentMC["content_" + (positionCounter)].text;
			this.dispatchEvent(evt);
		}
		
		private function upContent(e:MouseEvent):void
		{
			
			if(positionCounter <= 2)
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
			
			if(markedContentID)
				contentMC.markerMC.y = this.contentMC["content_" + markedContentID].y;
			
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
			
			if(markedContentID)
				contentMC.markerMC.y = this.contentMC["content_" + markedContentID].y;
				
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
			//txt.alpha = 0.5;
			txt.textColor = 0xCCFF00;
			
			//var greenFormat:TextFormat = new TextFormat();
			//greenFormat.color = 0xCCFF00;
//
			//txt.setTextFormat(greenFormat);
		}
		
		private function setUnSelectedTxtFormat(txt:TextField):void
		{
			//txt.alpha = 1;
			txt.textColor = 0xFFFFFF;
			
			//var myFormatWhite:TextFormat = new TextFormat();
			//myFormatWhite.color = 0xFFFFFF;
//
			//txt.setTextFormat(myFormatWhite);
		}
		
		private function setUnSelectedTxtFormatToAll():void
		{
			for(var j:Number=0; j<catArray.length+1; j++)
			{
				setUnSelectedTxtFormat(this.contentMC["content_"+(j+1)] as TextField)
			}
		}
	}
	
}
