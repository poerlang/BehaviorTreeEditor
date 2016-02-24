package net {
	import flash.events.Event;
	
	public class SimpleSocketMessageEvent extends Event {
		public static const MESSAGE_RECEIVED:String = "messageReceived";
		
		protected var _message:String;
		
		public function SimpleSocketMessageEvent(type:String, message:String = "", bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			this._message = message;
		}
		
		public function get message():String {
			return this._message;
		}
	}
}