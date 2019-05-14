package props.noEvent
{
	import com.bit101.components.Text;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	public class InputTextAreaNoEvent extends Text
	{
		public var sendEvent:Boolean=true;
		public function InputTextAreaNoEvent(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, text:String="", defaultHandler:Function=null)
		{
			super(parent, xpos, ypos, text);
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