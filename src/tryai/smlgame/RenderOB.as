package tryai.smlgame
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Elastic;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import tryai.ActorMgr;
	
	public class RenderOB extends Sprite
	{
		[Embed(source="../../../psd/boss.png",mimeType="image/png")]
		public static var ClassPicBoss:Class;
		public static var ClassPicBossBD:BitmapData = (new ClassPicBoss() as Bitmap).bitmapData;
		
		[Embed(source="../../../psd/player.png",mimeType="image/png")]
		public static var ClassPicPlayer:Class;
		public static var ClassPicPlayerBD:BitmapData = (new ClassPicPlayer() as Bitmap).bitmapData;

		[Embed(source="../../../psd/alert.png",mimeType="image/png")]
		public static var ClassPicAlert:Class;
		public static var ClassPicAlertBD:BitmapData = (new ClassPicAlert() as Bitmap).bitmapData;
		
		[Embed(source="../../../psd/what.png",mimeType="image/png")]
		public static var ClassPicWhat:Class;
		public static var ClassPicWhatBD:BitmapData = (new ClassPicWhat() as Bitmap).bitmapData;
		
		public var pid:int;
		public static const PLAYER:String = "player";
		public static const BOSS:String = "boss";
		private var bitmap:Bitmap;
		public function RenderOB(pid:int)
		{
			this.pid = pid;
			viewSprite = new Sprite();addChild(viewSprite);viewSprite.mouseEnabled = false;
			attSprite = new Sprite();addChild(attSprite);attSprite.mouseEnabled = false;
			
			bitmap = new Bitmap();
			addChild(bitmap);
			bitmap.x =- 12;
			bitmap.y =- 15;
			
			tipBitmap = new Bitmap();
			addChild(tipBitmap);
			tipBitmap.x -= 12;
			tipBitmap.y -= 25;
			
			actor = ActorMgr.one.getActorById(pid);
		}
		private var _type:String

		private var viewSprite:Sprite;
		private var attSprite:Sprite;

		private var actor:ActorData;

		private var tipBitmap:Bitmap;

		public function get type():String
		{
			return _type;
		}

		public function set type(v:String):void
		{
			_type = v;
			if(v==BOSS){
				bitmap.bitmapData = ClassPicBossBD;
				draw();
			}else{
				bitmap.bitmapData = ClassPicPlayerBD;
			}
		}
		
		private function draw():void
		{
			drawViewArea();
			drawAttackArea();
		}
		
		public function drawAttackArea():void
		{
			if(!SmlGameSetupWin.view)return;
			var g:Graphics = attSprite.graphics;
			g.clear();
			g.lineStyle(1,0x990000,.7);
			g.beginFill(0x990000,.1);
			g.drawCircle(0,0,actor.attRad);
			g.endFill();			
		}
		public function drawViewArea():void
		{
			if(!SmlGameSetupWin.view)return;
			var g:Graphics = viewSprite.graphics;
			g.clear();
			g.lineStyle(1,0x006600,.8);
			g.beginFill(0x009900,.05);
			g.drawCircle(0,0,actor.view);
			g.endFill();
		}
		
		public function update():void
		{
			if(_type==PLAYER){
				var t:Sprite = Scene.playerTarget;
				move(t.x,t.y);
			}
			if(_type==BOSS){
				if(!actor)return;
				x = actor.x;
				y = actor.y;
				if(actor.targetPos){
					moveToPoint(actor.targetPos);
				}
			}
		}
		
		private function moveToPoint(p2:Point,speed:Number=1):void
		{
			var p1:Point = new Point(x,y);
			var dir:Point = p2.subtract(p1);
			var dis:Number = dir.length;
			dir.normalize(speed);
			if(dis>actor.attRad){
				if(dir.x>0){
					turnRight();
				}
				if(dir.x<0){
					turnLeft();
				}
				x+=dir.x;
				y+=dir.y;
			}else{
				actor.targetPos = null;
			}
			actor.x = x;
			actor.y = y;
		}
		
		public function turnLeft():void
		{
			bitmap.scaleX = -1;
			bitmap.x = bitmap.width-12;
		}
		
		public function turnRight():void
		{
			bitmap.scaleX = 1;
			bitmap.x =- 12;
		}
		private function move(xx:Number,yy:Number,speed:Number=1):void
		{
			var p2:Point = new Point(xx,yy);
			moveToPoint(p2,speed);
		}
		
		public function showAlert():void
		{
			tipBitmap.bitmapData = ClassPicAlertBD;
			tipBitmap.visible = true;
			var ox:Number = tipBitmap.x;
			var oy:Number = tipBitmap.y;
			TweenLite.to(tipBitmap,.2,{y:"-5",ease:Elastic.easeOut,onComplete:function():void{
				tipBitmap.visible = false;
				tipBitmap.x = ox;
				tipBitmap.y = oy;
			}});
		}
		public function showWhat():void
		{
			tipBitmap.bitmapData = ClassPicWhatBD;
			tipBitmap.visible = true;
			var ox:Number = tipBitmap.x;
			var oy:Number = tipBitmap.y;
			tipBitmap.y-=5;
			TweenLite.to(tipBitmap,.2,{y:"-5",ease:Elastic.easeOut,onComplete:function():void{
				tipBitmap.visible = false;
				tipBitmap.x = ox;
				tipBitmap.y = oy;
			}});
		}
		
		public function showAttack():void
		{
			if(!actor.target) return;
			playerAttack();			
		}
		
		private function playerAttack():void
		{
			var p2:Point = actor.target.pos;
			var p1:Point = new Point(x,y);
			var dir:Point = p2.subtract(p1);
			dir.normalize(3);
			var mybody:RenderOB = this;
			TweenLite.to(mybody,.2,{x:x+dir.x,y:y+dir.y,ease:Elastic.easeOut,onComplete:function():void{
				TweenLite.to(mybody,.1,{x:x-dir.x,  y:y-dir.x});
			}});
		}
		
		public function showSkill():void
		{
			if(!actor.target) return;
			
			playerAttack();
			
			var p2:Point = actor.target.pos;
			var p1:Point = new Point(x,y);
			var dir:Point = p2.subtract(p1);
			var dis:Number = dir.length;
			var pathlen:Number = dis+5;
			
			dir.normalize(pathlen*1);
			var s5:Point = p1.add(dir);
			
			dir.normalize(pathlen*.8);
			var s4:Point = p1.add(dir);
			
			dir.normalize(pathlen*.6);
			var s3:Point = p1.add(dir);
			
			dir.normalize(pathlen*.4);
			var s2:Point = p1.add(dir);
			
			dir.normalize(pathlen*.2);
			var s1:Point = p1.add(dir);
			
			dir.normalize(pathlen*.1);
			var s0:Point = p1.add(dir);
			
			EffectLayer.one.showSkill([s0,s1,s2,s3,s4,s5]);
		}
	}
}