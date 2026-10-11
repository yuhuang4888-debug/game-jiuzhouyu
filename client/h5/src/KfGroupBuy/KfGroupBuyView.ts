
import { Alert, Alert_Type } from "../alert/Alert";
import { BaseItem1 } from "../common/BaseItem1";
import { EquipmentItem } from "../common/EquipmentItem";
import { EventName } from "../common/EventName";
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr";
import { ResManager } from "../common/ResManager";
import { table } from "../common/table";
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine";
import { CustomActivityModel } from "../commonModel/CustomActivityModel";
import { GoodsModel } from "../commonModel/GoodsModel";
import { RoleManager } from "../commonModel/RoleManager";
import { ComActTimerView } from "../customActivity/ComActTimerView";
import { PlatformManager } from "../PlatformManager";
import { Message } from "../sysInfo/SysInfoController";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { ErlangParser } from "../util/ErlangParser";
import { GameResPath } from "../util/GameResPath";
import { TimeUtil } from "../util/TimeUtil";
import { AtlasUrl, GlobalTimerQuest, NotEnougnDiamond, RefBoxChildsLayout, SetLocalPosition, Util } from "../util/Util";
import { KfGBDiscountItem } from "./KfGBDiscountItem";
import { KfGBShopItem } from "./KfGBShopItem";


//跨服团购，功能移植
export class KfGroupBuyView extends BaseItem1 {
    CustomMehod
    InitEvent
    InitView
    CreatKfGBShopItem
    RefGoodsInfo
    RefShops
    RefTime
    UpdateRewardItems
    UpdateDiscountItems
    reward_loop_mgr
    discount_loop_mgr
    vo
    UpdateSpeakBtnCd
    is_can_click_speak_btn
    gp_goods
    CancelTime
    time_id
    select_index
    public constructor(parent) {
        super(parent)
        this.base_file = "kfGroupBuy"
        this.layout_file = "KfGroupBuyView"
        let local_EVENT = CustomActivityDefine.EVENT,
            local_Util = Util,
            local_ResManager = ResManager.GetInstance(),
            model = CustomActivityModel.GetInstance(),
            local_GoodsModel = GoodsModel.GetInstance(),
            info,
            data,
            base_type,
            sub_type,
            goods_item: EquipmentItem,
            time_item: ComActTimerView,
            discount_items = [],
            is_buy = true,
            limit_num = 0,
            pro_num = 0,
            buy_num = 0,
            cur_money = 0,
            select_grade,
            select_index,
            last_shout_time = 0
        this.gp_goods = null
        this.Load()
        this.reward_loop_mgr = null
        this.discount_loop_mgr = null
        this.is_can_click_speak_btn = true
        this.select_index = null

        this.load_callback = () => {
            this.InitView()
            this.InitEvent()
        }

        this.InitView = () => {
            // local_ResManager.SetOutsideImageSprite(this, this._img0, GameResPath.GetIconJpgOtherPath("kfGroupBuy", "ui_kftg_bg"), false)
            local_ResManager.SetOutsideImageSprite(this, this._img1, GameResPath.GetIconOtherPath("kfGroupBuy", "ui_kftg_01"), false)
            local_ResManager.SetOutsideImageSprite(this, this._gp_btn, GameResPath.GetIconOtherPath("kfGroupBuy", "ui_kftg_02"), false)
            local_ResManager.SetOutsideImageSprite(this, this.img_role, GameResPath.GetIconOtherPath("kfGroupBuy", "ui_kftg_18"), false)
            local_ResManager.SetOutsideImageSprite(this, this._Image5, GameResPath.GetIconOtherPath("kfGroupBuy", "ui_kftg_03"), false)
            local_ResManager.SetOutsideImageSprite(this, this._Image1, GameResPath.GetIconOtherPath("kfGroupBuy", "ui_kftg_15"), false)
            local_ResManager.SetOutsideImageSprite(this, this._Image6, GameResPath.GetIconOtherPath("kfGroupBuy", "ui_kftg_17"), false)
            // local_ResManager.SetOutsideImageSprite(this, this.img_speak, GameResPath.GetIconOtherPath("kfGroupBuy", "ui_kftg_08"), false)
            local_ResManager.SetOutsideImageSprite(this, this._record, GameResPath.GetIconOtherPath("kfGroupBuy", "ui_button_rect11"), false)
            local_ResManager.SetOutsideImageSprite(this, this._Image4, GameResPath.GetIconOtherPath("kfGroupBuy", "ui_kftg_16"), false)
            local_ResManager.SetOutsideImageSprite(this, this._Image10, GameResPath.GetIconOtherPath("kfGroupBuy", "com_arrow_left"), false)
            local_ResManager.SetOutsideImageSprite(this, this._Image11, GameResPath.GetIconOtherPath("kfGroupBuy", "com_arrow_left"), false)

            if (!info) return
            base_type = info.base_type
            sub_type = info.sub_type
            data = model.GetActData(base_type, sub_type)
            if (!data) return
            model.CloseACTRed(base_type, sub_type)
            if (this.is_loaded) {
                this.RefTime()
                this.RefShops()
                this.RefGoodsInfo(this.vo)
                this.UpdateSpeakBtnCd(null, data.last_shout_time)
            }
        }

        this.UpdateRewardItems = (list) => {
            let idx = 0

            table.sort(list, (a?, b?)=>{
                return a.grade < b.grade
            })

            if(this.select_index){
                for (let key in list) {
                    let vo = list[key]
                    if(this.select_index == vo.grade){
                        idx = Number(key)
                        break
                    }
                }
                this.select_index = null
            }

            let select_func = (index?)=>{
                this.vo = list[index]
                this.RefGoodsInfo(this.vo)
            }
            
            if (!this.reward_loop_mgr) {
                this.reward_loop_mgr = new LoopScrowViewMgr()
                this.reward_loop_mgr.SetData(this._list_reward, KfGBShopItem, list, LoopScrCon.Horizontal, null, select_func, idx)
                let gap = this._list_reward.spaceX
				let itemWidth = 95
                this._list_reward.scrollBar.value = Math.max((itemWidth + gap) * (Number(idx) + 1) - this._list_reward.width, 0)
            } else {
                this.reward_loop_mgr.replaceAll(list)
            }
            
        }

        this.UpdateDiscountItems = (vo) => {
            if (!this.discount_loop_mgr) {
                this.discount_loop_mgr = new LoopScrowViewMgr()
                this.discount_loop_mgr.SetData(this._gp_discount, KfGBDiscountItem, vo, LoopScrCon.Vertical, null)
            } else {
                this.discount_loop_mgr.replaceAll(vo)
            }
        }

        this.InitEvent = () => {
            local_Util.AddClickEvent(this._gp_btn, () => {
                if (limit_num <= pro_num) {
                    let str = is_buy ? `已达到最大订购次数` : limit_num == 0 ? `没有订购该商品` : `已支付所有订购商品`
                    Message.show(str)
                    return
                }
                let jin = RoleManager.GetInstance().mainRoleInfo.jin
                let request = () => {
                    model.Fire(local_EVENT.SCMD_REQUEST, 33229, base_type, sub_type, select_grade, is_buy ? 1 : 2)
                }
                if (jin >= cur_money) {
                    let key = is_buy ? `buy_open` : `pay_open`
                    let bool = model.getKeyDicValue(base_type, sub_type, key)
                    let open = true
                    if (bool == false)
                        request()
                    else {
                        let str = `是否消耗<font color='#0a953e'>${cur_money}</font>勾玉${is_buy ? `预定` : `购买`}该商品`
                        Alert.Show(str, Alert_Type.AlertTypeCheckBox, () => {
                            model.setKeyDicValue(base_type, sub_type, key, open)
                            request()}, undefined, undefined, undefined, undefined, undefined, () => {
                            open = !open
                        })
                    }
                } else {
                    NotEnougnDiamond()
                }
            }, this, true)

            local_Util.AddClickEvent(this._record, () => {
                GlobalEventSystem.Fire(EventName.OPEN_VIEW, "KfGBRecordView", info)
            }, this, true)

            local_Util.AddClickEvent(this.img_speak, ()=> {
                if(!this.is_can_click_speak_btn){
                    Message.show("冷却中")
                    return
                }
                let grade_id = null
                grade_id = Number(this.gp_goods.grade_id)
                model.Fire(local_EVENT.SCMD_REQUEST, 33267, base_type, sub_type, grade_id)
            }, this, true)

            this.BindEvent(model, local_EVENT.UPDATE_VIEW, (...args) => {
                if (base_type && base_type == args[0] && sub_type == args[1] && info) {
                    data = model.GetActData(base_type, sub_type)
                    if (data) {
                        this.RefTime()
                        this.RefShops()
                        this.RefGoodsInfo(this.vo)
                    }
                }
            })

            this.BindEvent(model, local_EVENT.ANSWER_TARGET, (...args) => {
                if (base_type && base_type == args[0] && sub_type == args[1] && info) {
                    data = model.GetActData(base_type, sub_type)
                    if (data) {
                        this.RefShops()
                        this.RefGoodsInfo(this.vo)
                    }
                }
            })

            this.BindEvent(model, local_EVENT.UPDATE_GROUP_BUY_SPEAK_TIME, (new_args)=> {
                this.UpdateSpeakBtnCd(new_args)
            })
        }

        this.UpdateSpeakBtnCd = (scmd?, time?)=>{
            let condition = ErlangParser.GetInstance().Parse(info.condition)
            let cd_time = Number(condition[1][1])//读配置
            if(cd_time == 0){
                this.img_speak.visible = false
            }else{
                this.img_speak.visible = is_buy
            }
            // let cd_time = 60//读配置
            this.CancelTime()
            //这里做一层保证，防止click_btn哪儿的判断失效
            if(scmd){ 
                if(scmd.last_shout_time == 0){
                    Message.show("冷却中")
                    this.CancelTime()
                    return
                }
            }
            if(time && time != 0){
                last_shout_time = time
            }else if(time == 0){
                return
            } else{
                last_shout_time = (last_shout_time == scmd.last_shout_time) ? last_shout_time : scmd.last_shout_time
            }
            let func = () => {
                let cur_time = TimeUtil.getServerTime()
                let end_time = cur_time - last_shout_time
                let time = cd_time - end_time
                if(time > 0){ //说明还在cd中
                    this.img_speak.skin = AtlasUrl("kfGroupBuy", "ui_zy_24")
                    this.lable_time_cd.text =`${time}S` 
                    this.is_can_click_speak_btn = false
                } else{
                    this.CancelTime()
                    this.img_speak.skin = AtlasUrl("kfGroupBuy", "ui_kftg_08")
                    this.lable_time_cd.text = " "
                    this.is_can_click_speak_btn = true
                }
            }
            this.time_id = GlobalTimerQuest.AddPeriodQuest(func, 1, -1)
            func()
        }


        this.CancelTime = () => {
            if(this.time_id){
                GlobalTimerQuest.CancelQuest(this.time_id)
                this.time_id = null
            }
        }

        this.RefGoodsInfo = (vo) => {
            if (!vo) return
            select_grade = vo.grade
            let reward = model.GetActReward(base_type, sub_type, vo.form_type, vo.reward)
            if (reward) {
                let [typeId, lock] = local_GoodsModel.GetMappingTypeId(reward[0][0], reward[0][1])
                let basic = local_GoodsModel.GetGoodsBasicByTypeId(typeId)
                if (basic)
                    this._lb_name.text = `${basic.goods_name}`
                if (!goods_item) {
                    goods_item = new EquipmentItem(this._gp_item)
                    goods_item.Load()
                    goods_item.SetItemSize(85, 85)
                }
                goods_item.ExcuteCallback(() => {
                    goods_item.SetData(typeId, reward[0][2], lock)
                })
            }
            let grade_cond = model.GetActCondition(base_type, sub_type, "data", vo.grade)
            if (!grade_cond) return
            let cost = grade_cond[`cost`]
            let discount = grade_cond[`discount`]
            if (!cost || !discount) return
            this._old_price.text = `原价: ${cost[1]}`
            let goods = vo.goods
            this.gp_goods = vo.goods
            if (!goods) return
            buy_num = goods.buy_num
            let cur_price = Number(cost[2])
            let next_num = 0
            if (buy_num >= 0) {
                for (let v of discount) {
                    if (buy_num >= Number(v[0])) {
                        cur_price = Number(v[1])
                    } else {
                        next_num = v[0]
                        break
                    }
                }
            }
            let _all = [{ "0": 0, "1": cost[2] }]
            _all = _all.concat(discount)
            for (let v of _all) {
                v[2] = buy_num
                v[3] = cur_price
                v[4] = cost[1]
            }
            this.UpdateDiscountItems(_all)
            this._new_price.text = `当前团购价: ${cur_price}`
            this._lb_btn_desc.text = is_buy ? `支付订金` : `支付尾款`
            cur_money = is_buy ? cost[3] : cur_price - Number(cost[3])
            this._lb_deposit.text = `${cur_money}`
            pro_num = is_buy ? goods.first_buy_count : goods.tail_buy_count
            limit_num = is_buy ? grade_cond["buy_count"] : goods.first_buy_count
            let str = is_buy ? `限购: ${pro_num}/${limit_num}` : `需支付: ${pro_num}/${limit_num}`
            this._lb_limit.text = str
            // this._cur_num.text = local_Util.StrToHTML(`<font color = '#0a953e'>${buy_num}件</font>`)
            this._cur_num.text = local_Util.StrToHTML(`${buy_num}件`)
            // let str0 = next_num != 0 ? `<font color = '#ef4848'>${next_num - buy_num}件</font>` : `已达最大折扣`
            this._next_num_tips.visible = next_num != 0 ? true : false
            let str0 = next_num != 0 ? `${next_num - buy_num}件` : `已达最大折扣`
            this._next_num.text = local_Util.StrToHTML(str0)
            this._red.visible = !is_buy && limit_num - pro_num > 0
            RefBoxChildsLayout(this.box_price, 0, null, true, "center")
            RefBoxChildsLayout(this.hBox_cur_num, 0, null, true, "left")
            RefBoxChildsLayout(this.hBox_next_num, 0, null, true, "left")
        }

        this.RefShops = () => {
            if (!data) return
            let list = data.reward_list
            let goods_list = data.gp_goods
            if (list && goods_list) {
                let sortFunc = (a, b) => {
                    return a.grade - b.grade
                }
                list.sort(sortFunc)
                for (let v of list) {
                    for (let i in goods_list) {
                        let vo = goods_list[i]
                        if (v.grade == vo.grade_id) {
                            v.goods = vo
                            v.is_buy = is_buy
                            if (select_index == null && !is_buy && v.first_buy_count) {
                                select_index = Number(i)
                            }
                        }
                    }
                    v.base_type = base_type
                    v.sub_type = sub_type
                }

                let func = (list)=>{
                    if (!is_buy) {  //支付尾款阶段
                        let new_list = []
                        //筛选掉没有预定的商品
                        for (let key in list) {
                            let vo = list[key]
                            if(vo.goods.first_buy_count != 0){
                                table.insert(new_list, vo)
                            }
                        }
                        let buy_list = []
                        let not_buy_list = []
                        //已支付的放在后面，未支付的放在前面
                        for (let key in new_list) {
                            let data = new_list[key]
                            if((data.goods.first_buy_count - data.goods.tail_buy_count) <= 0){ 
                                table.insert(buy_list, data)
                            }else{ 
                                table.insert(not_buy_list, data)
                            }
                        }
        
                        table.sort(buy_list, (a?, b?)=>{
                            return a.grade < b.grade
                        })
        
                        table.sort(not_buy_list, (a?, b?)=>{
                            return a.grade < b.grade
                        })
                        not_buy_list = not_buy_list.concat(buy_list)
                        this.UpdateRewardItems(not_buy_list)
                        // this.reward_loop_mgr.replaceAll(not_buy_list)
                    } else{
                        this.UpdateRewardItems(list)
                        // this.reward_loop_mgr.replaceAll(list)
                    }
                }
                func(list)
                // this.reward_loop_mgr.replaceAll(list)
                // _shops_source.replaceAll(list)
            }

            
        }

        
        this.RefTime = () => {
            if (!info || !data) return
            let info_cond = model.GetActCondition(base_type, sub_type, "info")
            if (!info_cond) return
            let stime = info.stime
            let etime = info.etime
            let buy_time = Number(info_cond.buy_day) * 24 * 3600
            let buy_end_time = stime + buy_time
            let cur_time = TimeUtil.getServerTime()
            if(time_item){
                time_item.DeleteMe()
                time_item = null
            }
            if (cur_time > stime && cur_time <= buy_end_time) {
                is_buy = true
                if(buy_end_time <= 0){
                    this._gp_time.visible = false
                }else{
                    this._gp_time.visible = true
                }
                time_item = model.LoadActTimer(this._gp_time, buy_end_time, 32, "#b2ff47", "hh:MM:ss", "#ffffff", `参团倒计时:&nbsp;`, true, null, null, null ,`预订阶段结束`)
                SetLocalPosition(this._gp_time, 200, 714)
            }
            else if (cur_time > buy_end_time) {
                if(etime <= 0){
                    this._gp_time.visible = false
                }else{
                    this._gp_time.visible = true
                }
                is_buy = false
                time_item = model.LoadActTimer(this._gp_time, etime, 32, "#b2ff47", "hh:MM:ss", "#ffffff", `支付尾款倒计时:&nbsp;`, true, null, null, null ,`支付阶段结束`)
                SetLocalPosition(this._gp_time, 200, 714)
            }
        }

        this.CustomMehod = (index, arg) => {
            info = arg
            this.select_index = info.select_index ?  info.select_index : null
        }

        this.DeleteMe = () => {
            // if (this._li_shops)
            //     this._li_shops.removeEventListener(Laya.ItemTapEvent.ITEM_TAP, OnClick, this)
            this.CancelTime()
            if (this.reward_loop_mgr) {
                this.reward_loop_mgr.DeleteMe()
                this.reward_loop_mgr = null
            }

            if (this.discount_loop_mgr) {
                this.discount_loop_mgr.DeleteMe()
                this.discount_loop_mgr = null
            }

            if (goods_item)
                goods_item.DeleteMe()

            if (time_item)
                time_item.DeleteMe()

            if (discount_items.length > 0) {
                for (let item of discount_items) {
                    item.DeleteMe()
                }
                discount_items.length = 0
            }
            super.DeleteMe()
        }
    }

    _img0: Laya.Image
    _img1: Laya.Image
    _Image1: Laya.Image
    _lb_name: Laya.Label
    _gp_item: Laya.Box
    _Group1: Laya.HBox
    _old_price: Laya.Label
    _img_jin: Laya.Image
    _Image2: Laya.Image
    _Group2: Laya.HBox
    _new_price: Laya.Label
    _img_jin1: Laya.Image
    _gp_btn: Laya.Image
    _lb_btn_desc: Laya.Label
    _Group3: Laya.HBox
    _lb_deposit: Laya.Label
    _img_jin2: Laya.Image
    _Label1: Laya.Label
    _red: Laya.Image
    _lb_limit: Laya.Label
    _gp_time: Laya.Box
    _scr_discount: Laya.Panel
    _gp_discount: Laya.List
    img_role: Laya.Image
    _Image5: Laya.Image
    hBox_cur_num: Laya.Box
    _cur_num_tips: Laya.Label
    _cur_num: Laya.Label
    hBox_next_num: Laya.Box
    _next_num_tips: Laya.Label
    _next_num: Laya.Label
    img_speak: Laya.Image
    _record: Laya.Image
    _Image4: Laya.Image
    _Label2: Laya.Label
    _Image6: Laya.Image
    _Image8: Laya.Image
    _lable_title: Laya.Label
    _scr_shops: Laya.Panel
    _list_reward: Laya.List
    _Image10: Laya.Image
    _Image11: Laya.Image
    box_price: Laya.Box
    lable_time_cd: Laya.Label

    public GetComponents() {
    [
        this._img0,
        this._img1,
        this._Image1,
        this._lb_name,
        this._gp_item,
        this._Group1,
        this._old_price,
        this._img_jin,
        this._Image2,
        this._Group2,
        this._new_price,
        this._img_jin1,
        this._gp_btn,
        this._lb_btn_desc,
        this._Group3,
        this._lb_deposit,
        this._img_jin2,
        this._Label1,
        this._red,
        this._lb_limit,
        this._gp_time,
        this._scr_discount,
        this._gp_discount,
        this.img_role,
        this._Image5,
        this.hBox_cur_num,
        this._cur_num_tips,
        this._cur_num,
        this.hBox_next_num,
        this._next_num_tips,
        this._next_num,
        this.img_speak,
        this._record,
        this._Image4,
        this._Label2,
        this._Image6,
        this._Image8,
        this._lable_title,
        this._scr_shops,
        this._list_reward,
        this._Image10,
        this._Image11,
        this.box_price,
        this.lable_time_cd
    ]
    = this.GetChildrenByNames([
        "_img0",
        "_img1",
        "_Image1",
        "_lb_name",
        "_gp_item",
        "_Group1",
        "_old_price",
        "_img_jin",
        "_Image2",
        "_Group2",
        "_new_price",
        "_img_jin1",
        "_gp_btn",
        "_lb_btn_desc",
        "_Group3",
        "_lb_deposit",
        "_img_jin2",
        "_Label1",
        "_red",
        "_lb_limit",
        "_gp_time",
        "_scr_discount",
        "_gp_discount",
        "img_role",
        "_Image5",
        "hBox_cur_num",
        "_cur_num_tips",
        "_cur_num",
        "hBox_next_num",
        "_next_num_tips",
        "_next_num",
        "img_speak",
        "_record",
        "_Image4",
        "_Label2",
        "_Image6",
        "_Image8",
        "_lable_title",
        "_scr_shops",
        "_list_reward",
        "_Image10",
        "_Image11",
        "box_price",
        "lable_time_cd"
        ])
    }
}
window["KfGroupBuyView"] = KfGroupBuyView