package props.noEvent
{
	import com.bit101.components.InputText;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	public class InputTextNoEvent extends InputText
	{
		public var sendEvent:Boolean=true;
		public function InputTextNoEvent(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, text:String="", defaultHandler:Function=null)
		{
			super(parent, xpos, ypos, text, defaultHandler);
			height = 20;
		}
		public function setText(t:String):void{
			_text = t;
		}
		override protected function onChange(e:Event):void
		{
			return;
			e.stopImmediatePropagation();
			_text = _tf.text;
			if(sendEvent){
				dispatchEvent(e);
			}
		}
	}
}