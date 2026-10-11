import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer, LayerManager } from "../common/LayerManager"
import { FirstRechargeModel } from "../commonModel/FirstRechargeModel"
import { Config } from "../common/Config"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { Util, SetLocalScale } from "../util/Util"
import { RoleManager } from "../commonModel/RoleManager"
import { SYTweenLite } from "../util/SYTweenLite"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { table } from "../common/table"
import { FriendEvent } from "../commonModel/FriendModel"
import { MainUIModel } from "../commonModel/MainUIModel"
import { SceneManager } from "../scene/SceneManager"
import { FirstRechargeController } from "../commonController/FirstRechargeController"
import { ViewPopLevelModel } from "../commonModel/ViewPopLevelModel"
import { BaseItem1 } from "../common/BaseItem1"
import { PlatformManager } from "../PlatformManager"

export class FirstRechargeNewTipsView extends BaseItem1 {
    _img_bg: Laya.Image
    _img_1: Laya.Image
    _img_close: Laya.Image
    _img_2: Laya.Image
    _img_3: Laya.Image
    model_icon: Laya.Box
    box_click: Laya.Box
    _lb_time: Laya.Label
    ClearModel
    DeleteMe
    InitEvent
    LoadCfg
    LoadSuccess
    Remove
    ShowEffect
    ShowModel
    change_scene_close
    destroy_callback
    destroy_imm
    is_center
    not_show_main_msg
    open_callback
    show_open_movie
    use_background
    time
    change_state
    Del_me
    public constructor(parent?) {
        super(parent)


        this.base_file = "recharge"
        this.layout_file = "FirstRechargeNewTipsView"
        this.layer_value = Enum_UILayer.Main
        this.change_scene_close = false
        this.use_background = false
        this.is_center = false
        this.show_open_movie = true
        //this.not_show_main_msg = true
        this.destroy_imm = true
        let model = FirstRechargeModel.GetInstance()

        //let local_laya = Laya
        let client_cfg_ = null
        let model_list_ = null
        let floatList_ = null
        let model_res = [1101, 1101, 1301, 1401]
        this.preload_client_config = {
            "ConfigFirstRecharge": false
        }
        this.load_callback = () => {
            if (PlatformManager.IsEyouThPlatform()) {
                this._img_1.x = 2
                this._img_1.y = 10
                this._img_1.scaleY = this._img_1.scaleX = 0.8
                this._img_2.pos(40, 246)
                this._img_3.pos(12, 287)
                this._img_3.width = 237
                this._img_3.height = 41
            }
            this.display_obj.y = 0
            this.display_obj.scale(0, 0)
            this.LoadCfg()
            this.LoadSuccess()
            this.InitEvent()
        }

        this.open_callback = () => {
            this.ShowModel()
        }

        this.destroy_callback = () => {

            this.Remove()
        }

        this.LoadCfg = () => {
            client_cfg_ = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigFirstRecharge", true)
            this.ShowModel()
        }

        this.LoadSuccess = () => {
            let x = 0
            let y = 0
             if (FirstRechargeModel.GetInstance().is_bubble) {
                x = 50
                y = -345
            } else if (FirstRechargeModel.GetInstance().is_show_qipao) {
                x = 50
                y = -415
            } else {
                x = 60
                y = -375
            }

            if (SceneManager.GetInstance().IsExpDungeon() && !MainUIModel.GetInstance().activity_icon_in_show && !FirstRechargeModel.GetInstance().is_bubble) {
                this.display_obj.pos(10, LayerManager.GetInstance().stageHeight - 500)
                x = 60
                y = LayerManager.GetInstance().stageHeight - 700
            }
            Laya.Tween.to(this.display_obj, { x: x, y: y, scaleX: 1, scaleY: 1 }, 500, undefined, Laya.Handler.create(this, () => {
                if (client_cfg_.tips_close_time) {
                    this.time = client_cfg_.tips_close_time.toString()
                    // this._lb_time.text=this.time +"秒后自动关闭"
                    Laya.timer.loop(1000, this, () => {
                        this.time = this.time - 1
                        // this._lb_time.text=this.time.toString()+"秒后自动关闭"
                        if (Number(this.time) <= 0) {
                            Laya.timer.clearAll(this)
                            this.Del_me()
                        }
                    })
                }
            }))
            this.display_obj.zOrder = 1;
        }

        this.InitEvent = () => {
            Util.AddClickEvent(this._img_close, () => {
                Laya.timer.clearAll(this)
                this.Del_me()
            }
                , this, true)
            Util.AddClickEvent(this.box_click, () => {
                Laya.timer.clearAll(this)
                // model.Fire(FirstRechargeModel.OPEN_FIRST_RECHARGE_VIEW)
                ViewPopLevelModel.GetInstance().SetViewPop('FirstRechargeView');
                this.Del_me();
            }
                , this, true)
            this.BindEvent(MainUIModel.GetInstance(), MainUIModel.UPDATE_ACTIVITY_STATE, this.change_state)
            this.BindEvent(FirstRechargeModel.GetInstance(), FirstRechargeModel.CLOSE_NEW_TIPS_VIEW, () => {
                Laya.timer.clearAll(this)
                this.Del_me()
            })
        }
        this.ShowEffect = () => {

        }

        this.Del_me = ( )  =>{
            FirstRechargeModel.GetInstance().Fire(FirstRechargeModel.REMOVE_FIRST_RECHARGE_NEW_TIPS_ITEM)
        }

        this.change_state = (show?) => {
            if (!show) {
                Laya.Tween.to(this.display_obj, { x: 0, y: 0, scaleX: 0, scaleY: 0 }, 200,)
                if (SceneManager.GetInstance().IsExpDungeon() && !MainUIModel.GetInstance().activity_icon_in_show && !FirstRechargeModel.GetInstance().is_bubble) {
                    let x, y
                    this.display_obj.pos(10, LayerManager.GetInstance().stageHeight - 500)
                    this.display_obj.scale(0, 0)
                    x = 60
                    y = LayerManager.GetInstance().stageHeight - 700
                    Laya.Tween.to(this.display_obj, { x: x, y: y, scaleX: 1, scaleY: 1 }, 200,)
                }
            } else {
                let x = 0
                let y = 0
                if (FirstRechargeModel.GetInstance().is_bubble) {
                    x = 50
                    y = -345
                } else if (FirstRechargeModel.GetInstance().is_show_qipao) {
                    x = 50
                    y = -415
                } else {
                    x = 60
                    y = -375
                }
                this.display_obj.pos(0, 0)
                this.display_obj.scale(0, 0)
                Laya.Tween.to(this.display_obj, { x: x, y: y, scaleX: 1, scaleY: 1 }, 200,)
            }
        }

        this.ShowModel = (parent?, type?, res?, ui_scale?, pos?) => {
            let data = {
                clothe_res_id: model_res[RoleManager.GetInstance().GetMainRoleCareer() - 1],
                type: 4,
                can_rotate: false,
                layer_value: this.layer_value,
                scale: 1,
                position: { "x": 0, "y": 0 },
                rotate: RoleManager.GetInstance().GetMainRoleCareer() == 3 ? 180 : 0,
                texture_size: { x: 567, y: 415 },
                action_name_list: ["show"],
                action_delta: true
            }
            if (data) {
                ResManager.GetInstance().SetRoleModel(this, this.model_icon, data)
            }
        }

        this.ClearModel = () => {
            //ResManager.GetInstance().ClearRoleMode(this)
        }

        this.Remove = () => {
            Laya.Tween.clearAll(this)
        }

        this.DeleteMe = () => {
            //this:ClearModel()
            //图片 动画取消
            if (floatList_) {
                for (let _tmpi in floatList_) {
                    var obj = floatList_[_tmpi]
                    if (obj) {
                        SYTweenLite.Stop(obj)
                    }
                }
                floatList_ = null
            }
            super.DeleteMe()
        }


    }

    public GetComponents() {
        [
            this._img_bg,
            this._img_1,
            this._img_close,
            this._img_2,
            this._img_3,
            this.model_icon,
            this.box_click,
            this._lb_time
        ]
            = this.GetChildrenByNames([

                "_img_bg",
                "_img_1",
                "_img_close",
                "_img_2",
                "_img_3",
                "model_icon",
                "box_click",
                "_lb_time"
            ])
    }
}
window["FirstRechargeNewTipsView"] = FirstRechargeNewTipsView