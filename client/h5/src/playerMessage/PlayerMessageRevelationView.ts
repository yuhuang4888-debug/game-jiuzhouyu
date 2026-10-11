import { BaseItem1 } from "../common/BaseItem1"
import { SetAnchoredPosition, SetLocalPosition, SetSizeDelta, Util } from "../util/Util"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { GoodsModel } from "../commonModel/GoodsModel"
import { CompositeModel } from "../commonModel/CompositeModel"
import { RedDotManager, ModuleType } from "../common/RedDotManager"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { FightingShowSmallItem } from "../common/FightingShowSmallItem"
import { RevelationModel, RevelationEvent } from "../commonModel/RevelationModel"
import { Revelation1EquipItem } from "../revelation/Revelation1EquipItem"
import { FriendEvent, FriendModel } from "../commonModel/FriendModel"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { RoleManager } from "../commonModel/RoleManager"
import { Vector2 } from "../util/Vector2"
import { SkillManager } from "../skill/SkillManager"
export class PlayerMessageRevelationView extends BaseItem1 {
    revelation_model
    model
    red_mgr
    goods_model
    comp_model

    pos_list
    equip_items
    bag_loop_mgr
    SetData
    cover_effect_cache_sort_order
    effect_cache_sort_order
    type_id
    role_data
    need_refreshData
    revelation_data
    posList_
    public constructor(parent?) {
        super(parent)
        this.base_file = "playerMessage"
        this.layout_file = "PlayerMessageRevelationView"
        this.model = FriendModel.GetInstance()
        this.revelation_model = RevelationModel.GetInstance()
        this.red_mgr = RedDotManager.GetInstance()
        this.goods_model = GoodsModel.GetInstance()
        this.comp_model = CompositeModel.GetInstance()
        this.equip_items = []
        this.pos_list = [
            { x: 90, y: 270 },
            { x: 310, y: 46 },
            { x: 310, y: 490 },
            { x: 310, y: 204 },
            { x: 310, y: 333 },
            { x: 200, y: 157 },
            { x: 420, y: 157 },
            { x: 420, y: 380 },
            { x: 200, y: 380 },
            { x: 532, y: 270 }
        ]
        this.posList_ = [
            { 1: 222, 2: -5 }, { 1: 357, 2: 37 }, { 1: 441, 2: 152 }, { 1: 441, 2: 293 }, { 1: 358, 2: 406 },
            { 1: 224, 2: 451 }, { 1: 89, 2: 406 }, { 1: 7, 2: 293 }, { 1: 7, 2: 153 }, { 1: 90, 2: 39 }
        ]

        this.load_callback = () => {
            ResManager.GetInstance().SetOutsideImageSprite(this, this.bg, GameResPath.GetIcon("playerMessage", "ui_rwxx_bg_04"))
			SetSizeDelta(this.bg, 602, 680)
            this.InitEvent()
        }

        this.SetData = (type_id?, role_info?) => {
            this.type_id = type_id
            this.role_data = role_info
        }
    }

    private InitEvent() {
        Util.AddClickEvent(this.propBtn, () => {
            this.revelation_model.Fire(RevelationEvent.OPEN_VIEW, "PlayerMessageRevelationAttrView", this.revelation_data)
        }, this, true)

        this.BindEvent(this.model, FriendEvent.UPDATE_PLAYERMESSAGE_REVELATION, (scmd) => {
            this.revelation_data = scmd
            this.UpdateView()
            this.SetSkillInfo()
            this.CreateModel()
        })

        Util.AddClickEvent(this.skill, () => {
            this.revelation_model.Fire(RevelationEvent.OPEN_VIEW, "PlayerMessageRevelationSkillView", this.revelation_data)
        }, this, true)
    }

    private UpdateView() {
        this.lb_fight.text = this.revelation_data.power
        let is_activity_pos = false
        for (let key in RevelationModel.PosIndex) {
            is_activity_pos = false
            for (let _ in this.revelation_data.gathering) {
                if (RevelationModel.PosIndex[key] == this.revelation_data.gathering[_].pos) {
                    is_activity_pos = true
                }
            }
        }
        for (let _tmpi in RevelationModel.PosIndex) {
            let vo = RevelationModel.PosIndex[_tmpi]
            let item = new Revelation1EquipItem(this.equipGp)
            item.Load()
            item.ExcuteCallback(() => {
                let data = null
                for (let _ in this.revelation_data.gathering) {
                    if (vo == this.revelation_data.gathering[_].pos) {
                        data = this.revelation_data.gathering[_]
                        data["type_id"] = data.item_id
                    }
                }
                if (!data) {
                    data = { type_id: 0, equip_type: vo }
                }
                item.SetData(data,true,this.revelation_data.suit)
                SetAnchoredPosition(item.display_obj, this.posList_[vo - 1][1], this.posList_[vo - 1][2])
            })
            this.equip_items[vo] = item
        }

    }

    public SetSkillInfo() {
        let skillList = this.revelation_data.skill_list
        let skillId = 400101
        let skillLv = 0
        if (skillList && skillList.length > 0) {
            skillId = skillList[skillList.length - 1].skill_id
            skillLv = skillList[skillList.length - 1].lv
        }
        let skill_vo = SkillManager.GetInstance().getSkill(skillId)
        if (skillLv != 0) {
            this.skill_des.color = '#d15e00'
            this.skill_des.text = "Lv." + skillLv
        } else {
            this.skill_des.color = '#fe1a1a'
            this.skill_des.text = "未激活"
        }
        let icon = skill_vo.GetIcon((skillLv == 0 && 1 || skillLv))
        
        SetLocalPosition(this.skill_bg, -6, -5)
        SetSizeDelta(this.skill_bg, 94, 94)
        SetLocalPosition(this.skill_des, 12, 90)
        ResManager.GetInstance().SetImageSprite(this, this.skill_bg,"playerMessage","ui_rwxx_jndi")
        ResManager.GetInstance().SetOutsideImageSprite(this, this.skill, GameResPath.GetSkillIconPath(icon != 0 && icon || skillId))
    }

    public CreateModel() {
        let weapon_model_id = Util.GetWeaponClotheId(this.role_data)
        let id = this.revelation_data.current_figure_id
        id = id == 0 ? 1 : id
        let [role_res, texture_id] = Util.GetRevelationClothesRes(id, this.role_data.sex)
        let [hairs, hairs_text_id] = Util.GetRevelationHairRes(id, this.role_data.sex)
        let data = {
            clothe_res_id: role_res,
            texture_id: texture_id,
            type: UI_MODEL_TYPE.ROLE,
            can_rotate: true,
            layer_value: this.layer_value,
            weapon_res_id: weapon_model_id,
            head_wear_id: hairs,
            head_clothe_id: hairs_text_id,
            scale: 1,
            position: new Vector2(0, 0),
            fashion_model_id: role_res,
            sex: this.role_data.sex,
            career: this.role_data.career
        }
        ResManager.GetInstance().SetRoleModel(this, this.modelGp, data)
    }

    public DeleteMe() {
        for (let key in this.equip_items) {
            this.equip_items[key].DeleteMe()
            this.equip_items[key] = null
        }
        super.DeleteMe()
    }

    public ReOpen_callback() {
    }


    bg: Laya.Image
    lb_fight: Laya.Label
    _Image3: Laya.Image
    _Image4: Laya.Image
    _Image5: Laya.Image
    _Image6: Laya.Image
    _Image7: Laya.Image
    _Image8: Laya.Image
    _Image9: Laya.Image
    _Image10: Laya.Image
    _Image11: Laya.Image
    _Image12: Laya.Image
    modelGp: Laya.Box
    propBtn: Laya.Image
    skill: Laya.Image
    skill_des: Laya.Label
    equipGp: Laya.Box
    skill_bg: Laya.Image

    public GetComponents() {
        [
            this.bg,
            this.lb_fight,
            this._Image3,
            this._Image4,
            this._Image5,
            this._Image6,
            this._Image7,
            this._Image8,
            this._Image9,
            this._Image10,
            this._Image11,
            this._Image12,
            this.modelGp,
            this.propBtn,
            this.skill,
            this.skill_des,
            this.equipGp,
            this.skill_bg

        ]
            = this.GetChildrenByNames([

                "bg",
                "lb_fight",
                "_Image3",
                "_Image4",
                "_Image5",
                "_Image6",
                "_Image7",
                "_Image8",
                "_Image9",
                "_Image10",
                "_Image11",
                "_Image12",
                "modelGp",
                "propBtn",
                "skill",
                "skill_des",
                "equipGp",
                "skill_bg"
            ])
    }
}
window["PlayerMessageRevelationView"] = PlayerMessageRevelationView