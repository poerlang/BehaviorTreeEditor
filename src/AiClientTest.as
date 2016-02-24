package
{
	import flash.display.Sprite;
	
	import net.SimpleSocketClient;
	import net.SimpleSocketMessageEvent;
	
	public class AiClientTest extends Sprite
	{
		private var socket:SimpleSocketClient;
		public function AiClientTest()
		{
			init();
		}
		public function init():void
		{
			if(socket)socket.close();
			this.socket = new net.SimpleSocketClient();
			this.socket.addEventListener(SimpleSocketMessageEvent.MESSAGE_RECEIVED, onSocketMessageFromSkillEditor);
			this.socket.s.connect("127.0.0.1", 9988);
		}
		
		protected function onSocketMessageFromSkillEditor(e:SimpleSocketMessageEvent):void
		{
			trace(e.message);
		}
	}
}