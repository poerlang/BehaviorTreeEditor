package tryai.smlgame
{
	import com.bit101.components.HSlider;
	import com.bit101.components.InputText;
	import com.bit101.components.NumericStepper;
	import com.bit101.components.VBox;
	
	import flash.display.DisplayObjectContainer;
	
	import props.WindowX;
	
	import tryai.ActorMgr;
	import tryai.ai.AINode;
	
	public class SmlGameSetupWin extends WindowX
	{

		private var speed:InputText;

		private var ss:HSlider;

		public static var view:NumericStepper;
		public static var attRad:NumericStepper;
		public function SmlGameSetupWin(parent:DisplayObjectContainer=null)
		{
			super(parent,"SmlGameWin", 908,418);
			setSize(220,249);
			var body:VBox = new VBox(this);
			
			//new LableX(body,0,0," ");
			new LableX(body,0,0,"闪烁间隔：");
			speed = new InputText(body,0,0,"1",onSpeedChange);
			ss = new HSlider(body,0,0,onSpeedSlider); ss.minimum = 0.01; ss.maximum = 1;
			new LableX(body,0,0,"视野范围：");
			view = new NumericStepper(body,0,0,onViewChange);view.value = 200;view.step=10;
			new LableX(body,0,0,"攻击范围：");
			attRad = new NumericStepper(body,0,0,onAttChange);attRad.value = 70;attRad.step=10;
		}
		
		private function onAttChange(e:*):void
		{
			var a:ActorData = ActorMgr.one.getActorById(0);
			a.attRad = attRad.value;
		}
		
		private function onViewChange(e:*):void
		{
			var a:ActorData = ActorMgr.one.getActorById(0);
			a.view = view.value;
		}
		
		private function onSpeedSlider(e):void
		{
			speed.text = ss.value.toFixed(2);
			AINode.waitTime = ss.value;
		}
		
		private function onSpeedChange(e:*):void
		{
			var speedNum:Number = parseFloat(speed.text);
			AINode.waitTime = speedNum;
			ss.value = speedNum;
		}
	}
}