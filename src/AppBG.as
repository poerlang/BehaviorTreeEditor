package
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	
	public class AppBG extends Box
	{
		public function AppBG(p:DisplayObjectContainer, sizeW:int=30, sizeH:int=30, color:uint=0x999999, canResize:Boolean=true, dragerSize:int=25)
		{
			var ww:* = SO("AppBG_W");
			var hh:* = SO("AppBG_H");
			if(ww>0){
				sizeW = ww;
				sizeH = hh;
			}
			super(p, sizeW, sizeH, color, canResize, dragerSize);
		}
		override protected function onMouseMove(e:Event):void
		{
			super.onMouseMove(e);
			onResize();
		}
		override protected function onMouseDown(e:MouseEvent):void
		{
			super.onMouseDown(e);
			onResize();
		}
		override protected function onMouseUp(e:MouseEvent):void
		{
			super.onMouseUp(e);
			onResize2();
		}
		protected function onResize2():void
		{
			var ww:Number = drager.x + drager.width;
			var hh:Number = drager.y + drager.height;
			SO("AppBG_W",ww);
			SO("AppBG_H",hh);
			dispatchEvent(new Event(Event.RESIZE));
		}
		protected function onResize():void
		{
			var ww:Number = drager.x + drager.width;
			var hh:Number = drager.y + drager.height;
			dispatchEvent(new Event(Event.RESIZE));
		}
		public static function SO(key:String, val:*=null):*
		{
			var so:SharedObject = SharedObject.getLocal("AiEditor");
			if(val!=null) so.data[key] = val;
			return so.data[key];
		}
	}
}