package
{
	import com.bit101.components.ListItem;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	
	public class ListItemX extends ListItem
	{

		private var icon:Bitmap;
		public function ListItemX(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, data:Object=null)
		{
			super(parent, xpos, ypos, data);
			icon = new Bitmap(new BitmapData(25,25));
			addChild(icon);
		}
		public override function draw() : void
		{
			super.draw();
			if(Node.leafTypes.indexOf(_label.text)==-1){
				icon.bitmapData = Node.trunkbd;
			}else{
				icon.bitmapData = Node.leafbd;
			}
			addChildAt(icon,0);
			icon.scaleX = 0.7;
			icon.scaleY = 0.7;
			icon.alpha = 0.7;
			icon.x = _label.x+_label.getBounds(this).width+2;
		}
	}
}