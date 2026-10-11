import { Alert, Alert_Type } from "../alert/Alert"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseView1 } from "../common/BaseView1"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { BagModel } from "../commonModel/BagModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Mathf } from "../util/Mathf"
import { Util } from "../util/Util"

export class ExpandBagView extends BaseView1 {
    bg: Laya.Image
    _Image2: Laya.Image
    reduce_btn: Laya.Image
    input_bg: Laya.Image
    increase_btn: Laya.Image
    maxBtn: Laya.Image
    itemGp: Laya.Box
    title_text: Laya.Image
    tip_text: Laya.Label
    left_cost: Laya.Label
    right_cost: Laya.HTMLDivElement
    cancel_btn: Laya.Box
    _Image1: Laya.Image
    labelDisplay1: Laya.Label
    enter_btn: Laya.Box
    _Image11: Laya.Image
    labelDisplay: Laya.Label
    input_text: Laya.Label
    close_btn: Laya.Image

    item: BaseAwardItem
    SetQuantity
    max_quantity
    Local_Open
    destroy_callback
    bagType
    is_center
    RefreshQuantity
    open_callback
    min_quantity
    index
    cur_quantity
    LoadSuccess
    click_bg_toClose
    InitEvent
    use_background

    public constructor() {
        super()

        this.min_quantity = 1;
        this.cur_quantity = 1;
        this.base_file = "bag"
        this.layout_file = "ExpandBagView"
        this.layer_value = Enum_UILayer.Activity
        this.is_center = true
        this.use_background = true
        this.click_bg_toClose = true
        let local_Math = Mathf
        //let local_Util = Util
        let goods_model = GoodsModel.GetInstance()
        let local_GoodsModel = GoodsModel
        let local_BagModel = BagModel
        this.load_callback = () => {
            // this.right_cost.width = 108
            this.right_cost.style.fontSize = 24
            this.right_cost.style.color = "#b3ff48"
            this.right_cost.style.stroke = 1
            this.right_cost.style.strokeColor = "#000000"


            this.LoadSuccess()
            this.InitEvent()
            // if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
            // 	this.title_text.size  = 22
            // }
            ResManager.GetInstance().SetOutsideImageSprite(this, this.bg, GameResPath.GetIcon("common", "uisy_023"), true)
        }

        this.open_callback = () => {
            this.max_quantity = local_Math.Floor(goods_model.GetTypeGoodsNum(local_BagModel.expandGoods) / 2)
            this.SetQuantity((this.index && this.index > 0) && this.index || (this.max_quantity && this.max_quantity > 0) && this.max_quantity || 1)
        }

        this.destroy_callback = () => {
            if (this.item) {
                this.item.DeleteMe()
                this.item = null
            }
        }

        this.Local_Open = (...parms) => {
            if (parms) {
                this.bagType = parms[0]
                this.index = parms[1]
            }
            super.Open()
        }

        this.LoadSuccess = () => {
            if (!this.item) {
                this.item = new BaseAwardItem(this.itemGp)
                this.item.Load()
                this.item.SetScale(0.7)
                this.item.SetData(local_BagModel.expandGoods)
            }
        }

        this.InitEvent = () => {
            let OnCloseBtnClick = () => {
                this.Close()
            }

            Util.AddClickEvent(this.close_btn, OnCloseBtnClick, this, true)
            let OnEnterBtnClick = () => {
                let needCount = this.cur_quantity * local_BagModel.expandNeed
                let nowCount = goods_model.GetTypeGoodsNum(local_BagModel.expandGoods)
                if (needCount <= nowCount) {
                    goods_model.Fire(local_GoodsModel.ASK_EXPAND_BAG, this.bagType, this.cur_quantity)
                    this.Close()
                } else {
                    let priceCfg = Config.PRELOAD_SERVER_CONFIG.config_goods_price[local_BagModel.expandGoods]
                    if (priceCfg) {
                        Alert.Show(Util.StrToHTML("当前扩容道具不足<br/>是否花费<font color='#639c12'>" + (((needCount - nowCount)) * priceCfg.price) + "</font>勾玉补足缺额<font color='#639c12'>(优先消耗绑玉)</font>"), Alert_Type.Two, () => {
                            goods_model.Fire(local_GoodsModel.ASK_EXPAND_BAG, this.bagType, this.cur_quantity)
                        }
                        )
                        this.Close()
                    }
                }
            }

            Util.AddClickEvent(this.enter_btn, OnEnterBtnClick, this, true)
            let OnCancelBtnClick = () => {
                this.Close()
            }

            Util.AddClickEvent(this.cancel_btn, OnCancelBtnClick, this, true)
            let OnReduceBtnClick = () => {
                this.SetQuantity(this.cur_quantity - 1)
            }

            Util.AddClickEvent(this.reduce_btn, OnReduceBtnClick, this, true)
            let OnIncreaseBtnClick = () => {
                this.SetQuantity(this.cur_quantity + 1)
            }

            Util.AddClickEvent(this.increase_btn, OnIncreaseBtnClick, this, true)
            let maxFunc = () => {
                let max = local_Math.Floor(goods_model.GetTypeGoodsNum(local_BagModel.expandGoods) / local_BagModel.expandNeed)
                if (max == 0) {
                    Message.show("已达最大扩充容量")
                    return
                }
                this.SetQuantity(max)
            }

            Util.AddClickEvent(this.maxBtn, maxFunc, this, true)
            Util.AddClickEvent(this.input_bg, () => {
                let num_change_fun = (value?) => {
                    if (this.use_delete_method) {
                        return
                    }
                    this.SetQuantity(value)
                }

                GlobalEventSystem.Fire(EventName.OPEN_CALCULATOR_VIEW, 9999, num_change_fun, [50, -50])
            }
                , this, false)
            this.BindEvent(goods_model, local_GoodsModel.CHANGE_BAG_MAX_CELL, () => {
                this.Close()
            }
            )
            this.BindEvent(goods_model, local_GoodsModel.UPDATE_GOODS_NUM, () => {
                if (this.use_delete_method) {
                    return
                }
                this.RefreshQuantity()
            }
            )
        }

        this.RefreshQuantity = () => {
            this.input_text.text = this.cur_quantity
            let needCount = this.cur_quantity * local_BagModel.expandNeed
            let nowCount = goods_model.GetTypeGoodsNum(local_BagModel.expandGoods)
            if (nowCount >= needCount) {
                this.right_cost.innerHTML = nowCount + "/" + needCount
            } else {
                this.right_cost.innerHTML = Util.StrToHTML("<font color='#ff4f50'>" + nowCount + "/" + needCount + "</font>")
            }
            this.right_cost.width = 108
        }

        this.SetQuantity = (quantity?) => {
            if (quantity < 1) {
                Message.show("已达最小扩充容量")
                return
            }
            this.cur_quantity = quantity
            this.RefreshQuantity()
        }
    }

    public Open(...new_args) {
        this.Local_Open(...new_args)
    }

    public GetComponents() {
        [
            this.bg,
            this._Image2,
            this.reduce_btn,
            this.input_bg,
            this.increase_btn,
            this.maxBtn,
            this.itemGp,
            this.title_text,
            this.tip_text,
            this.left_cost,
            this.right_cost,
            this.cancel_btn,
            this._Image1,
            this.labelDisplay1,
            this.enter_btn,
            this._Image11,
            this.labelDisplay,
            this.input_text,
            this.close_btn,
        ] = this.GetChildrenByNames([
            "bg",
            "_Image2",
            "reduce_btn",
            "input_bg",
            "increase_btn",
            "maxBtn",
            "itemGp",
            "title_text",
            "tip_text",
            "left_cost",
            "right_cost",
            "cancel_btn",
            "_Image1",
            "labelDisplay1",
            "enter_btn",
            "_Image11",
            "labelDisplay",
            "input_text",
            "close_btn",
        ])
    }
}

window["ExpandBagView"] = ExpandBagView