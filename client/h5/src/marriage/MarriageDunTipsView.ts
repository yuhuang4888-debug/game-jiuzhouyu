import { BaseView1 } from "../common/BaseView1";
import { CustomHeadItem } from "../common/CustomHeadItem";
import { Enum_UILayer } from "../common/LayerManager";
// import { PlayerHead } from "../common/PlayerHead";
import { ResManager } from "../common/ResManager";
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel";
import { DressModel, DressType } from "../commonModel/DressModel";
import { MarriageModel } from "../commonModel/MarriageModel";
import { RoleManager } from "../commonModel/RoleManager";
import { GameResPath } from "../util/GameResPath";
import { TimeUtil } from "../util/TimeUtil";
import { GlobalTimerQuest, SetHtmlCenter, Util } from "../util/Util";

//伴侣-邀请副本界面
export class MarriageDunTipsView extends BaseView1 {

    Local_Open
    Clear
    LoadSuccess
    InitEvent
    GetDunDataByType
    StartProTween
    ClearTween
    StartTimer
    UpdateTimer
    ClearTimer
    _head_self: CustomHeadItem
    _head_other: CustomHeadItem
    public constructor() {
        super()
        this.base_file = "marriage";
        this.dependent_res = ["marriage2"]
        this.layout_file = "MarriageDunTipsView"
        this.layer_value = Enum_UILayer.Activity;
        this.is_center = true
        this.use_background = true
        // this.click_bg_toClose = true
        this.show_open_movie = true
        this.destroy_imm = true
        this.change_scene_close = true

        let _model = BaseDungeonModel.GetInstance(),
        dress_model = DressModel.GetInstance(),
            Photo = DressType.Photo,
            local_Util = Util,
            // local_egret = egret,
            SCMD_REQUEST = BaseDungeonModel.SCMD_REQUEST,
            local_TimeUtil = TimeUtil,
            _dun_vo_,
            _time_,
            _timer_: Laya.Timer,
            _is_initiative_ = false,
            _count_down_ = 12

        this.load_callback = function () {
            ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1111, GameResPath.GetIcon("marriage", "ui_marry_17"))
            ResManager.GetInstance().SetOutsideImageSprite(this, this._img_125, GameResPath.GetIconJpg("marriage", "uijh_1251"), true)
            this.LoadSuccess()
            this.InitEvent()
        }

        this.destroy_callback = function () {
            this.Clear()
        }
        this.Local_Open = (parms) => {
            [_dun_vo_] = parms
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
            _is_initiative_ = false
            this.ClearTimer()
            this.ClearTween()
        }

        this.LoadSuccess = () => {
            this._head_self = new CustomHeadItem(this._head_self_con)
            this._head_self.Load()
            this._head_other = new CustomHeadItem(this._head_other_con)
            this._head_other.Load()

            ResManager.GetInstance().SetTexture(this, this._img_125, "resource/game/marriage/texture/uijh_1251.jpg")
            this._lb_tips_2.visible = true
            this._img_ready.visible = true

            let vo_1 = this.GetDunDataByType(1)
            let frame_id = dress_model.GetDressByType(vo_1.dress_list, Photo)
            // this._head_self.SetData(vo_1.level, vo_1.career, vo_1["picture"], undefined, undefined, frame_id)
            this._head_self.SetRoleVoData(vo_1)
            this._lb_name_self.text = vo_1.name

            let vo_2 = this.GetDunDataByType(2)
            let frame_id2 = dress_model.GetDressByType(vo_2.dress_list, Photo)
            // this._head_other.SetData(vo_2.lv, vo_2.career, vo_2["picture"], undefined, undefined, frame_id2)
            this._head_other.SetRoleVoData(vo_2)
            this._lb_name_other.text = vo_2.name

            let role_vo = RoleManager.GetInstance().GetMainRoleVo()
            let is_initiative = vo_1.role_id == role_vo.role_id     //是否邀请方
            this._btn_cancel.visible = is_initiative
            this._btn_refuse.visible = !is_initiative
            this._btn_go.visible = !is_initiative
            this._btn_gray.visible = is_initiative

            this._lb_tips.style.color = "#ffffff"
            this._lb_tips.style.fontSize = 20
            this._lb_tips.style.align = "center"
            this._lb_tips.style.valign = "middle"
            this._lb_tips.width = 300
            
            if (is_initiative) {
                local_Util.SetImageGray(this._img_gray, is_initiative)
                this._lb_tips.innerHTML = "已向对方发起邀请等待对方确认"
            } else {
                let info = MarriageModel.GetInstance().GetDunInfo()
                if (info) {
                    let dun_name = local_Util.HtmlColorTxt(info.name, "'#fae50a'")
                    let str = `对方邀请您将要进行${dun_name} 是否前往?`
                    this._lb_tips.innerHTML = local_Util.StrToHTML(str)
                }
            }
            SetHtmlCenter(this._lb_tips, {"x":0, "w":720})

            _is_initiative_ = is_initiative

            // let mask = new local_egret.Rectangle(0, 0, this._img_progress.width, this._img_progress.height)
            // this._img_progress.mask = mask

            this.StartProTween()
            this.StartTimer()
            this.UpdateTimer()
        }

        this.InitEvent = () => {
            local_Util.AddClickEvent(this._btn_go, () => {
                let vo = _dun_vo_
                let vo_1 = this.GetDunDataByType(1)
                _model.Fire(SCMD_REQUEST, 61047, vo.dun_id, vo_1.role_id, 1)
                this.Close()
            }, this, true)


            local_Util.AddClickEvent(this._btn_refuse, () => {
                let vo = _dun_vo_
                let vo_1 = this.GetDunDataByType(1)
                _model.Fire(SCMD_REQUEST, 61047, vo.dun_id, vo_1.role_id, 2)
                this.Close()
            }, this, true)

            local_Util.AddClickEvent(this._btn_cancel, () => {
                let vo_2 = this.GetDunDataByType(2)
                _model.Fire(SCMD_REQUEST, 61046, 2, _dun_vo_.dun_id, vo_2.role_id)
                this.Close()
            }, this, true)

            local_Util.AddClickEvent(this._btn_gray, () => {

            }, this, true)

            local_Util.AddClickEvent(this._btn_close, () => {
                if (_is_initiative_) {
                    let vo_2 = this.GetDunDataByType(2)
                    _model.Fire(SCMD_REQUEST, 61046, 2, _dun_vo_.dun_id, vo_2.role_id)
                } else {
                    let vo = _dun_vo_
                    let vo_1 = this.GetDunDataByType(1)
                    _model.Fire(SCMD_REQUEST, 61047, vo.dun_id, vo_1.role_id, 2)
                }
                this.Close()
            }, this, true)

            // this.BindEvent(_model, "", () => {
            //     this.UpdateView()
            // })
        }

        this.GetDunDataByType = (type) => {
            if (!_dun_vo_) return
            for (let data of _dun_vo_.list) {
                if (data.type == type) {
                    return data
                }
            }
        }

        this.StartProTween = () => {
            this.ClearTween()
            Laya.Tween.to(this._img_progress, { width: 0}, _count_down_ * 1000)
        }

        this.ClearTween = () => {
            if (this._img_progress) {
                Laya.Tween.clearAll(this._img_progress)
            }
        }

        this.StartTimer = () => {
            this.ClearTimer()
            _time_ = local_TimeUtil.getServerTime() + _count_down_
            var peorid_func = () => {
                if (!this.use_delete_method) {
                    this.UpdateTimer()
                }
            }
            _timer_ = GlobalTimerQuest.AddPeriodQuest(peorid_func, 1, -1)
            peorid_func()
            
            // _timer_ = new local_egret.Timer(1000, 0)
            // _timer_.addEventListener(local_egret.TimerEvent.TIMER, this.UpdateTimer, this)
            // _timer_.start()
        }

        this.UpdateTimer = () => {
            let rtime = _time_ - local_TimeUtil.getServerTime()
            if (rtime <= 0) {
                let vo = _dun_vo_
                let vo_1 = this.GetDunDataByType(1)
                if (!_is_initiative_) {
                    _model.Fire(SCMD_REQUEST, 61047, vo.dun_id, vo_1.role_id, 1)
                }
                this.ClearTimer()
                this.Close()
            } else {
                this._lb_time.text = local_TimeUtil.timeConvert(rtime, "mm:ss")
            }
        }

        this.ClearTimer = () => {
            if (_timer_) {
                GlobalTimerQuest.CancelQuest(_timer_)
                _timer_ = null
            }
            // if (_timer_) {
            //     _timer_.stop()
            //     _timer_.removeEventListener(local_egret.TimerEvent.TIMER, this.UpdateTimer, this)
            //     _timer_ = undefined
            // }
        }
    }

    public Open(...parms) {
        this.Local_Open(parms)
    }

    _Image1111: Laya.Image
    _img_125: Laya.Image
    _Image3: Laya.Image
    _btn_close: Laya.Image
    _lb_tips_2: Laya.Label
    _lb_tips: Laya.HTMLDivElement
    _Group1: Laya.Box
    _Image5: Laya.Image
    _head_self_con: Laya.Box
    _lb_name_self: Laya.Label
    _img_ready: Laya.Image
    _Group2: Laya.Box
    _Image6: Laya.Image
    _head_other_con: Laya.Box
    _lb_name_other: Laya.Label
    _Group3: Laya.Box
    _Image7: Laya.Image
    _img_progress: Laya.Image
    _lb_time: Laya.Label
    _btn_gray: Laya.Box
    _img_gray: Laya.Image
    _Label1: Laya.Label
    _btn_go: Laya.Box
    _Image111: Laya.Image
    labelDisplay: Laya.Label
    _btn_refuse: Laya.Box
    _Image1: Laya.Image
    labelDisplay11: Laya.Label
    _btn_cancel: Laya.Box
    _Image11: Laya.Image
    labelDisplay1: Laya.Label
    public GetComponents() {
        [
            this._Image1111,
            this._img_125,
            this._Image3,
            this._btn_close,
            this._lb_tips_2,
            this._lb_tips,
            this._Group1,
            this._Image5,
            this._head_self_con,
            this._lb_name_self,
            this._img_ready,
            this._Group2,
            this._Image6,
            this._head_other_con,
            this._lb_name_other,
            this._Group3,
            this._Image7,
            this._img_progress,
            this._lb_time,
            this._btn_gray,
            this._img_gray,
            this._Label1,
            this._btn_go,
            this._Image111,
            this.labelDisplay,
            this._btn_refuse,
            this._Image1,
            this.labelDisplay11,
            this._btn_cancel,
            this._Image11,
            this.labelDisplay1,
        ]
            = this.GetChildrenByNames([

                "_Image1111",
                "_img_125",
                "_Image3",
                "_btn_close",
                "_lb_tips_2",
                "_lb_tips",
                "_Group1",
                "_Image5",
                "_head_self_con",
                "_lb_name_self",
                "_img_ready",
                "_Group2",
                "_Image6",
                "_head_other_con",
                "_lb_name_other",
                "_Group3",
                "_Image7",
                "_img_progress",
                "_lb_time",
                "_btn_gray",
                "_img_gray",
                "_Label1",
                "_btn_go",
                "_Image111",
                "labelDisplay",
                "_btn_refuse",
                "_Image1",
                "labelDisplay11",
                "_btn_cancel",
                "_Image11",
                "labelDisplay1",
            ])
    }
}
window["MarriageDunTipsView"] = MarriageDunTipsView