package com.controller.commands
{
	import com.config.ServiceConfig;
	import com.events.ApplicationEvent;
	import com.model.AppModel;
	import com.serviceLocator.AppServiceLocator;
	import com.serviceLocator.GetCategoriesServiceLocator;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GetCategoriesCommand extends MovieClip implements ICommand
	{
		private var model:AppModel = AppModel.getInstance();
		private var callBackObj:MovieClip;
		
		public function GetCategoriesCommand(obj:MovieClip):void
		{
			callBackObj = obj;
		}
		
		public function execute():void
		{
			var service:GetCategoriesServiceLocator = new GetCategoriesServiceLocator(this, ServiceConfig.GET_CATEGORY_SERVICE);
		}
		
		public function callBackCommand(obj:Object):void
		{
			//trace(obj,"---")
			
			model.categoriesArray = new Array();
			
			var categories:Array = obj.CategoryList;
	
			for (var key:Object in categories)
			{
				var categoriesObj:Object = new Object();
				
				categoriesObj.categoryID = categories[key].CategoryID;		
				categoriesObj.categoryName = categories[key].CategoryName;
				
				model.categoriesArray.push(categoriesObj);
			}
			
			callBackObj.notifyUpdate(new ApplicationEvent(ApplicationEvent.GET_CATEGORIES_EVENT));
		}
	}
	
}