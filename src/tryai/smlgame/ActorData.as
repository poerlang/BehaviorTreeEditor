package tryai.smlgame
{
	import flash.geom.Point;

	public class ActorData
	{
		public var target:ActorData;
		public var hpMax:int = 100;
		public var hp:int = hpMax;
		public var x:Number=0;//当前位置
		public var y:Number=0;
		private var _targetPos:Point;//移动目标点，为空时不移动
		public function get targetPos():Point
		{
			return _targetPos;
		}
		public function set targetPos(v:Point):void
		{
			_targetPos = v;
		}
		public var xBorn:Number=0;//出生点
		public var yBorn:Number=0;
		public var isSilence:Boolean;//是否被沉默（不能施放技能，但能普通攻击）
		private var _view:Number=200;//视野范围
		public var pid:int;
		private var _attRad:Number=70;//攻击范围
		public function get attRad():Number
		{
			return _attRad;
		}

		public function set attRad(value:Number):void
		{
			_attRad = value;
			var r:RenderOB = Scene.one.get(pid);
			if(r){
				r.drawAttackArea();
			}
		}
		private var _pos:Point=new Point();//位置 x,y 的 point 形式
		public function get pos():Point
		{
			_pos.x=x;
			_pos.y=y;
			return _pos;
		}
		public function get view():Number
		{
			return _view;
		}
		public function set view(value:Number):void
		{
			_view = value;
			var r:RenderOB = Scene.one.get(pid);
			if(r){
				r.drawViewArea();
			}
		}


		public function ActorData(pid:int)
		{
			this.pid = pid;
		}
		
		public function action(s:String):void
		{
			var r:RenderOB = Scene.one.get(pid);
			if(!r) return;
			if(s=="alert"){
				r.showAlert();
			}
			if(s=="what"){
				r.showWhat();
			}
			if(s=="attack"){
				r.showAttack();
			}
			if(s=="skill"){
				r.showSkill();
			}
			if(s=="turn"){
				if(target){
					if(target.x>x){
						r.turnRight();
					}else{
						r.turnLeft();
					}
				}
			}
		}
	}
}