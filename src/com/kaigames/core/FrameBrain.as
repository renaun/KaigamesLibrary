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
import flash.events.Event;
import flash.utils.getTimer;

public final class FrameBrain
{
	public function FrameBrain(stage:Stage, initCallback:Function = null)
	{
		if (initCallback != null)
		{
			stage.addEventListener(Event.ENTER_FRAME, waitFewFramesHandler);
			this.initCallback = initCallback;
		}
		else
			stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
	}
	
	public var maxFrameCount:int = 100;
	private var initCallback:Function;
	
	private var executables:Vector.<ITimedExecute> = new Vector.<ITimedExecute>();
	private var executableLength:int = 0;
	private var frameSequence:int = 0;
	
	public function addExecutable(timedExecute:ITimedExecute):void
	{
		executables.push(timedExecute);
		executableLength++;
	}
	
	public function removeExecutable(timedExecute:ITimedExecute):void
	{
		for (var i:int = 0;i < executables.length;i++)
		{
			if (executables[i] == timedExecute)
			{
				executableLength--;
				executables.splice(i,1);
				return;
			}
		}
	}
	
	private function enterFrameHandler(event:Event):void
	{
		event.stopImmediatePropagation();
		
		if (executableLength == 1)
			executables[0].execute(frameSequence);
		else if (executableLength == 2)
		{
			executables[0].execute(frameSequence);
			executables[1].execute(frameSequence);
		}
		else
		{
			for (var i:int = 0;i < executableLength;i++)
				executables[i].execute(frameSequence);
		}
		frameSequence = (frameSequence < maxFrameCount) ? ++frameSequence : 0;
	}
	
	private function waitFewFramesHandler(event:Event):void
	{
		event.stopImmediatePropagation();
		frameSequence++;
		if (frameSequence > 2)
		{
			frameSequence = 0;
			ScreenUtils.setScaleMatrix(event.target as Stage);
			initCallback();
			(event.target).removeEventListener(Event.ENTER_FRAME, waitFewFramesHandler);	
			(event.target).addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
	}
}
}