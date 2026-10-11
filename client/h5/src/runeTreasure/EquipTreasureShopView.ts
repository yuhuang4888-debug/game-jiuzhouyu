import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RuneTreasureEvent, RuneTreasureModel } from "../commonModel/RuneTreasureModel"
import { PlatformManager } from "../PlatformManager"
import { RoleManager } from "../commonModel/RoleManager"
import { ColorUtil, ColorType } from "../util/ColorUtil"
import { Util } from "../util/Util"
import { TreasureExchangeItem } from "./TreasureExchangeItem"

export class EquipTreasureShopView extends BaseView1 {
    public score_label
    public close_btn
    public exchange_btn
    public reward_scroller
    public reward_group
    _Image1: Laya.Image
    _Image2: Laya.Image
    _Image3: Laya.Image
    _Image4: Laya.Image
    _Image11: Laya.Image
    labelDisplay: Laya.Label
    Content
    _Label1: Laya.Label
    // public let                

    LoadSuccess
    InitEvent
    public constructor() {
        super()
        this.base_file = "runeTreasure"
        this.layout_file = "EquipTreasureShopView"
        this.layer_value = Enum_UILayer.Activity
        this.destroy_imm = true
        this.is_center = true
        this.use_background = true
        this.click_bg_toClose = true
        let local_util = Util
        let local_event = RuneTreasureEvent
        let model = RuneTreasureModel.GetInstance(),
            array_collection_: LoopScrowViewMgr,
            goods_config_,
            select_goods_
        this.preload_server_config = {
            "config_treasure_hunt_shop": false
        }
        this.load_callback = function () {
            this.LoadSuccess()
        }

        this.LoadSuccess = () => {
            goods_config_ = this.preload_server_config.config_treasure_hunt_shop // await local_util.LoadServerConfig("config_treasure_hunt_shop")

            array_collection_ = new LoopScrowViewMgr()
            // this.reward_group.dataProvider = array_collection_
            // this.reward_group.itemRenderer = TreasureExchangeItem
            let dataList=[]
            if (goods_config_) {
                for (let key in goods_config_) {
                    if (goods_config_[key].lv <= RoleManager.GetInstance().GetMainRoleVo().level) {
                        dataList.push(goods_config_[key])
                    }
                }
            }
            array_collection_.SetData(this.Content, TreasureExchangeItem, dataList, LoopScrCon.Vertical, 1)
            this.score_label.text = `${model.equip_treasure_socre}`
            // if (model.record_data_list) {
            //     for (let key in model.record_data_list) {
            //         this.score_label.text = model.record_data_list[key].score
            //     }
            // }
            this.InitEvent()
        }

        this.InitEvent = () => {
            local_util.AddClickEvent(this.close_btn, () => {
                this.Close()
            }, this, true)

            local_util.AddClickEvent(this.exchange_btn, () => {
                if (select_goods_) {
                    model.Fire(local_event.RUNE_TREASURE_REQUEST_PROTO, 41609, "i", select_goods_)
                }
            }, this, true)

            this.BindEvent(model, local_event.SELECT_SHOP_ITEM, (id) => {
                select_goods_ = id
            })

            this.BindEvent(model, local_event.UPDATE_EQUIP_SCORE, (score) => {
                this.score_label.text = score
            })
        }
    }

    public GetComponents() {
        [
            this._Image1,
            this._Image2,
            this._Image3,
            this._Image4,
            this.exchange_btn,
            this._Image11,
            this.labelDisplay,
            this.reward_scroller,
            this.Content,
            this.close_btn,
            this._Label1,
            this.score_label,
        ]
            = this.GetChildrenByNames([

                "_Image1",
                "_Image2",
                "_Image3",
                "_Image4",
                "exchange_btn",
                "_Image11",
                "labelDisplay",
                "reward_scroller",
                "Content",
                "close_btn",
                "_Label1",
                "score_label",
            ])
    }
}

window["EquipTreasureShopView"] = EquipTreasureShopView