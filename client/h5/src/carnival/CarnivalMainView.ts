import { AccumRechargeItem } from "../activity/AccumRechargeItem"
import { DailySupplyItem } from "../activity/DailySupplyItem"
import { BaseItem1 } from "../common/BaseItem1"
import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { CarnivalMainItem } from "./CarnivalMainItem"

export class CarnivalMainView extends BaseItem1 {
    _img_bg: Laya.Image
    _img_title: Laya.Image
    _titleBg: Laya.Image
    bg: Laya.Image
    _gp_tips: Laya.Box
    _Image1: Laya.Image
    _Label1: Laya.Label
    time_bg: Laya.Image
    _gp_time: Laya.Box
    _group_item: Laya.List
    _lb_desc: Laya.Label
    CustomMehod
    InitEvent
    InitView
    LoadSuccess
    Local_DeleteMe
    SetRewardData
    UpdateItems
    _Viewport1
    _ac_item
    _act_info
    _model
    _reward_data
    createChildren
    needRefresh
    parent_mask_corner
    story_obj_list
    time_title_color

    public constructor(parent?) {
        super(parent)

        this._act_info = null
        this._model = CustomActivityModel.GetInstance()

        this.base_file = "carnival"
        this.layout_file = "CarnivalMainView"
        this.layer_value = Enum_UILayer.UI
        let local_Event = CustomActivityDefine.EVENT
        this._ac_item = null
        let timer = null
        this._reward_data = null
        let CURR_BASE_WINDOW_COMPONENT = BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT

        this.load_callback = () => {

            this._group_item.scrollBar.visible = false
            if (this.needRefresh) {
                this.SetRewardData(this._act_info)
                this._model.Fire(local_Event.SCMD_REQUEST,33258,this._act_info.base_type,this._act_info.sub_type)
            }

            this.LoadSuccess()
        }

        this.Local_DeleteMe = () => {
            if (timer) {
                timer.DeleteMe()
                timer = null
            }
            if (this._ac_item) {
                this._ac_item.DeleteMe()
                this._ac_item = null
            }
        }

        this.CustomMehod = (index?, info?) => {
            this._act_info = info
            if (this.is_loaded) {
                this._model.Fire(local_Event.SCMD_REQUEST,33258,this._act_info.base_type,this._act_info.sub_type)
                this.SetRewardData(info)
            } else {
                this.needRefresh = true
            }
        }

        this.SetRewardData = (info?) => {
            let act_data = this._model.GetActData(info.base_type, info.sub_type)
            if (act_data) {
                for (let _tmpi in act_data.reward_list) {
                    var data = act_data.reward_list[_tmpi]
                    data.base_type = info.base_type
                    data.sub_type = info.sub_type
                }
            }
            this._reward_data = act_data
        }

        this.InitEvent = () => {
            let RefView = (base_type?, sub_type?) => {
                if (!this._act_info) {
                    return
                }
                if (!this._reward_data) {
                    return
                }
                if (this._act_info.base_type == base_type && this._act_info.sub_type == sub_type) {
                    this.SetRewardData(this._act_info)
                    this.UpdateItems()
                }
            }
            this.BindEvent(this._model, local_Event.UPDATE_ACT_RECHANGE, RefView)

            this.BindEvent(this._model, local_Event.UPDATE_ACT_RECHANGE_DAY, () => {
                this.UpdateItems()
            })

            this.BindEvent(this._model, local_Event.ANSWER_TARGET, (base_type?, sub_type?, result_data?, reward_data?) => {
                if (!this._act_info) {
                    return
                }
                if (this._act_info.base_type == base_type && this._act_info.sub_type == sub_type) {
                    this.SetRewardData(this._act_info)
                    this.UpdateItems()
                    let rewards = this._model.GetActReward(reward_data.base_type, reward_data.sub_type, reward_data.form_type, reward_data.reward)
                    new CongratulationObtainView(rewards, 10).Open()
                }
            }
            )
            let updata_view = (base_type?, sub_type?) => {
                if (this._act_info.base_type == base_type && this._act_info.sub_type == sub_type) {
                    this.SetRewardData(this._act_info)
                    this.UpdateItems()
                }
            }

            this.BindEvent(this._model, local_Event.UPDATE_VIEW, updata_view)
        }

        this.LoadSuccess = () => {

            this.InitView()
            this.InitEvent()
        }

        this.InitView = (item?) => {
            ResManager.GetInstance().SetTexture(this,this._img_bg,GameResPath.GetIconJpg("activity","ui_qmkh_01"))
            if (!this._act_info) {
                this._model.Fire(local_Event.SCMD_REQUEST, 33104, this._act_info.base_type, this._act_info.sub_type)
            }
            if (!this._act_info) {
                return
            }  
            this._model.CloseACTRed(this._act_info.base_type,this._act_info.sub_type)
            this.time_bg.visible = false
            this._gp_time.x = 10
            this._gp_time.y = 255
            this.UpdateItems()
            this.time_title_color = this.time_title_color ? this.time_title_color : "#ffffff"
            let time_desc = "活动剩余时间："
            timer = this._model.LoadActTimer(this._gp_time, this._act_info.etime, 22, "#00fa64", null, this.time_title_color, time_desc)
        }

        this.UpdateItems = () => {
            if (!this._reward_data) {
                return
            }
            let list = this._reward_data.reward_list
            table.sort(list, (a?, b?) => {
				if (a.status != b.status) {
					if (a.status == 1) {
						return true
					} else if (b.status == 1) {
						return false
					} else {
						return a.status < b.status
					}
				} else {
					return a.grade < b.grade
				}
			})
            if (!this._ac_item) {
                this._ac_item = new LoopScrowViewMgr()
                this._ac_item.SetData(this._group_item, CarnivalMainItem, list, LoopScrCon.Vertical, 1)
            }else{
                this._ac_item.replaceAll(list)
            }
        }


    }

    public DeleteMe() {

        this.Local_DeleteMe()
        super.DeleteMe()
    }

    public GetComponents() {
        [
            this._img_bg,
            this._img_title,
            this._titleBg,
            this.bg,
            this._gp_tips,
            this._Image1,
            this._Label1,
            this.time_bg,
            this._gp_time,
            this._group_item,
            this._lb_desc,
        ]
            = this.GetChildrenByNames([

                "_img_bg",
                "_img_title",
                "_titleBg",
                "bg",
                "_gp_tips",
                "_Image1",
                "_Label1",
                "time_bg",
                "_gp_time",
                "_group_item",
                "_lb_desc",
            ])
    }
}
window["CarnivalMainView"]=CarnivalMainView