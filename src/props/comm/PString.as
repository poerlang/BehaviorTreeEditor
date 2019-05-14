package props.comm
{
	import com.bit101.components.HBox;
	import com.bit101.components.Label;
	
	import comm.EventData;
	
	import props.noEvent.InputTextNoEvent;

	public class PString extends HBox
	{
		public var ui:InputTextNoEvent;
		private var _val:* ="";
		private var sendEvent:Boolean = true;
		public function PString(label:String)
		{
			super(null);
			new Label(this,0,0,label);
			ui = new InputTextNoEvent(this,0,0,"",onChange);
			ui.height = 20;
		}
		public function get val():*
		{
			return _val;
		}
		public function set val(v:*):void
		{
			ui.sendEvent = false;
			_val = v;
			ui.setText(v);
			ui.sendEvent = true;
			if(sendEvent)dispatchEvent(new EventData(_val));
		}
		public function set valNoEvent(v:*):void
		{
			ui.sendEvent = false;
			_val = v;
			ui.setText(v);
			ui.sendEvent = true;
		}
		private function onChange(e:*=null):void
		{
			_val = ui.textField.text;
			if(sendEvent)dispatchEvent(new EventData(_val));
		}
	}
}