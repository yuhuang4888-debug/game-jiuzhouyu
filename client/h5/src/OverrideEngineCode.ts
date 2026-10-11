import { ResManager } from "./common/ResManager";
import { ConchXMLHttpRequest } from "./util/ConchXMLHttpRequest";
import { GameError } from "./util/GameError";
import { Config } from "./common/Config";
import { LayerManager } from "./common/LayerManager";
import { ClientConfig } from "./util/DeclareGlobalVar";
import { Util } from "./util/Util";

let local_Util = Util
export class OverrideEngineCode
{
    //在引擎调用Init之前的覆盖方法
    public static BeforeEngineInit()
    {
        //覆盖引擎实现的类方法
        let local_Laya = Laya
        //原生包的重写逻辑
        if(window["conch"])
        {
            let w:any = window
            w.XMLHttpRequest = ConchXMLHttpRequest;
            // w.Image = w.HTMLImageElement = ConchHTMLImageElement;

            // local_Laya.Loader.prototype["_loadHtmlImage"] = function(url: string, onLoadCaller: any, onLoad: Function, onErrorCaller: any, onError: Function): void {
            //     url = window["location"].resolve(url);
            //     let relative_url = url
            //     let cdn_res_path = ResManager.GetInstance().cdn_res_path;
            //     if (cdn_res_path && relative_url.indexOf(cdn_res_path) >= 0) {
            //         relative_url = relative_url.replace(cdn_res_path, "");
            //     }
            //     let not_load_package = url.indexOf(".png") > 0 || url.indexOf(".jpg") > 0 //目前png和jpg通过readFileFromAsset加载回来的数据不对，暂时先屏蔽他，以后有新方式在尝试。ktx可以用
            //     var folder = window["conch"].getCachePath()+"/";
            //     var package_url
            //     var package_obj
            //     if(!not_load_package)
            //     {
            //         package_url = relative_url.replace("?v=", "_v=")
            //         console.log("package_url = " + package_url)
            //         package_obj = window["conch"].readFileFromAsset(package_url, "raw")
            //     } 
            //     var cachepath:String = folder + relative_url;
            //     //判断图片是否存在
            //     if (package_obj || window["fs_exists"](cachepath)) {
            //         try{
            //             var result;
            //             if (package_obj) {
            //                 console.log("包内图片存在 = " + package_url+package_obj);
            //                 result = package_obj;
            //                 var image = new w.HTMLImageElement();
            //                 image.crossOrigin = "";
            //                 // image.onload = onload;
            //                 // image.onerror = onerror;
            //                 // image.src = url;
            //                 // if(!not_load_package)
            //                 // {
            //                     image.putImageData(result);
            //                 // }else
            //                 // {
            //                 //     image.putImageData(result);
            //                     // var fileRead = new window["conch_FileReader"]();
            //                     // fileRead.sync = false
            //                     // fileRead.onload = function(e) {
            //                     //     // callback(e.target.result);
            //                     //     onLoad.call(onLoadCaller, e.target.result);
            //                     // };
            //                     // fileRead.readAsDataURL(result);


            //                 // }
            //                 local_Laya.Loader["_imgCache"][url] = image;
            //                 onLoad.call(onLoadCaller, image);
            //             }
            //             else {
            //                 console.log("缓存图片存在 = " + cachepath);
            //                 result = window["fs_readFileSync"](cachepath);
            //                 var image = new w.HTMLImageElement();
            //                 image.crossOrigin = "";
            //                 image.putImageData(result, 52, 164);
            //                 onLoad.call(onLoadCaller, image);
            //             }
            //         }catch(e)
            //         {
            //             console.log(e)
            //         }
            //     }else
            //     {
            //         console.log("缓存图片和包内图片都不存在，需要下载 = "+cachepath)
            //         var image: any;
            //         function clear(): void {
            //             var img: any = image;
            //             img.onload = null;
            //             img.onerror = null;
            //             delete local_Laya.Loader["_imgCache"][url];
            //         }
            //         var onerror: Function = function (): void {
            //             clear();
            //             onError.call(onErrorCaller);
            //         }
                    
            
            //         var onload: Function = function (e): void {
            //             clear();
            //             var relativeFolder = folder + relative_url.substring(0,relative_url.lastIndexOf("/"));
            //             if (!window["fs_exists"](relativeFolder)) {
            //                 console.log("create dir = "+relativeFolder)
            //                 window["fs_mkdir"](relativeFolder);
            //             }else
            //             {
            //                 console.log("dir exists = "+relativeFolder)
            //             }
            //             window["fs_writeFileSync"](cachepath, image._nativeObj.getImageData(0,0,52, 164));
            //             onLoad.call(onLoadCaller, image);
            //         };
            //         image = new local_Laya.Browser.window.Image();
            //         image.crossOrigin = "";
            //         image.onload = onload;
            //         image.onerror = onerror;
            //         image.src = url;
            //         local_Laya.Loader["_imgCache"][url] = image;//增加引用，防止垃圾回收
            //     }
            // }
        }

        if (!Object.values) 
        {
            Object.values = function(obj) 
            { //有些浏览器不支持values，所以要重新实现
                if (obj && obj == Object(obj))
                {
                    var val=[],key;
                    for (key in obj) {
                        if (Object.prototype.hasOwnProperty.call(obj,key)) {
                            val.push(obj[key]);
                        }
                    }
                    return val;
                }
            }
        }

        // let source_timer_update = local_Laya.Timer.prototype["_update"]
        // local_Laya.Timer.prototype["_update"] = function (caller: any, method: Function): void {
        //     if(!this.force_update_in_next_frame && !LayerManager.GetInstance().CheckFrameTimeValid())
        //     {
        //         this.force_update_in_next_frame = true
        //         return
        //     }else
        //     {
        //         this.force_update_in_next_frame = false
        //     }
        //     source_timer_update.call(this)
        // }


        // local_Laya.Timer.prototype.runTimer = function (caller: any, method: Function): void {
        //     var handler = this._getHandler(caller, method);
        //     if (handler && handler.method != null) {
        //         delete this._map[handler.key]
        //         handler.run(true);
        //     }
        // }


        local_Laya.Stage.prototype["_updateTimers"] = function(): void {
            local_Laya.systemTimer["_update"]();
            // local_Laya.startTimer._update();
            // local_Laya.physicsTimer._update();
            // local_Laya.updateTimer._update();
            // local_Laya.lateTimer._update();
            local_Laya.timer["_update"]();
        }

        // 	/**
        // 	 * 渲染入口
        // 	 */
        // local_Laya.Scene3D.prototype.renderSubmit = function () {
        // 		this._prepareSceneToRender();
        // 		var i: number, n: number, n1: number;
        // 		local_Laya.Scene3D._updateMark++;
        // 		for (i = 0, n = this._cameraPool.length, n1 = n - 1; i < n; i++) {
        // 			if (local_Laya.Render.supportWebGLPlusRendering)
        //                 local_Laya.ShaderData.setRuntimeValueMode((i == n1) ? true : false);
        // 			var camera = (this._cameraPool[i]);
        // 			camera.enableRender && camera.render();
        // 		}
        //         // if(this.name == "UIScene3D")
        //         // {
        //         //     var gl = local_Laya["LayaGL"].instance;
        //         //     var context = local_Laya.RenderContext3D["_instance"];
        //         //     this._clear(gl, context);
            
        //         //     this._renderScene(context,local_Laya.Scene3D.SCENERENDERFLAG_RENDERQPAQUE);
        //         //     this._renderScene(context,local_Laya.Scene3D.SCENERENDERFLAG_RENDERTRANSPARENT);
        //         // }
        // 		local_Laya.Context.set2DRenderConfig();//还原2D配置
        // 		return 1;
        // 	}

        //重写富文本格式不对的问题
        // local_Laya.Utils.parseXMLFromString = function (value: string): XMLDocument {
        //     var rst: any;
        //     value = value.replace(/>\s+</g, '><');
        //     rst = (new DOMParser()).parseFromString(value, 'text/xml');
        //     if (rst.firstChild.textContent.indexOf("This page contains the following errors") > -1) {
        //        window["GameError"].GetInstance().SendErrorToPHP("富文本内容: "+ value + " 报错栈：" + rst.firstChild.firstChild.textContent)
        //     }
        //     return rst;
        // }

        //有重复 回收回调错误的bug
        local_Laya.Handler.prototype.clear = function ()
        {
            return this
        }

        local_Laya.Handler.prototype.recover = function ()
        {
        }

        let original_measureText =  local_Laya.Browser.measureText
        local_Laya.Browser.measureText = function (txt: string, font: string): any {
            let r = original_measureText(txt, font)
            if(!r)
            {
                r = {width: 24}
            }
            return r
        }


        // local_Laya.Text.prototype.set_text = function (value: string) {
        //     this.changeText(value);
        //     // if (this._tf.text != value) {
        //     //     if (value)
        //     //         value = UIUtils.adptString(value + "");
        //     //     this._tf.text = value;
        //     //     this.event(Event.CHANGE);
        //     //     if (!this._width || !this._height) this.onCompResize();
        //     // }
        // }

        //后面有重写过加载回调的方法，去掉了prefix和compress的相关逻辑判断，所以该方法暂时弃用
        // let FormatAtlasObj = function (atlas_obj:any)
        // {
        //     let meta = atlas_obj.meta
        //     if(meta)
        //     {
        //         if(meta.prefix)
        //         {
        //             meta.prefix = null
        //         }
        //         if(meta.compressTextureIOS || meta.compressTextureAndroid)
        //         {
        //             meta.compressTextureIOS = meta.compressTextureAndroid = true
        //         }
        //     }
        // }

        // let onHttpLoadedTarget
        // onHttpLoadedTarget = new local_Laya.EventDispatcher()
        // onHttpLoadedTarget.OnHttpLoaded = function (is_atlas, onLoadCaller, onLoad, data)
        // {
        //     if(is_atlas && data)
        //     {
        //         FormatAtlasObj(data)
        //     }
        //     onLoad && onLoad.call(onLoadCaller, data)
        // }
        if(window["print_load_res_url"])
        {
            window["package_obj"] = []
            local_Laya.Loader.prototype["_loadResourceFilter"] = function(type: string, url: string): void {
                this._loadResource(type, url);
                //去掉前缀
                let index = url.indexOf('resource/')
                if(index > -1)
                {
                    url = url.slice(index)
                }
                //是否有参数
                index = url.indexOf('?')
                if(index > -1){
                    url = url.slice(0, index)
                }
                if(window["package_obj"].indexOf(url) < 0)
                {
                    window["package_obj"].push(url)
                }
            }
        }

        let source_onScrollBarChange = local_Laya.List.prototype["onScrollBarChange"]
        local_Laya.List.prototype["onScrollBarChange"] = function(e?) {
            if(this._cells)
            {
                source_onScrollBarChange.call(this, e)
            }
        }


        local_Laya.Loader.prototype["_loadHttpRequest"] = function (url: string, contentType: string, onLoadCaller: Object, onLoad: Function | null, onProcessCaller: any, onProcess: Function | null, onErrorCaller: any, onError: Function): void {
            let is_atlas = url.indexOf(".atlas") > 0
            if (is_atlas) {
                if(local_Laya.Loader["all_uiconfig_config"])
                {
                    let index = url.lastIndexOf("/")
                    let config_name = `${url.substring(url.indexOf("/game/") + 6, index)}/texture.atlas`
                    let ui_layout_obj = local_Laya.Loader["all_uiconfig_config"][config_name]
                    if(ui_layout_obj)
                    {
                        // FormatAtlasObj(ui_layout_obj)
                        onLoad.call(onLoadCaller, ui_layout_obj);
                        return
                    }
                }
            }

            // if (local_Laya.Browser.onVVMiniGame || local_Laya.Browser.onHWMiniGame) {
                // this._http = new local_Laya.HttpRequest();//临时修复vivo复用xmlhttprequest的bug
            // // } else {
                if (!this._http || !this._http.on) //有可能是wxmini库里面特殊创建的thisLoader._http = {url: url}
                    this._http = new local_Laya.HttpRequest();
            // }
            // onProcess && this._http.on(local_Laya.Event.PROGRESS, onProcessCaller, onProcess);
            onLoad && this._http.on(local_Laya.Event.COMPLETE, onLoadCaller, onLoad);
            // this._http.on(local_Laya.Event.COMPLETE, onHttpLoadedTarget, onHttpLoadedTarget.OnHttpLoaded, [is_atlas, onLoadCaller, onLoad]);
            this._http.on(local_Laya.Event.ERROR, onErrorCaller, onError);
            this._http.send(url, null, "get", contentType);
        }

        local_Laya.HttpRequest.prototype.send = function(url: string, data: any = null, method: string = "get", responseType: string = "text", headers: any[]|null = null): void {
            this._responseType = responseType;
            this._data = null;

            // if (Browser.onVVMiniGame || Browser.onQGMiniGame || Browser.onQQMiniGame || Browser.onAlipayMiniGame || Browser.onBLMiniGame || Browser.onHWMiniGame || Browser.onTTMiniGame || Browser.onTBMiniGame) {
            //     url = HttpRequest._urlEncode(url);
            // }
            this._url = url;
            var _this: Laya.HttpRequest = this;
            var http = this._http;
            //临时，因为微信不支持以下文件格式
            // if(local_Util.IsConch())
            // {
            //     let index = url.indexOf('?')
            //     if(index > -1){
            //         //去参数
            //         url = url.slice(0, index)
            //     }
            // }
            http.open(method, url, true);
            let isJson = false;
            if (headers) {
                for (var i: number = 0; i < headers.length; i++) {
                    http.setRequestHeader(headers[i++], headers[i]);
                }
            } else if (!(((<any>window)).conch)) {
                if (!data || typeof (data) == 'string') http.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
                else{ 
                    http.setRequestHeader("Content-Type", "application/json");
                    if (!(data instanceof ArrayBuffer) && typeof data !== "string") {
                        isJson=true;
                    }
                }
            }
            let restype: XMLHttpRequestResponseType = responseType !== "arraybuffer" ? "text" : "arraybuffer";
            http.responseType = restype;
            if ((http as any).dataType) {//for Ali
                (http as any).dataType = restype;
            }
            http.onerror = function (e: any): void {
                _this["_onError"](e);
            }
            http.onabort = function (e: any): void {
                _this["_onAbort"](e);
            }
            http.onprogress = function (e: any): void {
                _this["_onProgress"](e);
            }
            http.onload = function (e: any): void {
                _this["_onLoad"](e);
            }
            // if(Browser.onBLMiniGame&&Browser.onAndroid&&!data)data={};
            http.send( isJson?JSON.stringify(data):data);
        }


        ResManager.SOURCE_TEXTGC = local_Laya.TextRender.prototype.GC
        local_Laya.TextRender.prototype.GC = function ()
        {

        }

        //如果文本设置了0的行距 则默认用10的行距
        let Default_Text_leading = 10  
        let source_renderText = local_Laya.Text.prototype["_renderText"]
        local_Laya.Text.prototype["_renderText"] = function ()
        {
            if(this.leading == 0 && this._lines.length > 1)
            {
                this.leading = Default_Text_leading
            }
            source_renderText.call(this)
        }

        let source_evalTextSize = local_Laya.Text.prototype["_evalTextSize"]
        local_Laya.Text.prototype["_evalTextSize"] = function ()
        {
            if(this.leading == 0 && this._lines.length > 1)
            {
                this.leading = Default_Text_leading
            }
            source_evalTextSize.call(this)
        }

        let source_multiLineLayout = local_Laya.Layout._multiLineLayout
        local_Laya.Layout._multiLineLayout = function (element)
        {
            var style = element["_getCSSStyle"]();
            if(style.leading == 0)
            {
                style.leading = Default_Text_leading
            }
            let result = source_multiLineLayout(element)
            result[1] -= style.leading
            return result
        }


        Laya.EventDispatcher.prototype.event = function(type: string, data: any = null): boolean {
            if (!this._events || !this._events[type]) return false;

            var listeners: any = this._events[type];
            if (listeners.run) {
                if (listeners.once) delete this._events[type];
                data != null ? listeners.runWith(data) : listeners.run();
            } else {
                for (var i: number = 0, n: number = listeners.length; i < n; i++) {
                    var listener: Handler = listeners[i];
                    if (listener) {
                        (data != null) ? listener.runWith(data) : listener.run();
                    }
                    if (!listener || listener.once) {
                        listeners.splice(i, 1);
                        i--;
                        n--;
                    }
                }
                if (listeners.length === 0 && this._events && (this._events[type] == null || !this._events[type].run)) // 最后是春阳加的判断，防止误删除注册的事件
                    delete this._events[type];
            }
            
            return true;
        }


        let cache_view_pool = []
        // for(var i = 0; i < 1000; i ++)
        // {
        //     cache_view_pool.push(new local_Laya.View())
        // }
        let ResetSprite = function(sp)
        {
            sp._x = 0;
            sp._y = 0;
            sp._width = 0;
            sp._height = 0;
            sp._visible = true;
            sp._mouseState = 0;
            sp._zOrder = 0;
            sp._renderType = 0;
            sp._transform = null;
            sp._tfChanged = false;
            sp._repaint = local_Laya.SpriteConst.REPAINT_NONE;
            sp._texture  = null;

            sp._style = local_Laya.SpriteStyle.EMPTY;
            sp._cacheStyle = local_Laya["CacheStyle"].EMPTY;
            sp._boundStyle = null;
            sp._graphics = null;
            sp.mouseThrough = false;
            sp.autoSize = false;
            sp.hitTestPrior = false;

            sp._bits = 0;
            sp._children = local_Laya.Node["ARRAY_EMPTY"];

            sp._extUIChild = local_Laya.Node["ARRAY_EMPTY"];

            sp._components = null
            sp._activeChangeScripts = null//TODO:可用对象池
            sp._scene = null;

            sp._parent = null;
            sp.name = "";
            sp.destroyed = false;
            sp._conchData = null;
        }
        let GetViewFromPool = function()
        {
            let view = cache_view_pool.shift()
            if(view)
            {
                ResetSprite(view)

                local_Laya.Scene.unDestroyedScenes.push(view);
                view._scene = view;
                view.autoDestroyAtClosed = false;
                view._viewCreated = false;

                view._dataSource = null;
                view._anchorX = NaN;
                view._anchorY = NaN;
                view._widget = local_Laya.Widget.EMPTY;
                view.createChildren();
            }else
            {
                view = new local_Laya.View()
            }
            return view
        }
        
        let scene_destroy = local_Laya.Scene.prototype.destroy
        local_Laya.View.prototype.destroy =  function(destroyChild: boolean = true, not_cache = false): void {
            if(this.destroyed) return
            this._watchMap = {};
            scene_destroy.call(this, destroyChild);
            if(!not_cache)
            {
                this.skin_dependence_map = null
                cache_view_pool.push(this)
            }
        }

       
        let cache_texture2d_pool = []
        window["cache_texture2d_pool"] = cache_texture2d_pool
        let GetTexture2dFromPool = function(width: number = 0, height: number = 0, format = local_Laya.TextureFormat.R8G8B8A8, mipmap: boolean = true, canRead: boolean = false)
        {
            let texture2d = cache_texture2d_pool.shift()
            if(texture2d)
            {
                texture2d._url = null;
                texture2d._cpuMemory = 0;
                texture2d._gpuMemory = 0;


                texture2d.name = null;
                texture2d._id = ++local_Laya.Resource["_uniqueIDCounter"];
                texture2d._destroyed = false;
                texture2d._referenceCount = 0;
                local_Laya.Resource["_idResourcesMap"][texture2d.id] = texture2d;
                texture2d.lock = false;


                texture2d._mipmapCount = null;
                texture2d._wrapModeU = local_Laya.WarpMode.Repeat;
                texture2d._wrapModeV = local_Laya.WarpMode.Repeat;
                texture2d._filterMode = local_Laya.FilterMode.Bilinear;

                texture2d._readyed = false;
                texture2d._format = format;
                texture2d._mipmap = mipmap;
                texture2d._anisoLevel = 1;
                var gl: WebGLRenderingContext = local_Laya["LayaGL"].instance;
                texture2d._glTexture = gl.createTexture();

                texture2d._pixels = null;//TODO:是否合并格式

                texture2d._glTextureType = gl.TEXTURE_2D;
                texture2d._width = width;
                texture2d._height = height;
                texture2d._canRead = canRead;

                texture2d._setWarpMode(gl.TEXTURE_WRAP_S, texture2d._wrapModeU);//TODO:重置宽高需要调整
                texture2d._setWarpMode(gl.TEXTURE_WRAP_T, texture2d._wrapModeV);//TODO:重置宽高需要调整
                texture2d._setFilterMode(texture2d._filterMode);//TODO:重置宽高需要调整
                texture2d._setAnisotropy(texture2d._anisoLevel);

                var compress: boolean = texture2d._gpuCompressFormat();//if the format is compress,_setPixels() will cause webgl error
                if (mipmap) {
                    var mipCount: number = Math.max(Math.ceil(Math.log2(width)) + 1, Math.ceil(Math.log2(height)) + 1);
                    if (!compress) {
                        for (var i: number = 0; i < mipCount; i++)
                            texture2d._setPixels(null, i, Math.max(width >> i, 1), Math.max(height >> i, 1));//init all level
                    }
                    texture2d._mipmapCount = mipCount;
                    texture2d._setGPUMemory(width * height * 4 * (1 + 1 / 3));
                } else {
                    if (!compress)
                        texture2d._setPixels(null, 0, width, height);//init 0 level
                    texture2d._mipmapCount = 1;
                    texture2d._setGPUMemory(width * height * 4);
                }
            }else
            {
                texture2d = new local_Laya.Texture2D(width, height, format, mipmap, canRead)
            }
            return texture2d
        }
        window["GetTexture2dFromPool"] = GetTexture2dFromPool

        let Texture2d_type
        let source_resource_destroy = local_Laya.Texture2D.prototype.destroy
        local_Laya.Texture2D.prototype.destroy = function (): void {
            if (!this._destroyed) {
                source_resource_destroy.call(this)
                if(!Texture2d_type)
                    Texture2d_type = new local_Laya.Texture2D()["constructor"].name
                if(this["constructor"].name == Texture2d_type && cache_texture2d_pool.length < 2000)
                    cache_texture2d_pool.push(this)
            }
        }

        local_Laya.WorkerLoader.prototype["_loadImage"] = function (url: string): void {
            var _this = this;
            let type = _this.type;
            if (!this._useWorkerLoader || !local_Laya.WorkerLoader["_enable"]) {
                local_Laya.WorkerLoader["_preLoadFun"].call(_this, url);
                return;
            }
            url = local_Laya.URL.formatURL(url);
            function clear(): void {
                local_Laya.WorkerLoader.I.off(url, _this, onload);
            }

            var onload: Function = function (imageData: any): void {
                clear();
                if (imageData) {
                    var image:any = imageData;
                    if (type !== "nativeimage") {
                        image = GetTexture2dFromPool();
                        (image).wrapModeU = local_Laya.WarpMode.Clamp;
                        (image).wrapModeV = local_Laya.WarpMode.Clamp;
                        image.loadImageSource(imageData,true);
                    }
                    
                    _this["onLoaded"](image);
                } else {
                    //失败之后使用原版的加载函数加载重试
                    local_Laya.WorkerLoader["_preLoadFun"].call(_this, url);
                }
            };
            local_Laya.WorkerLoader.I.on(url, _this, onload);
            local_Laya.WorkerLoader.I.loadImage(url);
        }


        local_Laya.Texture2D["_parse"] = function (data: any, propertyParams: any = null, constructParams: any[] = null) {
            var texture = constructParams ? GetTexture2dFromPool(constructParams[0], constructParams[1], constructParams[2], constructParams[3], constructParams[4]) : GetTexture2dFromPool(0, 0);
            if (propertyParams) {
                texture.wrapModeU = propertyParams.wrapModeU;
                texture.wrapModeV = propertyParams.wrapModeV;
                texture.filterMode = propertyParams.filterMode;
                texture.anisoLevel = propertyParams.anisoLevel;
            }
            let TextureFormat = local_Laya.TextureFormat
            switch (texture._format) {
                case TextureFormat.R8G8B8:
                case TextureFormat.R8G8B8A8:
                    texture.loadImageSource(data);
                    break;
                default:
                    texture.setCompressData(data);
                    break;
            }
            return texture;
        }



        let cache_texture_pool = []
        window["cache_texture_pool"] = cache_texture_pool
        let GetTextureFromPool = function(tex_2d,uv: ArrayLike<number> = null, sourceWidth: number = 0, sourceHeight: number = 0)
        {
            let texture = cache_texture_pool.shift()
            if(texture)
            {
                texture.uvrect = [0, 0, 1, 1]; //startu,startv, urange,vrange
                texture._destroyed = false;
                texture._uv = null
                texture._referenceCount = 0;
                texture._nativeObj = null;

                texture.$_GID = 0;
                texture.offsetX = 0;
                texture.offsetY = 0;
                texture._w = 0;
                texture._h = 0;

                texture.sourceWidth = 0;
                texture.sourceHeight = 0;
                texture.url = null;
                texture.scaleRate = 1;
                if(tex_2d)
                    texture.setTo(tex_2d, uv, sourceWidth, sourceHeight);
            }else
            {
                texture = new local_Laya.Texture(tex_2d, uv, sourceWidth, sourceHeight)
            }
            return texture
        }
        window["GetTextureFromPool"] = GetTextureFromPool

        local_Laya.Texture.prototype.load = function (url: string, complete = null) {
            var _this = (<Laya.Texture>(this as any));
            if (!_this["_destroyed"])
                local_Laya.loader.load(url, local_Laya.Handler.create(_this, _this["_onLoaded"], [complete]), null, "image", 1, true);
        }
        let source_texture_destroy = local_Laya.Texture.prototype.destroy
        local_Laya.Texture.prototype.destroy = function (force: boolean = false): void {
            if (!this._destroyed) {
                source_texture_destroy.call(this, force)
                this._bitmap = null
                if(cache_texture_pool.length < 2000)
                    cache_texture_pool.push(this)
            }
        }
        local_Laya.Texture["_create"] = function (source, x: number, y: number, width: number, height: number, offsetX: number = 0, offsetY: number = 0, sourceWidth: number = 0, sourceHeight: number = 0, outTexture = null) {
            var btex: boolean = source instanceof local_Laya.Texture;
            var uv = btex ? (source).uv : local_Laya.Texture.DEF_UV;
            var bitmap = btex ? (source).bitmap : source;

            if (bitmap.width && (x + width) > bitmap.width)
                width = bitmap.width - x;
            if (bitmap.height && (y + height) > bitmap.height)
                height = bitmap.height - y;
            var tex;
            if (outTexture) {
                tex = outTexture;
                tex.setTo(bitmap, null, sourceWidth || width, sourceHeight || height);
            } else {
                tex = GetTextureFromPool(bitmap, null, sourceWidth || width, sourceHeight || height)
            }
            tex.width = width;
            tex.height = height;
            tex.offsetX = offsetX;
            tex.offsetY = offsetY;

            var dwidth: number = 1 / bitmap.width;
            var dheight: number = 1 / bitmap.height;
            x *= dwidth;
            y *= dheight;
            width *= dwidth;
            height *= dheight;

            var u1: number = tex.uv[0], v1: number = tex.uv[1], u2: number = tex.uv[4], v2: number = tex.uv[5];
            var inAltasUVWidth: number = (u2 - u1), inAltasUVHeight: number = (v2 - v1);
            var oriUV: any[] = local_Laya.Texture.moveUV(uv[0], uv[1], [x, y, x + width, y, x + width, y + height, x, y + height]);
            tex.uv = new Float32Array([u1 + oriUV[0] * inAltasUVWidth, v1 + oriUV[1] * inAltasUVHeight,
            u2 - (1 - oriUV[2]) * inAltasUVWidth, v1 + oriUV[3] * inAltasUVHeight,
            u2 - (1 - oriUV[4]) * inAltasUVWidth, v2 - (1 - oriUV[5]) * inAltasUVHeight,
            u1 + oriUV[6] * inAltasUVWidth, v2 - (1 - oriUV[7]) * inAltasUVHeight]);

            var bitmapScale: number = (((bitmap as any))).scaleRate;
            if (bitmapScale && bitmapScale != 1) {
                tex.sourceWidth /= bitmapScale;
                tex.sourceHeight /= bitmapScale;
                tex.width /= bitmapScale;
                tex.height /= bitmapScale;
                tex.scaleRate = bitmapScale;
            } else {
                tex.scaleRate = 1;
            }
            return tex;
        }

        let cache_scene3d_pool = []
        let GetScene3DFromPool = function()
        {
            let scene3d = cache_scene3d_pool.shift()
            if(scene3d)
            {
                ResetSprite(scene3d)
                scene3d._shaderValues = new local_Laya.ShaderData();
                scene3d._scene = scene3d;
            }else
            {
                scene3d = new local_Laya.Scene3D()
            }
            return scene3d
        }
        window["GetScene3DFromPool"] = GetScene3DFromPool

        let Sprite_destroy = local_Laya.Sprite.prototype.destroy
        local_Laya.Scene3D.prototype.destroy = function (destroyChild: boolean = true): void {
            if(this.destroyed) return
            Sprite_destroy.call(this, destroyChild);
            this._renders.elements.length = 0;
            this._renders.length = 0;
            this._animatorPool.elements.length = 0;
            this._animatorPool.length = 0;
            this._cameraPool.length = 0;
            cache_scene3d_pool.push(this)
        }



        let cache_image_pool = []
        let GetImageFromPool = function()
        {
            let image = cache_image_pool.shift()
            if(image)
            {
                ResetSprite(image)
                image._anchorX = NaN;
                image._anchorY = NaN;
                image._dataSource = null
                image._toolTip = null
                image._tag = null
                image._disabled = null
                image._gray = null
                image._widget = local_Laya.Widget.EMPTY;

                image._skin = null
                image._group = null

                image._bitmap.autoCacheCmd = true;
                image._bitmap._width = 0;
                image._bitmap._height = 0;
                image._bitmap._source = null;
                image._bitmap_isChanged = false;
                image._bitmap._offset = null;
                image._bitmap.uv = null;
                image._bitmap._drawGridCmd = null;
                image._bitmap._sizeGrid = null
                image.sy_img_url = ""

                image.preinitialize();
                image.createChildren();
                image.initialize();
            }else
            {
                // image = new local_Laya.Image()
            }
            return image
        }
        window["GetImageFromPool"] = GetImageFromPool

        let UIComponent_destroy = local_Laya.UIComponent.prototype.destroy
        local_Laya.Image.prototype.destroy = function (destroyChild: boolean = true): void {
            if(this.destroyed) return
            UIComponent_destroy.call(this, destroyChild);
            this._bitmap && this._bitmap.destroy();
            cache_image_pool.push(this)
        }
        local_Laya.Image.prototype["createChildren"] = function (): void {
            this.graphics = this._bitmap = (this._bitmap || new local_Laya.AutoBitmap());
            this._bitmap.autoCacheCmd = false;
        }

        local_Laya.Image.prototype["setSource"] = function (url: string, img: any = null): void {
            if (url === this._skin && img) {
                if (!this._bitmap || this.destroyed) return
                this.source = img
                this.onCompResize();
            }
        }




        // let cache_box_pool = []
        // let GetBoxFromPool = function()
        // {
        //     let box = cache_box_pool.shift()
        //     if(box)
        //     {
        //         ResetSprite(box)
        //         box._anchorX = NaN;
        //         box._anchorY = NaN;
        //         box._dataSource = null
        //         box._toolTip = null
        //         box._tag = null
        //         box._disabled = false
        //         box._gray = null
        //         box._widget = local_Laya.Widget.EMPTY;

        //         box._bgColor = null


        //         box.preinitialize();
        //         box.createChildren();
        //         box.initialize();
        //     }else
        //     {
        //         // box = new local_Laya.Box()
        //     }
        //     return box
        // }
        // window["GetBoxFromPool"] = GetBoxFromPool

        // let Box_type = new local_Laya.Box()["constructor"].name
        // let Sprite_destroy = local_Laya.Sprite.prototype.destroy
        // local_Laya.UIComponent.prototype.destroy = function (destroyChild: boolean = true): void {
        //     if(this.destroyed) return
        //     Sprite_destroy.call(this, destroyChild);
        //     this._dataSource = null;
        //     this._tag = null;
        //     this._toolTip = null;
        //     // if(this["constructor"].name == Box_type)
        //     // {
        //     //     cache_box_pool.push(this);
        //     // }
        // }

        // let cache_label_pool = []
        // let GetLabelFromPool = function()
        // {
        //     let label = cache_label_pool.shift()
        //     if(label)
        //     {
        //         ResetSprite(label)
        //         label._anchorX = NaN;
        //         label._anchorY = NaN;
        //         label._dataSource = null
        //         label._toolTip = null
        //         label._tag = null
        //         label._disabled = null
        //         label._gray = null
        //         label._widget = local_Laya.Widget.EMPTY;
        //         let text = label._tf
        //         ResetSprite(text)
        //         text._clipPoint = null;
        //         text._text = null
        //         text._isChanged = null
        //         text._textWidth = 0;
        //         text._textHeight = 0;
        //         text._lines = [];
        //         text._lineWidths = [];
        //         text._startX = 0;
        //         text._startY = 0;
        //         text._words = null
        //         text._charSize = {};
        //         text._valign = "top";
        //         text._fontSize = local_Laya.Text.defaultFontSize;
        //         text._font = local_Laya.Text.defaultFont;
        //         text._color = "#000000";

        //         text._singleCharRender = false;	// 拆分渲染

        //         text.overflow = local_Laya.Text.VISIBLE;
        //         text._style = local_Laya.TextStyle.EMPTY;

        //         label.preinitialize();
        //         label.createChildren();
        //         label.initialize();
        //     }else
        //     {
        //         // label = new local_Laya.label()
        //     }
        //     return label
        // }

        // window["GetLabelFromPool"] = GetLabelFromPool
        // local_Laya.Label.prototype["createChildren"] = function (): void {  //重现 不addchild 以免报错
        //     this._tf = new local_Laya.Text()
        // }
        // let Label_type = new local_Laya.Label()["constructor"].name
        // local_Laya.Label.prototype.destroy = function (destroyChild: boolean = true): void {
        //     if(this.destroyed) return
        //     UIComponent_destroy.call(this, destroyChild);
        //     if(this["constructor"].name == Label_type)
        //     {
        //         cache_label_pool.push(this);
        //     }else
        //     {
        //         this._tf = null
        //     }
        // }
        // local_Laya.Label.prototype["createChildren"] = function (): void {
        //     this.addChild(this._tf = this._tf || new local_Laya.Text());
        // }

        //加载ui布局文件默认最高级别的加载队列
        local_Laya.SceneLoader.prototype["loadOne"] = function(url: any, is3D: boolean = false): void {
            if (is3D) {
                local_Laya.loader.create(url, this._completeHandler);
            } else
                this._curUrl = url;
                var type: string = local_Laya.Utils.getFileExtension(this._curUrl);
                if (local_Laya.SceneLoader.LoadableExtensions[type]) {
                    local_Laya.loader.load(url, this._completeHandler, null, local_Laya.SceneLoader.LoadableExtensions[type], 0);
                } else if (url != local_Laya.AtlasInfoManager.getFileLoadPath(url) || local_Laya.SceneLoader.No3dLoadTypes[type] || !local_Laya.LoaderManager.createMap[type]) {
                    local_Laya.loader.load(url, this._completeHandler, null, null, 0 );
                } else {
                    local_Laya.loader.create(url, this._completeHandler, null, null, null, null, 0);
                }
        }


        var create = function(url: string, complete: Handler = null): void {
            var obj: any = local_Laya.Loader.getRes(url);
            if (!obj) console.warn("Can not find scene:" + url);
            var scene
            scene = GetViewFromPool()
            if (scene && scene instanceof local_Laya.Node) {
                scene["url"] = url;
                if (scene["_viewCreated"]) {
                    complete && complete.runWith(scene);
                } else {
                    scene["on"]("onViewCreated", null, function (): void {
                        complete && complete.runWith(scene)
                    })
                    scene["createView"](obj);
                }
            } else {
                console.warn("Can not find scene:" , scene);
            }
        }
        local_Laya.Scene.load = function (url: string, complete: Handler = null): void {

            local_Laya.loader.resetProgress();
            var loader = new local_Laya.SceneLoader();
            // loader.on(local_Laya.Event.PROGRESS, null, onProgress);
            loader.once(local_Laya.Event.COMPLETE, null, create, [url, complete]);
            loader.load(url);
        }

        let SceneUtils = local_Laya.SceneUtils
        SceneUtils.createByData = function(root: any, uiView: any): any {
            //递归创建节点
            root = SceneUtils.createComp(uiView, root, root, null, null);

            //设置页面穿透
            if (root._$componentType === "Scene" && root._width > 0 && uiView.props.hitTestPrior == null && !root.mouseThrough)
                root.hitTestPrior = true;

            root.event("onViewCreated");
            return root;
        }

        SceneUtils.createComp = function (uiView: any, comp: any = null, view: any = null, dataMap: any[] = null, initTool = null): any {
            comp = comp || SceneUtils.getCompInstance(uiView);
            if (!comp) {
                if (uiView.props && uiView.props.runtime)
                    console.warn("runtime not found:" + uiView.props.runtime);
                else
                    console.warn("can not create:" + uiView.type);
                return null;
            }

            var child: any[] = uiView.child;
            if (child) {
                var isList: boolean = comp["_$componentType"] == "List";
                for (var i: number = 0, n: number = child.length; i < n; i++) {
                    var node: any = child[i];
                    if (local_Laya.ClassUtils['_isDrawType'](node.type)) {
                        local_Laya.ClassUtils['_addGraphicToSprite'](node, comp, true);
                    }else
                    {
                        if (isList) {
                            //收集数据绑定信息
                            var arr: any[] = [];
                            var tChild: any = SceneUtils.createComp(node, null, view, arr, initTool);
                            if (arr.length)
                                tChild["_$bindData"] = arr;
                        } else {
                            tChild = SceneUtils.createComp(node, null, view, dataMap, initTool);
                        }
                    }
                    if (node.props.renderType == "mask" || node.props.name == "mask") {
                        comp.mask = tChild;
                    } else {
                        tChild instanceof local_Laya.Node && comp.addChild(tChild);
                    }
                }
            }

            var props: any = uiView.props;
            for (var prop in props) {
                var value: any = props[prop];
                SceneUtils['setCompValue'](comp, prop, value, view, dataMap);
            }

            if (comp._afterInited) {
                //if (initTool) {
                //initTool.addInitItem(comp);
                //} else {
                comp._afterInited();
                //}
            }
            return comp;
        }

        SceneUtils['setCompValue'] = function (comp: any, prop: string, value: any, view: any = null, dataMap: any[] = null): void {
            //处理数据绑定
            comp[prop] = value;
            if(view && value && (prop == "texture" || prop == "skin"))
            {
                if(value.indexOf("/texture/") < 0)//value.indexOf("resource/game") >= 0 &&
                {
                    let skin_dependence_map = view.skin_dependence_map
                    if(!skin_dependence_map)
                    {
                        skin_dependence_map = {}
                        view.skin_dependence_map = skin_dependence_map
                    }
                    skin_dependence_map[value] = true
                }
            }
        }



        SceneUtils.getCompInstance = function (json: any): any {
            var runtime: string = json.type;
            let obj
            if(runtime == "Image")
            {
                obj = GetImageFromPool()
            // }else if(runtime == "Box")
            // {
            //     // obj = GetBoxFromPool()
            // }else if(runtime == "Label")
            // {
            //     obj = GetLabelFromPool()
            }
            if(!obj)
            {
                // test_com_counts[runtime] = test_com_counts[runtime] || 0
                // test_com_counts[runtime] ++
                var compClass = local_Laya.ClassUtils.getClass(runtime);
                if (!compClass) throw "Can not find class " + runtime;
                obj = new compClass();
            }
            // console.log("----------compClass Image---------", test_com_counts["Image"])
            // console.log("----------compClass-- Box-------", test_com_counts["Box"])
            // console.log("----------compClass---- Label-----", test_com_counts["Label"])
            return obj
        }

        local_Laya.Loader.setGroup = function(url: string, group: string): void {
        }

        local_Laya.Loader.getRes = function(url: string): any {
            url = local_Laya.URL.formatURL(url)
            var res = local_Laya.Loader.textureMap[url];
            if (res)
                return res;
            else
                return local_Laya.Loader.loadedMap[url];
        }

        /**
         * 资源加载完成的处理函数。
         * @param	data 数据。
         */
        local_Laya.Loader.prototype["onLoaded"] = function(data: any = null): void {
            var type = this._type;
            var Loader = local_Laya.Loader
            let tex:any
            switch(type)
            {
                case Loader.IMAGE:
                    //可能有另外一种情况
                    if (data instanceof ArrayBuffer) {
                        let format = local_Laya.TextureFormat.ETC1RGB;
                        tex = GetTexture2dFromPool(0, 0, format, false, false);
                        tex.wrapModeU = local_Laya.WarpMode.Clamp;
                        tex.wrapModeV = local_Laya.WarpMode.Clamp;
                        tex.setCompressData(data);
                        tex._setCreateURL(this.url);
                    } else if (!(data instanceof local_Laya.Texture2D)) {
                        tex = GetTexture2dFromPool(data.width, data.height, 1, false, false);
                        tex.wrapModeU = local_Laya.WarpMode.Clamp;
                        tex.wrapModeV = local_Laya.WarpMode.Clamp;
                        tex.loadImageSource(data, true);
                        tex._setCreateURL(data.src);
                    } else {
                        tex = data;
                    }
                    var texture = GetTextureFromPool(tex);
                    texture.url = this._url;
                    this.complete(texture);
                    break;
                case Loader.SOUND:
                case "nativeimage":
                    this.complete(data);
                    break;
                case "htmlimage":
                    tex = GetTexture2dFromPool(data.width, data.height, 1, false, false);
                    tex.wrapModeU = local_Laya.WarpMode.Clamp;
                    tex.wrapModeV = local_Laya.WarpMode.Clamp;
                    tex.loadImageSource(data, true);
                    tex._setCreateURL(data.src);
                    this.complete(tex);
                    break;
                case Loader.ATLAS:
                    //处理图集
                    if (data.frames) {
                        var toloadPics: string[] = [];
                        if (!this._data) {
                            this._data = data;
                            //构造加载图片信息
                            if (data.meta && data.meta.image) {
                                //带图片信息的类型
                                toloadPics = data.meta.image.split(",");
                                var split: string = this._url.indexOf("/") >= 0 ? "/" : "\\";
                                var idx: number = this._url.lastIndexOf(split);
                                var folderPath: string = idx >= 0 ? this._url.substr(0, idx + 1) : "";
                                var changeType: string | null = null;
            
                                if (local_Util.use_ktx && (data.meta.compressTextureIOS || data.meta.compressTextureAndroid)) {
                                    changeType = ".ktx";
                                }
                                for (var i = 0, len = toloadPics.length; i < len; i++) {
                                    if (changeType) {
                                        toloadPics[i] = folderPath + toloadPics[i].replace(".png", changeType);
                                    } else {
                                        toloadPics[i] = folderPath + toloadPics[i];
                                    }
            
                                }
                            } else {
                                //不带图片信息
                                toloadPics = [this._url.replace(".json", ".png")];
                            }
            
                            //保证图集的正序加载
                            toloadPics.reverse();
                            data.toLoads = toloadPics;
                            data.pics = [];
                        }
                        // this.event(local_Laya.Event.PROGRESS, 0.3 + 1 / toloadPics.length * 0.6);
                        var url = local_Laya.URL.formatURL(toloadPics.pop());
                        var ext = local_Laya.Utils.getFileExtension(url);
                        let type = Loader.IMAGE;
                        if (ext == "ktx") {
                            type = Loader.BUFFER;
                        }
                        return this._loadResourceFilter(type, url);
                    } else {
                        var url: string;
                        if (!(data instanceof local_Laya.Texture2D)) {
                            if (data instanceof ArrayBuffer) {
                                url = this._http ? this._http.url : this._url;
                                var ext: string = local_Laya.Utils.getFileExtension(url);
                                let format = local_Laya.TextureFormat.ETC1RGB;
                                let tex = GetTexture2dFromPool(0, 0, format, false, false);
                                tex.wrapModeU = local_Laya.WarpMode.Clamp;
                                tex.wrapModeV = local_Laya.WarpMode.Clamp;
                                tex.setCompressData(data);
                                tex._setCreateURL(url);
                                data = tex;
                            } else {
                                let tex = GetTexture2dFromPool(data.width, data.height, 1, false, false);
                                tex.wrapModeU = local_Laya.WarpMode.Clamp;
                                tex.wrapModeV = local_Laya.WarpMode.Clamp;
                                tex.loadImageSource(data, true);
                                tex._setCreateURL(data.src);
                                data = tex;
                            }
                        }
                        if(!this._data.pics)
                        {
                            let type = "this._type = " + (this._type || "null")
                            let http_url = "_________this._http.url = " + (this._http ? this._http.url : "null")
                            let url = "____________this.url = " + (this._url || "null")
                            GameError.GetInstance().SendErrorToPHP("-----this._data.pics is null---" + type + http_url + url)
                            return
                        }
                        this._data.pics.push(data);
                        if (this._data.toLoads.length > 0) {
                            // this.event(Event.PROGRESS, 0.3 + 1 / this._data.toLoads.length * 0.6);
                            //有图片未加载
                            var url = local_Laya.URL.formatURL(this._data.toLoads.pop());
                            var ext = local_Laya.Utils.getFileExtension(url);
                            let type = Loader.IMAGE;
                            if (ext == "ktx") {
                                type = Loader.BUFFER;
                            }
                            return this._loadResourceFilter(type, url);
                        }
                        var frames: any = this._data.frames;
                        var cleanUrl: string = this._url.split("?")[0];
                        var directory: string = cleanUrl.substring(0, cleanUrl.lastIndexOf(".")) + "/";
                        var pics: any[] = this._data.pics;
                        var atlasURL = local_Laya.URL.formatURL(this._url);
                        var map: any[] = Loader.atlasMap[atlasURL] || (Loader.atlasMap[atlasURL] = []);
                        ((<any>map)).dir = directory;
                        if (this._data.meta && this._data.meta.scale && this._data.meta.scale != 1) {
                            var scaleRate: number = 1;
                            scaleRate = parseFloat(this._data.meta.scale);
                            for (var name in frames) {
                                var obj: any = frames[name];//取对应的图
                                var tPic = pics[obj.frame.idx ? obj.frame.idx : 0];//是否释放
                                url = directory + name;
                                ((<any>tPic)).scaleRate = scaleRate;
                                var tTexture;
                                tTexture = local_Laya.Texture["_create"](tPic, obj.frame.x, obj.frame.y, obj.frame.w, obj.frame.h, obj.spriteSourceSize.x, obj.spriteSourceSize.y, obj.sourceSize.w, obj.sourceSize.h, Loader.getRes(url));
                                Loader.cacheTexture(url, tTexture);
                                tTexture.url = url;
                                map.push(url);
                            }
                        } else {
                            for (name in frames) {
                                obj = frames[name];//取对应的图
                                tPic = pics[obj.frame.idx ? obj.frame.idx : 0];//是否释放
                                url = directory + name;
                                tTexture = local_Laya.Texture["_create"](tPic, obj.frame.x, obj.frame.y, obj.frame.w, obj.frame.h, obj.spriteSourceSize.x, obj.spriteSourceSize.y, obj.sourceSize.w, obj.sourceSize.h, Loader.getRes(url));
                                Loader.cacheTexture(url, tTexture);
                                tTexture.url = url;
                                map.push(url);
                            }
                        }
            
                        delete this._data.pics;
                        this.complete(this._data);
                    }
                    break;
                case Loader.FONT:
                    //处理位图字体
                    if (!data._source) {
                        this._data = data;
                        // this.event(Event.PROGRESS, 0.5);
                        return this._loadResourceFilter(Loader.IMAGE, this._url.replace(".fnt", ".png"));
                    } else {
                        var bFont = new local_Laya.BitmapFont();
                        bFont.parseFont(this._data, GetTextureFromPool(data));
                        var tArr: any[] = this._url.split(".fnt")[0].split("/");
                        var fontName = tArr[tArr.length - 1];
                        local_Laya.Text.registerBitmapFont(fontName, bFont);
                        this._data = bFont;
                        this.complete(this._data);
                    }
                    break;
                default:
                    this.complete(data);
                    break;
            }
        }

        let source_tween_clearAll = local_Laya.Tween.clearAll
        local_Laya.Tween.clearAll = function (target: any): void {
            source_tween_clearAll(target)
            if(target)
                delete local_Laya.Tween["tweenMap"][target.$_GID]
        }

        local_Laya.Tween.prototype["_remove"] = function (): void {
            var tweens: any[] = local_Laya.Tween["tweenMap"][this._target.$_GID];
            if (tweens) {
                for (var i: number = 0, n: number = tweens.length; i < n; i++) {
                    if (tweens[i] === this) {
                        tweens.splice(i, 1);
                        break;
                    }
                }
                if(tweens.length == 0)
                    delete local_Laya.Tween["tweenMap"][this._target.$_GID]
            }
        }
        local_Laya.Tween["tweenMap"] = {}

        //修复输入文本获取焦点后消失的bug
        let TextInput_createChildren = local_Laya.TextInput.prototype["createChildren"]
        local_Laya.TextInput.prototype["createChildren"] = function(){
            TextInput_createChildren.call(this)
            this._tf._focus = false
        }

        local_Laya.HTMLDivElement.prototype['_onMouseClick'] = function(e:Laya.Event): void {
            var tX: number = this.mouseX;
            var tY: number = this.mouseY;
            var i: number, len: number;
            var tHit;
            len = this._recList.length;
            for (i = 0; i < len; i++) {
                tHit = this._recList[i];
                if (tHit && tHit.rec.contains(tX, tY)) {
                    this._eventLink(tHit.href, e);
                }
            }
        }

        local_Laya.HTMLDivElement.prototype['_eventLink'] = function(href: string, e?:Laya.Event): void {
            if(e)
            {
                this.event(Laya.Event.LINK, [href, e]);
            }else
            {
                this.event(Laya.Event.LINK, [href]);
            }
        }

        // local_Laya.Text.prototype["_getContextFont"] = function (): string {
        //     let new_fz = this.fontSize * 2
        //     return (this.italic ? "italic " : "") + (this.bold ? "bold " : "") + new_fz + "px " + (local_Laya.Browser.onIPhone ? (Text["fontFamilyMap"][this.font] || this.font) : this.font);
        // }

        local_Laya.HTMLElement.prototype["_addChildsToLayout"] = function(out:[]): boolean {
            var words:[] = this._getWords();
            if (words == null && (!this._children || this._children.length == 0))
                return false;
            if (words) {
                for (var i: number = 0, n: number = words.length; i < n; i++) {
                    out.push(words[i]);
                }
            }
            if (this._children)
                this._children.forEach(function (o, index: number, array: any[]): void {
                    var _style = (o._style);
                    _style && _style._enableLayout && _style._enableLayout() && o._addToLayout(out);
                });
            return true;
        }
        if(local_Util.IsWXGame() || local_Util.IsKSGame() || local_Util.IsMTGame())
        {
            local_Laya.Utils.parseXMLFromString = function (value) {
                var rst;
                value = value.replace(/>\s+</g, '><');
                rst = (new local_Laya.MiniAdpter.window.Parser.DOMParser()).parseFromString(value, 'text/xml');
                if (rst.firstChild.textContent.indexOf("This page contains the following errors") > -1) {
                    GameError.GetInstance().SendErrorToPHP("htmlContent format error "+ value);
                    return false
                    // throw new Error(rst.firstChild.firstChild.textContent);许我半盏清茶
                }
                return rst;
            };
        }else if(local_Util.IsQQGame()){
            local_Laya.Utils.parseXMLFromString = function (value) {
                var rst;
                value = value.replace(/>\s+</g, '><');
                try {
                    rst = (new local_Laya.QQMiniAdapter.window.Parser.DOMParser()).parseFromString(value, 'text/xml');
                }
                catch (error) {
                    throw "需要引入xml解析库文件";
                }
                return rst;
            };
        }else if(local_Util.IsBiliBiliGame()){
            local_Laya.Utils.parseXMLFromString = function (value) {
                var rst;
                value = value.replace(/>\s+</g, '><');
                rst = (new local_Laya.BLMiniAdapter.window.Parser.DOMParser()).parseFromString(value, 'text/xml');
                if (rst.firstChild.textContent.indexOf("This page contains the following errors") > -1) {
                    GameError.GetInstance().SendErrorToPHP("htmlContent format error "+ value);
                    return false
                    // throw new Error(rst.firstChild.firstChild.textContent);许我半盏清茶
                }
                return rst;
            };
        }else if(local_Util.IsTTGame()){
            local_Laya.Utils.parseXMLFromString = function (value) {
                var rst;
                value = value.replace(/>\s+</g, '><');
                rst = (new local_Laya.TTMiniAdapter.window.Parser.DOMParser()).parseFromString(value, 'text/xml');
                if (rst.firstChild.textContent.indexOf("This page contains the following errors") > -1) {
                    GameError.GetInstance().SendErrorToPHP("htmlContent format error "+ value);
                    return false
                    // throw new Error(rst.firstChild.firstChild.textContent);许我半盏清茶
                }
                return rst;
            };
        }else{
            local_Laya.Utils.parseXMLFromString = function (value) {
                var rst;
                value = value.replace(/>\s+</g, '><');
                rst = (new DOMParser()).parseFromString(value, 'text/xml');
                if (rst.firstChild.textContent.indexOf("This page contains the following errors") > -1) {
                    GameError.GetInstance().SendErrorToPHP("htmlContent format error "+ value);
                    return false
                }
                return rst;
            };
        }

        local_Laya.HTMLParse.parse = function(ower, xmlString, url) {
            xmlString = xmlString.replace(/<br>/g, "<br/>");
            //英语替换&字符
            if(window["PlatformManager"].IsEyouEnPlatform()){
                if(xmlString.indexOf("&")!=-1){
                    xmlString = xmlString.replace(/&(?!nbsp;|#38;)/g, "&#38;");
                }
            }
            xmlString = "<root>" + xmlString + "</root>";
            xmlString = xmlString.replace(local_Laya.HTMLParse["spacePattern"], local_Laya.HTMLParse["char255"]);
            var xml = Laya.Utils.parseXMLFromString(xmlString);
            if(xml)
                local_Laya.HTMLParse["_parseXML"](ower, xml.childNodes[0].childNodes, url);
        }

        let source_onInActive = local_Laya.Node.prototype["_onInActive"]
        local_Laya.RenderableSprite3D.prototype["_onInActive"] = function(): void {
            source_onInActive.call(this)
            if(this._scene)
            {
                this._scene._removeRenderObject(this._render);
            }

        }

        local_Laya["ShaderInstance"].prototype._uniform_sampler2D = function(one: any, texture): number {//TODO:TEXTURTE ARRAY
            var value: any = texture._getSource() || (texture.defaulteTexture && texture.defaulteTexture._getSource());
            if(value == null) return 0
            var gl: WebGLRenderingContext = local_Laya["LayaGL"].instance;
            local_Laya.WebGLContext["activeTexture"](gl, one.textureID);
            local_Laya.WebGLContext["bindTexture"](gl, gl.TEXTURE_2D, value);
            return 0;
        }

        local_Laya.Material.prototype.setShaderName = function(name: string): void {
            this._shader = Laya.Shader3D.find(name);
            if (!this._shader){
                Laya.timer.callLater(this, ()=>{
                    GameError.GetInstance().SendErrorToPHP(`BaseMaterial: unknown shader name.${this.name} ${name}`, true)
                })
                // throw new Error(`BaseMaterial: unknown shader name.${this.name}`);
            }
        }
        // Laya3D["_endLoad"] = function(loader, content: any = null, subResous: any[] = null): void {
        //     loader.endLoad(content);
        // }

        // local_Laya.Resource.prototype["_removeReference"] = function(count: number = 1): void {
        //     this._referenceCount -= count;
        //     if(this._referenceCount == 0)
        //     {
        //         local_Laya.timer.callLater(this, () => {
        //             if(this._referenceCount == 0)
        //                 this.destroy()
        //         });
        //     }
        // }
        if(Util.IsMeiZuFastGame() && local_Laya["CharRender_Canvas"]){
            local_Laya["CharRender_Canvas"].prototype.getCharBmp = function(char: string, font: string, lineWidth: number, colStr: string, strokeColStr: string, cri: Laya.CharRenderInfo,
                margin_left: number, margin_top: number, margin_right: number, margin_bottom: number, rect: any[] | null = null): ImageData|null {
                if (!this.supportImageData)
                    return this.getCharCanvas(char, font, lineWidth, colStr, strokeColStr, cri, margin_left, margin_top, margin_right, margin_bottom);
                var ctx: any = this.ctx;
        
                var sz = this.fontsz;
                //ctx.save();
                //由于大家公用一个canvas，所以需要在选中的时候做一些配置。
                //跟_lastFont比较容易出错，所以比较ctx.font
                if (ctx.font != font) {// ctx._lastFont != font) {	问题：ctx.font=xx 然后ctx==xx可能返回false，例如可能会给自己加"",当字体有空格的时候
                    ctx.font = font;
                    ctx._lastFont = font;
                    //console.log('use font ' + font);
                }
        
                cri.width = ctx.measureText(char).width;//排版用的width是没有缩放的。后面会用矩阵缩放
                var w: number = cri.width * this.lastScaleX;//w h 只是clear用的。所以要缩放
                var h: number = cri.height * this.lastScaleY;
                w += (margin_left + margin_right) * this.lastScaleX;
                h += (margin_top + margin_bottom) * this.lastScaleY;
                w = Math.ceil(w);
                h = Math.ceil(h);
                //@ts-ignore
                w = Math.min(w, local_Laya["CharRender_Canvas"].canvas.width);
                //@ts-ignore
                h = Math.min(h, local_Laya["CharRender_Canvas"].canvas.height);
        
                var clearW: number = w + lineWidth * 2 + 1;
                var clearH: number = h + lineWidth * 2 + 1;
                if (rect) {// measureText可能会小于请求的区域。 rect[2]可能为-1
                    clearW = Math.max(clearW, rect[0] + rect[2] + 1);
                    clearH = Math.max(clearH, rect[1] + rect[3] + 1);
                }
                ctx.clearRect(0, 0, clearW+1, clearH+1);
                ctx.save();
                //ctx.textAlign = "end";
                ctx.textBaseline = "middle";
                //ctx.translate(CborderSize, CborderSize);
                //ctx.scale(xs, ys);
                if (lineWidth > 0) {
                    ctx.strokeStyle = strokeColStr;
                    ctx.lineWidth = lineWidth;
                    ctx.strokeText(char, margin_left, margin_top + sz / 2);
                }
                if (colStr) {
                    ctx.fillStyle = colStr;
                    ctx.fillText(char, margin_left, margin_top + sz / 2);
                }
        
                if (this.showDbgInfo) {
                    ctx.strokeStyle = '#ff0000';
                    ctx.strokeRect(1, 1, w - 2, h - 2);
                    ctx.strokeStyle = '#00ff00';
                    ctx.strokeRect(margin_left, margin_top, cri.width, cri.height);//原始大小，没有缩放的
                }
                //ctx.restore();
                if (rect) {
                    if (rect[2] == -1) rect[2] = Math.ceil((cri.width + lineWidth * 2) * this.lastScaleX); // 这个没有考虑左右margin
                    if(rect[2]<=0) rect[2]=1;	// 有的字体在处理不存在文字的时候，测量宽度为0，会导致getImageData出错
                }
                var imgdt: ImageData = rect ? (ctx.getImageData(rect[0], rect[1], rect[2], rect[3]+1)) : (ctx.getImageData(0, 0, w, h+1));
                ctx.restore();
                cri.bmpWidth = imgdt.width;
                cri.bmpHeight = imgdt.height;
                return imgdt;
            }
        }

        //@ts-ignore 修复render还未加入场景时,animator掉用隐藏的报错。
        local_Laya.SimpleSingletonList.prototype.remove = function(element: Laya.ISingletonElement): void {
            var index: number = element._getIndexInList();
            if(index == -1 || this.length === 0) return
            this.length--;
            if (index !== this.length) {
                var end: any = this.elements[this.length];
                this.elements[index] = end;
                end._setIndexInList(index);
            }
            element._setIndexInList(-1);
        }

        //@ts-ignore 修复View 不刷新布局的问题
        local_Laya.View.prototype._setScaleX = function(value: number): void {
            this._style.scaleX = value;
            this._getWidget()?.resetLayoutX();
        }

        //@ts-ignore 修复View 不刷新布局的问题
        local_Laya.View.prototype._setScaleY = function(value: number): void {
            this._style.scaleY = value;
            this._getWidget()?.resetLayoutY();
        }

        local_Laya.TextRender.prototype.addBmpData = function(data: ImageData, ri: Laya.CharRenderInfo): Laya.TextAtlas {
            var w = data.width;
            var h = data.height;
            var sz = this.textAtlases.length;
            var atlas: Laya.TextAtlas;
            var find = false;
            for (var i = 0; i < sz; i++) {
                atlas = this.textAtlases[i];
                find = atlas.getAEmpty(w, h, this.tmpAtlasPos);
                if (find) {
                    break;
                }
            }
            if (!find) {
                // 创建一个新的
                atlas = new Laya.TextAtlas()
                this.textAtlases.push(atlas);
                find = atlas.getAEmpty(w, h, this.tmpAtlasPos);
                if (!find) {
                    // throw 'err1'; //TODO
                    console.warn('----addBmpData cannot find a emptypos----', ri.char)
                    find = true;
                }
                // 清理旧的
                this.cleanAtlases();
            }
            if (find) {
                atlas.texture.addChar(data, this.tmpAtlasPos.x, this.tmpAtlasPos.y, ri.uv);
                ri.tex = atlas.texture;
            }
            return atlas;
        }
        if(Util.IsConch()){
            local_Laya.TextRender.forceSplitRender = true
        }
    }




    //在引擎调用Init之后的覆盖方法
    public static AfterEngineInit() {
        let res_mgr = ResManager.GetInstance()
        let local_Laya3d = Laya3D
        let local_Laya = Laya
            

        let Sprite3D = local_Laya.Sprite3D
        let Transform3D = local_Laya.Transform3D
        let SkinnedMeshSprite3D = local_Laya.SkinnedMeshSprite3D
        let MeshSprite3D = local_Laya.MeshSprite3D
        let ShuriKenParticle3D = local_Laya.ShuriKenParticle3D
        let ShurikenParticleSystem = local_Laya.ShurikenParticleSystem
        let Animator = local_Laya.Animator
        let forcePreCulling = window["forcePreCulling"]
        let source_preCulling = local_Laya.Scene3D.prototype["_preCulling"]
        local_Laya.Scene3D.prototype["_preCulling"] = function (context, camera, shader, replacementTag): void {
            if (this.update_culling_state || forcePreCulling) {
                source_preCulling.call(this, context, camera, shader, replacementTag)
                this.update_culling_state = false
            }
        }

        local_Laya.Camera.prototype["_renderMainPass"] = function (context, viewport, scene, shader, replacementTag, needInternalRT) {
            
            var gl = local_Laya["LayaGL"].instance;
            var renderTex = this._getRenderTexture();//如果有临时renderTexture则画到临时renderTexture,最后再画到屏幕或者离屏画布,如果无临时renderTexture则直接画到屏幕或离屏画布
        
            context.viewport = viewport;
            this._prepareCameraToRender();
            scene._preCulling(context, this, shader, replacementTag);
            if(renderTex&&renderTex._isCameraTarget)//保证反转Y状态正确
                context.invertY = true;
            this._applyViewProject(context, this.viewMatrix, this._projectionMatrix);
            if(this.depthTextureMode!=0){
                //TODO:是否可以不多次
                this._renderDepthMode(context);
            }
            (renderTex) && (renderTex._start());
            // if(scene.name == "Scene3D")
            // {
                scene._clear(gl, context);
            
                scene._renderScene(context,local_Laya.Scene3D.SCENERENDERFLAG_RENDERQPAQUE);
                scene._renderScene(context,local_Laya.Scene3D.SCENERENDERFLAG_RENDERTRANSPARENT);
            // }
            scene._postRenderScript();//TODO:duo相机是否重复
            (renderTex) && (renderTex._end());
        
            if (needInternalRT) {
                if (this._postProcess && this._postProcess.enable) {
                    this._postProcess.commandContext = context;
                    this._postProcess._render();
                    this._postProcess._applyPostProcessCommandBuffers();
                } else if (this._enableHDR || this._needBuiltInRenderTexture) {
                    var canvasWidth: number = this._getCanvasWidth(), canvasHeight: number = this._getCanvasHeight();
                    this._screenOffsetScale.setValue(viewport.x / canvasWidth, viewport.y / canvasHeight, viewport.width / canvasWidth, viewport.height / canvasHeight);
                    this._internalCommandBuffer._camera = this;
                    this._internalCommandBuffer._context = context;
                    this._internalCommandBuffer.blitScreenQuad(this._internalRenderTexture, this._offScreenRenderTexture ? this._offScreenRenderTexture : null, this._screenOffsetScale, null, null, 0, true);
                    this._internalCommandBuffer._apply();
                    this._internalCommandBuffer.clear();
                }
                local_Laya.RenderTexture.bindCanvasRender = this._internalRenderTexture;
            }else{
                local_Laya.RenderTexture.bindCanvasRender = null;
            }
        }

        local_Laya.Scene3D.prototype["_update"] = function () {
            local_Laya.Animator["_update"](this);
        }


        // let layer_mgr = LayerManager.GetInstance()
        local_Laya.Animator["_update"] = function (scene): void {
            // if(!scene.force_update_in_next_frame && !layer_mgr.CheckFrameTimeValid())
            // {
            //     scene.force_update_in_next_frame = true
            //     return
            // }else
            // {
            //     scene.force_update_in_next_frame = false
            // }
            var pool = scene._animatorPool;
            var elements = pool.elements;
            for (var i = 0, n = pool.length; i < n; i++) {
                var animator = elements[i];
                (animator && animator.enabled) && (animator._update(true));
            }
        }

        if(!(ClientConfig && ClientConfig.no_animator_optimize1))
        {
            let vector3_pool = []
            let quaternion_pool = []

            let animator_state_removeRef = local_Laya.AnimatorState.prototype._removeReference
            local_Laya.AnimatorState.prototype._removeReference = function (count: number = 1): void {
                animator_state_removeRef.call(this, count)
                if(this._clip)
                {
                    count = this._realtimeDatas.length;
                    var clipNodes = this._clip._nodes;
                    var vector3_can_pool = vector3_pool.length < 5000
                    var quaternion_can_pool = quaternion_pool.length < 5000
                    if(vector3_can_pool || quaternion_can_pool)
                    {
                        for (var i: number = 0; i < count; i++) {
                            switch (clipNodes.getNodeByIndex(i).type) {
                                case 0:
                                    break;
                                case 1:
                                case 3:
                                case 4:
                                    vector3_can_pool && vector3_pool.push(this._realtimeDatas[i])
                                    break;
                                case 2:
                                    quaternion_can_pool && quaternion_pool.push(this._realtimeDatas[i])
                                    break;
                                default:
                                    throw "AnimationClipParser04:unknown type.";
                            }
                        }
                    }
                    this._realtimeDatas.length = 0
                }
            }
            
            let setClip = function(animatorState, value)
            {
                // if (animatorState._clip !== value) {
                //     if (animatorState._clip)
                        // (animatorState._referenceCount > 0) && (animatorState._clip._removeReference(animatorState._referenceCount));
                    if (value) {
                        var realtimeDatas = animatorState._realtimeDatas;
                        var clipNodes = value._nodes;
                        var count = clipNodes.count;
                        animatorState._currentFrameIndices = new Int16Array(count);
                        animatorState._resetFrameIndices();
                        (animatorState._referenceCount > 0) && (value._addReference(animatorState._referenceCount));
                        animatorState._realtimeDatas.length = count;
                        for (var i = 0; i < count; i++) {
                            switch (clipNodes.getNodeByIndex(i).type) {
                                case 0:
                                    break;
                                case 1:
                                case 3:
                                case 4:
                                    realtimeDatas[i] = vector3_pool.shift() || new local_Laya.Vector3();
                                    break;
                                case 2:
                                    realtimeDatas[i] = quaternion_pool.shift() || new local_Laya.Quaternion();
                                    break;
                                default:
                                    throw "AnimationClipParser04:unknown type.";
                            }
                        }
                    }
                    animatorState._clip = value;
                // }
            }

                
            local_Laya.AnimatorState.prototype.cloneTo = function(destObject: any): void {
                var dest: Laya.AnimatorState = <Laya.AnimatorState>destObject;
                dest.name = this.name;
                dest.speed = this.speed;
                dest.clipStart = this.clipStart;
                dest.clipEnd = this.clipEnd;
                // dest.clip = this._clip;
                setClip(dest, this._clip)
            }
            local_Laya.Animator.prototype["_parse"] = function (data) {
                var avatarData = data.avatar;
                if (avatarData) {
                    this.avatar = Laya.Loader.getRes(avatarData.path);
                    var linkSprites = avatarData.linkSprites;
                    this._linkSprites = linkSprites;
                    this._linkToSprites(linkSprites);
                }
                var play = data.playOnWake;
                var layersData = data.layers;
                for (var i = 0; i < layersData.length; i++) {
                    var layerData = layersData[i];
                    var animatorLayer = new local_Laya.AnimatorControllerLayer(layerData.name);
                    if (i === 0)
                        animatorLayer.defaultWeight = 1.0;
                    else
                        animatorLayer.defaultWeight = layerData.weight;
                    var blendingModeData = layerData.blendingMode;
                    (blendingModeData) && (animatorLayer.blendingMode = blendingModeData);
                    this.addControllerLayer(animatorLayer);
                    var states = layerData.states;
                    for (var j = 0, m = states.length; j < m; j++) {
                        var state = states[j];
                        var clipPath = state.clipPath;
                        if (clipPath) {
                            var name = state.name;
                            var motion;
                            motion = Laya.Loader.getRes(clipPath);
                            if (motion) {
                                var animatorState = new local_Laya.AnimatorState();
                                animatorState.name = name;
                                setClip(animatorState, motion)
                                // animatorState.clip = motion;
                                animatorLayer.addState(animatorState);
                                (j === 0) && (this.getControllerLayer(i).defaultState = animatorState);
                            }
                        }
                    }
                    (play !== undefined) && (animatorLayer.playOnWake = play);
                    let layerMaskData = layerData.avatarMask;
                    if (layerMaskData) {
                        let avaMask = new local_Laya.AvatarMask();
                        animatorLayer.avatarMask = avaMask;
                        for (var bips in layerMaskData) {
                            avaMask.setTransformActive(bips, layerMaskData[bips]);
                        }
                    }
                }
                var cullingModeData = data.cullingMode;
                (cullingModeData !== undefined) && (this.cullingMode = cullingModeData);
            }

            // let is_ios = local_Laya.Browser.onIOS
            local_Laya.Animator.prototype["_update"] = function (force): void {
                if(!this.owner.activeInHierarchy) return
                // var timer = (this.owner._scene).timer;
                // if (is_ios && !this.main_role && timer.currFrame % 2 == 1) {
                //     this.wait_delta = timer._delta
                //     return
                // }
                // var delta = (this.wait_delta || 0) + timer._delta
                var delta = local_Laya.timer.delta * 0.001
                // this.wait_delta = 0
                // delta = Math.max(0.016, delta);//Laya.timer.delta已结包含Laya.timer.scale
                // this.delta = delta
                // console.warn("------delta---", delta)
                // delta =  this._applyUpdateMode(delta);
                // if (this._speed === 0 || delta === 0)//delta为0无需更新,可能造成crossWeight计算值为NaN
                //     return;
                var needRender: boolean;
                if (this.cullingMode === local_Laya.Animator.CULLINGMODE_CULLCOMPLETELY) {//所有渲染精灵不可见时
                    needRender = false;
                    for (var i: number = 0, n: number = this._renderableSprites.length; i < n; i++) {
                        if (this._renderableSprites[i]._render.isRender) {
                            needRender = true;
                            break;
                        }
                    }
                } else {
                    needRender = true;
                }
                this._updateMark++;
                for (i = 0, n = this._controllerLayers.length; i < n; i++) {
                    var controllerLayer = this._controllerLayers[i];
                    var playStateInfo = controllerLayer._playStateInfo!;
                    var crossPlayStateInfo = controllerLayer._crossPlayStateInfo!;
                    addtive = controllerLayer.blendingMode !== local_Laya.AnimatorControllerLayer.BLENDINGMODE_OVERRIDE;
                    switch (controllerLayer._playType) {
                        case 0:
                            var animatorState = playStateInfo._currentState!;
                            var clip = animatorState._clip!;
                            var speed: number = this._speed * animatorState.speed;
                            var finish: boolean = playStateInfo._finish;//提前取出finish,防止最后一帧跳过
                            finish || this._updatePlayer(animatorState, playStateInfo, delta * speed, clip.islooping);
                            if (needRender) {
                                var addtive: boolean = controllerLayer.blendingMode !== local_Laya.AnimatorControllerLayer.BLENDINGMODE_OVERRIDE;
                                this._updateClipDatas(animatorState, addtive, playStateInfo, controllerLayer.avatarMask, true);//clipDatas为逐动画文件,防止两个使用同一动画文件的Animator数据错乱,即使动画停止也要updateClipDatas
                                // this._setClipDatasToNode(animatorState, addtive, controllerLayer.defaultWeight, i === 0, controllerLayer);//多层动画混合时即使动画停止也要设置数据
                                // finish || this._updateEventScript(animatorState, playStateInfo);
                            }
                            // finish || this._updateStateFinish(animatorState, playStateInfo);
                            break;
                        case 1:
                            animatorState = playStateInfo._currentState!;
                            clip = animatorState._clip!;
                            var crossState = controllerLayer._crossPlayState;
                            var crossClip = crossState._clip!;
                            var crossDuratuion: number = controllerLayer._crossDuration;
                            var startPlayTime: number = crossPlayStateInfo._startPlayTime;
                            var crossClipDuration: number = crossClip._duration - startPlayTime;
                            var crossScale: number = crossDuratuion > crossClipDuration ? crossClipDuration / crossDuratuion : 1.0;//如果过度时间大于过度动作时间,则减慢速度
                            var crossSpeed: number = this._speed * crossState.speed;
                            this._updatePlayer(crossState, crossPlayStateInfo, delta * crossScale * crossSpeed, crossClip.islooping);
                            var crossWeight: number = ((crossPlayStateInfo._elapsedTime - startPlayTime) / crossScale) / crossDuratuion;
                            var needUpdateFinishcurrentState = false;
                            if (crossWeight >= 1.0) {
                                if (needRender) {
                                    this._updateClipDatas(crossState, addtive, crossPlayStateInfo, controllerLayer.avatarMask);
                                    this._setClipDatasToNode(crossState, addtive, controllerLayer.defaultWeight, i === 0, controllerLayer);

                                    controllerLayer._playType = 0;//完成融合,切换到正常播放状态
                                    playStateInfo._currentState = crossState;
                                    crossPlayStateInfo._cloneTo(playStateInfo);
                                }
                            } else {
                                if (!playStateInfo._finish) {
                                    speed = this._speed * animatorState.speed;
                                    needUpdateFinishcurrentState = true;
                                    this._updatePlayer(animatorState, playStateInfo, delta * speed, clip.islooping);
                                    if (needRender)
                                        this._updateClipDatas(animatorState, addtive, playStateInfo, controllerLayer.avatarMask);
                                }
                                if (needRender) {
                                    this._updateClipDatas(crossState, addtive, crossPlayStateInfo, controllerLayer.avatarMask);
                                    this._setCrossClipDatasToNode(controllerLayer, animatorState, crossState, crossWeight, i === 0);
                                }
                            }
                            // if (needRender) {
                                // this._updateEventScript(animatorState, playStateInfo);
                                // this._updateEventScript(crossState, crossPlayStateInfo);
                            // }
                            // this._updateStateFinish(crossState, crossPlayStateInfo);
                            // needUpdateFinishcurrentState && this._updateStateFinish(playStateInfo._currentState, playStateInfo);
                            break;
                        case 2:
                            crossState = controllerLayer._crossPlayState;
                            crossClip = crossState._clip!;
                            crossDuratuion = controllerLayer._crossDuration;
                            startPlayTime = crossPlayStateInfo._startPlayTime;
                            crossClipDuration = crossClip._duration - startPlayTime;
                            crossScale = crossDuratuion > crossClipDuration ? crossClipDuration / crossDuratuion : 1.0;//如果过度时间大于过度动作时间,则减慢速度
                            crossSpeed = this._speed * crossState.speed;
                            this._updatePlayer(crossState, crossPlayStateInfo, delta * crossScale * crossSpeed, crossClip.islooping);
                            if (needRender) {
                                crossWeight = ((crossPlayStateInfo._elapsedTime - startPlayTime) / crossScale) / crossDuratuion;
                                if (crossWeight >= 1.0) {
                                    this._updateClipDatas(crossState, addtive, crossPlayStateInfo, controllerLayer.avatarMask);
                                    this._setClipDatasToNode(crossState, addtive, 1.0, i === 0, controllerLayer);
                                    controllerLayer._playType = 0;//完成融合,切换到正常播放状态
                                    playStateInfo._currentState = crossState;
                                    crossPlayStateInfo._cloneTo(playStateInfo);
                                } else {
                                    this._updateClipDatas(crossState, addtive, crossPlayStateInfo, controllerLayer.avatarMask);
                                    this._setFixedCrossClipDatasToNode(controllerLayer, crossState, crossWeight, i === 0);
                                }
                                // this._updateEventScript(crossState, crossPlayStateInfo);
                            }
                            // this._updateStateFinish(crossState, crossPlayStateInfo);
                            break;
                    }
                }

                if (needRender) {
                    if (this._avatar) {
                        this._updateAvatarNodesToSprite();
                    }
                }
            }
            let EvaluateClipDatasRealTime:Function
            local_Laya.Animator.prototype["_updateClipDatas"] = function(animatorState, addtive, playStateInfo, animatorMask = null, use_cache = false) {
                var clip = animatorState._clip;
                var clipDuration = clip._duration;
                var curPlayTime = animatorState.clipStart * clipDuration + playStateInfo._normalizedPlayTime * playStateInfo._duration;
                var currentFrameIndices = animatorState._currentFrameIndices;
                var frontPlay = playStateInfo._elapsedTime > playStateInfo._lastElapsedTime;
                if(use_cache)
                {
                    EvaluateClipDatasRealTime(clip, clip._nodes, curPlayTime, currentFrameIndices, addtive, frontPlay, animatorState._realtimeDatas, animatorMask, animatorState);
                }else
                {
                    clip._evaluateClipDatasRealTime(clip._nodes, curPlayTime, currentFrameIndices, addtive, frontPlay, animatorState._realtimeDatas, animatorMask);
                }
            }

            EvaluateClipDatasRealTime = function(clip, nodes, playCurTime, realTimeCurrentFrameIndexes, addtive, frontPlay, outDatas, avatarMask, stateInfo?) 
            {
                let nodeOwners = stateInfo._nodeOwners;
                let nodeOwner
                let pro
                let node
                let isEnd
                var type 
                var nextFrameIndex;
                var keyFrames
                var keyFramesCount
                var frameIndex
                for (var i = 0, n = nodes.count; i < n; i++) {
                    node = nodes.getNodeByIndex(i);
                    nodeOwner = nodeOwners[i];
                    if(nodeOwner)
                        pro = nodeOwner.propertyOwner;
                    else
                    {
                        // pro = null
                        // console.log("----------nodeOwner is null i" , i, n)
                        continue;
                    }
                    type = node.type;
                    nextFrameIndex;
                    keyFrames = node._keyFrames;
                    keyFramesCount = keyFrames.length;
                    frameIndex = realTimeCurrentFrameIndexes[i];
                    if (frontPlay) {
                        if ((frameIndex !== -1) && (playCurTime < keyFrames[frameIndex].time)) {
                            frameIndex = -1;
                            realTimeCurrentFrameIndexes[i] = frameIndex;
                        }
                        nextFrameIndex = frameIndex + 1;
                        while (nextFrameIndex < keyFramesCount) {
                            if (keyFrames[nextFrameIndex].time > playCurTime)
                                break;
                            frameIndex++;
                            nextFrameIndex++;
                            realTimeCurrentFrameIndexes[i] = frameIndex;
                        }
                    }
                    else {
                        nextFrameIndex = frameIndex + 1;
                        if ((nextFrameIndex !== keyFramesCount) && (playCurTime > keyFrames[nextFrameIndex].time)) {
                            frameIndex = keyFramesCount - 1;
                            realTimeCurrentFrameIndexes[i] = frameIndex;
                        }
                        nextFrameIndex = frameIndex + 1;
                        while (frameIndex > -1) {
                            if (keyFrames[frameIndex].time < playCurTime)
                                break;
                            frameIndex--;
                            nextFrameIndex--;
                            realTimeCurrentFrameIndexes[i] = frameIndex;
                        }
                    }
                    isEnd = nextFrameIndex === keyFramesCount;
                    switch (type) {
                        case 0:
                            if (frameIndex !== -1) {
                                var frame = keyFrames[frameIndex];
                                if (isEnd) {
                                    outDatas[i] = frame.value;
                                }
                                else {
                                    var nextFarme = keyFrames[nextFrameIndex];
                                    var d = nextFarme.time - frame.time;
                                    var t;
                                    if (d !== 0)
                                        t = (playCurTime - frame.time) / d;
                                    else
                                        t = 0;
                                    outDatas[i] = clip._hermiteInterpolate(frame, nextFarme, t, d);
                                }
                            }
                            else {
                                outDatas[i] = keyFrames[0].value;
                            }
                            if (addtive)
                                outDatas[i] = outDatas[i] - keyFrames[0].value;
                            var proPat
                            proPat = nodeOwner.property;
                            var m = proPat.length - 1;
                            for (var j = 0; j < m; j ++) {
                                pro = pro[proPat[j]];
                                if (!pro)
                                    break;
                            }
                            if(pro)
                            {
                                if (addtive)
                                    pro[proPat[m]] = nodeOwner.defaultValue + outDatas[i];
                                else
                                    pro[proPat[m]] = outDatas[i];
                            }
                            break;
                        case 1:
                            var clipData = outDatas[i];
                            clip._evaluateFrameNodeVector3DatasRealTime(keyFrames, frameIndex, isEnd, playCurTime, clipData);
                            if (addtive) {
                                var firstFrameValue = keyFrames[0].value;
                                clipData.x -= firstFrameValue.x;
                                clipData.y -= firstFrameValue.y;
                                clipData.z -= firstFrameValue.z;
                            }
                            var localPos = pro.localPosition;
                            if (addtive) {
                                var defValue: Laya.Vector3 = nodeOwner.defaultValue;
                                localPos.x = defValue.x + clipData.x;
                                localPos.y = defValue.y + clipData.y;
                                localPos.z = defValue.z + clipData.z;
                                pro.localPosition = localPos;
                            } else {
                                if(clipData.x != localPos.x || clipData.y != localPos.y || clipData.z != localPos.z)
                                {
                                    localPos.x = clipData.x;
                                    localPos.y = clipData.y;
                                    localPos.z = clipData.z;
                                    pro.localPosition = localPos;
                                }
                            }
                            break;
                        case 4:
                            var clipData = outDatas[i];
                            clip._evaluateFrameNodeVector3DatasRealTime(keyFrames, frameIndex, isEnd, playCurTime, clipData);
                            if (addtive) {
                                var firstFrameValue = keyFrames[0].value;
                                clipData.x -= firstFrameValue.x;
                                clipData.y -= firstFrameValue.y;
                                clipData.z -= firstFrameValue.z;
                            }
                            var localEuler = pro.localRotationEuler;
                            if (addtive) {
                                let defValue = nodeOwner.defaultValue;
                                localEuler.x = defValue.x + clipData.x;
                                localEuler.y = defValue.y + clipData.y;
                                localEuler.z = defValue.z + clipData.z;
                                pro.localRotationEuler = localEuler;
                            } else {
                                if(clipData.x != localEuler.x || clipData.y != localEuler.y || clipData.z != localEuler.z)
                                {
                                    localEuler.x = clipData.x;
                                    localEuler.y = clipData.y;
                                    localEuler.z = clipData.z;
                                    pro.localRotationEuler = localEuler;
                                }
                            }
                            break;
                        case 2:
                            var clipQuat = outDatas[i];
                            clip._evaluateFrameNodeQuaternionDatasRealTime(keyFrames, frameIndex, isEnd, playCurTime, clipQuat);
                            if (addtive) {
                                var tempQuat = local_Laya.AnimationClip["_tempQuaternion0"];
                                var firstFrameValueQua = keyFrames[0].value;
                                local_Laya.Utils3D["quaternionConjugate"](firstFrameValueQua, tempQuat);
                                local_Laya.Quaternion.multiply(tempQuat, clipQuat, clipQuat);
                            }
                            var localRot = pro.localRotation;
                            if (addtive) {
                                var defaultRot: Laya.Quaternion = nodeOwner.defaultValue;
                                local_Laya.Quaternion.multiply(defaultRot, clipQuat, localRot);
                                pro.localRotation = localRot;
                            } else {
                                if(clipQuat.x != localRot.x || clipQuat.y != localRot.y || clipQuat.z != localRot.z || clipQuat.w != localRot.w)
                                {
                                    localRot.x = clipQuat.x;
                                    localRot.y = clipQuat.y;
                                    localRot.z = clipQuat.z;
                                    localRot.w = clipQuat.w;
                                    pro.localRotation = localRot;
                                }
                            }
                            break;
                        case 3:
                            clipData = outDatas[i];
                            clip._evaluateFrameNodeVector3DatasRealTime(keyFrames, frameIndex, isEnd, playCurTime, clipData);
                            if (addtive) {
                                firstFrameValue = keyFrames[0].value;
                                clipData.x /= firstFrameValue.x;
                                clipData.y /= firstFrameValue.y;
                                clipData.z /= firstFrameValue.z;
                            }
                            var localSca = pro.localScale;
                            if (addtive) {
                                var defaultSca = nodeOwner.defaultValue;
                                localSca.x = defaultSca.x * clipData.x;
                                localSca.y = defaultSca.y * clipData.y;
                                localSca.z = defaultSca.z * clipData.z;
                                pro.localScale = localSca;
                            } else {
                                if(clipData.x != localSca.x || clipData.y != localSca.y || clipData.z != localSca.z)
                                {
                                    localSca.x = clipData.x;
                                    localSca.y = clipData.y;
                                    localSca.z = clipData.z;
                                    pro.localScale = localSca;
                                }
                            }
                            break;
                        default:
                            throw "AnimationClip:unknown node type.";
                    }
                    // nodeOwner.updateMark = this._updateMark;
                }
            }
        }

        let HierarchylhLoaded = function(loader: Laya.Loader, lhData: any) {
            let data = lhData.data
            let url = loader.url
            if (data) {
                let params: any = {}
                //提取链接参数
                if (url.indexOf("?") > -1) {
                    let query = url.split('?')
                    let params_str = query[1], param
                    if (params_str.indexOf('&') > -1) {
                        let params_list = params_str.split('&')
                        for (let i = 0; i < params_list.length; i++) {
                            if (params_list[i]) {
                                param = params_list[i].split('=')
                                if (param[0]) {
                                    params[param[0]] = param[1]
                                }
                            }
                        }
                    }
                }
                let ani_dic
                let ani_list
                if(params.action_name_list)
                {
                    ani_list = params.action_name_list.split(',')
                }else
                {
                    if (params.module) {
                        let cfgs = Config.PRELOAD_CLIENT_CONFIG.ConfigModelAni
                        let cfg = cfgs && cfgs[params.module]
                        if (cfg) {
                            if (params.name && cfg[params.name]) {
                                if (params.id && cfg[params.name][params.id]) {
                                    ani_list = cfg[params.name][params.id]
                                }
                                else {
                                    ani_list = cfg[params.name].default
                                }
                            }
                            else {
                                ani_list = cfg.default
                            }
                        }
                    }
                }
                if (ani_list) {
                    ani_dic = {}
                    for (let v of ani_list) {
                        ani_dic[v] = true
                    }
                }
                if (ani_dic) {
                    let components: any = data.components;
                    if (components) {
                        let com, layers, layer, states, state
                        for (let i in components) {
                            com = components[i]
                            if (com.type == "Animator") {
                                layers = com.layers
                                if (layers) {
                                    for (let y in layers) {
                                        layer = layers[y]
                                        states = layer.states
                                        for (let index = 0; index < states.length; index++) {
                                            state = states[index]
                                            if (!ani_dic[state.name]) {
                                                states.splice(index, 1)
                                                index--;
                                            }
                                        }
                                        break
                                    }
                                }
                                break
                            }
                        }
                    }
                }
            }
            // console.warn("------@@@@@@@------", loader.url, lhData)
            Laya3D["_onHierarchylhLoaded"](loader, lhData)
        }
        Laya.Loader.parserMap[local_Laya3d.HIERARCHY] = (loader) => {
            loader._originType = loader.type;
            let lhData_info = res_mgr.load_prefab_cache_lhdata[loader.url]
            if (lhData_info) {
                local_Laya3d["_onHierarchylhLoaded"](loader, lhData_info)
            } else {
                loader.on(local_Laya.Event.LOADED, null, HierarchylhLoaded, [loader]);
                loader.load(loader.url, local_Laya.Loader.JSON, false, null, true);
            }
        }

        local_Laya3d["_onHierarchylhLoaded"] = function (loader: Laya.Loader, lhData_info: any): void {
            var firstLevUrls;
            var secondLevUrls;
            var thirdLevUrls;
            var forthLevUrls;
            var subUrls;
            if (!lhData_info.has_parse) {
                lhData_info.has_parse = true
                var url: string = loader.url;
                var urlVersion: string = local_Laya.Utils3D.getURLVerion(url);
                var hierarchyBasePath: string = local_Laya.URL.getPath(url);
                firstLevUrls = [];
                secondLevUrls = [];
                thirdLevUrls = [];
                forthLevUrls = [];
                subUrls = [];
                local_Laya3d["_getSprite3DHierarchyInnerUrls"](lhData_info.data, firstLevUrls, secondLevUrls, thirdLevUrls, forthLevUrls, subUrls, urlVersion, hierarchyBasePath);
                lhData_info.firstLevUrls = firstLevUrls;
                lhData_info.secondLevUrls = secondLevUrls;
                lhData_info.thirdLevUrls = thirdLevUrls;
                lhData_info.forthLevUrls = forthLevUrls;
                lhData_info.subUrls = subUrls;
                res_mgr.load_prefab_cache_lhdata[url] = lhData_info
            } else {
                firstLevUrls = lhData_info.firstLevUrls;
                secondLevUrls = lhData_info.secondLevUrls;
                thirdLevUrls = lhData_info.thirdLevUrls;
                forthLevUrls = lhData_info.forthLevUrls;
                subUrls = lhData_info.subUrls;
            }
            if (forthLevUrls.length > 0) {
                local_Laya3d["_innerFourthLevelLoaderManager"]._create(forthLevUrls, false, local_Laya.Handler.create(null, local_Laya3d["_onHierarchyInnerForthLevResouLoaded"], [loader, null, lhData_info, subUrls, firstLevUrls, secondLevUrls, thirdLevUrls, 1, null]), null, null, null, null, 1, true);
            } else {
                local_Laya3d["_onHierarchyInnerForthLevResouLoaded"](loader, null, lhData_info, subUrls, firstLevUrls, secondLevUrls, thirdLevUrls, 1, null);
            }
        }

        let MaterilLmatLoaded = function(loader: Laya.Loader, lmatData: any) {
            let local_Laya3D = Laya3D
            var url: string = loader.url;
            var urlVersion: string = Laya.Utils3D.getURLVerion(url);
            var materialBasePath: string = Laya.URL.getPath(url);
            var urls: any[] = [];
            var subUrls: any[] = [];
            // var customProps: any = lmatData.customProps;
            var formatSubUrl: string;
            var version: string = lmatData.version;
            switch (version) {
                case "LAYAMATERIAL:01":
                case "LAYAMATERIAL:02":
                case "LAYAMATERIAL:03":
                    var i: number, n: number;
                    var textures: any[] = lmatData.props.textures;
                    if (textures) {
                        for (i = 0, n = textures.length; i < n; i++) {
                            var tex2D: any = textures[i];
                            var tex2DPath: string = tex2D.path;
                            if (tex2DPath) {
                                formatSubUrl = local_Laya3D['formatRelativePath'](materialBasePath, tex2DPath);
                                (urlVersion) && (formatSubUrl = formatSubUrl + urlVersion);
                                if (local_Util.use_ktx) {
                                    formatSubUrl = formatSubUrl.substring(0, formatSubUrl.lastIndexOf(".")) + ".ktx"
                                }
                                urls.push({ url: formatSubUrl, constructParams: tex2D.constructParams, propertyParams: tex2D.propertyParams });//不指定类型,自动根据后缀判断Texture2D或TextureCube
                                subUrls.push(formatSubUrl);
                                tex2D.path = formatSubUrl;
                            }
                        }
                    }
                    break;
                default:
                    throw new Error("Laya3D:unkonwn version.");
            }
    
            var urlCount: number = urls.length;
            // var totalProcessCount: number = urlCount + 1;
            // var lmatWeight: number = 1 / totalProcessCount;
            // Laya3D['_onProcessChange'](loader, 0, lmatWeight, 1.0);
            if (urlCount > 0) {
                // var processHandler: Laya.Handler = Laya.Handler.create(null, Laya3D['_onProcessChange'], [loader, lmatWeight, urlCount / totalProcessCount], false);
                local_Laya3D['_innerFourthLevelLoaderManager']._create(urls, false, Laya.Handler.create(null, local_Laya3D['_onMateialTexturesLoaded'], [loader, null, lmatData, subUrls]), null, null, null, null, 1, true);//TODO:还有可能是TextureCube,使用三级
            } else {
                local_Laya3D['_onMateialTexturesLoaded'](loader, null, lmatData, null);
            }
        }
    

        local_Laya.Loader.parserMap[Laya3D.MATERIAL] = (loader) => {
            loader.on(Laya.Event.LOADED, null, MaterilLmatLoaded, [loader]);
            loader.load(loader.url, Laya.Loader.JSON, false, null, true);
        }


        // var NotCopyToNameDic = {
        //     "ride": true,
        //     "head": true,
        //     "lhand": true,
        //     "rhand": true,
        //     "wing": true
        // }

        let source_clone = Sprite3D.prototype["clone"]
        Sprite3D.prototype.clone = function () {
            var dstSprite3D = source_clone.call(this)
            dstSprite3D.forbid_clone = this.forbid_clone
            dstSprite3D._url = this._url
            return dstSprite3D;
        }
        Sprite3D["_createSprite3DInstance"] = (scrSprite) => {
            var node = scrSprite["_create"]();
            var children: any[] = scrSprite["_children"];
            var child
            for (var i: number = 0, n: number = children.length; i < n; i++) {
                child = children[i]
                if (child.forbid_clone) continue // && NotCopyToNameDic[child.parent.name]
                child = Sprite3D["_createSprite3DInstance"](children[i])
                node.addChild(child);
            }
            return node;
        }

        Sprite3D["_parseSprite3DInstance"] = (srcRoot, dstRoot, scrSprite, dstSprite) => {
            var srcChildren: any[] = scrSprite["_children"];
            var dstChildren: any[] = dstSprite["_children"];
            for (var i: number = 0, n: number = dstChildren.length; i < n; i++)
                Sprite3D["_parseSprite3DInstance"](srcRoot, dstRoot, srcChildren[i], dstChildren[i])

            scrSprite["_cloneTo"](dstSprite, srcRoot, dstRoot);
        }
        let sprite_3d_pool = res_mgr.laya_sprite_3d_pool
        let skinnedMesh_sprite3d_pool = res_mgr.laya_skinnedMesh_sprite3d_pool
        let mesh_sprite3d_pool = res_mgr.laya_mesh_sprite3d_pool
        let shuriKen_particle3d_pool = res_mgr.laya_shuriKen_particle3d_pool

        let ResetSprite3D = function (sp) {
            sp._id = ++Sprite3D["_uniqueIDCounter"];
            sp._children = local_Laya.Node["ARRAY_EMPTY"];
            sp._bits = 0;
            sp._url = null;
            sp._scene = null;
            sp._scripts = null;
            sp._hierarchyAnimator = null;
            sp._needProcessCollisions = false;
            sp._needProcessTriggers = false;
            // sp._transform = new local_Laya.Transform3D(sp);
            // this._owner = owner;
            sp._transform._children = [];
            sp._transform._isDefaultMatrix = false;
            sp._transform._setTransformFlag(tranform3d_flag1, false);
            sp._transform._setTransformFlag(tranform3d_flag2, true);
            sp._isStatic = false;
            if(sp.forbid_clone) sp.forbid_clone = null;
            sp.destroyed = false;
            sp.layer = 0;
        }
        let tranform3d_flag1 = Transform3D["TRANSFORM_LOCALQUATERNION"] | Transform3D["TRANSFORM_LOCALEULER"] | Transform3D["TRANSFORM_LOCALMATRIX"]
        let tranform3d_flag2 = Transform3D["TRANSFORM_WORLDPOSITION"] | Transform3D["TRANSFORM_WORLDQUATERNION"] | Transform3D["TRANSFORM_WORLDEULER"] | Transform3D["TRANSFORM_WORLDSCALE"] | Transform3D["TRANSFORM_WORLDMATRIX"]
        let GetSprite3DPool = function () {
            let sp = sprite_3d_pool.shift()
            if (sp) {
                ResetSprite3D(sp)
            } else {
                sp = new Sprite3D();
            }
            return sp
        }

        let ResetMeshRender = function (render, sp) {
            render._lightmapIndex = null
            render._receiveShadow = null
            render._indexInList = -1;

            render._bounds = null;
            render._boundsChange = true;


            render._castShadow = false;
            render._supportOctree = true;

            render._distanceForSort = null
            render._renderMark = -1;//TODO:初始值为-1强制更新,否则会造成第一帧动画不更新等,待优化
            render._octreeNode = null
            render._indexInOctreeMotionList = -1;
            render._probReflection = null
            render._surportReflectionProbe = null
            render._reflectionMode = local_Laya.ReflectionProbeMode.simple;

            render._sceneUpdateMark = -1;
            render._updateMark = -1;
            render._updateRenderType = -1;
            render._isPartOfStaticBatch = false;
            render._staticBatch = null;


            render._cullingBufferIndex = null

            render._revertStaticBatchDefineUV1 = false
            render._projectionViewWorldMatrix = new local_Laya.Matrix4x4();


            render._id = ++local_Laya.BaseRender["_uniqueIDCounter"];
            render._indexInCastShadowList = -1;
            render._bounds = new local_Laya.Bounds(local_Laya.Vector3["_ZERO"], local_Laya.Vector3["_ZERO"]);

            render._renderElements = [];
            render._owner = sp;
            render._enable = true;
            render._materialsInstance = [];
            render._shaderValues = new local_Laya.ShaderData();
            render.lightmapIndex = -1;
            render.receiveShadow = false;
            render.sortingFudge = 0.0;
            render._owner.transform.on(local_Laya.Event.TRANSFORM_CHANGED, render, render._onWorldMatNeedChange);//如果为合并BaseRender,owner可能为空
            render._sharedMaterials = []
        }

        let GetSkinnedMeshSprite3DPool = function () {
            let sp = skinnedMesh_sprite3d_pool.shift()
            if (sp) {
                ResetSprite3D(sp)

                sp._meshFilter._owner = sp

                let render = sp._render
                ResetMeshRender(render, sp)

                render._cacheMesh = null
                render._bones = []
                render._lightmapScaleOffset = new local_Laya.Vector4(1, 1, 0, 0);
                render._skinnedData = []
                render._skinnedDataLoopMarks = []
                render._cacheAnimator = null
                render._cacheRootBone = null

                render._rootBone = null;//[兼容性API]
                render._cacheAvatar = null;//[兼容性API]
                render._cacheRootAnimationNode = null;//[兼容性API]
                render._cacheAnimationNode = [];//[兼容性]
            } else {
                sp = new SkinnedMeshSprite3D();
            }
            return sp
        }
        Sprite3D.prototype["_create"] = function (): Node {
            return GetSprite3DPool();
        }

        SkinnedMeshSprite3D.prototype["_create"] = function (): Node {
            return GetSkinnedMeshSprite3DPool();
        }

        //重写3d模型销毁
        let node_destory = local_Laya.Node.prototype.destroy
        let Sprite3D_type = new Sprite3D()["constructor"].name
        Sprite3D.prototype.destroy = function (destroyChild: boolean = true, cache = false): void {
            if (this.destroyed)
                return;
            node_destory.call(this, destroyChild);
            this._scripts = null;
            if (this._url) {
                let res = local_Laya.loader.getRes(this._url)
                if (res && res["destroyed"]) {
                    local_Laya.Loader.clearRes(this._url);
                }
            }
            if (this._transform && this._transform._children) this._transform._children.length = 0
            if (this["constructor"].name == Sprite3D_type) {
                sprite_3d_pool.push(this);
                // console.log("-----------Sprite3D add pool ------------")
            } else if (!cache) {
                this._transform = null;
            }
        }

        let Sprite3D_destory = local_Laya.Sprite3D.prototype.destroy
        let SkinnedMeshSprite3D_type = new SkinnedMeshSprite3D()["constructor"].name
        SkinnedMeshSprite3D.prototype.destroy = function (destroyChild: boolean = true): void {
            if (this.destroyed)
                return;
            Sprite3D_destory.call(this, destroyChild, true);
            this._meshFilter.destroy();
            this._render._destroy();
            if (this["constructor"].name == SkinnedMeshSprite3D_type) {
                skinnedMesh_sprite3d_pool.push(this);
                // console.log("-----------skinnedMesh_sprite3d_pool add pool ------------")
            } else {
                this._render = null;
            }
        }


        let GetMeshSprite3DPool = function () {
            let sp = mesh_sprite3d_pool.shift()
            if (sp) {
                ResetSprite3D(sp)

                sp._meshFilter._owner = sp

                let render = sp._render
                ResetMeshRender(render, sp)
            } else {
                sp = new MeshSprite3D();
            }
            return sp
        }
        MeshSprite3D.prototype["_create"] = function (): Node {
            return GetMeshSprite3DPool();
        }

        let MeshSprite3D_type = new MeshSprite3D()["constructor"].name
        MeshSprite3D.prototype.destroy = function (destroyChild: boolean = true): void {
            if (this.destroyed)
                return;
            Sprite3D_destory.call(this, destroyChild, true);
            this._meshFilter.destroy();
            this._render._destroy();
            if (this["constructor"].name == MeshSprite3D_type) {
                mesh_sprite3d_pool.push(this);
                // console.log("-----------Mesh_sprite3d_pool add pool ------------")
            } else {
                this._render = null;
            }
        }

        Laya.BaseRender.prototype["_destroy"] = function (){
            (this._indexInOctreeMotionList !== -1) && (this._octreeNode.getManagerNode().removeMotionObject(this));
            this.offAll();
            var i: number = 0, n: number = 0;
            for (i = 0, n = this._renderElements.length; i < n; i++)
                this._renderElements[i].destroy();
            this._sharedMaterials.forEach(element => {
                (element && (element.destroyed || element._removeReference()));//TODO:材质可能为空
            });
            this._renderElements = null;
            this._owner = null;
            this._sharedMaterials = null;
            this._bounds = null;
            this._lightmapScaleOffset = null;
            this._scene = null;
        }
    

        let baseRender_destroy = local_Laya.BaseRender.prototype["_destroy"]
        local_Laya.BaseRender.prototype["_destroy"] = function (): void {
            if (this._owner)
                this._owner.transform.off(local_Laya.Event.TRANSFORM_CHANGED, this, this._onWorldMatNeedChange);//如果为合并BaseRender,owner可能为空
            baseRender_destroy.call(this)
        }

        
        let source_getInstanceMaterial = local_Laya.BaseRender.prototype["_getInstanceMaterial"]
        local_Laya.BaseRender.prototype["_getInstanceMaterial"] = function(material, index: number) {
            if(!material) return null
            return source_getInstanceMaterial.call(this, material, index)
        }


        let run_in_es5 = window["run_in_es5"]
        let GetShuriKenParticle3DPool = function () {
            let sp = shuriKen_particle3d_pool.shift()
            if (sp) {
                ResetSprite3D(sp)

                let render = sp._render
                if (!render)
                    render = sp._render = new local_Laya.ShurikenParticleRenderer(sp);
                // sp._render = render
                // render._lightmapIndex = null
                //  render._receiveShadow = null
                //  render._indexInList = -1;

                //  render._bounds = null;
                //  render._boundsChange = true;


                //  render._castShadow = false;
                //  render._supportOctree = true;

                //  render._distanceForSort= null
                //  render._renderMark = -1;//TODO:初始值为-1强制更新,否则会造成第一帧动画不更新等,待优化
                //  render._octreeNode= null
                //  render._indexInOctreeMotionList = -1;
                //  render._probReflection= null
                //  render._surportReflectionProbe= null
                //  render._reflectionMode = local_Laya.ReflectionProbeMode.simple;

                //  render._sceneUpdateMark = -1;
                //  render._updateMark = -1;
                //  render._updateRenderType = -1;
                //  render._isPartOfStaticBatch = false;
                //  render._staticBatch = null;


                //  render._cullingBufferIndex= null


                //  render.stretchedBillboardCameraSpeedScale = 0;
                //  render.stretchedBillboardSpeedScale = 0;
                //  render.stretchedBillboardLengthScale = 2;


                //  render._id = ++local_Laya.BaseRender["_uniqueIDCounter"];
                //  render._indexInCastShadowList = -1;
                //  render._bounds = new local_Laya.Bounds(local_Laya.Vector3["_ZERO"], local_Laya.Vector3["_ZERO"]);

                //  render._renderElements = [];
                //  render._owner = sp;
                //  render._enable = true;
                //  render._materialsInstance = [];
                //  render._shaderValues = new local_Laya.ShaderData();
                //  render.lightmapIndex = -1;
                //  render.receiveShadow = false;
                //  render.sortingFudge = 0.0;
                //  render._owner.transform.on(local_Laya.Event.TRANSFORM_CHANGED, render, render._onWorldMatNeedChange);//如果为合并BaseRender,owner可能为空
                //  render._sharedMaterials = []

                //  render.renderMode = 0;
                //  //sortingMode = SORTINGMODE_NONE;
                //  render._supportOctree = false;


                let _particleSystem = sp._particleSystem
                
                if (!_particleSystem) {
                    if (!local_Laya["LayaGL"].layaGPUInstance.supportInstance() || run_in_es5) {
                        _particleSystem = new local_Laya.ShurikenParticleSystem(sp);
                    } else
                        _particleSystem = new local_Laya.ShurikenParticleInstanceSystem(sp);

                    sp._particleSystem = _particleSystem
                    var elements = render._renderElements;
                    var element = elements[0] = new local_Laya.RenderElement();
                    element["setTransform"](sp._transform);
                    element["render"] = render;
                    element["setGeometry"](_particleSystem);
                    element["material"] = local_Laya.ShurikenParticleMaterial.defaultMaterial;
                }
                //  _particleSystem._gravityOffset = new local_Laya.Vector2();

                //  _particleSystem._customBounds = null;

                //  _particleSystem._vertices = null;
                //  _particleSystem._floatCountPerVertex = 0;
                //  _particleSystem._startLifeTimeIndex = 0;
                //  _particleSystem._timeIndex = 0;
                //  _particleSystem._simulationUV_Index = 0


                //  _particleSystem._drawCounter = 0;
                //  _particleSystem._shape = null;

                //  _particleSystem._playStartDelay = 0;
                //  _particleSystem._velocityOverLifetime = null;
                //  _particleSystem._colorOverLifetime = null;
                //  _particleSystem._sizeOverLifetime = null;
                //  _particleSystem._rotationOverLifetime = null;
                //  _particleSystem._textureSheetAnimation = null;

                //  _particleSystem._uvLength = new local_Laya.Vector2();//TODO:
                //  _particleSystem._vertexStride = 0;
                //  _particleSystem._indexStride = 0;
                //  _particleSystem._vertexBuffer = null;
                //  _particleSystem._indexBuffer = null;
                //  _particleSystem._bufferState = new local_Laya["BufferState"]();

                //  _particleSystem._updateMask = 0;

                //  _particleSystem._startUpdateLoopCount = 0;

                //  _particleSystem.randomizeRotationDirection = 0;

                //  _particleSystem.startColorType = 0;
                //  _particleSystem.startColorConstant = new local_Laya.Vector4(1, 1, 1, 1);;
                //  _particleSystem.startColorConstantMin = new local_Laya.Vector4(0, 0, 0, 0);
                //  _particleSystem.startColorConstantMax = new local_Laya.Vector4(1, 1, 1, 1);

                //  _particleSystem.simulationSpeed = 1.0;
                //  _particleSystem.scaleMode = 1;

                //  _particleSystem._firstActiveElement = 0;
                // _particleSystem._firstNewElement = 0;
                // _particleSystem._firstFreeElement = 0;
                // _particleSystem._firstRetiredElement = 0;

                // _particleSystem._owner = sp;
                // _particleSystem._ownerRender = sp.particleRenderer;
                // _particleSystem._boundingBoxCorners = [];
                // _particleSystem._boundingSphere = new local_Laya.BoundSphere(new local_Laya.Vector3(), Number.MAX_VALUE);//TODO:
                // _particleSystem._boundingBox = new local_Laya.BoundBox(new local_Laya.Vector3(-Number.MAX_VALUE, -Number.MAX_VALUE, -Number.MAX_VALUE), new local_Laya.Vector3(Number.MAX_VALUE, Number.MAX_VALUE, Number.MAX_VALUE));//TODO:
                // _particleSystem._bounds = new local_Laya.Bounds(_particleSystem._boundingBox.min, _particleSystem._boundingBox.max);
                // _particleSystem._useCustomBounds = false;

                // _particleSystem._currentTime = 0;

                // _particleSystem._destroyed = false;
                // _particleSystem._isEmitting = false;
                // _particleSystem._isPlaying = false;
                // _particleSystem._isPaused = false;
                // _particleSystem._burstsIndex = 0;
                // _particleSystem._frameRateTime = 0;
                // _particleSystem._emissionTime = 0;
                // _particleSystem._totalDelayTime = 0;
                // _particleSystem._simulateUpdate = false;

                // _particleSystem._bufferMaxParticles = 1;
                // _particleSystem.duration = 5.0;
                // _particleSystem.looping = true;
                // _particleSystem.prewarm = false;
                // _particleSystem.startDelayType = 0;
                // _particleSystem.startDelay = 0.0;
                // _particleSystem.startDelayMin = 0.0;
                // _particleSystem.startDelayMax = 0.0;

                // _particleSystem._startLifetimeType = 0;
                // _particleSystem._startLifetimeConstant = 5.0;
                // _particleSystem._startLifeTimeGradient = new local_Laya.GradientDataNumber();
                // _particleSystem._startLifetimeConstantMin = 0.0;
                // _particleSystem._startLifetimeConstantMax = 5.0;
                // _particleSystem._startLifeTimeGradientMin = new local_Laya.GradientDataNumber();
                // _particleSystem._startLifeTimeGradientMax = new local_Laya.GradientDataNumber();
                // _particleSystem._maxStartLifetime = 5.0;//_startLifetimeType默认为0，_startLifetimeConstant为5.0,因此该值为5.0

                // _particleSystem.startSpeedType = 0;
                // _particleSystem.startSpeedConstant = 5.0;
                // _particleSystem.startSpeedConstantMin = 0.0;
                // _particleSystem.startSpeedConstantMax = 5.0;
                // _particleSystem.threeDStartSize = false;
                // _particleSystem.startSizeType = 0;
                // _particleSystem.startSizeConstant = 1;
                // _particleSystem.startSizeConstantSeparate = new local_Laya.Vector3(1, 1, 1);
                // _particleSystem.startSizeConstantMin = 0;
                // _particleSystem.startSizeConstantMax = 1;
                // _particleSystem.startSizeConstantMinSeparate = new local_Laya.Vector3(0, 0, 0);
                // _particleSystem.startSizeConstantMaxSeparate = new local_Laya.Vector3(1, 1, 1);

                // _particleSystem.threeDStartRotation = false;
                // _particleSystem.startRotationType = 0;
                // _particleSystem.startRotationConstant = 0;
                // _particleSystem.startRotationConstantSeparate = new local_Laya.Vector3(0, 0, 0);
                // _particleSystem.startRotationConstantMin = 0.0;
                // _particleSystem.startRotationConstantMax = 0.0;
                // _particleSystem.startRotationConstantMinSeparate = new local_Laya.Vector3(0, 0, 0);
                // _particleSystem.startRotationConstantMaxSeparate = new local_Laya.Vector3(0, 0, 0);

                // _particleSystem.gravityModifier = 0.0;
                // _particleSystem.simulationSpace = 1;
                // _particleSystem.scaleMode = 1;
                // _particleSystem.playOnAwake = true;
                // _particleSystem._rand = new local_Laya.Rand(0);
                // _particleSystem.autoRandomSeed = true;
                // _particleSystem.randomSeed = new Uint32Array(1);
                // _particleSystem._randomSeeds = new Uint32Array(local_Laya.ShurikenParticleSystem["_RANDOMOFFSET"].length);
                // _particleSystem.isPerformanceMode = true;

                // _particleSystem._emission = new local_Laya.Emission();
                // _particleSystem._emission.enable = true;
            } else {
                sp = new ShuriKenParticle3D();
            }
            return sp
        }
        ShuriKenParticle3D.prototype["_create"] = function (): Node {
            return GetShuriKenParticle3DPool();
        }

        let ShuriKenParticle3D_type = new ShuriKenParticle3D()["constructor"].name
        ShuriKenParticle3D.prototype.destroy = function (destroyChild: boolean = true): void {
            if (this.destroyed)
                return;
            Sprite3D_destory.call(this, destroyChild, true);
            this._particleSystem.destroy();
            this._render._destroy();
            if (this["constructor"].name == ShuriKenParticle3D_type) {
                shuriKen_particle3d_pool.push(this);
                // console.log("-----------ShuriKenParticle3D add pool ------------")
            } else {
            }
            this._particleSystem = null;
            this._render = null;
        }
        
        Animator.prototype.onReset = function (): void {
            this._controllerLayers = [];
            this._linkSprites = {};
            this._speed = 1.0;
            this._keyframeNodeOwnerMap = {};
            this._updateMark = 0;

            this._keyframeNodeOwners = [];
            if(!run_in_es5)
            this._updateMode = local_Laya.AnimatorUpdateMode.Normal;
            this._lowUpdateDelty = 20;
            this._avatarNodeMap = null;
            this._linkAvatarSpritesData = {};
            this._linkAvatarSprites = [];
            this._renderableSprites = [];
            this.cullingMode = Animator.CULLINGMODE_CULLCOMPLETELY;
        }

        let Scene3DUtils = Laya["Scene3DUtils"]
        Scene3DUtils._createSprite3DInstance = function (nodeData: any, spriteMap: any, outBatchSprites) {
            var node;
            switch (nodeData.type) {
                case "Sprite3D":
                    node = GetSprite3DPool();
                    break;
                case "ShuriKenParticle3D":
                    node = GetShuriKenParticle3DPool();
                    break;
                case "MeshSprite3D":
                    node = GetMeshSprite3DPool();
                    // (outBatchSprites && nodeData.props.isStatic) && (outBatchSprites.push(node));
                    break;
                case "SkinnedMeshSprite3D":
                    node = GetSkinnedMeshSprite3DPool();
                    break;
                case "TrailSprite3D":
                    node = new local_Laya.TrailSprite3D();
                    break;
                case "Camera":
                    node = new local_Laya.Camera();
                    break;
                case "Scene3D":
                    node = new local_Laya.Scene3D();
                    break;
                case "SimpleSkinnedMeshSprite3D":
                    node = new local_Laya.SimpleSkinnedMeshSprite3D();
                    break;
                case "DirectionLight":
                    node = new local_Laya.DirectionLight();
                    break;
                case "PointLight":
                    node = new local_Laya.PointLight();
                    break;
                case "SpotLight":
                    node = new local_Laya.SpotLight();
                    break;
                case "ReflectionProbe":
                    node = new local_Laya.ReflectionProbe();
                    break;
                default:
                    throw new Error("Utils3D:unidentified class type in (.lh) file.");
            }
            var childData: any[] = nodeData.child;
            if (childData) {
                for (var i: number = 0, n: number = childData.length; i < n; i++) {
                    var child: any = Scene3DUtils._createSprite3DInstance(childData[i], spriteMap, outBatchSprites)
                    node.addChild(child);
                }
            }
            spriteMap[nodeData.instanceID] = node;
            return node;
        }

        Scene3DUtils._parse = function (data: any, propertyParams: any = null, constructParams: any[] = null) {
            var json: any = data.data;
            var sprite;
            // switch (data.version) {
            //     case "LAYAHIERARCHY:02":
            sprite = (Scene3DUtils._createNodeByJson02(json));
            //         break;
            //     default:
            //         sprite = (Scene3DUtils._createNodeByJson(json));
            // }
            // StaticBatchManager.combine(sprite, outBatchSprits);
            return sprite;
        }

        //处理释放粒子的时候第一帧 总放不出来
        //@ts-ignore
        ShurikenParticleSystem.prototype._updateParticles = function (elapsedTime: number): void {
            if (this._ownerRender.renderMode === 4 && !this._ownerRender.mesh)//renderMode=4且mesh为空时不更新
			    return;
            this._currentTime += elapsedTime;//计算目前粒子播放时间啊
            this._retireActiveParticles(elapsedTime);
            this._freeRetiredParticles();
            this._totalDelayTime += elapsedTime;
            if (this._totalDelayTime < this._playStartDelay) {
                return;
            }

            if (this._emission.enable && this._isEmitting && !this._isPaused)
                this._advanceTime(elapsedTime, this._currentTime);

        }

        //@ts-ignore
        ShurikenParticleSystem.prototype._retireActiveParticles = function (elapsedTime: number): void {
            const epsilon: number = 0.0001;
            while (this._firstActiveElement != this._firstNewElement) {
                var index: number = this._firstActiveElement * this._floatCountPerVertex * this._vertexStride;
                var timeIndex: number = index + this._timeIndex;//11为Time

                let need_retire = false
				if(elapsedTime + this._emissionTime > this.duration && this.maxParticles == 1 && this.looping){
					need_retire = true
				}
                var particleAge: number = this._currentTime - this._vertices[timeIndex];
                if (particleAge + epsilon < this._vertices[index + this._startLifeTimeIndex]/*_maxLifeTime*/ && !need_retire)//7为真实lifeTime,particleAge>0为生命周期为负时
                    break;

                this._vertices[timeIndex] = this._drawCounter;
                this._firstActiveElement++;
                if (this._firstActiveElement >= this._bufferMaxParticles)
                    this._firstActiveElement = 0;
            }
        }
        

        //原生包不支持斜体的处理
        Object.defineProperty(local_Laya.Text.prototype, "italic", {
            get: function(){
                return ((<Laya.TextStyle>this._style)).italic;
            },
            set: function(value){
                if(window["Util"] && window["Util"].IsConch()) return
                this._getTextStyle().italic = value;
                this.isChanged = true;
            },
            configurable: true
        })

        Object.defineProperty(local_Laya.HTMLStyle.prototype, "italic", {
            get: function(){
                //@ts-ignore
                return (this._type & Laya.HTMLStyle._ITALIC) != 0;
            },
            set: function(value){
                if(window["Util"] && window["Util"].IsConch()) return
                //@ts-ignore
                value ? (this._type |= Laya.HTMLStyle._ITALIC) : (this._type &= ~Laya.HTMLStyle._ITALIC);
            },
            configurable: true
        })
    }
}