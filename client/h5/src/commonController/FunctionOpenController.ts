import { BaseClass } from "../common/BaseClass"
import { BaseController } from "../common/BaseController"
import { BaseViewInterface } from "../common/BaseView1"
import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { EventName } from "../common/EventName"
import { LayerManager, Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { UIEffect } from "../common/UIEffect"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { ViewManager } from "../common/ViewManager"
import { FunctionOpenEvent, FunctionOpenModel } from "../commonModel/FunctionOpenModel"
import { MainUIModel } from "../commonModel/MainUIModel"
import { PlatformManager } from "../PlatformManager"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameMath } from "../util/GameMath"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"


import "../funcOpen/FunctionOpenAutoView"
import "../funcOpen/FunctionOpenIcon"
import "../funcOpen/FunctionOpenListView"
import "../funcOpen/FunctionOpenTipView"
import { TaskModel } from "../commonModel/TaskModel"
import { OpenFun } from "../common/OpenFun"

// 功能开放
export class FunctionOpenController extends BaseController {

    view_dic: { [name: string]: BaseViewInterface } = {}
    func_open_model: FunctionOpenModel = FunctionOpenModel.GetInstance()
    layer_mgr: LayerManager = LayerManager.GetInstance()
    res_mgr: ResManager = ResManager.GetInstance()
    user_msg_adapter: UserMsgAdapter = UserMsgAdapter.GetInstance()
    scene_mgr: SceneManager = SceneManager.GetInstance()
    hash_code_target = new BaseClass()

    public constructor() {
        super()
        this.InitEvent()
        this.RegisterProtocals()
    }


    InitEvent() {
        this.func_open_model.Bind(FunctionOpenEvent.FUNCTIONOPEN_REQUEST_PROTO, (id: number, fmt?: string, ...parms) => {
            this.SendFmtToGame(id, fmt, ...parms)
        })

        this.func_open_model.Bind(FunctionOpenEvent.FUNCTIONOPEN_OPEN_VIEW, (view_class_name, ...parms) => {
            if (view_class_name == "FunctionOpenIcon" && PlatformManager.GetInstance().is_alpha) {
                return
            }
            let view = this.view_dic[view_class_name]
            if (!view) {
                let view_class: any = window[view_class_name]
                view = new view_class()
                this.view_dic[view_class_name] = view
            }
            view.Open(...parms)
        })

        this.func_open_model.Bind(FunctionOpenEvent.FUNCTIONOPEN_CLOSE_VIEW, (view_class_name, ...parms) => {
            let view = this.view_dic[view_class_name]
            if (view && view.HasOpen()) {
                view.Close()
            }
        })

        this.func_open_model.Bind(FunctionOpenEvent.FUNCTIONOPEN_CLOSE_ICON_VIEW, () => {
            if (this.view_dic["FunctionOpenIcon"] && this.view_dic["FunctionOpenIcon"].HasOpen()) {
                this.view_dic["FunctionOpenIcon"].Close()
            }
        })

        GlobalEventSystem.Bind(EventName.INIT_CONFIG, () => {
            this.func_open_model.InitConfig()
        })

        GlobalEventSystem.Bind(EventName.GAME_START, () => {
            this.func_open_model.Fire(FunctionOpenEvent.FUNCTIONOPEN_REQUEST_PROTO, 13800)
        })

        let fly_fun = (id, icon, pos, target_pos, endFunc, is_skill) => {
            if (!id || !icon || !pos) {
                return
            }
            let ui_layer = this.layer_mgr.GetUILayer(Enum_UILayer.UI)
            let img = new Laya.Image()
            img.width = img.height = is_skill ? 58 : 100


            if (is_skill) {
                this.res_mgr.SetTexture(this.hash_code_target, img, GameResPath.GetSkillIcon(icon))

            } else if (id >= 1002 && id <= 1006) {
                this.res_mgr.SetOutsideImageSprite(this.hash_code_target, img, GameResPath.GetIcon("pet", id))

            } else {
                this.res_mgr.SetImageSprite(this.hash_code_target, img, "functionOpen", icon)
            }
            ui_layer.addChild(img)
            img.x = pos.x
            img.y = pos.y
            if (target_pos) {
                let dist = GameMath.GetDistance(pos.x, pos.y, target_pos.x, target_pos.y, true)
                let time = dist / 600 * 1000;
                if (is_skill) {
                    time -= 250;
                }
                let delayFunc = () => {
                    if (endFunc) {
                        endFunc()
                    }
                    if(id && id == 1006){
						OpenFun.OpenFunHandler(243)
					}
                    if (img && ui_layer) {
                        img.visible = false
                        ui_layer.removeChild(img)
                        this.res_mgr.DestroyAllReferenceRes(this.hash_code_target.hashCode);
                    }
                }
                setTimeout(() => {
                    Laya.Tween.to(img, { x: target_pos.x, y: target_pos.y }, time, undefined, Laya.Handler.create(this, () => {
                        delayFunc()
                        // let main_role_task = TaskModel.GetInstance().GetMainLineTaskVo()
                        // if (main_role_task && main_role_task.task_id == 100990) {
                        //     GlobalEventSystem.Fire(EventName.SET_TR_ARROW)
                        // }
                    }))
                }, 500)

            }
        }
        this.func_open_model.Bind(FunctionOpenEvent.FUNCTIONOPEN_ICON_FLY, fly_fun)

        let scene_start = () => {
            this.ChangeScene()
        }
        GlobalEventSystem.Bind(SceneManager.START, scene_start)
        GlobalEventSystem.Bind(EventName.CLOSED_ONE_VIEW, scene_start)
        // GlobalEventSystem.Bind(EventName.CHANGE_CUR_VIEW_COUNT, scene_start)

        MainUIModel.GetInstance().BindOne("activity_state", (event_name, value) => {
            if (value) {
                scene_start()
            }
        })
        let delay_timer_id
        RoleManager.GetInstance().GetMainRoleVo().Bind(EventName.CHANGE_LEVEL, (lv) => {
            if (delay_timer_id) {
                clearTimeout(delay_timer_id)
                delay_timer_id = null
            }
            if (!delay_timer_id) {
                delay_timer_id = setTimeout(() => {
                    this.func_open_model.Fire(FunctionOpenEvent.FUNCTIONOPEN_REQUEST_PROTO, 13800)
                }, 100)
            }
        })
    }

    RegisterProtocals() {
        //已完成列表
        let On13800 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(13800)
            Laya.timer.callLater(this, () => {
                this.func_open_model.SetFinishFunData(scmd.list)
            })
        }

        //领取奖励
        let On13801 = () => {
            let scmd = this.user_msg_adapter.GetSCMD(13801)
            if (scmd.code == 1) {
                // Message.show("领取成功")
                this.func_open_model.UpdateFinishFunState(scmd)
                this.func_open_model.Fire(FunctionOpenEvent.FUNCTIONOPEN_GET_REWARD_SUCCESS, scmd.id)
            } else {
                Util.ErrorCodeShow(scmd.code)
            }
        }

        //新功能开放
        let On13802 = () => {

        }
        this.RegisterProtocal(13800, On13800)  //已完成列表
        this.RegisterProtocal(13801, On13801)  //领取奖励
        this.RegisterProtocal(13802, On13802)  //新功能开放
    }



    ChangeScene() {
        if (this.view_dic["FunctionOpenIcon"] != undefined) {
            if (!this.func_open_model.IsShowFunctionScene()) {
                this.view_dic["FunctionOpenIcon"]["Hide"]()
            } else {
                this.view_dic["FunctionOpenIcon"]["CancelHide"]()
            }

        }

        if (this.func_open_model.IsShowFunctionScene()) {
            let data = this.func_open_model.NeedShowFunctionOpenIcon()
            if (data) {
                this.func_open_model.Fire(FunctionOpenEvent.FUNCTIONOPEN_OPEN_VIEW, "FunctionOpenIcon", data)
            }
        }

        if (this.func_open_model.need_show_open_fun_data_cache && this.scene_mgr.IsFieldScene()
            && ViewManager.GetInstance().NoBackGroupViewInShow() && Util.IsTableEmpty(BaseWindowComponent.CURR_OPEN_VIEW)) {
            this.func_open_model.Fire(FunctionOpenEvent.FUNCTIONOPEN_OPEN_VIEW, "FunctionOpenAutoView", this.func_open_model.need_show_open_fun_data_cache)
            this.func_open_model.need_show_open_fun_data_cache = null
        }
    }
}
window["FunctionOpenController"] = FunctionOpenController