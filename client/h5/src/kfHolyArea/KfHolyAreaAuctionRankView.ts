import { BaseView1 } from "../common/BaseView1"
import { KfHolyAreaModel } from "../commonModel/KfHolyAreaModel"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { KfHolyAreaAuctionRankItem } from "./KfHolyAreaAuctionRankItem"
export class KfHolyAreaAuctionRankView extends BaseView1 {
  bg_img: Laya.Image
  _Group1: Laya.Box
  _Image1: Laya.Image
  _Image2: Laya.Image
  _Image3: Laya.Image
  _Group3: Laya.Box
  _Image4: Laya.Image
  _Group2: Laya.Box
  _Image5: Laya.Image
  _Image6: Laya.Image
  _Image7: Laya.Image
  _Label1: Laya.Label
  _Label2: Laya.Label
  _Label3: Laya.Label
  empty_gp: Laya.HBox
  _Image8: Laya.Image
  _Label4: Laya.Label
  Content: Laya.List
  close_img: Laya.Image
  _Group4: Laya.Box
  _Label5: Laya.Label
  my_total_lb: Laya.Label
  _Group5: Laya.Box
  _Label6: Laya.Label
  my_rank_lb: Laya.Label
  change_scene_close
  click_bg_toClose
  contribution_lb
  data
  destroy_callback
  destroy_imm
  is_center
  item_list
  medal_img
  model
  my_rank
  my_value
  name_lb
  rank_img
  rank_lb
  show_open_movie
  title_gp
  use_background
  loop_mgr

  public constructor() {
    super()


    this.base_file = "kfHolyArea"
    this.layout_file = "KfHolyAreaAuctionRankView"
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
      this.data = new_args[0].info
      this.my_rank = new_args[0].this_rank
      this.my_value = new_args[0].this_value
    }
    super.Open()
  }

  public LoadSuccess() {

    ResManager.GetInstance().SetOutsideImageSprite(this, this.bg_img, GameResPath.GetIcon("kfHolyArea", "uiboss_049"))

    if (!this.loop_mgr) {
      this.loop_mgr = new LoopScrowViewMgr()
      this.loop_mgr.SetData(this.Content, KfHolyAreaAuctionRankItem, this.data, LoopScrCon.Vertical)
    } else {
      this.loop_mgr.replaceAll(this.data)

    }
    this.InitEvent()
    this.UpdateView()
  }

  public InitEvent() {

    Util.AddClickEvent(this.close_img, () => {
      this.Close()
    }
      , this, true)
  }

  public UpdateView() {

    if (this.data && this.data.length > 0) {
      this.empty_gp.visible = false
      this.loop_mgr.replaceAll(this.data)
    } else {
      this.empty_gp.visible = true
    }
    // [ts2lua]lua中0和空字符串也是true，此处this.my_rank > 0需要确认
    this.my_rank_lb.text = (this.my_rank > 0 ? (String(this.my_rank)) : ("未上榜"))
    this.my_total_lb.text = String(this.my_value)
  }
  public DeleteMe() {
    if (this.loop_mgr) {
      this.loop_mgr.DeleteMe()
      this.loop_mgr = null
    }
    super.DeleteMe()
  }


  public GetComponents() {
    [
      this.bg_img,
      this._Group1,
      this._Image1,
      this._Image2,
      this._Image3,
      this._Group3,
      this._Image4,
      this._Group2,
      this._Image5,
      this._Image6,
      this._Image7,
      this._Label1,
      this._Label2,
      this._Label3,
      this.empty_gp,
      this._Image8,
      this._Label4,
      this.Content,
      this.close_img,
      this._Group4,
      this._Label5,
      this.my_total_lb,
      this._Group5,
      this._Label6,
      this.my_rank_lb,
    ]
      = this.GetChildrenByNames([

        "bg_img",
        "_Group1",
        "_Image1",
        "_Image2",
        "_Image3",
        "_Group3",
        "_Image4",
        "_Group2",
        "_Image5",
        "_Image6",
        "_Image7",
        "_Label1",
        "_Label2",
        "_Label3",
        "empty_gp",
        "_Image8",
        "_Label4",
        "Content",
        "close_img",
        "_Group4",
        "_Label5",
        "my_total_lb",
        "_Group5",
        "_Label6",
        "my_rank_lb",
      ])
  }
}
window["KfHolyAreaAuctionRankView"] = KfHolyAreaAuctionRankView