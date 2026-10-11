import { Enum_UILayer } from "../common/LayerManager"
import { SevenDayView } from "../sevenDay/SevenDayView"

export class SevenMergeView extends SevenDayView {
  _img_bg: Laya.Image
  _img_title: Laya.Image
  img_reward_name: Laya.Image
  _btn_claim: Laya.Box
  _Image11: Laya.Image
  labelDisplay: Laya.Label
  _img_red: Laya.Image
  _Image1: Laya.Image
  _gp_effect1: Laya.Box
  _gp_model: Laya.Box
  _gp_model_effect: Laya.Box
  _scl_reward: Laya.Panel
  Content: Laya.HBox
  _Group1: Laya.Box
  _img_model: Laya.Image
  _lb_day: Laya.Label
  _img_close: Laya.Image
  _lb_name: Laya.Label
  login_day: Laya.Label
  location_y
  not_show_main_msg
  use_background
  public constructor() {
    super()


    this.base_file = "sevenMergeDay"
    this.layout_file = "SevenMergeView"
    this.use_background = true
    this.is_center = true
    this.layer_value = Enum_UILayer.Activity
    this.not_show_main_msg = true
    this.destroy_imm = true
    this.load_callback = () => {
      this._scl_reward.hScrollBar.visible = false
      this.location_y = this._img_model.y
    }
  }



  public GetComponents() {
    [
      this._img_bg,
      this._img_title,
      this.img_reward_name,
      this._btn_claim,
      this._Image11,
      this.labelDisplay,
      this._img_red,
      this._Image1,
      this._gp_effect1,
      this._gp_model,
      this._gp_model_effect,
      this._scl_reward,
      this.Content,
      this._gp_tab,
      this._Group1,
      this._img_model,
      this._lb_day,
      this._img_close,
      this._lb_name,
      this.login_day
    ]
      = this.GetChildrenByNames([

        "_img_bg",
        "_img_title",
        "img_reward_name",
        "_btn_claim",
        "_Image11",
        "labelDisplay",
        "_img_red",
        "_Image1",
        "_gp_effect1",
        "_gp_model",
        "_gp_model_effect",
        "_scl_reward",
        "Content",
        "_gp_tab",
        "_Group1",
        "_img_model",
        "_lb_day",
        "_img_close",
        "_lb_name",
        "login_day"
      ])
  }
}
window["SevenMergeView"] = SevenMergeView