import { ResManager } from "../common/ResManager";

export class ConchXMLHttpRequest extends Laya.EventDispatcher{
	public static UNSENT:number = 0;
	public static OPENED:number = 1;
	public static HEADERS_RECEIVED:number = 2;
	public static LOADING:number = 3;
	public static DONE:number = 4;
    private xhr;
    private _responseText:string;
    private _response:any;
    private _responseType:string;
    private _readyState:number;
    private _status:number;
    private _url:string;
    private _async:boolean;
    private _method:string;
    private _onloadcb:(evt:Event)=>any;
    private _onrchgcb:(evt:Event)=>any;
    private _head:any;
    private _hasReqHeader=false;
    onerror:(evt:Event)=>any;
    withCredentials:boolean=false;
    
    constructor(){
        super();
        this.xhr=new window["_XMLHttpRequest"]();
        this._readyState=0;
        this._responseText=this._response=this._responseType=this._url="";
        this._responseType="text";
        this._method="GET";
        this.xhr._t=this;
        this.xhr.set_onreadystatechange(function(r:number):void{
            var _t=this._t;
            if (r == 1) {
	           _t._readyState = 1;
            }
            if (_t._onrchgcb ) {
                //标准的回调是没有参数的。
                var e=new window['Event']("readystatechange");
                e.target=_t;
                _t._onrchgcb(e);
            }
            //模拟事件
            var ev;
            if(_t._status==200){
                ev=new window['Event']("load");
                ev.target=_t;
                _t.event(ev);
                
            }else if(_t._status==404){
                ev=new window['Event']("error");
                ev.target=_t;
                _t.event(ev);
            }
                
        });
    }
    
    setRequestHeader(name:string,value:string):void{
        this.xhr.setRequestHeader(name,value);
        this._hasReqHeader=true;
    }
    
    getAllResponseHeaders(){
        return this._head;
    }
    
    get responseText()
    {
        return this._responseText;
    }
    
    get response()
    {
        return this._response;
    }
    
    get responseType()
    {
        return this._responseType;
    }
    
    set responseType(type:string)
    {
        this._responseType=type;
        if( type=='blob'){
            this.xhr.responseTypeCode=4;
        }
        else if(type=='arraybuffer'){
            this.xhr.responseTypeCode=5;
        }else{
            this.xhr.responseTypeCode= 1;
        }        
    }
    
    get url()
    {
        return this._url;
    }
    
    get async()
    {
        return this._async;
    }
    
    get readyState():number
    {
        return this._readyState;
    }
    
    get status():number
    {
        return this._status;
    }
    
    private _loadsus():void
    {
         var e=new window['Event']("load");
         e.target=this;
         this._onloadcb(e);
    }
    
    set onreadystatechange(listen:(evt:Event)=>any)
    {
        this._onrchgcb=listen;
        if(listen==null)return;
        if(this._readyState!=0)
        {
            var e=new window['Event']("readystatechange");
            e.target=this;
            this._onrchgcb(e);
        }
    }
    get onreadystatechange():(evt:Event)=>any
    {
        return this._onrchgcb;
    }
    
    set onload(listen:((evt:Event)=>any))
    {
        this._onloadcb=listen;
        if(listen==null)return;
        if(this._readyState==4&&this._status==200)
        {
            this._loadsus();
        }
    }
    get onload():(evt:Event)=>any
    {
        return this._onloadcb;
    }
    getResponseHeader()
	{
		return this._head;
	}
	setResponseHeader=function(name,value)
	{
		this._head=value;
	}
    
    open(type:string,url:string,async:boolean)
    {
        //url = encodeURI(url);
        console.log('ConchXMLHttpRequest xhr.'+type+' url='+url);
        if(!url)return;
		type=type.toUpperCase();
		async=true;
        url = window["location"].resolve(url);
		this._method=(type==='POST'?'POST':'GET');
		this._url = url;
		this._async = (async == null || async == undefined || async == true) ? true : false;
		this.xhr._open(this._method, this._url, this._async);
    }
    
    overrideMimeType(mime:string):void
    {
        if(this._responseType=="text"||this._responseText=="")
                this._responseType="arraybuffer";
        this.xhr.mimeType="1";
    }
    
    send(body:any):void
    {
        if(body){
            if(body instanceof ArrayBuffer|| ArrayBuffer.isView(body) || body instanceof DataView )
                this._responseType='arraybuffer';
            else if( body instanceof Object){
                body = JSON.stringify(body);
            }
        }
        this.xhr._t=this;
        var onPostLoad:any=function(buf,strbuf)
        {
            var _t=this._t;
            if (_t.responseType == 'arraybuffer')
            {
                _t._response = buf;
                _t._responseText = strbuf;
            }
            else
            {
                _t._response=_t._responseText=buf;
            }
            //console.log('xhr post ret:'+_t.responseText);
            _t._readyState = 4;
            _t._status = 200;
            _t.xhr._changeState(4);
            if(_t._onloadcb)
            {
                _t._loadsus();
            }
            onPostLoad.ref=onPostError.ref=null;
        }
        var onPostError:any=function(e1:number, e2:number){
            var _t=this._t;//不用this是因为jsc有泄露
            _t._readyState = 4;
            _t._status = 404;//e; 目前好像只有200和404
            _t.xhr._changeState(4);
            if(_t.onerror)
            {
                var ev=new window['Event']("error");
                ev.target=_t;
                ev['ecode1']=e1;   //curl返回值
                ev['ecode2']=e2;   //http返回值。
                _t.onerror(ev);
            }
            onPostLoad.ref=onPostError.ref=null;
        }        
        if(this._method=='POST' && body){
            onPostLoad.ref=onPostError.ref=this.xhr;
		    this.xhr.setPostCB( onPostLoad,onPostError );
			this.xhr.postData(this.url,body);
		}else if( this._hasReqHeader){
            onPostLoad.ref=onPostError.ref=this.xhr;
		    this.xhr.setPostCB( onPostLoad,onPostError );
            this.xhr.getData(this.url)
        }
		else
		{
            let relative_url = this.url
            let cdn_res_path = ResManager.GetInstance().cdn_res_path;
            if (cdn_res_path && relative_url.indexOf(cdn_res_path) >= 0) {
                relative_url = relative_url.replace(cdn_res_path, "");
            }
            var folder = window["conch"].getCachePath()+"/";
            var package_url = relative_url.replace("?v=", "_v=")
            // console.log("package_url = "+package_url)
            var package_obj
            if(this._responseType == "arraybuffer"){
                package_obj = window["conch"].readFileFromAsset(package_url, "raw")
            }else{
                package_obj = window["conch"].readFileFromAsset(package_url, "utf8")
            }
            var cachepath:String = folder + relative_url;
            //判断文件是否存在
            if (package_obj || window["fs_exists"](cachepath)) {
                var result
                if(package_obj)
                {
                    // console.log("包内文件存在 = "+package_url)
                    result = package_obj
                    if(this._responseType == "arraybuffer"){
                        this._response = result
                    }else{
                        this._response = this._responseText = result;
                    }
                }else
                {
                    // console.log("缓存文件存在 = "+cachepath+this._responseType)
                    if(this._responseType == "arraybuffer"){
                        result = window["fs_readFileSync"](cachepath)
                        this._response = result
                    }else{
                        result = window["readFileSync"](cachepath, "utf8");
                        this._response = this._responseText = result;
                    }
                }
                if(this._responseType=="json")
                {
                    this._response=JSON.parse(result);
                }
                if(result)
                {
                    if(this.xhr.mimeType)
                    {
                       var u8arr = new Uint8Array(this._response);
                       var strret="";
                        u8arr.forEach((v, i, arr) => {
                            if (v >=0x80) {
                                strret += String.fromCharCode(0xf700 | v);
                            }
                            else if( v==0 ){
                                strret+='\0';
                            }
                            else {
                                strret += String.fromCharCode(v);
                            }
                        });
                        this._responseText =  strret;
                    }
                    this._readyState = 4;
                    this._status = 200;
                    this.xhr._changeState(4);
                    if (this._onloadcb) {
                        this._loadsus();
                    }
                    return
                }
            }else
            {
                // console.log("缓存文件和包内文件都不存在，需要下载 = "+cachepath)
            }
            
			var file = new window["conch_File"](this.url);
			var fileRead = new window["conch_FileReader"]();
			fileRead.sync = !this.async;
			if( this._responseType == "text" || this._responseType == "TEXT" ){
				fileRead.responseType = 0;
			}else if( this._responseType == "arraybuffer" ){
				fileRead.responseType = 1;
			}else{
				console.log("XMLhttpRequest 暂不支持的类型 responseType=" + this.responseType );
			}
            fileRead._t=this;
			fileRead.onload = function () {
                var _t=this._t;
                var relativeFolder = folder + relative_url.substring(0,relative_url.lastIndexOf("/"));
                if (!window["fs_exists"](relativeFolder)) {
                    // console.log("create dir = "+relativeFolder)
                    window["fs_mkdir"](relativeFolder);
                }else
                {
                    // console.log("dir exists = "+relativeFolder)
                }
				if( _t._responseType == "arraybuffer" ){
					_t._response = this.result;
                    window["fs_writeFileSync"](cachepath, this.result);
                    //_t._responseText=?
				}else{
                    _t._response=_t._responseText = this.result;
                    window["writeStrFileSync"](cachepath, this.result);
                    if(_t._responseType=="json")
                    {
                        _t._response=JSON.parse(this.result);
                    }
				}
				if(_t.xhr.mimeType)
				{
				   var u8arr = new Uint8Array(_t._response);
				   var strret="";
					u8arr.forEach((v, i, arr) => {
						if (v >=0x80) {
							strret += String.fromCharCode(0xf700 | v);
						}
						else if( v==0 ){
							strret+='\0';
						}
						else {
							strret += String.fromCharCode(v);
						}
					});
					_t._responseText =  strret;
				}
				_t._readyState = 4;
				_t._status = 200;
				_t.xhr._changeState(4);
				if (_t._onloadcb) {
				    _t._loadsus();
				}
				fileRead.onload =null;
				fileRead.onerror = null;
				//_this.onreadystatechange=null;
			}
			fileRead.onerror = function () {
                var _t=this._t;
			    _t._readyState = 4;
			    _t._status = 404;
			    _t.xhr._changeState(4);
                if(_t.onerror)
                {
                    var ev=new window['Event']("error");
                    ev.target=_t;
                    _t.onerror(ev);
                }
				fileRead.onload =null;
				fileRead.onerror = null;
			}
			if(this.onerror){
                fileRead.setIgnoreError(true);
            }
			if( this.responseType == "arraybuffer" )
				fileRead.readAsArrayBuffer(file);
			else
				fileRead.readAsText(file);
		}
    }

    //扩展的
   /* async:boolean;
    method:string;
    evtmap:Object;  //TODO 这个要去掉。*/
}
