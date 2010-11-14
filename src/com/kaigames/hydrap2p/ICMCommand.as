/*
* Copyright 2010 (c) Renaun Erickson renaun.com
*
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the "Software"), to deal in the Software without
* restriction, including without limitation the rights to use,
* copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the
* Software is furnished to do so, subject to the following
* conditions:
*
* The above copyright notice and this permission notice shall be
* included in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
* HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
* OTHER DEALINGS IN THE SOFTWARE.
*/
package com.kaigames.hydrap2p
{
	import org.devboy.hydra.commands.HydraCommand;

	/**
	 * @author Renaun Erickson - renaun.com
	 */
	public class ICMCommand extends HydraCommand
	{
		
		public static const COMMAND_BG:String = "bg";
		public static const COMMAND_CLEAR:String = "clear";
		public static const COMMAND_GESTURE:String = "gesture";
		public static const COMMAND_START_GESTURE:String = "gestureStart";
		public static const COMMAND_STOP_GESTURE:String = "gestureStop";
		public static const COMMAND_MULTITOUCH:String = "multitouch";
		public static const COMMAND_START_MULTITOUCH:String = "multitouchStart";
		public static const COMMAND_STOP_MULTITOUCH:String = "multitouchStop";
		public static const COMMAND_ACCELEROMETER:String = "accelerometer";
		public static const COMMAND_START_ACCELEROMETER:String = "accelerometerStart";
		public static const COMMAND_STOP_ACCELEROMETER:String = "accelerometerStop";
		public static const COMMAND_DATA:String = "data";
		
		public static const TYPE:String = "com.kaigames.hydrap2p.ICMCommand.TYPE";
		
		public function ICMCommand() 
		{
			super(ICMCommand.TYPE);
		}
		
		protected var _info:Object = {icmType: "", id: "",sequence: 0, data: new Object()};
		
		public var icmType:String = "";
		public var id:String = "";
		public var sequence:int = 0;
		public var data:Object = {};
		
		override public function get info():Object
		{
			_info.icmType = icmType;
			_info.id = id;
			_info.sequence = sequence;
			_info.data = data;
			return _info;
		}

	}
}
