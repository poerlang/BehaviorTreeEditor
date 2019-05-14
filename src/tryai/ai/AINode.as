package tryai.ai
{
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	public class AINode
	{
		private function selectSub():void
		{
			running_sub = null;
			state = selectFunction(childs,this);
			if(state!=WAITSUB){
				stepNow = STEP_TYPE_NO_SUB_CAN_RUN;
			}
		}
		public var _isStop:Boolean;
		
		public function get isStop():Boolean
		{
			return _isStop;
		}
		
		public function set isStop(v:Boolean):void
		{
			_isStop = v;
		}
		
		private var _timeToRestart:Number = -1;
		
		public function get timeToRestart():Number
		{
			return _timeToRestart;
		}
		
		public function set timeToRestart(v:Number):void
		{
			_timeToRestart = v;
		}
		
		public function stop(timeToRestart:Number=-1):void
		{
			reset();
			root.timeToRestart = timeToRestart;
			root.isStop=true;
			god.nodeNow = root;
		}
		public function play():void
		{
			root.isStop = false;
		}
		public function update(dt:Number):void{
			if(root.god.leaf.me.hp<=0){
				root.isStop = true;
				root.timeToRestart = -1;
			}
			if(root.isStop && root.timeToRestart==-1){
				return;//停止
			}
			if(root.isStop && root.timeToRestart!=-1){
				root.timeToRestart -= dt;
				if(root.timeToRestart<0){
					root.timeToRestart = -1;
					if(root.god.leaf.me.hp>0)root.isStop = false;//恢复
				}
				return;
			}
			time += dt;//累积时间，直到超过waitTime，才能进入下一个step
			var factor:Number = 1;
			if(!root.inCombat) factor = 1.2;//【优化】如果不在战斗中，则ai降频。
			if( time < waitTime*factor ){//没有超过waitTime，则强制【等待，返回】
				return;
			}
			switch(stepNow)
			{
				case 0:
				{
					running_sub = null;
					state = WAITSUB;
					stepNow = STEP_TYPE_ENTER;
					rndChilds();
					if(childs.length==0 && !isRoot && isLeaf()){
						god.leaf.resetTime();
						stepNow = STEP_TYPE_RUN;
					}else{
						stepNow = STEP_TYPE_SEL_SUB_NODE;
						selectSub();
					}
					return;
				}
				case STEP_TYPE_RUN://如果上一步是运行，说明是叶子节点，则运行叶子函数，传值为dt
				{
					state = selectFunction(time,this);
					if(state==AINode.RUNNING){
						stepNow = STEP_TYPE_RUN;
					}else{
						do_return();
					}
					return;
				}					
				case STEP_TYPE_SEL_SUB_NODE://如果上一步是选择子节点，接下来就是【运行子节点】
				{
					state = WAITSUB;
					stepNow = STEP_TYPE_RUN_AND_WAIT_SUB_NODE;
					if(sel=="NotAgainInXsec")lastTimeRunning = getTimer();
					god.nodeNow = running_sub;
					return;
				}
				case STEP_TYPE_SUB_RETURN://如果上一步是子节点返回，接下来就是	【选择子节点】
				{
					state = WAITSUB;
					stepNow = STEP_TYPE_SEL_SUB_NODE;
					selectSub();
					return;
				}
				case STEP_TYPE_NO_SUB_CAN_RUN://子节点都运行过了，目前没有节点可运行
				{
					hasRun = true;
					if(isRoot){
						stepNow = STEP_TYPE_RETURN_TO_ROOT;
					}else{
						do_return();
					}
					return;
				}
				case STEP_TYPE_RETURN_TO_ROOT://回到根节点，即将重置整棵树的状态并重新运行。
				{
					reset();
					return;
				}
				default:
				{
					return;
				}
			}
		}
		
		public function do_return():void
		{
			parent.stepNow = AINode.STEP_TYPE_WILL_RETURN;
			hasRun = true;
			if(parent){
				god.nodeNow = parent;//返回父节点
				parent.stepNow = STEP_TYPE_SUB_RETURN;
			}
		}
		
		private function isLeaf():Boolean
		{
			return Leaf.leafTypes.indexOf(sel)!=-1;
		}
		
		
		public function get stepNow():int {
			return _stepNow;
		}
		
		public function set stepNow(value:int):void
		{
			time = 0;//重置时间
			_stepNow = value;
//			if(send==this.root){
				NodeContainer.one.flash(ID);
//			}
		}
		private function rndChilds():void
		{
			if(rnd){
				childs.sort(sortFunction);
			}
		}
		public function sortFunction(a:AINode,b:AINode):Boolean{
			return Math.random()>.5;
		}
		
		public function reset():void
		{
			if(isRoot){
				//Logger.debug(2046,"=========重置所有数据========");
			}
			if(!isRoot)timeToRestart = -1;
			_stepNow = 0;
			state = -1;
			count = -1;
			hasRun = false;
			running_sub = null;
			time=0;
			if(god){
				god.nodeNow = root;
				if(god.leaf){
					god.leaf.allTime = 0;
				}
			}
			if(childs){
				for (var i:int = 0; i < childs.length; i++) 
				{
					childs[i].reset();
				}
			}
		}
		public function dispose():void
		{
			if(isRoot){
				for (var i:int = 0; i < childs.length; i++) 
				{
					childs[i].dispose()
				}
				god.dispose();
			}
			childs = null;
			state = -1;
			hasRun = false;
			count = -1;
			running_sub = null;
			time=0;
			_stepNow = 0;
			selectFunction = null;
			parent = null;
			root = null;
			god = null;
			name = null;
			_stepNow = 0;
			sel = null;
		}
		public var parent:AINode;
		public var childs:Vector.<AINode> = new Vector.<AINode>();
		public var running_sub:AINode;
		public var god:God;
		public var name:String="";
		private var rnd:Boolean;
		public static var FRAME_STEP:int = 1;//每隔多少帧运行一次god的Update
		public static var waitTime:Number = 0.02;//需要等待进入下一步的总时间（秒）
		private var time:Number = 0;//当前累积已经等待的时间（秒）
		
		public static const STEP_TYPE_ENTER:int 				= 1;//"进入节点";
		public static const STEP_TYPE_SEL_SUB_NODE:int 			= 2;//"选择子节点";
		public static const STEP_TYPE_NO_SUB_CAN_RUN:int 		= 3;//"无节点可运行，或已经满足返回条件";
		public static const STEP_TYPE_RUN_AND_WAIT_SUB_NODE:int = 4;//"运行并等待子节点";
		public static const STEP_TYPE_TIME_LIMINT:int 			= 5;//"时间限制";
		public static const STEP_TYPE_WILL_RETURN:int 			= 6;//"即将返回上层节点";
		public static const STEP_TYPE_RUN:int 					= 7;//"正在执行";
		public static const STEP_TYPE_SUB_RETURN:int 			= 8;//"子节点返回";
		public static const STEP_TYPE_RETURN_TO_ROOT:int 		= 9;//"回到根节点，即将重置整棵树的状态并重新运行";
		public static const STEP_TYPE_EXIT:int 					= 10;//"退出节点";
		
		public static var StepDic:Dictionary; 
		public function AINode(_parent:AINode,sel:String="",_pid:uint = 0)
		{
			if(!StepDic){
				StepDic = new Dictionary();
				StepDic[1] = "STEP_TYPE_ENTER";
				StepDic[2] = "STEP_TYPE_SEL_SUB_NODE";
				StepDic[3] = "STEP_TYPE_NO_SUB_CAN_RUN";
				StepDic[4] = "STEP_TYPE_RUN_AND_WAIT_SUB_NODE";
				StepDic[5] = "STEP_TYPE_TIME_LIMINT";
				StepDic[6] = "STEP_TYPE_WILL_RETURN";
				StepDic[7] = "STEP_TYPE_RUN";
				StepDic[8] = "STEP_TYPE_SUB_RETURN";
				StepDic[9] = "STEP_TYPE_RETURN_TO_ROOT";
				StepDic[10] = "STEP_TYPE_EXIT";
			}
			pid = _pid;
			parent = _parent;
			this.sel = sel;
			if(sel=="") sel = "And";
			if(!_parent){
				isRoot = true;
				root = this;
				god = new God(pid);
				god.nodeNow = this;
			}else{
				god = parent.god;
				root = parent.root;
				_parent.childs.push(this);
			}
			if(Leaf.leafTypes.indexOf(sel)!=-1){
				selectFunction = god.leaf[sel];//如果是叶子节点，则赋予叶子节点的函数
			}else{
				selectFunction = god.select[sel];
			}
		}
		
		public static const RUNNING :int = 1;//只在叶子节点使用
		public static const SUCCESS :int = 2;
		public static const FAIL 	:int = 3;
		public static const WAITSUB :int = 4;
		
		public var count:int = 0;//次数
		public var lastTimeRunning:int = 0;//上次运行此节点的时间（毫秒）
		public var notAgainInXsec:Number = 0;//X秒内，不再执行此节点。这个变量配合 lastTimeRunning 一起使用，参考 Select的 NotAgainInXsec
		public var countMax:int = 1;//最大次数
		public var countRnd:Boolean = false;//是否随机次数（ 1次 ~ 最大次数之间 ）
		public static var uiContainer:Sprite;
		public var _stepNow:int = 0;//当前Step
		public var selectFunction:Function;
		public var hasRun:Boolean;//本轮是否运行过，从根节点到所有分支，然后再回逆到根节点，算一轮，一轮后会重置所有节点的 hasRun
		public var state:int = -1;// RUNNING 1    SUCCESS 2     FAIL 3     WAITSUB 4
		public var root:AINode;
		public var inCombat:Boolean;//战斗状态，只在某个怪物的根节点记录，可这样读取 this.root.inCombat
		public var isRoot:Boolean;
		public var sel:String;
		public var x:Number;//UINode在编辑器里的x轴坐标
		public var y:Number;//同上（y轴）
		public var pid:uint;
		private var _arr:Array;//参数集合
		public static var send:AINode;//是否向编辑器发送讯息
		public var ID:int;
		public function get arr():Array
		{
			return _arr;
		}
		
		public function set arr(value:Array):void
		{
			_arr = value;
		}
		
		
		public static function sortX(vec:Array):Array{
			var array:Array = [];
			while(vec.length > 0) array.push(vec.pop());
			array.sortOn("x", Array.NUMERIC|Array.DESCENDING);
			while(array.length > 0) vec.push(array.pop());
			return vec
		}
	}
}
