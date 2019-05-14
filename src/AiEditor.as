package
{
	import com.bit101.components.HBox;
	import com.bit101.components.HSlider;
	import com.bit101.components.InputText;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.Style;
	import com.bit101.components.VBox;
	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getTimer;
	
	import props.PropertyPanel;
	
	import tryai.ActorMgr;
	import tryai.AiUpdateMgr;
	import tryai.smlgame.ActorData;
	import tryai.smlgame.RenderOB;
	import tryai.smlgame.Scene;
	import tryai.smlgame.SmlGameSetupWin;
	import com.bit101.components.Text;
	
	[SWF(width="100%",height="100%",frameRate="60")]
	public class AiEditor extends Sprite
	{
		private var btAlwaysOnTop:PushButton;
		
		private var nc:NodeContainer;
		
		public static var flashStage:Stage;
		
		private var aiPath:InputText;
		
		
		public static var aiFileDesc:InputText;
		public static var one:AiEditor;
		
		private var propertyPanel:PropertyPanel;
		
		
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
			
			var bg:AppBG = new AppBG(this,2980,2980,0x999999);
			
			nc = new NodeContainer(); addChild(nc);
			
			var menuContainer:VBox = new VBox(this,5,5);
			new Label(menuContainer,0,0,"说明：单击移动，双击瞬移，另外，由于运行环境对原有游戏依赖比较重，编辑功能不再支持，此版本只用于预览行为树 AI 的运行效果。");
			menuContainer.mouseEnabled = false;
			var m1:HBox = new HBox(menuContainer); 
			var m2:HBox = new HBox(menuContainer);
			m2.mouseEnabled = false;
			var m3:HBox = new HBox(menuContainer);
			var inputText:Text = new Text(m3,0,0,"QQ:30558209，Web：<a href='http://poerlang.com'>poerlang.com</a>");
//			inputText.enabled = false;
			inputText.html = true;
			inputText.width = 300;
			inputText.height = 24;
//			inputText.addEventListener(MouseEvent.CLICK,onWebClick);
			
			new Alert(this,-200,-50);
			new AlertInput(this,-200,-50);
			
			propertyPanel = new PropertyPanel(this);
			smlGameWin = 	new SmlGameSetupWin(this);
			smlGameWin.visible = 	true;
			game = new Scene(this); 				
			game.visible = true;
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
			
			new AiUpdateMgr();
			
			stage.addEventListener(Event.ENTER_FRAME,onTick);
			
			load("0.txt");
		}
		
		protected function onWebClick(event:MouseEvent):void
		{
			
		}
		
		private function load(url:String):void
		{
			var urlLoader:URLLoader = new URLLoader();
			
			urlLoader.load(new URLRequest( url ));//这里是你要获取JSON的路径
			urlLoader.addEventListener(Event.COMPLETE, onLoad);
		}
		private function onLoad(event:Event):void {
			try
			{
				var str:String = URLLoader( event.target ).data
				nc.showAiTree(str);
				var ob:Object = JSON.parse(str);
				AiUpdateMgr.one.JsonToAI(ob);
				AiUpdateMgr.one.canRun = true;
			} 
			catch(error:Error) 
			{
				trace(error);
			}
		}
		private var lastTime:int;
		
		private var actorMgr:ActorMgr;
		protected function onTick(e:Event):void
		{
			var now:int = getTimer();
			AiUpdateMgr.one.update(now);
		}
		private function onAiPathChange(e:*=null):void
		{
			SO("aiPath",aiPath.text);
			load(aiPath.text);
		}
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