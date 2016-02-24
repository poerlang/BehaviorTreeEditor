package
{
	import com.bit101.components.HBox;
	import com.bit101.components.Label;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	public class FileX extends Sprite
	{
		public var data:Object;
		public var f:File;
		private var num:Label;
		private var desc:Label;
		private var bg:Box;
		private var hBox:HBox;
		private var colorOver:uint=0xeeeeee;
		private var colorOut:uint=0xffffff;
		private var colorSel:uint=0x00aa00;
		public function FileX(p:DisplayObjectContainer, f:File)
		{
			bg = new Box(this,270,18,colorOut); addChild(bg);
			hBox = new HBox(this);
			this.f = f;
			num = new Label(hBox); num.width=50;
			desc = new Label(hBox); desc.width=200;
			p.addChild(this);
			addEventListener(MouseEvent.MOUSE_OVER,onOver);
			addEventListener(MouseEvent.MOUSE_OUT,onOut);
			addEventListener(MouseEvent.MOUSE_DOWN,onDown);
			read();
		}
		
		protected function onDown(e:MouseEvent):void
		{
			selected = true;
		}
		
		protected function onOut(e:MouseEvent):void
		{
			if(!selected)bg.color = colorOut;
		}
		
		protected function onOver(e:MouseEvent):void
		{
			if(!selected)bg.color = colorOver;
		}
		public function read():void
		{
			data = null;
			var s:FileStream = new FileStream();
			s.open(f,FileMode.READ);
			var str:String = s.readUTFBytes(s.bytesAvailable);
			try{
				data = JSON.parse(str);
			}catch(e:Error) {
				Alert.show(f.nativePath+"的 JSON 格式不正确: \n"+e.message);
				dispose();
				return;
			}
			num.text = f.name.replace(".ai","");
			desc.text = data.desc;
			
		}
		private var _selected:Boolean;

		public function get selected():Boolean
		{
			return _selected;
		}
		public static var lastSel:FileX;
		public function set selected(v:Boolean):void
		{
			_selected = v;
			if(v==true){
				if(lastSel && lastSel!=this){
					lastSel.selected = false;
				}
				if(lastSel!=this) {
					bg.color = colorSel;
					lastSel=this;
					this.dispatchEvent(new Event(Event.SELECT,true));
				}
			}else{
				bg.color = colorOut;
			}
		}

		public function dispose(delFile:Boolean=false):void
		{
			var me:FileX = this;
			function remove():void{
				f = null;
				data = null;
				bg.dispose();
				if(parent)parent.removeChild(me);
			}
			if(delFile && f.exists){
				Alert.show("确定从硬盘删除"+f.name+"？",function(yes:Boolean):void{
					if(yes){
						try{
							f.deleteFile();
						}catch(e:Error) {
							Alert.show("删除失败："+e.message);
						}
						remove();
					}
				})
			}
			if(!delFile)remove();
		}
	}
}