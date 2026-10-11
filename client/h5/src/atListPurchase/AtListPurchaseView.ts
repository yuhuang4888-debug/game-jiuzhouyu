import { BaseItem1 } from "../common/BaseItem1"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { Config } from "../common/Config"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { GameResPath } from "../util/GameResPath"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { TimeUtil } from "../util/TimeUtil"
import { ErlangParser } from "../util/ErlangParser"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { NotEnougnDiamond, Util } from "../util/Util"
import { Message } from "../sysInfo/SysInfoController"
import { RoleManager } from "../commonModel/RoleManager"
import { Alert, Alert_Type } from "../alert/Alert"
import { OpenFun } from "../common/OpenFun"
import { ItemUseController } from "../commonController/ItemUseController"

export class AtListPurchaseView extends BaseItem1 {
    _img_title: Laya.Image
    _gp_time: Laya.Box
    _img_item_bg: Laya.Image
    rare: Laya.Image
    item_panel: Laya.Panel
    _item_group: Laya.HBox
    _lb_group: Laya.Box
    personal_num: Laya.Label
    all_num: Laya.Label
    price: Laya.Box
    old_price: Laya.Label
    new_price: Laya.Label
    money_1: Laya.Image
    money_2: Laya.Image
    _buy_btn: Laya.Box
    _lb_btn: Laya.Label
    point_gp: Laya.Box
    big_num: Laya.Image
    small_num: Laya.Image

    InitView
    InitEvent
    LoadSuccess
    Local_DeleteMe
    Settime
    UpdateView
    CreateItem
    SetBtn
    data
    info
    item_group_
    public constructor(parent?) {
        super(parent)


        this.base_file = "atListPurchase"
        this.layout_file = "AtListPurchaseView"
        this.is_load_res = false
        let model = CustomActivityModel.GetInstance()
        this.item_group_ = []
        let local_CustomActivityDefine = CustomActivityDefine
        let cfg_ = null
        let base_type_ = Config.PRELOAD_CLIENT_CONFIG.ConfigCustomActivity.ACT_ID.ATLISTPURCHASE
        let show_id_ = 0
        let sub_type_ = 1
        let condition_list
        let reward_info
        let all_buy_num //全服已经够的数量
        let timer = null
        this.preload_server_config = {

        }
        this.load_callback = () => {
            this.LoadSuccess()
        }

        this.InitEvent = () => {
            Util.AddClickEvent(this._buy_btn, () => {
                if (this._lb_btn.text == "购买") {
                    let role_vo = RoleManager.GetInstance().mainRoleInfo
                    let have_money = role_vo.jin
                    let have_money_2 = role_vo.jinLock
                    let request = () => {
                        model.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33179, this.info.base_type, this.info.sub_type, reward_info.grade, 1)
                    }
                    // if (have_money_2 >= condition_list.price[3] && condition_list.price[1] == 1) {
                    let tip_func = ()=>{
                        let str = null
                        if(condition_list.price[1] == 1){
                            str = "还需要<font color='#639c12'>" + (condition_list.price[3] - have_money) + "勾玉</font>才能购买礼包，是否前往充值？"
                        }else if(condition_list.price[1] == 2){
                            str = "还需要<font color='#639c12'>" + (condition_list.price[3] - have_money - have_money_2) + "勾玉</font>才能购买礼包，是否前往充值？"
                        }
                        // str = "还需要<font color='#639c12'>" + (condition_list.price[3] - have_money - have_money_2) + "勾玉</font>才能购买礼包，是否前往充值？"
                        Alert.Show(str, Alert_Type.Two, () => {
                            let state = CustomActivityModel.GetInstance().GetSuperGiftBuyState()
                            if(state){
                                OpenFun.OpenFunHandler(21);
                            }else{
                                OpenFun.OpenFunHandler(249);
                            }
                            // OpenFun.OpenFunHandler(21)
                        })
                    }

                    if(condition_list.price[1] == 1){
                        if(have_money >= condition_list.price[3]){
                            request()
                        }else{
                            tip_func()
                        }
                    } else if(condition_list.price[1] == 2){
                        if(have_money + have_money_2 >= condition_list.price[3]){
                            request()
                        }else{
                            tip_func()
                        }
                    }

                    // if (have_money >= condition_list.price[3]) {
                    //     request()
                    // } else if (have_money + have_money_2 >= condition_list.price[3]) {
                    //     let str = null
                    //     str = "勾玉不足，还需要<font color='#639c12'>" + (condition_list.price[3] - have_money_2) + "勾玉</font>才能购买礼包，是否购买？"
                    //     Alert.Show(str, Alert_Type.Two, () => {
                    //         request()
                    //     })
                    // } else {
                    //     let str = null
                    //     if(condition_list.price[1] == 1){
                    //         str = "还需要<font color='#639c12'>" + (condition_list.price[3] - have_money) + "勾玉</font>才能购买礼包，是否前往充值？"
                    //     }else if(condition_list.price[1] == 2){
                    //         str = "还需要<font color='#639c12'>" + (condition_list.price[3] - have_money - have_money_2) + "勾玉</font>才能购买礼包，是否前往充值？"
                    //     }
                    //     // str = "还需要<font color='#639c12'>" + (condition_list.price[3] - have_money - have_money_2) + "勾玉</font>才能购买礼包，是否前往充值？"
                    //     Alert.Show(str, Alert_Type.Two, () => {
                    //         let state = CustomActivityModel.GetInstance().GetSuperGiftBuyState()
                    //         if(state){
                    //             OpenFun.OpenFunHandler(21);
                    //         }else{
                    //             OpenFun.OpenFunHandler(249);
                    //         }
                    //         // OpenFun.OpenFunHandler(21)
                    //     })
                    // }
                } else {
                    if (condition_list.personal_num == reward_info.receive_times && condition_list.all_num > all_buy_num) {
                        Message.show("个人已售空")
                    } else {
                        Message.show("商品已售空")
                    }
                }
            }, this, true)

            this.BindEvent(model, CustomActivityDefine.EVENT.UPDATE_ALL_COUNT, (...new_args) => {
                let args = new_args
                if (args && args[2] && args[2].count != undefined) {
                    all_buy_num = args[2].count
                    this.all_num.text = (condition_list.all_num - all_buy_num) + "/" + condition_list.all_num
                    this.SetBtn()
                }

            })

            this.BindEvent(model, CustomActivityDefine.EVENT.UPDATE_VIEW, (base_type?, sub_type?) => {
                if (this.use_delete_method) { return }
                if (this.info && this.info.base_type == base_type && this.info.sub_type == sub_type) {
                    this.UpdateView()
                }
            })
            let GetReward = (...new_args) => {
                let args = new_args
                if (this.info.base_type == args[0] && this.info.sub_type == args[1]) {
                    let data = []
                    let info = args[3]
                    let reward = model.GetActReward(this.info.base_type, this.info.sub_type, info.form_type, info.reward)
                    if (reward.length > 0) {
                        let view = new CongratulationObtainView(reward, 10)
                        view.Open()
                    }
                    this.UpdateView()
                }
            }

            this.BindEvent(model, local_CustomActivityDefine.EVENT.ANSWER_TARGET, GetReward)
        }


        this.LoadSuccess = () => {
            this.data = model.GetActData(this.info.base_type, this.info.sub_type)
            reward_info = this.data.reward_list[0]
            condition_list = model.GetActCondition(this.info.base_type, this.info.sub_type, "data", reward_info.grade)
            model.Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33106, this.info.base_type, this.info.sub_type, condition_list.counter[1], condition_list.counter[2], reward_info.grade)
            let str = condition_list.price[1] == 1 ? "34" : "35"
            ResManager.GetInstance().SetTexture(this, this.money_1, GameResPath.GetGoodsIconPath(str))
            ResManager.GetInstance().SetTexture(this, this.money_2, GameResPath.GetGoodsIconPath(str))
            if (!this.info) return
            // ResManager.GetInstance().SetTexture(ths,this._img_title,GameResPath.GetIcon("atListPurchase",""))
            model.CloseACTRed(this.info.base_type, this.info.sub_type)
            this.InitEvent()
            this.UpdateView()
            ResManager.GetInstance().SetTexture(this, this._img_title, GameResPath.GetIcon("atListPurchase", "ui_1"))
        }



        this.UpdateView = () => {
            this.data = model.GetActData(this.info.base_type, this.info.sub_type)
            reward_info = this.data.reward_list[0]
            condition_list = model.GetActCondition(this.info.base_type, this.info.sub_type, "data", reward_info.grade)
            this.CreateItem()
            this.SetBtn()
            this.Settime()
            this.personal_num.text = (condition_list.personal_num - reward_info.receive_times) + "/" + condition_list.personal_num
            this.old_price.text = condition_list.price[2]
            this.new_price.text = condition_list.price[3]

            let dis = condition_list.rare
            let [num, num_point] = CustomActivityModel.GetInstance().GetActDis(dis)
			this.rare.visible = num_point == 0
			this.point_gp.visible = num_point != 0
			if (num_point == 0) {
				ResManager.GetInstance().SetImageSprite(this, this.rare, "atListPurchase", "qg" + dis)
			}
			else {
				ResManager.GetInstance().SetImageSprite(this, this.big_num, "atListPurchase", "big0" + num)
				ResManager.GetInstance().SetImageSprite(this, this.small_num, "atListPurchase", "small0" + num_point)
			}
            
        }

        this.CreateItem = () => {
            if (this.item_group_.length > 0) {
                for (let key in this.item_group_) {
                    var item = this.item_group_[key]
                    item.DeleteMe()
                }
                this.item_group_ = []
            }
            let reward_ = ErlangParser.GetInstance().Parse(reward_info.reward)
            let count = 0
            for (let key in reward_) {
                let item
                if (!item) {
                    item = new BaseAwardItem(this._item_group)
                    item.Load()
                    item.SetItemSize(87, 87)
                    table.insert(this.item_group_, item)
                }
                let callback = () => {
                    item.visible = true
                    item.SetData(reward_[key][1], reward_[key][2])
                    count++
                    if (count == reward_.length) {
                        if ((87 * count + 10 * (count - 1)) > 380) {
                            this.item_panel.width = 380
                        } else {
                            this.item_panel.width = (87 * count + 10 * (count - 1))
                        }
                    }
                }

                item.ExcuteCallback(callback)
            }
        }

        this.SetBtn = () => {
            if (condition_list.personal_num > reward_info.receive_times && condition_list.all_num > all_buy_num) {
                this._lb_btn.text = "购买"
            } else {
                this._lb_btn.text = "已售空"
            }

        }

        this.Settime = (end_time?) => {
            if (timer) {
                timer.DeleteMe()
                timer = null
            }
            timer = model.LoadActTimer(this._gp_time, this.info.etime, 22, "#0a953e", null, "#a64b47", "活动倒计时：")
        }

        this.Local_DeleteMe = () => {

            if (timer) {
                timer.DeleteMe()
                timer = null
            }
            if (this.item_group_.length > 0) {
                for (let key in this.item_group_) {
                    var item = this.item_group_[key]
                    item.DeleteMe()
                }
                this.item_group_ = []
            }
        }
    }

    public CustomMehod(index?, info?) {
        this.info = info
    }

    public DeleteMe() {

        this.Local_DeleteMe()
        super.DeleteMe()
    }



    public GetComponents() {
        [
            this._img_title,
            this._gp_time,
            this._img_item_bg,
            this.rare,
            this.item_panel,
            this._item_group,
            this._lb_group,
            this.personal_num,
            this.all_num,
            this.price,
            this.old_price,
            this.new_price,
            this.money_1,
            this.money_2,
            this._buy_btn,
            this._lb_btn,
            this.point_gp,
            this.big_num,
            this.small_num,
        ]
            = this.GetChildrenByNames([

                "_img_title",
                "_gp_time",
                "_img_item_bg",
                "rare",
                "item_panel",
                "_item_group",
                "_lb_group",
                "personal_num",
                "all_num",
                "price",
                "old_price",
                "new_price",
                "money_1",
                "money_2",
                "_buy_btn",
                "_lb_btn",
                "point_gp",
                "big_num",
                "small_num",
            ])
            this.item_panel.hScrollBarSkin = ""
            this.item_panel.hScrollBar.visible = false
    }
}
window["AtListPurchaseView"] = AtListPurchaseView