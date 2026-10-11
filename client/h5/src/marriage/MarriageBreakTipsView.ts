import { BaseView1 } from "../common/BaseView1";
import { CustomHeadItem } from "../common/CustomHeadItem";
import { Enum_UILayer } from "../common/LayerManager";
// import { PlayerHead } from "../common/PlayerHead";
import { ResManager } from "../common/ResManager";
import { DressModel, DressType } from "../commonModel/DressModel";
import { MarriageEvent, MarriageModel } from "../commonModel/MarriageModel";
import { RoleManager } from "../commonModel/RoleManager";
import { GameResPath } from "../util/GameResPath";
import { TimeUtil } from "../util/TimeUtil";
import { GlobalTimerQuest, Util } from "../util/Util";

//伴侣-离婚界面
export class MarriageBreakTipsView extends BaseView1 {
    

    private _head_self: CustomHeadItem;
    private _head_other: CustomHeadItem;

    Local_Open
    Clear
    LoadSuccess
    StartTimer
    UpdateTimer
    ClearTimer
    InitEvent
    public constructor() {
        super()
        this.base_file = "marriage";
        this.dependent_res = ["marriage2"]
        this.layout_file = "MarriageBreakTipsView"
        this.layer_value = Enum_UILayer.Activity;
        this.is_center = true
        this.use_background = true
        // this.click_bg_toClose = true
        this.show_open_movie = true
        this.destroy_imm = true

        let _model = MarriageModel.GetInstance(),
            res_mgr = ResManager.GetInstance(),
            dress_model = DressModel.GetInstance(),
            Photo = DressType.Photo,
            local_Util = Util,
            REQUEST_PROTO = MarriageEvent.REQUEST_PROTO,
            // local_egret = egret,
            local_TimeUtil = TimeUtil,
            _other_vo_,
            _time_,
            _timer_

        this.load_callback = function () {
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

            res_mgr.SetTexture(this, this._img_bg, "resource/game/marriage/texture/uijh_090.png")
            // res_mgr.SetTexture(this, this._img_086, "resource/game/marriage/texture/uijh_086.png")

            let role_vo = RoleManager.GetInstance().GetMainRoleVo()
            let frame_id = dress_model.GetDressByType(role_vo.dress_list, Photo)
            // this._head_self.setData(role_vo.level, role_vo.career, role_vo["picture"], undefined, undefined, frame_id)
            this._head_self.SetRoleVoData(role_vo)

            this._lb_name_self.text = role_vo.name
            this._lb_power_self.text = `z${role_vo.fighting}`

            let other_vo = _other_vo_
            let frame_id2 = dress_model.GetDressByType(other_vo.dress_list, Photo)
            // this._head_other.setData(other_vo.lv, other_vo.career, other_vo["picture"], undefined, undefined, frame_id2)
            this._head_other.SetRoleVoData(other_vo)

            this._lb_name_other.text = other_vo.name
            this._lb_power_other.text = `z${other_vo.combat_power}`

            this.StartTimer()
            this.UpdateTimer()
        }

        this.InitEvent = () => {
            local_Util.AddClickEvent(this._btn_go, () => {
                _model.Fire(REQUEST_PROTO, 17235, "c", 1)
                this.Close()
            }, this, true)

            local_Util.AddClickEvent(this._btn_cancel, () => {
                _model.Fire(REQUEST_PROTO, 17235, "c", 2)
                this.Close()
            }, this, true)

            local_Util.AddClickEvent(this._btn_close, () => {
                _model.Fire(REQUEST_PROTO, 17235, "c", 2)
                this.Close()
            }, this, true)

            // this.BindEvent(_model, "", () => {
            //     this.UpdateView()
            // })
        }

        this.StartTimer = () => {
            this.ClearTimer()
            _time_ = local_TimeUtil.getServerTime() + 30

            var peorid_func = () => {
                if (!this.use_delete_method) {
                    this.UpdateTimer()
                }
            }
            _timer_ = GlobalTimerQuest.AddPeriodQuest(peorid_func, 1, -1)
            peorid_func()
        }

        this.UpdateTimer = () => {
            let rtime = _time_ - local_TimeUtil.getServerTime()
            if (rtime <= 0) {
                this.ClearTimer()
                _model.Fire(REQUEST_PROTO, 17235, "c", 2)
                this.Close()
            } else {
                this.labelDisplay1.text = `我拒绝(${rtime}s)`
            }
        }

        this.ClearTimer = () => {
            if (_timer_) {
                GlobalTimerQuest.CancelQuest(_timer_)
                _timer_ = null
            }
        }
    }

    public Open(...parms) {
        this.Local_Open(parms)
    }

    _Image1: Laya.Image
    _img_bg: Laya.Image
    _Image2: Laya.Image
    _Image3: Laya.Image
    _img_086: Laya.Image
    _Image4: Laya.Image
    _Group1: Laya.HBox
    _btn_cancel: Laya.Box
    _Image111: Laya.Image
    labelDisplay1: Laya.Label
    _btn_go: Laya.Box
    _Image11: Laya.Image
    labelDisplay11: Laya.Label
    _btn_close: Laya.Box
    _Image1111: Laya.Image
    labelDisplay: Laya.Label
    _lb_msg: Laya.Label
    _Group2: Laya.Box
    _Image5: Laya.Image
    _head_self_con: Laya.Box
    _lb_name_self: Laya.Label
    _lb_power_self: Laya.Label
    _Group3: Laya.Box
    _Image6: Laya.Image
    _head_other_con: Laya.Box
    _lb_name_other: Laya.Label
    _lb_power_other: Laya.Label
    public GetComponents() {
        [
            this._Image1,
            this._img_bg,
            this._Image2,
            this._Image3,
            this._img_086,
            this._Image4,
            this._Group1,
            this._btn_cancel,
            this._Image111,
            this.labelDisplay1,
            this._btn_go,
            this._Image11,
            this.labelDisplay11,
            this._btn_close,
            this._Image1111,
            this.labelDisplay,
            this._lb_msg,
            this._Group2,
            this._Image5,
            this._head_self_con,
            this._lb_name_self,
            this._lb_power_self,
            this._Group3,
            this._Image6,
            this._head_other_con,
            this._lb_name_other,
            this._lb_power_other,
        ]
            = this.GetChildrenByNames([

                "_Image1",
                "_img_bg",
                "_Image2",
                "_Image3",
                "_img_086",
                "_Image4",
                "_Group1",
                "_btn_cancel",
                "_Image111",
                "labelDisplay1",
                "_btn_go",
                "_Image11",
                "labelDisplay11",
                "_btn_close",
                "_Image1111",
                "labelDisplay",
                "_lb_msg",
                "_Group2",
                "_Image5",
                "_head_self_con",
                "_lb_name_self",
                "_lb_power_self",
                "_Group3",
                "_Image6",
                "_head_other_con",
                "_lb_name_other",
                "_lb_power_other",
            ])
    }
}
window["MarriageBreakTipsView"] = MarriageBreakTipsView