package
{
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import comm.EventData;
	
	import props.PropertyPanel;
	import props.comm.PSpace;
	import props.comm.PString;
	import props.comm.PStringComboBox;
	
	public class Node extends DragSprite
	{
		private var bg:Box;
		private var bgTitle:Box;
		public static const dw:int=100;
		public static const dh:int=45;
		public var ww:int=100;
		public var hh:int=45;
		private var titleHeight:int=20;
		private var pad:int=2;
		private var bgColor:uint=0x000000;
		private var bgColorSel:uint=0x003300;
		private var bgTitleColor:uint=0x333333;
		private var bgTitleColorSel:uint=0x005500;
		[Embed(source="../psd/leaf.png",mimeType="image/png")]
		public static var ClassPicLeaf:Class;
		[Embed(source="../psd/trunk.png",mimeType="image/png")]
		public static var ClassPicTrunk:Class;
		public static var leafbd:BitmapData = (new ClassPicLeaf() as Bitmap).bitmapData;
		public static var trunkbd:BitmapData = (new ClassPicTrunk() as Bitmap).bitmapData;
		private var _mid:Point = new Point;
		public static var flashDic:Dictionary = new Dictionary();
		public function get mid():Point
		{
			_mid.x = int(x+width*.5);
			_mid.y = int(y+height*.5);
			return _mid;
		}
		public static var index:Number=0;
		public var parentNode:Node;
		private var _ID:Number;

		public function get ID():Number
		{
			return _ID;
		}

		public function set ID(value:Number):void
		{
			_ID = value;
			flashDic[_ID] = this;
		}

		public function Node(id:int=-1)
		{
			super();
			if(id==-1){
				index++;
				ID = index;
			}else{
				ID = id;
			}
			
			
			bg 		= new Box(this,1,1,bgColor);
			bgTitle = new Box(this,1,1,bgTitleColor);
			
			
			var bd:BitmapData = new BitmapData(25,25);
			iconBitmap = new Bitmap(bd);
			addChild(iconBitmap);
			
			_titleTxt = new LableX(this,2,2); _titleTxt.color = 0x778888;	_titleTxt.width=20; _titleTxt.x=25;
			_txt = new LableX(this,2,22); _txt.color = 0xeeeeee;			_txt.width=20;
			
			addEventListener(MouseEvent.MOUSE_DOWN,onDown);
			addEventListener(MouseEvent.MOUSE_UP,onUp);
			addEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStage);
			
			__titleTxt.ui.width = 170;
			__txt.ui.width = 170;
			
			__titleTxt.addEventListener(EventData.EVENT_DATA,onDataTitle);
			__txt.addEventListener(EventData.EVENT_DATA,onDataTxt);
			
		}
		
		protected function onDataTitle(e:EventData):void
		{
			titleTxt = e.data;
			resize();
		}
		protected function onDataTxt(e:EventData):void
		{
			txt = e.data;
			resize();
		}
		
		protected function onRemoveFromStage(e:Event):void
		{
			del(e);
		}
		public function dispose():void{
			removeEventListener(MouseEvent.MOUSE_DOWN,onDown);
			removeEventListener(MouseEvent.MOUSE_UP,onUp);
			bg.dispose();
			bgTitle.dispose();
			_mid = null;
		}
		protected function onUp(e:MouseEvent):void
		{
			p2 = new Point(x,y);
			
			if(p1 != null){
				var dx:Number = p2.x-p1.x;
				var dy:Number = p2.y-p1.y;
				p1 = null;
				p2 = null;
				NodeContainer.one.moveAllSel(dx,dy,this);
			}
			drawArrow();
		}
		
		private var lastPos:Point = new Point();

		public var hasRemoveParentAndKillMe:Boolean;

		public static var typeArr:Array = ["And","All","Or","Not","AndReturnTrue","CountAndLoop","NotAgainInXsec","Rnd"];
		public static var leafTypes:Array = ["IsTargetExist","HpLowTo","IsTargetOutOfFollowRads","IsTargetInAttRads","IsTargetInSkillRads","FindNPCInMap","FindPlayerInMap","FindTargetInViewRads","MoveToTarget","MoveAroundTarget","MoveAroundBornPos","MoveAndKeepDist","MoveToPoint","BackToBornPos","TurnDirToTarget","Alert","Attack","Skill","SkillCDReady","StandPose","SetTargetToNull","justTrue","justFalse","delayTrue","RndDelayTrue","delayFalse"];
		private var _titleTxt:LableX;
		private var _txt:LableX;
		private var __txt:PString = new PString("注释");
		private var __titleTxt:PStringComboBox = new PStringComboBox("类型",typeArr.concat(leafTypes));
		private var __space:PSpace = new PSpace(1);
		private var p1:Point;
		private var p2:Point;
		private var _isLeaf:Boolean;

		private var iconBitmap:Bitmap;

		public function get isLeaf():Boolean
		{
			return _isLeaf;
		}

		public function set isLeaf(v:Boolean):void
		{
			_isLeaf = v;
			if(v){
				iconBitmap.bitmapData = leafbd;
			}else{
				iconBitmap.bitmapData = trunkbd;
			}
			addChild(iconBitmap);
		}

		public function showProp():void
		{
			PropertyPanel.one.show(this,__space,__titleTxt,__txt);
		}
		public function get titleTxt():String
		{
			return _titleTxt.text;
		}

		public function set titleTxt(v:String):void
		{
			_titleTxt.text = v;
			__titleTxt.valNoEvent = v;
			if(leafTypes.indexOf(v)!=-1){
				isLeaf=true;
			}else{
				isLeaf=false;
			}
		}


		public function get txt():String
		{
			return _txt.text;
		}

		public function set txt(v:String):void
		{
			_txt.text = v;
			__txt.valNoEvent = v;
		}
		
		public function resize():void
		{
			TweenLite.delayedCall(.6,resizeX);
		}
		
		private function resizeX():void
		{
			var r:Rectangle;
			var r2:Rectangle = _txt.textField.getBounds(this);
			var r1:Rectangle = _titleTxt.textField.getBounds(this);
			if(r1.width+25>r2.width){
				r=r1;
				ww = r.width+25+3;
			}else{
				r=r2;
				ww = r.width+10+3;
			}
			
			draw();
			drawArrow();
		}
		
		protected function onDown(event:MouseEvent):void
		{
			NodeContainer.one.sel(this);
			p1 = new Point(x,y);
		}
		
		public function draw():void
		{
			if(txt==""){
				hh=27;
			}else{
				hh=dh;
			}
			bg.setSize(ww,hh);
			bgTitle.setSize(ww-pad*2,titleHeight); bgTitle.x=pad; bgTitle.y=pad;
		}
		
		public function sel():void
		{
			if(bg.color==bgColorSel)return;
			bg.color = bgColorSel;
			bgTitle.color = bgTitleColorSel;
		}
		public function unSel():void
		{
			if(bg.color==bgColor)return;
			bg.color = bgColor;
			bgTitle.color = bgTitleColor;
		}
		
		public function drawArrow():void
		{
			if(parentNode){
				var key:Number = parentNode.ID*10000 + ID;
				var a:Arrow = NodeContainer.one.arrowDic[key];
				if(!a){
					NodeContainer.one.arrowDic[key] = a = new Arrow(this,parentNode);
					NodeContainer.one.arrowContainer.addChild(a);
				}else{
					a.draw(this,parentNode);
				}
			}
			var me:Node = this;
			NodeContainer.one.forAllNode(function(sub:Node):void{
				if(sub.parentNode==me){
					sub.drawArrow();
				}
			});
		}
		
		public function removeParent():void
		{
			if(hasRemoveParentAndKillMe)return;
			if(parentNode==null)return;
			var key:Number = parentNode.ID*10000 + ID;
			var a:Arrow = NodeContainer.one.arrowDic[key];
			if(a){
				NodeContainer.one.arrowContainer.removeChild(a);
				delete NodeContainer.one.arrowDic[key];
			}
			parentNode = null;
		}
		public function del(e:Event=null):void
		{
			removeParent();
			hasRemoveParentAndKillMe = true;
			var me:Node = this;
			NodeContainer.one.forAllNode(function(n:Node):void{
				if(n.parentNode==me){
					if(!n.hasRemoveParentAndKillMe)n.removeParent();
				}
			});
			if(e==null)NodeContainer.one.nodeContainer.removeChild(this);
			dispose();
		}
	}
}