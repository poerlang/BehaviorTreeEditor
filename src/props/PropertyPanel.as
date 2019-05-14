package props
{
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.bit101.components.VBox;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	
	public class PropertyPanel extends WindowX
	{
		public static var one:PropertyPanel;
		private var body:VBox;
		private var delBtn:PushButton;
		private var ob:DisplayObject;
		public function PropertyPanel(p:DisplayObjectContainer=null)
		{
			one = this;
			super(p,"★    属性",752,63);
			if(p) p.addChild(this);
			var panel:Panel = new Panel(this,6,6);
			panel.shadow = false;
			panel.setSize(220-12,350-31);
			body = new VBox(panel);
			
			setSize(220,350);
//			delBtn = new PushButton(null,0,0,"删除",onDelete); delBtn.setSize(43,20);
		}
		
		private function onDelete(e:*):void
		{
			if(body.numChildren) body.removeChildren();
			if(ob && ob.parent){
				ob.parent.removeChild(ob);
			}
		}
		public function show(ob:DisplayObject,...arr):void
		{
			this.ob = ob;
			if(body.numChildren) body.removeChildren();
			for (var i:int = 0; i < arr.length; i++) 
			{
				body.addChild(arr[i]);
			}
//			body.addChild(delBtn);
		}
	}
}