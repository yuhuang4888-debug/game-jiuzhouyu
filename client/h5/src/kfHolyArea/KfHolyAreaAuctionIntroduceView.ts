import { BaseView1 } from "../common/BaseView1"
import { KfHolyAreaModel } from "../commonModel/KfHolyAreaModel"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class KfHolyAreaAuctionIntroduceView extends BaseView1 {
  Scr_Scroller1
  change_scene_close
  click_bg_toClose
  data
  destroy_callback
  destroy_imm
  is_center
  model
  show_open_movie
  use_background

  public constructor() {
    super()


    this.base_file = "kfHolyArea"
    this.layout_file = "KfHolyAreaAuctionIntroduceView"
    this.model = KfHolyAreaModel.GetInstance()
    this.layer_value = Enum_UILayer.Activity
    this.show_open_movie = true
    this.is_center = true
    this.destroy_imm = true
    this.change_scene_close = true
    this.use_background = true
    this.click_bg_toClose = true
    this.load_callback = () => {
      this.LoadSuccess()
    }

    this.destroy_callback = () => { }
  }

  public Open(...new_args) {

    if (new_args) {
      this.data = new_args[0]
    }
    super.Open()
  }

  public LoadSuccess() {

    let tip_str = "参与玩法可获得全服拍卖品\n拍卖所得<font color='#639c12'>全额以分红形式</font>返还给参与者"
    let detail_str = "1.<font color='#639c12'>占领要塞</font>可获得要塞拍卖品，只要参与玩法即可参与分红，参与人数越多拍卖品越丰厚。\n2.<font color='#639c12'>击杀境门和异域怪物</font>可获得稀有拍卖品。需要在城堡和异域中参战才能参与分红。"
    let activity_time_str = "<font color='#b55d31'>活动时间：</font><font color='#387800'>每轮刷新后的</font><font color='#639c12'>30分钟</font><font color='#387800'>内</font>"
    ResManager.GetInstance().SetOutsideImageSprite(this, this.bg_img, GameResPath.GetIcon("kfHolyArea", "uiswgh_001"))
    ResManager.GetInstance().SetImageSpriteTrans(this, this.introduce_bg_img, GameResPath.GetIcon("kfHolyArea", "uiswgh_002"))
    // this.detail_lb.textFlow = Util.StrToHTML(detail_str)
    // this.time_lb.textFlow = Util.StrToHTML(activity_time_str)
    // this.tip_lb.textFlow = Util.StrToHTML(tip_str)
    this.detail_lb.text = Util.StrToHTML(detail_str)
    this.time_lb.text = Util.StrToHTML(activity_time_str)
    this.tip_lb.text = Util.StrToHTML(tip_str)
    this.InitEvent()
    this.UpdateView()
  }

  public InitEvent() {

    Util.AddClickEvent(this.rank_img, () => {
      this.model.Fire(KfHolyAreaModel.REQUEST_CCMD_EVENT, 28419)
      this.Close()
    }
      , this, true)
    Util.AddClickEvent(this.know_gp, () => {
      this.Close()
    }
      , this, true)
    Util.AddClickEvent(this.intrduce_img, () => {
      this.model.Fire(KfHolyAreaModel.OPEN_VIEW, "KfHolyAreaAuctionIntroduceToPlayView")
      this.Close()
    }
      , this, true)
  }

  public UpdateView() {
  }

  bg_img: Laya.Image
  _Image1: Laya.Image
  _Image2: Laya.Image
  _Group1: Laya.Box
  time_lb: Laya.Label
  _Group3: Laya.Box
  introduce_bg_img: Laya.Image
  _Label1: Laya.Label
  _Scroller1: Laya.Panel
  Content: Laya.Box
  detail_lb: Laya.Label
  tip_lb: Laya.Label
  rank_img: Laya.Image
  intrduce_img: Laya.Image
  know_gp: Laya.Box
  _Image3: Laya.Image
  _Label2: Laya.Label
  public GetComponents() {
    [
      this.bg_img,
      this._Image1,
      this._Image2,
      this._Group1,
      this.time_lb,
      this._Group3,
      this.introduce_bg_img,
      this._Label1,
      this._Scroller1,
      this.Content,
      this.detail_lb,
      this.tip_lb,
      this.rank_img,
      this.intrduce_img,
      this.know_gp,
      this._Image3,
      this._Label2,
    ]
      = this.GetChildrenByNames([

        "bg_img",
        "_Image1",
        "_Image2",
        "_Group1",
        "time_lb",
        "_Group3",
        "introduce_bg_img",
        "_Label1",
        "_Scroller1",
        "Content",
        "detail_lb",
        "tip_lb",
        "rank_img",
        "intrduce_img",
        "know_gp",
        "_Image3",
        "_Label2",
      ])
  }
}
window["KfHolyAreaAuctionIntroduceView"] = KfHolyAreaAuctionIntroduceView