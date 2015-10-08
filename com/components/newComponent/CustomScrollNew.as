package com.components.newComponent
{	
	import flash.display.MovieClip;	
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.events.Event;
	
	public class CustomScrollNew extends MovieClip 
	{				
		private var lowerScroll:Number = 0;
		private var upperScroll:Number;	
		private var scrollRange:Number;
					
		private var lowerText:Number;
		private var upperText:Number = 0;
		private var textRange:Number;
		
		private var self:MovieClip = this as MovieClip;
		private var scroller:MovieClip;
		private var scrollerX:Number;
		
		private var txtBox:TextField;
		private var commentsStr:String;
					
		public function CustomScrollNew() 
		{	
			trace("Hi..")
			AddDynamicText();
		}
		
		public function get commentTxt():String
		{
			return commentsStr;
		}
		public function set commentTxt(str:String):void
		{
			commentsStr = str;
			txtBox.text = commentsStr;
			
			configureScroll();
			trace(txtBox.height,"Text")
		}
		
		private function configureScroll():void
		{
			scroller = self.mc_Scrollbar.mc_Scroller;  
			scrollerX = scroller.x;
			scroller.buttonMode = true
						
			upperScroll = self.mc_Scrollbar.height - scroller.height;
			scrollRange = upperScroll - lowerScroll;
			
			lowerText = upperScroll - txtBox.height; // maximum scroll
			textRange = upperText - lowerText;			 
			
			trace(self.mc_Scrollbar.height, txtBox.height);
			
			if(self.mc_Scrollbar.height >= txtBox.height)
			{
				self.mc_Scrollbar.visible = false;
			}
			else
			{
				self.mc_Scrollbar.visible = true;
				scroller.addEventListener(MouseEvent.MOUSE_DOWN, startScroll);
				scroller.addEventListener(MouseEvent.MOUSE_UP, stopScroll);				
			}
		}
		
		
		private function AddDynamicText()
		{
			txtBox = new TextField();
			txtBox.width = 137;
			txtBox.x = 5;
			txtBox.y = 5;
			txtBox.scrollV = 10;
			txtBox.textColor = 0xFFFFFF;
			txtBox.wordWrap = true;
			txtBox.multiline = true;
			txtBox.autoSize = "left";
			
			self.mc_Text.addChild(txtBox);
		}
		
		/*private function Refresh(evt:Event)
		{
			if(self.mc_Scrollbar.height >= txtBox.height)
			{
				self.mc_Scrollbar.visible = false;
			}
			else
			{
				self.mc_Scrollbar.visible = true;				
			}
		}*/
		
		private function scrollText(evt:MouseEvent)
		{
			var percentMove:Number = (scroller.y - lowerScroll)/scrollRange;
			var textMove:Number = upperText - textRange*percentMove;
			self.mc_Text.y = textMove;	
		}
		
		private function startScroll(evt:MouseEvent)
		{	
			//trace("Dragging");
			scroller.startDrag(false, new Rectangle(scrollerX, lowerScroll, 0, scrollRange));	
			scroller.addEventListener(MouseEvent.MOUSE_MOVE, scrollText);
				
			// Add event listener for mouseUp ouside the scroller
			evt.target.stage.addEventListener(MouseEvent.MOUSE_UP, stopStageScroll);
		}
		
		private function stopScroll(evt:MouseEvent)
		{
			//trace("Stopped");
			scrollText(evt);
			scroller.stopDrag();	
			scroller.removeEventListener(MouseEvent.MOUSE_MOVE, scrollText);		
				
			evt.stopImmediatePropagation();
		}
		
		private function stopStageScroll(evt:MouseEvent)
		{
			//trace("Stage Stopped");
			scrollText(evt);
			scroller.stopDrag();	
			scroller.removeEventListener(MouseEvent.MOUSE_MOVE, scrollText);		
				
			evt.target.removeEventListener(MouseEvent.MOUSE_UP, stopStageScroll);
		}
		
	} // class ends	
}
