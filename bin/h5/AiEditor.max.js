
/***********************************/
/*http://www.layabox.com  2017/12/12*/
/***********************************/
var Laya=window.Laya=(function(window,document){
	var Laya={
		__internals:[],
		__packages:{},
		__classmap:{'Object':Object,'Function':Function,'Array':Array,'String':String},
		__sysClass:{'object':'Object','array':'Array','string':'String','dictionary':'Dictionary'},
		__propun:{writable: true,enumerable: false,configurable: true},
		__presubstr:String.prototype.substr,
		__substr:function(ofs,sz){return arguments.length==1?Laya.__presubstr.call(this,ofs):Laya.__presubstr.call(this,ofs,sz>0?sz:(this.length+sz));},
		__init:function(_classs){_classs.forEach(function(o){o.__init$ && o.__init$();});},
		__isClass:function(o){return o && (o.__isclass || o==Object || o==String || o==Array);},
		__newvec:function(sz,value){
			var d=[];
			d.length=sz;
			for(var i=0;i<sz;i++) d[i]=value;
			return d;
		},
		__extend:function(d,b){
			for (var p in b){
				if (!b.hasOwnProperty(p)) continue;
				var gs=Object.getOwnPropertyDescriptor(b, p);
				var g = gs.get, s = gs.set; 
				if ( g || s ) {
					if ( g && s)
						Object.defineProperty(d,p,gs);
					else{
						g && Object.defineProperty(d, p, g);
						s && Object.defineProperty(d, p, s);
					}
				}
				else d[p] = b[p];
			}
			function __() { Laya.un(this,'constructor',d); }__.prototype=b.prototype;d.prototype=new __();Laya.un(d.prototype,'__imps',Laya.__copy({},b.prototype.__imps));
		},
		__copy:function(dec,src){
			if(!src) return null;
			dec=dec||{};
			for(var i in src) dec[i]=src[i];
			return dec;
		},
		__package:function(name,o){
			if(Laya.__packages[name]) return;
			Laya.__packages[name]=true;
			var p=window,strs=name.split('.');
			if(strs.length>1){
				for(var i=0,sz=strs.length-1;i<sz;i++){
					var c=p[strs[i]];
					p=c?c:(p[strs[i]]={});
				}
			}
			p[strs[strs.length-1]] || (p[strs[strs.length-1]]=o||{});
		},
		__hasOwnProperty:function(name,o){
			o=o ||this;
		    function classHas(name,o){
				if(Object.hasOwnProperty.call(o.prototype,name)) return true;
				var s=o.prototype.__super;
				return s==null?null:classHas(name,s);
			}
			return (Object.hasOwnProperty.call(o,name)) || classHas(name,o.__class);
		},
		__typeof:function(o,value){
			if(!o || !value) return false;
			if(value===String) return (typeof o==='string');
			if(value===Number) return (typeof o==='number');
			if(value.__interface__) value=value.__interface__;
			else if(typeof value!='string')  return (o instanceof value);
			return (o.__imps && o.__imps[value]) || (o.__class==value);
		},
		__as:function(value,type){
			return (this.__typeof(value,type))?value:null;
		},
        __int:function(value){
            return value?parseInt(value):0;
        },
		interface:function(name,_super){
			Laya.__package(name,{});
			var ins=Laya.__internals;
			var a=ins[name]=ins[name] || {self:name};
			if(_super)
			{
				var supers=_super.split(',');
				a.extend=[];
				for(var i=0;i<supers.length;i++){
					var nm=supers[i];
					ins[nm]=ins[nm] || {self:nm};
					a.extend.push(ins[nm]);
				}
			}
			var o=window,words=name.split('.');
			for(var i=0;i<words.length-1;i++) o=o[words[i]];
			o[words[words.length-1]]={__interface__:name};
		},
		class:function(o,fullName,_super,miniName){
			_super && Laya.__extend(o,_super);
			if(fullName){
				Laya.__package(fullName,o);
				Laya.__classmap[fullName]=o;
				if(fullName.indexOf('.')>0){
					if(fullName.indexOf('laya.')==0){
						var paths=fullName.split('.');
						miniName=miniName || paths[paths.length-1];
						if(Laya[miniName]) console.log("Warning!,this class["+miniName+"] already exist:",Laya[miniName]);
						Laya[miniName]=o;
					}
				}
				else {
					if(fullName=="Main")
						window.Main=o;
					else{
						if(Laya[fullName]){
							console.log("Error!,this class["+fullName+"] already exist:",Laya[fullName]);
						}
						Laya[fullName]=o;
					}
				}
			}
			var un=Laya.un,p=o.prototype;
			un(p,'hasOwnProperty',Laya.__hasOwnProperty);
			un(p,'__class',o);
			un(p,'__super',_super);
			un(p,'__className',fullName);
			un(o,'__super',_super);
			un(o,'__className',fullName);
			un(o,'__isclass',true);
			un(o,'super',function(o){this.__super.call(o);});
		},
		imps:function(dec,src){
			if(!src) return null;
			var d=dec.__imps|| Laya.un(dec,'__imps',{});
			function __(name){
				var c,exs;
				if(! (c=Laya.__internals[name]) ) return;
				d[name]=true;
				if(!(exs=c.extend)) return;
				for(var i=0;i<exs.length;i++){
					__(exs[i].self);
				}
			}
			for(var i in src) __(i);
		},
        superSet:function(clas,o,prop,value){
            var fun = clas.prototype["_$set_"+prop];
            fun && fun.call(o,value);
        },
        superGet:function(clas,o,prop){
            var fun = clas.prototype["_$get_"+prop];
           	return fun?fun.call(o):null;
        },
		getset:function(isStatic,o,name,getfn,setfn){
			if(!isStatic){
				getfn && Laya.un(o,'_$get_'+name,getfn);
				setfn && Laya.un(o,'_$set_'+name,setfn);
			}
			else{
				getfn && (o['_$GET_'+name]=getfn);
				setfn && (o['_$SET_'+name]=setfn);
			}
			if(getfn && setfn) 
				Object.defineProperty(o,name,{get:getfn,set:setfn,enumerable:false,configurable:true});
			else{
				getfn && Object.defineProperty(o,name,{get:getfn,enumerable:false,configurable:true});
				setfn && Object.defineProperty(o,name,{set:setfn,enumerable:false,configurable:true});
			}
		},
		static:function(_class,def){
				for(var i=0,sz=def.length;i<sz;i+=2){
					if(def[i]=='length') 
						_class.length=def[i+1].call(_class);
					else{
						function tmp(){
							var name=def[i];
							var getfn=def[i+1];
							Object.defineProperty(_class,name,{
								get:function(){delete this[name];return this[name]=getfn.call(this);},
								set:function(v){delete this[name];this[name]=v;},enumerable: true,configurable: true});
						}
						tmp();
					}
				}
		},		
		un:function(obj,name,value){
			value || (value=obj[name]);
			Laya.__propun.value=value;
			Object.defineProperty(obj, name, Laya.__propun);
			return value;
		},
		uns:function(obj,names){
			names.forEach(function(o){Laya.un(obj,o)});
		}
	};

    window.console=window.console || ({log:function(){}});
	window.trace=window.console.log;
	Error.prototype.throwError=function(){throw arguments;};
	//String.prototype.substr=Laya.__substr;
	Object.defineProperty(Array.prototype,'fixed',{enumerable: false});

	return Laya;
})(window,document);

(function(window,document,Laya){
	var __un=Laya.un,__uns=Laya.uns,__static=Laya.static,__class=Laya.class,__getset=Laya.getset,__newvec=Laya.__newvec;
//class tryai.ai.God
var God=(function(){
	function God(pid){
		this.select=null;
		this.leaf=null;
		this._nodeNow=null;
		this.isStop=false;
		this.select=new Select();
		this.leaf=new Leaf(pid,this);
	}

	__class(God,'tryai.ai.God');
	var __proto=God.prototype;
	__proto.stop=function(){
		this.isStop=true;
	}

	__proto.start=function(){
		this.isStop=false;
	}

	__proto.update=function(dt){
		if(this.isStop)return;
		if(this.nodeNow){
			this.nodeNow.update(dt);
		}
	}

	/**暂停 or 开启 **/
	__proto.switchPower=function(){
		if(this.isStop){
			this.start();
			}else{
			this.stop();
		}
	}

	__proto.dispose=function(){
		if(this.leaf){
			this.leaf.dispose();
			this.leaf=null;
		}
	}

	__getset(0,__proto,'nodeNow',function(){
		return this._nodeNow;
		},function(value){
		this._nodeNow=value;
	});

	return God;
})()


//class ColorUtil
var ColorUtil=(function(){
	function ColorUtil(){}
	__class(ColorUtil,'ColorUtil');
	ColorUtil.getRGB=function(color){
		var o={};
		o.r=color >> 16 & 0xFF;
		o.g=color >> 8 & 0xFF;
		o.b=color & 0xFF;
		return o;
	}

	ColorUtil.getUINT=function(r,g,b){
		var h=0;
		h+=r<<16;
		h+=g<<8;
		h+=b;
		return h;
	}

	ColorUtil.Change=function(color,d,part){
		var c=ColorUtil.getRGB(color);
		if(part){
			var npart=c[part]+d;
			c[part]=npart>255?255:npart;
			}else{
			var nr=c.r+d;
			var ng=c.g+d;
			var nb=c.b+d;
			c.r=nr>255?255:nr;
			c.g=ng>255?255:ng;
			c.b=nb>255?255:nb;
		}
		return ColorUtil.getUINT(c.r,c.g,c.b);
	}

	return ColorUtil;
})()


//class com.bit101.components.Style
var Style=(function(){
	function Style(){}
	__class(Style,'com.bit101.components.Style');
	Style.setStyle=function(style){
		switch(style){
			case "dark":
				com.bit101.components.Style.BACKGROUND=0x444444;
				com.bit101.components.Style.BUTTON_FACE=0x666666;
				com.bit101.components.Style.BUTTON_DOWN=0x222222;
				com.bit101.components.Style.INPUT_TEXT=0xBBBBBB;
				com.bit101.components.Style.LABEL_TEXT=0xCCCCCC;
				com.bit101.components.Style.PANEL=0x666666;
				com.bit101.components.Style.PROGRESS_BAR=0x666666;
				com.bit101.components.Style.TEXT_BACKGROUND=0x555555;
				com.bit101.components.Style.LIST_DEFAULT=0x444444;
				com.bit101.components.Style.LIST_ALTERNATE=0x393939;
				com.bit101.components.Style.LIST_SELECTED=0x666666;
				com.bit101.components.Style.LIST_ROLLOVER=0x777777;
				break ;
			case "light":
			default :
				com.bit101.components.Style.BACKGROUND=0xCCCCCC;
				com.bit101.components.Style.BUTTON_FACE=0xFFFFFF;
				com.bit101.components.Style.BUTTON_DOWN=0xEEEEEE;
				com.bit101.components.Style.INPUT_TEXT=0x333333;
				com.bit101.components.Style.LABEL_TEXT=0x666666;
				com.bit101.components.Style.PANEL=0xF3F3F3;
				com.bit101.components.Style.PROGRESS_BAR=0xFFFFFF;
				com.bit101.components.Style.TEXT_BACKGROUND=0xFFFFFF;
				com.bit101.components.Style.LIST_DEFAULT=0xFFFFFF;
				com.bit101.components.Style.LIST_ALTERNATE=0xF3F3F3;
				com.bit101.components.Style.LIST_SELECTED=0xCCCCCC;
				com.bit101.components.Style.LIST_ROLLOVER=0xDDDDDD;
				break ;
			}
	}

	Style.TEXT_BACKGROUND=0xFFFFFF;
	Style.BACKGROUND=0xaaaaaa;
	Style.BUTTON_FACE=0xeeeeee;
	Style.BUTTON_DOWN=0xbbbbbb;
	Style.INPUT_TEXT=0x333333;
	Style.LABEL_TEXT=0x666666;
	Style.DROPSHADOW=0x777777;
	Style.PANEL=0xF3F3F3;
	Style.PROGRESS_BAR=0xFFFFFF;
	Style.LIST_DEFAULT=0xFFFFFF;
	Style.LIST_ALTERNATE=0xF3F3F3;
	Style.LIST_SELECTED=0xCCCCCC;
	Style.LIST_ROLLOVER=0XDDDDDD;
	Style.embedFonts=true;
	Style.fontName="PF Ronda Seven";
	Style.fontSize=8;
	Style.DARK="dark";
	Style.LIGHT="light";
	return Style;
})()


//class props.comm.PSpace extends com.bit101.components.HBox
var PSpace=(function(_super){
	function PSpace(defaultHeight,theAlpha){
		this.ui=null;
		this._val=null;
		(defaultHeight===void 0)&& (defaultHeight=5);
		(theAlpha===void 0)&& (theAlpha=.1);
		PSpace.__super.call(this,null);
		this.ui=new Panel(this,0,0);this.ui.setSize(defaultHeight,defaultHeight);this.ui.alpha=theAlpha;
	}

	__class(PSpace,'props.comm.PSpace',_super);
	return PSpace;
})(HBox)


//class props.comm.PString extends com.bit101.components.HBox
var PString=(function(_super){
	function PString(label){
		this.ui=null;
		this._val="";
		this.sendEvent=true;
		PString.__super.call(this,null);
		new Label(this,0,0,label);
		this.ui=new InputTextNoEvent(this,0,0,"",this.onChange);
		this.ui.height=20;
	}

	__class(PString,'props.comm.PString',_super);
	var __proto=PString.prototype;
	__proto.onChange=function(e){
		this._val=this.ui.textField.text;
		if(this.sendEvent)/*no*/this.dispatchEvent(new EventData(this._val));
	}

	__getset(0,__proto,'val',function(){
		return this._val;
		},function(v){
		this.ui.sendEvent=false;
		this._val=v;
		this.ui.setText(v);
		this.ui.sendEvent=true;
		if(this.sendEvent)/*no*/this.dispatchEvent(new EventData(this._val));
	});

	__getset(0,__proto,'valNoEvent',null,function(v){
		this.ui.sendEvent=false;
		this._val=v;
		this.ui.setText(v);
		this.ui.sendEvent=true;
	});

	return PString;
})(HBox)



	/**LayaGameStart**/
	new AiEditor();

})(window,document,Laya);
