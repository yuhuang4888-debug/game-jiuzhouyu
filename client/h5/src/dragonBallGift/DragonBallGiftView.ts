///@描述:view
///@作者:fengning
///@Laya版本:2.12.2
///@日期:2022-11-14 17:02

import { BaseView1 } from "../common/BaseView1"
import { EquipmentItem } from "../common/EquipmentItem"
import { FightingShowSmallItem } from "../common/FightingShowSmallItem"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { DragonBallModel } from "../commonModel/DragonBallModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { VipModel } from "../commonModel/VipModel"
import { PlatformManager } from "../PlatformManager"
import { Message } from "../sysInfo/SysInfoController"
import { ColorType, ColorUtil } from "../util/ColorUtil"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { AtlasUrl, RefBoxChildsLayout, SetLocalPosition, Util } from "../util/Util"

export class DragonBallGiftView extends BaseView1 {
    /*----这里定义变量-----*/
    model
    LoadCallback
    InitEvent
    DestroyCallback
    UpdateView
    UpdateRewardItem
    rewrd_item_list
    config
    data
    fight_num
    scmd

    local_gift_id
    /*---------------------*/
    public constructor() {
        super()
        this.base_file = "dragonBallGift"
        this.layout_file = "DragonBallGiftView"
        this.layer_value = Enum_UILayer.Activity
        let local_ResManager = ResManager.GetInstance()
        this.is_center = true
        this.destroy_imm = true
        this.use_background = true
        this.click_bg_toClose = true
        this.show_open_movie = true
        this.model = DragonBallModel.GetInstance()
        this.rewrd_item_list = []
        this.config = null
        this.data = null
        this.fight_num = null
        this.scmd = null
        let max_buy_time = 1
        this.preload_server_config = {
            "config_start_nuclear": false,
            "config_recharge_product": false
        }

        this.load_callback = () => {
            this.InitEvent()
            this.LoadCallback()
            // this.model.Fire(DragonBallModel.REQUEST_SCMD, 14311)
        }
        
        this.open_callback = () => {
            this.config = ResManager.GetInstance().GetGameConfigFromCache(this, "config_start_nuclear", false)
            this.UpdateView()
        }

        this.close_callback = () =>{
            this.local_gift_id = null
        }
        
        this.destroy_callback = () => {
            this.DestroyCallback()
        }

        this.LoadCallback = ()=> {
            local_ResManager.SetOutsideImageSprite(this, this.img_title_bg, GameResPath.GetIconOtherPath("dragonBallGift", "ui_lygm_title_bg"), false)
            local_ResManager.SetOutsideImageSprite(this, this.img_reward_bg, GameResPath.GetIconOtherPath("dragonBallGift", "ui_lygm_bg"), false)
        }

        this.InitEvent = ()=> {
            Util.AddClickEvent(this.img_close, ()=> {
                this.Close()
            },this,true)

            Util.AddClickEvent(this.img_buy, ()=>{
                if(this.scmd.id == 0 || max_buy_time - this.scmd.buy_times <= 0){
                    Message.show("已达到购买上限")
                    return
                }
                let product_id = this.data.recharge_id
                if (product_id) {
                    let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_recharge_product", false)
                    let product_info_ = cfg[product_id]
                    let hasNum: number = GoodsModel.GetInstance().GetTypeGoodsNum(36210008) // 写死默认拿这个道具
                    let real_rmb_price = this.data.price
                    if (hasNum >= Number(real_rmb_price)) {
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
            },this, true)

            this.BindEvent(this.model, DragonBallModel.UPDATE_GIFT_VIEW, (scmd)=>{
                if(this.local_gift_id && this.local_gift_id != scmd.id){
                    //切换礼包时需要关闭界面
                    this.Close()
                    return
                }
                this.UpdateView()
            })
        }

        this.UpdateView = ()=> {
            let scmd = this.model.dragon_gift_data
            if(!scmd || !this.config){
                return
            }
            this.local_gift_id = scmd.id
            this.scmd = scmd
            if(scmd.id != 0){
                this.data = this.config[scmd.id]
                max_buy_time = this.data.times_limit
            }
            
            let can_buy_times = max_buy_time - scmd.buy_times
            if(scmd.id == 0){
                Util.SetImageGray(this.img_buy, true)
                return
            }
            let img_reward_str = `ui_lygm_ly${scmd.id}`
            local_ResManager.SetOutsideImageSprite(this, this.img_reward, GameResPath.GetIconOtherPath("dragonBallGift", img_reward_str), false)
            let img_tittle_str = `ui_lygm_title${scmd.id}`
            local_ResManager.SetOutsideImageSprite(this, this.img_title, GameResPath.GetIconOtherPath("dragonBallGift", img_tittle_str), false)
            this.img_desc.skin = AtlasUrl("dragonBallGift",`ui_desc_0${scmd.id}`)
            let price_str = null
            if(this.data.price == 30){
                price_str = `ui_lygm_02`
            }else if(this.data.price == 68){
                price_str = `ui_lygm_01`
            }
            this.img_price.skin = AtlasUrl("dragonBallGift", price_str)
            this.UpdateRewardItem(scmd.id)
            this.lable_price.text = `￥${this.data.price}`
            if(this.data.good_id){
                let data = this.model.GetDrageonData(this.data.good_id)
                let fight = data.next_power
                this.fight_num = new FightingShowSmallItem(this.box_fight)
                this.fight_num.Load()
                this.fight_num.Updatefighting(fight)
                this.fight_num.IsCenter(true, false)
            }else{
                this.box_fight.visible = false
            }
            Util.SetImageGray(this.img_buy, can_buy_times <= 0)
            if(this.data.send_id == scmd.id){
                this.html_buy_times.visible = true
                SetLocalPosition(this.img_buy, 330, 890)
                SetLocalPosition(this._tip_accu, 286, 990)
            }else{
                this.html_buy_times.visible = false
                SetLocalPosition(this.img_buy, 330, 860)
                SetLocalPosition(this._tip_accu, 286, 965)
            }
            this.html_buy_times

            this.html_buy_times.style.color = "#ffffff"
            this.html_buy_times.style.fontSize = 24
            this.html_buy_times.style.wordWrap = false

            let color = null
            if(can_buy_times > 0){
                color = "'#ffffff'"
            }else{
                color = ColorUtil.GetColorLight(ColorType.RED)
            }
            this.html_buy_times.innerHTML = `每日限购<font color = ${color}>${can_buy_times}</font>/${max_buy_time}`
            RefBoxChildsLayout(this.box_middle_reward, 0, null, true, "center")
        }

        this.UpdateRewardItem = (gift_id)=> {
            if(!this.config){
                return
            }

            if (this.rewrd_item_list && this.rewrd_item_list.length > 0) {
				for (let k in this.rewrd_item_list) {
					var item = this.rewrd_item_list[k]
					item.DeleteMe()
				}
				this.rewrd_item_list = []
			}

            let reward_data = Util.DeepCopy(this.config[gift_id].reward)
            let reward_list = ErlangParser.GetInstance().Parse(reward_data)
            for (let key in reward_list) {
                let vo = reward_list[key]
                let idx = Number(key)
                let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(vo[0], vo[1])
                let item = this.rewrd_item_list[idx]
                if(!item){
                    item = new EquipmentItem(this.box_middle_reward)
                    this.rewrd_item_list[idx] = item
                    item.Load()
                    item.SetItemSize(85, 85)
                }
                let y = 0
                if((idx + 1) == 1 || (idx + 1) == 4){
                    y = -15
                }else{
                    y = -3
                }
                item.SetPosition(idx * 110, y)
                item.SetData(type_id, vo[2], lock)
            }
        }

        this.DestroyCallback = ()=>{
            if (this.rewrd_item_list && this.rewrd_item_list.length > 0) {
				for (let k in this.rewrd_item_list) {
					var item = this.rewrd_item_list[k]
					item.DeleteMe()
				}
				this.rewrd_item_list = []
			}

            if (this.fight_num) {
                this.fight_num.DeleteMe()
                this.fight_num = null
            }
        }
    }

    img_title_bg:Laya.Image
    img_title:Laya.Image
    box_reward:Laya.Box
    img_reward_bg:Laya.Image
    img_reward:Laya.Image
    img_price:Laya.Image
    img_desc:Laya.Image
    img_close:Laya.Image
    img_buy:Laya.Image
    lable_price:Laya.Label
    box_middle_reward:Laya.Box
    box_fight: Laya.Box
    html_buy_times: Laya.HTMLDivElement
    _tip_accu: Laya.Image
    
    public GetComponents() {
    [
        this.img_title_bg,
        this.img_title,
        this.box_reward,
        this.img_reward_bg,
        this.img_reward,
        this.img_price,
        this.img_desc,
        this.img_close,
        this.img_buy,
        this.lable_price,
        this.box_middle_reward,
        this.box_fight,
        this.html_buy_times,
        this._tip_accu
    ]
    = this.GetChildrenByNames([
        "img_title_bg",
        "img_title",
        "box_reward",
        "img_reward_bg",
        "img_reward",
        "img_price",
        "img_desc",
        "img_close",
        "img_buy",
        "lable_price",
        "box_middle_reward",
        "box_fight",
        "html_buy_times",
        "_tip_accu"
        ])
    }
}
 window["DragonBallGiftView"]= DragonBallGiftView