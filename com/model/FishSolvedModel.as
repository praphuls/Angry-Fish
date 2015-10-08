package com.model  {
	import flash.display.MovieClip;
	import flash.events.Event;
	import com.utils.AddPopUps;
	
	public class FishSolvedModel extends MovieClip{
		
		private static var _instance:FishSolvedModel = new FishSolvedModel();
		
		public function FishSolvedModel() 
		{
			if(_instance)
				throw new Error("Singleton Class");
		}
		
		public static function getInstance():FishSolvedModel
		{
			return _instance;
		}
		
		//---------------
		
		private var addPops:MovieClip;
		public function get addPopName():MovieClip
		{
			return addPops;
		}
		
		public function set addPopName(val:MovieClip):void
		{
			addPops = val;
		}
		
		private var solvedFishesArr:Array = new Array();
		public var fishNameStr:String;
		
		public function get solvedFishes():String
		{
			return fishNameStr;
		}
		
		public function set solvedFishes(val:String):void
		{
			fishNameStr = val;
			solvedFishesArr.push(fishNameStr);
		}
		
		public function get solvedArr():Array
		{
			return solvedFishesArr;
		}
		
		private var fishCatStr:String;
		public function get fishCat():String
		{
			return fishCatStr;
		}
		
		public function set fishCat(val:String):void
		{
			fishCatStr = val;
		}
		
		private var popUpArr:Array = new Array();
		private var addPop:MovieClip;
		public function get popUps():MovieClip
		{
			return addPop;
		}
		public function set popUps(val:MovieClip):void
		{
			addPop = val;
			popUpArr.push(val);
		}
		public function get allPopuUps():Array
		{
			return popUpArr;
		}
		
		public function set allPopuUps(val:Array):void
		{
			popUpArr = val;
		}
		
		//---------------------
		public var fishArr:Array //= new Array();
		private var fishes:MovieClip;
		public function get fish():MovieClip
		{
			return fishes;
		}
		public function set fish(val:MovieClip):void
		{
			fishes = val;
			fishArr.push(val);
		}
		public function get fishArray():Array
		{
			return fishArr;
		}
		//------------------------
		private var totalFishArr:Array = new Array();
		private var fishesInLake:MovieClip;
		public function get fishInLake():MovieClip
		{
			return fishesInLake;
		}
		public function set fishInLake(val:MovieClip):void
		{
			fishesInLake = val;
			totalFishArr.push(val);
		}
		public function get fishInLakeArray():Array
		{
			return totalFishArr;
		}
		//------------------------
		
		private var lake:MovieClip;
		public var lakeArr:Array = new Array();
		public var lakeCount:int = 0;
		public function get lakeMc():MovieClip
		{
			return lake;
		}
		
		public function set lakeMc(val:MovieClip):void
		{
			lake = val;
			lakeArr.push(lake);
		}
		
		public function get lakeArray():Array
		{
			return lakeArr;
		}
		//-----------
		public var catMcToBeRemoved:MovieClip;
		public var mainStage:MovieClip;
	}
	
	
	
}
