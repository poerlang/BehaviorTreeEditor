package tryai
{
	import flash.utils.Dictionary;
	
	import tryai.ai.AINode;
	/**
	 * 行为树管理器
	 */
	public class AiUpdateMgr
	{
		public var dicAINode : Dictionary = new Dictionary();
		public static var one:AiUpdateMgr;
		public function AiUpdateMgr(){
			one = this;
		}
		public function JsonToAI(ob:Object,pid:uint=0):AINode{
			var rootAI:AINode;
			show(ob,null);
			function show(ob:Object,parentAI:AINode):void{
				var aai:AINode = new AINode(parentAI,ob.sel,pid);
				if(parentAI==null){
					rootAI = aai;
				}
				aai.name = ob.name;
				aai.x = ob.x;
				aai.y = ob.y;
				aai.ID = ob.id;
				if(ob.arr)aai.arr = ob.arr;
				if(ob.childs){
					for (var i:int = 0; i < ob.childs.length; i++) 
					{
						show(ob.childs[i],aai);
					}
				}
			}
			dicAINode[pid] = rootAI;
			return rootAI;
		}
		public function get(pid:int):AINode{
			return dicAINode[pid];
		}
		private var lastTime:Number = -1;
		public var canRun:Boolean;
		public function update(t:Number):void{
			if(!canRun)return;
			if(lastTime==-1) lastTime = t-33;
			var dt:Number = (t-lastTime)/1000;//转换成秒
			lastTime = t;
			for (var id:uint in dicAINode) 
			{
				var node:AINode = dicAINode[id];
				node.god.update(dt);
				//node.god.update(0);
			}
		}
	}
}