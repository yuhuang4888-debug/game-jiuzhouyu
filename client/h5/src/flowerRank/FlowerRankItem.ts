///@描述:FlowerRankItem
///@作者:fengning
///@Laya版本:2.12.2
///@日期:2022-09-27 15:07

// import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { FlowerRankEvent, FlowerrankModel } from "../commonModel/FlowerRankModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { SetLocalPositionX, Util } from "../util/Util"

export class FlowerRankItem extends BaseItemRenderer {

    img_bg: Laya.Image
    img_rank_icon: Laya.Image
    lable_name: Laya.Label
    lable_flower_num: Laya.Label
    lable_rank: Laya.Label
    lable_tips: Laya.Label
    img_flower_icon: Laya.Image
    image_send_flower_btn: Laya.Image
    box_send_flower: Laya.Box
    lable_server_name: Laya.Label
    box_server_name: Laya.Box

    /*----这里定义变量-----*/
    local_ResManager
    game_res
    InitView
    local_RoleManager
    model
    local_FlowerRankEvent
    figure
    local_Util
    local_EventName
    local_GlobalEventSystem
    /*---------------------*/
    public constructor() {
        super()
        this.WIDTH = 673
	    this.HEIGT = 73

        this.base_file = "flowerRank"
        this.layout_file = "FlowerRankItem"
        this.local_ResManager = ResManager.GetInstance()
        this.game_res = GameResPath
        this.local_Util = Util
        this.local_EventName = EventName
        this.local_GlobalEventSystem = GlobalEventSystem
        this.local_RoleManager = RoleManager.GetInstance()
        this.model = FlowerrankModel.GetInstance()
        this.local_FlowerRankEvent = FlowerRankEvent
        this.figure = null
        this.Load()
    }

    public load_callback(){
        this.local_ResManager.SetOutsideImageSprite(this, this.img_bg,
            this.game_res.GetIconOtherPath("flowerRank", "ui_flower_rank_item_bg") , false)
        this.local_ResManager.SetOutsideImageSprite(this, this.image_send_flower_btn,
            this.game_res.GetIconOtherPath("flowerRank", "ui_send_flower_bg") , false)
        this.InitEvents()
    }

    public InitEvents() {
        this.BindEvent(this.model, this.local_FlowerRankEvent.UPDATE_ROLE_FIGURE, (vo?) =>{
            if(vo && this.data){
                let data = vo
                if(data[this.data.role_id]){
                    this.figure = data[this.data.role_id]
                }
            }
        })

        this.local_Util.AddClickEvent(this.image_send_flower_btn,()=>{
            let self_role_id = this.local_RoleManager.GetMainRoleId()
            if(self_role_id == this.data.role_id){
                Message.show("不可以给自己送花，快去拉票吧！")
                return
            }
            if(this.figure){
                this.figure.name =  this.data.name
                this.figure.role_id =  this.data.role_id
                this.local_GlobalEventSystem.Fire(this.local_EventName.OPEN_VIEW, "MarriageFlowerView", this.figure)
            }
        }, this, true)
    }


    private RequestProto() {
        let base_type = this.data.rank_type
        this.model.Fire(this.local_FlowerRankEvent.REQUEST_PROTO, 13015, this.data.server_id, this.data.role_id, base_type)
    }

    
    public dataChanged() {
        if(super.dataChanged()){
            let data = this.data
            let color = null
            if(data.server_num){
                this.lable_server_name.visible = true
                color = "#0a953e"
                this.lable_server_name.text = `S${data.server_num}.`
                this.lable_name.text = `${data.name}`
                this.lable_flower_num.text = data.first_value
                this.lable_server_name.color = color
                SetLocalPositionX(this.box_server_name, 200)
                this.RequestProto()
            }
            else{
                this.lable_server_name.visible = false
                color = "#663915"
                this.lable_name.text = data.name
                this.lable_flower_num.text = data.first_value
                SetLocalPositionX(this.box_server_name, 175)
            }
            this.lable_name.color = color
            this.lable_flower_num.color = color
            if(data.rank <= 3)
            {
                this.img_rank_icon.visible = true
                this.lable_rank.visible = false
                let rank_icon = `ui_rank_icon_${data.rank}`
                this.local_ResManager.SetOutsideImageSprite(this, this.img_rank_icon,
                    GameResPath.GetIconOtherPath("flowerRank", rank_icon) , false)
            } 
            else 
            {
                this.img_rank_icon.visible = false
                this.lable_rank.visible = true
                this.lable_rank.text = data.rank
            }
            this.lable_flower_num.text = data.first_value
            this.lable_tips.visible = !data.has_player
            this.img_flower_icon.x = !data.has_player ? 503 : 470
            let is_self = this.local_RoleManager.mainRoleInfo.role_id == data.role_id
            this.box_send_flower.visible = (data.self_sel_zone == data.zone && !is_self) ? true : false
        }
    }
    
    public DeleteMe() {
        super.DeleteMe()
    }

    public GetComponents() {
        [
            this.img_bg,
            this.img_rank_icon,
            this.lable_name,
            this.lable_flower_num,
            this.lable_rank,
            this.lable_tips,
            this.img_flower_icon,
            this.image_send_flower_btn,
            this.box_send_flower,
            this.lable_server_name,
            this.box_server_name
        ]
        = this.GetChildrenByNames([
            "img_bg",
            "img_rank_icon",
            "lable_name",
            "lable_flower_num",
            "lable_rank",
            "lable_tips",
            "img_flower_icon",
            "image_send_flower_btn",
            "box_send_flower",
            "lable_server_name",
            "box_server_name"
        ])
    }
}
window["FlowerRankItem"] = FlowerRankItem