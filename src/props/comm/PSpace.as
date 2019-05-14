package props.comm
{
	import com.bit101.components.HBox;
	import com.bit101.components.Panel;

	public class PSpace extends HBox
	{
		private var ui:Panel;
		private var _val:*;
		public function PSpace(defaultHeight:Number = 5,theAlpha:Number=.1)
		{
			super(null);
			ui = new Panel(this,0,0); ui.setSize(defaultHeight,defaultHeight); ui.alpha = theAlpha;
		}
	}
}