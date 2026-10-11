import { BaseView1 } from "../common/BaseView1";
import { CustomHeadItem } from "../common/CustomHeadItem";
import { EventName } from "../common/EventName";
import { Enum_UILayer } from "../common/LayerManager";
// import { PlayerHead } from "../common/PlayerHead";
import { ResManager } from "../common/ResManager";
import { BanqEvent, BanquetModel } from "../commonModel/BanquetModel";
import { DressModel, DressType } from "../commonModel/DressModel";
import { MarriageModel, MarriageEvent } from "../commonModel/MarriageModel";
import { RoleManager } from "../commonModel/RoleManager";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { GameResPath } from "../util/GameResPath";
import { TimeUtil } from "../util/TimeUtil";
import { GlobalTimerQuest, Util } from "../util/Util";

export class MarriageSuccessView extends BaseView1 {

    private _head_self: CustomHeadItem;
    private _head_other: CustomHeadItem;

    Local_Open
    Clear
    LoadSuccess
    InitEvent
    UpdateMateData
    StartTimer
    UpdateTimer
    ClearTimer
    public constructor() {
        super()
        this.base_file = "marriage";
        this.dependent_res = ["marriage2"]
        this.layout_file = "MarriageSuccessView"
        this.layer_value = Enum_UILayer.Activity;
        this.is_center = true
        this.use_background = true
        // this.click_bg_toClose = true
        this.show_open_movie = true
        this.destroy_imm = true

        let _model = MarriageModel.GetInstance(),
            REQUEST_PROTO = MarriageEvent.REQUEST_PROTO,
            res_mgr = ResManager.GetInstance(),
            dress_model = DressModel.GetInstance(),
            local_BanqEvent = BanqEvent,
            // local_egret = egret,
            local_TimeUtil = TimeUtil,
            _other_vo_,
            _time_,
            time_event_id_
        // _timer_: egret.Timer

        this.load_callback = function () {
            ResManager.GetInstance().SetOutsideImageSprite(this, this.img1, GameResPath.GetIcon("marriage", "uijh_081"))
            ResManager.GetInstance().SetOutsideImageSprite(this, this._img_086, GameResPath.GetIcon("marriage", "ui_marry_30"))
            ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("marriage", "uijh_090"))
            this.LoadSuccess()
            this.InitEvent()
        }

        this.destroy_callback = function () {
            this.Clear()
        }

        this.Local_Open = (parms) => {
            [_other_vo_] = parms
            super.Open()
        }

        this.Clear = () => {
            if (this._head_self) {
                this._head_self.DeleteMe()
                this._head_self = undefined
            }
            if (this._head_other) {
                this._head_other.DeleteMe()
                this._head_other = undefined
            }
            _time_ = undefined
            this.ClearTimer()
        }

        this.LoadSuccess = () => {
            this._head_self = new CustomHeadItem(this._head_self_con)
            this._head_self.Load()
            this._head_other = new CustomHeadItem(this._head_other_con)
            this._head_other.Load()

            _model.Fire(REQUEST_PROTO, 17232)
            _model.Fire(REQUEST_PROTO, 17250)
            res_mgr.SetTexture(this, this.img1, "resource/game/marriage/texture/uijh_081.png")
            res_mgr.SetTexture(this, this._img_bg, "resource/game/marriage/texture/uijh_090.png")
            res_mgr.SetTexture(this, this._img_086, "resource/game/marriage/texture/uijh_086.png")

            let role_vo = RoleManager.GetInstance().GetMainRoleVo()
            let frame_id = dress_model.GetDressByType(role_vo.dress_list, DressType.Photo)
            this._head_self.SetRoleVoData(role_vo)
            // this._head_self.setData(role_vo.level, role_vo.career, role_vo["picture"], undefined, undefined, frame_id)
            this._lb_name_self.text = role_vo.name
            //this._lb_power_self.text = `z${role_vo.fighting}`

            this.StartTimer()
            this.UpdateTimer()
        }

        this.InitEvent = () => {
            let banqModel = BanquetModel.GetInstance()
            Util.AddClickEvent(this._btn_go, () => {
                if (banqModel.canApply) {
                    GlobalEventSystem.Fire(EventName.OPEN_VIEW, "BanquetApplyView")
                }
                _model.Fire(REQUEST_PROTO, 17235, "c", 1)
                this.Close()
            }, this, true)

            Util.AddClickEvent(this._btn_close, () => {
                _model.Fire(REQUEST_PROTO, 17235, "c", 2)
                this.Close()
            }, this, true)

            this.BindVar(_model, "_mate_info", () => {
                this.UpdateMateData()
            })

            //结婚成功的时候 如果有婚宴预约次数 则显示的提示
            let SetMsg = () => {
                if (banqModel.canApply) {
                    this._lb_msg.text = `您当前有可预约的婚礼次数\n是否立即前往预约？`
                    this.labelDisplay11.text = `预约婚礼`
                    this.ClearTimer()
                }
            }
            this.BindEvent(banqModel, local_BanqEvent.APPLY_VIEW_DATA, SetMsg)
        }

        this.UpdateMateData = () => {
            let other_vo = _model.GetMateInfo()
            let frame_id = dress_model.GetDressByType(other_vo.dress_list, DressType.Photo)
            // this._head_other.setData(other_vo.lv, other_vo.career, other_vo["picture"], undefined, undefined, frame_id)
            this._head_other.SetRoleVoData(other_vo)
            this._lb_name_other.text = other_vo.name
            //this._lb_power_other.text = `z${other_vo.combat_power}`
        }

        this.StartTimer = () => {
            this.ClearTimer()
            var peorid_func = () => {
                if (!this.use_delete_method) {
                    this.UpdateTimer()
                }
            }
            _time_ = local_TimeUtil.getServerTime() + 30
            time_event_id_ = GlobalTimerQuest.AddPeriodQuest(peorid_func, 1, -1)
            peorid_func()
        }

        this.UpdateTimer = () => {
            let rtime = _time_ - local_TimeUtil.getServerTime()
            if (rtime <= 0) {
                this.ClearTimer()
                this.Close()
            } else {
                this.labelDisplay11.text = `确定(${rtime}s)`
            }
        }

        this.ClearTimer = () => {
            if (time_event_id_) {
                GlobalTimerQuest.CancelQuest(time_event_id_)
                time_event_id_ = null
            }
        }
    }

    public Open(...parms) {
        this.Local_Open(parms)
    }

    img1: Laya.Image
    _img_bg: Laya.Image
    img2: Laya.Image
    img3: Laya.Image
    _img_086: Laya.Image
    img4: Laya.Image
    _btn_go: Laya.Box
    _Image11: Laya.Image
    labelDisplay11: Laya.Label
    _btn_close: Laya.Box
    _Image1: Laya.Image
    labelDisplay: Laya.Label
    _lb_msg: Laya.Label
    group1: Laya.Box
    img6: Laya.Image
    _head_self_con: Laya.Box
    _lb_name_self: Laya.Label
    _lb_power_self: Laya.Label
    group2: Laya.Box
    img7: Laya.Image
    _head_other_con: Laya.Box
    _lb_name_other: Laya.Label
    _lb_power_other: Laya.Label
    public GetComponents() {
        [
            this.img1,
            this._img_bg,
            this.img2,
            this.img3,
            this._img_086,
            this.img4,
            this._btn_go,
            this._Image11,
            this.labelDisplay11,
            this._btn_close,
            this._Image1,
            this.labelDisplay,
            this._lb_msg,
            this.group1,
            this.img6,
            this._head_self_con,
            this._lb_name_self,
            this._lb_power_self,
            this.group2,
            this.img7,
            this._head_other_con,
            this._lb_name_other,
            this._lb_power_other,
        ]
            = this.GetChildrenByNames([

                "img1",
                "_img_bg",
                "img2",
                "img3",
                "_img_086",
                "img4",
                "_btn_go",
                "_Image11",
                "labelDisplay11",
                "_btn_close",
                "_Image1",
                "labelDisplay",
                "_lb_msg",
                "group1",
                "img6",
                "_head_self_con",
                "_lb_name_self",
                "_lb_power_self",
                "group2",
                "img7",
                "_head_other_con",
                "_lb_name_other",
                "_lb_power_other",
            ])
    }
}
window["MarriageSuccessView"] = MarriageSuccessView