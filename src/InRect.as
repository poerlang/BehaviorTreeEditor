package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;

	[SWF(width="1000",height="600")]
	public class InRect extends Sprite
	{
		private var world:Sprite;

		private var mouse:Yuan;
		public function InRect()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			world = new Sprite(); world.x = 200; world.y = 500; world.scaleY = -1;
			addChild(world);
			
			//坐标轴
			drawLine(-1000,0,1000,0);
			drawLine(0,-1000,0,1000);
			
			//矩形
			drawYuan(0,0);
			drawLine(0,0,400,320);
			drawLine(0,0,-180,350);
			
			//鼠标（在范围内时变绿，在范围外时变红）
			mouse = drawYuan(0,0);
			addEventListener(Event.ENTER_FRAME,onFrame);
		}
		
		protected function onFrame(event:Event):void
		{
			var mousePoint:Point = new Point(stage.mouseX,stage.mouseY);
			var p:Point = world.globalToLocal(mousePoint);
			mouse.x = p.x;
			mouse.y = p.y;
			
			var m:Matrix2D = new Matrix2D(400,320,-180,350);
			var mi:Matrix2D = m.Invert();
			check(p,mi);
		}
		
		private function check(pp:Point,m:Matrix2D):void
		{
			var p:Point = m.VectorLeftdot(pp);
			if(p.x>0 && p.x<1){
				if(p.y>0 && p.y<1){
					trace("mouse in rect");
					mouse.toGreen();
					return;
				}
			}
			mouse.toRed();
			trace("not in");
		}
		
		private function drawLine(x1:int,y1:int,x2:int,y2:int,color:uint = 0xff0000):void
		{
			world.graphics.lineStyle(1,color);
			world.graphics.moveTo(x1,y1);
			world.graphics.lineTo(x2,y2);
		}
		private function drawYuan(x1:Number,y1:Number):Yuan
		{
			var yuan:Yuan = new Yuan();
			yuan.x = x1;
			yuan.y = y1;
			world.addChild(yuan);
			
			var txt:TextField = new TextField();
			txt.selectable = false;
			txt.width = 200;
			txt.height = 20;
			txt.textColor = 0x000000;
			txt.text = "("+x1+","+y1+")";
			var p:Point = world.localToGlobal(new Point(x1,y1));
			txt.x = p.x;
			txt.y = p.y;
			addChild(txt);
			
			return yuan;
		}
	}
}
import flash.display.Sprite;
import flash.geom.Point;

class Yuan extends Sprite{
	private const Red:uint = 0xff0000;
	private const Green:uint = 0x009900;
	private var r:Number;
	public function Yuan(r:Number=15):void{
		this.r = r;
		toRed();
	}
	private function draw(color:uint):void
	{
		graphics.clear();
		graphics.beginFill(color,0.7);
		graphics.drawCircle(0,0,r);
		graphics.endFill();
	}
	public function toRed():void{
		draw(Red);
	}
	public function toGreen():void{
		draw(Green);
	}
}
class Matrix2D {
	//第一行
	public var x1:Number;//a
	public var y1:Number;//b
	
	//第二行
	public var x2:Number;//c
	public var y2:Number;//d
	public function Matrix2D(x1:Number,y1:Number,x2:Number,y2:Number):void{
		this.x1 = x1;
		this.y1 = y1;
		this.x2 = x2;
		this.y2 = y2;
	}
	public function VectorLeftdot(p:Point):Point{
		return new Point(p.x*x1+p.y*x2  ,  p.x*y1+p.y*y2);
	}
	public function Invert():Matrix2D{
		var m:Matrix2D = new Matrix2D(0,0,0,0);
		var det:Number = this.x1 * this.y2 - this.y1 * this.x2;
		m.x1 =    (this.y2 / det);
		m.y1 =  - (this.y1 / det);
		m.x2 =  - (this.x2 / det);
		m.y2 =    (this.x1 / det);
		return m;
	}
	public function toString():String{
		return "( "+x1+" , "+y1+" , "+x2+" , "+y2+" )";
	}
}