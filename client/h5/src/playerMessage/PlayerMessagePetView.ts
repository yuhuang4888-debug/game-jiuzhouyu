import { BaseItem1 } from "../common/BaseItem1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { FriendEvent, FriendModel } from "../commonModel/FriendModel"
import { PlayerMessagePetItem } from "./PlayerMessagePetItem"
import "./PlayerMessageDemonSkillTipsView"
import "./PlayerMessageDemonTalentSelectView"
import { GameResPath } from "../util/GameResPath"
import { TopPkMatchSuccessView } from "../topPk/TopPkMatchSuccessView"
import { CommonManager } from "../common/CommonManager"
export class PlayerMessagePetView extends BaseItem1 {



    DesFunc
    InitView
    attr_box
    InitEvent
    UpdateView
    SetData
    need_refreshData
    select
    data
    role_data
    partner_loop_mgr
    demon_loop_mgr
    
    public constructor(parent?) {
        super(parent)
        this.base_file = "playerMessage"
        this.layout_file = "PlayerMessagePetView"
        this.layer_value = Enum_UILayer.Activity
        let local_resMgr = ResManager.GetInstance()
        let _model = FriendModel.GetInstance()
        let common_mgr = CommonManager.GetInstance()

        this.preload_server_config = {
            "config_demons": false,
            "config_demons_skill": false
        }

        this.preload_client_config = {

        }

        this.load_callback = () => {
            this.InitEvent()
            this.InitView()
            if (this.need_refreshData) {
                _model.Fire(FriendEvent.REQUEST_PLAYERMESSAGE_EVENT, this.role_data.server_id, this.role_data.role_id, 11)
                this.need_refreshData = false
            }
        }

        this.SetData = (data) => {
            this.role_data = data
            if (this.is_loaded) {
                _model.Fire(FriendEvent.REQUEST_PLAYERMESSAGE_EVENT, this.role_data.server_id, this.role_data.role_id, 11)
            } else {
                this.need_refreshData = true
            }
        }
        this.InitEvent = () => {
            this.BindEvent(FriendModel.GetInstance(), FriendEvent.UPDATE_PLAYERMESSAGE_PET, (scmd?) => {
                this.UpdateView(scmd)
            })
        }

        this.InitView = () => {
            local_resMgr.SetTexture(this, this.petBg, GameResPath.GetIcon("playerMessage", "ui_rwxx_ssbg"))
            local_resMgr.SetTexture(this,this.partner_none_1,GameResPath.GetIcon("playerMessage","none_1"))
            local_resMgr.SetTexture(this,this.demon_none_1,GameResPath.GetIcon("playerMessage","none_1"))
            local_resMgr.SetTexture(this,this.partner_title_bg,GameResPath.GetIcon("playerMessage","ui_rwxx_ss01"))
            local_resMgr.SetTexture(this,this.demon_title_bg,GameResPath.GetIcon("playerMessage","ui_rwxx_ss01"))
            local_resMgr.SetTexture(this,this.line_1,GameResPath.GetIcon("playerMessage","ui_rwxx_ss_10"))
            local_resMgr.SetTexture(this,this.line_2,GameResPath.GetIcon("playerMessage","ui_rwxx_ss_10"))
        }

        this.UpdateView = (scmd?) => {
            this.partner_fight.text = scmd.companion_power
            this.demon_fight.text = scmd.demons_power
            if (scmd.companion_list.length > 0) {
                this.partner_none.visible = false
                this.partner.visible = true
                this.line_1.visible = true
                this.partnerItem.visible = true
                this.partner_HBox.visible = true
                for (let key in scmd.companion_list) {
                    scmd.companion_list[key]["type"] = 1
                }
                if (!this.partner_loop_mgr) {
                    this.partner_loop_mgr = new LoopScrowViewMgr()
                    this.partner_loop_mgr.SetData(this.partnerItem, PlayerMessagePetItem, scmd.companion_list, LoopScrCon.Horizontal)
                } else {
                    this.partner_loop_mgr.replaceAll(scmd.companion_list)
                }
            }else{
                this.partner_none.visible = true
                this.line_1.visible = false
                this.partnerItem.visible = false
                this.partner_HBox.visible = false
                // this.partner.visible = false
            }

            if (scmd.demons_list.length > 0) {
                this.demon_none.visible = false
                this.demon.visible = true
                this.line_2.visible = true
                this.demonItem.visible = true
                this.demon_HBox.visible = true
                let skill_cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "config_demons_skill", false)

                let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_demons", false)
                for (let key in scmd.demons_list) {
                    scmd.demons_list[key]["type"] = 2
                    scmd.demons_list[key]["info"] = cfg[scmd.demons_list[key].id]
                    for(let _ in skill_cfgs){
                        if(skill_cfgs[_].demons_id == scmd.demons_list[key].id){
                            scmd.demons_list[key]["skill_info"] = skill_cfgs[_]
                            break
                        }
                    }
                }
                if (!this.demon_loop_mgr) {
                    this.demon_loop_mgr = new LoopScrowViewMgr()
                    this.demon_loop_mgr.SetData(this.demonItem, PlayerMessagePetItem, scmd.demons_list, LoopScrCon.Horizontal)
                } else {
                    this.demon_loop_mgr.replaceAll(scmd.demons_list)
                }
            }else{
                this.demon_none.visible = true
                this.line_2.visible = false
                this.demonItem.visible = false
                this.demon_HBox.visible = false
                // this.demon.visible = false
            }
            let bool = common_mgr.CheckFuncOpenState("DemonMainView", true)
            this.demon.visible = bool
            // this.demon_none.visible = bool
        }

        this.DesFunc = () => {

        }
    }

    public DeleteMe() {
        if (this.partner_loop_mgr) {
            this.partner_loop_mgr.DeleteMe()
            this.partner_loop_mgr = null
        }
        if (this.demon_loop_mgr) {
            this.demon_loop_mgr.DeleteMe()
            this.demon_loop_mgr = null
        }
        this.DesFunc()
        super.DeleteMe()
    }

    petBg: Laya.Image
    partner: Laya.Box
    partner_title_bg: Laya.Image
    partner_fight: Laya.Label
    partnerItem: Laya.List
    demon: Laya.Box
    demon_title_bg: Laya.Image
    demon_fight: Laya.Label
    demonItem: Laya.List
    partner_none: Laya.Box
    demon_none: Laya.Box
    partner_none_1:Laya.Image
    demon_none_1: Laya.Image
    line_1: Laya.Image
    line_2: Laya.Image
    demon_HBox: Laya.HBox
    partner_HBox: Laya.HBox


    public GetComponents() {
        [
            this.petBg,
            this.partner,
            this.partner_title_bg,
            this.partner_fight,
            this.partnerItem,
            this.demon,
            this.demon_title_bg,
            this.demon_fight,
            this.demonItem,
            this.partner_none,
            this.demon_none,
            this.partner_none_1,
            this.demon_none_1,
            this.line_1,
            this.line_2,
            this.demon_HBox,
            this.partner_HBox
        ]
            = this.GetChildrenByNames([

                "petBg",
                "partner",
                "partner_title_bg",
                "partner_fight",
                "partnerItem",
                "demon",
                "demon_title_bg",
                "demon_fight",
                "demonItem",
                "partner_none",
                "demon_none",
                "partner_none_1",
                "demon_none_1",
                "line_1",
                "line_2",
                "demon_HBox",
                "partner_HBox"
            ])
    }
}
window["PlayerMessagePetView"] = PlayerMessagePetView