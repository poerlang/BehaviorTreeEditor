package props.comm
{
	import com.bit101.components.HBox;
	import com.bit101.components.Label;
	
	import flash.events.Event;
	
	import comm.EventData;
	
	import props.noEvent.comboBoxNoEvent;

	public class PStringComboBox extends HBox
	{
		public var ui:comboBoxNoEvent;
		private var _val:* = "";
		private var sendEvent:Boolean = true;
		public function PStringComboBox(label:String,arr:Array)
		{
			super(null);
			new Label(this,0,0,label);
			ui = new comboBoxNoEvent(this,0,0,"",arr); ui.addEventListener(Event.SELECT,onChange);
			ui.numVisibleItems = arr.length+1;
			ui.height = 20;
			ui.selectedIndex = 0;
		}
		public function get val():*
		{
			return _val;
		}
		public function set val(value:*):void
		{
			ui.sendEvent = false;
			_val = ui.selectedItem = value;
			ui.sendEvent = true;
			if(sendEvent)dispatchEvent(new EventData(_val));
		}
		public function set valNoEvent(v:*):void
		{
			ui.sendEvent = false;
			_val = ui.selectedItem = v;
			ui.sendEvent = true;
		}
		private function onChange(e:*=null):void
		{
			_val = ui.selectedItem;
			if(sendEvent)dispatchEvent(new EventData(_val));
		}
	}
}