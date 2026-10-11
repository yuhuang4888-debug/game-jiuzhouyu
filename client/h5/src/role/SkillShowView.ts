import { BaseView1 } from "../common/BaseView1"
import { Config } from "../common/Config"
import { Enum_UILayer, LayerManager } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { SkillUIModel } from "../commonModel/SkillUIModel"
import { GameResPath } from "../util/GameResPath"

export class SkillShowView extends BaseView1 {
  public _img_bg: Laya.Image;
  public _img_icon: Laya.Image;
  public _lb_name: Laya.Label;
  public _lb_desc: Laya.Label;

  _height
  _model
  _skill_id
  alpha
  destroy_callback
  horizontalCenter
  open_callback
  touchChildren
  touchEnabled
  y

  public constructor() {
    super()


    this._model = SkillUIModel.GetInstance();
    this.base_file = "role"
    this.layout_file = "SkillShowView"
    this.layer_value = Enum_UILayer.Activity
    this.horizontalCenter = 0
    let layer = LayerManager.GetInstance().GetUILayer(Enum_UILayer.Main)
    this._height = layer.height
    this.touchEnabled = false
    this.touchChildren = false
    this.load_callback = () => {
      this.LoadSuccess()
    }

    this.destroy_callback = () => {
      this.ClearAction()
    }

    this.open_callback = () => {
      this.y = this._height
      this.UpdateView()
      this.StartAction()
    }


  }

  public Open(...new_args) {

    this._skill_id = new_args
    super.Open()
  }

  public LoadSuccess() {

    ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("common", "uity_059"))
  }

  public UpdateView() {

    if (!this._skill_id) {
      return
    }
    // [ts2lua]Config.PRELOAD_SETVER_CONFIG.config_skill下标访问可能不正确
    // let cfg = Config.PRELOAD_SETVER_CONFIG.config_skill[this._skill_id]
    // if (!cfg) {
    //   return
    // }
    // this._lb_name.text = "解锁技能：" + cfg.name
    ResManager.GetInstance().SetOutsideImageSprite(this, this._img_icon, GameResPath.GetSkillIconPath(this._skill_id))
  }

  public StartAction() {

    this.ClearAction()
    this.alpha = 0
    Laya.Tween.to(this.display_obj, { y: this._height - 220, alpha: 1 }, 300).to(this.display_obj, { y: this._height - 300, alpha: 0 }, 300, null, Handler.create(this.display_obj, () => {
      close()
    }), 800)
  }

  public ClearAction() {

    Laya.Tween.clearAll(this.display_obj)
  }
}

window["SkillShowView"] = SkillShowView