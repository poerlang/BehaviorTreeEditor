package tryai.ai
{
	public class God
	{
		public function God(pid:int){
			select = new Select();
			leaf = new Leaf(pid,this);
		}
		public var select:Select;
		public var leaf:Leaf;
		private var _nodeNow:AINode;
		private var isStop:Boolean;
		public function stop():void
		{
			isStop = true;
		}
		public function start():void
		{
			isStop = false;
		}
		public function get nodeNow():AINode
		{
			return _nodeNow;
		}

		public function set nodeNow(value:AINode):void
		{
			_nodeNow = value;
		}

		public function update(dt:Number):void{
			if(isStop) return;
			if(nodeNow){
				nodeNow.update(dt);
			}
		}
		
		/**	暂停 or 开启	**/
		public function switchPower():void
		{
			if(isStop){
				start();
			}else{
				stop();
			}
		}
		
		public function dispose():void
		{
			if(leaf){
				leaf.dispose();
				leaf = null;
			}
		}
	}
}