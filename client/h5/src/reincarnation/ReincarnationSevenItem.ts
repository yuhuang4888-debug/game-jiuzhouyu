import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { ReincarnationModel } from "../commonModel/ReincarnationModel"
import { Util } from "../util/Util"

export class ReincarnationSevenItem extends BaseItem1 {
  id
  is_red
  model
  need_refresh
  need_setRed
  select_cache
  select_state
  state
  sub_index
  vo

  public constructor(parent?) {
    super(parent)


    this.id = 0;
    this.need_refresh = false;
    this.need_setRed = false;
    this.model = ReincarnationModel.GetInstance();
    this.base_file = "reincarnation"
    this.layout_file = "ReincarnationSevenItem"
    this.load_callback = () => {

      this.LoadSuccess()
    }


  }

  public LoadSuccess() {


    if (this.need_refresh) {
      this.SetState(this.state)
    }
    if (this.select_cache) {
      this.SetSelect(this.select_state)
      this.select_cache = false
    }
    if (this.need_setRed) {
      this.SetRedDot(this.is_red)
    }
    ResManager.GetInstance().SetImageSprite(this, this.icon_bg, "reincarnation_asset", "seven_img" + this.sub_index)
    this.InitEvent()
  }

  public InitEvent() {


    let ClickFunc = () => {
      if (this.vo) {
        this.vo.state = this.state
        this.model.Fire(ReincarnationModel.OPEN_TIPS_VIEW, this.vo)
      }
    }

    Util.AddClickEvent(this.con, ClickFunc, this, false)
  }

  
	public SetData(vo?, turn?) {
		this.vo = vo
		this.vo.turn = turn
		this.id = vo.id
	}

  public SetState(state?) {


    this.state = state
    if (this.is_loaded) {
      this.red_dot.visible = false
      this.ClearUIEffect(this.effectGp)
      if (this.state == 0) {

      } else if (this.state == 1) {
        let can_awaken = this.model.CellCanAwake(this.vo.id)
        if (can_awaken) {
          this.red_dot.visible = true
          this.AddUIEffect("UI_1127_01", this.effectGp, null, null, true)
        }
      }
      else if (this.state == 2) {

      }
      this.select_img.visible = this.state == 1
      Util.SetImageGray(this.icon_bg, this.state != 2)
      this.gray_bg.visible = this.state != 2
      this.active_bg.visible = this.state == 2
    } else {
      this.need_refresh = true
    }
  }

  public SetSelect(bool?) {


    this.select_state = bool
    if (this.is_loaded) {
      if (bool) {
        this.select_img.visible = true
      } else {
        this.select_img.visible = false
      }
    } else {
      this.select_cache = true
    }
  }

  public SetRedDot(bool?) {


    this.is_red = bool
    if (this.is_loaded) {
      if (bool) {
        this.red_dot.visible = true
        this.AddUIEffect("UI_1127_01", this.effectGp, null, null, true)
      } else {
        this.red_dot.visible = false
        this.ClearUIEffect(this.effectGp)
      }
    } else {
      this.need_setRed = true
    }
  }


  public SetIndex(max_index_?) {

    this.sub_index = max_index_
  }


  public ReOpen_callback() {

    if (this.state == 1) {
      this.AddUIEffect("UI_1127_03", this.effectGp, null, null, true)
    }
  }
  con: Laya.Box
  active_bg: Laya.Image
  gray_bg: Laya.Image
  icon_bg: Laya.Image
  select_img: Laya.Image
  effectGp: Laya.Box
  red_dot: Laya.Image
  public GetComponents() {
    [
      this.con,
      this.active_bg,
      this.gray_bg,
      this.icon_bg,
      this.select_img,
      this.effectGp,
      this.red_dot,
    ]
      = this.GetChildrenByNames([

        "con",
        "active_bg",
        "gray_bg",
        "icon_bg",
        "select_img",
        "effectGp",
        "red_dot",
      ])
  }
}
window["ReincarnationSevenItem"] = ReincarnationSevenItem