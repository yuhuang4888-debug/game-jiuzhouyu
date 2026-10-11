
import { Util } from "./Util"

export class GameVideo {

    //区分 InitVideo   Destroy   Play

    /**微信小游戏 */
    public static PLAT_TYPE_WX = 1
    /**链接端 */
    public static PLAT_TYPE_LINK = 2
    /**QQ小游戏 */
    public static PLAT_TYPE_QQMIN = 3
    /**OPPO快应用*/
    public static PLAT_TYPE_OPPOFAST = 4
    /**Vivo快应用*/
    public static PLAT_TYPE_VIVOFAST = 5
    /**小米快应用*/
    public static PLAT_TYPE_XMFAST = 6
    /**魅族快应用*/
    public static PLAT_TYPE_MEIZU_FAST = 7
    /**uc小游戏*/
    public static PLAT_TYPE_UC = 8
    /**bilibili小游戏*/
    public static PLAT_TYPE_BL = 9
    /**华为小游戏*/
    public static PLAT_TYPE_HBS = 10
    /**美团小游戏*/
    public static PLAT_TYPE_MT = 11
    /**字节跳动小游戏*/
    public static PLAT_TYPE_TT = 12


    video_
    _completeHandler:Laya.Handler
    plat_type = 0

    /**加载完毕调用 */
    video_load_call_back
    /**播放完毕调用 */
    video_ended_call_back
    /**播放出错或加载不到资源调用 */
    video_error_call_back

    public constructor() {
        if (Util.IsMiniGame()) {
            if (Util.IsWXGame()) {
                this.plat_type = GameVideo.PLAT_TYPE_WX
            }
            else if (Util.IsQQGame()) {
                this.plat_type = GameVideo.PLAT_TYPE_QQMIN
            }
            else if (Util.IsOPPOFastGame()) {
                this.plat_type = GameVideo.PLAT_TYPE_OPPOFAST
            }
            else if (Util.IsVivoFastGame()) {
                this.plat_type = GameVideo.PLAT_TYPE_VIVOFAST
            }
            else if (Util.IsMiFastGame()) {
                this.plat_type = GameVideo.PLAT_TYPE_XMFAST
            }
            else if (Util.IsUCGame()) {
                this.plat_type = GameVideo.PLAT_TYPE_UC
            }
            else if (Util.IsMeiZuFastGame()) {
                this.plat_type = GameVideo.PLAT_TYPE_MEIZU_FAST
            }
            else if (Util.IsBiliBiliGame()) {
                this.plat_type = GameVideo.PLAT_TYPE_BL
            }
            else if (Util.IsHuaweiFastGame()) {
                this.plat_type = GameVideo.PLAT_TYPE_HBS
            }
            else if (Util.IsMTGame()) {
                this.plat_type = GameVideo.PLAT_TYPE_MT
            }
            else if (Util.IsTTGame()) {
                this.plat_type = GameVideo.PLAT_TYPE_TT
            }
        } else {
            this.plat_type = GameVideo.PLAT_TYPE_LINK
        }
    }


    /**
     * 初始化视频组件
     * @param parent                        播放器父节点(对小游戏没有用)
     * @param video_url                     地址
     * @param other_param                   其他的参数 {x,y,width,heigt.....}
     * @param video_load_call_back          箭头函数 加载完成调用  
     * @param video_ended_call_back         箭头函数 播放完成调用
     * @param video_error_call_back         箭头函数 播放出错或加载不到资源调用
     * @returns 
     */
    public InitVideo(parent?, video_url?, other_param?, video_load_call_back?, video_ended_call_back?, video_error_call_back?) {
        if (!parent) {
            if (this.video_error_call_back) this.video_error_call_back("没有指定父节点")
            return null
        }
        parent.mouseEnabled = false

        //视频分辨率
        let width = other_param && other_param.width || 720;
        let height = other_param && other_param.heigt || 1280;

        //回调
        this.video_load_call_back = video_load_call_back;
        this.video_ended_call_back = video_ended_call_back;
        this.video_error_call_back = video_error_call_back;

        switch (this.plat_type) {
            case GameVideo.PLAT_TYPE_WX:
                this.CreatVideoComp("wx", width, height, video_url)
                break
            case GameVideo.PLAT_TYPE_QQMIN:
                this.CreatVideoComp("qq", width, height, video_url)
                break
            case GameVideo.PLAT_TYPE_VIVOFAST:
            case GameVideo.PLAT_TYPE_OPPOFAST:
            case GameVideo.PLAT_TYPE_XMFAST:
            case GameVideo.PLAT_TYPE_MEIZU_FAST:
                this.CreatVideoComp("qg", width, height, video_url)
                break
            case GameVideo.PLAT_TYPE_UC:
                this.CreatVideoComp("uc", width, height, video_url)
                break;
            case GameVideo.PLAT_TYPE_BL:
                this.CreatVideoComp("bl", width, height, video_url)
                break;
            case GameVideo.PLAT_TYPE_HBS:
                this.CreatVideoComp("hbs", width, height, video_url)
                break;
            case GameVideo.PLAT_TYPE_LINK:
                if (!parent) return null
                this.video_ = new Laya.Video(width, height)
                parent.addChild(this.video_) //小游戏不需要加载这一步

                if (this.video_ended_call_back) {
                    this.video_.on('ended', null, this.video_ended_call_back)        //视频播放完毕
                }

                if (this.video_load_call_back) {
                    this.video_.on("loadedmetadata", null, this.video_load_call_back) //等待视频加载完不必缓冲时再播放
                }

                if (this.video_error_call_back) {
                    this.video_.on("error", null, this.video_error_call_back) //视频因为一些原因播放不了
                }

                if (!this._completeHandler) {
                    this._completeHandler = Laya.Handler.create(this, (res) => {
                        //如果加载不到视频资源 那么进行下一步，避免卡流程
                        if (res != null) {
                            if(this.video_){
                                this.video_.load(video_url)
                            }
                        } else {
                            if (this.video_error_call_back) this.video_error_call_back("加载不到资源")
                        }

                    }, null, false)
                }
                Laya.loader.create(video_url, this._completeHandler)
                break;
            default:
                if (this.video_error_call_back) this.video_error_call_back("该平台还没做视频播放的接入")
                break;
        }

    }

    /**移除*/
    public Destroy() {
        if (this._completeHandler) {
            this._completeHandler.recover()
            this._completeHandler = null
        }
        switch (this.plat_type) {
            case GameVideo.PLAT_TYPE_LINK:
                if (this.video_) {
                    this.video_.pause()

                    if (this.video_ended_call_back) {
                        this.video_.off('ended', null, this.video_ended_call_back)        //视频播放完毕
                    }

                    if (this.video_load_call_back) {
                        this.video_.off("loadedmetadata", null, this.video_load_call_back) //等待视频加载完不必缓冲时再播放
                    }

                    if (this.video_error_call_back) {
                        this.video_.off("error", null, this.video_error_call_back) //视频因为一些原因播放不了
                    }


                    this.video_.removeSelf()
                    this.video_.destroy()
                    this.video_ = null
                }
                break
            default:
                if (this.video_) {
                    if (this.video_ended_call_back) this.video_.offEnded(this.video_ended_call_back)
                    if (this.video_error_call_back) this.video_.offError(this.video_error_call_back)
                    if (this.video_load_call_back) this.video_.offPlay(this.video_load_call_back)

                    this.video_.destroy()
                    this.video_ = null
                }
                break;
        }

        this.video_ended_call_back = null
        this.video_load_call_back = null
        this.video_error_call_back = null
    }



    /**播放 */
    public Play() {
        if (!this.video_) return
        switch (this.plat_type) {
            case GameVideo.PLAT_TYPE_LINK:
                this.video_.play()
                break;
            default:
                //设置了自动播放/手动播放
                break
        }
    }




    /**
     * 创建video组件
     * @param api_name      api名称
     * @param width         视频分辨率宽度
     * @param height        视频分辨率高度
     * @param video_url     视频文件地址
     */
    private CreatVideoComp(api_name, width, height, video_url) {
        let local_api = window[api_name]
        //设备宽高  默认iphone 13(pro)宽高
        let dev_width = local_api["getSystemInfoSync"] && local_api["getSystemInfoSync"]().windowWidth || 399
        let dev_height = local_api["getSystemInfoSync"] && local_api["getSystemInfoSync"]().windowHeight || 844

        //视频宽高
        let video_width = dev_width
        let video_height = video_width / (width / height);
        //位置居中调整
        let video_y = (dev_height - video_height) / 2;

        let video_obj = {
            "x": 0,
            "y": 0,
            "width": video_width,
            "height": video_height,
            "src": video_url,
            "controls": false,
            "showProgress": false,
            "showProgressInControlMode": false,
            "autoplay": true, //自动播放
            "loop": false,
            "enableProgressGesture": false,
            "enablePlayGesture": false,
            "showCenterPlayBtn": false,
            "objectFit": "contain"
        }


        if (local_api && local_api["createVideo"]) {
            this.video_ = local_api["createVideo"](video_obj)

            if (this.video_ended_call_back) this.video_.onEnded(this.video_ended_call_back)
            if (this.video_error_call_back) this.video_.onError(this.video_error_call_back)
            if (this.video_error_call_back) this.video_.onPlay(this.video_load_call_back)

            //重新设置video的位置
            this.video_.y = video_y

        } else {
            if (this.video_error_call_back) this.video_error_call_back(`调用不到${api_name}方法`)
        }

    }



}
window["GameVideo"] = GameVideo