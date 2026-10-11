import { Alert, Alert_Type } from "../alert/Alert"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ShopModel, ShopEvent, MysteryShopType } from "../commonModel/ShopModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { Util } from "../util/Util"
import { ShopMysteriouItem } from "./ShopMysteriouItem"

export class ShopMysteriousView extends BaseItem1 {
  CancelTimer
  EmprefreshBtn
  InitContent
  InitEvents
  LoadSuccess
  OnTime
  Scrscroll
  SetCost
  SetData
  SetRefreshAndCost
  StartTimer
  is_delay_callback

  img_bg
  img_bg2
  goods_icon
  refreshBtn
  refreshTime
  num
  scroll
  Content
  bottom_conta: Laya.Box
  _Image11: Laya.Image
  _Image2: Laya.Image
  _Image3: Laya.Image
  _Label1: Laya.Label
  cost_conta: Laya.HBox
  _Image1: Laya.Image
  labelDisplay: Laya.Label

  public constructor(parent?) {
    super(parent)


    this.base_file = "shop"
    this.layout_file = "ShopMysteriousView"
    let model = ShopModel.GetInstance()
    let role_mgr = RoleManager.GetInstance()

    let local_ShopEvent = ShopEvent
    let local_MysteryShopType = MysteryShopType
    let lcoal_TimeUtil = TimeUtil
    let local_Util = Util
    let goods_model = GoodsModel.GetInstance()
    let local_laya = Laya
    let data_ = null
    let arrayCollection_ = null
    let count_time_id_ = null
    let cost_item_ = null
    let ticket_enough_ = false
    let money_cost_cfg_ = null
    let tong_event_id_ = null
    let jin_event_id_ = null
    let jinLock_event_id_ = null
    let needRefresh_ = false
    let fly_group_list_ = []
    let last_show_effect_time_ = null
    this.is_delay_callback = false
    this.load_callback = () => {
      this.LoadSuccess()
      this.InitEvents()
    }

    this.DeleteMe = () => {
      this.CancelTimer()
      if (cost_item_) {
        cost_item_.DeleteMe()
        cost_item_ = null
      }
      if (tong_event_id_) {
        role_mgr.mainRoleInfo.UnBind(tong_event_id_)
        tong_event_id_ = null
      }
      if (jin_event_id_) {
        role_mgr.mainRoleInfo.UnBind(jin_event_id_)
        jin_event_id_ = null
      }
      if (jinLock_event_id_) {
        role_mgr.mainRoleInfo.UnBind(jinLock_event_id_)
        jinLock_event_id_ = null
      }
      super.DeleteMe()
    }

    this.LoadSuccess = () => {
      ResManager.GetInstance().SetImageSpriteTrans(this, this.img_bg, GameResPath.GetIconJpg("shop", "uisc_002"))
      ResManager.GetInstance().SetOutsideImageSprite(this, this.img_bg2, GameResPath.GetIcon("common", "uity_059"))
      this.img_bg2.scale9Grid = new Laya.Rectangle(499, 70, 73, 30)
      model.Fire(local_ShopEvent.SHOP_REQUEST_PROTO, 15305, "h", local_MysteryShopType.MysteryShop)
      cost_item_ = new BaseAwardItem(this.goods_icon)
      cost_item_.Load()
      cost_item_.SetItemSize(40, 40)
      cost_item_.SetItembgVisible(false)
    }

    this.InitEvents = () => {
      let update_fun = () => {
        if (this.display_obj.visible) {
          this.SetData()
        }
      }

      this.BindEvent(model, local_ShopEvent.UPDATE_MYSTERY_SHOP_DATA, update_fun)
      let update_one = () => {
        this.SetRefreshAndCost()
      }

      this.BindEvent(model, local_ShopEvent.UPDATE_MYSTERY_SHOP_ONE_DATA, update_one)
      jin_event_id_ = role_mgr.mainRoleInfo.BindOne("jinLock", update_one)
      jinLock_event_id_ = role_mgr.mainRoleInfo.BindOne("jin", update_one)
      Util.AddClickEvent(this.refreshBtn, () => {
        if (last_show_effect_time_ && lcoal_TimeUtil.getServerTime() - last_show_effect_time_ <= 1) {
          return
        }
        let request_fun = (force?) => {
          if (!force && money_cost_cfg_) {
            let enough, gap, my_have, str = model.MoneyIsEnough(money_cost_cfg_[0], money_cost_cfg_[2])
            if (!enough) {
              Message.show(str)
              return
            }
          }
          model.Fire(local_ShopEvent.SHOP_REQUEST_PROTO, 15306, "h", local_MysteryShopType.MysteryShop)
        }

        if (ticket_enough_) {
          request_fun(true)
        } else {
          if (money_cost_cfg_) {
            if (money_cost_cfg_[0] == 2) {
              let enough, gap = model.MoneyIsEnough(money_cost_cfg_[0], money_cost_cfg_[2])
              if (enough) {
                request_fun(true)
              } else {
                let check_func = (bool?) => {
                  model.mystery_jinLock_not_alert = bool
                }

                let ok_func = () => {
                  request_fun(true)
                }

                let diamond_enough, gap2 = model.MoneyIsEnough(1, gap)
                if (diamond_enough) {
                  if (model.mystery_jinLock_not_alert == false) {
                    let str = "<font color=0xff4f50>当前绑玉数量不足，是否消耗勾玉代替？</font>"
                    let content = local_Util.StrToHTML(str)
                    Alert.Show(content, Alert_Type.AlertTypeCheckBox, ok_func, null, "确定", "取消", null, false, check_func, "本次登录不再提示")
                    Alert.SetIsCharge(true)
                  } else {
                    ok_func()
                  }
                } else {
                  request_fun()
                }
              }
            } else {
              request_fun()
            }
          }
        }
      }
        , this, true)
      let OnChangeBagList = () => {
        if (this.use_delete_method) {
          return
        }
        this.SetCost()
      }

      this.BindEvent(goods_model, GoodsModel.CHANGE_BAG_LIST, OnChangeBagList)
      let refresh_effect = (_type?) => {
        if (_type == local_MysteryShopType.MysteryShop) {
          last_show_effect_time_ = lcoal_TimeUtil.getServerTime()
        }
      }

      this.BindEvent(model, local_ShopEvent.SHOW_REFRESH_EFFECT, refresh_effect)
      if (needRefresh_) {
        this.SetData()
        needRefresh_ = false
      }
    }

    this.SetData = () => {
      // [ts2lua]model.mystery_data下标访问可能不正确
      data_ = model.mystery_data[local_MysteryShopType.MysteryShop]
      if (!data_) {
        return
      }
      if (this.is_loaded) {
        data_.good_list = model.FormatMysteriousData(data_.good_list)
        if (!arrayCollection_) {
          this.InitContent()
        } else {
          arrayCollection_.replaceAll(data_.good_list)
        }
        this.SetRefreshAndCost()
      } else {
        needRefresh_ = true
      }
    }

    this.InitContent = () => {
      if (!arrayCollection_) {
        // arrayCollection_ =  new Laya.ArrayCollection()
        arrayCollection_ = new LoopScrowViewMgr()
      }

      // arrayCollection_.source = data_.good_list
      // this.scroll.dataProvider = arrayCollection_
      // this.scroll.itemRenderer = ShopMysteriouItem

      arrayCollection_.SetData(this.Content, ShopMysteriouItem, data_.good_list, LoopScrCon.Vertical)
      if (model.show_type_id) {
        let count = null
        let vo = null
        let i = 0
        do {
          vo = data_.good_list[i]
          if (vo.goods_id == model.show_type_id) {
            count = i
            break
          }
          i = i + 1
        } while ((i < data_.good_list.length)
        )
        if (count) {
          let height = 332
          let line = Math.floor(count / 3)
          let scroll_to = line * height
          if (scroll_to > this.scroll.height - this.scroll.height) {
            scroll_to = this.scroll.height - this.scroll.height
          }
          this.scroll.validateNow()
          this.scroll.scrollV = scroll_to
        }
        model.show_type_id = null
      }
    }

    this.SetRefreshAndCost = () => {
      this.SetCost()
      this.CancelTimer()
      this.StartTimer()
    }

    this.SetCost = () => {
      if (!data_) {
        return
      }
      ticket_enough_ = false
      money_cost_cfg_ = null
      let cfg = model.GetRefreshCfg(data_.hit_num, local_MysteryShopType.MysteryShop)
      if (cfg) {
        let type_id = null
        let str = ""
        let cost_cfg = ErlangParser.GetInstance().parse(cfg.cost)
        if (cost_cfg) {
          for (let _tmpi in cost_cfg) {
            var vo = cost_cfg[_tmpi]
            if (vo[0] == 0) {
              let my_have = goods_model.GetTypeGoodsNum(vo[1])
              if (my_have >= vo[2]) {
                ticket_enough_ = true
                type_id = vo[1]
                str = "<font color=0x639c12>" + my_have + "</font>/" + vo[2]
                break
              }
            } else {
              // [ts2lua]Config.PRELOAD_CLIENT_CONFIG.ConfigNotNormalGoods下标访问可能不正确
              // [ts2lua]Config.PRELOAD_CLIENT_CONFIG.ConfigNotNormalGoods下标访问可能不正确
              // [ts2lua]lua中0和空字符串也是true，此处Config.PRELOAD_CLIENT_CONFIG.ConfigNotNormalGoods[vo[0*/需要确认
              type_id = (Config.PRELOAD_CLIENT_CONFIG.ConfigNotNormalGoods[vo[0]] && (Config.PRELOAD_CLIENT_CONFIG.ConfigNotNormalGoods[vo[0]].goods_id) || (0))
              money_cost_cfg_ = vo
              let color_str = "#639c12"
              let enough, gap, my_have = model.MoneyIsEnough(vo[0], vo[2])
              if (!enough) {
                color_str = "#ff4f50"
              }
              str = "<font color=" + color_str + ">" + my_have + "</font>/" + vo[2]
            }
          }
        }
        if (type_id && str) {
          cost_item_.SetData(type_id)
          this.num.text = local_Util.StrToHTML(str)
        }
      }
    }

    this.StartTimer = () => {

      Laya.timer.loop(1000, this, this.OnTime)
      // count_time_id_ =  new Laya.Timer(1000, 0)
      // count_time_id_.addEventListener(Laya.TimerEvent.TIMER, this.OnTime, this)
      // count_time_id_.start()
      this.OnTime()
    }

    this.OnTime = () => {
      if (data_ && data_.refresh_time != null) {
        let left_time = data_.refresh_time - lcoal_TimeUtil.getServerTime()
        if (left_time < 0) {
          this.CancelTimer()
          this.refreshTime.text = "00:00:00"
          return
        }
        let time_str = lcoal_TimeUtil.convertTime(left_time)
        this.refreshTime.text = String(time_str)
      }
    }

    this.CancelTimer = () => {
      if (count_time_id_) {
        Laya.timer.clear(this, this.OnTime)
        // count_time_id_.stop()
        // count_time_id_.removeEventListener(Laya.TimerEvent.TIMER, this.OnTime, this)
        // count_time_id_ = null
      }
    }


  }


  public GetComponents() {
    [
      this.img_bg,
      this.img_bg2,
      this.scroll,
      this.Content,
      this.bottom_conta,
      this._Image11,
      this._Image2,
      this._Image3,
      this._Label1,
      this.refreshTime,
      this.cost_conta,
      this.goods_icon,
      this.num,
      this.refreshBtn,
      this._Image1,
      this.labelDisplay,
    ]
      = this.GetChildrenByNames([

        "img_bg",
        "img_bg2",
        "scroll",
        "Content",
        "bottom_conta",
        "_Image11",
        "_Image2",
        "_Image3",
        "_Label1",
        "refreshTime",
        "cost_conta",
        "goods_icon",
        "num",
        "refreshBtn",
        "_Image1",
        "labelDisplay",
      ])
  }
}

window["ShopMysteriousView"]=ShopMysteriousView