import { FtvShopItem } from "./FtvShopItem"

export class FtvShopItemTwo extends FtvShopItem {
  _Image1: Laya.Image
  _lb_name: Laya.Label
  _lb_limit: Laya.Label
  _gp_item: Laya.Box
  _img_title: Laya.Image
  _img_discount: Laya.Image
  _Group2: Laya.Box
  _Group1: Laya.HBox
  _Label1: Laya.Label
  _img_jin: Laya.Image
  _lb_price: Laya.Label
  _Image2: Laya.Image
  _gp_btn: Laya.Box
  _Image3: Laya.Image
  _gp_buy: Laya.HBox
  _Label2: Laya.Label
  _img_btn_jin: Laya.Image
  _lb_btn_price: Laya.Label
  _lb_over: Laya.Label
  _img_over: Laya.Image
  Emp_gp_btn
  item_type

  public constructor(parent?) {
    super()


    this.base_file = "ftvShop"
    this.layout_file = "FtvShopItemTwo"
    this.item_type = 2
  }


  public GetComponents() {
    [
      this._Image1,
      this._lb_name,
      this._lb_limit,
      this._gp_item,
      this._img_title,
      this._img_discount,
      this._Group2,
      this._Group1,
      this._Label1,
      this._img_jin,
      this._lb_price,
      this._Image2,
      this._gp_btn,
      this._Image3,
      this._gp_buy,
      this._Label2,
      this._img_btn_jin,
      this._lb_btn_price,
      this._lb_over,
      this._img_over,
    ]
      = this.GetChildrenByNames([

        "_Image1",
        "_lb_name",
        "_lb_limit",
        "_gp_item",
        "_img_title",
        "_img_discount",
        "_Group2",
        "_Group1",
        "_Label1",
        "_img_jin",
        "_lb_price",
        "_Image2",
        "_gp_btn",
        "_Image3",
        "_gp_buy",
        "_Label2",
        "_img_btn_jin",
        "_lb_btn_price",
        "_lb_over",
        "_img_over",
      ])
  }
}
window["FtvShopItemTwo"]=FtvShopItemTwo