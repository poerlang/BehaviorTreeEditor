package
{
	import com.bit101.components.TextArea;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.DataEvent;
	
	import net.SimpleSocketServer;
	
	import props.WindowX;
	
	public class ServerState extends WindowX
	{
		public var ww:int = 300;
		public var hh:int = 200;

		public var txt:TextArea;
		public static var one:ServerState;
		public function ServerState(p:DisplayObjectContainer, server:SimpleSocketServer)
		{
			one = this;
			super(p,"ServerState",976,63);
			setSize(ww,hh);
			
			txt = new TextArea(this,2,2);
			txt.width = ww-5;
			txt.height = hh-25;
			txt.text=server.toString();
			
			server.addEventListener(SimpleSocketServer.SOCKET_ALERT,function(e:DataEvent):void
			{
				txt.text += e.data+"\n";
			});
		}
	}
}