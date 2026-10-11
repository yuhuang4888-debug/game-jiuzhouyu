import { BaseItem1 } from "../common/BaseItem1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { FriendEvent, FriendModel } from "../commonModel/FriendModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { OutWardBaseModel, enum_OutWardType } from "../commonModel/OutWardBaseModel"
import { RoleManager } from "../commonModel/RoleManager"
import { PetRoundItem } from "../pet/PetRoundItem"
import { SceneBaseType } from "../scene/SceneConfig"
import { SkillManager } from "../skill/SkillManager"
import { Message } from "../sysInfo/SysInfoController"
import { GameResPath } from "../util/GameResPath"
import { SetLocalPosition, SetLocalPositionY, SetSizeDelta, Util } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { Config } from "../common/Config"

export class PlayerMessageOutWard extends BaseItem1 {


    SelectItem
    CreateModel
    CreateRoleModel
    ClearModel
    DesFunc
    InitView
    attr_box
    InitEvent
    UpdateView
    SetData
    need_refreshData
    type_id
    data
    index
    SetSkillData
    role_data
    stage
    BaseSkillData
    UpdateStar
    show_out_type = 0
    public constructor(parent?) {
        super(parent)
        this.base_file = "playerMessage"
        this.layout_file = "PlayerMessageOutWard"
        this.layer_value = Enum_UILayer.Activity

        let local_outwardModel = OutWardBaseModel
        let local_outwardModelIns = local_outwardModel.GetInstance()
        let local_illusion_cfg = local_outwardModelIns.outward_illusion_cfg
        let local_roleVo = RoleManager.GetInstance().GetMainRoleVo()
        let local_resMgr = ResManager.GetInstance()
        let skill_list_ = {}
        let skill_id_to_item_
        let selectedId_,
            oldItem_,
            illuItemList_ = {},
            starList_ = [],
            shadowList = [],
            propItemList_ = [],
            costItem_,
            costId_,
            defaultSelect_,
            outward_model_,
            model_id_ = null,
            outward_action_cfg_,
            model_name_
        this.index = 0   // 使用时加一，避开该功能的基本幻化
        this.stage = 1
        this.preload_client_config = {

        }
        this.preload_server_config = {
            "config_fashion_model": false
        }

        this.load_callback = () => {
            if (this.need_refreshData) {
                this.InitView()
                this.InitEvent()
            }
            outward_action_cfg_ = Config.PRELOAD_CLIENT_CONFIG.ClientOutWardModel
        }

        this.SetData = (type_id?, role_info?) => {
            this.type_id = type_id
            this.role_data = role_info
            if (this.is_loaded) {
                this.InitView()
                this.InitEvent()
            } else {
                this.need_refreshData = true
            }
        }

        this.InitEvent = () => {

            Util.AddClickEvent(this.left, () => {
                if(!this.data) return
                if (this.type_id == 6 && Util.IsTableEmpty(this.data.fashion_list)) {
                    return
                } else if (this.type_id == 6) {
                    if (this.index - 1 >= 0) {
                        this.index = this.index - 1
                        let fashion_id = this.data.fashion_list[this.index].fashion_id
                        // this.CreateRoleModel(fashion_id)
                        this.UpdateView();
                    } else {
                        Message.show("无更多展示")
                        this.index = this.index
                    }
                    return
                }
                if (Util.IsTableEmpty(this.data.figure_list)) return
                if (this.index - 1 > 0) {
                    this.show_out_type = 1
                    this.index = this.index - 1
                    // this.CreateModel()
                    this.UpdateView();
                } else if (this.index - 1 == 0) {
                    this.index = 0
                    this.show_out_type = 0
                    this.stage = this.stage
                    // this.CreateModel()
                    this.UpdateView();

                } else if (this.index == 0) {
                    this.index = 0
                    this.show_out_type = 0
                    if (this.stage - 1 >= 1) {
                        this.stage = this.stage - 1
                        // this.CreateModel()
                        this.UpdateView();
                    } else {
                        Message.show("无更多展示")
                        this.stage = this.stage
                    }
                } else {
                    this.index = this.index

                }
            }, this, true)

            Util.AddClickEvent(this.right, () => {
                if(!this.data) return
                if (this.type_id == 6 && Util.IsTableEmpty(this.data.fashion_list)) {
                    return
                } else if (this.type_id == 6) {
                    if (this.index + 1 <= this.data.fashion_list.length - 1) {
                        this.index = this.index + 1
                        let fashion_id = this.data.fashion_list[this.index].fashion_id
                        // this.CreateRoleModel(fashion_id)
                        this.UpdateView();
                    } else {
                        Message.show("无更多展示")
                        this.index = this.index
                    }
                    return
                }
                if (Util.IsTableEmpty(this.data.figure_list)) return
                if (this.index == 0) {
                    this.show_out_type = 0
                    if (this.stage + 1 <= this.data.figure_list[0].stage) {
                        this.stage = this.stage + 1
                        // this.CreateModel()
                        this.UpdateView();
                        return
                    } else {
                        this.stage = this.stage
                    }
                }
                if (this.index + 1 <= this.data.figure_list.length - 1) {
                    this.show_out_type = 1
                    this.index = this.index + 1
                    // this.CreateModel()
                    this.UpdateView();
                } else {
                    Message.show("无更多展示")
                    this.index = this.index
                }
            }, this, true)

            this.BindEvent(FriendModel.GetInstance(), FriendEvent.UPDATE_PLAYERMESSAGE_ILLUSION, () => {
                this.UpdateView()
            })
        }

        this.InitView = () => {
            let bg_name = ""
            if (this.type_id == 1) {
                bg_name = "ui_rwxx_bg_06"
            } else if (this.type_id == 2) {
                bg_name = "ui_rwxx_bg_06"
            } else if (this.type_id == 3) {
                bg_name = "ui_rwxx_bg_04"
            } else if (this.type_id == 4) {
                bg_name = "ui_rwxx_bg_04"
            } else if (this.type_id == 5) {
                bg_name = "ui_rwxx_bg_05"
            } else if (this.type_id == 6) {
                bg_name = "ui_rwxx_bg_04"
            } else if (this.type_id == 12) {
                bg_name = "ui_rwxx_bg_05"
            }
            ResManager.GetInstance().SetTexture(this, this.bg, GameResPath.GetIcon("playerMessage", bg_name))
            SetLocalPosition(this.bg, 0, 0)
            if(bg_name == "ui_rwxx_bg_04"){
                SetSizeDelta(this.bg, 602, 680)
            }else{
                SetSizeDelta(this.bg, 602, 622)
            }
            this.title.skin = GameResPath.GetIcon("playerMessage", this.type_id)
            for (let i = 0; i < 5; i++) {
                starList_[i] = this.star.getChildAt(i)
            }
            SetLocalPositionY(this.none, -80)
        }

        this.SelectItem = (id?) => {
        }

        this.UpdateView = () => {
            let str = ""
            if (this.type_id == 1) {
                str = "坐骑激活幻化数量："
            } else if (this.type_id == 2) {
                str = "侍魂激活幻化数量："
            } else if (this.type_id == 3) {
                str = "羽翼激活幻化数量："
            } else if (this.type_id == 4) {
                str = "御守激活幻化数量："
            } else if (this.type_id == 5) {
                str = "神兵激活幻化数量："
            } else if (this.type_id == 6) {
                str = "人物时装幻化数量："
            } else if (this.type_id == 7){
                str = "背饰激活幻化数量："
            }
             
            let temp_data = FriendModel.GetInstance().other_player_illusion_info
            for (let key in temp_data.illusion_list) {
                if (temp_data.illusion_list[key].type == this.type_id) {
                    this.data = temp_data.illusion_list[key]
                    break
                }
            }
            if (this.type_id == 6) {
                for (let key in temp_data.fashion_pos) {
                    if (temp_data.fashion_pos[key].pos_id == 1) {
                        this.data = temp_data.fashion_pos[key]
                    }
                }
            }
            if (this.data) {
                table.sort(this.data.figure_list, (a?, b?) => {
                    return a.id < b.id
                })
                
                if (this.type_id != 6 && this.data.figure_list[0] && this.show_out_type == 0) {
                    this.have_Info.visible = true
                    this.none.visible = false
                    this.star.visible = false
                    this.star_bgGp.visible = false
                    this.info_bg.visible = false
                    // if (this.data.figure_list[0].stage == 1 && this.data.figure_list.length == 1) {
                    //     this.left.visible = false
                    //     this.right.visible = false
                    // } else {
                    //     this.left.visible = true
                    //     this.right.visible = true
                    // }
                    let key = `${this.type_id}@${this.stage}@${this.role_data.career}`
                    if (local_outwardModelIns.outward_stage_cfg && local_outwardModelIns.outward_stage_cfg[key]) {
                        this.lb_name.text = local_outwardModelIns.outward_stage_cfg[key].name
                    }
                    this.lb_fight.text = this.data.power; // this.data.figure_list[0].combat
                    this.CreateModel()
                } else if (this.type_id != 6 && this.data.figure_list.length > 1 && this.show_out_type == 1) {
                    table.sort(this.data.figure_list, (a?, b?) => {
                        return a.id < b.id
                    })
                    this.have_Info.visible = true
                    this.none.visible = false
                    this.lb_fight.text = this.data.power
                    this.info.innerHTML = str + (this.data.num - 1)
                    // if ((this.data.num - 1) == 1) {
                    //     this.left.visible = false
                    //     this.right.visible = false
                    // } else {
                    //     this.left.visible = true
                    //     this.right.visible = true
                    // }
                    this.info.x = 314 / 2 - this.info.contextWidth / 2
                    this.info.y = 30 / 2 - this.info.contextHeight / 2
                    let star = 0
                    if (this.data.figure_list[this.index + 1]) {
                        star = this.data.figure_list[this.index + 1].star
                    } else {
                        star = this.data.figure_list[this.index].star
                    }

                    let star_res = ""
                    for (let i = 0; i < 5; i++) {
                        let star_stage = Math.floor((star - 1) / 5)
                        star_stage = star_stage < 0 ? 0 : star_stage
                        let star_num = star - star_stage * 5
                        if (star_stage == 1) {
                            star_res = "pet_moon"
                        } else if (star_stage == 2) {
                            star_res = "pet_son"
                        } else {
                            star_res = "pet_star"
                        }
                        starList_[i].visible = i < star_num
                        starList_[i].skin = GameResPath.GetIcon("playerMessage", star_res)
                    }
                    this.CreateModel()
                } else if (this.type_id == 6 && this.data.fashion_list.length > 0) {
                    this.have_Info.visible = true;
                    this.none.visible = false;
                    this.star.visible = false;
                    this.star_bgGp.visible = false;

                    // 总战力
                    let power: number = this.data.fashion_list.reduce((pre: number, data: any) => {
                        return pre += data.combat;
                    }, 0)

                    this.lb_fight.text = power.toString(); // this.data.fashion_list[this.index].combat
                    let info = GoodsModel.GetInstance().GetGoodsBasicByTypeId(this.data.fashion_list[this.index].fashion_id)
                    this.lb_name.text = info.goods_name
                    this.info.innerHTML = str + this.data.fashion_list.length
                    // if (this.data.fashion_list.length == 1) {
                    //     this.left.visible = false
                    //     this.right.visible = false
                    // } else {
                    //     this.left.visible = true
                    //     this.right.visible = true
                    // }
                    this.info.x = 314 / 2 - this.info.contextWidth / 2
                    this.info.y = 30 / 2 - this.info.contextHeight / 2
                    this.CreateRoleModel(this.data.fashion_list[this.index].fashion_id)
                } else {
                    this.have_Info.visible = false
                    this.none.visible = true
                    ResManager.GetInstance().SetTexture(this, this.role_bg, GameResPath.GetIcon("playerMessage", "none_1"))
                }
            } else {
                if (this.type_id == 6) {
                    this.lb_none.text = "该玩家未激活时装幻化"
                } else {
                    this.lb_none.text = "该玩家未激活幻化"
                }
                ResManager.GetInstance().SetTexture(this, this.role_bg, GameResPath.GetIcon("playerMessage", "none_1"))
                this.have_Info.visible = false
                this.none.visible = true
            }
            SetLocalPositionY(this.none, -80)
        }

        this.CreateModel = () => {
            if (this.show_out_type == 0) {
                let client_pos_cfg_ = local_resMgr.GetGameConfigFromCache(this, "ClientOutWardPos", true)
                ResManager.GetInstance().LoadGameConfig(this, "config_mount_stage", false, null, (cfg_mount_stage) => {
                    this.ClearModel();
                    let key = `${this.type_id}@${this.stage}@${this.role_data.career}`
                    let cfg = cfg_mount_stage[key]
                    if (cfg) {
                        let model_res = String(cfg.ride_figure)
                        // if (model_name_ == model_res) {
                        //     return
                        // }
                        // model_name_ = model_res
                        let action_list = null
                        if (outward_action_cfg_ && outward_action_cfg_[this.type_id + "@0"]) {
                            action_list = Util.DeepCopy(outward_action_cfg_[this.type_id + "@0"].action_list)
                        }
                        let pre_x = ""
                        let default_str = ""
                        let type = 1
                        if (this.type_id == enum_OutWardType.Horse) {
                            type = UI_MODEL_TYPE.HORSE
                            pre_x = "h"
                            default_str = "default_horse"
                        } else if (this.type_id == enum_OutWardType.Wings) {
                            type = UI_MODEL_TYPE.WING
                            pre_x = "w"
                            default_str = "default_wing"
                        } else if (this.type_id == enum_OutWardType.Partner) {
                            type = UI_MODEL_TYPE.SPRITE
                            pre_x = "s"
                            default_str = "default_sprite"
                        } else if (this.type_id == enum_OutWardType.HolyDevice) {
                            type = UI_MODEL_TYPE.WEAPON
                            pre_x = "d"
                            default_str = "default_weapon"
                        } else if (this.type_id == enum_OutWardType.Artifact) {
                            type = UI_MODEL_TYPE.ARTIFACT
                            pre_x = "a"
                            default_str = "default_artifact"
                        } else if (this.type_id == enum_OutWardType.BackOrnament) {
                            type = UI_MODEL_TYPE.BACKORNAMENT
                            pre_x = "b"
                            default_str = "default_back_ornament"
                        }
                        let data = null
                        let pos_cfg = null
                        let pos_cfg_special = client_pos_cfg_[`${pre_x}_${model_res}`]
                        if (pos_cfg_special) {
                            pos_cfg = pos_cfg_special
                        }else{
                            pos_cfg = client_pos_cfg_[default_str]
                        }
                        data = {
                            clothe_res_id: model_res,
                            type: type,
                            can_rotate: true,
                            layer_value: this.layer_value,
                            scale: pos_cfg && pos_cfg.playermessage_scale ? pos_cfg.playermessage_scale : client_pos_cfg_[default_str].playermessage_scale,
                            position: pos_cfg && pos_cfg.palyermessage_position ? pos_cfg.palyermessage_position : client_pos_cfg_[default_str].palyermessage_position,
                            rotate: pos_cfg && pos_cfg.playermessage_rotate ? pos_cfg.playermessage_rotate : client_pos_cfg_[default_str].playermessage_rotate,
                            texture_size: { x: 567, y: 415 },
                            action_name_list: action_list,
                            action_delta: true
                        }
                        if (data) {
                            ResManager.GetInstance().SetRoleModel(this, this.modelGp, data)
                        }
                    }
                })
                this.BaseSkillData()
            } else {

                model_id_ = this.data.figure_list[this.index].id

                if (!model_id_ || !this.type_id) {
                    return
                }
                this.ClearModel()
                let pre_x = ""
                let default_str = ""
                let modelType = 1
                if (this.type_id == enum_OutWardType.Horse) {
                    modelType = UI_MODEL_TYPE.HORSE
                    pre_x = "h"
                    default_str = "default_horse"
                } else if (this.type_id == enum_OutWardType.Wings) {
                    modelType = UI_MODEL_TYPE.WING
                    pre_x = "w"
                    default_str = "default_wing"
                } else if (this.type_id == enum_OutWardType.Partner) {
                    modelType = UI_MODEL_TYPE.SPRITE
                    pre_x = "s"
                    default_str = "default_sprite"
                } else if (this.type_id == enum_OutWardType.HolyDevice) {
                    modelType = UI_MODEL_TYPE.WEAPON
                    pre_x = "d"
                    default_str = "default_weapon"
                } else if (this.type_id == enum_OutWardType.Artifact) {
                    modelType = UI_MODEL_TYPE.ARTIFACT
                    pre_x = "a"
                    default_str = "default_artifact"
                } else if (this.type_id == enum_OutWardType.BackOrnament) {
                    modelType = UI_MODEL_TYPE.BACKORNAMENT
                    pre_x = "b"
                    default_str = "default_back_ornament"
                }
                let action_list = null
                let action_key = this.type_id + "@1"
                let client_pos_cfg_ = local_resMgr.GetGameConfigFromCache(this, "ClientOutWardPos", true)
                let action_config = local_outwardModelIns.outward_action_cfg
                if (action_config && action_config[action_key]) {
                    action_list = action_config[action_key].action_list
                }
                let cfg = local_illusion_cfg[this.type_id + "@" + model_id_ + "@" + this.role_data.career];

                if (!cfg) {
                    return;
                }

                let model_res = Number(cfg.ride_figure)
                // let pos_cfg = client_pos_cfg_[`${pre_x}_${model_res}`]
                // if (!pos_cfg) {
                let pos_cfg = null
                let pos_cfg_special = client_pos_cfg_[`${pre_x}_${model_res}`]
                if (pos_cfg_special) {
                    pos_cfg = pos_cfg_special
                }else{
                    pos_cfg = client_pos_cfg_[default_str]
                }
                // }
                // let temp_pos = { x: pos_cfg.position.x, y: pos_cfg.position.y }
                // temp_pos.x = pos_cfg.x_offset ? pos_cfg.position.x + pos_cfg.x_offset : pos_cfg.position.x
                let data = {
                    clothe_res_id: model_res,
                    type: modelType,
                    can_rotate: true,
                    layer_value: this.layer_value,
                    scale: pos_cfg && pos_cfg.playermessage_scale ? pos_cfg.playermessage_scale : client_pos_cfg_[default_str].playermessage_scale,
                    position: pos_cfg && pos_cfg.palyermessage_position ? pos_cfg.palyermessage_position : client_pos_cfg_[default_str].palyermessage_position,
                    rotate: pos_cfg && pos_cfg.playermessage_rotate ? pos_cfg.playermessage_rotate : client_pos_cfg_[default_str].playermessage_rotate,
                    texture_size: new Vector2(567, 415),
                    action_name_list: action_list,
                    action_delta: true
                }
                if (data) {
                    ResManager.GetInstance().SetRoleModel(this, this.modelGp, data)
                }
                this.lb_name.text = cfg.name
                let skill_cfg = JSON.parse(cfg.skill_list)
                this.SetSkillData(skill_cfg)
                this.UpdateStar()
            }

        }

        this.CreateRoleModel = (fashion_id?) => {
            if (this.role_data && this.type_id == 6) {
                let [role_res, role_color] = Util.GetRoleClotheId(this.role_data)
                if (fashion_id) {
                    let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_fashion_model", false)
                    let id = 1 + "@" + fashion_id + "@" + this.role_data.career + "@" + this.role_data.sex + "@" + 0
                    role_res = cfg[id].model_id
                }
                let wing_res
                let type = SceneBaseType.Role
                let rotate = null
                let _scale = 250
                let model_id = this.role_data.level_model_list[0].level_model_id
                let weapon_res = Util.GetWeaponClotheId(this.role_data)
                let [head_res, head_texture_id] = Util.GetRoleHeadId(this.role_data)
                let data = {
                    career: this.role_data.career,
                    sex: this.role_data.sex,
                    clothe_res_id: role_res,
                    weapon_res_id: weapon_res,
                    weapon_clothe_id: 0,
                    type: 1,
                    fashion_model_id: role_res,
                    texture_id: 0,// role_color,
                    wing_id: wing_res,
                    head_wear_id: head_res,
                    head_clothe_id: 0,
                    hair_id: 0,
                }
                ResManager.GetInstance().SetRoleModel(this, this.modelGp, data)
            }
        }


        //坐骑基本技能
        this.BaseSkillData = () => {
            if (skill_list_) {
                for (let key in skill_list_) {
                    skill_list_[key].DeleteMe()
                }
                skill_list_ = {}
            }
            let skill_info_list = local_outwardModelIns.GetDefaultSkillList(this.data.type)
            if (skill_info_list) {
                let sort_func = (a?, b?) => {
                    return a.stage < b.stage
                }
                table.sort(skill_info_list, sort_func)
                for (let skill_id in skill_info_list) {
                    let skill_item = skill_list_[skill_info_list[skill_id].skill_id]
                    if (!skill_item) {
                        skill_item = new PetRoundItem(this.skillGp)
                        skill_item.Load()
                        skill_list_[skill_info_list[skill_id].skill_id] = skill_item
                    }
                }
            }
            for (let skill_id in skill_list_) {
                let skill_vo = SkillManager.GetInstance().getSkill(skill_id)
                let show_icon = (skill_vo && skill_vo.level == 0) ? skill_vo.GetIcon(1) : skill_vo.GetIcon()
                let source_str = `resource/game/skillIcon/${show_icon}.png`
                let SkillClickFunc = () => {
                    local_outwardModelIns.Fire(local_outwardModel.OPEN_VIEW, "PetSkillView", skill_id, this.type_id)
                }
                let is_lock = true
                let lock_stage
                for (let key in this.data.figure_list) {
                    for (let _ in this.data.figure_list[key].skill_list) {
                        if (this.data.figure_list[key].skill_list[_].skill_id == skill_id) {
                            is_lock = false
                            break
                        }
                    }
                }
                skill_list_[skill_id].SetData(source_str, SkillClickFunc, is_lock, lock_stage, 0, 0, false, false)
            }
        }


        //幻化技能
        this.SetSkillData = (cfg?) => {
            if (cfg && cfg.length > 0) {
                if (skill_list_) {
                    for (let key in skill_list_) {
                        skill_list_[key].DeleteMe()
                    }
                    skill_list_ = {}
                }
                let i = 0
                skill_id_to_item_ = {}
                let sort_func = (a?, b?) => {
                    let askill_data = local_outwardModelIns.outward_skill_cfg[`${this.type_id}@${a}`]
                    let bskill_data = local_outwardModelIns.outward_skill_cfg[`${this.type_id}@${b}`]
                    if (askill_data && bskill_data) {
                        return askill_data.stage < bskill_data.stage
                    } else {
                        return false
                    }
                }
                table.sort(cfg, sort_func)

                for (let index in cfg) {
                    let skill_item = skill_list_[i]
                    if (!skill_item) {
                        skill_item = new PetRoundItem(this.skillGp)
                        skill_item.Load()
                        skill_list_[i] = skill_item
                    }
                    skill_item.ExcuteCallback(() => {
                        skill_item.display_obj.visible = true
                    })
                    let key = `${this.type_id}@${cfg[i]}`
                    let skill_data = local_outwardModelIns.outward_skill_cfg[key]
                    if (skill_data) {
                        let skill_info = SkillManager.GetInstance().getSkillFromConfig(skill_data.skill_id)
                        if (skill_info && skill_info.type != 1) {
                            let source_str = `resource/game/skillIcon/${skill_data.skill_id}.png`
                            let SkillClickFunc = () => {
                                local_outwardModelIns.Fire(local_outwardModel.OPEN_VIEW, "PetSkillView", skill_data.skill_id, this.type_id)
                            }

                            let is_lock = true
                            let lock_stage
                            for (let key in this.data.figure_list) {
                                for (let _ in this.data.figure_list[key].skill_list) {
                                    if (this.data.figure_list[key].skill_list[_].skill_id == skill_data.skill_id) {
                                        is_lock = false
                                        break
                                    }
                                }
                            }
                            if (is_lock) {
                                lock_stage = skill_data.stage
                            }
                            skill_item.ExcuteCallback(() => {
                                skill_item.SetData(source_str, SkillClickFunc, is_lock, lock_stage, 0, 0, false)
                            })
                        }
                        i++
                        skill_id_to_item_[skill_data.skill_id] = skill_item
                    }
                }
                for (let key in skill_list_) {
                    skill_list_[key].visible = false
                }
                // for (i; i < skill_list_.length; i++) {
                //     let skill_item = skill_list_[i]
                //     skill_item.display_obj.visible = false
                // }

            } else {

            }
        }

        this.UpdateStar = () => {
            let star = 0
            if (this.data.figure_list[this.index + 1]) {
                star = this.data.figure_list[this.index + 1].star
            } else {
                star = this.data.figure_list[this.index].star
            }
            let star_res = ""
            for (let i = 0; i < 5; i++) {
                let star_stage = Math.floor((star - 1) / 5)
                star_stage = star_stage < 0 ? 0 : star_stage
                let star_num = star - star_stage * 5
                if (star_stage == 1) {
                    star_res = "pet_moon"
                } else if (star_stage == 2) {
                    star_res = "pet_son"
                } else {
                    star_res = "pet_star"
                }
                starList_[i].visible = i < star_num
                starList_[i].skin = GameResPath.GetIcon("playerMessage", star_res)
            }
        }


        this.ClearModel = () => {
            if (!outward_model_) {
                return
            }
            outward_model_.DeleteMe()
            outward_model_ = null
        }

        this.DesFunc = () => {
            if (skill_list_) {
                for (let key in skill_list_) {
                    skill_list_[key].DeleteMe()
                }
                skill_list_ = null
            }

            this.ClearModel()
            if (costItem_) {
                costItem_.DeleteMe()
                costItem_ = null
            }
            if (propItemList_) {
                for (let vo of propItemList_) {
                    vo.DeleteMe()
                    vo = null
                }
                propItemList_ = []
            }
            if (illuItemList_) {
                for (let key in illuItemList_) {
                    illuItemList_[key].DeleteMe()
                    delete illuItemList_[key]
                }
                illuItemList_ = {}
            }

            oldItem_ = null
            this.type_id = null
            model_id_ = null
        }
    }

    public DeleteMe() {
        this.DesFunc()
        super.DeleteMe()
    }

    modelGp: Laya.Box
    lb_fight: Laya.Label
    left: Laya.Image
    right: Laya.Image
    img_name_bg: Laya.Image
    lb_name: Laya.Label
    star_bgGp: Laya.VBox
    bg_1: Laya.Image
    bg_2: Laya.Image
    bg_3: Laya.Image
    bg_4: Laya.Image
    bg_5: Laya.Image
    star: Laya.VBox
    star_1: Laya.Image
    star_2: Laya.Image
    star_3: Laya.Image
    star_4: Laya.Image
    star_5: Laya.Image
    info_bg: Laya.Image
    info: Laya.HTMLDivElement
    title: Laya.Image
    skillGp: Laya.HBox
    bg: Laya.Image
    have_Info: Laya.Box
    none: Laya.Box
    role_bg: Laya.Image
    lb_none: Laya.Label
    public GetComponents() {
        [
            this.modelGp,
            this.lb_fight,
            this.left,
            this.right,
            this.img_name_bg,
            this.lb_name,
            this.star_bgGp,
            this.bg_1,
            this.bg_2,
            this.bg_3,
            this.bg_4,
            this.bg_5,
            this.star,
            this.star_1,
            this.star_2,
            this.star_3,
            this.star_4,
            this.star_5,
            this.info_bg,
            this.info,
            this.title,
            this.skillGp,
            this.bg,
            this.have_Info,
            this.none,
            this.role_bg,
            this.lb_none
        ]
            = this.GetChildrenByNames([

                "modelGp",
                "lb_fight",
                "left",
                "right",
                "img_name_bg",
                "lb_name",
                "star_bgGp",
                "bg_1",
                "bg_2",
                "bg_3",
                "bg_4",
                "bg_5",
                "star",
                "star_1",
                "star_2",
                "star_3",
                "star_4",
                "star_5",
                "info_bg",
                "info",
                "title",
                "skillGp",
                "bg",
                "have_Info",
                "none",
                "role_bg",
                "lb_none"
            ])
        this.info.style.fontSize = 18
        this.info.style.color = "#ffffff"
        this.info.style.wordWrap = false
        ResManager.GetInstance().LoadFont(this, "fighting_font", this.lb_fight, null, false)
    }
}
window["PlayerMessageOutWard"] = PlayerMessageOutWard