package com.controller.commands
{
	import com.config.ServiceConfig;
	import com.events.ApplicationEvent;
	import com.model.AppModel;
	import com.serviceLocator.AppServiceLocator;
	import flash.display.MovieClip;
	
	import com.lakeview.LakeView;
	import com.model.FishSolvedModel;
	import flash.text.ime.CompositionAttributeRange;
	
	/**
	 * ...
	 * @author ...
	 */
	public class CategorySelectorCommand extends MovieClip implements ICommand 
	{
		private var model:AppModel = AppModel.getInstance();
		private var callBackObj:MovieClip;

		private var fishModel:FishSolvedModel;
		private var lake:MovieClip;
		private var category:String;
		
		public function CategorySelectorCommand(obj:MovieClip):void
		{
			callBackObj = obj;
			category = model.categoryText;
			fishModel = FishSolvedModel.getInstance();
			lake = fishModel.lakeMc;
		}
		
		public function execute():void
		{
			if(model.fishesArray.length > 0)
				cleanLake(lake as LakeView);
				
			callBackCommand(lake as LakeView);
		}
		
		public function callBackCommand(obj:Object):void
		{
			//trace(obj,"---")
			obj.filterCategory(category);
		}
		
		private function cleanLake(target_mc:MovieClip):void
		{
			var fishesArrLen:Number = fishModel.fishArr.length;
			var fishArr:Array = fishModel.fishArr;
			
			if (fishesArrLen > 0)
			{
				for (var j:Number = 0; j < fishesArrLen; j++ )
				{
					(lake as LakeView).removeChild(fishArr[j]);
				}
				
				if(fishModel.allPopuUps.length > 0)
					fishModel.allPopuUps.pop();
			}
			
			for (var i:uint = 0; i < target_mc.numChildren; i++){
				trace (i + '.\t name:' + target_mc.getChildAt(i).name + '\t type:' + typeof (target_mc.getChildAt(i)) + '\t' + target_mc.getChildAt(i));
				target_mc.removeChild(target_mc.getChildAt(i));
			}
		}
		
	}
	
}