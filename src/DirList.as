package
{
	import com.bit101.components.HBox;
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	import com.bit101.components.Style;
	import com.bit101.components.TextArea;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.filesystem.File;
	import flash.net.SharedObject;
	import flash.utils.setTimeout;
	
	public class DirList extends Sprite
	{

		private var inputText:InputText;

		private var textArea:TextArea;

		private var so:SharedObject;

		private var inputText2:InputText;
		private var inputText3:InputText;
		public function DirList()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			Style.embedFonts = false;
			Style.fontName = "Arial";
			Style.fontSize = 14;
			
			inputText = new InputText(this,0,0,"",onChange); inputText.setSize(500,20);
			var hBox:HBox = new HBox(this,0,25);
			
			new Label(hBox,0,0,"将");
			inputText2 = new InputText(hBox,0,0,".mp3",searchDirAndListFiles); inputText2.setSize(50,20);
			new Label(hBox,0,0,"替换成");
			inputText3 = new InputText(hBox,0,0,"",searchDirAndListFiles); inputText3.setSize(50,20);
			
			textArea = new TextArea(this,0,55); textArea.setSize(500,400);
			so = SharedObject.getLocal("sounddir");
			if(!so.data.dir){
				so.data.dir = "E:\\client\\WSSG\\res\\asset\\sounds";
			}
			inputText.text = so.data.dir;
			
			searchDirAndListFiles();
		}
		
		private function searchDirAndListFiles(e:*=null):void
		{
			var f:File = new File(so.data.dir);
			if(!f.exists || !f.isDirectory){
				textArea.text = "";
				setTimeout(function():void{textArea.text = "目录不存在，或路径不存在，请重新指定路径";},200);
				return;
			}
			var list:Array = f.getDirectoryListing();
			var out:String = "[";
			for (var i:int = 0; i < list.length; i++) 
			{
				out+="'"+(list[i] as File).name.replace(inputText2.text,inputText3.text)+"'";
				if(i+1!=list.length){
					out+=",";
				}else{
					out+="]";
				}
			}
			trace(out);
			textArea.text = out;
		}
		
		private function onChange(e:*):void
		{
			var so:SharedObject = SharedObject.getLocal("sounddir");
			so.data.dir = inputText.text;
			searchDirAndListFiles();
		}
	}
}