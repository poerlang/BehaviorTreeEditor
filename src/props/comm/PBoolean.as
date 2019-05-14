package props.comm
{
	import com.bit101.components.CheckBox;
	import com.bit101.components.HBox;
	import comm.EventData;

	public class PBoolean extends HBox
	{
		private var ui:CheckBox;
		private var _val:* = false;
		public var bind:*;
		public var sendEvent:Boolean = true;
		public function PBoolean(label:String,defaultVal:Boolean = true)
		{
			super(null);
			ui = new CheckBox(this,0,0,label,onChange);
			ui.selected = defaultVal;
			_val = defaultVal;
		}
		public function get val():*
		{
			return _val;
		}
		public function set val(value:*):void
		{
			_val = ui.selected = value;
			if(sendEvent)dispatchEvent(new EventData(_val));
		}
		private function onChange(e:*):void
		{
			_val = ui.selected;
			if(bind)bind.text = _val;
			if(sendEvent)dispatchEvent(new EventData(_val));
		}
	}
}