import { ResManager } from "../common/ResManager"
import { RuneTreasureModel } from "../commonModel/RuneTreasureModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RuneModel } from "../commonModel/RuneModel"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { GameResPath } from "../util/GameResPath"
import { PartnerModel } from "../commonModel/PartnerModel"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { Vector2 } from "../util/Vector2"
import { Enum_UILayer } from "../common/LayerManager"
import { PlayerMessagePartnerSkillItem } from "./PlayerMessagePartnerSkillItem"
import { DemonDefine } from "../commonModel/DemonDefine"
import { PlayerMessageDemonTalentItem } from "./PlayerMessageDemonTalentItem"
import { PlayerMessageDemonSkillItem } from "./PlayerMessageDemonSkillItem"
import { DemonModel } from "../commonModel/DemonModel"
import { SceneNormalFont } from "../scene/fight/FightFont"

export class PlayerMessagePetItem extends BaseItemRenderer {
    bg: Laya.Image
    modelGp: Laya.Box
    titile: Laya.Image
    star_bg: Laya.Box
    star_bg_1: Laya.Image
    star_bg_2: Laya.Image
    star_bg_3: Laya.Image
    star_bg_4: Laya.Image
    star_bg_5: Laya.Image
    star_bg_6: Laya.Image
    star_bg_7: Laya.Image
    star_bg_8: Laya.Image
    star_bg_9: Laya.Image
    star_bg_10: Laya.Image
    star: Laya.Box
    star_1: Laya.Image
    star_2: Laya.Image
    star_3: Laya.Image
    star_4: Laya.Image
    star_5: Laya.Image
    star_6: Laya.Image
    star_7: Laya.Image
    star_8: Laya.Image
    star_9: Laya.Image
    star_10: Laya.Image
    skil_gp: Laya.HBox
    line: Laya.Image
    is_show: Laya.Image
    lb_name: Laya.Label
    color: Laya.Image

    model
    res_mgr
    goods_model
    rune_model
    data
    info
    skill_items
    demon_skill_1 //妖灵技能
    demon_skill_items
    //rune_mat:Laya.EffectMaterial
    //rune_tex

    public constructor() {
        super()
        this.base_file = "playerMessage"
        this.layout_file = "PlayerMessagePetItem"
        this.WIDTH = 468
        this.HEIGT = 300
        this.skill_items = []
        this.demon_skill_items = []
        this.res_mgr = ResManager.GetInstance()
        this.model = RuneTreasureModel.GetInstance()
        this.goods_model = GoodsModel.GetInstance()
        this.rune_model = RuneModel.GetInstance()


        this.Load()
    }

    public load_callback() {
        ResManager.GetInstance().SetTexture(this, this.bg, GameResPath.GetIcon("playerMessage", "ui_rwxx_ss03"))
        // ResManager.GetInstance().SetTexture(this,this.line,GameResPath.GetIcon("playerMessage",""))
        this.InitEvent()
    }

    public InitEvent() {

    }

    public dataChanged() {
        if (super.dataChanged()) {
            for (let i = 1; i <= 10; i++) {
                this["star_" + i].visible = false
            }
            this.is_show.visible = false
            if (this.data.type == 1) {//神巫
                // for (let i = 5; i <= 10; i++) {
                //     // this["star_" + i].visible = true
                //     this["star_bg_" + i].visible = true
                // }
                if (this.data.star > 0) {
                    for (let i = 1; i <= this.data.star; i++) {
                        ResManager.GetInstance().SetImageSprite(this,this["star_" + i],"playerMessage","pet_star")
                        this["star_" + i].visible = true
                    }
                }
                let list = PartnerModel.GetInstance().GetPartnerList()
                this.info = list[this.data.id - 1]
                let goods_basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(this.info.goods_id)
                this.lb_name.text = goods_basic.goods_name + "  " + this.data.stage+ "阶"
                let bg_res = ""
                let imgstage_res = "uihb_007"
                if (goods_basic) {
                    if (goods_basic.color == 4) {
                        bg_res = "uihb_013"
                        imgstage_res = "uihb_008"
                    } else if (goods_basic.color == 5) {
                        bg_res = "uihb_014"
                        imgstage_res = "uihb_009"
                    } else if (goods_basic.color == 7) {
                        bg_res = "uihb_015"
                        imgstage_res = "uihb_010"
                    }
                    if (imgstage_res) {
                        this.color.skin = GameResPath.GetIcon("partner", `${imgstage_res}`)
                        this.color.visible = true
                    } else {
                        this.color.visible = false
                    }
                    if (this.data.is_fight == 1) {
                        this.is_show.visible = true
                        this.is_show.skin = GameResPath.GetIcon("playerMessage","ui_rwxx_ss_11")
                    }
                    if (this.skill_items) {
                        for (let key in this.skill_items) {
                            this.skill_items[key].DeleteMe()
                        }
                        this.skill_items = []
                    }
                    let skill_list = this.info.skill_list
                    if (skill_list) {
                        skill_list = JSON.parse(skill_list)
                        for (let k in skill_list) {
                            let v = skill_list[k]
                            let item = this.skill_items[k]
                            if (!item) {
                                item = new PlayerMessagePartnerSkillItem(this.skil_gp)
                                item.Load()
                                this.skill_items[k] = item
                            }
                            item.SetData(v, this.info.id, null, k, this.data)
                        }
                    }
                    this.CreateModel(UI_MODEL_TYPE.PARTNER, this.info.figure_id)
                }
            } else {//妖灵
                // for (let i = 6; i <= 10; i++) {
                //     this["star_" + i].visible = false
                //     this["star_bg_" + i].visible = false
                // }
                for (let i = 1; i <= this.data.star; i++) {
                    ResManager.GetInstance().SetImageSprite(this,this["star_" + i],"playerMessage","pet_star")
                    this["star_" + i].visible = true
                }
                this.lb_name.text = this.data.info.demons_name
                if (this.demon_skill_items) {
                    for (let key in this.demon_skill_items) {
                        this.demon_skill_items[key].DeleteMe()
                    }
                    this.demon_skill_items = []
                }
                if (this.demon_skill_1) {
                    this.demon_skill_1.DeleteMe()
                    this.demon_skill_1 = null
                }
                if (this.data.skill_list.length > 0) {
                    if (!this.demon_skill_1) {
                        this.demon_skill_1 = new PlayerMessageDemonSkillItem(this.skil_gp)
                        this.demon_skill_1.SetData(this.data.skill_info)
                        this.demon_skill_1.Load()
                    }
                }
                if (this.data.slot_skill.length > 0) {
                    for (let key in this.data.slot_skill) {
                        let item = this.demon_skill_items[key]
                        if (!item) {
                            item = new PlayerMessageDemonTalentItem(this.skil_gp)
                            item.SetData(this.data.slot_skill[key], this.data.id, this.data.info)
                            item.Load()
                            this.demon_skill_items[key] = item
                        }
                    }
                }
                let tips_source = DemonDefine.tips_source[this.data.info.realm + "@" + this.data.info.color]
                if (tips_source) {
                    this.color.skin = GameResPath.GetIcon(tips_source[0], tips_source[1])
                }
                this.CreateModel(UI_MODEL_TYPE.DEMON, this.data.info.resource)
            }

        }
    }
    public CreateModel(type_id?, model_res?) {
        let action_cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "ClientOutWardModel", true)
        let pos_cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "ClientOutWardPos", true)
        let act_cfg = action_cfgs[model_res]
        let action_list = act_cfg && act_cfg.action_list
        let pos_cfg = pos_cfgs[model_res]
        if(type_id == 11){
        //    if(pos_cfg && pos_cfg.scale){
            pos_cfg = {}
            pos_cfg.scale = 1.5
            this.modelGp.y = -30
        //    }
        }
        let data = {
            clothe_res_id: model_res,
            type: type_id,
            can_rotate: true,
            layer_value: Enum_UILayer.Activity,
            scale: pos_cfg && pos_cfg.scale,
            position: pos_cfg && pos_cfg.position,
            rotate: pos_cfg && pos_cfg.rotate,
            texture_size: new Vector2(507, 415),
            action_name_list: ["idle"]// Util.DeepCopy(action_list),
        }
        ResManager.GetInstance().SetRoleModel(this, this.modelGp, data)

    }

    public DeleteMe() {
        if (this.skill_items) {
            for (let key in this.skill_items) {
                this.skill_items[key].DeleteMe()
            }
            this.skill_items = []
        }

        if (this.demon_skill_items) {
            for (let key in this.demon_skill_items) {
                this.demon_skill_items[key].DeleteMe()
            }
            this.demon_skill_items = []
        }

        if (this.demon_skill_1) {
            this.demon_skill_1.DeleteMe()
            this.demon_skill_1 = null
        }
        super.DeleteMe()
    }


    public GetComponents() {
        [
            this.bg,
            this.modelGp,
            this.titile,
            this.star_bg,
            this.star_bg_1,
            this.star_bg_2,
            this.star_bg_3,
            this.star_bg_4,
            this.star_bg_5,
            this.star_bg_6,
            this.star_bg_7,
            this.star_bg_8,
            this.star_bg_9,
            this.star_bg_10,
            this.star,
            this.star_1,
            this.star_2,
            this.star_3,
            this.star_4,
            this.star_5,
            this.star_6,
            this.star_7,
            this.star_8,
            this.star_9,
            this.star_10,
            this.skil_gp,
            this.line,
            this.is_show,
            this.lb_name,
            this.color,
        ]
            = this.GetChildrenByNames([

                "bg",
                "modelGp",
                "titile",
                "star_bg",
                "star_bg_1",
                "star_bg_2",
                "star_bg_3",
                "star_bg_4",
                "star_bg_5",
                "star_bg_6",
                "star_bg_7",
                "star_bg_8",
                "star_bg_9",
                "star_bg_10",
                "star",
                "star_1",
                "star_2",
                "star_3",
                "star_4",
                "star_5",
                "star_6",
                "star_7",
                "star_8",
                "star_9",
                "star_10",
                "skil_gp",
                "line",
                "is_show",
                "lb_name",
                "color",
            ])
    }
}
window["PlayerMessagePetItem"] = PlayerMessagePetItem