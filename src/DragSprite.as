package
{
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class DragSprite extends Sprite
	{
		public var isDrag:Boolean;
		public function DragSprite()
		{
			addEventListener(Event.ADDED_TO_STAGE,onAdd);
			addEventListener(Event.REMOVED_FROM_STAGE,onRemoveEvent);
		}
		
		protected function onAdd(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE,onAdd);
			addEventListener(MouseEvent.MOUSE_OVER,onIn);
		}
		
		protected function onRemoveEvent(e:Event=null):void
		{
			removeEventListener(MouseEvent.MOUSE_OVER,onIn);
			onOut();
		}
		protected function onIn(event:MouseEvent):void
		{
			addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			addEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			addEventListener(MouseEvent.MOUSE_MOVE,onMove);
			addEventListener(MouseEvent.MOUSE_OUT,onOut);
			addEventListener(MouseEvent.RELEASE_OUTSIDE,onRelease);
		}
		protected function onRelease(event:MouseEvent = null):void
		{
			isDrag = false;
		}		
		protected function onOut(event:MouseEvent = null):void
		{
			isDrag = false;
			removeEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
			removeEventListener(MouseEvent.MOUSE_UP,onMouseUp);
			removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
			removeEventListener(MouseEvent.MOUSE_OUT,onOut);
			removeEventListener(MouseEvent.RELEASE_OUTSIDE,onRelease);
			removeEventListener(Event.REMOVED_FROM_STAGE,onRemoveEvent);
		}
		
		protected function onMove(e:MouseEvent):void
		{
			if(isDrag){
				this.startDrag();
				if(stage)stage.quality = StageQuality.LOW;
			}
		}
		
		protected function onMouseUp(e:MouseEvent):void
		{
			isDrag = false;
			this.stopDrag();
			this.dispatchEvent(new Event("stopDrag",true));
			x = int(x);
			y = int(y);
			//if(stage)stage.quality = StageQuality.BEST;
		}
		public function onMouseDown(e:MouseEvent=null):void
		{
			if(e)isDrag = true;
		}
	}
}