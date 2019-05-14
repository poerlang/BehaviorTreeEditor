package
{
	import com.bit101.components.Label;
	
	import flash.display.DisplayObjectContainer;
	
	public class LableX extends Label
	{
		public function LableX(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, text:String="")
		{
			super(parent, xpos, ypos, text);
		}
		private var _color:uint = 0xaaaaaa;

		public function get color():uint
		{
			return _color;
		}

		public function set color(v:uint):void
		{
			_color = v;
			_tf.textColor = _color;
			_tf.mouseEnabled = false;
		}

	}
}