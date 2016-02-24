package tryai.smlgame
{
	import com.greensock.TweenLite;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import tryai.AiUpdateMgr;

	public class Scene extends Box
	{
		private var dic:Dictionary = new Dictionary();
		public static var one:Scene;

		public static var playerTarget:Sprite;
		private var lastClickTime:int;

		private var maskSprite:Sprite;
		public function Scene(p:DisplayObjectContainer)
		{
			one = this;
			super(p,904,250,0x666666,true);
			x = 2;
			y = 417;
			addEventListener(MouseEvent.MOUSE_DOWN,onDown);
			addEventListener(MouseEvent.MOUSE_UP,onUp);
			
			bg.alpha = .8;
			
			playerTarget = new Sprite();
			var g:Graphics = playerTarget.graphics;
				g.beginFill(0x00ee00);
				g.drawCircle(0,0,3);
				g.endFill();
			playerTarget.alpha = 0;
			playerTarget.x = 720;
			playerTarget.y = 140;
			addChild(playerTarget);
			p.stage.addEventListener(Event.ENTER_FRAME,onTick);
			
			maskSprite = new Sprite();
			addChild(maskSprite);
			drawMask();
			
			var effectLayer:EffectLayer = new EffectLayer();
			addChild(effectLayer);
			
		}
		override public function redraw():void
		{
			super.redraw();
			drawMask();
		}
		private function drawMask():void
		{
			if(!maskSprite)return;
			var g:Graphics = maskSprite.graphics;
			g.clear();
			g.beginFill(0);
			g.drawRect(0,0,bg.width,bg.height);
			g.endFill();this.mask = maskSprite;
		}
		
		protected function onTick(e:Event):void
		{
			if(!AiUpdateMgr.one.canRun) return;
			for (var pid:int in dic) {
				var r:RenderOB = dic[pid];
				r.update();
			}
		}
		
		public function add(pid:int):RenderOB
		{
			var r:RenderOB = new RenderOB(pid);
			addChild(r);
			r.x = 100+int(Math.random()*50);
			r.y = 100+int(Math.random()*50);
			dic[pid] = r;
			return r;
		}
		public function get(pid:int):RenderOB
		{
			var r:RenderOB = dic[pid];
			if(r) return r;
			return null;
		}
		
		protected function onUp(e:MouseEvent):void
		{
			this.stopDrag();
		}
		
		protected function onDown(e:MouseEvent):void
		{
			if(e.target != drager){
				this.startDrag();
				playerTarget.x = this.mouseX;
				playerTarget.y = this.mouseY;
				var now:int = getTimer();
				if(lastClickTime==0){
					lastClickTime = now;
				}
				if((now-lastClickTime)<500){
					var player:RenderOB = get(1);
					player.x = playerTarget.x;
					player.y = playerTarget.y;
					return;
				}
				lastClickTime = now;
				playerTarget.alpha = 1;
				playerTarget.scaleX = 1.5;
				playerTarget.scaleY = 1.5;
				TweenLite.killTweensOf(playerTarget);
				TweenLite.to(playerTarget,.5,{alpha:0,scaleX:1,scaleY:1});
			}
		}
	}
}