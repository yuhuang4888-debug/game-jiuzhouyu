///@描述:item
///@作者:fengning
///@Laya版本:2.12.2
///@日期:2022-11-23 15:05

import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { EquipmentItem } from "../common/EquipmentItem"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { HaloModel } from "../commonModel/HaloModel"
import { RoleManager } from "../commonModel/RoleManager"
import { TaskModel } from "../commonModel/TaskModel"
import { TeamEvent, TeamModel } from "../commonModel/TeamModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { RefBoxChildsLayout, Util } from "../util/Util"
import { Vector2 } from "../util/Vector2"

export class HaloItem extends BaseItemRenderer {
    /*----这里定义变量-----*/
    public WIDTH = 289
    public HEIGT = 177
    reward_list
    local_ResManager
    local_EventName
    model
    /*---------------------*/
    public constructor() {
        super()
        this.base_file = "halo"
        this.layout_file = "HaloItem"
        this.Load()
        this.local_ResManager = ResManager.GetInstance()
        this.local_EventName = EventName
        this.model = HaloModel.GetInstance()
        this.reward_list = []
    }

    public load_callback() {
        this.LoadSuccess()
    }

    public LoadSuccess() {
        this.img_getted.visible = false
        this.img_flag.visible = false
        this.img_mask.visible = false
        this.box_desc.visible = false
        this.InitEvent()
    }

    public InitEvent() {
        Util.AddClickEvent(this.img_get,()=>{
            this.model.Fire(HaloModel.REQUEST_SCMD, 51401, "i", this.data.id)
        },this,true)

        // Util.AddClickEvent(this.img_getted,()=>{
        //     Message.show("奖励已领取")
        // },this,true)

        // Util.AddClickEvent(this.img_mask,()=>{
        //     Message.show("未满足领取条件")
        // },this,false)

        Util.AddClickEvent(this.box_desc,(e?)=>{
            let point= new Vector2(e.stageX, e.stageY)
            // GlobalEventSystem.Fire(EventName.OPEN_VIEW, "TeamSmallDescView", point, this.data.supplement_desc)
            TeamModel.GetInstance().Fire(TeamEvent.TEAM_OPEN_VIEW, "TeamSmallDescView", point, this.data.supplement_desc, true)
        },this,true)
    }

    public dataChanged() {
        if (super.dataChanged()) {
            let data = this.data
            this.local_ResManager.SetOutsideImageSprite(this, this.img_bg, GameResPath.GetIconOtherPath("halo", data.picture), false)
            if(this.data.flag){
                this.img_flag.visible = true
            }else {
                this.img_flag.visible = false
            }
            this.UpdateImageGetShowOrHide(data)
            this.UpdateRewatdMaskCondition(data)
            this.UpdateRewardItem(data)
            this.ShowOrHideDescBtn(data)
        }
    }

    /**
     * 控制立即领取和已领取的显示和隐藏
     * @param data 
     */
    public UpdateImageGetShowOrHide(data?) {
        let halo_data = this.model.GetHaloData()
        let reward_state = halo_data.rewards
        if(halo_data){
            //end_time大于0，代表开通的光环特权
            if(halo_data.end_time > 0){
                if(reward_state.length <= 0){
                    this.img_get.visible = true
                    this.img_getted.visible = false
                }else{
                    for (let key in reward_state) {
                        let vo = reward_state[key]
                        if(vo.id == data.id){
                            this.img_get.visible = vo.state == 1 ? false : true
                            this.img_getted.visible = vo.state == 1 ? true : false
                            break
                        }
                    }
                }
            }else{
                this.img_get.visible = false
                this.img_getted.visible = false
            }
        }
    }

    /**
     * 根据配置条件控制遮罩显示
     * @param data 
     */
    public UpdateRewatdMaskCondition(data?) {
        let halo_data = this.model.GetHaloData()
        let role_lv = RoleManager.GetInstance().GetMainRoleLevel()
        let condition = ErlangParser.GetInstance().Parse(data.condition)
        let cond_lv = Number(condition[0][1])
        let cond_str = condition[0][0]
        let bool 
        if(cond_str == "lv"){
            if(role_lv >= cond_lv){
                bool = true 
            }else {
                bool = false 
            }
        }else if(cond_str == "task"){
            let finish = TaskModel.GetInstance().IsAllStepFinish(cond_lv)
            if(finish){
                bool = true 
            }else{
                bool = true 
            }
        }
        if(halo_data.end_time <= 0){
            this.img_mask.visible = true
            if(cond_lv == 1){
                this.lable_mask_desc.text = `购买激活`
            }else{
                this.lable_mask_desc.x = 35
                this.lable_mask_desc.text = `购买并达到${cond_lv}级激活`
                this.img_get.visible = false
                this.img_getted.visible = false
            }
        }else{
            if(bool){
                this.img_mask.visible = false
            }else { 
                this.img_mask.visible = true
                this.lable_mask_desc.x = 90
                this.lable_mask_desc.text = `${cond_lv}级激活`
                this.img_get.visible = false
                this.img_getted.visible = false
            }
        }
    }

    /**
     * 更新奖励
     * @param data 
     */
    public UpdateRewardItem(data?) {
        if(!data){
            return
        }
        let reward_dic = ErlangParser.GetInstance().Parse(data.reward)
        for (let key in reward_dic) {
            let vo = reward_dic[key]
            let idx = Number(key)
            let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(Number(vo[0]) ,Number(vo[1]))
            let item = this.reward_list[idx]
            if(!item){
                item = new EquipmentItem(this.box_parent)
                this.reward_list[idx] = item
                item.Load()
                item.SetItemSize(56, 56)
            }
            item.SetPosition(32 + idx * 65, 0)
            item.SetData(type_id, Number(vo[2]) , lock)
        }
    }

    /**
     * 控制描述按钮是否显示
     * @param data 
     */
    public ShowOrHideDescBtn(data?) {
        if(data.supplement_desc != ""){
            this.box_desc.visible = true
        }else{
            this.box_desc.visible = false
        }
    }

    
    public DeleteMe() {
        if (this.reward_list && this.reward_list.length > 0) {
            for (let k in this.reward_list) {
                var item = this.reward_list[k]
                item.DeleteMe()
            }
            this.reward_list = []
        }
        super.DeleteMe()
    }

    img_bg:Laya.Image
    img_get:Laya.Image
    img_getted:Laya.Image
    img_mask:Laya.Image
    lable_mask_desc:Laya.Label
    img_flag:Laya.Image
    box_parent:Laya.Box
    box_desc:Laya.Box
    public GetComponents() {
    [
        this.img_bg,
        this.img_get,
        this.img_getted,
        this.img_mask,
        this.lable_mask_desc,
        this.img_flag,
        this.box_parent,
        this.box_desc
    ]
    = this.GetChildrenByNames([
            "img_bg",
            "img_get",
            "img_getted",
            "img_mask",
            "lable_mask_desc",
            "img_flag",
            "box_parent",
            "box_desc"
        ])
    }
}
 window["HaloItem"]= HaloItem