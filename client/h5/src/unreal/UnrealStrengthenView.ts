import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { MaterialsTool } from "../common/MaterialsTool"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { WordManager } from "../common/WordManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { UnrealModel } from "../commonModel/UnrealModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { ErlangParser } from "../util/ErlangParser"
import { PlayBigEffect, SetHtmlCenter, Util } from "../util/Util"
import { UnrealEquipStrenItem } from "./UnrealEquipStrenItem"
import { UnrealNextAttrItem } from "./UnrealNextAttrItem"
import { UnrealStrenCostItem } from "./UnrealStrenCostItem"
import { GiftPushIcon } from "../mainUI/GiftPushIcon"
import { EnumPushGiftType, PushGiftModel } from "../commonModel/PushGiftModel"

export class UnrealStrengthenView extends BaseItem1 {

    LoadSuccess
    InitEvent
    InitView
    SwitchEquip
    UpdateView
    UpdateCost
    GetBaseAndStrenProStr
    UpdateEquipInfo
    UpdateEquips
    UpdateNowAttr
    FormatAttr

    private giftItem: GiftPushIcon;

    public constructor(parent) {
        super(parent)
        this.base_file = "unreal"
        this.layout_file = "UnrealStrengthenView"
        let model = UnrealModel.GetInstance(),
            res_mgr = ResManager.GetInstance(),
            local_Util = Util,
            local_UnrealModel = UnrealModel,
            goods_model = GoodsModel.GetInstance(),
            material_tool = MaterialsTool.GetInstance(),
            local_Message = Message,
            local_GoodsModel = GoodsModel,
            erlang_parser = ErlangParser.GetInstance(),
            local_Number = Number,
            local_WordManager = WordManager,
            role_mgr = RoleManager.GetInstance(),
            equip_list_,
            now_equip_: UnrealEquipStrenItem,
            now_equip_info_,
            now_equip_stren_,
            offset_ = 6,
            select_equip_type_,
            wear_unreal_dic_,
            state_,
            now_cost_,
            cost_item_list_,
            now_attr_list_,
            attr_cache_,
            max_stage_tips_ = "已达到当前等级进阶上限",
            stage_state_,
            can_stren_ = false,
            // equip_pos_ = [
            //     { x: 8 - offset_, y: 8 - offset_ },
            //     { x: 8 - offset_, y: 162 - offset_ },
            //     { x: 8 - offset_, y: 314 - offset_ },
            //     { x: 425 - offset_, y: 8 - offset_ },
            //     { x: 425 - offset_, y: 162 - offset_ },
            //     { x: 425 - offset_, y: 314 - offset_ },
            // ]
            equip_pos_ = [
                { x: 3, y: 2 },
                { x: 347, y: 2 },
                { x: 3, y: 145 },
                { x: 347, y: 145 },
                { x: 3, y: 287 },
                { x: 347, y: 287 },
            ]
        this.preload_server_config = {
            "config_dec_unlock_cell": false
        }
        this.load_callback = function () {
            this.LoadSuccess()

        }

        this.LoadSuccess = () => {
            this._Scroller1.vScrollBar.visible = false
            // res_mgr.SetTexture(this, this._img_equip_bg, "resource/game/unreal/texture/uihs_007.png")
            // res_mgr.SetTexture(this, this._img_attr_bg, "resource/game/unreal/texture/uihs_004.png")

            this.InitView()
            this.InitEvent()
            this.ShowGiftIcon();
        }

        this.InitEvent = () => {

            this.BindEvent(PushGiftModel.GetInstance(), PushGiftModel.UPDATE_ICON, (giftId: number) => {
                this.ShowGiftIcon();
            })


            local_Util.AddClickEvent(this._gp_level_up, () => {
                switch (state_) {
                    case 0:
                        if (can_stren_)
                            model.Fire(local_UnrealModel.REQUEST_CCMD_EVENT, 14905, now_equip_info_.cell, 1)
                        else if (now_cost_) {
                            for (let value of now_cost_) {
                                let my_count = goods_model.GetTypeGoodsNum(value.type_id)
                                let cost_count = value.count
                                if (my_count < cost_count) {
                                    material_tool.materialsTips(value.type_id)
                                    break
                                }
                            }
                        }

                        break
                    case 1:
                        if (!stage_state_) {
                            local_Message.show(max_stage_tips_)
                            return
                        }
                        if (can_stren_)
                            model.Fire(local_UnrealModel.REQUEST_CCMD_EVENT, 14903, now_equip_info_.goods_id)
                        else if (now_cost_) {
                            for (let value of now_cost_) {
                                let my_count = goods_model.GetTypeGoodsNum(value.type_id)
                                let cost_count = value.count
                                if (my_count < cost_count) {
                                    material_tool.materialsTips(value.type_id)
                                    break
                                }
                            }
                        }
                        break
                    case 2:
                        local_Message.show("已满级!")
                        break
                }

            }, this, true)


            this.BindEvent(model, local_UnrealModel.UPDATE_EQUIP_STREN_DATA, (cell) => {
                if (now_equip_info_ && cell == now_equip_info_.cell) {
                    this.UpdateView()
                }
            })

            this.BindEvent(goods_model, local_GoodsModel.CHANGE_UNREAL_LIST, () => {
                this.UpdateEquips()
                this.UpdateEquipInfo()
                this.UpdateView()
            })

            this.BindEvent(model, local_UnrealModel.STAGE_SUCCESS, () => {
                this.AddUIEffect("ui_shengjiechenggong_glow", this._gp_effect)
            })

            this.BindEvent(goods_model, local_GoodsModel.UPDATE_GOODS_NUM, (goods_list) => {
                if (this.use_delete_method) return
                for (let vo of goods_list) {
                    if (now_cost_) {
                        for (let value of now_cost_) {
                            if (value.type_id == vo.type_id) {
                                this.UpdateCost()
                                break
                            }
                        }
                    }
                }
            })

            this.BindEvent(model, local_UnrealModel.STAGE_PREVIEW, (goods_id) => {
                let decoration_level_cfg = res_mgr.GetGameConfigFromCache(this, "config_decoration_level", false)
                let decoration_stage_cfg = res_mgr.GetGameConfigFromCache(this, "config_decoration_stage", false)
                if (now_equip_info_.goods_id == goods_id) {
                    let next_stage_info = model.GetStagePreviewData()
                    let stren_key = now_equip_info_.equip_type + "@" + now_equip_stren_
                    let stren_cfg = model.GetUnrealStrenValue(stren_key, decoration_level_cfg)
                    let stren_list = []
                    if (stren_cfg) {
                        stren_list = JSON.parse(stren_cfg.attr)
                    }
                    let stage_cfg = model.GetUnrealStageValue(now_equip_info_.type_id, decoration_stage_cfg)
                    let basic = goods_model.GetGoodsBasicByTypeId(stage_cfg.new_goods_id)
                    this._lb_next_attr.style.fontSize = 24
                    this._lb_next_attr.style.leading = 17
                    this._lb_next_attr.width = 240
                    this._lb_next_attr.style.color = "#663915"
                    this._lb_next_attr.innerHTML = local_Util.StrToHTML(this.GetBaseAndStrenProStr(erlang_parser.Parse(basic.base_attrlist), stren_list, "'#0a953e'", next_stage_info.equip_extra_attr, true))
                }
            })

        }

        this.InitView = () => {
            if (!equip_list_)
                equip_list_ = []
            let item: UnrealEquipStrenItem

            let func = (subtype) => {
                this.SwitchEquip(subtype)
            }

            for (let i = 0; i < local_UnrealModel.equip_count; i++) {
                item = new UnrealEquipStrenItem(this._gp_equips)
                item.SetCallBack(func)
                equip_list_[i] = item
                let pos = equip_pos_[i]
                item.SetPosition(pos.x, pos.y)
                item.SetEquipType(i + 1)
                item.Load()
            }

            now_equip_ = new UnrealEquipStrenItem(this._gp_select_equip)
            now_equip_.Load()

            this.UpdateEquipInfo()
            this.UpdateEquips()


            let decoration_attr_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_decoration_attr", false)
            let decoration_level_max_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_decoration_level_max", false)
            let decoration_level_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_decoration_level", false)
            let decoration_stage_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_decoration_stage", false)
            let decoration_stage_max_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_decoration_stage_max", false)

            let defalut_equip_type
            for (let key in wear_unreal_dic_) {
                let info = wear_unreal_dic_[key]
                if (info) {
                    let red = model.GetEquipCanUp(info,
                        decoration_attr_cfg,
                        decoration_level_max_cfg,
                        decoration_level_cfg,
                        decoration_stage_cfg,
                        decoration_stage_max_cfg
                    )
                    if (red) {
                        defalut_equip_type = info.subtype
                        break
                    } else {
                        if (defalut_equip_type == undefined) {
                            defalut_equip_type = info.subtype
                        }
                    }
                }
            }
            if (defalut_equip_type)
                this.SwitchEquip(defalut_equip_type)
        }

        this.DeleteMe = () => {
            if (now_attr_list_) {
                for (let obj of now_attr_list_) {
                    obj.DeleteMe()
                }
                now_attr_list_ = undefined
            }

            if (now_equip_) {
                now_equip_.DeleteMe()
                now_equip_ = undefined
            }

            if (equip_list_) {
                for (let obj of equip_list_) {
                    obj.DeleteMe()
                }
                equip_list_ = undefined
            }

            if (cost_item_list_) {
                for (let obj of cost_item_list_) {
                    obj.DeleteMe()
                }
                cost_item_list_ = undefined
            }

            if (this.giftItem) {
                this.giftItem.DeleteMe();
                this.giftItem = null;
            }

            super.DeleteMe()
        }

        this.SwitchEquip = (equip_type) => {
            if (select_equip_type_ == equip_type)
                return

            let item = equip_list_[select_equip_type_ - 1]
            if (item) {
                item.SetSelect(false)
            }

            item = equip_list_[equip_type - 1]
            if (item) {
                item.SetSelect(true)
            }
            select_equip_type_ = equip_type
            attr_cache_ = undefined
            this.UpdateView()
        }

        this.UpdateView = () => {
            let info = wear_unreal_dic_[select_equip_type_]

            let equip_info = info
            if (!equip_info)
                return
            now_equip_info_ = equip_info

            now_equip_.SetData(equip_info, false)

            let stren_data = model.GetStrenData(equip_info.cell)
            let now_stren = stren_data ? stren_data.level : 0

            let decoration_attr_cfg = res_mgr.GetGameConfigFromCache(this, "config_decoration_attr", false)
            let attr_cfg = model.GetUnrealData(equip_info.type_id, decoration_attr_cfg)

            let stren_max_key
            let stage
            if (attr_cfg) {
                stage = attr_cfg.stage
                stren_max_key = `${equip_info.equip_type}@${attr_cfg.stage}@${equip_info.color}`
            }

            let decoration_level_max_cfg = res_mgr.GetGameConfigFromCache(this, "config_decoration_level_max", false)
            let stren_max_cfg = model.GetUnrealStrenMax(stren_max_key, decoration_level_max_cfg)

            let limit_level = 0
            if (stren_max_cfg) {
                limit_level = stren_max_cfg.limit_level
            }

            // let desc = <Array<egret.ITextElement>>[
            //     { text: "强化等级达到 " },
            //     { text: `${limit_level}`, style: { size: 32, textColor: "'#ff9015'" } },
            //     { text: " 级可进阶，增强极品属性" },
            // ]
            let desc = "强化等级达到 <font color='#ff8519'>" + limit_level + "级</font> 可进阶，增强极品属性"

            if (limit_level && now_stren > limit_level) {
                now_stren = limit_level
            }

            now_equip_stren_ = now_stren
            console.warn("now_stren-----------:", now_stren)
            this._lb_sten_lv.text = "+" + now_stren

            let stren_key = equip_info.equip_type + "@" + now_stren

            let decoration_level_cfg = res_mgr.GetGameConfigFromCache(this, "config_decoration_level", false)
            let stren_cfg = model.GetUnrealStrenValue(stren_key, decoration_level_cfg)
            let stren_list = []
            if (stren_cfg) {
                stren_list = JSON.parse(stren_cfg.attr)
            }

            this.UpdateNowAttr(erlang_parser.Parse(equip_info.base_attrlist), stren_list, equip_info.equip_extra_attr)
            stage_state_ = true
            if (limit_level <= now_stren) {
                let decoration_stage_cfg = res_mgr.GetGameConfigFromCache(this, "config_decoration_stage", false)
                let stage_cfg = model.GetUnrealStageValue(equip_info.type_id, decoration_stage_cfg)
                let decoration_stage_max_cfg = res_mgr.GetGameConfigFromCache(this, "config_decoration_stage_max", false)
                let max_stage = model.GetUnrealMaxStage(decoration_stage_max_cfg)
                if (max_stage == stage) {
                    stage_state_ = false
                    desc = local_Util.StrToHTML(max_stage_tips_)
                }
                if (stage_cfg && stage_cfg.new_goods_id) {
                    state_ = 1
                    this._lb_level_up.text = "进阶"
                    this._lb_next_tips.text = "下阶属性"
                    this._lb_cost_tips.text = "消耗进阶材料:"

                    this._gp_next_tips.visible = this._lb_tips.visible = this._lb_next_attr.visible = this._gp_cost.visible = true
                    this._img_lv_max.visible = this._lb_un_stren.visible = false

                    let basic = goods_model.GetGoodsBasicByTypeId(stage_cfg.new_goods_id)
                    this._lb_next_attr.style.fontSize = 24
                    this._lb_next_attr.style.leading = 17
                    this._lb_next_attr.width = 240
                    this._lb_next_attr.style.color = "#663915"
                    this._lb_next_attr.innerHTML = local_Util.StrToHTML(this.GetBaseAndStrenProStr(erlang_parser.Parse(basic.base_attrlist), stren_list, "'#0a953e'", [], true))
                    model.Fire(local_UnrealModel.REQUEST_CCMD_EVENT, 14906, equip_info.goods_id)
                    let list = JSON.parse(stage_cfg.cost)
                    if (list && list.length > 0) {
                        now_cost_ = []
                        for (let value of list) {
                            let [type_id, lock] = goods_model.GetMappingTypeId(value[0], value[1])
                            now_cost_.push({ type_id: type_id, count: value[2] })
                        }
                    }
                    this.UpdateCost()
                } else {
                    state_ = 2
                    this._gp_next_tips.visible = this._gp_cost.visible = this._lb_tips.visible = this._lb_next_attr.visible = false
                    let bool = !limit_level
                    this._img_lv_max.visible = !bool
                    this._lb_un_stren.visible = bool
                }
            }
            else {
                state_ = 0

                this._lb_next_attr.visible = this._gp_next_tips.visible = this._gp_cost.visible = this._lb_tips.visible = true
                this._img_lv_max.visible = this._lb_un_stren.visible = false

                this._lb_level_up.text = "强化"
                this._lb_next_tips.text = "下级属性"
                this._lb_cost_tips.text = "消耗强化材料:"
                let next_stren_key = `${equip_info.equip_type}@${now_stren + 1}`
                let next_stren_cfg = model.GetUnrealStrenValue(next_stren_key, decoration_level_cfg)
                let next_stren_list = next_stren_cfg ? JSON.parse(next_stren_cfg.attr) : []
                this._lb_next_attr.style.fontSize = 24
                this._lb_next_attr.style.leading = 17
                this._lb_next_attr.width = 240
                this._lb_next_attr.style.color = "#663915"
                this._lb_next_attr.innerHTML = local_Util.StrToHTML(this.GetBaseAndStrenProStr(erlang_parser.Parse(equip_info.base_attrlist), next_stren_list, "'#0a953e'", equip_info.equip_extra_attr, false))

                let list = JSON.parse(stren_cfg.cost)
                if (list && list.length > 0) {
                    now_cost_ = []
                    for (let value of list) {
                        let [type_id, lock] = goods_model.GetMappingTypeId(value[0], value[1])
                        now_cost_.push({ type_id: type_id, count: value[2] })
                    }
                }
                this.UpdateCost()
            }
            this._lb_tips.style.fontSize = 18
            this._lb_tips.width = 720
            this._lb_tips.style.color = "#2ddf57"
            this._lb_tips.innerHTML = desc
            SetHtmlCenter(this._lb_tips, { "x": 0, "w": 720 })
        }


        this.UpdateCost = () => {
            let list = []

            let bool = true

            if (now_cost_ && now_cost_.length > 0) {
                list = now_cost_
            }

            if (!cost_item_list_)
                cost_item_list_ = []

            for (let i = list.length; i < cost_item_list_.length; i++) {
                cost_item_list_[i].visible = false
            }

            for (let key in list) {
                let item = cost_item_list_[key]
                let value = list[key]
                if (!item) {
                    item = new UnrealStrenCostItem(this._gp_cost_award)
                    item.Load()
                    cost_item_list_[key] = item
                }

                let my_count = goods_model.GetTypeGoodsNum(value.type_id)
                let cost_count = value.count
                let bool1 = my_count >= cost_count
                if (!bool1 || !bool) {
                    bool = false
                }

                item.SetData(value.type_id, bool ? "'#b3ff48'" : "'#fe140d'", my_count, cost_count)
                item.visible = true
            }


            local_Util.SetImageGray(this._gp_level_up, !stage_state_)

            this._img_stren_red.visible = stage_state_ ? bool : false

            can_stren_ = bool
        }

        this.GetBaseAndStrenProStr = (base_attrlist, stren_list, font_color, equip_extra_attr, is_upstage): string => {
            let str = ""
            let stren_str
            let pro

            let list = this.FormatAttr(base_attrlist, stren_list, equip_extra_attr, is_upstage)
            if (list) {
                for (let vo of list) {
                    font_color = vo.add == 1 ? "'#0a953e'" : "'#d85d03'"
                    if (vo.add == 1) {

                    }
                    if (vo.kind != 1) {
                        str += "<font color='#8400FF'>" + vo.desc + `:</font><font color=${font_color}>` + vo.value + "</font><br/>";
                    } else {
                        str += vo.desc + `:<font color='#0a953e'>` + vo.value + "</font><br/>";
                    }

                }
            }



            // if (base_attrlist && Array.isArray(base_attrlist)) {
            //     base_attrlist.forEach((val, idx, array) => {
            //         stren_str = ""
            //         if (stren_list && Array.isArray(stren_list)) {
            //             for (let i = 0; i < stren_list.length; i++) {
            //                 pro = stren_list[i]
            //                 if (pro && pro[0] == val[0] && pro[1] > 0) {
            //                     stren_str = local_Number(pro[1])
            //                     break
            //                 }
            //             }
            //         }
            //         str += local_WordManager.GetProperties(val[0]) + `:<font color=${font_color}>` + (local_Number(val[1]) + stren_str) + "</font><br/>";
            //     })
            // }

            // for (let i = 0; i < equip_extra_attr.length; i++) {
            //     let vo = equip_extra_attr[i]
            //     let pro = local_WordManager.GetProperties(vo.attr_id)
            //     let value = local_WordManager.ConvertToPercentValue(vo.attr_id, vo.attr_val)
            //     if (vo.type_id == 1) {
            //         let level = role_mgr.mainRoleInfo.level
            //         value = Math.floor(level / vo.plus_interval) * vo.plus_unit
            //         pro = pro.replace("{0}", vo.plus_interval)
            //     }
            //     if (i == equip_extra_attr.length - 1) {
            //         str += `${pro}:<font color=${font_color}>${value}</font>`
            //     } else
            //         str += `${pro}:<font color=${font_color}>${value}</font><br/>`
            // }
            return str
        }

        this.UpdateEquipInfo = () => {
            let wear_unreal_list = goods_model.wear_unreal_list
            let dic = {}
            for (let equip_type in wear_unreal_list) {
                let equip_info = wear_unreal_list[equip_type]
                if (equip_info) {
                    dic[equip_info.equip_type] = equip_info
                }
            }
            wear_unreal_dic_ = dic
        }

        this.UpdateEquips = () => {
            let wear_unreal_list = goods_model.wear_unreal_list
            let item
            for (let i = 0; i < local_UnrealModel.equip_count; i++) {
                item = equip_list_[i]

                item.SetData(wear_unreal_list[i])
            }
        }

        //is_upstage是否是进阶
        this.FormatAttr = (base_attrlist, stren_list, equip_extra_attr, is_upstage) => {
            let list = []
            let stren_str
            let pro
            let attr_config = Config.PRELOAD_CLIENT_CONFIG.ConfigItemAttr

            if (base_attrlist && Array.isArray(base_attrlist)) {
                base_attrlist.forEach((val, idx, array) => {
                    stren_str = 0
                    if (stren_list && Array.isArray(stren_list)) {
                        for (let i = 0; i < stren_list.length; i++) {
                            pro = stren_list[i]
                            if (pro && pro[0] == val[0] && pro[1] > 0) {
                                stren_str = local_Number(pro[1])
                                break
                            }
                        }
                    }
                    let desc = local_WordManager.GetProperties(val[0])
                    let kind = attr_config[val[0]] && attr_config[val[0]].kind || 1
                    list.push({
                        attr_id: Number(val[0]),
                        desc: desc,
                        value: local_Number(val[1]) + stren_str,
                        kind: Number(kind),
                        add: 1
                    })
                })
            }
            if (equip_extra_attr && equip_extra_attr.length > 0) {
                for (let i = 0; i < equip_extra_attr.length; i++) {
                    let vo = equip_extra_attr[i]
                    let pro = local_WordManager.GetProperties(vo.attr_id)
                    let value = local_WordManager.ConvertToPercentValue(vo.attr_id, vo.attr_val)
                    if (vo.type_id == 1) {
                        let level = role_mgr.mainRoleInfo.level
                        value = Math.floor(level / vo.plus_interval) * vo.plus_unit
                        pro = pro.replace("{0}", vo.plus_interval)
                    }
                    let kind = attr_config[vo.attr_id] && attr_config[vo.attr_id].kind || 1
                    let find = false
                    for (let tmp of list) {
                        if (tmp.attr_id == Number(vo.attr_id)) {
                            find = true
                            tmp.value = Number(tmp.value) + value
                            break
                        }
                    }
                    if (!find) {
                        list.push({
                            attr_id: Number(vo.attr_id),
                            desc: pro,
                            value: value,
                            kind: Number(kind),
                            add: is_upstage ? 1 : 0
                        })
                    }
                }
            }
            let sort_fun = (a, b) => {
                if (a.kind == b.kind) {
                    return a.attr_id - b.attr_id
                } else {
                    return b.kind - a.kind
                }
            }
            list.sort(sort_fun)

            return list
        }

        this.UpdateNowAttr = (base_attrlist, stren_list, equip_extra_attr) => {
            let list = this.FormatAttr(base_attrlist, stren_list, equip_extra_attr, false)

            if (!now_attr_list_)
                now_attr_list_ = []

            if (!attr_cache_) {
                attr_cache_ = list
            }
            else {
                let effect_list = []
                for (let key in list) {
                    let vo = list[key]
                    let cache_vo = attr_cache_[key]
                    if (vo && cache_vo && vo.value > cache_vo.value) {
                        effect_list.push(key)
                    }
                }
                for (let index of effect_list) {
                    let item = now_attr_list_[index]
                    if (item && item.is_loaded) {
                        item.StartAction()
                    }
                }
                attr_cache_ = list
            }

            for (let i = list.length; i < now_attr_list_.length; i++) {
                now_attr_list_[i].SetVisible(false)
            }
            for (let index in list) {
                let item = now_attr_list_[index]
                if (!item) {
                    item = new UnrealNextAttrItem(this._gp_attr)
                    now_attr_list_[index] = item
                    item.Load()
                }
                item.SetData(list[index])
                item.SetVisible(true)
            }

        }
    }

    private ShowGiftIcon() {
        let bool: boolean = Boolean(PushGiftModel.GetInstance().GetGiftList(EnumPushGiftType.eLingShi));
        if (bool) {
            if (!this.giftItem) {
                this.giftItem = new GiftPushIcon(this.giftIcon);
                this.giftItem.Load();
            }
            this.giftItem.ExcuteCallback(() => {
                this.giftItem.SetDate(PushGiftModel.ICON_TYPE, EnumPushGiftType.eLingShi);
            });

        }
        this.giftIcon.visible = bool;
    }

    _img_equip_bg: Laya.Image
    _img_attr_bg: Laya.Image
    _Group2: Laya.Box
    img1: Laya.Image
    _Group1: Laya.HBox
    img2: Laya.Image
    _lb_sten_lv: Laya.Label
    _gp_equips: Laya.Box
    _gp_select_equip: Laya.Box
    _Image3: Laya.Image
    _Scroller1: Laya.Panel
    Content: Laya.Box
    _gp_attr: Laya.VBox
    _lb_next_attr: Laya.HTMLDivElement
    _img_lv_max: Laya.Image
    _lb_tips: Laya.HTMLDivElement
    _lb_un_stren: Laya.Label
    _gp_cost: Laya.Box
    _lb_cost_tips: Laya.Label
    _gp_cost_award: Laya.HBox
    _gp_level_up: Laya.Box
    img5: Laya.Image
    _lb_level_up: Laya.Label
    _img_stren_red: Laya.Image
    _gp_effect: Laya.Box
    _gp_next_tips: Laya.Box
    _Image333: Laya.Image
    _lb_next_tips: Laya.Label
    _Group4: Laya.Box
    _Image31: Laya.Image
    _Label3: Laya.Label
    giftIcon: Laya.Box
    public GetComponents() {
        [
            this._img_equip_bg,
            this._img_attr_bg,
            this._Group2,
            this.img1,
            this._Group1,
            this.img2,
            this._lb_sten_lv,
            this._gp_equips,
            this._gp_select_equip,
            this._Image3,
            this._Scroller1,
            this.Content,
            this._gp_attr,
            this._lb_next_attr,
            this._img_lv_max,
            this._lb_tips,
            this._lb_un_stren,
            this._gp_cost,
            this._lb_cost_tips,
            this._gp_cost_award,
            this._gp_level_up,
            this.img5,
            this._lb_level_up,
            this._img_stren_red,
            this._gp_effect,
            this._gp_next_tips,
            this._Image333,
            this._lb_next_tips,
            this._Group4,
            this._Image31,
            this._Label3,
            this.giftIcon,
        ]
            = this.GetChildrenByNames([

                "_img_equip_bg",
                "_img_attr_bg",
                "_Group2",
                "img1",
                "_Group1",
                "img2",
                "_lb_sten_lv",
                "_gp_equips",
                "_gp_select_equip",
                "_Image3",
                "_Scroller1",
                "Content",
                "_gp_attr",
                "_lb_next_attr",
                "_img_lv_max",
                "_lb_tips",
                "_lb_un_stren",
                "_gp_cost",
                "_lb_cost_tips",
                "_gp_cost_award",
                "_gp_level_up",
                "img5",
                "_lb_level_up",
                "_img_stren_red",
                "_gp_effect",
                "_gp_next_tips",
                "_Image333",
                "_lb_next_tips",
                "_Group4",
                "_Image31",
                "_Label3",
                "giftIcon",
            ])
    }
}

window["UnrealStrengthenView"] = UnrealStrengthenView