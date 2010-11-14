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
	import flash.events.DataEvent;
	import flash.net.GroupSpecifier;
	
	import mx.events.FlexEvent;
	
	import org.devboy.hydra.HydraChannel;
	import org.devboy.hydra.HydraEvent;
	import org.devboy.hydra.HydraService;
	import org.devboy.hydra.commands.HydraCommand;
	import org.devboy.hydra.commands.HydraCommandEvent;
	import org.devboy.hydra.commands.IHydraCommand;
	import org.devboy.hydra.commands.IHydraCommandCreator;
	import org.devboy.hydra.commands.PingCommand;
	import org.devboy.hydra.users.HydraUserEvent;
	
	public class MulticastConnection
	{
		
		public static const TYPE_CONNECT:String = "typeConnect";
		public static const TYPE_DISCONNECT:String = "typeDisconnect";
		public static const TYPE_USER:String = "typeUser";
		public static const TYPE_MESSAGE:String = "typeMessage";
		
		public function MulticastConnection()
		{
		}

		private var hydraConn:HydraService;
		private var multicastChatChannel:HydraChannel;
		public var userName:String = "";
		public var callback:Function;
		
		public function connect(serviceName:String, groupName:String = "default", address:String = "225.225.0.1:35353"):void
		{
			if (!hydraConn || !hydraConn.connected)
			{
				if (userName == "")
					userName = (new Date()).getTime()+"";
				
				hydraConn = new HydraService(serviceName, "rtmfp:");
				hydraConn.addEventListener(HydraEvent.SERVICE_CONNECT_SUCCESS, serviceHandler);
				hydraConn.addEventListener(HydraEvent.SERVICE_CONNECT_CLOSED, serviceHandler);
				hydraConn.addEventListener(HydraEvent.SERVICE_CONNECT_FAILED, serviceHandler);
				
				var specifier:GroupSpecifier = new GroupSpecifier(serviceName + "/" + groupName);
				specifier.postingEnabled = true;
				specifier.ipMulticastMemberUpdatesEnabled = true;
				specifier.addIPMulticastAddress(address);
				
				multicastChatChannel = new HydraChannel(hydraConn, "pqch", specifier, true);
				multicastChatChannel.addEventListener(HydraUserEvent.USER_CONNECT, userHandler);
				multicastChatChannel.addEventListener(HydraUserEvent.USER_DISCONNECT, userHandler);
				multicastChatChannel.addEventListener(HydraEvent.CHANNEL_CONNECT_FAILED, serviceHandler);
				multicastChatChannel.addEventListener(HydraEvent.CHANNEL_CONNECT_REJECTED, serviceHandler);
				multicastChatChannel.addEventListener(HydraCommandEvent.COMMAND_RECEIVED, commandMessageHandler);
				multicastChatChannel.addEventListener(HydraCommandEvent.COMMAND_SENT, commandMessageHandler);
								
				hydraConn.addChannel(multicastChatChannel);
				hydraConn.connect(userName);
			}
			else
			{
				hydraConn.netConnection.close();
			}
		}
		
		public function addCommandFactory(factory:IHydraCommandCreator):void
		{
			hydraConn.commandFactory.addCommandCreator(factory);
		}
		
		protected function serviceHandler(event:HydraEvent):void
		{
			//output("msg", "Service: " + event.type);
			if (event.type == HydraEvent.SERVICE_CONNECT_FAILED
				|| event.type == HydraEvent.SERVICE_CONNECT_CLOSED)
			{
				callback(MulticastConnection.TYPE_DISCONNECT,"");
				//currentState = "disconnected";
			}
			else if (event.type == HydraEvent.SERVICE_CONNECT_SUCCESS)
			{
				callback(MulticastConnection.TYPE_CONNECT,"");
				//currentState = "connected";
			}
		}
		protected function userHandler(event:HydraUserEvent):void
		{
			output(MulticastConnection.TYPE_USER, {userTimestamp: event.user.name, type: event.type});
		}
		
		public function sendMessage(command:IHydraCommand):void
		{
			multicastChatChannel.sendCommand(command);
		}
		
		public function commandMessageHandler(event:HydraCommandEvent):void
		{
			output(MulticastConnection.TYPE_MESSAGE, event.command);
		}
		
		private function output(type:String, obj:Object):void
		{
			callback(type, obj);
			//txtHistory.text += txt+"\n";
		}
		
		public function destroy():void
		{
			if (hydraConn)
				hydraConn.netConnection.close();
		}
		
	}
}