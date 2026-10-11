import Loader = Laya.Loader;
import URL = Laya.URL;
import EventDispatcher = Laya.EventDispatcher;
/**
*
* @ author:xs
* @ data: 2021-09-14 12:41
*/
export class WorkerUtils  extends EventDispatcher{

    /**单例*/
    static I: WorkerUtils;
    /**@private */
    private static _preLoadFun: any;
    private static _preImgLoadFun: any;
    static instance:WorkerUtils;
    /**使用的Worker对象。*/
    worker: any;
    constructor() {
        super();
    }

    static init()
    {
        WorkerUtils._preImgLoadFun = Laya.MiniLoader._transformImgUrl;
        Laya.MiniLoader._transformImgUrl = WorkerUtils._transformImgUrl;
        WorkerUtils._preLoadFun = Loader["prototype"]["_loadImage"];
        if (!WorkerUtils.I) WorkerUtils.I = new WorkerUtils();
        WorkerUtils.I.createWorker();
    }


    /**
     * @param url 图片路径
     * @param type 图片类型
     * @param thisLoader Loader对象
     */
    static _transformImgUrl(url:string,type:string, thisLoader:any)
    {
        if (Laya.MiniAdpter.isZiYu || Laya.MiniFileMgr.isLocalNativeFile(url)) {
            if (Laya.MiniFileMgr.isLocalNativeZipFile(url)) {
                url = Laya.MiniFileMgr.getFileNativePath(url);
            }
            thisLoader._loadImage(url, false);
            return;
        }
        if (!Laya.MiniAdpter.autoCacheFile) {
            thisLoader._loadImage(url);
        }else
        {
            var tempUrl = Laya.URL.formatURL(url);
            if (!Laya.MiniFileMgr.isLocalNativeFile(url) && !Laya.MiniFileMgr.getFileInfo(tempUrl)) {
                if (Laya.MiniFileMgr.isNetFile(tempUrl)) {
                    //需要通过worker加载
                    WorkerUtils.I.loadImage(tempUrl,thisLoader);
                }
                else {
                    thisLoader._loadImage(url, false);
                }
            }
            else {
                var fileObj = Laya.MiniFileMgr.getFileInfo(tempUrl);
                if (fileObj && fileObj.md5) {
                    tempUrl = fileObj.tempFilePath || Laya.MiniFileMgr.getFileNativePath(fileObj.md5);
                }
                thisLoader._loadImage(tempUrl, false);
            }
        }
        
    }

    createWorker()
    {
        let useExperimentalWorker = true
        if(Laya.Browser.onIOS)
        {
            useExperimentalWorker = false
        }
        // 监听worker被系统回收事件
        this.worker = Laya.Browser.window.wx.createWorker('worker/request/index.js',{
            useExperimentalWorker:useExperimentalWorker
        });
        var me:any = this;
        this.worker.onProcessKilled(function(){
            // 重新创建一个worker
            this.Worker = Laya.Browser.window.wx.createWorker('worker/request/index.js',{
                useExperimentalWorker:useExperimentalWorker
            });
        });
        this.worker.onMessage(function(data){
            me.workerMessage(data);
        });
    }

    /**
     * @private
     */
    workerMessage(data: any): void {
        if (data) {
            this.imageLoaded(data);
        }
    }

    /**
     * @private
     */
     private imageLoaded(data: any): void {
        var tempFilePath:string = null;
        var readyUrl:string = data.readyUrl;
        if(data.errCode==0)
        {   
            var fileObj = Laya.MiniFileMgr.getFileInfo(readyUrl);
            if(!fileObj)
            {
                tempFilePath = data.data.tempFilePath;
                Laya.MiniFileMgr.copyTOCache(tempFilePath, readyUrl, null, "", true);//存储下载的外网图片地址，下次直接从缓存里使用
            }
            console.log("load success :", readyUrl);
        }
        this.event(readyUrl, tempFilePath);
        

    }

    /**
     * 加载图片
     * @param	url 图片地址
     */
     loadImage(url: string,thisLoader:any): void {
        var _this: Loader = thisLoader;
        if (!this.worker) {
            WorkerUtils._preLoadFun.call(_this, url);
            return;
        }
        url = URL.formatURL(url);
        function clear(): void {
            WorkerUtils.I.off(url, _this, onload);
        }
        var onload: Function = function (url: any): void {
            clear();
            if (url) {
                _this["_loadImage"](url, false);
            } else {
                //失败之后使用原版的加载函数加载重试
                WorkerUtils._preLoadFun.call(_this, url);
            }
        };
        this.worker.postMessage({url:url});
        WorkerUtils.I.on(url, _this, onload);
    }

    /**
     * @private
     * 加载图片资源。
     * @param	url 资源地址。
     */
    protected _loadImage(url: string): void {
        var _this: Loader = (<Loader>(this as any));
        if (!this.worker) {
            WorkerUtils._preLoadFun.call(_this, url);
            return;
        }
        url = URL.formatURL(url);
        function clear(): void {
            WorkerUtils.I.off(url, _this, onload);
        }
        var onload: Function = function (url: any): void {
            clear();
            _this["_loadImage"](url, false);
        };
        WorkerUtils.I.on(url, _this, onload);
        WorkerUtils.I.loadImage(url,_this);
    }

    terminate()
    {
        if(this.worker)
        {
            this.worker.terminate();
            this.worker = null;
        }
    }

    /**
     * 恢复重写
     */
    recover()
    {
        this.terminate();
        Loader["prototype"]["_loadImage"] = WorkerUtils._preLoadFun;
        Laya.MiniLoader._transformImgUrl = WorkerUtils._preImgLoadFun;
    }
}