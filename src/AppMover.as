package
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class AppMover extends Box
	{
		private var bgbox:AppBG;
		public function AppMover(p:DisplayObjectContainer, color:uint=0x999999,bgbox:AppBG=null)
		{
			super(p, bgbox.width, 60, color);
			this.bgbox = bgbox;
			addEventListener(MouseEvent.MOUSE_DOWN,onMoveAppWin);
			if(bgbox){
				bgbox.addEventListener(Event.RESIZE,onResize);
			}
		}
		
		protected function onResize(e:Event):void
		{
			setSize(bgbox.width,this.height);
		}
		protected function onMoveAppWin(event:MouseEvent):void
		{
			stage.nativeWindow.startMove();
		}
	}
}