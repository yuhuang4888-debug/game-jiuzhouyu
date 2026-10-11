import { HashEventDispatcher } from "./HashEventDispatcher";
import { BaseClass, HashObject, IBaseClass } from "./BaseClass";
import { Util, DEVICE_OS, GlobalTimerQuest, GetTargetHashcode, ResetTransform, ResetSkinnedMeshSprite3D, GetParams, Set3DLocalPosition, Set3DLocalRotationEuler, Set3DLocalScale } from "../util/Util";
import { GameError } from "../util/GameError";
import { ResVersionManager } from "../ResVersionManager";
import { Config } from "./Config";
import { GameResPath } from "../util/GameResPath";
import { ClientConfig, FRAME_TYPE, GlobalEventSystem, LOAD_QUEUE } from "../util/DeclareGlobalVar";
import { EventName } from "./EventName";
import { UserMsgAdapter } from "./UserMsgAdapter";
import { Enum_UILayer, LayerManager } from "./LayerManager";
import { EffectResType, SceneBaseType } from "../scene/SceneConfig";
import { HttpUtil } from "../util/HttpUtil";
import { ResInfo } from "./ResInfo";
import { Runner } from "../util/Runner";
import { RoleManager } from "../commonModel/RoleManager";
import { CameraManager } from "../scene/CameraManager";
// TypeScript file
export class ResGroupInfo {
    public reference_count: number = 0;
}
let local_LOAD_QUEUE = LOAD_QUEUE
let local_Laya = Laya
let local_GameResPath = GameResPath
let local_Util = Util
export class ResManager extends HashEventDispatcher {

    public static SOURCE_TEXTGC = null;
    //需要预加载的模块必须资源  会卡进度条
    // public static PRELOAD_MUST_MODULE_RES = ["common", "common2", "common4", "uiComponent"];
    //需要预加载的角色动作资源 通过角色信息动态添加
    public static PRELOAD_MUST_ACTION_RES = [];
    private static _instance: ResManager;
    static Check_Waiting_Queue_Max_Count = 45;
    //超过这个时间都还没去请求加载的 就从等待队列中删除 毫秒
    static Check_Waiting_Queue_Max_Time = 30 * 1000;
    public cdn_res_path = ""; //cdn资源路径
    public backup_res_dic = {}; //通过备份cdn加载的资源对象
    //mainui加载完毕
    public mainui_has_loaded = false;
    public timer_index = 0;
    public true_game_start = false;
    public mainUI_has_loaded = false;
    private _useWorkerLoader = Laya.Browser.onPC? false : true//测试不要提体验 true
    public preload_complete = false
    // private pool_con_sprite_3d: Laya.Sprite3D
    // private static_con_sprite_3d: Laya.Sprite3D
    private static_sprite_hash_code = HashObject.CreateHashcode()
    sprite_3d_pool_res_count

    public initShaderPromise: Promise<any>
    //每个url的加载标识
    _url_loaded_flag: {
        [key: string]: Boolean;
    } = {};
    LoadCompletedFromCDNToSaveCookie;
    CheckResHasLoadedFromCDN;
    GCRES;
    TriggerGameStart;
    SetMaxLoadingThread;
    PreloadNecessaryModuleRes;
    PreloadLoginConfig
    PreloadCommonRes;
    LoadJs;
    IsJsLoad;
    AddReferenceCount;
    ReduceReferenceCount;
    DestroyRes;
    DestoryResOnFrame
    DestroyAllReferenceRes;
    GetResReferenceCount;
    NormalCdnToBackUpCdn;
    LoadResByUrlComplete;
    GetResByUrl;
    GetRes;
    _config_name_reference_count_dic = {};
    LoadDebugIpList;
    LoadConfigZip;
    LoadUIConfigZip;
    LoadProtocalConfigZip;
    PreLoadConfigFormZip;
    LoadConfigFormZip;
    Update;
    Load2dCallback;

    Init;


    //静态缓存资源字典
    static_sprite_3d_name_dic = {}
    //静态缓存资源字典
    static_sprite_3d_dic = {}
    //缓存列表
    sprite_3d_pool_dic = {}
    //界面显示模型对象列表
    role_mode_list = {}
    //位图字体对象
    bitmap_font_objs = {}
    //位图字体的引用
    bitmap_font_name_references = {}

    //Laya.Sprite3D的缓存池
    laya_sprite_3d_pool = []
    laya_skinnedMesh_sprite3d_pool = []
    laya_mesh_sprite3d_pool = []
    laya_shuriKen_particle3d_pool = []


    private loaded_2d_callbacks = []
    private loaded_3d_callbacks = []

    // public autoClearRes = false
    public changeSceneClearRes = false

    private all_uiconfig_config

    private onPC = false

    public load_prefab_cache_lhdata = {}

    public default_head_objs = {}


    public constructor() {
        super();
        this.onPC = Laya.Browser.onPC
        if (local_Util.IsWXGame() 
        || local_Util.IsQQGame() 
        || local_Util.IsOPPOFastGame() 
        || local_Util.IsVivoFastGame() 
        || local_Util.IsUCGame() 
        || local_Util.IsMiFastGame() 
        || local_Util.IsBiliBiliGame() 
        || local_Util.IsMeiZuFastGame() 
        || local_Util.IsKSGame() 
        || local_Util.IsMTGame()
        || local_Util.IsTTGame()
        || Laya.Browser.onFirefox 
        || window["run_in_es5"] 
        || local_Util.IsConch() 
        || (Laya.Browser.onIOS && Util.IsIOS16()
        
        )) {
            this._useWorkerLoader = false
        }
        // this._useWorkerLoader = true
        Laya.WorkerLoader.enable = this._useWorkerLoader
        let loaded_2d_callback_speed = this.onPC ? 1 : 0.3
        //资源名字对应对象哈希值的字典
        let _res_name_to_hash_code_dic_: {
            [key: string]: {
                [key: number]: Boolean;
            };
        } = {},

            _is_jsmodule_loaded_dic_ = {},
            //对象哈希值对应资源名字的字典
            _hash_code_to_res_name_dic_ = {}, //:{[key:number]:{[key:string]:Boolean;};} = {},
            //资源组引用数量字典
            _res_name_reference_count_dic_: {
                [key: string]: number;
            } = {},
            _delete_list = [],
            //正在等待加载完资源的timer
            _url_loading_timer_callback_list_ = {},
            //正在加载中的回调参数
            _url_loading_callback_args_ = {},

            //resource\config 目录下的配置文件压缩包
            _all_config_zip_: JSZip,
            _all_uiconfig_zip_,
            //配置名字对应的配置对象
            //静默下载的资源 是游戏玩到后面可能会用到的资源 只需要下载到浏览器缓存就可以了
            local_laya = Laya, game_error = GameError.GetInstance(), local_Config = Config;


        this.Init = () => {
            Runner.GetInstance().AddRunObj(this, 1, FRAME_TYPE.odd)
        }


        let update_frames = 1
        let timer_info_list: Array<any>
        let call_size
        let obj
        let info

        let waitLoadedCallback = (url: string, obj) => {
            timer_info_list = _url_loading_timer_callback_list_[url]
            if (timer_info_list) {
                for (let timer_info of timer_info_list) {
                    if (timer_info && timer_info.compFunc) {
                        timer_info.compFunc.call(timer_info.thisObject, obj, ...timer_info.args);
                    }
                }
                delete _url_loading_timer_callback_list_[url];
            }
        }

        this.Load2dCallback = (url) => {
            if (url) {
                obj = this.GetRes(url)
                info = _url_loading_callback_args_[url];
                if (obj) {
                    this._url_loaded_flag[url] = true;
                    // this.LoadCompletedFromCDNToSaveCookie(url);
                    if (info) {
                        // console.log("loadCompleted url = ", url, compFunc, obj, md5.hex_md5(obj))
                        if (info.compFunc) {
                            info.compFunc.call(info.thisObject, obj, ...info.args);
                        }
                        delete _url_loading_callback_args_[url];
                    }
                    waitLoadedCallback(url, obj)
                }
                else {
                    if (info) {
                        let local_info = info, local_url = url
                        let BackUpUrl = this.NormalCdnToBackUpCdn(url);
                        local_laya.loader.load(BackUpUrl, local_laya.Handler.create(this, () => {
                            let backup_obj = this.GetRes(BackUpUrl)
                            if (backup_obj) {
                                game_error.SendErrorToPHP("加载备份cdn资源成功！！！！ -------------------------" + BackUpUrl, true);
                                this.backup_res_dic[local_url] = backup_obj; //备份cdn路径下载的资源
                                this._url_loaded_flag[local_url] = true;
                                // this.LoadCompletedFromCDNToSaveCookie(local_url);
                            }
                            else {
                                game_error.SendErrorToPHP("加载备份cdn资源失败？？？-------------------------" + BackUpUrl, true);
                                delete this._url_loaded_flag[local_url];
                            }
                            if (local_info.compFunc) {
                                local_info.compFunc.call(local_info.thisObject, backup_obj, ...local_info.args);
                            }
                            delete _url_loading_callback_args_[local_url];
                            waitLoadedCallback(BackUpUrl, backup_obj)
                        }), null, info.type, local_LOAD_QUEUE.HIGHT, true, null, false, this._useWorkerLoader)
                    } else {
                        //delete this._url_loaded_flag[url]
                    }
                }
            }
        }

        this.Update = (now_time, elapse_time) => {
            update_frames++
            if (update_frames % 2 == 0) {
                this.DestoryResOnFrame(0.1, true)
                call_size = Math.ceil(this.loaded_3d_callbacks.length * 0.2)
                if (call_size > 0) {
                    for (let i = 0; i < call_size; i++) {
                        info = this.loaded_3d_callbacks.shift()
                        if (info) {
                            if (info.sp && info.load_call_back) {

                                // 存在一种情况, 有两条请求同时引用了同一个资源,当第一条回调时,在功能逻辑内直接被删掉进入了缓存池,
                                // 且这时候刚好有另一个新的sprite创建,它从缓存内拿走了这个刚删除的sprite,这时第二条请求的信息内的sp就是新的sprite
                                // info.sp._url == Laya.URL.formatURL(info.url) 通过url来区分,加载回调的sprite是不是当前请求需要的sprite
                                if (!info.sp.destroyed && info.sp._url && info.sp._url.indexOf(info.url) >= 0) {
                                    if (info.sp.parent) {
                                        // console.log("-------loaded_3d_callbacks--------clone111111111", info.url)
                                        let clone_obj = info.sp.clone()
                                        // console.warn("info.sp.clone1111111111111111111 =", info.url, Math.random())
                                        clone_obj.active = true
                                        info.load_call_back(clone_obj)
                                    }
                                    else {
                                        let sprite_3d
                                        if (this.CheckSpIsInPool(info.sp, info.url)) {
                                            sprite_3d = this.GetSprite3DFormPool(info.hash_code, info.url)
                                        } else {
                                            sprite_3d = info.sp
                                        }
                                        // console.warn("info.sp222222222222222222 =", info.url, Math.random())
                                        if (sprite_3d) {
                                            sprite_3d.active = true
                                            info.load_call_back(sprite_3d)
                                        }
                                    }
                                }
                                else {
                                    // console.warn("-------loaded_3d_callbacks--------CreatePrefab3333333333", info.url, Math.random())
                                    this.CreatePrefab(info.hash_code, info.url, info.load_call_back, local_LOAD_QUEUE.HIGHT, info.ignore_pool)
                                }
                            }
                        }
                    }
                }
            } else {
                call_size = Math.ceil(this.loaded_2d_callbacks.length * loaded_2d_callback_speed)
                if (call_size > 0) {
                    for (let i = 0; i < call_size; i++) {
                        this.Load2dCallback(this.loaded_2d_callbacks.shift())
                    }
                }
            }
        }

        //标识资源从cdn下载完
        this.LoadCompletedFromCDNToSaveCookie = (url: string) => {
            // _cookie_.SaveCookie(url, "1");
        };
        //检测资源是否曾经从cdn下载完过 
        this.CheckResHasLoadedFromCDN = (url: string) => {
            return false//_cookie_.GetCookie(url);
        };
        this.GCRES = (force_clearRes = false, delete_ratio = 0.1) => {
            for (let res_name in _res_name_reference_count_dic_) {
                if (!_res_name_reference_count_dic_[res_name]) {
                    _delete_list.push(res_name)
                }
            }
            if (force_clearRes)
            {
                let bitmap_font_name_references = this.bitmap_font_name_references
                for (let bitmapFont_name in bitmap_font_name_references) {
                    if (bitmap_font_name_references[bitmapFont_name] <= 0) {
                        local_Laya.Text.unregisterBitmapFont(bitmapFont_name)
                        delete bitmap_font_name_references[bitmapFont_name]
                        local_Laya.loader.clearRes(local_GameResPath.GetFont(bitmapFont_name))
                        local_Laya.loader.clearRes(local_GameResPath.GetFont(bitmapFont_name).replace(".fnt", ".png"))
                    }
                }
                this.DestoryResOnFrame(delete_ratio, force_clearRes)
            }
        };
        //真正派发GAME_START事件
        this.TriggerGameStart = async () => {
            this.true_game_start = true;
            let SceneManager = window["SceneManager"]
            SceneManager.GetInstance().can_receive_scene_protocal = true;
            let scene = window["Scene"]
            if(scene)
            {
                scene.GetInstance().ResetMainRoleInfo()
            }
            // this.GCRES(true);
            GlobalEventSystem.Fire(EventName.GAME_START);
            // local_BaseController.is_delay_send_protocal = false;
            // Message.show("------GAME_START------")
            let role_mgr = window["RoleManager"].GetInstance()
            role_mgr.GetMainRoleVo().CacheHandle();
            GlobalEventSystem.Fire(EventName.INIT_MAINUI_EVENT)

            //重连重置静态缓存池对象
            this.ResetStaticSprite3DUrlDic()

        };
        //设置加载最大线程
        this.SetMaxLoadingThread = (count) => {
            local_laya.loader.maxLoader = count;
        };
        //预加载必须模块资源
        this.PreloadNecessaryModuleRes = async () => {
            // await _res_.loadGroup("preload", 1);
            if (window["engine_version"]) {
                ResVersionManager.engine_version = window["engine_version"];
                ResVersionManager.main_version = window["main_version"];
                ResVersionManager.hot_update_version = window["hot_update_version"];
                ResVersionManager.resource_version = window["resource_version"];
                ResVersionManager.js_version = window["js_version"];
                ResVersionManager.uiconfig_version = window["uiconfig_version"];
            }
            else {
                await ResVersionManager.GetInstance().LoadGameManulVersionConfig();
            }
        };
        /**预加载登录前需要的配置 */
        this.PreloadLoginConfig = async () =>{
            if (Util.IsDebug()) {
                
            }
            else {
                // console.warn("------PreloadLoginConfig Start-----")
                if(window["ServerModel"].GetInstance().IsLocationMode()){
                    let url = this.cdn_res_path + GameResPath.GetClientConfigPath("ConfigLocationInfo") + "?v=" + Math.random();
                    await new Promise<void>((resolve, reject) => { 
                        this.GetResByUrl(this.hashCode, url, (cfg) => {
                            window["ServerModel"].GetInstance().location_info_cfg = cfg;
                            // console.warn("------LoadVersionConfig End-----")
                            resolve()
                    }, this, Laya.Loader.JSON);
                    })
                }
            }
            
        }
        //预加载公共资源
        this.PreloadCommonRes = () => {
            let self = this
            //长持公共图集
            _res_name_reference_count_dic_[`${self.cdn_res_path}resource/game/common/texture.atlas`] = 10000;
            _res_name_reference_count_dic_[`${self.cdn_res_path}resource/game/common2/texture.atlas`] = 10000;
            _res_name_reference_count_dic_[`${self.cdn_res_path}resource/game/common4/texture.atlas`] = 10000;
            _res_name_reference_count_dic_[`${self.cdn_res_path}resource/game/sysInfo/texture.atlas`] = 10000;
            _res_name_reference_count_dic_[`${self.cdn_res_path}resource/game/uiComponent/texture.atlas`] = 10000;
            _res_name_reference_count_dic_[`${self.cdn_res_path}resource/game/icon/texture.atlas`] = 10000;
            _res_name_reference_count_dic_[`${self.cdn_res_path}resource/game/mainUI/texture.atlas`] = 10000;
            _res_name_reference_count_dic_[`${self.cdn_res_path}resource/game/emoji/texture.atlas`] = 10000;
            _res_name_reference_count_dic_[`${self.cdn_res_path}resource/game/dungeonCommon/texture.atlas`] = 10000;

            //持有alert的资源，避免断线的时候缓存没有，导致下载资源失败，显示不出来断线重连的弹窗
            let alert_bg_url = `${self.cdn_res_path}resource/game/alert/other/uisy_023.png`
            let prefix = ".json"
            if(local_Util.IsDebug())
            {
                prefix = ".scene"
            }
            local_laya.loader.load(`${self.cdn_res_path}resource/game/alert/texture/checkbox.png`, null, null, local_laya.Loader.IMAGE, 1, true, null, false, self._useWorkerLoader)
            local_laya.loader.load(alert_bg_url, null, null, local_laya.Loader.IMAGE, 1, true, null, false, self._useWorkerLoader)
            local_laya.loader.load(`${self.cdn_res_path}resource/game/alert/AlertTypeOne${prefix}`, null, null, local_laya.Loader.JSON, 1, true, null, false, self._useWorkerLoader)
            local_laya.loader.load(`${self.cdn_res_path}resource/game/alert/AlertTypeTwo${prefix}`, null, null, local_laya.Loader.JSON, 1, true, null, false, self._useWorkerLoader)
            _res_name_reference_count_dic_[`${self.cdn_res_path}resource/game/alert/texture.atlas`] = 10000
            _res_name_reference_count_dic_[alert_bg_url] = 10000
            _res_name_reference_count_dic_[`${self.cdn_res_path}resource/game/alert/AlertTypeOne${prefix}`] = 10000
            _res_name_reference_count_dic_[`${self.cdn_res_path}resource/game/alert/AlertTypeTwo${prefix}`] = 10000


            let createRole_cfg, modelAni_cfg
            let allLoaded = () => {
                if (createRole_cfg && modelAni_cfg) {
                    let create_cfg = createRole_cfg.CreateRole
                    let ui_cfg = create_cfg.UI
                    for (let i = 0; i < ui_cfg.length; i++) {
                        let ui_cfg_info = ui_cfg[i]
                        let key = `${ui_cfg_info.career}@${ui_cfg_info.sex}`
                        let res = create_cfg.Res[key]
                        if (res) {
                            let head_wear_id = res.head_res
                            let local_headWear_abName = local_GameResPath.GetHeadRes(null, head_wear_id)
                            let load_call_back = (obj) => {
                                if (local_Util.IsNull(obj)) {
                                    console.warn("preload default HeadWearRes cannot find headWear res = " + head_wear_id)
                                    return
                                }
                                this.default_head_objs[ui_cfg_info.career] = obj
                            }
                            if (local_headWear_abName) {
                                let params = {
                                    module: "head"
                                }
                                this.default_head_objs[ui_cfg_info.career] = false
                                let full_url = local_GameResPath.GetObjectPath("head", local_headWear_abName);
                                full_url += GetParams(params)
                                ResManager.GetInstance().CreatePrefab(self.hashCode, full_url, load_call_back, local_LOAD_QUEUE.HIGHT, true)
                            }
                        }
                    }
                }

            }
            self.LoadGameConfig(self, "ConfigLogin", true, local_LOAD_QUEUE.HIGHT, (cfg) => {
                createRole_cfg = cfg
                allLoaded()
            })

            self.LoadGameConfig(self, "ConfigModelAni", true, local_LOAD_QUEUE.HIGHT, (cfg) => {
                Config.PRELOAD_CLIENT_CONFIG.ConfigModelAni = cfg
                modelAni_cfg = cfg
                allLoaded()
            })
        };
        this.LoadJs = async (module_name: string, need_init_controller_name: string = null) => {
            if (module_name) {
                let config_loaded_dic = _is_jsmodule_loaded_dic_;
                if (config_loaded_dic[module_name] == null) {
                    let resolve_callback;
                    config_loaded_dic[module_name] = new Promise((resolve, reject) => {
                        resolve_callback = resolve;
                    });
                    let url = `${this.cdn_res_path}js/${module_name}.js?v=${ResVersionManager.js_version}`;
                    // }
                    local_Util.LoadScript(url, () => {
                        if (need_init_controller_name) {
                            window[need_init_controller_name].GetInstance();
                        }
                        resolve_callback();
                    });
                    await config_loaded_dic[module_name];
                    config_loaded_dic[module_name] = true;
                }
                else {
                    let value = config_loaded_dic[module_name];
                    if (value != true) {
                        await config_loaded_dic[module_name];
                    }
                }
            }
        };
        this.IsJsLoad = (module_name: string): boolean => {
            return _is_jsmodule_loaded_dic_[module_name] == true;
        };

        //添加引用
        //ref_tar调试的时候 方便找资源引用的持有者
        this.AddReferenceCount = (hash_code: number, res_name: string, ref_tar?: IBaseClass) => {
            if (!hash_code || !res_name)
                return false;
            let res_info = _res_name_to_hash_code_dic_[res_name], hash_info = _hash_code_to_res_name_dic_[hash_code];
            if (!hash_info) {
                hash_info = {};
                if (ref_tar) {
                    hash_info[res_name] = ref_tar;
                }
                else {
                    hash_info[res_name] = true;
                }
                _hash_code_to_res_name_dic_[hash_code] = hash_info;
            }
            else {
                if (!hash_info[res_name]) {
                    if (ref_tar) {
                        hash_info[res_name] = ref_tar;
                    }
                    else {
                        hash_info[res_name] = true;
                    }
                }
            }
            if (!_res_name_reference_count_dic_[res_name]) {
                _res_name_reference_count_dic_[res_name] = 0;
            }
            // let need_load_group = _res_name_reference_count_dic_[res_name] <= 0
            if (!res_info) {
                res_info = {};
                res_info[hash_code] = true;
                _res_name_to_hash_code_dic_[res_name] = res_info;
                ++_res_name_reference_count_dic_[res_name];
            }
            else {
                if (!res_info[hash_code]) {
                    res_info[hash_code] = true;
                    ++_res_name_reference_count_dic_[res_name];
                }
            }
            // return need_load_group
        };

        /**
         * @param hash_code 需要持有该组资源引用的对象哈希值
         * @param group_name 需要销毁的分组名字
         * @param destroy_imm 是否立即销毁 默认false
         */
        this.ReduceReferenceCount = (hash_code: number, group_name: string, destroy_imm: Boolean = true) => {
            if (!hash_code || !group_name)
                return;
            let group_info = _res_name_to_hash_code_dic_[group_name], hash_info = _hash_code_to_res_name_dic_[hash_code];
            if (hash_info && hash_info[group_name]) {
                delete hash_info[group_name];
            }
            if (group_info && group_info[hash_code]) {
                delete group_info[hash_code];
                --_res_name_reference_count_dic_[group_name];
                if (_res_name_reference_count_dic_[group_name] <= 0) {
                    //  if(destroy_imm)
                    //  {
                    //     this.DestroyRes(group_name, true)
                    //  }else
                    //  {
                    _res_name_reference_count_dic_[group_name] = 0;
                    //  }
                }
            }
        };
        this.DestroyRes = (res_name: string, force_clearRes: boolean = false) => {
            // console.log("----------------try to DestroyRes name = ", res_name)
            // if (this.GetRes(res_name)) {
            if (force_clearRes) {
                let delete_url: string
                if (this.backup_res_dic[res_name]) {
                    delete this.backup_res_dic[res_name];
                    delete_url = this.NormalCdnToBackUpCdn(res_name);
                    // delete_url = this.ParseRuntime2Url(delete_url);
                }
                else {
                    delete_url = res_name;
                    // delete_url = this.ParseRuntime2Url(delete_url);
                }
                //资源暂时不销毁 会卡
                let is_atlas_tex = delete_url.indexOf(".png") > 0 && delete_url.indexOf("/texture/") > 0 //图集
                if (!is_atlas_tex)//不在图集中的才能被销毁
                {
                    // console.log("----------------realy DestroyRes name = ", res_name)
                    local_laya.loader.clearRes(delete_url)
                }
            }
            delete _res_name_reference_count_dic_[res_name];
            delete this._url_loaded_flag[res_name];
            delete _url_loading_callback_args_[res_name];
            delete this._config_name_reference_count_dic[res_name];
            // }
        };


        this.DestoryResOnFrame = (delete_ratio, force_clearRes) => {
            delete_ratio = delete_ratio || 0.1
            let total_delete_length = _delete_list.length
            let delete_size = total_delete_length < 100 ? total_delete_length : Math.ceil(total_delete_length * delete_ratio)
            let delete_res
            if (delete_size > 0) {
                for (let i = 0; i < delete_size; i++) {
                    delete_res = _delete_list.shift()
                    if (delete_res && !_res_name_reference_count_dic_[delete_res]) {
                        this.DestroyRes(delete_res, force_clearRes)
                    }
                }
            }
        }
        /**
         * 删除该对象所引用的所有资源 包括配置
         * @param hash_code 该对象的哈希值
         * @param destroy_imm 是否立即销毁 默认false
         */
        this.DestroyAllReferenceRes = (hash_code: number, destroy_imm: Boolean = false) => {
            let hash_info = _hash_code_to_res_name_dic_[hash_code];
            if (hash_info) {
                for (let res_name in hash_info) {
                    if (hash_info[res_name]) {
                        this.ReduceReferenceCount(hash_code, res_name, destroy_imm);
                    }
                }
            }
            this.ClearRoleMode(hash_code);
            this.ClearBitmapFont(hash_code);
        };
        //获取资源被持有的引用数量
        this.GetResReferenceCount = (res_name: string) => {
            return _res_name_reference_count_dic_[res_name];
        };
        //普通正式服cdn路径转成备份cdn路径
        this.NormalCdnToBackUpCdn = (url: string) => {
            let BackUpUrl = ClientConfig && ClientConfig.BackUpUrl;
            if (!BackUpUrl) {
                BackUpUrl = url;
            }
            else {
                let data_path = this.cdn_res_path;
                if (data_path && url.indexOf(data_path) >= 0) {
                    BackUpUrl = url.replace(data_path, BackUpUrl);
                }
                else {
                    BackUpUrl = BackUpUrl + url;
                }
            }
            return BackUpUrl;
        };
        //加载资源成功回调
        this.LoadResByUrlComplete = (url: string, callback_imm) => {
            if (!callback_imm) {
                this.loaded_2d_callbacks.push(url)
            }
            else {
                this.Load2dCallback(url)
            }
        };
        /**
         * @param hash_code 需要持有该组资源引用的对象哈希值
         * @param url 要加载文件的外部路径
         * @param compFunc 回调函数。示例：compFunc(data,url):void。
         * @param thisObject 回调函数的 this 引用。
         * @param type 文件类型(可选)。请使用 ResourceItem 类中定义的静态常量。若不设置将根据文件扩展名生成。
         * @param load_queue 加载队列 高中低级
         * @param from_queue 是否从等待队列中添加   弃用
         * @param ref_tar 调试的时候 方便找资源引用的持有者
         * @param callback_imm 是否加载完立刻回调，false的话就加进去回调队列里面 逐帧加载
         */
        this.GetResByUrl = (hash_code: number, url: string, compFunc?: Function, thisObject?: any, type?: string, load_queue: LOAD_QUEUE = local_LOAD_QUEUE.LOW, from_queue = false, ref_tar?: IBaseClass, callback_imm = true, ...args) => {
            if (load_queue == null)
                load_queue = local_LOAD_QUEUE.LOW
            if (this.cdn_res_path && url.indexOf(this.cdn_res_path) == -1) {
                url = this.cdn_res_path + url;
            }
            this.AddReferenceCount(hash_code, url, ref_tar || thisObject);
            if (this._url_loaded_flag[url] == null) {
                this._url_loaded_flag[url] = false;
                // console.warn("load url = ", url)
                _url_loading_callback_args_[url] = { compFunc: compFunc, thisObject: thisObject, args: args, type: type };
                let real_url = url;
                // real_url = this.ParseRuntime2Url(real_url);
                local_laya.loader.load(real_url, local_laya.Handler.create(this, this.LoadResByUrlComplete, [real_url, callback_imm]), null, type, load_queue, true, null, false, this._useWorkerLoader)
            }
            else if (this._url_loaded_flag[url] == false) { //以后改成在update里定时判断全部
                if (!_url_loading_timer_callback_list_[url]) {
                    _url_loading_timer_callback_list_[url] = [];
                }
                _url_loading_timer_callback_list_[url].push({ compFunc: compFunc, args: args, thisObject: thisObject });
            }
            else if (this._url_loaded_flag[url] == true) {
                if (compFunc) {
                    let cfg = this.GetRes(url)
                    if (!cfg) {
                        console.warn("_url_loaded_flag is true, but get res is null", url)
                    }
                    compFunc.call(thisObject, cfg, ...args);
                }
            }
        };
        //获得资源
        this.GetRes = (url: string) => {
            // let real_url = this.ParseRuntime2Url(url);
            // console.warn("-----------real_url-------------", real_url)
            let res = local_laya.loader.getRes(url);
            if (!res) {
                res = this.backup_res_dic[url];
            }
            return res;
        };

        this.LoadDebugIpList = async () => {
            //ConfigDebugIpList比较特殊 正式服外网要把数据置空
            let LoginModel = window["LoginModel"]
            if (LoginModel.GetInstance().plat_name) {
                LoginModel.ConfigDebugIpList = { "ip_list": [] };
            }
            else {
                if (HttpUtil.game_url && HttpUtil.game_url.indexOf("shenhaitest") > 0)//深海测试服写死
                {
                    LoginModel.ConfigDebugIpList = { "ip_list": ["深海外网测试服:110.42.197.138:9000"] };
                    return
                }
                let url = "resource/game/login/ConfigDebugIpList.json?v=" + Math.random();
                await new Promise<void>((resolve, reject) => {
                    this.GetResByUrl(this.hashCode, url, (obj) => {
                        LoginModel.ConfigDebugIpList = obj;
                        resolve();
                    }, this, local_Laya.Loader.JSON, local_LOAD_QUEUE.HIGHT);
                });
            }
        };
        //初始化所有配置
        this.LoadConfigZip = async () => {
            let config = local_Config;
            let url = "resource/config.zip";
            if (local_Util.IsDebug()) {
                url = "resource/local_config.zip";
            }
            await new Promise<void>((resolve, reject) => {
                this.GetResByUrl(this.hashCode, url, (data) => {
                    var zip = new JSZip();
                    _all_config_zip_ = zip.load(data, null);
                    this.ReduceReferenceCount(this.hashCode, this.cdn_res_path + url, true);
                    resolve();
                }, this, local_Laya.Loader.BUFFER, local_LOAD_QUEUE.HIGHT);
            });
        };

        //加载ui布局文件和图集文件zip
        this.LoadUIConfigZip = async () => {
            if (local_Util.IsDebug()) {
                return
            }
            let url = "resource/UIConfig.zip";
            // if(!local_Util.IsConch())
            // {
                url = url + "?v=" + ResVersionManager.uiconfig_version;
            // }
            await new Promise<void>((resolve, reject) => {
                this.GetResByUrl(this.hashCode, url, (data) => {
                    var zip = new JSZip();
                    _all_uiconfig_zip_ = zip.load(data, null);
                    let obj_url = "UIConfig.json"
                    let jsz_obj = _all_uiconfig_zip_.file(obj_url);
                    _all_uiconfig_zip_.remove(obj_url);
                    _all_uiconfig_zip_ = null
                    if (jsz_obj) {
                        let txt = jsz_obj["asText"]();
                        if (txt) {
                            this.all_uiconfig_config = JSON.parse(txt);
                            local_Laya.Loader["all_uiconfig_config"] = this.all_uiconfig_config
                        }
                    }
                    this.ReduceReferenceCount(this.hashCode, this.cdn_res_path + url, true);
                    resolve();
                }, this, local_Laya.Loader.BUFFER, local_LOAD_QUEUE.HIGHT);
            });
        };

        this.PreLoadConfigFormZip = () => {
            let obj_url = "config.json"
            if (local_Util.IsDebug())
                obj_url = "local_config.json"
            let jsz_obj = _all_config_zip_.file(obj_url), cfg_obj;
            _all_config_zip_.remove(obj_url);
            _all_config_zip_ = null
            if (jsz_obj) {
                let txt = jsz_obj["asText"]();
                if (txt) {
                    cfg_obj = JSON.parse(txt);
                    // _all_config_dic_[url] = cfg_obj
                }
            }
            for (let config_name in local_Config.PRELOAD_CLIENT_CONFIG) {
                local_Config.PRELOAD_CLIENT_CONFIG[config_name] = cfg_obj[config_name];
            }
            for (let config_name in local_Config.PRELOAD_SERVER_CONFIG) {
                local_Config.PRELOAD_SERVER_CONFIG[config_name] = cfg_obj[config_name];
            }
        };
        this.LoadProtocalConfigZip = async () => {
            let config = local_Config;
            if (!config.load_protocal_config_promise) {
                let load_protocal_config_resolve;
                config.load_protocal_config_promise = new Promise<void>((resolve, reject) => {
                    load_protocal_config_resolve = resolve;
                });
                if (local_Util.IsDebug()) {
                    await this.LoadGameConfig(this, "ClientProtocol", true, local_LOAD_QUEUE.HIGHT);
                    UserMsgAdapter.GetInstance().ClientProtocol = this.GetGameConfigFromCache(this, "ClientProtocol", true);
                    load_protocal_config_resolve();
                }
                else {
                    let url = "resource/config/client/ClientProtocol.zip";
                    // url += "?v=123" + ResVersionManager.GetInstance().ParseUrlByVersion(url);
                    await new Promise<void>((resolve, reject) => {
                        this.GetResByUrl(this.hashCode, url, (data) => {
                            var zip = new JSZip();
                            var protocal_config_zip = zip.load(data, null);
                            var jsz_obj = protocal_config_zip.file("ClientProtocol.json");
                            protocal_config_zip.remove("ClientProtocol.json");
                            protocal_config_zip = null
                            if (jsz_obj) {
                                let txt = jsz_obj["asText"]();
                                if (txt) {
                                    UserMsgAdapter.GetInstance().ClientProtocol = JSON.parse(txt);
                                }
                            }
                            resolve();
                            this.ReduceReferenceCount(this.hashCode, this.cdn_res_path + url, true);
                        }, this, local_Laya.Loader.BUFFER, local_LOAD_QUEUE.HIGHT);
                    });
                    load_protocal_config_resolve();
                }
            }
        };
    }

    public static GetInstance(): ResManager {
        if (ResManager._instance == null) {
            ResManager._instance = new ResManager();
        }
        return ResManager._instance;
    }

    //SetTexture 加载成功回调
    public LoadTextureComplete = (texture: Laya.Texture, base_class: IBaseClass, image: Laya.Image, url: string, callback?: Function, thisObject?: any, setNative: boolean = false) => {
        if (!base_class.use_delete_method) {
            // if (this.cdn_res_path && url.indexOf(this.cdn_res_path) == -1) {
            //     url = this.cdn_res_path + url;
            // }
            if (image["sy_img_url"] != url) return
            image.source = texture//this.GetRes(url)// Laya.loader.getRes(url);
            if (image && !image.destroyed) {
                if (setNative && texture) {
                    image.width = texture.sourceWidth;
                    image.height = texture.sourceHeight;
                }
                if (callback) {
                    callback.call(thisObject, image.source, url);
                }
            } else {
                console.warn("--------LoadTextureComplete image is null ------url = ", url)
            }
        }
    };

    /**
     * 设置图片数据 加载散图片的时候用 自己模块的资源直接赋值skin
     * */
    public SetTexture = (base_class: IBaseClass, image: Laya.Image, url: string, callback?: Function, thisObject?: any, setNative: boolean = false, load_queue: LOAD_QUEUE = local_LOAD_QUEUE.MIDDLE, callback_imm = true, is_ktx = false) => {
        if (!base_class || base_class.use_delete_method || !image || !url) {
            return null;
        }

        if (url.indexOf("/texture/") != -1) {
            url = url.replace("texture", "other")
        } else if (url.indexOf('/bigBg/') != -1) {
            is_ktx = true;
        }



        if (is_ktx && local_Util.use_ktx) {
            callback_imm = callback_imm == null ? true : callback_imm
            url = url.substring(0, url.lastIndexOf(".")) + ".ktx"
        }
        image["sy_img_url"] = url
        load_queue = load_queue || local_LOAD_QUEUE.MIDDLE
        this.GetResByUrl(base_class.hashCode, url, this.LoadTextureComplete, thisObject, Laya.Loader.IMAGE, load_queue, false, base_class, callback_imm, base_class, image, url, callback, thisObject, setNative);
    };

    /**
     * 设置图片数据 加载散图片的时候用 自己模块的资源直接赋值skin
     * 为了兼容settexture的参数 另外包了一层  移植后遗症
     * */
    public SetOutsideImageSprite(ref_tar, image, respath: string, setNativeSize?, call_back?) {
        this.SetTexture(ref_tar, image, respath, call_back, undefined, setNativeSize)
    }

    /**
    * 加载图集中的子图片
    * 为了兼容lua代码 另外包了一层  移植后遗症
    * */
    public SetImageSprite = (ref_tar, image, abName: string, resName, setNativeSize?, call_back?, load_level?, not_insert?) => {
        if (abName.indexOf("_") > 0) {
            abName = abName.substring(0, abName.lastIndexOf("_"))
        }
        image.skin = `resource/game/${abName}/texture/${resName}.png`
    }

    /**
     * 加载图集中的子图片
     * 有些地方调用SetOutsideImageSprite方法，把图集中的子图片当作散图片给加载了，
     * 为了方便修改，就直接写了该方法替换掉SetOutsideImageSprite，然后直接调用skin加载图集的子图片
     * */
    public SetImageSpriteTrans(ref_tar, image: Laya.Image, respath: string, setNativeSize?, call_back?) {


        if (setNativeSize) {
            //可能会用到其他模块的图集文件
            image.loadImage(respath, local_Laya.Handler.create(image, () => {
                if (!image.destroyed && image.texture) {
                    image.width = image.texture.width
                    image.height = image.texture.height
                    image["onCompResize"]()
                    if (call_back) call_back()
                }
            }))

        } else {
            image.skin = respath
            if (call_back) call_back()
        }

    }
    /**
     * 加载fnt文件
     * */
    public LoadFont = (base_class: IBaseClass, font_name: string, label: Laya.Label, font_size: number = 24, autoScaleSize = true, callback?: Function) => {
        if (!base_class || base_class.use_delete_method || !font_name || font_name == "" || label.destroyed)
            return null;
        let bitmapFont = new local_Laya.BitmapFont();
        this.bitmap_font_objs[base_class.hashCode] = this.bitmap_font_objs[base_class.hashCode] || {}
        this.bitmap_font_objs[base_class.hashCode][GetTargetHashcode(bitmapFont)] = font_name

        this.bitmap_font_name_references[font_name] = this.bitmap_font_name_references[font_name] || 0
        this.bitmap_font_name_references[font_name]++
        // if (font_size) {
        //     label.fontSize = font_size
        // }
        let hander = local_Laya.Handler.create(this, () => {
            if (base_class.use_delete_method) {
                if (!this.bitmap_font_name_references[font_name])
                    bitmapFont.destroy()
                return
            }
            bitmapFont.autoScaleSize = autoScaleSize
            if (font_size) {
                bitmapFont.fontSize = font_size
            }
            local_Laya.Text.registerBitmapFont(font_name, bitmapFont);
            if (label && !label.destroyed) {
                label.font = font_name
            }
            if (callback) {
                callback()
            }
        })
        bitmapFont.loadFont(local_GameResPath.GetFont(font_name), hander);
    };

    /**
     * 添加游戏对象进入缓存池 通过loadPrefab加载的资源对象
     * @param hashCode 
     * @param url 资源路径
     * @param sprite 精灵对象
     * @returns 
     */
    public AddSprite3DToPool(hashCode, res_url, sprite_3d: Laya.Sprite3D) {
        if(local_Util.IsNull(sprite_3d)) return

        if (!hashCode || !res_url) {
            sprite_3d.destroy()
            return
        }

        //静态缓存对象(只存一个)
        if (this.static_sprite_3d_name_dic[res_url] && !this.static_sprite_3d_dic[res_url]) {
            // if (!this.static_con_sprite_3d) {
            //     this.static_con_sprite_3d = new Laya.Sprite3D()
            //     this.static_con_sprite_3d.active = false
            // }
            sprite_3d.parent && sprite_3d.parent.removeChild(sprite_3d);
            this.static_sprite_3d_dic[res_url] = sprite_3d
            // this.static_con_sprite_3d.addChild(sprite_3d)

            let full_url = this.cdn_res_path + res_url
            //添加缓存引用计数
            this.AddReferenceCount(this.static_sprite_hash_code, full_url)
            //放入缓存后减少引用计数
            this.ReduceReferenceCount(hashCode, full_url)
            
        } else {
            this.CreateSprite3DPool(res_url)
            let res_info = this.sprite_3d_pool_dic[res_url]
            if (res_info.res_list.length > this.GetMaxChildPoolSprite3DCount()) {
                //大于限制的相同对象缓存数量，不放入缓存
                sprite_3d.destroy()
            } else {
                
                // res_info.container.addChild(sprite_3d)
                sprite_3d.parent && sprite_3d.parent.removeChild(sprite_3d);
                res_info.res_list.push(sprite_3d)
                // res_info.last_change_time = Status.NowTime

                let full_url = this.cdn_res_path + res_url
                //添加缓存引用计数
                this.AddReferenceCount(res_info.hash_code, full_url)
                //放入缓存后减少引用计数
                this.ReduceReferenceCount(hashCode, full_url)
            }
        }
    }

    /**
     * 重置静态缓存池对象
     */
    public ResetStaticSprite3DUrlDic() {
        this.static_sprite_3d_name_dic = {}
        this.static_sprite_3d_dic = {}
        // if (this.static_con_sprite_3d) {
        //     this.static_con_sprite_3d.destroy()
        //     this.static_con_sprite_3d = undefined
        // }
        this.DestroyAllReferenceRes(this.static_sprite_hash_code)

        let main_role_vo = RoleManager.GetInstance().GetMainRoleVo()
        let SkillManager = window["SkillManager"]
        //缓存主角技能
        let pre_load_skill_id_list = [],
            common_list = SkillManager.BaseAttackSkills[`${main_role_vo.career}@${main_role_vo.sex}`],
            career_cfg = Config.PRELOAD_CLIENT_CONFIG.ConfigSkillUI.carrerSkillList[main_role_vo.career]

        if (common_list) {
            for (let skill_id of common_list) {
                pre_load_skill_id_list.push(skill_id)
            }
        }

        if (career_cfg) {
            for (let vo of career_cfg) {
                if (!vo.common) {
                    pre_load_skill_id_list.push(vo.skill_id)
                }
            }
        }

        let movie_cfg
        for (let skill_id of pre_load_skill_id_list) {
            movie_cfg = SkillManager.GetInstance().GetFightSkillMovie(skill_id)
            if (movie_cfg.particles) {
                for (let vo of movie_cfg.particles) {
                    this.AddStaticSprite3DUrl(local_GameResPath.GetEffectPath(EffectResType.Skill, vo.res))
                }
            }
        }

        //升级特效
        let res_url = local_GameResPath.GetEffectPath(EffectResType.Other, "effect_xemlvup")
        this.AddStaticSprite3DUrl(res_url)


        //主角当前模型资源
        //角色模型
        let [fashion_model_id, fashion_chartlet_id] = main_role_vo.GetRoleClotheTextureId()
        let res_name = local_GameResPath.GetModelClotheRes(SceneBaseType.MainRole, fashion_model_id)
        let full_url = local_GameResPath.GetTypePath(SceneBaseType.MainRole, res_name)
        let params = {
            module: local_GameResPath.GetTypeModuleName(SceneBaseType.MainRole),
            name: "Scene",
            id: window["SceneManager"].GetInstance().GetSceneId(),
        }
        full_url += GetParams(params)
        this.AddStaticSprite3DUrl(full_url)
    }

    public AddStaticSprite3DUrl(res_url) {
        this.static_sprite_3d_name_dic[res_url] = true
    }

    /**
     * 创建缓存池
     * @param res_url 
     */
    public CreateSprite3DPool(res_url) {


        if (!this.sprite_3d_pool_dic[res_url]) {

            ++this.sprite_3d_pool_res_count
            this.sprite_3d_pool_dic[res_url] = {
                hash_code: HashObject.CreateHashcode(),
                res_url: res_url,
                // last_change_time: Status.NowTime,
                // container: container,
                res_list: []
            }
        }
    }


    /**
     * 判断sp是否存在缓存池中
     * @param hash_code 
     * @param res_url 
     * @returns 
     */
    public CheckSpIsInPool(sp, res_url) {
        if (this.static_sprite_3d_dic[res_url] == sp) {
            return true
        }
        let res_info = this.sprite_3d_pool_dic[res_url]
        if (res_info && res_info.res_list) {
            return res_info.res_list.indexOf(sp) >= 0
        }
    }

    /**
     * 从缓存池中获取游戏对象
     * @param hash_code 
     * @param res_url 
     * @returns 
     */
    public GetSprite3DFormPool(hash_code, res_url) {
        if (!hash_code || !res_url) {
            return
        }
        let sprite_3d
        if (this.static_sprite_3d_name_dic[res_url]) {
            sprite_3d = this.static_sprite_3d_dic[res_url]
            if (sprite_3d) {
                delete this.static_sprite_3d_dic[res_url]
                let full_url = this.cdn_res_path + res_url
                this.AddReferenceCount(hash_code, full_url)
                this.ReduceReferenceCount(this.static_sprite_hash_code, full_url)
                ResetSkinnedMeshSprite3D(sprite_3d)
            }
        }
        if (!sprite_3d) {
            let res_info = this.sprite_3d_pool_dic[res_url]
            if (res_info && res_info.res_list) {
                sprite_3d = res_info.res_list.pop()
                if (sprite_3d) {
                    // res_info.last_change_time = Status.NowTime

                    let full_url = this.cdn_res_path + res_url
                    this.AddReferenceCount(hash_code, full_url)
                    this.ReduceReferenceCount(res_info.hash_code, full_url)
                    ResetSkinnedMeshSprite3D(sprite_3d)
                }
            }
        }
        if (sprite_3d) {
            if (sprite_3d.destroyed) {
                let full_url = this.cdn_res_path + res_url
                this.ReduceReferenceCount(hash_code, full_url)
                return null
            } else {
                sprite_3d.active = true
            }
        }
        return sprite_3d
    }

    /**
     * 清除所有缓存池游戏对象，切换场景时调用
     */
    public ClearAllSprite3DPool() {
        if (this.sprite_3d_pool_dic) {
            let res_info
            let res_list
            for (let res_url in this.sprite_3d_pool_dic) {
                res_info = this.sprite_3d_pool_dic[res_url]
                res_list = res_info.res_list
                if(res_list)
                {
                    for(let j = 0; j < res_list.length; j ++)
                    {
                        res_list[j].destroy()
                    }
                }
                this.DestroyAllReferenceRes(res_info.hash_code)
                // res_info.container.destroy()
                delete this.sprite_3d_pool_dic[res_url]
                --this.sprite_3d_pool_res_count
            }
            // this.pool_con_sprite_3d.destroy()
            // this.pool_con_sprite_3d = undefined
        }
        this.sprite_3d_pool_dic = {}
        this.sprite_3d_pool_res_count = 0
    }

    /**
     * 获得最大的缓存类型数量
     * @returns 
     */
    public GetMaxPoolObjCount(): number {

        // if (IsLowSystemState && IsIosSystem) {
        //     return 10
        // } else {
        //     if (IsIosSystem) {
        //         return 50
        //     } else {
        //         return 100
        //     }
        // }
        return 50
    }


    /**
     * 获得最大的缓存资源数量
     * @returns 
     */
    public GetMaxChildPoolSprite3DCount(): number {

        // if (IsLowSystemState && IsIosSystem) {
        //     return 3
        // } else {
        //     if (IsIosSystem) {
        //         return 10
        //     } else {
        //         return 18
        //     }
        // }
        return 2
    }

    /**
     * 从缓存中获取游戏配置   如果确保该配置已经加载到了内存中，就使用该接口来获取，因为用LoadGameConfig会使用Promise，导致逻辑要处理异步操作
     * @param base_class 实现IbaseClass的对象
     * @param cfg    配置文件名
     * @param is_client_cfg 是否客户端配置 默认是
     */
    public GetGameConfigFromCache = (base_class: IBaseClass, cfg: string, is_client_cfg: boolean = true) => {
        if (!base_class || base_class.use_delete_method || !cfg || cfg == "")
            return null;
        let res_obj = Config.PRELOAD_CLIENT_CONFIG[cfg];
        if (res_obj) {
            return res_obj;
        }
        else {
            res_obj = Config.PRELOAD_SERVER_CONFIG[cfg];
            if (res_obj) {
                return res_obj;
            }
        }
        let url = is_client_cfg ? local_GameResPath.GetClientConfigPath(cfg) : local_GameResPath.GetServerConfigPath(cfg);
        let full_url = this.cdn_res_path + url;
        if (this._url_loaded_flag[full_url] == true) {
            this.AddReferenceCount(base_class.hashCode, full_url, base_class);
            return this.GetRes(full_url);
        }
    };
    /**
     * 异步加载游戏配置，该配置会随着引用持有者的调用DeleteMe来一起销毁
     * @param base_class 实现IbaseClass的对象
     * @param cfg    配置文件名
     * @param is_client_cfg 是否客户端配置 默认是
     */
    public LoadGameConfig = async (base_class: IBaseClass, cfg: string, is_client_cfg: boolean = true, load_queue: LOAD_QUEUE = local_LOAD_QUEUE.HIGHT, load_call_back?): Promise<any> => {
        if (!base_class || base_class.use_delete_method || !cfg || cfg == "")
            return null;
        let full_url = this.GetConfigFullUrl(cfg, is_client_cfg)
        if (this._config_name_reference_count_dic[full_url] == null)
            this._config_name_reference_count_dic[full_url] = 0;
        ++this._config_name_reference_count_dic[full_url];
        let res_obj = Config.PRELOAD_CLIENT_CONFIG[cfg];
        if (!res_obj) {
            res_obj = Config.PRELOAD_SERVER_CONFIG[cfg];
        }
        if (!res_obj) {
            let url = is_client_cfg ? local_GameResPath.GetClientConfigPath(cfg) : local_GameResPath.GetServerConfigPath(cfg)
            if (this._url_loaded_flag[full_url] == true) {
                this.AddReferenceCount(base_class.hashCode, full_url, base_class);
                res_obj = this.GetRes(full_url);
            }
            else {
                // console.log("LoadGameConfig config_name = ", cfg);
                await new Promise<void>((resolve, reject) => {
                    this.GetResByUrl(base_class.hashCode, url, (obj) => { res_obj = obj; resolve(); }, this, local_Laya.Loader.JSON, load_queue);
                });
            }
            if (base_class.use_delete_method)
                return null;
        }
        if (load_call_back) {
            load_call_back(res_obj);
        }
        return res_obj;
    };
    //获取游戏配置  该配置会在获取完后自动销毁  注意：该配置外部不能持有，只能在回调函数使用一次
    public GetGameConfigWithAutoDestory = (config_name, call_back, is_client_cfg = true, load_queue: LOAD_QUEUE = local_LOAD_QUEUE.HIGHT) => {
        let url = is_client_cfg ? local_GameResPath.GetClientConfigPath(config_name) : local_GameResPath.GetServerConfigPath(config_name), full_url = this.cdn_res_path + url;
        let base_class = new BaseClass();
        let load_call_back = (obj) => {
            if (call_back) {
                call_back(obj);
            }
            this.ReduceReferenceCount(base_class.hashCode, full_url);
        };
        this.LoadGameConfig(base_class, config_name, is_client_cfg, load_queue, load_call_back);
    };
    /**
 * 主动销毁配置对象，如果在常驻内存的类中（通常是每个模块的Model）调用了LoadGameConfig，那么用完后就需要主动调用该函数来释放配置内存。
 * @param base_class 实现IbaseClass的对象
 * @param cfg    配置文件名
 * @param is_client_cfg 是否客户端配置 默认是
 */
    public DestoryGameConfig = (base_class: IBaseClass, cfg: string, is_client_cfg = true) => {
        let full_url = this.GetConfigFullUrl(cfg, is_client_cfg)
        if (this._config_name_reference_count_dic[full_url]) {
            --this._config_name_reference_count_dic[full_url];
            if (this._config_name_reference_count_dic[full_url] <= 0) {
                this._config_name_reference_count_dic[full_url] = 0;
                this.ReduceReferenceCount(base_class.hashCode, full_url);
            }
        } else {
            this.ReduceReferenceCount(base_class.hashCode, full_url);
        }
    };
    //获取配置的全路径
    public GetConfigFullUrl = (config_name, is_client_cfg = true) => {
        return this.cdn_res_path + (is_client_cfg ? local_GameResPath.GetClientConfigPath(config_name) : local_GameResPath.GetServerConfigPath(config_name))
    };

    //ui挂机模型最新的接口  horse_id 自由参数 通过type类型来确定其用途   ignore_param（为了保持旧接口的参数位置，暂用这个参数来确认是否为登录界面）
    /*
    ref_tar:必须是继承baseclass的对象
    parent:父容器
    career：职业
    sex:性别
    clothe_res_id：衣服模型id
    weapon_res_id：武器模型id
    weapon_clothe_id: 武器时装
    type：类型
    rotate:旋转度数
    action_name_list:动作集
    can_rotate:是否支持左右旋转 
    scale:缩放 
    position:位置
    fashion_model_id:时装模型id
    texture_id:时装贴图id
    action_delta:动作间隔
    horse_id,
    ignore_param,
    skill_id:技能id
    callBack:加载完成的回调，返回modelClass
    wing_id:翅膀id
    liveness_id,
    head_wear_id,
    head_clothe_id,
    layout_file:是否支持配置控制模型大小，位置，角度参数
    //*/
    //修改成table形式  只添需要的参数
    public SetRoleModel(ref_tar: BaseClass, parent: Laya.Sprite, data: any) {

        let ref_info = this.role_mode_list[ref_tar.hashCode] || {}
        let curr_roleModel = ref_info[GetTargetHashcode(parent)]
        if (curr_roleModel) {
            curr_roleModel.DeleteMe()
            delete ref_info[GetTargetHashcode(parent)]
        }

        let cfg = Config.PRELOAD_CLIENT_CONFIG.UIModelParameter

        if (cfg) {
            //没有指定单独界面参数 和没有自主传参数就用 全界面通用配置参数
            if (!data.layout_file) {
                data.scale = data.scale && data.scale || cfg.Defaut.scale
                data.position = data.position && data.position || cfg.Defaut.position
                data.rotate = data.rotate && data.rotate || cfg.Defaut.rotate
            } else {
                //指定资源id参数
                let specific_cfg = null;
                let resType: string = local_GameResPath.GetUITypeModuleName(data.type);
                if (cfg[data.layout_file] && cfg[data.layout_file][resType]) { // 指定类型
                    specific_cfg = cfg[data.layout_file][resType][data.clothe_res_id];
                } else {
                    specific_cfg = cfg[data.layout_file] && cfg[data.layout_file][data.clothe_res_id] && cfg[data.layout_file][data.clothe_res_id] || null;
                }

                //可能是时装
                if (!specific_cfg) {
                    specific_cfg = cfg[data.layout_file] && cfg[data.layout_file][data.fashion_model_id] && cfg[data.layout_file][data.fashion_model_id] || null
                    if (data.is_hair) {
                        specific_cfg = cfg[data.layout_file] && cfg[data.layout_file][data.head_wear_id] && cfg[data.layout_file][data.head_wear_id] || null
                    }
                }
                if (specific_cfg) {
                    data.scale = specific_cfg.scale || data.scale
                    data.position = specific_cfg.position || data.position
                    data.rotate = specific_cfg.rotate || data.rotate
                    data.action_name_list = specific_cfg && specific_cfg.action_name_list
                } else {
                    //界面统一参数配置
                    let part_cfg = cfg[data.layout_file] && cfg[data.layout_file] || null
                    data.scale = part_cfg && part_cfg.defaut.scale || data.scale
                    data.position = part_cfg && part_cfg.defaut.position || data.position
                    data.rotate = part_cfg && part_cfg.defaut.rotate || data.rotate
                    data.action_name_list = part_cfg && part_cfg.defaut.action_name_list || data.action_name_list
                }
            }
        }

        if (data.action_name_list) {
            data.action_name_list = local_Util.DeepCopy(data.action_name_list)
        }
        if (parent.numChildren > 0) {
            parent.removeChildren();
        }
        ref_info[GetTargetHashcode(parent)] = new window["UIModelClass3D"](parent, data)
        this.role_mode_list[ref_tar.hashCode] = ref_info
        return ref_info
    }
    //清除该对象的所有角色模型的引用
    public ClearRoleMode(hash_code: number) {

        let ref_count_obj = this.role_mode_list[hash_code]
        if (ref_count_obj) {
            for (let p in ref_count_obj) {
                var uiModelClass = ref_count_obj[p]
                uiModelClass.DeleteMe()
            }
            delete this.role_mode_list[hash_code]
        }
    }
    //清除该对象的所有位图对象的引用
    public ClearBitmapFont(hash_code: number) {
        let ref_count_obj = this.bitmap_font_objs[hash_code]
        if (ref_count_obj) {
            for (let p in ref_count_obj) {
                var bitmapFont_name = ref_count_obj[p]
                --this.bitmap_font_name_references[bitmapFont_name]
            }
            delete this.bitmap_font_objs[hash_code]
        }
    }
    /**
     *  加载ui布局文件
    * @param hash_code 需要持有该组资源引用的对象哈希值
    * @param url 要加载文件的外部路径
    * @param compFunc 回调函数。示例：compFunc(data,url):void。
    * @param thisObject 回调函数的 this 引用。
     */
    public LoadUILayoutFile(hash_code: number, base_file: string, layout_file: string, compFunc?: Function, thisObject?: any) {
        var real_url

        if (!local_Util.IsDebug()) {
            let config_name = `${base_file}/${layout_file}.json`
            real_url = `resource/game/${config_name}`
            if (this.all_uiconfig_config) {
                let ui_layout_obj = this.all_uiconfig_config[config_name]
                if (ui_layout_obj && !ui_layout_obj.has_cache) {
                    ui_layout_obj.has_cache = true
                    local_Laya.Loader.cacheRes(real_url, ui_layout_obj)
                }

                // config_name = `${base_file}/texture.atlas`
                // ui_layout_obj = this.all_uiconfig_config[config_name]
                // if(ui_layout_obj)
                // {
                //     let atlas_cache_url = local_Laya.URL.formatURL(`resource/game/${config_name}`);
                //     local_Laya.Loader["CACHE_ATLAS_OBJ"][atlas_cache_url] = ui_layout_obj
                // }
            }
        } else {
            real_url = `resource/game/${base_file}/${layout_file}.scene`
            this.AddReferenceCount(hash_code, this.cdn_res_path + real_url, thisObject);
        }
        this._url_loaded_flag[real_url] = false
        //加上加载图集的资源引用
        this.AddReferenceCount(hash_code, `${this.cdn_res_path}resource/game/${base_file}/texture.atlas`, thisObject);
        local_Laya.Scene.load(real_url, local_Laya.Handler.create(this, (view) => {
            this._url_loaded_flag[real_url] = true
            if (compFunc) {
                compFunc.call(thisObject, view)
            }
        }))
    }

    /**
   *  加载和创建3d预制体
  * @param hash_code 需要持有该组资源引用的对象哈希值
  * @param url 要加载文件的外部路径
  * @param load_call_back load_call_back(data):void。
  * @param load_queue 加载优先级。默认高
  * @param ignore_pool 是否忽略从缓存池中取，默认false
   */
    public async CreatePrefab(hash_code: number, url: string, load_call_back, load_queue: LOAD_QUEUE = local_LOAD_QUEUE.HIGHT, ignore_pool = false) {
        // console.warn("CreatePrefab = ", url, this.curr_loading_prefab_thread, this.prefab_max_loading_thread, Math.random())
        let loader = local_Laya.loader
        let cache_obj
        if (!ignore_pool) {
            let sprite_3d = this.GetSprite3DFormPool(hash_code, url)
            if (sprite_3d) {
                load_call_back(sprite_3d)
                return
            }
            cache_obj = loader.getRes(url)
            if (cache_obj && !cache_obj.destroyed && cache_obj._url.indexOf(url) >= 0) {
                if (cache_obj.parent) {
                    let clone_obj = cache_obj.clone()
                    clone_obj.active = true
                    load_call_back(clone_obj)
                    return
                }
                else {
                    cache_obj.active = true
                    load_call_back(cache_obj)
                    return
                }
            }
        }

        if (load_queue == null)
            load_queue = local_LOAD_QUEUE.MIDDLE

        let full_url = this.cdn_res_path + url

        let load_handler = local_Laya.Handler.create(this, (sp) => {
            if (sp) {
                sp._url = url
                sp.forbid_clone = true
                if (ignore_pool) {
                    loader.clearRes(full_url)
                }
            }
            this.loaded_3d_callbacks.push({ sp: sp, load_call_back: load_call_back, hash_code: hash_code, url: url, ignore_pool: ignore_pool })
        })
        cache_obj = cache_obj || loader.getRes(url)
        if (cache_obj) {
            var info: ResInfo = local_Laya.LoaderManager["_resMap"][url];
            if (!info) {
                let info = loader["_infoPool"].length ? loader["_infoPool"].pop() : new ResInfo();
                info.url = full_url;
                info.type = Laya3D.HIERARCHY;
                info.cache = false;
                info.ignoreCache = true;
                info.originalUrl = null;
                info.group = null;
                info.createCache = false;
                info.createConstructParams = null;
                info.createPropertyParams = null;
                info.on(local_Laya.Event.COMPLETE, load_handler.caller, load_handler.method, load_handler.args);
                local_Laya.LoaderManager["_resMap"][full_url] = info;
                let priority = 1 < loader["_maxPriority"] ? 1 : loader["_maxPriority"] - 1;
                loader["_resInfos"][priority].push(info);
                loader["_statInfo"].count++;
                loader["_next"]();
            }
            else {
                info["_createListener"](local_Laya.Event.COMPLETE, load_handler.caller, load_handler.method, load_handler.args, false, false);
            }
        }
        else {
            loader.create(full_url, load_handler, null, local_Laya.Sprite3D.HIERARCHY, null, null, load_queue, !ignore_pool);
        }
    }

    public Preload3DScene() {
        if (!LayerManager.GetInstance().Scene3D) {
            let scene3d = new local_Laya.Scene3D()
            scene3d.name = "Scene3D"
            LayerManager.GetInstance().Scene3D = scene3d
            LayerManager.GetInstance().GetUILayer(Enum_UILayer.SceneObj).addChild(scene3d);
            scene3d.enableFog = false
            scene3d.enableLight = false

            let delay_time = 100
            if(local_Laya.Browser.onIOS)
            {
                delay_time = 300
            }
            local_Laya.Sprite3D.prototype.onEnable = function () {
                // if(this.scene == scene3d)
                // {
                let scene = this.scene
                if (scene) {
                    if(scene == scene3d)
                    {
                        if (!scene.sprite3d_enable_delay_id) {
                            scene.sprite3d_enable_delay_id = setTimeout(() => {
                                scene.update_culling_state = true
                                scene.sprite3d_enable_delay_id = null
                            }, delay_time);
                        }
                    }else
                    {
                        scene.update_culling_state = true
                    }
                }
            }

            local_Laya.Sprite3D.prototype.onDisable = function () {
                // if(this.scene == scene3d)
                // {
                let scene = this.scene
                if (scene) {
                    if (scene.sprite3d_enable_delay_id) {
                        clearTimeout(scene.sprite3d_enable_delay_id)
                        scene.sprite3d_enable_delay_id = null
                    }
                    scene.update_culling_state = true
                }
            }

            var camera: Laya.Camera = scene3d.addChild(new local_Laya.Camera(0, 0.3, 1000)) as Laya.Camera
            
            Set3DLocalPosition(camera.transform, 0, -1, -10)
            Set3DLocalRotationEuler(camera.transform, 0, 180, 0)
            Set3DLocalScale(camera.transform, 1, 1, 1)

            camera.orthographic = true
            camera.useOcclusionCulling = false
            // camera.msaa = true
            // camera.fieldOfView = 60
            //清除摄像机的标记
            camera.clearFlag = local_Laya.CameraClearFlags.DepthOnly;
            camera.enableHDR = false

            window["CameraManager"].GetInstance().SetMainCamera(camera)
            camera.orthographicVerticalSize = local_Laya.stage.height * 0.01;
            CameraManager.GetInstance().orthographicVerticalSize = camera.orthographicVerticalSize 
        }
    }

    public InitShader = () => {
        let initShaderComplete
        this.initShaderPromise = new Promise<any>((resolve, reject) => {
            initShaderComplete = resolve
        })
        if (local_Laya.Browser.onAndroid && !Util.IsDebug() && ClientConfig.android_do_not_precompile_shader) {
            initShaderComplete()
            return
        }

        let main_role_vo = window["RoleManager"] && window["RoleManager"].GetInstance().GetMainRoleVo()
        let arr
        let shader_obj_list = Config.PRELOAD_CLIENT_CONFIG.ConfigShaderObj[`${main_role_vo.career}@${main_role_vo.sex}`]
        if(!shader_obj_list) return
        let compile_list = []
        for (let shader_name in shader_obj_list) {
            arr = shader_obj_list[shader_name]
            // let dic = {}
            for (let index = 0; index < arr.length; index++) {
                let obj = arr[index];
                // let outDebugDefineMask = []
                // for (var i: number = 0, n: number = obj.defineNames.length; i < n; i++)
                // {
                //     let define:Laya.ShaderDefine = Laya.Shader3D.getDefineByName(obj.defineNames[i])
                //     var index: number = define["_index"];
                //     outDebugDefineMask[index] = define["_value"];
                // }
                compile_list.push([shader_name, obj.subShaderIndex, obj.passIndex, obj.defineNames])
                // Laya.Shader3D.compileShaderByDefineNames(shader_name, obj.subShaderIndex, obj.passIndex, obj.defineNames)
                // for(let name of obj.defineNames){
                //     dic[name] = true
                // }
            }
            // let list = []
            // for(let name in dic){
            //     list.push(name)
            // }
            // console.warn("@@@@@@@@@@@@@", shader_name, list)
            // Laya.Shader3D.compileShaderByDefineNames(shader_name, 0, 0, list)
        }
        if (compile_list.length > 0) {
            let caclulate_framerate = () => {
                if (compile_list.length > 0) {
                    for (let i = 0; i < 5; i++) {
                        let info = compile_list.shift()
                        if (info) {
                            Laya.Shader3D.compileShaderByDefineNames(info[0], info[1], info[2], info[3])
                        } else {
                            return
                        }
                    }
                } else {
                    initShaderComplete()
                    Laya.timer.clear(this, caclulate_framerate)
                }
            };
            Laya.timer.frameLoop(1, this, caclulate_framerate)
        }

        //预编译shader
        // Laya.Shader3D.debugShaderVariantCollection.compile();
    }

    static CommonViewList = [
        "NameBoard",
        "ProgressBar2"
    ]
    public async PreloadCommonView() {

        let load_completed
        let promise = new Promise<any>((resolve, reject) => {
            load_completed = resolve;
        })

        let list = ResManager.CommonViewList
        let total_count = list.length
        if (list) {
            let delte_time_id = setTimeout(() => {
                load_completed()
            }, 10000);

            let load_count = 0
            let load_call_back = () => {
                load_count++
                if (load_count >= total_count) {
                    if (delte_time_id) {
                        clearTimeout(delte_time_id)
                    }
                    load_completed()
                }
            }
            for (let name of list) {
                this.LoadUILayoutFile(this.hashCode, "uiComponent", name, load_call_back, this)
            }

        }
        await promise;
    }

    /**
     * 进游戏前需要预加载好的图集
     */
    static PreloadAtlasList = [
        "mainUI",
        "common",
        "common2",
        "common4",
        "icon",
        "uiComponent",
        "emoji"
    ]
    public async PreloadAtlas() {
        let load_completed
        let promise = new Promise<any>((resolve, reject) => {
            load_completed = resolve;
        })

        let list = ResManager.PreloadAtlasList
        let total_count = list.length
        if (list) {
            let delte_time_id = setTimeout(() => {
                load_completed()
            }, 10000);

            let load_count = 0
            let load_call_back = () => {
                load_count++
                if (load_count >= total_count) {
                    if (delte_time_id) {
                        clearTimeout(delte_time_id)
                    }
                    load_completed()
                }
            }
            for (let name of list) {
                Laya.loader.load(`${this.cdn_res_path}resource/game/${name}/texture.atlas`, Laya.Handler.create(this, load_call_back), null, Laya.Loader.ATLAS, 0, true, null, false)// this._useWorkerLoader
            }
        }
        await promise;
    }

    public InitSprite3dPool() {
        let Sprite3D = local_Laya.Sprite3D
        let SkinnedMeshSprite3D = local_Laya.SkinnedMeshSprite3D
        let MeshSprite3D = local_Laya.MeshSprite3D
        let ShuriKenParticle3D = local_Laya.ShuriKenParticle3D
        let Animator = local_Laya.Animator
        let Pool = local_Laya.Pool
        let count = this.laya_sprite_3d_pool.length
        for (let i = count; i < 3000; i++) {
            this.laya_sprite_3d_pool.push(new Sprite3D())
        }
        count = this.laya_skinnedMesh_sprite3d_pool.length
        for (let i = count; i < 100; i++) {
            this.laya_skinnedMesh_sprite3d_pool.push(new SkinnedMeshSprite3D())
        }
        count = this.laya_mesh_sprite3d_pool.length
        for (let i = count; i < 60; i++) {
            this.laya_mesh_sprite3d_pool.push(new MeshSprite3D())
        }
        count = this.laya_shuriKen_particle3d_pool.length
        for (let i = count; i < 250; i++) {
            this.laya_shuriKen_particle3d_pool.push(new ShuriKenParticle3D())
        }
        for (let i = 0; i < 100; i++) {
            Pool.recoverByClass(new Animator());
        }

        let cache_texture_pool = window["cache_texture_pool"]
        if (cache_texture_pool) {
            let Texture = local_Laya.Texture
            count = cache_texture_pool.length
            for (let i = count; i < 1500; i++) {
                cache_texture_pool.push(new Texture())
            }
        }

        let cache_texture2d_pool = window["cache_texture2d_pool"]
        if (cache_texture2d_pool) {
            let Texture2D = local_Laya.Texture2D
            count = cache_texture2d_pool.length
            for (let i = count; i < 1500; i++) {
                cache_texture2d_pool.push(new Texture2D())
            }
        }
    }
}
window["ResManager"] = ResManager