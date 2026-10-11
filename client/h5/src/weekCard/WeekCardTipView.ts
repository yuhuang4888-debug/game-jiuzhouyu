import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { RoleManager } from "../commonModel/RoleManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ResManager } from "../common/ResManager"
import { Util } from "../util/Util"
import { LuaSoundManager } from "../common/SoundManager"
import { Config } from "../common/Config"
import { ErlangParser } from "../util/ErlangParser"
import { ColorUtil } from "../util/ColorUtil"
import { ColorType } from "../util/ColorUtil"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { Message } from "../sysinfo/SysInfoController"
import { VipModel } from "../commonModel/VipModel"
import { PlatformManager } from "../PlatformManager"
import { WeekCardModel } from "../commonModel/WeekCardModel"
import { EquipmentItem } from "../common/EquipmentItem"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"


export class WeekCardTipView extends BaseView1 {
    InitEvent
    InitView
    LoadSuccess

    item_list
    public constructor() {
        super()

        this.base_file = "weekCard"
        this.layout_file = "WeekCardTipView"
        this.use_background = true
        this.show_open_movie = true
        this.is_center = true
        this.change_scene_close = true
        this.destroy_imm = true
        this.layer_value = Enum_UILayer.Activity
        this.preload_server_config = {
        }
        this.load_callback = () => {
            this.item_gp.hScrollBarSkin = ""
            WeekCardModel.GetInstance().spacial_red = false
            GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 452, false)
            WeekCardModel.GetInstance().Fire(WeekCardModel.UPDATE_VIEW)
            this.LoadSuccess()
        }

        this.destroy_callback = () => {
            if (this.item_list) {
                for (let _tmpi in this.item_list) {
                    let obj = this.item_list[_tmpi]
                    obj.DeleteMe()
                }
                this.item_list = null
            }
        }



        this.LoadSuccess = () => {

            this.InitView()
            this.InitEvent()
        }

        this.InitEvent = () => {
            let pay_fun = () => {

                let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_recharge_product", false)
                let product_info_ = cfg[107]
                let hasNum: number = GoodsModel.GetInstance().GetTypeGoodsNum(36210008) // 写死默认拿这个道具
                if (hasNum >= 8) {
                    VipModel.GetInstance().Fire(VipModel.REQUEST_PROTO, 15804, 'i', 107)
                }
                else {
                    if (product_info_) {
                        PlatformManager.GetInstance().PayRequest(product_info_.money, { id: product_info_.product_id, pay_title: product_info_.product_name }, (ret) => {
                            if (ret == 'SUCCESS') {
                                WeekCardModel.GetInstance().Fire(WeekCardModel.REQUEST_PROTO, 45201)
                            }
                        })
                    }
                }
            }
            Util.AddClickEvent(this.close, () => {
                this.Close()
            }, this, true)
            Util.AddClickEvent(this.chnnel, () => {
                this.Close()
            }, this, true)
            Util.AddClickEvent(this.buy, () => {
                pay_fun()
                this.Close()
            }, this, true)
        }

        this.InitView = () => {
            let reward = WeekCardModel.GetInstance().GetReward()
            if (!this.item_list) {
                this.item_list = []
            }
            for (let key in reward) {
                let item = this.item_list[key]
                if (!item) {
                    item = new EquipmentItem(this.item_gp)
                    this.item_list[key] = item
                    item.SetItemSize(85, 85)
                    item.Load()
                }
                item.SetPosition(Number(key) * 90, 0)
                let vo = reward[key]
                let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(vo[0], vo[1])
                item.SetData(type_id, vo[2])

            }
        }



    }





    close: Laya.Image
    buy: Laya.Box
    chnnel: Laya.Box
    item_gp: Laya.Panel
    public GetComponents() {
        [
            this.close,
            this.buy,
            this.chnnel,
            this.item_gp,
        ]
            = this.GetChildrenByNames([

                "close",
                "buy",
                "chnnel",
                "item_gp",
            ])
    }
}
window["WeekCardTipView"] = WeekCardTipView