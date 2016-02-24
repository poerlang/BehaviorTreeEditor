package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class Box extends Sprite
	{
		public var bg:Bitmap;
		public var sizeW:int;
		public var sizeH:int;
		private var _color:uint;

		public function get color():uint{
			return _color;
		}

		public function set color(v:uint):void
		{
			_color = v;
			redraw();
		}

		private var canResize:Boolean;
		public var drager:Sprite;
		private var dragerSize:int;
		public function Box(p:DisplayObjectContainer,sizeW:int=30,sizeH:int=30,__color:uint=0x999999,canResize:Boolean=false,dragerSize:int = 25)
		{
			super();
			this.dragerSize = dragerSize;
			this.canResize = canResize;
			this._color = __color;
			this.sizeH = sizeH;
			this.sizeW = sizeW;
			p.addChild(this);
			bg = new Bitmap(new BitmapData(1,1,false)); addChild(bg);
			
			if(canResize){
				drager = new Sprite(); addChild(drager);
				drager.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
				drager.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
				drawDrager();
			}
			redraw();
		}
		
		protected function onMouseOut(e:MouseEvent):void
		{
			if(!press)drawDrager();
		}
		
		protected function onMouseOver(e:MouseEvent):void
		{
			drawDrager(-30);
			drager.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
		}
		
		private function drawDrager(d:int=-10):void
		{
			var dragerColor:uint = ColorUtil.Change(_color,d);
			drager.graphics.beginFill(dragerColor);
			drager.graphics.moveTo(dragerSize,0);
			drager.graphics.lineTo(dragerSize,dragerSize);
			drager.graphics.lineTo(0,dragerSize);
			drager.graphics.lineTo(dragerSize,0);
			drager.graphics.endFill();
			drager.x = sizeW-dragerSize;
			drager.y = sizeH-dragerSize;
		}
		public function setSize(w:int,h:int):void
		{
			sizeW = w;
			sizeH = h;
			redraw();
		}
		public function redraw():void
		{
			if(drager){
				drager.x = int(drager.x);
				drager.y = int(drager.y);
				sizeW =drager.x+drager.width;
				sizeH =drager.y+drager.height;
				if(lastX==drager.x && drager.y==lastY) return;
			}
			bg.bitmapData.dispose();
			AiEditor.flashStage.quality = StageQuality.LOW;
			bg.bitmapData = new BitmapData(sizeW,sizeH,false,_color);
			AiEditor.flashStage.quality = StageQuality.HIGH;
			if(drager){
				lastX = drager.x;
				lastY = drager.y;
			}
		}
		public function dispose():void
		{
			if(bg && bg.bitmapData)bg.bitmapData.dispose();
			if(parent)parent.removeChild(this);
			if(canResize){
				drager.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
				drager.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
				drager.removeEventListener(Event.ENTER_FRAME,onMouseMove);
				drager.removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			}
		}
		protected function onMouseUp(e:MouseEvent):void
		{
			press = false;
			drager.stopDrag();
			redraw();
			drawDrager();
			drager.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			drager.removeEventListener(Event.ENTER_FRAME,onMouseMove);
			drager.removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			dispatchEvent(new Event(Event.RESIZE+2));
		}
		private var press:Boolean;
		private var lastX:int;
		private var lastY:int;
		protected function onMouseMove(e:Event):void
		{
			redraw();
		}
		
		protected function onMouseDown(e:MouseEvent):void
		{
			press = true;
			drager.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			drager.addEventListener(Event.ENTER_FRAME,onMouseMove);
			drager.addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			drager.startDrag();
		}
	}
}