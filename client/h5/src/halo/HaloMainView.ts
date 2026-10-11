///@描述:view
///@作者:fengning
///@Laya版本:2.12.2
///@日期:2022-11-23 14:25

import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { GoodsModel } from "../commonModel/GoodsModel"
import { HaloModel } from "../commonModel/HaloModel"
import { VipModel } from "../commonModel/VipModel"
import { ServerModel } from "../login/ServerModel"
import { PlatformManager } from "../PlatformManager"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, Util } from "../util/Util"
import { HaloItem } from "./HaloItem"

export class HaloMainView extends BaseView1 {
    /*----这里定义变量-----*/
    model
    loop_mgr
    LoadSucess
    InitEvent
    UpdateItem
    config
    globle_config
    recharge_config
    UpdateView
    OnTimer
    removeTimer
    _timer
    data

    /*---------------------*/
    public constructor() {
        super()
        this.base_file = "halo"
        this.layout_file = "HaloMainView"
        this.layer_value = Enum_UILayer.Activity
        this.is_center = true
        this.destroy_imm = true
        this.use_background = true
        this.click_bg_toClose = true
        this.show_open_movie = true
        
        let local_ResManager = ResManager.GetInstance()
        let local_EventName = EventName
        this.model = HaloModel.GetInstance()
        this.preload_server_config = {
            "config_hero_halo": false,
            "config_key_value": false,
            "config_recharge_product": false
        }

        this.config = null
        this.data = null
        
        this.load_callback = () => {
            this.data = this.model.GetHaloData()
            this.InitEvent()
            this.LoadSucess()
        }

        this.LoadSucess = ()=> {
            local_ResManager.SetOutsideImageSprite(this, this.img_bg, GameResPath.GetIconOtherPath("halo","ui_zjgh_01"), false)
            local_ResManager.SetOutsideImageSprite(this, this.img_bottom_banner, GameResPath.GetIconOtherPath("halo", "ui_zjgh_bg11"), false)
            this.config = ResManager.GetInstance().GetGameConfigFromCache(this, "config_hero_halo", false)
            this.globle_config = ResManager.GetInstance().GetGameConfigFromCache(this, "config_key_value", false)
            this.recharge_config = ResManager.GetInstance().GetGameConfigFromCache(this, "config_recharge_product", false)
        }

        this.InitEvent = ()=> {
            this.BindEvent(this.model, HaloModel.UPDATE_ITEM, ()=> {
                this.UpdateItem()
            })

            this.BindEvent(this.model, HaloModel.UPDATE_TIME, ()=> {
                this.OnTimer()
            })

            Util.AddClickEvent(this.img_btn_buy, ()=>{
                let data = this.globle_config[5140000]
                let product_id = data ? data.value : null
                if (product_id) {
                    let product_info = this.recharge_config[product_id]
                    let hasNum: number = GoodsModel.GetInstance().GetTypeGoodsNum(36210008) // 写死默认拿这个道具
                    let real_rmb_price = product_info.money
                    if (hasNum >= Number(real_rmb_price)) {
                        VipModel.GetInstance().Fire(VipModel.REQUEST_PROTO, 15804, 'i', product_id)
                    }
                    else {
                        if (product_info) {
                            PlatformManager.GetInstance().PayRequest(product_info.money, { id: product_info.product_id, pay_title: product_info.product_name }, (ret) => {
                                if (ret == 'SUCCESS') {
                                }
                            })
                        }
                    }
                }
            },this, true)

            Util.AddClickEvent(this.img_btn_close, ()=>{
                this.Close()
            }, this, true)

            Util.AddClickEvent(this.box_effect, ()=>{
                let type_id = 38065414
                UIToolTipMgr.GetInstance().AppendIllusionTips(type_id)
            },this, true)
        }
        
        this.open_callback = () => {
            this.UpdateView()
            this.UpdateItem()
            this.OnTimer()  
        }

        this.UpdateView = () => {
            this.html_time.visible = false
            // this.box_buy.visible = false
            let glob_cfg = this.globle_config
            let data = glob_cfg[5140000]
            let product_id = data ? data.value : null
            let product_info = this.recharge_config[product_id]
            let original_price = glob_cfg[5140002].value
            let now_price = product_info.money
            this.lable_original_price.text = `原价: ${original_price}元`
            this.lable_now_price.text = `现价: ${now_price}元`
            this.box_effect.height = 200
            this.box_effect.width = 300
            this.box_effect.y = 15
            this.AddUIEffect("UI_305414", this.box_effect, {x:0, y:0}, 8, true)


            //这里更具光环是否购买来判断，更改文字以及显示隐藏组件
            // this.lable_buy.text = `立即购买`
        }

        this.OnTimer = ()=> {
            if(!this.model.GetHaloData()){
                return
            }
            this.removeTimer()
            let end_time = this.model.GetHaloData().end_time
            if(!end_time){
                this.img_bottom_banner.visible = true
                this.list_middle.height = 583
                return
            }
            this.html_time.style.fontSize = 20
            this.html_time.style.wordWrap = false
            this.html_time.style.color = "#00fa64"
            this.html_time.x = 458
            this.html_time.y = 195
            let time_fun = ()=>{
                let _time = end_time - TimeUtil.getServerTime()
                let five_day = Number(this.globle_config[5140003].value)
                if(_time > 0){
                    this.html_time.visible = true
                    //当时间还剩余5天的时候，提醒续费
                    if(_time <= five_day){
                        this.img_bottom_banner.visible = true
                        this.list_middle.height = 583
                        this.lable_buy.text = `立即续费`
                    }else{
                        this.img_bottom_banner.visible = false
                        this.list_middle.height = 741
                        // this.lable_buy.text = `立即购买`
                    }
                    this.html_time.innerHTML = TimeUtil.timeConvert(_time, "dd-hh-mm-ss")
                }else{
                    this.html_time.visible = false
                    this.removeTimer()
                }
            }

            if(!this._timer){
                this._timer = GlobalTimerQuest.AddPeriodQuest(()=>{
                    time_fun()
                } ,0.1 ,-1)
            }
        }

        this.removeTimer = ()=> {
            if (this._timer) {
                GlobalTimerQuest.CancelQuest(this._timer)
                this._timer = null
            }
        }

        this.UpdateItem = () => {
            let list = []
            if(this.model.is_new_reward){
                list = this.model.ConsolidateData()
                this.model.SetOpenRewardCanGetState()
                this.model.is_new_reward = false
            }else{
                for (let key in this.config) {
                    let data = this.config[key]
                    table.insert(list, data)
                }
                let func_sort = (a, b)=> {
                    return a.weight > b.weight
                }
                table.sort(list, func_sort)
            }

            if(!this.loop_mgr){
                this.loop_mgr = new LoopScrowViewMgr()
                this.loop_mgr.SetData(this.list_middle, HaloItem, list , LoopScrCon.Vertical)
            }else{
                this.loop_mgr.replaceAll(list)
            }
        }
        
        this.destroy_callback = () => {
            this.DestroyCallback()
        }
    }
    
    
    public DestroyCallback() {
        if (this.loop_mgr) {
            this.loop_mgr.DeleteMe()
            this.loop_mgr = null
        }
        this.removeTimer()
        this.ClearUIEffect(this.box_effect)

    }
    
    img_bg:Laya.Image
    img_btn_close:Laya.Image
    html_time:Laya.HTMLDivElement
    list_middle:Laya.List
    img_bottom_banner:Laya.Image
    img_btn_buy:Laya.Image
    lable_buy:Laya.Label
    img_now_price:Laya.Image
    lable_now_price:Laya.Label
    lable_original_price:Laya.Label
    img_line:Laya.Image
    box_buy:Laya.Box
    box_effect:Laya.Box

    public GetComponents() {
    [
        this.img_bg,
        this.img_btn_close,
        this.html_time,
        this.list_middle,
        this.img_bottom_banner,
        this.img_btn_buy,
        this.lable_buy,
        this.img_now_price,
        this.lable_now_price,
        this.lable_original_price,
        this.img_line,
        this.box_buy,
        this.box_effect
    ]
    = this.GetChildrenByNames([
        "img_bg",
        "img_btn_close",
        "html_time",
        "list_middle",
        "img_bottom_banner",
        "img_btn_buy",
        "lable_buy",
        "img_now_price",
        "lable_now_price",
        "lable_original_price",
        "img_line",
        "box_buy",
        "box_effect"
        ])
    }
}
 window["HaloMainView"]= HaloMainView