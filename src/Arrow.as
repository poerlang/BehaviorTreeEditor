package
{
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class Arrow extends Sprite
	{
		private var color:uint = 0x333333;
		public function Arrow(d1:DisplayObject,d2:DisplayObject)
		{
			draw(d1,d2);
		}
		
		public function draw(d1:DisplayObject,d2:DisplayObject):void
		{
			var g:Graphics = graphics;
			g.clear();
			var p2:Point = new Point();
			var p1:Point = new Point();
			p2.x = d2.x+d2.width*.5;
			p2.y = d2.y+d2.height*.5;
			p1.x = d1.x+d1.width*.5;
			p1.y = d1.y+d1.height*.5;
			g.lineStyle(1,color);
			g.moveTo(p1.x,p1.y);
			g.lineTo(p2.x,p2.y);
		}
	}
}