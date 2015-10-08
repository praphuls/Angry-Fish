package com.controller.commands
{
	import com.lakeview.LakeView;
	import com.model.AppModel;
	import com.model.FishSolvedModel;
	import flash.display.MovieClip;
	import flash.external.ExternalInterface;
	import flash.text.ime.CompositionAttributeRange;
	
	/**
	 * ...
	 * @author ...
	 */
	public class RefreshStageCommand extends MovieClip implements ICommand
	{
		private var model:AppModel = AppModel.getInstance();
		private var callBackObj:MovieClip;
		private var fishModel:FishSolvedModel;
		private var lake:MovieClip;
		
		public function RefreshStageCommand(obj:MovieClip):void
		{
			callBackObj = obj;
			
			fishModel = FishSolvedModel.getInstance();
			lake = fishModel.lakeMc;
		}
		
		public function execute():void
		{
			var fishesArrLen:Number;;
			var fishArr:Array;
				
			if (model.fishesArray.length > 0)
			{
				fishesArrLen = fishModel.fishArr.length;
				fishArr = fishModel.fishArr;
				
				for (var i:Number = 0; i < fishesArrLen; i++ )
				{
					(lake as LakeView).removeChild(fishArr[i]);
				}
				
				if(fishModel.allPopuUps.length > 0)
					fishModel.allPopuUps.pop();
				cleanLake(lake as LakeView);
			}
			
			callBackCommand(lake as LakeView);
		}
		
		private function cleanLake(target_mc:MovieClip):void
		{
			trace(target_mc.numChildren, "In Clean Lake");
			for (var i:uint = 0; i < target_mc.numChildren; i++){
				trace (i + '.\t name:' + target_mc.getChildAt(i).name + '\t type:' + typeof (target_mc.getChildAt(i)) + '\t' + target_mc.getChildAt(i),"REFERSH...");
				target_mc.removeChild(target_mc.getChildAt(i));
			}
		}
		
		public function callBackCommand(obj:Object):void
		{
			//if(model.loader)
				//callBackObj.removeChild(model.loader);
			
			obj.refreshLake();
		}
	}
	
}