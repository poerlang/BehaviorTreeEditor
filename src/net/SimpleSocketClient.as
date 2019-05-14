package net {
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;

	/**
	 * 简化版Socket客户端，只收发字符串。配合SocketServer使用。使用方法：						<br>
	 *  var c = new SimpleSocketClient();													<br>
	 *		c.addEventListener(SimpleSocketMessageEvent.MESSAGE_RECEIVED, handle);			<br>
	 *		c.s.connect("127.0.0.1", 9999);													<br>
	 * 
	 * 		function handle(e:SimpleSocketMessageEvent):void {								<br>
	 *				trace("收到数据"e.message);												<br>
	 *		}																				<br>
	 */
	public class SimpleSocketClient extends EventDispatcher {
		protected var _message:String;
		public var s:Socket;
		public static var SPLITER:String = "_$_";
		public function SimpleSocketClient(warpSocket:Socket=null) {
			super();
			this._message = "";
			
			s = warpSocket ? warpSocket  :  new Socket();
			
			s.addEventListener(Event.CONNECT, socketConnected);
			s.addEventListener(Event.CLOSE, socketClosed);
			s.addEventListener(ProgressEvent.SOCKET_DATA, socketData);
			s.addEventListener(IOErrorEvent.IO_ERROR, socketError);
			s.addEventListener(SecurityErrorEvent.SECURITY_ERROR, socketError);
		}
		public static var SOCKET_ALERT:String = "SOCKET_ALERT";
		private function alert(str:String):void
		{
			dispatchEvent(new DataEvent(SOCKET_ALERT,false,false,str));
		}
		protected function socketData(event:ProgressEvent):void {
			var str:String = s.readUTFBytes(s.bytesAvailable);
			
			//For this example, look for \n as a message terminator
			var messageParts:Array = str.split(SPLITER);
			
			//There could be multiple messages or a partial message, 
			//pass on complete messages and buffer any partial
			for (var i:int = 0; i < messageParts.length; i++) {
				this._message += messageParts[i];
				if (i < messageParts.length - 1) {
					this.notifyMessage(this._message);
					this._message = "";
				}
			}
		}
		
		protected function notifyMessage(value:String):void {
			this.dispatchEvent(new SimpleSocketMessageEvent(SimpleSocketMessageEvent.MESSAGE_RECEIVED, value));
		}
		
		protected function socketConnected(event:Event):void {
			alert("【Clinet】Socket connected");
		}
		
		protected function socketClosed(event:Event):void {
			alert("【Clinet】Connection was closed");
			//TODO: Reconnect if needed
		}
		
		protected function socketError(event:Event):void {
			alert("【Clinet】An error occurred:"+ event);
		}
		
		public function close():void
		{
			if(s && s.connected){
				s.close();
				s = null;
			}
		}
		
		public function send(str:String):void
		{
			if(s && s.connected){
				s.writeUTFBytes(str + SPLITER);
				s.flush();
			}else{
				trace("【Clinet】not connected");
			}
		}
	}
}