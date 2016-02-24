package props.comm
{
	import com.bit101.components.HBox;
	import com.bit101.components.Label;
	
	import props.noEvent.InputTextNoEvent;
	import comm.EventData;

	public class PNumber extends HBox
	{
		private var ui:InputTextNoEvent;
		private var _val:* = 0;
		public var bind:*;
		private var sendEvent:Boolean = true;
		public function PNumber(label:String,defaultVal:Number = 0)
		{
			super(null);
			new Label(this,0,0,label);
			ui = new InputTextNoEvent(this,0,0,"",onChange);
			ui.text = defaultVal+"";
			_val = defaultVal;
		}
		public function get val():*
		{
			return _val;
		}
		public function set val(v:*):void
		{
			ui.sendEvent = false;
			ui.textField.text = v+"";
			_val = parseFloat(v);
			ui.sendEvent = true;
			if(sendEvent)dispatchEvent(new EventData(_val));
		}
		private function onChange(e:*):void
		{
			_val = parseFloat(ui.textField.text);
			if(bind)bind.text = _val;
			if(sendEvent)dispatchEvent(new EventData(_val));
		}
	}
}