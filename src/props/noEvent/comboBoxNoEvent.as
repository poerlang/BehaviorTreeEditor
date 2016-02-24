package props.noEvent
{
	import com.bit101.components.ComboBox;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	public class comboBoxNoEvent extends ComboBox
	{
		public var sendEvent:Boolean=true;

		public function comboBoxNoEvent(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, defaultLabel:String="", items:Array=null)
		{
			super(parent, xpos, ypos, defaultLabel, items);
			_list.listItemClass = ListItemX;
		}
		override protected function onSelect(e:Event):void
		{
			_open = false;
			_dropDownButton.label = "+";
			if(stage != null && stage.contains(_list))
			{
				stage.removeChild(_list);
			}
			setLabelButtonLabel();
			if(sendEvent){
				dispatchEvent(e);
			}
		}
		
	}
}