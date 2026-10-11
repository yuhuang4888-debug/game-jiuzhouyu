import { BaseView1 } from "../common/BaseView1";
import { Enum_UILayer } from "../common/LayerManager";
import { ResManager } from "../common/ResManager";
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel";
import { MarriageEvent, MarriageModel } from "../commonModel/MarriageModel";
import { Message } from "../sysInfo/SysInfoController";
import { GameResPath } from "../util/GameResPath";
import { TimeUtil } from "../util/TimeUtil";
import { GlobalTimerQuest, Util } from "../util/Util";
import { MarriageDunLuckBtn } from "./MarriageDunLuckBtn";

//伴侣-副本答题界面
export class MarriageDunLuckView extends BaseView1 {

    Local_Open
    Clear
    LoadSuccess
    InitEvent
    UpdateBtns
    SelectRadioBtn
    StartTimer
    UpdateTimer
    ClearTimer
    answer_list
    public constructor() {
        super()
        this.base_file = "marriage";
        this.dependent_res = ["marriage2"]
        this.layout_file = "MarriageDunLuckView"
        this.layer_value = Enum_UILayer.Activity;
        this.is_center = true
        // this.use_background = true
        // this.click_bg_toClose = true
        this.show_open_movie = true
        this.destroy_imm = true
        this.back_login_toClose = true

        let _model = BaseDungeonModel.GetInstance(),
        local_Util = Util,
            res_mgr = ResManager.GetInstance(),
            local_Message = Message,
            // local_egret = egret,
            _question_vo_,
            _time_,
            _timer_: Laya.Timer,
            _cur_answer_,
            _is_answer_ = false,
            _question_cfg_,
            _btn_list_

        this.load_callback = function () {
            this.LoadSuccess()
        }
        this.destroy_callback = function () {
            this.Clear()
        }

        this.Local_Open = (parms) => {
            [_question_vo_] = parms
            super.Open()
        }

        this.Clear = () => {
            _time_ = undefined
            _btn_list_ = undefined
            _cur_answer_ = undefined
            this.ClearTimer()
            // this._radioGroup.removeEventListener(eui.UIEvent.CHANGE, this.SelectRadioBtn, this)
        }

        this.LoadSuccess = async () => {
            ResManager.GetInstance().SetOutsideImageSprite(this, this._Image11111, GameResPath.GetIcon("marriage", "ui_marry_17"))
            _question_cfg_ = await res_mgr.LoadGameConfig(this, "config_dungeon_question", false)
            if (this.use_delete_method) {
                res_mgr.DestroyAllReferenceRes(this.hashCode)
                return
            }

            // this._radioGroup = new eui.RadioButtonGroup()
            // this._radioGroup.addEventListener(eui.UIEvent.CHANGE, this.SelectRadioBtn, this)

            _btn_list_ = []
            let item
            for (let i = 0; i < 4; i++) {
                item = new MarriageDunLuckBtn(this._group_btn)
                _btn_list_[i] = item
                item.Load()
                item.SetPosition(i % 2 * 165, Math.floor(i / 2) * 100)
            }
            // for (let i = 0; i < this._group_btn.numChildren; i++) {
            //     let btn = this._group_btn.getChildAt(i) as MarriageDunLuckBtn
            //     btn.group = this._radioGroup
            //     _btn_list_[i] = btn
            // }

            let vo = _question_vo_
            let cfg = _question_cfg_[`${vo.dun_id}@${vo.question_id}`]
            if (cfg) {
                this._lb_content111.text = cfg.question
                let answer_list = JSON.parse(cfg.answers)
                this.UpdateBtns(answer_list)
            }

            this.StartTimer()
            this.UpdateTimer()

            this.InitEvent()
        }

        this.InitEvent = () => {
            let click_fun = (index) => {
                if (!this.use_delete_method) {
                    this.SelectRadioBtn(index)
                }
            }
            this.BindEvent(MarriageModel.GetInstance(), MarriageEvent.DUN_TAB_BTN_CLICK, click_fun)

            local_Util.AddClickEvent(this._btn_go, () => {
                // if (_is_answer_) { local_Message.show("您已完成选择"); return; }
                if (!_cur_answer_) { local_Message.show("您还没选择"); return; }
                _is_answer_ = true
                _model.Fire(BaseDungeonModel.SCMD_REQUEST, 61090, _cur_answer_)
                this._btn_gray.visible = true
                this._btn_go.visible = false
                local_Util.SetImageGray(this._img_gray, true)
                // this._radioGroup.enabled = false
            }, this, true)

            local_Util.AddClickEvent(this._btn_gray, () => {
                local_Message.show("您已完成选择")
            }, this, true)

            local_Util.AddClickEvent(this._btn_close, () => {
                this.Close()
            }, this, true)

        }

        this.UpdateBtns = (list) => {
            if (!list || list.length < 1) return

            this.answer_list = list
            let item
            for (let i = 0; i < _btn_list_.length; i++) {
                item = _btn_list_[i]
                if (item){
                    item.SetVisible(false)
                }
            }

            // let count_list = []
            // for (let i = 0; i < list.length; i++) {
            //     count_list.push(i)
            // }

            // while (count_list.length > 0) {
            //     let i = local_Util.RandomRange(0, count_list.length - 1)
            //     let index = count_list[i]
            //     let btn = _btn_list_[index] as MarriageDunLuckBtn
            //     if (!btn) continue
            //     btn._lb_content.text = list[index]
            //     btn.content = list[index]
            //     btn.visible = true
            //     count_list.splice(i, 1)
            // }

            for (let i = 0; i < list.length; i++) {
                let btn = _btn_list_[i] as MarriageDunLuckBtn
                if (!btn) continue
                btn.SetData(list[i], i)
                btn.SetVisible(true)
            }
            // for (let i = list.length; i < _btn_list_.length; i++) {
            //     let btn = _btn_list_[i]
            //     btn.visible = false
            // }
        }

        this.SelectRadioBtn = (index) => {
            // let index = Number(this._radioGroup.selectedValue)
            if (!this.answer_list || !this.answer_list[index]){
                return
            }
            _cur_answer_ = this.answer_list[index]
            // let btn = this._radioGroup.selection as MarriageDunLuckBtn
            // _cur_answer_ = btn.content
        }

        this.StartTimer = () => {
            this.ClearTimer()
            _time_ = _question_vo_.end_time
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
            let rtime = _time_ - TimeUtil.getServerTime()
            if (rtime <= 0) {
                this.ClearTimer()
                this.Close()
            } else {
                this._lb_time.text = `${rtime}s`
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

    _Image11111: Laya.Image
    _Image3: Laya.Image
    _btn_close: Laya.Image
    _Label1: Laya.Label
    _lb_content111: Laya.Label
    _Label2: Laya.Label
    _lb_time: Laya.Label
    _btn_go: Laya.Box
    _Image1: Laya.Image
    labelDisplay: Laya.Label
    _btn_gray: Laya.Box
    _img_gray: Laya.Image
    _Label3: Laya.Label
    _group_btn: Laya.Box
    public GetComponents() {
        [
            this._Image11111,
            this._Image3,
            this._btn_close,
            this._Label1,
            this._lb_content111,
            this._Label2,
            this._lb_time,
            this._btn_go,
            this._Image1,
            this.labelDisplay,
            this._btn_gray,
            this._img_gray,
            this._Label3,
            this._group_btn,
        ]
            = this.GetChildrenByNames([

                "_Image11111",
                "_Image3",
                "_btn_close",
                "_Label1",
                "_lb_content111",
                "_Label2",
                "_lb_time",
                "_btn_go",
                "_Image1",
                "labelDisplay",
                "_btn_gray",
                "_img_gray",
                "_Label3",
                "_group_btn",
            ])
    }
}
window["MarriageDunLuckView"] = MarriageDunLuckView