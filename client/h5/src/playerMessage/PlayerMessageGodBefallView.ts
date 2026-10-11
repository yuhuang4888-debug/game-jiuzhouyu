import { BaseItem1 } from "../common/BaseItem1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { FriendEvent, FriendModel } from "../commonModel/FriendModel"
import { GodBefallModel } from "../commonModel/GodBefallModel"
import { Message } from "../sysInfo/SysInfoController"
import { GameResPath } from "../util/GameResPath"
import { SetLocalPosition, SetSizeDelta, Util } from "../util/Util"
import { Vector3 } from "../util/Vector3"
import { PlayerMessageGodBefallEquipItem } from "./PlayerMessageGodBefallEquipItem"
import { PlayerMessageGodbefallSkillItem } from "./PlayerMessageGodbefallSkillItem"

export class PlayerMessageGodBefallView extends BaseItem1 {
    none: Laya.Box
    none_1: Laya.Image
    none_2: Laya.Image
    show_info: Laya.Box
    bg: Laya.Image
    modelGp: Laya.Box
    _gp_skill: Laya.Box
    _lb_skill1: Laya.Label
    _lb_skill2: Laya.Label
    scr1: Laya.List
    scr2: Laya.List
    equipGp: Laya.Box
    lb_fight: Laya.Label
    name: Laya.Label
    lv: Laya.Label
    left: Laya.Image
    right: Laya.Image
    is_fight: Laya.Image
    image_bg: Laya.Image

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
    ac_skill_loop_list
    ac_skill_loop_mgr
    ac_talent_loop_list
    ac_talent_loop_mgr
    equip_items
    UpdateUIModel
    info
    index
    public constructor(parent?) {
        super(parent)
        this.base_file = "playerMessage"
        this.layout_file = "PlayerMessageGodBefallView"
        this.layer_value = Enum_UILayer.Activity
        let local_resMgr = ResManager.GetInstance()
        let _model = FriendModel.GetInstance()
        let equip_pos = [[60, 0], [470, 0], [60, 200], [470, 200]]
        this.equip_items = []
        this.index = 0
        this.preload_client_config = {

        }

        this.load_callback = () => {
            this.InitEvent()
            this.InitView()
            _model.Fire(FriendEvent.REQUEST_PLAYERMESSAGE_EVENT, this.role_data.server_id, this.role_data.role_id, 7)
        }

        this.SetData = (data) => {
            this.role_data = data
        }
        this.InitEvent = () => {
            this.BindEvent(FriendModel.GetInstance(), FriendEvent.UPDATE_PLAYERMESSAGE_GODBEFALL, (scmd?) => {
                this.info = scmd
                if (this.info.god_battle_info.length == 1) {
                    this.left.visible = false
                    this.right.visible = false
                } else {
                    table.sort(this.info.god_battle_info, (a?, b?) => {
                        return a.battle_pos > b.battle_pos
                    })
                }
                this.UpdateView(scmd)
            })

            Util.AddClickEvent(this.left, () => {
                if(!this.info){
                    return
                }
                 
                if (this.index - 1 < 0) {
                    Message.show("无更多展示")
                    this.index = this.index
                } else {
                    this.index = this.index - 1

                    this.UpdateView()
                }
            }, this, true)

            Util.AddClickEvent(this.right, () => {
                if(!this.info){
                    return
                } 
                if (this.index + 1 >= this.info.god_battle_info.length) {
                    Message.show("无更多展示")
                    this.index = this.index
                } else {
                    this.index = this.index + 1
                    this.UpdateView()
                }
            }, this, true)
        }

        this.InitView = () => {
            local_resMgr.SetTexture(this, this.bg, GameResPath.GetIcon("playerMessage", "ui_rwxx_jsbg"))
            local_resMgr.SetTexture(this, this.none_1, GameResPath.GetIcon("playerMessage", "none_1"), null, null, true)
            local_resMgr.SetOutsideImageSprite(this, this.image_bg, GameResPath.GetIcon("playerMessage", "ui_none_bg"),true)
            SetSizeDelta(this.image_bg, 602, 820)
            SetLocalPosition(this.image_bg, -85, -195)
            this.ac_skill_loop_list = []
            this.scr1.repeatX=55
            this.ac_skill_loop_mgr = new LoopScrowViewMgr()
            this.ac_skill_loop_mgr.SetData(this.scr1, PlayerMessageGodbefallSkillItem, this.ac_skill_loop_list, LoopScrCon.Horizontal)

            this.ac_talent_loop_list = []
            this.scr2.repeatX = 10
            this.ac_talent_loop_mgr = new LoopScrowViewMgr()
            this.ac_talent_loop_mgr.SetData(this.scr2, PlayerMessageGodbefallSkillItem, this.ac_talent_loop_list, LoopScrCon.Horizontal)

        }

        this.UpdateView = () => {
            if (this.info.god_battle_info.length > 0 && this.info.god_battle_info[this.index].god_id != 0) {
                if (this.equip_items) {
                    for (let key in this.equip_items) {
                        this.equip_items[key].DeleteMe()
                    }
                    this.equip_items = []
                }
                this.show_info.visible = true
                this.none.visible = false
                this.left.visible = true
                this.right.visible = true
                let data = this.info.god_battle_info[this.index]
                this.is_fight.visible = data.battle_pos !=0 ? true :false
                let god_info = GodBefallModel.GetInstance().GetGodData(data.god_id)
                this.name.text = god_info.name+ " " + data.star + "星"
                this.lb_fight.text = this.info.god_sum_power
                this.lv.text = data.grade + "阶"
                let skills = GodBefallModel.GetInstance().GetSkillList(data.god_id, data.grade)
                let talents = GodBefallModel.GetInstance().GetTalentList(data.god_id)
                for (let key in skills) {
                    skills[key]["no_lock"] = true
                }
                for (let key in talents) {
                    talents[key]["grade"] = data.grade
                    talents[key]["no_lock"] = true
                }

                if (skills) {
                    this.ac_skill_loop_mgr.replaceAll(skills)
                }
                if (talents) {
                    this.ac_talent_loop_mgr.replaceAll(talents)
                }
                let equips = GodBefallModel.GetInstance().GetEquipList(data)
                for(let key in equips){
                    let item = new PlayerMessageGodBefallEquipItem(this.equipGp)
                    item.SetData(equips[key])
                    item.Load()
                    this.equip_items.push(item)
                    item.ExcuteCallback(() =>{
                        item.display_obj.pos(equip_pos[key][0],equip_pos[key][1])
                    })
                }
                this.UpdateUIModel(god_info)
            } else {
                this.show_info.visible = false
                this.none.visible = true
                this.left.visible = false
                this.right.visible = false
            }
        }

        this.UpdateUIModel = (data?) => {
            let weapon_model_id = data.model
            let mode_data = {
                clothe_res_id: data.model,
                weapon_res_id: weapon_model_id,
                type: UI_MODEL_TYPE.GOD,
                layer_value: this.layer_value,

                scale: 1 * data.model_ratio,
                position: new Vector3(0, -1.5, 0),
            }
            ResManager.GetInstance().SetRoleModel(this, this.modelGp, mode_data)
        }


        this.DesFunc = () => {
            if (this.ac_skill_loop_mgr) {
                this.ac_skill_loop_mgr.DeleteMe()
                this.ac_skill_loop_mgr = null
            }
            if (this.ac_talent_loop_mgr) {
                this.ac_talent_loop_mgr.DeleteMe()
                this.ac_talent_loop_mgr = null
            }
            if (this.equip_items) {
                for (let key in this.equip_items) {
                    this.equip_items[key].DeleteMe()
                }
                this.equip_items = []
            }
        }
    }

    public DeleteMe() {
        this.DesFunc()
        super.DeleteMe()
    }


    public GetComponents() {
        [
            this.none,
            this.none_1,
            this.none_2,
            this.show_info,
            this.bg,
            this.modelGp,
            this._gp_skill,
            this._lb_skill1,
            this._lb_skill2,
            this.scr1,
            this.scr2,
            this.equipGp,
            this.lb_fight,
            this.name,
            this.lv,
            this.left,
            this.right,
            this.is_fight,
            this.image_bg
        ]
            = this.GetChildrenByNames([

                "none",
                "none_1",
                "none_2",
                "show_info",
                "bg",
                "modelGp",
                "_gp_skill",
                "_lb_skill1",
                "_lb_skill2",
                "scr1",
                "scr2",
                "equipGp",
                "lb_fight",
                "name",
                "lv",
                "left",
                "right",
                "is_fight",
                "image_bg"
            ])
            // this.scr1.scrollBar.visible = false
            // this.scr2.scrollBar.visible = false
        }
    }
    window["PlayerMessageGodBefallView"] = PlayerMessageGodBefallView