package net
{
	import flash.events.DataEvent;
	import flash.events.EventDispatcher;
	import flash.events.ServerSocketConnectEvent;
	import flash.net.ServerSocket;
	import flash.net.Socket;

	/**
	 * AS3版本的 Socket服务器，为了简化，没有对多个客户端进行管理，只针对一个客户端，
	 * 也没有用二进制去实现收发，目前只支持字符串，消息之间用"\n"分割。默认侦听 127.0.0.1:9999
	 * 具体用法:																								<br><br>
	 * 
	 *  var s = new SocketServer();																			<br>
	 * 		s.start();																						<br><br>
	 * 
	 * 如果觉得有必要，也可以对 SocketServer产生的Err信息进行侦听：<br><br>
	 * 
	 * 		s.addEventListener(SimpleSocketServer.SOCKET_ALERT,function(e:DataEvent):void			<br>
	 *		{																								<br>
	 *			trace(e.data);																				<br>
	 *		});																								<br>
	 */
	public class SimpleSocketServer extends EventDispatcher
	{
		private var clientSocket:SimpleSocketClient;
		private var serverSocket:ServerSocket;
		
		public static var one:SimpleSocketServer;
		public function SimpleSocketServer(){
			one = this;
		}
		public function start(IP:String="127.0.0.1",PORT:int=9999):void{
			stop();
			if(ServerSocket && ServerSocket.isSupported){
				//
			}else{
				alert("当前设备（或SWF）不支持ServerSocket，无法启动ServerSocket");
				return;
			}
			serverSocket = new ServerSocket();//关闭的serverSocket无法再重新打开，所以必须每次都 new 新的。
			serverSocket.bind(PORT, IP);
			serverSocket.addEventListener(ServerSocketConnectEvent.CONNECT, onConnectServer);
			serverSocket.listen();
		}
		
		public function get running():Boolean{
			if(!serverSocket) return false;
			return serverSocket.listening;
		}
		
		protected function onConnectServer(event:ServerSocketConnectEvent):void
		{
			clientSocket = new SimpleSocketClient(event.socket as Socket);
			clientSocket.addEventListener(SimpleSocketMessageEvent.MESSAGE_RECEIVED, receive);
			alert( "新的客户端连接" + clientSocket.s.remoteAddress + ":" + clientSocket.s.remotePort );
		}
		
		/**发送**/
		public function send(str:String):void{
			if(clientSocket){
				clientSocket.send(str);
			}else{
				alert("暂无客户端连接，等待中...");
			}
		}
		
		public static var SOCKET_ALERT:String = "SOCKET_ALERT";
		public var onReceive:Function;
		private function alert(str:String):void
		{
			dispatchEvent(new DataEvent(SOCKET_ALERT,false,false,str));
		}
		
		/**接收**/
		protected function receive(e:SimpleSocketMessageEvent):void
		{
//			var date:Date = new Date();
//			alert("收到客户端消息："+date.hoursUTC + ":" + date.minutesUTC + ":" + date.secondsUTC + " 内容为: " + e.message);
			if(onReceive){
				onReceive(e.message);
			}
		}
		
		/**停止（清理）**/
		public function stop():void
		{
			if(serverSocket){
				if(serverSocket.listening){
					serverSocket.close();
				}
				serverSocket.removeEventListener(ServerSocketConnectEvent.CONNECT, onConnectServer);
				serverSocket = null;
			}
			if(clientSocket){
				clientSocket.removeEventListener(SimpleSocketMessageEvent.MESSAGE_RECEIVED, receive);
				clientSocket.close();
			}
		}
		override public function toString():String
		{
			return "正在侦听"+serverSocket.localAddress+":"+serverSocket.localPort+"\n";
		}
	}
}