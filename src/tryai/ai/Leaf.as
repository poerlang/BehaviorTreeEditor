package tryai.ai
{
	import flash.geom.Point;
	
	import tryai.ActorMgr;
	import tryai.smlgame.ActorData;

	public class Leaf
	{
		public static var leafTypes:Array = ["IsTargetExist","HpLowTo","IsTargetOutOfFollowRads","IsTargetInAttRads","IsTargetInSkillRads","FindNPCInMap","FindPlayerInMap","FindTargetInViewRads","MoveToTarget","MoveAroundTarget","MoveAroundBornPos","MoveAndKeepDist","BackToBornPos","TurnDirToTarget","Alert","Attack","Skill","SkillCDReady","StandPose","SetTargetToNull","justTrue","justFalse","delayTrue","RndDelayTrue","delayFalse"];
		public var player:ActorData;
		public var me:ActorData;
//		public var xls:BatAction;//配表
		public var allTime:Number = 3.3;
		public var sumDelayTime:Number = 0;
		public function dispose():void
		{
			god = null;
			me = null;
		}
		public function Leaf(pid:int,god:God){
			this.god = god;
			me = ActorMgr.one.getActorById(pid);
//			player = ActorMgr.ins.getActorById(PartnerMgr.ins.GetPlayer().pid);
//			xls = CombatMgr.ins.getBatAction(me.actionId);
		}
		/**目标是否存在（me.target是否存在）**/
		public function IsTargetExist(dt:Number,ai:AINode):int{
			if(me.target && me.target.hp>0){
				return AINode.SUCCESS;
			}
			me.target = null;
			return AINode.FAIL;
		}
		/**我的血量是否低于某值**/
		public function HpLowTo(dt:Number,ai:AINode):int{
			if(ai.arr.length==1){
				ai.arr = [0,ai.arr[0]];//确保有一个最大和最小值，百分比模式下，是0~1，血量绝对值模式下，是0~无限大
			}
			var hp1:Number = ai.arr[0];
			var hp2:Number = ai.arr[1];
			if(hp2<=1){
				//血量百分比模式
				var bfb:Number = me.hp/me.hpMax;
				if(hp1<=bfb && bfb<=hp2){
					return AINode.SUCCESS;
				}else{
					return AINode.FAIL;
				}
			}
			if(me.hp<=hp1 && me.hp<=hp2){
				//血量绝对值模式
				return AINode.SUCCESS;
			}
			return AINode.FAIL;
		}
		/**目标是否超出追击范围**/
		public function IsTargetOutOfFollowRads(dt:Number,ai:AINode):int{
			if(!me.target)return  AINode.FAIL;
			if(me.target.hp<=0)return AINode.FAIL;
			
			var p2:Point = me.target.pos;
			var p1:Point = me.pos;
			var dis:Number = Point.distance(p1,p2);
			
			if(dis>me.view){
				return AINode.SUCCESS;
			}
			return AINode.FAIL;
		}
		/**目标是否在攻击范围内**/
		public function IsTargetInAttRads(dt:Number,ai:AINode):int{
			if(!me.target)return  AINode.FAIL;
			
			var p2:Point = me.target.pos;
			var p1:Point = me.pos;
			var dis:Number = Point.distance(p1,p2);
			
			if(dis<me.attRad){
				return AINode.SUCCESS;
			}
			return AINode.FAIL;
		}
		/**目标是否在技能攻击范围内**/
		public function IsTargetInSkillRads(dt:Number,ai:AINode):int{
			if(!me.target)return  AINode.FAIL;
			var p2:Point = me.target.pos;
			var p1:Point = me.pos;
			var dis:Number = Point.distance(p1,p2);
			
			if(dis*1.1 < me.attRad){
				return AINode.SUCCESS;
			}
			return AINode.FAIL;
		}
		/**寻找可攻击的NPC（在全地图范围内），并记录到 me.target**/
		public function FindNPCInMap(dt:Number,ai:AINode):int{
			var checkActor:ActorData;
			ActorMgr.one.forAllActor(function(a:ActorData):Boolean{
				if(a!=me){
					checkActor = a;
					return true;
				}
				return false;
			});
			me.target = checkActor;
			if(me.target) {
				return AINode.SUCCESS;
			}
			return AINode.FAIL;
		}
		/**寻找可攻击的玩家（在全地图范围内），并记录到 me.target**/
		public function FindPlayerInMap(dt:Number,ai:AINode):int{
			var checkActor:ActorData;
			ActorMgr.one.forAllActor(function(a:ActorData):Boolean{
				if(a!=me){
					checkActor = a;
					return true;
				}
				return false;
			});
			me.target = checkActor;
			if(me.target) {
				return AINode.SUCCESS;
			}
			return AINode.FAIL;
		}
		/**寻找目标（在视野范围内，包括可攻击的NPC、以及玩家），并记录到 me.target**/
		public function FindTargetInViewRads(dt:Number,ai:AINode):int{
			var checkActor:ActorData;
			ActorMgr.one.forAllActor(function(a:ActorData):Boolean{
				if(a!=me){
					var p2:Point = a.pos;
					var p1:Point = me.pos;
					var dis:Number = Point.distance(p1,p2);
					if(dis<me.view){
						checkActor = a;
						return true;
					}
				}
				return false;
			});
			me.target = checkActor;
			if(me.target) {
				return AINode.SUCCESS;
			}
			if(me.target) {
				if(me.target.hp<=0)return AINode.FAIL;
				return AINode.SUCCESS;
			}
			return AINode.FAIL;
		}
		/**移动到目标**/
		public function MoveToTarget(dt:Number,ai:AINode):int{
			if(!me.target)return  AINode.FAIL;
			me.targetPos = me.target.pos.clone();
			return AINode.SUCCESS;
		}
		/**围绕目标移动一次**/
		public function MoveAroundTarget(dt:Number,ai:AINode):int{
			if(!me.target) return AINode.FAIL;
			var tmp:Point = me.target.pos.clone();
			tmp.x += Math.random()*80-25;
			tmp.y += Math.random()*80-25;
			me.targetPos = tmp;
			return AINode.SUCCESS;
		}
		/**围绕出生点移动一次**/
		public function MoveAroundBornPos(dt:Number,ai:AINode):int{
			var newPoint:Point = new Point(me.xBorn+Math.random()*200-100     ,      me.yBorn+Math.random()*200-100);
			me.targetPos = newPoint;
			me.action("what");
			return AINode.SUCCESS;
		}
		/**保持距离，★尚未完成**/
		public function MoveAndKeepDist(dt:Number,ai:AINode):int{
			if(!me.target) return AINode.SUCCESS;
			var p1:Point = me.target.pos;//目标的当前点
			var p2:Point = me.pos;//怪物的当前点
			var toDist:int = ai.arr[0];//与目标要保持的【距离】
			var toSpace:int = ai.arr[1];//要保持的距离的【容差值】，在此容差范围内，则代表计算出的坐标到目标的距离已经与 toDist相等
			var distance:int = Point.distance(p1,p2);
			var space:int = Math.abs(toDist-distance);
			if(space<toSpace){
				trace("★已经处在适当距离，无需计算，误差:",space);
				return AINode.SUCCESS;
			}
			
			var count:int = 0;
			var thePoint:Point;
			var bestCount:int = 0;
			var c:Point;
			trace("运算开始========================================================================");
			trace("怪物当前点",p2," 玩家当前点",p1);
			trace("目标距离",toDist," 目标距离容差",toSpace);
			trace("当前距离",distance," 差距",space);
			do {
				count++;
				c = p2.clone();
				c.x += Math.random()*222-111;
				c.y += Math.random()*222-111;
				distance = Point.distance(p1,c);
				var tmpSpace:int = Math.abs(toDist-distance);
				trace("\t第",count,"次随机，差距",tmpSpace);
				if(tmpSpace<space){
					space = tmpSpace;
					thePoint = c;
					bestCount = count;
					trace("\t\t新的怪物当前点",c);
				}
				if(thePoint && count>10) {
					trace(count,"大于10次，退出");
					break;
				}
			} while(space>toSpace);
			trace("最终点选用第",bestCount,"次的结果",thePoint);
			trace("结束---------------------------↑↑↑↑");
			me.targetPos = thePoint;
			return AINode.SUCCESS;
		}
		/**转向目标**/
		public function TurnDirToTarget(dt:Number,ai:AINode):int{
			if(!me.target) return AINode.FAIL;
			me.action("turn");
			return AINode.SUCCESS;
		}
		/**返回出生点**/
		public function BackToBornPos(dt:Number,ai:AINode):int{
			var newPoint:Point = new Point(me.xBorn, me.yBorn);
			me.targetPos = newPoint;
			return AINode.SUCCESS;
		}
		/**boss技能预警**/
		public function Alert(dt:Number,ai:AINode):int{
			if(!me.target) return AINode.FAIL;
			me.action("alert");
			return AINode.SUCCESS;
		}
		/**攻击（只适用于怪物）**/
		public function Attack(dt:Number,ai:AINode):int{
			if(!me.target) return AINode.FAIL;
			me.action("attack");
			return AINode.SUCCESS;
		}
		public var skill:Object;
		public var lastSkillTime:Number;
		/**放技能（只适用于怪物）**/
		public function Skill(dt:Number,ai:AINode):int{
			if(!me.target) return AINode.FAIL;
			me.action("skill");
			return AINode.SUCCESS;
		}
		/**技能是否冷却（只适用于怪物）**/
		public function SkillCDReady(dt:Number,ai:AINode):int{
			if(!me.target){
				return AINode.FAIL;
			}
			Alert.show("练习模式下，暂不支持技能 CD 节点");
			return AINode.SUCCESS;
		}
		/**站立姿势**/
		public function StandPose(dt:Number,ai:AINode):int{
			me.targetPos = null;
			me.action("what");
			return AINode.SUCCESS;
		}
		/**清空目标**/
		public function SetTargetToNull(dt:Number,ai:AINode):int{
			me.target = null;
			return AINode.SUCCESS;
		}
		public static const INIT		:int = -1;
		public static const RUNNING		:int = 1;
		public static const SUCCESS		:int = 2;
		public static const FAIL		:int = 3;
		public var state:int = -1;//INIT -1   RUNNING 1    SUCCESS 2     FAIL 3

		private var god:God;
		public function resetTime():void{
			sumDelayTime = 0;
		}
		public function justTrue(dt:Number,ai:AINode):int{
			return AINode.SUCCESS;
		}
		public function justFalse(dt:Number,ai:AINode):int{
			return AINode.FAIL;
		}
		public function delayTrue(dt:Number,ai:AINode):int{
			if(god.nodeNow.arr)allTime = god.nodeNow.arr[0];
			sumDelayTime += dt;
			if(sumDelayTime>allTime){
				return AINode.SUCCESS;
			}
			return AINode.RUNNING;
		}
		public function RndDelayTrue(dt:Number,ai:AINode):int{
			if(god.nodeNow.arr)allTime = god.nodeNow.arr[0]*Math.random();
			sumDelayTime += dt;
			if(sumDelayTime>allTime){
				return AINode.SUCCESS;
			}
			return AINode.RUNNING;
		}
		public function delayFalse(dt:Number,ai:AINode):int{
			sumDelayTime += dt;
			if(sumDelayTime>allTime){
				return AINode.FAIL;
			}
			return AINode.RUNNING;
		}
	}
}