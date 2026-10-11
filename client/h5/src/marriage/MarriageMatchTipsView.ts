import { BaseView1 } from "../common/BaseView1";
import { Enum_UILayer } from "../common/LayerManager";
// import { PlayerHead } from "../common/PlayerHead";
import { ResManager } from "../common/ResManager";
import { DressModel, DressType } from "../commonModel/DressModel";
import { TimeUtil } from "../util/TimeUtil";
import { Util } from "../util/Util";

export class MarriageMatchTipsView extends BaseView1 {
//   private _btn_close: eui.Button;
//   private _head_self: PlayerHead;
//   private _head_other: PlayerHead;
//   private _lb_name_self: eui.Label;
//   private _lb_name_other: eui.Label;
//   private _img_125: eui.Image;
//   private _lb_tips: eui.Label;
//   private _img_progress: eui.Image;
//   private _lb_time: eui.Label;
//   private _lb_tips_2: eui.Label;

//   Local_Open
//   Clear
//   LoadSuccess
//   InitEvent
//   GetDunDataByType
//   StartProTween
//   ClearTween
//   StartTimer
//   UpdateTimer
//   ClearTimer
//   public constructor() {
//       super()
//       this.base_file = "marriage";
//       this.dependent_res = ["marriage2"]
//       this.layout_file = "MarriageDunTipsView"
//       this.layer_value = Enum_UILayer.Activity;
//       this.is_center = true
//       this.use_background = true
//       // this.click_bg_toClose = true
//       this.show_open_movie = true
//       this.destroy_imm = true
//       this.change_scene_close = true

//       // let _model = BaseDungeonModel.GetInstance(),
//          let dress_model = DressModel.GetInstance(),
//           Photo = DressType.Photo,
//           local_egret = egret,
//           local_TimeUtil = TimeUtil,
//           _dun_vo_,
//           _time_,
//           _timer_: egret.Timer

//       this.load_callback = function () {
//           this.LoadSuccess()
//           this.InitEvent()
//       }

//       this.destroy_callback = function () {
//           this.Clear()
//       }
//       this.Local_Open = (parms) => {
//           [_dun_vo_] = parms
//           super.Open()
//       }

//       this.Clear = () => {
//           if (this._head_self) {
//               this._head_self.DeleteMe()
//               this._head_self = undefined
//           }
//           if (this._head_other) {
//               this._head_other.DeleteMe()
//               this._head_other = undefined
//           }
//           _time_ = undefined
//           this.ClearTimer()
//           this.ClearTween()
//       }

//       this.LoadSuccess = () => {
//           ResManager.GetInstance().SetTexture(this, this._img_125, "resource/game/marriage/texture/uijh_125.jpg")
//           this._lb_tips.text = "倒计时结束后进入副本"

//           let vo_1 = this.GetDunDataByType(1)
//           let frame_id = dress_model.GetDressByType(vo_1.dress_list, Photo)
//           this._head_self.setData(vo_1.level, vo_1.career, vo_1["picture"], undefined, undefined, frame_id)
//           this._lb_name_self.text = vo_1.name

//           let vo_2 = this.GetDunDataByType(2)
//           let frame_id2 = dress_model.GetDressByType(vo_2.dress_list, Photo)
//           this._head_other.setData(vo_2.lv, vo_2.career, vo_2["picture"], undefined, undefined, frame_id2)
//           this._lb_name_other.text = vo_2.name

//           let mask = new local_egret.Rectangle(0, 0, this._img_progress.width, this._img_progress.height)
//           this._img_progress.mask = mask

//           this.StartProTween()
//           this.StartTimer()
//           this.UpdateTimer()
//       }

//       this.InitEvent = () => {
//           Util.AddClickEvent(this._btn_close, () => {
//               this.Close()
//           }, this, true)
//       }

//       this.GetDunDataByType = (type) => {
//           if (!_dun_vo_) return
//           for (let data of _dun_vo_.list) {
//               if (data.type == type) {
//                   return data
//               }
//           }
//       }

//       this.StartProTween = () => {
//           this.ClearTween()
//           let time = _dun_vo_.enter_time - local_TimeUtil.getServerTime()
//           local_egret.Tween.get(this._img_progress.mask).to({ width: 0 }, time * 1000)
//       }

//       this.ClearTween = () => {
//           if (this._img_progress && this._img_progress.mask) {
//               local_egret.Tween.removeTweens(this._img_progress.mask)
//           }
//       }

//       this.StartTimer = () => {
//           this.ClearTimer()
//           _time_ = _dun_vo_.enter_time
//           _timer_ = new local_egret.Timer(1000, 0)
//           _timer_.addEventListener(local_egret.TimerEvent.TIMER, this.UpdateTimer, this)
//           _timer_.start()
//       }

//       this.UpdateTimer = () => {
//           let rtime = _time_ - local_TimeUtil.getServerTime()
//           if (rtime <= 0) {
//               this.ClearTimer()
//               this.Close()
//           } else {
//               this._lb_time.text = local_TimeUtil.timeConvert(rtime, "mm:ss")
//           }
//       }

//       this.ClearTimer = () => {
//           if (_timer_) {
//               _timer_.stop()
//               _timer_.removeEventListener(local_egret.TimerEvent.TIMER, this.UpdateTimer, this)
//               _timer_ = undefined
//           }
//       }
//   }


//   public Open(...parms) {
//       this.Local_Open(parms)
//   }
}

window["MarriageMatchTipsView"] = MarriageMatchTipsView