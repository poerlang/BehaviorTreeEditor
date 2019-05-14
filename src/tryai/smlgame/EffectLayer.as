package tryai.smlgame
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.plugins.*;
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	public class EffectLayer extends Sprite
	{
		public static var one:EffectLayer;
		public function EffectLayer()
		{
			one = this;
			TweenPlugin.activate([GlowFilterPlugin]);
		}
		public function showSkill(arr:Array):void
		{
			var s:Sprite = new Sprite();
			TweenMax.to(s, 0.02, {glowFilter:{color:0x00eeff, alpha:1, blurX:17, blurY:17, strength:23.5, quality:2}});
			addChild(s);
			drawOnce();
			TweenLite.delayedCall(.1,drawOnce);
			TweenLite.delayedCall(.2,drawOnce);
			TweenLite.delayedCall(.3,clear);
			
			function clear():void{
				one.removeChild(s);
			}
			function drawOnce():void{
				var g:Graphics = s.graphics;
				g.clear();
				g.lineStyle(1,0xffffff);
				g.moveTo(arr[0].x,arr[0].y);
				for (var i:int = 1; i < arr.length; i++) {
					if(i+1<arr.length){
						var xx:int = arr[i].x+Math.random()*6-3;
						var yy:int = arr[i].y+Math.random()*10-5;
					}
					g.lineTo(xx,yy);
				}
			}
		}		
	}
}