package props
{
	import com.bit101.components.Window;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	
	public class WindowX extends Window
	{
		public function WindowX(parent:DisplayObjectContainer=null,title:String="WindowX", defaulX:int=-1,defaulY:int=-1)
		{
			super(parent, 0, 0, title);
			var sxx:* = SO(title+"_x");
			var syy:* = SO(title+"_y");
			if(sxx){
				x=sxx;
				y=syy;
			}else{
				x=defaulX;
				y=defaulY;
			}
			savePos();
		}
		override protected function onMouseGoUp(e:MouseEvent):void
		{
			super.onMouseGoUp(e);
			savePos();
		}
		
		public function savePos():void
		{
			SO(title+"_x",x);
			SO(title+"_y",y);
		}
		public static function SO(key:String, val:*=null):*
		{
			var so:SharedObject = SharedObject.getLocal("AiEditor");
			if(val!=null) so.data[key] = val;
			return so.data[key];
		}
	}
}