package
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class DragBorder extends Sprite
	{
		public static var p2:Point=new Point;
		public static var p1:Point=new Point;
		private var bg:DisplayObject;
		public function DragBorder(p:DisplayObjectContainer,bg:DisplayObject)
		{
			super();
			this.bg = bg;
			x = bg.x;
			y = bg.y;
			p.addChild(this);
			bg.addEventListener(MouseEvent.MOUSE_DOWN,onDown);
			bg.addEventListener(MouseEvent.MOUSE_UP,onUp);
			bg.addEventListener(MouseEvent.RELEASE_OUTSIDE,onOut);
			this.mouseChildren = false;
			this.mouseEnabled = false;
		}
		
		protected function onOut(event:Event):void
		{
			onUp();
		}
		
		private function draw():void
		{
			var g:Graphics = graphics; g.clear();
			g.lineStyle(2,0x009900,.9);
			g.beginFill(0x009900,.3);
			g.drawRect(p1.x,p1.y,p2.x-p1.x,p2.y-p1.y);
		}
		
		protected function onUp(e:Event=null):void
		{
			p2.x = stage.mouseX;
			p2.y = stage.mouseY;			
			bg.removeEventListener(MouseEvent.MOUSE_UP,onUp);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
			graphics.clear();
			
			var minX:Number = Math.min(p1.x,p2.x);
			var minY:Number = Math.min(p1.y,p2.y);
			var maxX:Number = Math.max(p1.x,p2.x);
			var maxY:Number = Math.max(p1.y,p2.y);
			
			p1 = new Point(minX,minY);
			p2 = new Point(maxX,maxY);
			
			dispatchEvent(new Event(Event.SELECT));
		}
		
		protected function onMove(e:Event):void
		{
			p2 = new Point();
			p2.x = stage.mouseX;
			p2.y = stage.mouseY;			
			draw();
		}
		
		protected function onDown(e:Event):void
		{
			stage.addEventListener(MouseEvent.MOUSE_MOVE,onMove);
			bg.addEventListener(MouseEvent.MOUSE_UP,onUp);
			p1 = new Point();
			p1.x = stage.mouseX;
			p1.y = stage.mouseY;
		}
	}
}