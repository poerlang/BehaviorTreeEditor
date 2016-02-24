package
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quart;
	import com.greensock.plugins.BezierPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.Sprite;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import tryai.AiUpdateMgr;
	import tryai.ai.AINode;
	
	public class NodeContainer extends Sprite
	{
		public var arrowContainer:Sprite;
		public var nodeContainer:Sprite;
		public var posContainer:Sprite;
		public var flashContainer:Sprite;
		public static var one:NodeContainer;
		public function NodeContainer()
		{
			super();
			TweenPlugin.activate([BezierPlugin]);
			one = this;
			arrowContainer = new Sprite();addChild(arrowContainer);
			nodeContainer = new Sprite(); addChild(nodeContainer);
			posContainer = new Sprite();  addChild(posContainer);
			flashContainer = new Sprite();  addChild(flashContainer);
		}
		public function add(id:int=-1):Node{
			unSel();
			var n:Node = new Node(id);
				nodeContainer.addChild(n);
				n.x = 100+int(50*Math.random());
				n.y = 80+int(50*Math.random());
				
				sel(n);
				
				TweenLite.delayedCall(.1,function():void{
					n.showProp();
				});
				return n;
		}
		public var selArr:Vector.<Node> = new Vector.<Node>;
		public function sel(n:Node=null):void
		{
			if(n!=null){
				if(selArr.length==1 && selArr[0]!=n){
					selArr[0].unSel();
					selArr = new Vector.<Node>;
				}
				n.sel();
				if(selArr.indexOf(n)==-1)selArr.push(n);
				TweenLite.delayedCall(.1,function():void{
					if(selArr.length==1){
						selArr[0].showProp();
					}
				});
				return;
			}
			
			var p1:Point = DragBorder.p1;
			var p2:Point = DragBorder.p2;
			unSel();
			forAllNode(function(n:Node):void{
				var mid:Point = n.mid;
				if(mid.x>p1.x && mid.x<p2.x){
					if(mid.y>p1.y && mid.y<p2.y){
						n.sel();
						selArr.push(n);
					}
				}
			});
			TweenLite.delayedCall(.1,function():void{
				if(selArr.length==1){
					selArr[0].showProp();
				}
			});
		}
		
		private function unSel():void
		{
			if(selArr && selArr.length>0){
				for (var i:int = 0; i < selArr.length; i++) {
					selArr[i].unSel();
				}
			}
			selArr = new Vector.<Node>();
		}
		
		public function forAllNode(f:Function):void
		{
			for (var i:int = 0; i < nodeContainer.numChildren; i++) {
				var n:Node = nodeContainer.getChildAt(i) as Node;
				f(n);
			}
		}
		
		public function forAllSel(f:Function):void
		{
			for (var i:int = 0; i < selArr.length; i++) {
				f(selArr[i]);
			}
		}
		public function link():void
		{
			if(selArr.length<=1){
				Alert.show("请选择两个以上的节点");
				return;
			}
			
			var yy:int=99999;
			var pNode:Node;
			forAllSel(function(n:Node):void{
				if(n.y<yy){
					yy = n.y;
					pNode=n;
				}
			});
			if(pNode.isLeaf){
				Alert.show(pNode.titleTxt+"不能作为父节点");
				return;
			}
			forAllSel(function(n:Node):void{
				if(n!=pNode){
					if(n.parentNode){
						if(n.parentNode != pNode){
							n.removeParent();
						}
					}
					n.parentNode = pNode;
				}
			});
			var arr:Vector.<Node> = selArr;
			drawAllSelArrow();
		}
		public var arrowDic:Dictionary = new Dictionary();
		public var curFileX:FileX;

		private var fb:FlashBox;
		private function drawAllSelArrow():void
		{
			forAllSel(function(n:Node):void{
				if(n.parentNode){
					drawArrow(n);
				}
			});			
		}
		
		private function drawArrow(n:Node):void
		{
			n.drawArrow();
		}
		
		public function breakSel():void
		{
			forAllSel(function(n:Node):void{
				if(selArr.indexOf(n.parentNode)!=-1){
					n.removeParent();
				}
			})
		}
		
		public function delAllSel():void
		{
			for (var i:int = 0; i < selArr.length; i++) {
				selArr[i].del();
			}
		}
		
		public function showAiTree(fx:FileX):void
		{
			clear();
			this.curFileX = fx;
			var ob:Object = fx.data;
			AiEditor.aiFileDesc.text = ob.desc;
			
			var ox:int = 250;
			var oy:int = 400;
			
			if(ob.ver>1){
				ox = 0;
				oy = 0;
			}
			
			setANode(ob);
			forAllNode(function(n:Node):void{
				if(n.ID>Node.index){
					Node.index = n.ID;
				}
			});
			
			function setANode(o:Object,p:Node=null):void
			{
				if(o.id==null || o.id==0)o.id=-1;
				var n:Node = add(o.id);
				n.titleTxt = o.sel;
				n.txt = o.name;
				n.x=o.x+ox;
				n.y=o.y+oy;
				n.resize();
				if(p){
					n.parentNode = p;
					n.drawArrow();
				}
				
				var arr:Array = o.childs;
				if(arr && arr.length>0){
					for (var i:int = 0; i < arr.length; i++) 
					{
						var sub:Object = arr[i];
						setANode(sub,n);
					}
				}
			}
		}
		
		public function clear():void
		{
			Node.index = 0;
			Node.flashDic = new Dictionary();
			curFileX = null;
			while(nodeContainer.numChildren){
				var n:Node = nodeContainer.getChildAt(0) as Node;
				n.dispose();
				nodeContainer.removeChild(n);
			}
			while(arrowContainer.numChildren){
				arrowContainer.removeChildAt(0);
			}
		}
		
		public function save():void
		{
			if(!curFileX){
				Alert.show("请新建或选定一个文件，再保存"); return;
			}
			var rootNum:int;
			var root:Node;
			forAllNode(function(n:Node):void{
				if(n.parentNode==null){
					rootNum++;
					root = n;
				}
			});
			if(rootNum>1){
				Alert.show("根节点只能有一个"); return;
			}
			var all:Object = saveNodes(root);
			var fileID:Number = parseInt(curFileX.f.name.replace(".ai",""));
			var s:FileStream = new FileStream();
				s.open(curFileX.f,FileMode.WRITE);
				s.writeUTFBytes(JSON.stringify(all,null,"\t"));
				s.close();
				TweenLite.delayedCall(.2,function():void{
					AIBrowser.one.refresh();
					if(AiEditor.tryMode.selected){
						AiUpdateMgr.one.JsonToAI(all);
						var bossAi:AINode = AiUpdateMgr.one.get(0);
						AINode.send = bossAi;
					}else{
						AiEditor.one.server.send(JSON.stringify({cmd:"save",msg:fileID}));
					}
				});
				
			function saveNodes(nd:Node):Object{
				var ob:Object = {};
				if(nd.parentNode==null) ob.desc = AiEditor.aiFileDesc.text;
				ob.name = nd.txt;
				ob.sel = nd.titleTxt;
				ob.x = nd.x;
				ob.y = nd.y;
				if(nd.txt.indexOf("【")!=-1) ob.arr = parse(ob.name);
				ob.id = nd.ID;
				ob.ver = 2;
				var childs:Array = [];
				forAllNode(function(s:Node):void{
					if(s.parentNode==nd){
						var subOB:Object = saveNodes(s);
						childs.push(subOB);
					}
				});
				childs = AINode.sortX(childs);
				ob.childs = childs;
				return ob;
			}
		}
		
		public function flash(id:int):void{
			var nd:Node = Node.flashDic[id];
			if(!nd) return;
			fb = FlashBox.getPoolObject();
			flashContainer.addChild(fb);
			fb.x = nd.x+5;
			fb.y = nd.y+5;
			
			fb.alpha = .2;
			fb.scaleX = 1;
			fb.scaleY = 1;
			TweenMax.to(fb,.1,{alpha:1,scaleX:1.3,scaleY:1.3,onComplete:function(f:FlashBox):void{
				f.hide();
			},onCompleteParams:[fb]});
		}
		public static function parse(txt:String):Array
		{
			var p:RegExp = new RegExp("【[^【】]*】");//解析类似【2,4,6,100】的格式
			var arr:Array = txt.match(p);
			if(arr==null) return null;
			arr = String(arr[0]).replace("，",",").replace("【","").replace("】","").split(",");
			for (var i:int = 0; i < arr.length; i++) 
			{
				arr[i] = parseFloat(arr[i]);
			}
			return arr;
		}
		public function moveAllSel(dx:Number, dy:Number,nodeNow:Node):void
		{
			forAllSel(function(n:Node):void{
				if(n!=nodeNow){
					n.x+=dx;
					n.y+=dy;
					n.drawArrow();
				}
			})
		}
	}
}