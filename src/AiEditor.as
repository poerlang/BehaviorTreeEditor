package
{
	import com.bit101.components.HBox;
	import com.bit101.components.HSlider;
	import com.bit101.components.InputText;
	import com.bit101.components.PushButton;
	import com.bit101.components.Style;
	import com.bit101.components.VBox;
	
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.net.SharedObject;
	import flash.utils.getTimer;
	
	import net.SimpleSocketServer;
	
	import props.PropertyPanel;
	
	import tryai.ActorMgr;
	import tryai.AiUpdateMgr;
	import tryai.smlgame.RenderOB;
	import tryai.smlgame.Scene;
	import tryai.smlgame.SmlGameSetupWin;
	import tryai.smlgame.ActorData;

	[SWF(width="1280",height="768",frameRate="60")]
	public class AiEditor extends Sprite
	{
		private var btAlwaysOnTop:PushButton;

		private var nc:NodeContainer;

		public static var flashStage:Stage;

		public var server:SimpleSocketServer;

		private var aiPath:InputText;

		private var browser:AIBrowser;

		private var serverState:ServerState;

		public static var aiFileDesc:InputText;
		public static var one:AiEditor;

		private var propertyPanel:PropertyPanel;

		private var appWinAlpha:HSlider;

		public static var tryMode:PushButton;

		private var smlGameWin:SmlGameSetupWin;
		private var game:Scene;
		public function AiEditor()
		{
			one = this;
			flashStage = stage;
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			Style.embedFonts = false;
			Style.fontName = "Consolas";
			Style.fontSize = 12;
			
			var bg:AppBG = new AppBG(this,1280,768,0x999999);
			new AppMover(this,0x333333,bg);
			
			nc = new NodeContainer(); addChild(nc);
			var dragBorder:DragBorder = new DragBorder(this,bg); dragBorder.addEventListener(Event.SELECT,onSel);
			
			var menuContainer:VBox = new VBox(this,5,5); menuContainer.mouseEnabled = false;// menuContainer.mouseChildren = false;
			var m1:HBox = new HBox(menuContainer); 
			var m2:HBox = new HBox(menuContainer); m2.mouseEnabled = false;// m2.mouseChildren = false;
			var m3:HBox = new HBox(menuContainer);
			
			var btAdd:PushButton = new PushButton(m1,0,0,"添加",onAdd,0xffeeaa);
			var btLink:PushButton = new PushButton(m1,0,0,"连接",onLink);
			var btBreak:PushButton = new PushButton(m1,0,0,"断开",onBreak);
			var btDel:PushButton = new PushButton(m1,0,0,"删除",onDel);
			var btSave:PushButton = new PushButton(m1,0,0,"保存",onSave,0xaaffdd);
			tryMode = new PushButton(m1,0,0,"练习模式",onTry); tryMode.toggle = true; tryMode.selected=false;
			//new PushButton(m1,0,0,"不要点我",dontTouchMe);
			
			btAlwaysOnTop = new PushButton(m1,0,0,"总在最前",alwaysOnTop);
			btAlwaysOnTop.toggle = true;
			btAlwaysOnTop.selected = stage.nativeWindow.alwaysInFront = false;
			
			
			aiPath = new InputText(m1,0,0,"E:\\wssg\\client\\raw\\webres\\asset\\ai",onAiPathChange); aiPath.width=300;
			var aipath:String = SO("aiPath");
			if(aipath){
				aiPath.text = aipath;
			}
			
			new PushButton(m1,0,0,"浏览目录",onBrowser);
			new PushButton(m1,0,0,"关闭",onClose);
			
			new Alert(this,-200,-50);
			new AlertInput(this,-200,-50);
			
			aiFileDesc = new InputText(m2,0,0,"",onAiFileDescChange); aiFileDesc.width=200;
			
			var appAlphaLable:LableX = new LableX(m2,0,0,"                                                  窗体透明度:");appAlphaLable.color=0x999999;appAlphaLable.mouseEnabled=false;appAlphaLable.mouseChildren=false;
			appWinAlpha = new HSlider(m2,0,0,onAppWinAlpha); appWinAlpha.minimum = 0.3; appWinAlpha.maximum = 1; appWinAlpha.value = 1; appWinAlpha.height=18;
			//服务器
			server = new SimpleSocketServer();
			server.start("127.0.0.1",9988);
			server.onReceive = function(str:String):void{
				var ob:Object;
				try{
					ob = JSON.parse(str);
				} catch(e:Error) {
					return;
				}
				//trace("收到客户端消息:",ob.cmd,ob.msg);
				if(ob.cmd=="flash"){
					NodeContainer.one.flash(ob.msg);
				}
				if(ob.cmd=="say"){
					Alert.show(ob.msg);
				}
			}
			
			
			serverState = 	new ServerState(this,server);
			browser = 		new AIBrowser(this);
			propertyPanel = new PropertyPanel(this);
			smlGameWin = 	new SmlGameSetupWin(this); 	smlGameWin.visible = 	tryMode.selected;
			game = new Scene(this); 				game.visible = 			tryMode.selected;
			addChild(game);
			
			actorMgr = new ActorMgr();
			var bossData:ActorData = actorMgr.add(0);
				bossData.x=100;bossData.y=130;
				bossData.xBorn=100;bossData.yBorn=130;
			var playerData:ActorData = actorMgr.add(1);
				playerData.attRad = 5;
			
			var bossRender:RenderOB = game.add(0);
				bossRender.type = RenderOB.BOSS;
			var playerRender:RenderOB = game.add(1);
				playerRender.type = RenderOB.PLAYER;
			
			onAiPathChange();
			
			
			new AiUpdateMgr();
			
			stage.addEventListener(Event.ENTER_FRAME,onTick);
		}
		private var lastTime:int;

		private var actorMgr:ActorMgr;
		protected function onTick(e:Event):void
		{
			var now:int = getTimer();
			AiUpdateMgr.one.update(now);
		}
		
		private function onTry(e:*):void
		{
			smlGameWin.visible = 	tryMode.selected;
			game.visible = 			tryMode.selected;
			if(tryMode.selected){
				AiUpdateMgr.one.canRun = true;
				NodeContainer.one.save();
			}else{
				AiUpdateMgr.one.canRun = false;
			}
		}
		
		private function onAppWinAlpha(e:*):void
		{
			this.alpha = appWinAlpha.value;
		}
		
		private function onBrowser(e:*):void
		{
			var dir:File = new File(aiPath.text);
			dir.openWithDefaultApplication();
		}
		
		private function onAiFileDescChange(e:*):void
		{
			if(NodeContainer.one.curFileX){
				NodeContainer.one.curFileX.data.desc = aiFileDesc.text;
			}
		}
		
		private function onAiPathChange(e:*=null):void
		{
			SO("aiPath",aiPath.text);
			browser.show(aiPath.text);
		}
		
		protected function onSel(event:Event):void
		{
			nc.sel();
		}
		
		private function onClose(e:*):void
		{
			NativeApplication.nativeApplication.autoExit = true;
			stage.nativeWindow.close();
		}
		
		private function alwaysOnTop(e:Event):void
		{
			stage.nativeWindow.alwaysInFront = btAlwaysOnTop.selected;
		}
		
		private function onAdd(e:*):void
		{
			if(!NodeContainer.one.curFileX){
				Alert.show("请新建或选定一个文件，再继续操作"); return;
			}
			nc.add();
		}
		
		private function onLink(e:*):void
		{
			if(!NodeContainer.one.curFileX){
				Alert.show("请新建或选定一个文件，再继续操作"); return;
			}
			NodeContainer.one.link();
		}
		private function onBreak(e:*):void
		{
			if(!NodeContainer.one.curFileX){
				Alert.show("请新建或选定一个文件，再继续操作"); return;
			}
			NodeContainer.one.breakSel();
		}
		
		private function onDel(e:*):void
		{
			NodeContainer.one.delAllSel();
		}
//		private var sayArr:Array = ["等下放学了，小心点","贱人","够了","再点剁了你手指，怕不怕","都说了不要点，拿开你的臭手"];
//		private function dontTouchMe(e:*):void
//		{
//			if(sayArr.length==0){
//				sayArr.push("此按钮功能待定");
//			}
//			Alert.show(sayArr.pop());
//		}
		
		private function onSave(e:*):void
		{
			NodeContainer.one.save();
		}
		public static function SO(key:String, val:*=null):*
		{
			var so:SharedObject = SharedObject.getLocal("AiEditor");
			if(val!=null) so.data[key] = val;
			return so.data[key];
		}
	}
}