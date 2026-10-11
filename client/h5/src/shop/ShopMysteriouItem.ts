import { Alert, Alert_Type } from "../alert/Alert"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Config } from "../common/Config"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ShopModel, ShopEvent, MysteryShopType } from "../commonModel/ShopModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil } from "../util/ColorUtil"
import { ErlangParser } from "../util/ErlangParser"
import { Util } from "../util/Util"
import { SpecialCharKey } from "../common/SpecialCharKey"

export class ShopMysteriouItem extends BaseItemRenderer {
  cost_item
  item
  model
  original_cost_item
  type_id
  ui_effect

  goods_icon
  orignal_cost_icon
  cost_icon
  sell_out
  buy_btn
  sell_out_btn
  goodsname
  img_disc
  orignal_cost
  price
  orignal_price
  delete_line
  limit_conta
  limit_num
  _Image1: Laya.Image
  _Label1: Laya.Label
  btn_img: Laya.Image
  cost_conta: Laya.HBox
  _Label2: Laya.Label
  _Group1: Laya.HBox
  btn_img0: Laya.Image
  soldout_text: Laya.Label
  condition: Laya.Label
  effect: Laya.Box

  public constructor(parent) {
    super()


    this.base_file = "shop"
    this.layout_file = "ShopMysteriouItem"
    this.model = ShopModel.GetInstance()
    this.Load()
  }

  public load_callback(){
    this.LoadSuccess()
    this.InitEvent()
  }

  public LoadSuccess(){
    this.item = new BaseAwardItem(this.goods_icon)
    this.item.Load()
    this.item.SetItemSize(119, 119)
    this.original_cost_item = new BaseAwardItem(this.orignal_cost_icon)
    this.original_cost_item.Load()
    this.original_cost_item.SetItemSize(35, 35)
    this.original_cost_item.SetItembgVisible(false)
    this.cost_item = new BaseAwardItem(this.cost_icon)
    this.cost_item.Load()
    this.cost_item.SetItemSize(35, 35)
    this.cost_item.SetItembgVisible(false)
    this.sell_out.touchEnabled = false
  }

  public InitEvent(){
    Util.AddClickEvent(this.buy_btn, () => {
      if (this.data && this.data.mystery_shop_good) {
        let ok_func = (force?) => {
          if (!force && this.data.mystery_shop_good) {
            let enough, gap, my_have, str = this.model.MoneyIsEnough(this.data.mystery_shop_good.price_type, this.data.price)
            if (!enough) {
              Message.show(str)
              return
            }
          }
          this.model.Fire(ShopEvent.SHOP_REQUEST_PROTO, 15307, "hhi", this.data.type, this.data.cfg_id, this.data.price)
        }

        let check_func = (bool?) => {
          this.model.jinLock_not_enough_not_alert = bool
        }

        let ok_btn_fun = () => {
          ok_func(true)
        }

        if (this.data.mystery_shop_good.price_type == 2) {
          let enough, gap = this.model.MoneyIsEnough(this.data.mystery_shop_good.price_type, this.data.price)
          if (!enough) {
            let diamond_enough, gap2 = this.model.MoneyIsEnough(1, gap)
            if (diamond_enough) {
              if (this.model.jinLock_not_enough_not_alert == false) {
                let str = "<font color=0xff4f50>当前绑玉数量不足，是否消耗勾玉代替？</font>"
                let content = Util.StrToHTML(str)
                Alert.Show(content, Alert_Type.AlertTypeCheckBox, ok_btn_fun, null, "确定", "取消", null, false, check_func, "本次登录不再提示")
                Alert.SetIsCharge(true)
              } else {
                ok_btn_fun()
              }
            } else {
              ok_func()
            }
          } else {
            ok_func()
          }
        } else {
          ok_func()
        }
      }
    }
      , this, true)
    Util.AddClickEvent(this.sell_out_btn, () => {
      Message.show("没货啦~")
    }
      , this, true)
    let success_fun = (cfg_id?) => {
      if (this.data && this.data.cfg_id == cfg_id) {
        let pos = this.goods_icon.localToGlobal()
        this.model.Fire(ShopEvent.SHOP_ICON_FLY, this.data.type_id, pos)
      }
    }

    this.BindEvent(this.model, ShopEvent.SHOP_MYSTERY_BUY_SUCCESS, success_fun)
    let effect_fun = (_type?) => {
      if (this.data && _type == MysteryShopType.MysteryShop) {
        this.SetEffect()
      }
    }

    this.BindEvent(this.model, ShopEvent.SHOW_REFRESH_EFFECT, effect_fun)
    let refresh_fun = (_type?, cfg_id?) => {
      if (this.data && this.data.cfg_id == cfg_id) {
        this.data = this.model.GetMysteryDataById(this.data.type, cfg_id)
        this.SetBuyState()
      }
    }

    this.BindEvent(this.model, ShopEvent.UPDATE_MYSTERY_SHOP_ONE_DATA, refresh_fun)
    let refresh_fun2 = (cfg_id?) => {
      this.SetBuyState()
    }

    this.BindVar(RoleManager.Instance.mainRoleInfo, "jinLock", refresh_fun2)
    this.BindVar(RoleManager.Instance.mainRoleInfo, "jin", refresh_fun2)
  }

  public createChildren() {

    super.createChildren()
  }

  public dataChanged() {

    if (super.dataChanged()) {
      let reward_data = ErlangParser.GetInstance().parse(this.data.mystery_shop_good.goods)
      if (Util.TableSize(reward_data) < 1) {
        return
      }
      reward_data = reward_data[0]
      let goods_id, lock = GoodsModel.GetInstance().GetMappingTypeId(reward_data[0], reward_data[1])
      let goodsVo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(goods_id)
      if (goodsVo) {
        this.type_id = goodsVo.type_id
        if (this.item) {
          this.item.DeleteMe()
          this.item = null
        }
        this.item = new BaseAwardItem(this.goods_icon)
        this.item.Load()
        this.item.SetItemSize(119, 119)
        this.item.SetData(goodsVo.type_id, reward_data[2])
        let color_str = ColorUtil.GetColorLight(goodsVo.color)
        color_str=color_str.replace(SpecialCharKey.ShopMysteriouItem1,"");
				color_str=color_str.replace(SpecialCharKey.ShopMysteriouItem1,"");
        let name = "<font color=" + color_str + ">" + goodsVo.goods_name.trim() + "</font>"
        this.goodsname.text = goodsVo.goods_name.trim()
        this.goodsname.color=color_str
      }
      // [ts2lua]lua中0和空字符串也是true，此处this.data.discount < 10需要确认
      this.img_disc.visible = (this.data.discount < 10 && (true) || (false))
      if (this.data.discount < 10) {
        ResManager.GetInstance().SetImageSpriteTrans(this, this.img_disc, "resource/game/common2/texture/sh_discount_" + this.data.discount + ".png")
      }
      // [ts2lua]lua中0和空字符串也是true，此处this.data.discount < 10需要确认
      this.orignal_cost.visible = (this.data.discount < 10 && (true) || (false))
      let orignal_price = Math.round(this.data.price / this.data.discount * 0.1)
      this.price.text = this.data.price
      this.orignal_price.text = String(orignal_price)
      this.delete_line.width = 35 + 12 + this.orignal_price.textWidth
      this.delete_line.x = this.orignal_cost.width - this.delete_line.width + 12 / 2
      // [ts2lua]Config.PRELOAD_CLIENT_CONFIG.ConfigNotNormalGoods下标访问可能不正确
      // [ts2lua]Config.PRELOAD_CLIENT_CONFIG.ConfigNotNormalGoods下标访问可能不正确
      // [ts2lua]lua中0和空字符串也是true，此处Config.PRELOAD_CLIENT_CONFIG.ConfigNotNormalGoods[this.data.mystery_shop_good.price_type]需要确认
      let cost_type_id = (Config.PRELOAD_CLIENT_CONFIG.ConfigNotNormalGoods[this.data.mystery_shop_good.price_type] && (Config.PRELOAD_CLIENT_CONFIG.ConfigNotNormalGoods[this.data.mystery_shop_good.price_type].goods_id) || (0))
      this.cost_item.SetData(cost_type_id, 0)
      this.cost_item.SetShowTips(false)
      this.original_cost_item.SetData(cost_type_id)
      this.SetBuyState()
    }
  }

  public SetBuyState() {

    if (this.data) {
      let enough, gap = this.model.MoneyIsEnough(this.data.mystery_shop_good.price_type, this.data.price)
      // [ts2lua]lua中0和空字符串也是true，此处enough需要确认
      let color_str = (enough && ("#ffffff") || ("#ffffff"))
      this.price.textColor = color_str
      this.price.stroke = 2
      this.limit_conta.visible = this.data.mystery_shop_good.limit > 0
      this.limit_num.text = this.data.mystery_shop_good.limit - this.data.buy_num + "/" + this.data.mystery_shop_good.limit
      // [ts2lua]lua中0和空字符串也是true，此处this.data.mystery_shop_good.limit - this.data.buy_num > 0需要确认
      let textcolor=(this.data.mystery_shop_good.limit - this.data.buy_num > 0 && (ColorUtil.GetColorDark(0)) || (ColorUtil.GetColorDark(5)))
      textcolor=textcolor.replace(SpecialCharKey.ShopMysteriouItem1,"");
      textcolor=textcolor.replace(SpecialCharKey.ShopMysteriouItem1,"");
      this.limit_num.color = textcolor
      let show_out = false
      if (this.data.mystery_shop_good.limit > 0) {
        // [ts2lua]lua中0和空字符串也是true，此处this.data.mystery_shop_good.limit - this.data.buy_num > 0需要确认
        show_out = (this.data.mystery_shop_good.limit - this.data.buy_num > 0 && (false) || (true))
      }
      this.sell_out.visible = show_out
      this.sell_out_btn.visible = show_out
      this.item.SetGary(show_out)
      this.buy_btn.visible = !show_out
      Util.SetImageGray(this.img_disc, show_out)
    }
  }

  public SetEffect() {

    // if (! this.ui_effect ) {
    //   this.ui_effect =  new UIEffect()
    // }
    // this.ui_effect.AddUIEffect("ui_Mallrefresh_glow", this.effect, null)
  }

  public DeleteMe() {

    if (this.original_cost_item) {
      this.original_cost_item.DeleteMe()
      this.original_cost_item = null
    }
    if (this.item) {
      this.item.DeleteMe()
      this.item = null
    }
    if (this.cost_item) {
      this.cost_item.DeleteMe()
      this.cost_item = null
    }
    if (this.ui_effect) {
      this.ui_effect.DeleteMe()
      //this.ui_effect.ClearUIEffect(this.effect)
    }
    super.DeleteMe()
  }

  public GetComponents() {
    [
      this._Image1,
      this.goodsname,
      this.goods_icon,
      this.img_disc,
      this.limit_conta,
      this._Label1,
      this.limit_num,
      this.buy_btn,
      this.btn_img,
      this.cost_conta,
      this._Label2,
      this.cost_icon,
      this.price,
      this.orignal_cost,
      this._Group1,
      this.orignal_cost_icon,
      this.orignal_price,
      this.delete_line,
      this.sell_out,
      this.sell_out_btn,
      this.btn_img0,
      this.soldout_text,
      this.condition,
      this.effect,
    ]
      = this.GetChildrenByNames([

        "_Image1",
        "goodsname",
        "goods_icon",
        "img_disc",
        "limit_conta",
        "_Label1",
        "limit_num",
        "buy_btn",
        "btn_img",
        "cost_conta",
        "_Label2",
        "cost_icon",
        "price",
        "orignal_cost",
        "_Group1",
        "orignal_cost_icon",
        "orignal_price",
        "delete_line",
        "sell_out",
        "sell_out_btn",
        "btn_img0",
        "soldout_text",
        "condition",
        "effect",
      ])
  }
}
window["ShopMysteriouItem"] = ShopMysteriouItem