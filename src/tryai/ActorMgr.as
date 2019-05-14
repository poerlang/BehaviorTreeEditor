package tryai
{
	import flash.utils.Dictionary;
	
	import tryai.smlgame.ActorData;

	public class ActorMgr
	{
		public static var one:ActorMgr;
		private var dic:Dictionary = new Dictionary();
		public function ActorMgr()
		{
			one = this;
		}
		
		public function forAllActor(f:Function):void
		{
			for each(var a:ActorData in dic){
				var ok:Boolean = f(a);
				if(ok)return;
			}
		}
		public function add(pid:int):ActorData
		{
			dic[pid] = new ActorData(pid);
			return dic[pid];
		}
		public function getActorById(pid:int):ActorData
		{
			var a:ActorData = dic[pid];
			if(a) return a;
			return null;
		}
	}
}