package tryai.ai
{
	import flash.utils.getTimer;
	public class Select
	{
		public static var typeArr:Array = ["And","All","Or","Not","AndReturnTrue","CountAndLoop","NotAgainInXsec","Rnd"];
		public function And(childs:Vector.<AINode>,ai:AINode):int{
			for (var i:int = 0; i < childs.length; i++) 
			{
				if(childs[i].state == AINode.FAIL){
					return AINode.FAIL;
				}
				if(!childs[i].hasRun){
					childs[i].parent.running_sub = childs[i];
					return AINode.WAITSUB;
				}
			}
			return AINode.SUCCESS;
		}
		public function AndReturnTrue(childs:Vector.<AINode>,ai:AINode):int{
			for (var i:int = 0; i < childs.length; i++) 
			{
				if(childs[i].state == AINode.FAIL){
					return AINode.SUCCESS;
				}
				if(!childs[i].hasRun){
					childs[i].parent.running_sub = childs[i];
					return AINode.WAITSUB;
				}
			}
			return AINode.SUCCESS;
		}
		public function Or(childs:Vector.<AINode>,ai:AINode):int{
			for (var i:int = 0; i < childs.length; i++) 
			{
				if(childs[i].state == AINode.SUCCESS){
					return AINode.SUCCESS;
				}
				if(!childs[i].hasRun){
					childs[i].parent.running_sub = childs[i];
					return AINode.WAITSUB;
				}
			}
			return AINode.FAIL;
		}
		public function All(childs:Vector.<AINode>,ai:AINode):int{
			for (var i:int = 0; i < childs.length; i++) 
			{
				if(!childs[i].hasRun){
					childs[i].parent.running_sub = childs[i];
					return AINode.WAITSUB;
				}
			}
			return AINode.SUCCESS;
		}
		public function Not(childs:Vector.<AINode>,ai:AINode):int{
			if(childs.length==0)return AINode.FAIL;
			if(childs[0].hasRun){
				if(childs[0].state == AINode.SUCCESS){
					return AINode.FAIL;
				}else{
					return AINode.SUCCESS;
				}
			}
			childs[0].parent.running_sub = childs[0];
			return AINode.WAITSUB;
		}
		public function CountAndLoop(childs:Vector.<AINode>,ai:AINode):int{
			if(childs.length==0)return AINode.FAIL;
			if(ai.arr && ai.arr.length>0){
				ai.countMax = ai.arr[0];//编辑器节点中，【】内的参数
			}
			ai.running_sub = childs[0];
			if(childs[0].hasRun){
				ai.count++;//递增次数
				if(childs[0].state == AINode.FAIL){
					return AINode.FAIL;
				}
				if(ai.count>=ai.countMax-1){
					return AINode.SUCCESS;
				}
				resetHasrun(childs[0]);
				function resetHasrun(n:AINode):void{
					for (var i:int = 0; i < n.childs.length; i++) {
						//如果子节点是And节点，则重置子节点的下一层节点
						n.childs[i].hasRun = false; 
						n.childs[i].stepNow = 0;
						resetHasrun(n.childs[i]);
					}
				}
				childs[0]._stepNow = 0;
				ai._stepNow = AINode.STEP_TYPE_SEL_SUB_NODE;
			}
			return AINode.WAITSUB;
		}
		public function NotAgainInXsec(childs:Vector.<AINode>,ai:AINode):int{
			if(childs.length==0) return AINode.FAIL;
			var child:AINode = childs[0];
			var parent:AINode = childs[0].parent;
			parent.running_sub = child;
			if(parent.arr && parent.arr.length>0){
				parent.notAgainInXsec = parent.arr[0];//编辑器节点中，【】内的参数
			}
			var now:int = getTimer();
			var d:int = now - parent.lastTimeRunning;//时间差
			if(d<parent.notAgainInXsec*1000){
				parent.stepNow = AINode.STEP_TYPE_TIME_LIMINT;//trace("还差"+(parent.notAgainInXsec*1000-d)/1000+"秒，可再次执行");
				parent.do_return();
				return AINode.SUCCESS;
			}
			parent.lastTimeRunning = now;
			return AINode.WAITSUB;
		}
		public function Rnd(childs:Vector.<AINode>,ai:AINode):int{
			if(childs.length==0){
				if(Math.random()<=ai.arr[0])return AINode.SUCCESS;//例如：Math.random()>0.6，   代表60%的几率
				return AINode.FAIL;
			}
			var parent:AINode = childs[0].parent;
			if(parent.arr==null || parent.arr.length==0)
				return AINode.FAIL;
			
			//子对象数量为1的情况，例如，Math.random()>0.6，则进入子节点
			if(childs.length==1){
				if(childs[0].hasRun)return AINode.SUCCESS;
				if(Math.random()>ai.arr[0]){
					ai.running_sub = childs[0];//选择权重最大的子对象运行。
					return AINode.WAITSUB;
				}
			}
			
			//子对象数量>1的情况，例如，【0.6,  0.2,  0.2】，那就看几率了，哪个子节点跟 Math.random()相乘最大，则选择执行哪个子节点。
			var w:Number=0;//权重值
			var index:int = 0;
			for (var i:int = 0; i < childs.length; i++)
			{
				if(childs[i].hasRun){
					return AINode.SUCCESS;//如果有子对象曾经运行，则直接返回上层
				}
				var ww:Number = i<parent.arr.length?  Math.random()*parent.arr[i] : 0;
				if(ww>w){
					w = ww;//比较权重值，并记录
					index = i;//记录最大的权重的index
				}
			}
			childs[index].parent.running_sub = childs[index];//选择权重最大的子对象运行。
			return AINode.WAITSUB;
		}
	}
}