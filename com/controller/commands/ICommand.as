package com.controller.commands
{
	
	/**
	 * ...
	 * @author ...
	 */
	public interface ICommand
	{
		function execute():void;
		function callBackCommand(obj:Object):void;
	}
	
}