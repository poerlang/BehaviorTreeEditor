package
{
	public class ColorUtil
	{
		public static function getRGB(color:uint):Object{
			var o:Object = {};
			o.r = color >> 16 & 0xFF;
			o.g = color >> 8  & 0xFF;
			o.b = color       & 0xFF;
			return o;
		}
		
		public static function getUINT(r:uint,g:uint,b:uint):uint{
			var h:uint = 0;
			h+=r<<16;
			h+=g<<8;
			h+=b;
			return h;
		}
		
		/** 加减灰度，如 Gray(0x333333,2) 结果是 0x353535 ，如果part被指定为"r"，则只改变红色部分，其它g和b分别改变绿和蓝**/
		public static function Change(color:uint,d:int,part:String=null):uint{
			var c:Object = getRGB(color);
			if(part){
				var npart:int = c[part]+d;
				c[part] = npart>255?255:npart;
			}else{
				var nr:int = c.r+d;
				var ng:int = c.g+d;
				var nb:int = c.b+d;
				c.r = nr>255?255:nr;
				c.g = ng>255?255:ng;
				c.b = nb>255?255:nb;
			}
			return getUINT(c.r,c.g,c.b);
		}
	}
}