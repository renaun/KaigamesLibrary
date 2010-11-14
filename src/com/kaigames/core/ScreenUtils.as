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
package com.kaigames.core
{
	import flash.display.Stage;
	import flash.display.StageOrientation;
	import flash.geom.Matrix;
	import flash.system.Capabilities;

	public class ScreenUtils
	{
		public static var needsScaling:Boolean = false;
		public static var matrix:Matrix;
		public static var scale:Number = 1;
		public static var applicationWidth:Number = 1;
		public static var applicationHeight:Number = 1;
		
		public static function setScaleMatrix(stage:Stage, screenSizeThreshold:int = 5, screenDPIThreshold:int = 200, orientation:String = "land"):void
		{
			applicationWidth = stage.stageWidth;
			applicationHeight = stage.stageHeight;
			if (Capabilities.os.search("iPhone") > -1)
			{
				if ("land")
				{
					applicationWidth = Math.max(Capabilities.screenResolutionX, Capabilities.screenResolutionY);
					applicationHeight = Math.min(Capabilities.screenResolutionX, Capabilities.screenResolutionY);
				}
				else
				{
					applicationWidth = Math.min(Capabilities.screenResolutionX, Capabilities.screenResolutionY);
					applicationHeight = Math.max(Capabilities.screenResolutionX, Capabilities.screenResolutionY);
				}
			}
			
			var screenX:int = Capabilities.screenResolutionX;
			var screenY:int = Capabilities.screenResolutionY;
			var dpi:int = Capabilities.screenDPI;
			var screenSize:Number = Math.sqrt((screenX*screenX) + (screenY*screenY))/dpi;
			if (screenSize < 5 && dpi < screenDPIThreshold)
			{
				needsScaling = true;
				matrix = new Matrix(0.6, 0, 0, 0.6, 0, 0);
				scale = 0.6;
			}
		}
	}
}