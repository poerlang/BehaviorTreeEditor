package comm
{
	import flash.events.Event;
	
	public class EventData extends Event
	{
		public static const EVENT_DATA:String = "EVENT_DATA";
		public var data:*;
		public function EventData(data:*, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(EVENT_DATA, bubbles, cancelable);
			this.data = data;
		}
		override public function clone():Event
		{
			return new EventData(data);
		}
	}
}