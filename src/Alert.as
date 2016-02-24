package 
{
	import com.bit101.components.HBox;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.VBox;
	import com.bit101.components.Window;
	
	import flash.display.DisplayObjectContainer;
	import flash.utils.setTimeout;
	
	public class Alert extends Window
	{

		private var txt:Label;
		public static var one:Alert;
		private static var func:Function;
		public var bt1:PushButton;
		public var bt2:PushButton;
		private var offY:int;
		private var offX:int;
		private var ww:int = 450;
		public function Alert(parent:DisplayObjectContainer=null,offX:int=0,offY:int=0)
		{
			this.offX = offX;
			this.offY = offY;
			one = this;
			super(parent, 0, 0, "提示");
			setSize(ww,100);
			var vBox:VBox = new VBox(this,12,15);
			txt = new Label(vBox); txt.setSize(ww-30,70);
			txt.textField.multiline = true;
			visible = false;
			var hBox:HBox = new HBox(vBox);
			bt1 = new PushButton(hBox,0,9,"确定",onOK);
			bt2 = new PushButton(hBox,0,9,"取消",onCancel);
		}
		
		private function clear():void
		{
			visible = false;
			txt.text = "";
			func = null;
		}
		
		private function onCancel(e:*):void
		{
			if(func){
				var f:Function = func;
				setTimeout(f,50,false);
			}
			clear();
		}
		
		private function onOK(e:*):void
		{
			if(func){
				var f:Function = func;
				setTimeout(f,50,true);
			}
			clear();
		}
		public static function show(str:String,func:Function=null):void{
			Alert.func = func;
			one.txt.text = str;
			one.visible = true;
			one.draw();
			if(one.parent){
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