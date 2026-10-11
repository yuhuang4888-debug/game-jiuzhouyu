///@描述:FlowerRankView
///@作者:fengning
///@Laya版本:2.12.2
///@日期:2022-09-27 15:06

import { BaseItem1 } from "../common/BaseItem1"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { Color, GlobalTimerQuest, SetHtmlStyle, SetLocalPosition, SetLocalPositionX, Util } from "../util/Util"
import { FlowerRankItem } from "./FlowerRankItem"
import { FlowerTopRankItem } from "./FlowerTopRankItem"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"
import { ErlangParser } from "../util/ErlangParser"
import { table } from "../common/table"
import { RoleManager } from "../commonModel/RoleManager"
import { TimeUtil } from "../util/TimeUtil"
import { FlowerRankEvent, FlowerrankModel } from "../commonModel/FlowerRankModel"

export class FlowerRankView extends BaseItem1 {
    /*----这里定义变量-----*/
    SetData
    LoadSuccess
    InitEvent
    role_item_list
    loop_mgr
    default_select_index
    CustomMehod
    act_info
    index
    RequestProto
    model
    local_FlowerRankEvent
    local_Number
    local_FlowerRankItem
    onTimer
    cache_scmd
    timer
    end_time
    onTime
    removeTimer
    // once_timer
    // removeOnceTimer
    /*---------------------*/
    public constructor(parent) {
        super(parent)
        this.base_file = "flowerRank"
        this.layout_file = "FlowerRankView"
        let local_ResManager = ResManager.GetInstance()
        this.default_select_index = 1
        this.role_item_list = []
        let local_Util = Util
        let local_eventName = EventName
        this.local_FlowerRankItem = FlowerRankItem
        this.local_Number = Number
        let local_GlobalEventSystem = GlobalEventSystem
        this.model = FlowerrankModel.GetInstance()
        this.local_FlowerRankEvent = FlowerRankEvent
		this.timer = null
        this.end_time = 0
        this.Load()
        let FLOWER_TYPE = [371,372]
        let PROTO_ID = [22401,22403]
        this.load_callback = ()=>{
            this.InitEvent()
            this.LoadSuccess()
            this.SetData()
            
        }

        this.LoadSuccess = ()=> {
            local_ResManager.SetOutsideImageSprite(this, this.img_top_rank_bg,GameResPath.GetIconOtherPath("flowerRank", "ui_top_rank") , false)
            local_ResManager.SetOutsideImageSprite(this, this.img_btn_recive_flower,GameResPath.GetIconOtherPath("flowerRank", "com_rect_btn1") , false)
            local_ResManager.SetOutsideImageSprite(this, this.item_bg,GameResPath.GetIconOtherPath("flowerRank", "ui_item_bg") , false)
            local_ResManager.SetOutsideImageSprite(this, this.img_reward_btn,GameResPath.GetIconOtherPath("flowerRank", "ui_btn_reward") , false)
            this.RequestProto()
        }

        this.RequestProto = ()=> {
            let info = this.act_info
            let proto_id = PROTO_ID[info.base_type - 1] //base_type 跨服为2，本服为1，为了索引减一
            let rank_type_id = FLOWER_TYPE[this.index]
            this.model.Fire(this.local_FlowerRankEvent.REQUEST_PROTO, proto_id, rank_type_id, info.sub_type)
        }

        this.InitEvent = ()=> {
            local_Util.AddClickEvent(this.img_btn_recive_flower, () => {
                local_GlobalEventSystem.Fire(local_eventName.OPEN_VIEW, "MarriageRecordFlowerView")
            }, this, true)

            local_Util.AddClickEvent(this.img_reward_btn, () => {
                if(!this.cache_scmd) return
                let rank_type_id = FLOWER_TYPE[this.index]
                local_GlobalEventSystem.Fire(local_eventName.OPEN_VIEW, "FlowerRankRewardView", this.act_info, this.cache_scmd, this.index + 1, rank_type_id)
            }, this, true)

            let updata_item_list = (vo)=>{
                let rank_type_id = FLOWER_TYPE[this.index]
                let data = vo[rank_type_id]
                this.cache_scmd = data
                this.CreatTopRoleItem(data)
                this.CreatRankItem(data)
                this.SetOwnRankInfo(data)
            }
            this.BindEvent(this.model, this.local_FlowerRankEvent.UPDATE_RANK_ITEM, updata_item_list)
        }

        this.SetData = ()=> {
            if(this.is_loaded){
                if (!this.timer) {
                    this.timer = GlobalTimerQuest.AddPeriodQuest(() => {
                        this.onTime()
                    }, 1)
                }
                this.onTime()
                let y_offset = 4
                this.html_time_2.innerHTML = "活动于最后一天的<font color='#60e856'>22:00</font>结算奖励"
                this.html_time_1.y = y_offset
                this.html_time_2.y = y_offset
                // this.once_timer = GlobalTimerQuest.AddDelayQuest(() => {
                //     let vo = this.model.GetFlowerRankData()
                //     let rank_type_id = FLOWER_TYPE[this.index]
                //     let data = vo[rank_type_id]
                //     this.cache_scmd = data
                //     this.CreatTopRoleItem(data)
                //     this.CreatRankItem(data)
                //     this.SetOwnRankInfo(data)
                // }, 0.1)
            }
        }

        this.CustomMehod = (index?, info?)=>{
            this.index = index // 1为男，2为女
            this.act_info = info
            this.end_time = this.act_info.etime
        }

        this.removeTimer = () => {
			if (this.timer) {
				GlobalTimerQuest.CancelQuest(this.timer)
				this.timer = null
				this.end_time = 0
			}
		}

        // this.removeOnceTimer = () => {
		// 	if (this.once_timer) {
		// 		GlobalTimerQuest.CancelQuest(this.once_timer)
		// 		this.once_timer = null
		// 	}
		// }


        this.onTime = ()=> {
            if (this.end_time >= TimeUtil.getServerTime()) {
                this.html_time_1.visible = true
                let time = TimeUtil.timeConvert(this.end_time - TimeUtil.getServerTime(), 'hh-mm-ss')
                this.html_time_1.innerHTML = `活动剩余时间：<font color='#60e856'>${time}</font>`
            } else {
                this.html_time_1.innerHTML = "已结束"
                this.removeTimer();
            }
        }
    }


    private SetOwnRankInfo(scmd){
        let role_id = RoleManager.GetInstance().GetMainRoleId()
        let sex = RoleManager.GetInstance().GetMainRoleSex()
        if(sex == (this.index + 1)){
            this.box_bottom.visible = true
            this.lable_bottom_lable_tips.visible = false
        }
        else{
            this.box_bottom.visible = false
            this.lable_bottom_lable_tips.visible = true
            return
        }
        let rank_list = scmd.rank_list
        for (let key in rank_list) {
            let data = rank_list[key]
            if(data.role_id == role_id){
                this.lable_bottom_flower_num.text = data.first_value
                this.lable_bottom_rank.text = data.rank
                if(data.rank == 1){
                    this.lable_disparity_flower_num.text = "0"
                }
                else{
                    let score_list = this.ReprocessData(scmd)
                    for (const key in score_list) {
                        let vo = score_list[key]
                        if(vo.rank == data.rank - 1){
                            let result = vo.first_value - data.first_value
                            this.lable_disparity_flower_num.text = result.toString()
                            return
                        }
                    }
                }
                return
            }
        }

        //遍历整个榜单都找不到自己说明自己不在榜单上面
        if(scmd.sel_rank == 0){
            this.lable_bottom_rank.text = "未上榜"
            this.lable_bottom_flower_num.text = scmd.sel_val.toString()
            let score_list = this.ResolveConfigData(scmd)
            let len = score_list.length
            let last_vo = score_list[len - 1]
            let result = last_vo.first_value - scmd.sel_val
            this.lable_disparity_flower_num.text = result.toString()
            SetLocalPositionX(this.img_flower_rank, 150)
        }
    }

   
    
    private CreatTopRoleItem(scmd)
    {
        let cur_sex = scmd.type == 371 ? 1 : 2
        let pos_list = [{x: 15, y: 80, index: 1},{x: 249, y: 62, index: 0}, {x: 481, y: 80, index: 2}]
        let score_list = this.ReprocessData(scmd)
        for (let i = 1; i < 4; i++) {
            let role_item = this.role_item_list[i]
            if(!role_item){
                role_item = new FlowerTopRankItem(this.box_top_item_group)
                this.role_item_list[i] = role_item
                role_item.SetVisible = true
                role_item.Load()
                role_item.SetPosition(pos_list[i - 1].x, pos_list[i - 1].y)
                role_item.ExcuteCallback(()=>{
                    let key = pos_list[i - 1].index
                    role_item.SetData(score_list[key], key, this.act_info, cur_sex)
                })
            }
            
        }
    }

    private CreatRankItem(scmd)
    {
        let score_list = this.ReprocessData(scmd)

        if (this.loop_mgr) {
            this.loop_mgr.DeleteMe()
            this.loop_mgr = null
        }

        if(!this.loop_mgr){
            this.loop_mgr = new LoopScrowViewMgr()
            this.loop_mgr.SetData(this.list_flower_item_group, FlowerRankItem, score_list, LoopScrCon.Vertical, 1)
        }else{
            this.loop_mgr.replaceAll(score_list)
        }
        
    }

    //将玩家的数据替换初始区间列表中对应排名的数据
    private ReprocessData(scmd){
        let rank_list = scmd.rank_list
        let score_list = this.ResolveConfigData(scmd)
        for (let key in rank_list) {
            let data = rank_list[key]
            for (let idx in score_list) {
                let score_data = score_list[idx]
                if(data.rank == score_data.rank){
                    score_data.name = data.name
                    score_data.first_value = data.first_value
                    score_data.has_player = true
                    score_data.server_num = data.server_num
                    score_data.role_id = data.role_id
                    score_data.server_id = data.server_id
                    score_data.zone = data.zone
                    break
                }
            }
        }
        return score_list
    }


    //处理配置上班区间段以及插入玩家所在排名的数据
    private ResolveConfigData(scmd){
        let condition = this.act_info.condition
        let cond_list = ErlangParser.GetInstance().Parse(condition)
        let list = {}
        let socre_rank_list = []
        for (let idx in cond_list) {
            let data = cond_list[idx]
            let key = data[0]
            list[key] = data[1]
        }
        // let rank_len = this.local_Number(list["rank_len"])
        // let rank_limit = this.local_Number(list["rank_limit"])
        let score_rank = list["score_rank"]
        for (let key in score_rank) {
            let data = score_rank[key]
            let min = this.local_Number(data[0])
            let max = this.local_Number(data[1])
            for(let i = min; i <= max ; i++){
                let vo = {
                    rank: i, 
                    first_value: this.local_Number(data[2]),
                    name: "暂无玩家上榜",
                    has_player: false,
                    server_num: null,
                    role_id: null,
                    server_id: null,
                    rank_type: scmd.type,
                    zone: null,
                    self_sel_zone: scmd.sel_zone
                }
                table.insert(socre_rank_list, vo)
            }
        }
        return socre_rank_list
    }


    public DeleteMe() 
    {
        for (let key in this.role_item_list) {
           let item = this.role_item_list[key]
           if(item){
              item.DeleteMe()
              item = null
           }
        }
        this.role_item_list = []

        if (this.loop_mgr) {
            this.loop_mgr.DeleteMe()
            this.loop_mgr = null
        }
        this.removeTimer()
        // this.removeOnceTimer()
        super.DeleteMe()
    }

    img_top_rank_bg: Laya.Image
    img_btn_recive_flower: Laya.Image
    item_bg: Laya.Image
    img_reward_btn: Laya.Image
    img_flower_rank: Laya.Image
    box_top_item_group: Laya.Box
    box_bottom: Laya.Box
    list_flower_item_group: Laya.List
    html_time_1: Laya.HTMLDivElement
    html_time_2: Laya.HTMLDivElement
    lable_bottom_rank: Laya.Label
    lable_bottom_flower_num: Laya.Label
    lable_disparity_flower_num: Laya.Label
    lable_bottom_lable_tips: Laya.Label
    
    
    public GetComponents() {
        [
            this.img_top_rank_bg,
            this.box_top_item_group,
            this.html_time_1,
            this.html_time_2,
            this.list_flower_item_group,
            this.lable_bottom_rank,
            this.lable_bottom_flower_num,
            this.lable_disparity_flower_num,
            this.img_btn_recive_flower,
            this.item_bg,
            this.img_reward_btn,
            this.lable_bottom_lable_tips,
            this.box_bottom,
            this.img_flower_rank
        ]
        = this.GetChildrenByNames([
            "img_top_rank_bg",
            "box_top_item_group",
            "html_time_1",
            "html_time_2",
            "list_flower_item_group",
            "lable_bottom_rank",
            "lable_bottom_flower_num",
            "lable_disparity_flower_num",
            "img_btn_recive_flower",
            "item_bg",
            "img_reward_btn",
            "lable_bottom_lable_tips",
            "box_bottom",
            "img_flower_rank"
        ])
        this.html_time_1.style.fontSize = 18
		this.html_time_1.style.color="#ffffff"
		this.html_time_1.style.wordWrap = false
        this.html_time_2.style.fontSize = 18
		this.html_time_2.style.color="#ffffff"
		this.html_time_2.style.wordWrap = true
    }
}
window["FlowerRankView"] = FlowerRankView