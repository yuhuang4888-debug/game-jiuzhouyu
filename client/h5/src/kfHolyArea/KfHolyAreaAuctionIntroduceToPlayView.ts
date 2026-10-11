import { BaseView1 } from "../common/BaseView1"
import { KfHolyAreaModel } from "../commonModel/KfHolyAreaModel"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class KfHolyAreaAuctionIntroduceToPlayView extends BaseView1 {
  bg_img: Laya.Image
  _Group1: Laya.Box
  _Image1: Laya.Image
  _Image2: Laya.Image
  _Image3: Laya.Image
  close_img: Laya.Image
  _Group10: Laya.Box
  _Group3: Laya.Box
  one_img: Laya.Image
  _Group2: Laya.Box
  _Image4: Laya.Image
  _Image5: Laya.Image
  _Label1: Laya.Label
  one_lb: Laya.Label
  _Group5: Laya.Box
  two_img: Laya.Image
  _Group4: Laya.Box
  _Image6: Laya.Image
  _Image7: Laya.Image
  _Label2: Laya.Label
  two_lb: Laya.Label
  _Group7: Laya.Box
  three_img: Laya.Image
  _Group6: Laya.Box
  _Image8: Laya.Image
  _Image9: Laya.Image
  _Label3: Laya.Label
  three_lb: Laya.Label
  _Group9: Laya.Box
  four_img: Laya.Image
  _Group8: Laya.Box
  _Image10: Laya.Image
  _Image11: Laya.Image
  _Label4: Laya.Label
  _Label5: Laya.Label
  change_scene_close
  click_bg_toClose
  destroy_callback
  destroy_imm
  is_center
  model
  show_open_movie
  use_background

  public constructor() {
    super()


    this.base_file = "kfHolyArea"
    this.layout_file = "KfHolyAreaAuctionIntroduceToPlayView"
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

  public LoadSuccess() {

    ResManager.GetInstance().SetOutsideImageSprite(this, this.bg_img, GameResPath.GetIcon("kfHolyArea", "uiboss_049"))
    ResManager.GetInstance().SetOutsideImageSprite(this, this.one_img, GameResPath.GetIconJpg("kfHolyArea", "uiwfjc_002"))
    ResManager.GetInstance().SetOutsideImageSprite(this, this.two_img, GameResPath.GetIconJpg("kfHolyArea", "uiwfjc_003"))
    ResManager.GetInstance().SetOutsideImageSprite(this, this.three_img, GameResPath.GetIconJpg("kfHolyArea", "uiwfjc_004"))
    ResManager.GetInstance().SetOutsideImageSprite(this, this.four_img, GameResPath.GetIconJpg("kfHolyArea", "uiwfjc_005"))
    // let str2 = "占领要塞可获拍卖品!参与跨服圣域人数越多,奖励越丰厚!"
    // this.two_lb.text = str2
    this.InitEvent()
  }

  public InitEvent() {

    Util.AddClickEvent(this.close_img, () => {
      this.Close()
    }
      , this, true)
  }



  public GetComponents() {
    [
      this.bg_img,
      this._Group1,
      this._Image1,
      this._Image2,
      this._Image3,
      this.close_img,
      this._Group10,
      this._Group3,
      this.one_img,
      this._Group2,
      this._Image4,
      this._Image5,
      this._Label1,
      this.one_lb,
      this._Group5,
      this.two_img,
      this._Group4,
      this._Image6,
      this._Image7,
      this._Label2,
      this.two_lb,
      this._Group7,
      this.three_img,
      this._Group6,
      this._Image8,
      this._Image9,
      this._Label3,
      this.three_lb,
      this._Group9,
      this.four_img,
      this._Group8,
      this._Image10,
      this._Image11,
      this._Label4,
      this._Label5,
    ]
      = this.GetChildrenByNames([

        "bg_img",
        "_Group1",
        "_Image1",
        "_Image2",
        "_Image3",
        "close_img",
        "_Group10",
        "_Group3",
        "one_img",
        "_Group2",
        "_Image4",
        "_Image5",
        "_Label1",
        "one_lb",
        "_Group5",
        "two_img",
        "_Group4",
        "_Image6",
        "_Image7",
        "_Label2",
        "two_lb",
        "_Group7",
        "three_img",
        "_Group6",
        "_Image8",
        "_Image9",
        "_Label3",
        "three_lb",
        "_Group9",
        "four_img",
        "_Group8",
        "_Image10",
        "_Image11",
        "_Label4",
        "_Label5",
      ])
  }
}
window["KfHolyAreaAuctionIntroduceToPlayView"] = KfHolyAreaAuctionIntroduceToPlayView