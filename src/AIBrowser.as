package
{
	import com.bit101.components.HBox;
	import com.bit101.components.PushButton;
	import com.bit101.components.ScrollPane;
	import com.bit101.components.VBox;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	import props.WindowX;
	
	public class AIBrowser extends WindowX
	{
		private var path:String;

		private var html:VBox;
		private var menu:HBox;
		private var body:VBox;

		private var dir:Object;
		public static var one:AIBrowser;
		public function AIBrowser(parent:DisplayObjectContainer=null,title:String="Window")
		{
			one = this;
			super(parent,"AIBrowser",976,268);
			html = new VBox(this,2,2);
			menu = new HBox(html,2,2);
			var scroll:ScrollPane = new ScrollPane(html);
			scroll.width = 200-5;
			scroll.height=400-50; scroll.autoHideScrollBar = true;
			body = new VBox(scroll,2,2); body.spacing = 0;
			
			new PushButton(menu,0,0,"新建",onNew);
			new PushButton(menu,0,0,"删除",onDel);
			
			width = 200;
			height = 400;
			this.addEventListener(Event.SELECT,onFileSel);
		}
		
		private function onDel(e:*):void
		{
			NodeContainer.one.clear();
			clear(true);
		}
		
		private function onNew(e:*):void
		{
			AlertInput.show("请填写文件名，如“19.ai”或者“19”，后缀名可略 ",function(fileName:String):void{
				fileName = fileName.replace(".ai","");
				AlertInput.show("请填写描述，如 “XXXBoss的Ai，70%以下血时暴走”",function(descStr:String):void{
					var root:Object = getNewNodeOb();
					root.desc = descStr;
					
					NodeContainer.one.clear();
					save(root,fileName);
					refresh();
				});
			});
		}
		
		public function refresh():void
		{
			clear();
			show(path);
			sel(lastFileName);
		}
		
		private function sel(fileName:String):void
		{
			if(fileName=="") return;
			//TODO: LOAD TXT FILE
		}
		
		private function clear(delSel:Boolean=false):void
		{
			if(delSel){
				for (var j:int = 0; j < body.numChildren; j++) {
					var ff:Object = body.getChildAt(j) as Object;
					if(ff.selected){
						ff.dispose(true);
						return;
					}
				}
			}
			var len:int = body.numChildren;
			for (var i:int = 0; i < len; i++) {
				var f:Object = body.getChildAt(0) as Object;
					if(f.selected)f.selected=false;
					f.dispose();
			}
		}
		
		private function save(root:Object, fileName:String):void
		{
			try{
				var s:String = JSON.stringify(root);
				if(!dir.exists){
					Alert.show("目录"+dir+"不存在");return;
				}
				var f:Object = load(fileName+".ai");
//				var fs:FileStream = new FileStream();
//				fs.open(f,FileMode.WRITE);
//				fs.writeUTFBytes(s);
//				fs.close();
			}catch(e:Error) {
				Alert.show("保存时出错："+e.message);
			}
		}
		
		private function load(param0:String):Object
		{
			// TODO Auto Generated method stub
			return null;
		}
		
		protected function onFileSel(e:Event):void
		{
//			var fx:Object = e.target as Object;
//			if(!fx) return;
//			showAiTree(fx);
		}
		
		private function showAiTree(fx:Object):void
		{
			lastFileName = fx.f.name;
//			NodeContainer.one.showAiTree(fx);
		}
		public var lastFileName:String="";
		private function getNewNodeOb():Object{
			var ob:Object = {};
			ob.desc = "";
			ob.childs = [];
			ob.name = "根节点";
			ob.sel = "All";
			ob.x = 100;
			ob.y = 100;
			return ob;
		}
		public function show(path:String):void
		{
			this.path = path;
			var files:Vector.<Object>;
			files = new Vector.<Object>;
			
			dir = new Object();//todo
			if(!dir.exists){
				Alert.show(dir+"目录不存在，请检查");
				return;
			}
			
			var count:int;
			var arr:Array = dir.getDirectoryListing();
			for (var i:int = 0; i < arr.length; i++) {
				var f:Object = arr[i] as Object;
				if(f.extension!="ai") continue;
				count++;
				files.push(f);
			}
			files.sort(function(f1,f2):int{
				var n1:int = parseInt(f1.name.replace(".ai"));
				var n2:int = parseInt(f2.name.replace(".ai"));
				if(n1>n2) return 1;
				if(n1<n2) return -1;
				return 0;
			});
			if(count==0){
				Alert.show(dir+"目录下没有找到任何ai文件");
				return;
			}
			
			for (var j:int = 0; j < files.length; j++) {
				var fx:Object = new Object();//todo
			}
		}
	}
}