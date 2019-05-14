package props.comm
{
	import com.bit101.components.HBox;
	import com.bit101.components.PushButton;

	public class PBtn extends HBox
	{
		private var ui:PushButton;
		private var _val:*;
		private var func:Function;
		private var param:Array;
		public function PBtn(btnWidth:Number,str:String,func:Function,...param)
		{
			super(null);
			this.param = param;
			this.func = func;
			ui = new PushButton(this,0,0,str,onClick); setSize(btnWidth,20);
		}
		
		private function onClick():void
		{
			if(param){
				func.apply(param);
			}else{
				func();
			}
		}
	}
}