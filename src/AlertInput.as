package 
{
	import com.bit101.components.HBox;
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.VBox;
	import com.bit101.components.Window;
	
	import flash.display.DisplayObjectContainer;
	import flash.utils.setTimeout;
	
	public class AlertInput extends Window
	{

		private var txt:InputText;
		public static var one:AlertInput;
		private static var func:Function;
		public var bt1:PushButton;
		public var bt2:PushButton;
		private var offY:int;
		private var offX:int;
		public function AlertInput(parent:DisplayObjectContainer=null,offX:int=0,offY:int=0)
		{
			this.offX = offX;
			this.offY = offY;
			one = this;
			super(parent, 0, 0, "提示");
			setSize(300,90);
			var vBox:VBox = new VBox(this,12,15);
			txt = new InputText(vBox); txt.setSize(270,20);
			visible = false;
			var hBox:HBox = new HBox(vBox);
			bt1 = new PushButton(hBox,0,0,"确定",onOK);
			bt2 = new PushButton(hBox,0,0,"取消",onCancel);
		}
		
		private function clear():void
		{
			visible = false;
			txt.text = "";
			title = "提示";
			func = null;
		}
		
		private function onCancel(e:*):void
		{
			if(func){
				var f:Function = func;
				setTimeout(f,100,"");
			}
			clear();
		}
		
		private function onOK(e:*):void
		{
			if(func){
				var f:Function = func;
				setTimeout(f,100,txt.text);
			}
			clear();
		}
		public static function show(title:String="提示",func:Function=null):void{
			AlertInput.func = func;
			one.visible = true;
			if(one.parent){
				one.title = title;
				one.parent.addChild(one);
				one.x = (one.stage.stageWidth - one.width)*.5+one.offX;
				one.y = (one.stage.stageHeight - one.height)*.5+one.offY;
				if(func==null){
					one.bt2.visible = false;
				}else{
					one.bt2.visible = true;
				}
			}
		}
	}
}