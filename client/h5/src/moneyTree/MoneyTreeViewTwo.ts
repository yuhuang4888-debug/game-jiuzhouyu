import { MoneyTreeView } from "./MoneyTreeView"

export class MoneyTreeViewTwo extends MoneyTreeView {
  _gp_reward: Laya.Box
  _img_4: Laya.Image
  _img_3: Laya.Image
  _Image1: Laya.Image
  _gp_time: Laya.Box
  _img_5: Laya.Image
  _img_6: Laya.Image
  _gp_tree_effect: Laya.Box
  _Group3: Laya.HBox
  _Group1: Laya.Box
  _img_proview: Laya.Image
  _Group2: Laya.Box
  _shop: Laya.Image
  _shop_red: Laya.Image
  _gp_anime: Laya.Box
  _img_anime: Laya.Image
  _Label1: Laya.Label
  _score: Laya.HTMLDivElement
  _Image2: Laya.Image
  _gp_record: Laya.Box
  _gp_all_btn: Laya.Box
  _Image3: Laya.Image
  _Image4: Laya.Image
  _gp_one_btn: Laya.Box
  _gp_ten_btn: Laya.Box
  _gp_boom_effect: Laya.Box

  __cul_bg
  _gp_cul_reward
  _gp_fifty_btn
  _img_reward_bg
  _img_tree
  _lb_allcount

  show_two
  public constructor(parent?) {
    super()


    this.base_file = "moneyTree"
    this.layout_file = "MoneyTreeViewTwo"
    this.show_two = true
  }


  public GetComponents() {
    [
      this._gp_reward,
      this._img_4,
      this._img_3,
      this._Image1,
      this._gp_time,
      this._img_5,
      this._img_6,
      this._gp_tree_effect,
      this._Group3,
      this._Group1,
      this._img_proview,
      this._Group2,
      this._shop,
      this._shop_red,
      this._gp_anime,
      this._img_anime,
      this._Label1,
      this._score,
      this._Image2,
      this._gp_record,
      this._gp_all_btn,
      this._Image3,
      this._Image4,
      this._gp_one_btn,
      this._gp_ten_btn,
      this._gp_boom_effect,
    ]
      = this.GetChildrenByNames([

        "_gp_reward",
        "_img_4",
        "_img_3",
        "_Image1",
        "_gp_time",
        "_img_5",
        "_img_6",
        "_gp_tree_effect",
        "_Group3",
        "_Group1",
        "_img_proview",
        "_Group2",
        "_shop",
        "_shop_red",
        "_gp_anime",
        "_img_anime",
        "_Label1",
        "_score",
        "_Image2",
        "_gp_record",
        "_gp_all_btn",
        "_Image3",
        "_Image4",
        "_gp_one_btn",
        "_gp_ten_btn",
        "_gp_boom_effect",
      ])
      this._score.style.fontSize=20
      this._score.style.color="#f9e1d5"
      this._score.style.wordWrap=false
  }
}