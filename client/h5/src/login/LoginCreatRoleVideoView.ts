import { BaseView1 } from "../common/BaseView1"
import { Util } from "../util/Util"
import { Enum_UILayer } from "../common/LayerManager"
import { GameResPath } from "../util/GameResPath"
import { LoginManager } from "./LoginManager"
import { EventName, LoginStateEvent } from "../common/EventName"
import { kfStageModel } from "../commonModel/kfStageModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { LoginModel } from "./LoginModel"
import { PlatformManager } from "../PlatformManager"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { GameVideo } from "../util/GameVideo"
import { SoundManager } from "../common/SoundManager"
export class LoginCreatRoleVideoView extends BaseView1 {
    video_: GameVideo
    login_mgr
    _completeHandler
    public constructor() {
        super()

        this.base_file = "login"
        this.layout_file = "LoginCreatRoleVideoView"
        this.layer_value = Enum_UILayer.FightingUp
        //this.is_center = true
        this.destroy_imm = true
        this.is_delay_callback = false
        this.need_loading_view = false
        this.not_show_main_msg = true
        this.not_show_attr_main_msg = true
        this.use_background = true
        this.background_alpha = 12
        this.not_close_by_android_back_key = true
        this.login_mgr =  LoginManager.GetInstance()

        this.load_callback = () => {
            this.display_obj.visible=false
            this.ResizeBg()
            this.CreatVideo()
            this.InitEvent()
        }
        this.open_callback = () => {

        }
        this.close_callback = () => {
        }

        this.destroy_callback = () => {
            SoundManager.GetInstance().ResoveSceneSound()
            if (this.video_) {
                this.video_.Destroy()
            }
        }

    }

    public InitEvent() {

        Util.AddClickEvent(this._box_skip, () => {
            if(Util.IsMiniGame())return //小游戏点击不了 视频在最上层
            this.PlayEnded()
        }, this, true)

        this.BindEvent(GlobalEventSystem, EventName.STATE_RESET_SIZE, (width, height) => {
			this.CallLater(()=>{
                if(this.use_delete_method)return
                this.ResizeBg()
            })
		})

    }


    private ResizeBg(){
        this._img_bg.width = Laya.stage.width
        this._img_bg.height = Laya.stage.height
    }

    /**播放视频 */
    private CreatVideo() {
        if (Util.IsMiniGame()) {
            //小游戏不显示那妞
            this._box_skip.visible=false
        }

        this._box_video.mouseEnabled = false
        let video_url = LoginManager.GetInstance().GetVideoUrl()
        this.video_ = new GameVideo()
        this.video_.InitVideo(this._box_video,video_url,null,()=>{
            this.VideoLoaded()
        },()=>{
            this.PlayEnded()
        },(msg?)=>{
            this.PlayError(msg)
        })
    }


    /**加载完毕 */
    public VideoLoaded(){
        if(this.video_){
            this.display_obj.visible=true
            SoundManager.GetInstance().PauseSceneSound()
            this.video_.Play()
            this.login_mgr.Fire(LoginStateEvent.CLOSE_VIEW, "LoginCreateRoleView");
        }
    }



    /**视频播放完毕 */
    public PlayEnded() {
        SoundManager.GetInstance().ResoveSceneSound()
        this.Close()
        LoginManager.GetInstance().is_wait_video = false
        this.login_mgr.Fire(LoginStateEvent.OPEN_VIEW, "LoginLoadingView");
    }


    /**出错 */
    public PlayError(msg?){
        console.warn("测试PlayError",msg)
        this.PlayEnded()
    }

    public Open() {
        super.Open()
    }


_img_bg:Laya.Image
_box_video:Laya.Box
_box_skip:Laya.Box
_img_skip:Laya.Image
_lb_skip:Laya.Text
public GetComponents() {
[
this._img_bg,
this._box_video,
this._box_skip,
this._img_skip,
this._lb_skip,
]
 = this.GetChildrenByNames([

"_img_bg",
"_box_video",
"_box_skip",
"_img_skip",
"_lb_skip",
])
}
}
 window["LoginCreatRoleVideoView"]= LoginCreatRoleVideoView