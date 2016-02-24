package
{
	import flash.display.Sprite;
	
	public class FlashBox extends Sprite
	{
		public function FlashBox()
		{
			graphics.beginFill(0xffffdd,.9);
			graphics.drawRect(-3,-3,6,6);
			graphics.endFill();
		}
		public static var arr:Array = [];
		public static function getPoolObject():FlashBox
		{
			if(arr.length>0){
				var pop:FlashBox = arr.pop();
				return pop;
			}
			var flashBox:FlashBox = new FlashBox();
			return flashBox;
		}
		
		public function hide():void
		{
			if(parent)parent.removeChild(this);
			arr.push(this);
		}
	}
}