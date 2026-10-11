import { Alert, Alert_Type } from "../alert/Alert"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { EquipmentItem } from "../common/EquipmentItem"
import { EventName } from "../common/EventName"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { DragonBallModel } from "../commonModel/DragonBallModel"
import { FunctionOpenEvent, FunctionOpenModel } from "../commonModel/FunctionOpenModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { VipModel } from "../commonModel/VipModel"
import { PlatformManager } from "../PlatformManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class SuperGiftItem extends BaseItemRenderer {
    
    buyed: Laya.Image
    public WIDTH = 266
    public HEIGT = 245
    model
    real_rmb_price
    price
    can_buy_num
    color
    is_rmb
    product_id
    big_item
    item_list
    cost_type
    real_gold_price
    public constructor(parent) {
        super()

        this.base_file = "superGift"
        this.layout_file = "SuperGiftItem"
        this.model = CustomActivityModel.GetInstance()
        this.Load()

    }

    public load_callback() {
        this.LoadSuccess()
    }

    public LoadSuccess() {
        this.left_lb.style.fontSize = 18
        this.left_lb.style.color = "#663915"
        this.left_lb.style.wordWrap = false
        this.item_gp.hScrollBarSkin = ""
        this.InitEvent()
    }

    public InitEvent() {
        Util.AddClickEvent(this._box_enter, () => {
            if (this.is_rmb) {
                let product_id = this.product_id
                if (product_id) {
                    let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_recharge_product", false)
                    let product_info_ = cfg[product_id]
                    let hasNum: number = GoodsModel.GetInstance().GetTypeGoodsNum(36210008) // 写死默认拿这个道具
                    if (hasNum >= Number(this.real_rmb_price)) {
                        VipModel.GetInstance().Fire(VipModel.REQUEST_PROTO, 15804, 'i', product_id)
                    }
                    else {
                        if (product_info_) {

                            PlatformManager.GetInstance().PayRequest(product_info_.money, { id: product_info_.product_id, pay_title: product_info_.product_name }, (ret) => {
                                if (ret == 'SUCCESS') {
                                    //model.Fire(WeekCardModel.REQUEST_PROTO, 45201)
                                }
                            })
                        }
                    }
                }
            }
            else {
                if (this.cost_type) {
                    let no_money_func = () => {
                        Alert.Show("勾玉不足，是否前往充值", Alert_Type.Two, () => {
                            OpenFun.OpenFunHandler(21)
                        })
                    }
                    let func = () => {
                        CustomActivityModel.GetInstance().Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33105, this.data.base_type, this.data.sub_type, this.data.grade)
                    }
                    let cost_func = () => {
                        let is_bind_diamond = this.cost_type == Number(2) ? true : false

                        let vo = RoleManager.GetInstance().GetMainRoleVo(), bind_diamond = vo.jinLock, diamond = vo.jin;
                        let value = Number(this.real_gold_price)
                        if (is_bind_diamond) {
                            if (value > bind_diamond) {
                                if (value > bind_diamond + diamond) {
                                    no_money_func()
                                }
                                else {

                                    Alert.Show("绑玉不足是否使用勾玉代替？", Alert_Type.Two, () => {
                                        func();
                                    });
                                }
                            }
                            else {
                                func()
                            }
                        }
                        else {
                            if (value > diamond) {
                                no_money_func();
                            }
                            else {
                                func()
                            }
                        }
                    }
                    let name = this.cost_type == Number(1) ? "勾玉" : "绑玉"
                    let str = `是否花费<font color="#0a953e">${this.real_gold_price}</font>${name}购买${this.data.name}`
                    Alert.Show(str, Alert_Type.Two, () => {
                        cost_func()
                    })

                }

            }

        }, this, true)

        this.BindEvent(FunctionOpenModel.GetInstance(), FunctionOpenEvent.FUNCTIONOPEN_GET_REWARD_SUCCESS, (grade: number, moneys: any) => {
            if (!this.data) {
                return;
            }
            if (grade == this.data.grade) { 
                let point = this._box_enter.localToGlobal(new Laya.Point(this._box_enter.width / 2, 0))
                GlobalEventSystem.Fire(EventName.REWARD_FLY, moneys, point, undefined, undefined, 0, 0)
            }
        })

    }

    public dataChanged() {
        if (super.dataChanged()) {
            let data = this.data
            this.cost_type = null
            this.SetSelfData(data)
            this.CreateItem()
            ResManager.GetInstance().SetOutsideImageSprite(this, this.bg, GameResPath.GetIconOtherPath("superGift", `ui_czfl_1${this.color - 1}`))
            ResManager.GetInstance().SetImageSprite(this, this.tag_, "superGift", `ui_czfl_0${5 + this.color}`)
            ResManager.GetInstance().SetImageSprite(this, this.icon, "superGift", `ui_czfl_1${3 + this.color}`, true)
            let gold_name = ""
            if (!this.is_rmb && this.cost_type) {
                let source = this.cost_type == Number(1) ? "com_diamond" : "com_bind_diamond"
                ResManager.GetInstance().SetImageSprite(this, this.gold_img, "common", source)
                gold_name = this.cost_type == Number(1) ? "勾玉" : "绑玉"
            }
            this.btn_lb.text = this.is_rmb ? `￥${this.real_rmb_price}` : `${this.real_gold_price}`
            this.price_lb.text = this.is_rmb ? `${this.price}元` : `${this.price}${gold_name}`
            this.gold_img.width = !this.is_rmb ? 30 : 0
            this.gold_gp.refresh()
            let left_count = this.can_buy_num - data.receive_times
            let color = left_count > 0 ? "#0a953e" : "#ff4f50"
            this.left_lb.innerHTML = `剩余<font color='${color}'>${left_count}</font>/${this.can_buy_num}`
            let parent = <Laya.HBox>this.left_lb.parent
            if (parent) parent.refresh()
            this._box_enter.mouseEnabled = left_count > 0
            this.buyed.visible = left_count <= 0
            this.left_lb.visible = this._box_enter.visible = left_count > 0
        }

    }

    public SetSelfData(data) {
        let condition = ErlangParser.GetInstance().parse(data.condition)
        for (let k in condition) {
            if (condition[k][0] == "exchange_num")
                this.can_buy_num = Number(condition[k][1])
            else if (condition[k][0] == "color")
                this.color = Number(condition[k][1])
            else if (condition[k][0] == "is_rmb")
                this.is_rmb = Number(condition[k][1])
            else if (condition[k][0] == "product_id")
                this.product_id = Number(condition[k][1])
            else if (condition[k][0] == "price") {
                let list = condition[k][1]
                this.price = list[0]
                this.real_rmb_price = list[1]
            } else if (condition[k][0] == "cost") {
                let list = condition[k][1]
                if (list && Util.TableSize(list) > 0) {
                    this.cost_type = list[0][0]
                    this.real_gold_price = list[0][2]
                }
            } else if (condition[k][0] == "tip") {
                this.bg2.visible = Number(condition[k][1]) == 1
            }
        }
    }

    public CreateItem() {
        let reward_list = ErlangParser.GetInstance().parse(this.data.reward)
        if (this.item_list && Util.TableSize(this.item_list) > 0) {
            for (let key in this.item_list) {
                var item = this.item_list[key]
                item.DeleteMe()
            }
            this.item_list = []
        }
        for (let k in reward_list) {
            let reward = reward_list[k]
            let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(reward[0], reward[1])
            if (Number(k) == 0) {
                if (!this.big_item) {
                    this.big_item = new EquipmentItem(this.show_item)
                    this.big_item.Load()
                    this.big_item.SetItemSize(90, 90)
                }
                this.big_item.SetData(type_id, reward[2])
                continue
            }
            if (!this.item_list)
                this.item_list = []
            let item:EquipmentItem = this.item_list[k]
            if (!item) {
                item = new EquipmentItem(this.item_gp)
                item.Load()
                table.insert(this.item_list, item)
            }
            item.SetPosition((Number(k) - 1) * 70, 0)
            item.SetItemSize(68, 68)
            item.SetData(type_id, reward[2], lock)
            item.ExcuteCallback(() => {



            })
        }
    }

    public DeleteMe() {
        if (this.big_item) {
            this.big_item.DeleteMe()
            this.big_item = null
        }
        if (this.item_list && Util.TableSize(this.item_list) > 0) {
            for (let key in this.item_list) {
                var item = this.item_list[key]
                item.DeleteMe()
            }
            this.item_list = []
        }
        super.DeleteMe()
    }



    bg: Laya.Image
    bg2: Laya.Image
    icon: Laya.Image
    tag_: Laya.Image
    _box_enter: Laya.Box
    gold_gp: Laya.HBox
    btn_lb: Laya.Label
    gold_img: Laya.Image
    left_lb: Laya.HTMLDivElement
    show_item: Laya.Box
    item_gp: Laya.Panel
    price_lb: Laya.Label

    public GetComponents() {
        [
            this.bg,
            this.bg2,
            this.icon,
            this.tag_,
            this._box_enter,
            this.gold_gp,
            this.btn_lb,
            this.gold_img,
            this.left_lb,
            this.show_item,
            this.item_gp,
            this.price_lb,
            this.buyed,
        ]
            = this.GetChildrenByNames([

                "bg",
                "bg2",
                "icon",
                "tag_",
                "_box_enter",
                "gold_gp",
                "btn_lb",
                "gold_img",
                "left_lb",
                "show_item",
                "item_gp",
                "price_lb",
                "buyed",
            ])
    }
}
window["SuperGiftItem"] = SuperGiftItem