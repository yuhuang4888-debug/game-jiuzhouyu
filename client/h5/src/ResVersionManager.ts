import { ResManager } from "./common/ResManager";
import { Util } from "./util/Util";
import { CookieWrapper } from "./common/CookieWrapper";
import { EventDispatcher } from "./util/EventDispatcher";
import { PlatformManager } from "./PlatformManager";
/**
 * Created by yangsong on 15-4-21.
 * 单一资源通过版本号加载管理类
 */
export class ResVersionManager extends EventDispatcher {
    public static resource_version = "";
    public static js_version = "";
    public static uiconfig_version = "";
    public static engine_version = "1";
    public static last_main_version = 0;
    public static main_version = 1;
    public static hot_update_version = 1;
    public static base_cdn_config_url = "";
    public static backup_cdn_config_url = "";
    public static wx_cdn_config_url = "";
    public static wx_alpha_version = 0;
    public static cfg_wx_alpha_version = 0; //打在小程序包内的版本号
    private static _instance: ResVersionManager;
    public resVersionData: any = {}; //最新的版本数据
    private _version_cache = {}; //最新的版本数据缓存
    private _res_mgr: ResManager;
    private _random_value = Math.random() + ""
    private _replace_msg_list = [
       // "resource/game/",特殊处理了
        "resource/config/",
        "resource/object/",
        "resource/effect/",
        "resource/font/"
    ]
    
    public constructor() {
        super()
        this._res_mgr = ResManager.GetInstance();
    }
    public static GetInstance(): ResVersionManager {
        if (ResVersionManager._instance == null) {
            ResVersionManager._instance = new ResVersionManager();
        }
        return ResVersionManager._instance;
    }
    /**
     * Res加载使用版本号的形式
     */
    public OverrideResGetRealURL = () => {
        var patternFileExtension = /\.([0-9a-z]+)(?:[\?#]|$)/i;
        Laya.Utils.getFileExtension = (path: string) => {
            //获得文件扩展名 
            var fileExtension = (path).match(patternFileExtension);
            return fileExtension && fileExtension[1] || null
        }

        /**
         * @private 
         * 为兼容平台后缀名不能用的特殊兼容TODO：
         */
         Laya.Utils.getFilecompatibleExtension = (path: string) =>{
            // var result:string[] = path.split(".");
            // var resultlen:number = result.length;
            // if(result.length>2)
            // return result[resultlen-2]+"."+result[resultlen-1];
            // else
            return null;

        }
        let URL = Laya.URL
        let base_path = this._res_mgr.cdn_res_path || URL["_basePath"]
            /**
         * 格式化指定的地址并返回。
         * @param	url 地址。
         * @param	base 基础路径，如果没有，则使用basePath。
         * @return	格式化处理后的地址。
         */
        Laya.URL.formatURL = function(url: string): string {
            if (!url) return "null path";
            //如果是全路径，直接返回，提高性能
            // if (url.indexOf(":") > 0) return url;
            if(url.indexOf(":") > 0 && url.indexOf("?v=") > 0 ) return url
            //exportSceneToJson == true 变更后缀名
            // if (URL.exportSceneToJson) url = URL.getAdptedFilePath(url);
            //自定义路径格式化
            url = URL.customFormat(url);
            //如果是全路径，直接返回，提高性能
            if (url.indexOf(":") > 0) return url;
            // return url;
            // var char1: string = url.charAt(0);
            // if (char1 === ".") {
            //     return URL["_formatRelativePath"](URL["_basePath"] + url);
            // } else if (char1 === '~') {
            //     return URL.rootPath + url.substring(1);
            // } else if (char1 === "d") {
            //     if (url.indexOf("data:image") === 0) return url;
            // } else if (char1 === "/") {
            //     return url;
            // }
            return base_path + url;
        } 
        // if(Util.IsConch())
        // {
        //     Laya.URL.customFormat = (url:string) =>
        //     {
        //         //是否有参数
        //         let index = url.indexOf('?')
        //         if(index > -1){
        //             url = url.slice(0, index)
        //         }
        //         return url
        //     }
        // }else
        // {
            Laya.URL.customFormat = (url:string) =>
            {
                //是否有参数
                let index = url.indexOf('?')
                if(index > -1){
                    //去参数
                    if(url.indexOf("&") > -1)
                    {
                        url = url.slice(0, index)
                    }else
                    {
                        return url
                    }
                }
                return `${url}?v=${this.ParseUrlByVersion(url)}`
            }
        // }
    };
    
    //封装某个url资源 添加版本号
    public ParseUrlByVersion = (url: string) => {
        var version: string = "";
        var version_cache = this._version_cache;
        version = version_cache[url];
        if (version)
            return version;
        var resVersion: any = this.resVersionData;
        if(!resVersion)
        {
            version_cache[url] = this._random_value;
            return this._random_value;
        }
        let version_url = url;
        let start_index = url.indexOf("resource/")
        if(start_index >= 0 && resVersion)
        {
            version_url = url.substring(start_index)
            version = resVersion[version_url];
            if(!version)
            {   
                let str = version_url.match(/resource\/\w+\/+/)
                if(str && version_url.indexOf("resource/game/") < 0)
                {
                    let tem_url = str.toString()
                    if(this._replace_msg_list.indexOf(tem_url) >= 0)
                    {
                        tem_url = version_url.replace(tem_url, "")
                        version = resVersion[tem_url];
                        if(version)
                        {
                            version_cache[url] = version;
                            return version;
                        }
                    }
                }else
                {
                    let base_url = "resource/game/"
                    let list = version_url.replace(base_url, "").split("/");
                    if (list && list.length > 0) {
                        let len = list.length;
                        let check_url = "";
                        for (let i = 0; i < len; i++) {
                            check_url += list[i];
                            version = resVersion[check_url];
                            if (version) {
                                break;
                            }
                            check_url += '/';
                        }
                    }
                }
            }
        }
        if (!version) {
            version = this._random_value;
        }
        version_cache[url] = version;
        return version;
    };
    /**
     * 加载资源版本号配置文件
     * @param url 配置文件路径
     */
    public async LoadVersionConfig() {
        if (Util.IsDebug()) {
            let url = this._res_mgr.cdn_res_path + "resource/resource_version.json?v=" + ResVersionManager.resource_version;
            await new Promise<void>((resolve, reject) => { 
                this._res_mgr.GetResByUrl(this.hashCode,  url, (data) => {
                // console.warn("------LoadVersionConfig End-----")
                this.resVersionData = data;
                this.OverrideResGetRealURL();
                resolve()
            }, this, Laya.Loader.JSON);
            })
        }
        else {
            if(
                (Util.IsWXGame() && !Laya.MiniAdpter.autoCacheFile && PlatformManager.GetInstance().is_wx_alpha)
                || (Util.IsQQGame() && !Laya.QQMiniAdapter.autoCacheFile && PlatformManager.GetInstance().is_wx_alpha)
                || (Util.IsOPPOFastGame() && !Laya.QGMiniAdapter.autoCacheFile && PlatformManager.GetInstance().is_wx_alpha)
                || (Util.IsVivoFastGame() && !Laya.VVMiniAdapter.autoCacheFile && PlatformManager.GetInstance().is_wx_alpha)
                || (Util.IsMiFastGame() && !Laya.KGMiniAdapter.autoCacheFile && PlatformManager.GetInstance().is_wx_alpha)
                || (Util.IsUCGame() && PlatformManager.GetInstance().is_wx_alpha)
                || (Util.IsMeiZuFastGame() && PlatformManager.GetInstance().is_wx_alpha)
                || (Util.IsBiliBiliGame() && !Laya.BLMiniAdapter.autoCacheFile && PlatformManager.GetInstance().is_wx_alpha)
                || (Util.IsKSGame() && !Laya.MiniAdpter.autoCacheFile && PlatformManager.GetInstance().is_wx_alpha)
                || (Util.IsMTGame() && !Laya.MiniAdpter.autoCacheFile && PlatformManager.GetInstance().is_wx_alpha)
                || (Util.IsTTGame() && !Laya.TTMiniAdapter.autoCacheFile && PlatformManager.GetInstance().is_wx_alpha)
                
            )//微信QQ快应用不用版本号
            {
                this.OverrideResGetRealURL();
            }else{
                let root_path = this._res_mgr.cdn_res_path;
                if (Util.IsNeedLoadLocal()) {
                    root_path = "";
                }
                let url = root_path + "resource/resource_version.zip?v=" + ResVersionManager.resource_version;
                await new Promise<void>((resolve, reject) => {
                    this._res_mgr.GetResByUrl(this.hashCode,  url, (data) => {
                        let zip = new JSZip();
                        zip = zip.load(data, null);
                        let jsz_obj = zip.file("resource_version.json");
                        zip.remove("resource_version.json");
                        if (jsz_obj) {
                            let txt = jsz_obj["asText"]();
                            if (txt) {
                                let cfg_data = JSON.parse(txt);
                                this.resVersionData = cfg_data;
                                Laya.loader.clearRes(root_path + "resource/resource_version.zip")
                                this.OverrideResGetRealURL();
                                // window["progress"]++;
                                resolve();
                            }
                        }
                    }, this, Laya.Loader.BUFFER);
                });
            }
        }
    }
    //加载手动修改的游戏版本文件和加载全局版本号文件 其实就是svn版本号
    public async LoadGameManulVersionConfig() {
        console.log("------LoadGameManulVersionConfig Start-----");
        let root_path = this._res_mgr.cdn_res_path;
        if (Util.IsNeedLoadLocal()) {
            root_path = "";
        }
        let manul_version_cfg = root_path + "resource/game_manul_version.json?v=" + Math.random();
        await new Promise<void>((resolve, reject) => { 
                this._res_mgr.GetResByUrl(this.hashCode, manul_version_cfg, (data) => {
                console.log("------LoadGameManulVersionConfig End-----");
                if (data) {
                    ResVersionManager.engine_version = data.engine_version;
                    ResVersionManager.main_version = data.main_version;
                    ResVersionManager.hot_update_version = data.hot_update_version;
                    ResVersionManager.resource_version = data.resource_version;
                    ResVersionManager.js_version = data.js_version;
                    ResVersionManager.uiconfig_version = data.uiconfig_version;
                }
                resolve()
            }, this, Laya.Loader.JSON);
        })
    }
    //登录游戏成功后 设置上一次游戏主版本号
    public SetLastGameMainVersion() {
        let l_v = CookieWrapper.GetInstance().GetCookie(CookieWrapper.GAME_MAIN_VERSION, false);
        if (l_v) {
            ResVersionManager.last_main_version = +l_v;
        }
        CookieWrapper.GetInstance().SaveCookie(CookieWrapper.GAME_MAIN_VERSION, ResVersionManager.main_version.toString(), false);
    }
}

window["ResVersionManager"] = ResVersionManager