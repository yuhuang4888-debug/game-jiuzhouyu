///@描述:FlowerTopRankItem
///@作者:fengning
///@Laya版本:2.12.2
///@日期:2022-09-27 15:06

import { BaseItem1 } from "../common/BaseItem1"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { DsgtModel } from "../commonModel/DsgtModel"
import { FlowerRankEvent, FlowerrankModel } from "../commonModel/FlowerRankModel"
import { GuildFightEvent, GuildFightModel } from "../commonModel/GuildFightModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { GlobalTimerQuest, SetLocalPositionX, SetLocalPositionY, Util } from "../util/Util"
import { Vector3 } from "../util/Vector3"

export class FlowerTopRankItem extends BaseItem1 {
    /*----这里定义变量-----*/
    LoadSuccess
    InitEvent
    SetData
    data
    index
    CreateDsgt
    act_info
    cur_sex
    CreateRole
    model
    RequestProto
    role_id
    InitRole
    once_timer
    removeOnceTimer
    figure
    only_once
    /*---------------------*/
    public constructor(parent) {
        super(parent)
        this.base_file = "flowerRank"
        this.layout_file = "FlowerTopRankItem"
        this.Load()
        let local_FlowerRankEvent = FlowerRankEvent
        let local_ResManager = ResManager.GetInstance()
        let local_CustomActivityModel = CustomActivityModel.GetInstance()
        this.model = FlowerrankModel.GetInstance()
        let local_RoleManager = RoleManager.GetInstance()
        let local_GlobalEventSystem = GlobalEventSystem
        let local_EventName = EventName
        this.role_id = null
        this.figure = null
        let local_Util = Util
        this.only_once = false

        this.load_callback = ()=>{
            this.LoadSuccess()
            this.InitEvent()
            this.InitRole()
        }

        this.LoadSuccess = ()=> {
            local_ResManager.SetOutsideImageSprite(this, this.img_send_flower_bg,GameResPath.GetIconOtherPath("flowerRank", "ui_flower_bg") , false)
            local_ResManager.SetOutsideImageSprite(this, this.img_send_flower_btn,GameResPath.GetIconOtherPath("flowerRank", "ui_send_flower_bg") , false)
            SetLocalPositionY(this.box_role, 20) 
        }

        this.InitRole = ()=>{
            // this.once_timer = GlobalTimerQuest.AddDelayQuest(() => {
            //     let vo = this.model.GetTopRoleFigure()
            //     if(this.data.role_id){
            //         this.figure = vo[this.data.role_id]
            //         if(this.figure){
            //             this.CreateRole(this.figure)
            //         }
            //     }
            // },0.1)
        }

        this.InitEvent = ()=> {
            local_Util.AddClickEvent(this.img_send_flower_btn,()=>{
                let self_role_id = local_RoleManager.GetMainRoleId()
                if(self_role_id == this.data.role_id){
                    Message.show("不可以给自己送花，快去拉票吧！")
                    return
                }
                if(this.figure){
                    this.figure.name =  this.data.name
                    this.figure.role_id =  this.data.role_id
                    local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "MarriageFlowerView", this.figure)
                }
            }, this, true)
            // let creat_role_figure = (scmd)=>{
                
            // }
            // this.BindEvent(this.model, local_FlowerRankEvent.CREAT_TOP_ROLE_FIGURE, creat_role_figure)

            this.BindEvent(this.model, local_FlowerRankEvent.UPDATE_ROLE_FIGURE, (vo?) =>{
                if(vo){
                    if(vo[this.data.role_id]){
                        this.figure = vo[this.data.role_id]
                        this.CreateRole(this.figure)
                    }
                }
            })

            // this.BindEvent(GuildFightModel.GetInstance(), GuildFightEvent.UPDATE_REQUEST_FIGURE_2, (scmd?) => {
            //     if (!this.data || this.data.role_id != scmd.role_id || scmd.model_id != 224) {
            //         return
            //     }

            //     this.CreateRole(scmd.figure)
            // })
        }

        this.RequestProto = ()=> {
            // let base_type = this.act_info.base_type
            this.model.Fire(local_FlowerRankEvent.REQUEST_PROTO, 13015, this.data.server_id, this.data.role_id, 224)
        }

        this.SetData = (data? ,index?, act_info?, cur_sex?)=> {
            this.data = data
            this.index = index
            this.act_info = act_info
            this.cur_sex = cur_sex

            if(data.has_player && data.role_id){
                this.box_role.visible = true
                this.box_middle_tips.visible = false
                this.lable_name.visible = true
                this.box_send_flower.visible = true
                this.lable_flower_num.text = data.first_value
                if(this.data.rank <= 3){
                    this.RequestProto()
                }
            }else {
                this.box_middle_tips.visible = true
                this.box_role.visible = false
                this.lable_name.visible = false
                this.lable_middle_flower_num.text = data.first_value
                this.box_send_flower.visible = false
            }

            let image_name = `ui_foot_effect_rank_${data.rank}`
            local_ResManager.SetOutsideImageSprite(this, this.img_foot_effect, GameResPath.GetIconOtherPath("flowerRank", image_name) , false)
            this.CreateDsgt()
            let is_self = local_RoleManager.mainRoleInfo.role_id == data.role_id
            this.img_send_flower_btn.visible = (data.self_sel_zone == data.zone && !is_self) ? true : false
            SetLocalPositionX(this.box_send_flower, (data.self_sel_zone == data.zone && !is_self) ? 39 : 60)
        }

        this.CreateDsgt = ()=> {
            if(!this.act_info){
                return
            }
            let base_type = this.act_info.base_type
            let sub_type = this.act_info.sub_type
            let act_data = local_CustomActivityModel.GetActData(base_type, sub_type)
            let act_cond = local_CustomActivityModel.GetActCondition(base_type, sub_type, "data") 
            if (!act_data || !act_cond){
                return
            }
            let rank = this.index + 1
            let dsgt_id = null
            for (let key in act_data.reward_list) {
                let vo = act_data.reward_list[key]
                let range = act_cond[vo.grade] && act_cond[vo.grade].rank
                if(rank >= Number(range[0]) && rank <= Number(range[1])){
                    let reward = local_CustomActivityModel.GetActReward(base_type,sub_type,vo.form_type,vo.reward, this.cur_sex)
                    let goods_id = reward[0] && reward[0][1]
                    let cfg = DsgtModel.GetInstance().GetDsgtCfgByActiveGoods(goods_id)
                    if(cfg) {
                        dsgt_id = cfg.id
                        this.img_top_honor.visible = cfg.type != 1
                        if(cfg.type == 1){
                            this.box_top_effect.visible = true
                            this.AddUIEffect(cfg.resource_id, this.box_top_effect, {x : 0, y : 1}, {x : 8, y : 8}, true)
                        }else{
                            this.box_top_effect.visible = false
                            ResManager.GetInstance().SetOutsideImageSprite(this, this.img_top_honor, GameResPath.GetDesignImage(dsgt_id),true)
                        }
                    }
                    break
                }
            }
        }

        this.CreateRole = (vo)=> {
            if(this.only_once){
                return
            }
            let figure = vo.figure
            if(!figure){
                return
            }
            if (this.role_id && this.role_id == figure.player_id){
                return
            }
            this.role_id = figure.player_id
            let server_num = this.data.server_num
            this.lable_name.text = `S${server_num}.${figure.name}`

            let [head_id, head_texture_id] = local_Util.GetRoleHeadId(figure)
            let [role_res, role_color] = local_Util.GetRoleClotheId(figure)
            // let weapon_res = Util.GetWeaponClotheId(figure)
            // let wing_res = Util.GetWingClotheId(figure)


            let data = {
                type: UI_MODEL_TYPE.ROLE,
                career: figure.career,
                sex: figure.sex,
                clothe_res_id: role_res,
                fashion_model_id : role_res,
                texture_id : role_color,
                head_wear_id : head_id,
                head_clothe_id : head_texture_id,
                // weapon_res_id : weapon_res,
                // weapon_clothe_id : 0,
                scale: 1,
                // wing_id: wing_res,
                position: new Vector3(0, 0, 0),
            }
            ResManager.GetInstance().SetRoleModel(this, this.box_role, data)
            this.only_once = true
        }

        this.removeOnceTimer = () => {
			if (this.once_timer) {
				GlobalTimerQuest.CancelQuest(this.once_timer)
				this.once_timer = null
			}
		}
    }
    
    public DeleteMe() {
        this.removeOnceTimer()
        super.DeleteMe()
    }

    img_top_honor: Laya.Image
    img_foot_effect: Laya.Image
    img_send_flower_bg: Laya.Image
    img_send_flower_btn: Laya.Image
    lable_name: Laya.Label
    lable_flower_num: Laya.Label
    box_middle_tips: Laya.Box
    lable_middle_flower_num: Laya.Label
    box_send_flower: Laya.Box
    box_top_effect: Laya.Box
    box_role: Laya.Box
    
    
    public GetComponents() {
        [
            this.img_top_honor,
            this.img_foot_effect,
            this.img_send_flower_bg,
            this.img_send_flower_btn,
            this.lable_name,
            this.lable_flower_num,
            this.box_middle_tips,
            this.lable_middle_flower_num,
            this.box_send_flower,
            this.box_top_effect,
            this.box_role
        ]
        = this.GetChildrenByNames([
            "img_top_honor",
            "img_foot_effect",
            "img_send_flower_bg",
            "img_send_flower_btn",
            "lable_name",
            "lable_flower_num",
            "box_middle_tips",
            "lable_middle_flower_num",
            "box_send_flower",
            "box_top_effect",
            "box_role"
        ])
    }
}
window["FlowerTopRankItem"] = FlowerTopRankItem