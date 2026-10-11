import { JsxFlags } from "../../node_modules/typescript/lib/typescript"
import { Alert, Alert_Type } from "../alert/Alert"
import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { FightingShowSmallItem } from "../common/FightingShowSmallItem"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { WordManager } from "../common/WordManager"
import { FashionModel } from "../commonModel/FashionModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { OutWardBaseModel } from "../commonModel/OutWardBaseModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SkillManager } from "../skill/SkillManager"
import { SkillVo } from "../skill/SkillVo"
import { Message } from "../sysInfo/SysInfoController"
import { ColorType, ColorUtil } from "../util/ColorUtil"
import { GameResPath } from "../util/GameResPath"
import { HtmlColorTxt, Util } from "../util/Util"
import { Vector3 } from "../util/Vector3"
import { FashionSuitGoodsItem } from "./FashionSuitGoodsItem"
import { FashionSuitTabItem } from "./FashionSuitTabItem"


let local_FashionModel = FashionModel
let local_OutWardBaseModel = OutWardBaseModel
export class FashionSuitView extends BaseItem1 {

    fight_item: FightingShowSmallItem
    model: FashionModel = local_FashionModel.GetInstance()
    outward_model: OutWardBaseModel = local_OutWardBaseModel.GetInstance()
    up_cost_item: BaseAwardItem

    tab_data_list
    tab_item_list
    default_index = 0
    goods_item_dic
    cur_index
    cur_suit_id
    show_suit_id
    cur_suit_cfg
    up_show_tips
    public constructor(parent?) {
        super(parent)
        this.base_file = "fashion"
        this.layout_file = "FashionSuitView"
        this.load_callback = () => {
            this.LoadSuccess()
        }
    }

    public LoadSuccess = () => {
        //resource/game/fashion/texture/ui_role_66.png
        ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("fashion", "ui_role_66"))

        this.fight_item = new FightingShowSmallItem(this._box_fighting)
        this.fight_item.Load()
        this.fight_item.IsCenter(true, false)

        this._panel_tab.hScrollBarSkin = ""

        this._html_now_attr0.style.color = "#663915"
        this._html_now_attr0.style.fontSize = 20
        this._html_now_attr0.style.wordWrap = false

        this._html_now_attr1.style.color = "#663915"
        this._html_now_attr1.style.fontSize = 20
        this._html_now_attr1.style.wordWrap = false

        this._html_now_attr2.style.color = "#663915"
        this._html_now_attr2.style.fontSize = 20
        this._html_now_attr2.style.wordWrap = false

        this._html_now_attr3.style.color = "#663915"
        this._html_now_attr3.style.fontSize = 20
        this._html_now_attr3.style.wordWrap = false

        this._html_skill_desc.style.color = "#663915"
        this._html_skill_desc.style.fontSize = 20
        this._html_skill_desc.style.wordWrap = false

        this._html_up_cond.style.color = "#663915"
        this._html_up_cond.style.fontSize = 20
        this._html_up_cond.style.wordWrap = false

        this._html_goods_count.style.color = "#663915"
        this._html_goods_count.style.fontSize = 20
        this._html_goods_count.style.wordWrap = false


        this._html_high_attr.style.color = "#663915"
        this._html_high_attr.style.fontSize = 20
        this._html_high_attr.style.wordWrap = false

        this._html_per_attr.style.color = "#663915"
        this._html_per_attr.style.fontSize = 20
        this._html_per_attr.style.wordWrap = false


        let config_fashion_suit = Config.PRELOAD_SERVER_CONFIG.config_fashion_suit
        if (!config_fashion_suit)
            return

        this.InitEvent()
        this.InitTab()
        this.SwitchTab(this.default_index)

    }

    public ChangeCallFunc = () => {
        //每次点击界面请求一次为了刷新战力
        this.model.Fire(local_FashionModel.SCMD_REQUEST, 41313)
    }

    public InitTab() {
        this.tab_data_list = []
        let config_fashion_suit = Config.PRELOAD_SERVER_CONFIG.config_fashion_suit
        for (let i in config_fashion_suit) {
            this.tab_data_list.push(config_fashion_suit[i])
        }
        this.tab_data_list.sort(function (a, b) {
            return a.id - b.id
        })

        if (!this.tab_item_list) {
            this.tab_item_list = []
        }
        var item: FashionSuitTabItem
        for (let i in this.tab_data_list) {
            item = this.tab_item_list[i]
            if (!item) {
                item = new FashionSuitTabItem(this._panel_tab)
                item.Load()
                this.tab_item_list[i] = item
            }
            item.SetData(Number(i), this.tab_data_list[i])
            item.SetPosition(Number(i) * 116, 0)
        }
    }

    public SwitchTab(index) {
        if (this.cur_index == index)
            return

        let item: FashionSuitTabItem = this.tab_item_list[this.cur_index]
        if (item) {
            item.SetSelect(false)
        }

        item = this.tab_item_list[index]
        if (item) {
            item.SetSelect(true)
        }
        this.cur_index = index
        this.cur_suit_cfg = this.tab_data_list[this.cur_index]
        this.cur_suit_id = this.cur_suit_cfg.id
        this.UpdateView()
    }

    public UpdateView() {
        let cur_suit_cfg = this.cur_suit_cfg
        let suit_id = this.cur_suit_id

        this._lb_name.text = cur_suit_cfg.name

        if (!this.goods_item_dic) {
            this.goods_item_dic = {}
        }
        let condition = this.model.GetSuitCond(suit_id)
        for (let vo of condition) {
            /**
             * vo
             * {1,{1,1,12010030}}
             * {格子位置,{类型,子类型,id}}
             * 类型: 1 时装模块  子类型: 1 时装 3 头饰   id:对应时装id
             * 类型: 2 培养物的幻化模块  子类型: 1:坐骑 2：精灵 3: 翅膀 4:圣器 5：神兵 12：背饰  id:对应幻化id
             */
            var item = this.goods_item_dic[vo[0]]
            if (!item) {
                item = new FashionSuitGoodsItem(this._box_item)
                item.Load()
                this.goods_item_dic[vo[0]] = item
            }
            item.SetData(vo[1])
            item.SetPosition((Number(vo[0]) - 1) * 110, 0)
        }

        this.CreateModel()

        let suit_data = this.model.GetSuitData(suit_id)
        if (suit_data) {
            this._lb_stage.text = `${suit_data.lv}阶`
            this.fight_item.Updatefighting(suit_data.power)
            if (suit_data.next_power == 0) {
                this.fight_item.UpdatefightingUp(0);
                this.fight_item.IsCenter(true, false);
            }
            else {
                this.fight_item.UpdatefightingUp(suit_data.next_power - suit_data.power);
                this.fight_item.SetPowerOffset(this.fight_item.display_obj.width / 4);
            }

            let active_state = this.model.GetSuitActiveState(suit_id)
            if (active_state) {
                this._img_active_state.visible = false
                this._lb_stage.text = `${suit_data.lv}阶`
                this._box_active.visible = true
                this._box_not_active.visible = false
                this.UpdateActiveView()

            }
            else {
                this._img_active_state.visible = true
                this._box_not_active.visible = true
                this._box_active.visible = false
                this.UpdateNotActiveView()
            }
            this.UpdateWearBtnState()
        }
        else {
            this._img_change.visible = false
            this._img_changed.visible = false
            this._lb_stage.text = `0阶`
            this.fight_item.Updatefighting(0)
            this._box_active.visible = false
            this._box_not_active.visible = false
        }
    }

    public UpdateActiveView() {
        let suit_data = this.model.GetSuitData(this.cur_suit_id)
        let key = `${this.cur_suit_id}@${suit_data.lv}`
        let cfg = Config.PRELOAD_SERVER_CONFIG.config_fashion_suit_star[key]
        let next_key = `${this.cur_suit_id}@${suit_data.lv + 1}`
        let next_cfg = Config.PRELOAD_SERVER_CONFIG.config_fashion_suit_star[next_key]
        if (cfg) {
            let attr
            if (suit_data.lv == 1) {
                //1阶段取激活4件套的属性
                let attr_cfg = this.model.GetSuitAttr(this.cur_suit_id)
                for (let v of attr_cfg) {
                    if (v[0] == local_FashionModel.SuitPerfectActiveCount) {
                        attr = v[1]
                    }
                }
            }
            else {
                attr = this.model.GetSuitStarAttr(this.cur_suit_id, suit_data.lv)
            }

            let next_attr = this.model.GetSuitStarAttr(this.cur_suit_id, suit_data.lv + 1)
            for (let i in attr) {
                var vo = attr[i]
                let str = ""
                str += `${WordManager.GetProperties(vo[0])}`
                str += `&nbsp;${HtmlColorTxt(`+${WordManager.ConvertToPercentValue(vo[0], vo[1])}`, "'#d15e00'")}`
                if (next_attr) {
                    var next_vo = next_attr[i]
                    str += `&nbsp;<img src='${GameResPath.GetIcon("fashion", "com_uparrow_02")}'></img>`
                    str += `&nbsp;${HtmlColorTxt(next_vo[1] - vo[1], ColorUtil.GetColorDark(ColorType.GREEN))}`
                }
                this[`_html_now_attr${i}`].innerHTML = str
            }

            let skill
            if (suit_data.lv == 1) {
                //1阶段取激活的技能
                skill = this.model.GetSuitSkill(this.cur_suit_id)
            }
            else {
                skill = this.model.GetSuitStarSkill(this.cur_suit_id, suit_data.lv)
            }
            //只有一个技能
            let skill_id = skill[0][0]
            let skill_lv = skill[0][1]
            let skill_vo: SkillVo = SkillManager.GetInstance().getSkill(skill_id)
            let skill_str = skill_vo.getDesc(skill_lv, false)
            let skill_attr = skill_vo.GetBaseAttr(skill_lv)
            let skill_attr_value = skill_attr[0][2] / 100
            if (next_cfg) {
                skill_str += `&nbsp;<img src='${GameResPath.GetIcon("fashion", "com_uparrow_02")}'></img>`
                let next_skill = this.model.GetSuitStarSkill(this.cur_suit_id, suit_data.lv + 1)
                let next_skill_id = next_skill[0][0]
                let next_skill_lv = next_skill[0][1]
                let next_skill_vo: SkillVo = SkillManager.GetInstance().getSkill(next_skill_id)
                let next_skill_attr = next_skill_vo.GetBaseAttr(next_skill_lv)
                let next_skill_attr_value = next_skill_attr[0][2] / 100
                skill_str += `&nbsp;${HtmlColorTxt(`${next_skill_attr_value - skill_attr_value}%`, ColorUtil.GetColorDark(ColorType.GREEN))}`
            }

            this._html_skill_desc.innerHTML = skill_str


            if (next_cfg) {
                this._img_up.visible = true
                this._html_up_cond.visible = true
                this._img_max_stage.visible = false
                this.UpdateCond()
            }
            else {
                this._img_max_stage.visible = true
                this._html_up_cond.visible = false
                this._img_up.visible = false
                this._html_goods_count.visible = false
                this._box_goods_con.visible = false
            }
        }
    }

    public UpdateCond() {
        let cond_bool = this.UpdateStageCond()
        let cost_bool = this.UpdateCost()

        this.up_show_tips = null
        if (!cond_bool) {
            this._img_up.gray = true
            this.up_show_tips = "条件不足"
            this._img_up.mouseEnabled = false
            this._img_up_red.visible = false
        } else {
            this._img_up.gray = false
            this._img_up.mouseEnabled = true
            if (!cost_bool) {
                this.up_show_tips = "材料不足"
                this._img_up_red.visible = false
            }
            else {
                this._img_up_red.visible = true
            }
        }
    }

    public UpdateStageCond() {
        let suit_data = this.model.GetSuitData(this.cur_suit_id)
        let next_key = `${this.cur_suit_id}@${suit_data.lv + 1}`
        let bool = false
        let next_cfg = Config.PRELOAD_SERVER_CONFIG.config_fashion_suit_star[next_key]
        if (next_cfg) {
            //条件要选下一阶段的
            let cond_str = next_cfg.desc
            let cond = this.model.GetSuitStarCond(this.cur_suit_id, suit_data.lv + 1)
            let total_count = cond.length
            let now_count = 0
            for (let vo of cond) {
                var count = this.model.GetSuitPosLv(this.cur_suit_id, vo[0])
                if (count >= vo[1]) {
                    now_count++
                }
            }
            bool = now_count >= total_count
            let color = bool ? ColorUtil.GetColorDark(ColorType.GREEN) : ColorUtil.GetColorDark(ColorType.RED)
            cond_str += HtmlColorTxt(`(${now_count}/${total_count})`, color)
            this._html_up_cond.innerHTML = cond_str
        }
        return bool
    }

    public UpdateCost() {
        let suit_data = this.model.GetSuitData(this.cur_suit_id)
        let next_key = `${this.cur_suit_id}@${suit_data.lv + 1}`
        let next_cfg = Config.PRELOAD_SERVER_CONFIG.config_fashion_suit_star[next_key]
        let bool = false
        if (next_cfg) {
            //条件要选下一阶段的
            let cost = this.model.GetSuitStarCost(this.cur_suit_id, suit_data.lv + 1)
            cost = cost[0]
            if (cost) {
                this._html_goods_count.visible = true
                this._box_goods_con.visible = true

                if (!this.up_cost_item) {
                    this.up_cost_item = new BaseAwardItem(this._box_goods_con)
                    this.up_cost_item.Load()
                    this.up_cost_item.SetItemSize(34)
                }
                let [goods_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(cost[0], cost[1])
                let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(goods_id)
                this.up_cost_item.SetData(basic.type_id, 0, lock)

                let my_count = GoodsModel.GetInstance().GetBagGoodsNum(goods_id)
                bool = my_count >= cost[2]
                let color = bool ? ColorUtil.GetColorDark(ColorType.GREEN, false) : ColorUtil.GetColorDark(ColorType.RED, false)
                this._html_goods_count.style.color = color
                this._html_goods_count.innerHTML = `${my_count}/${cost[2]}`
            }
            else {
                bool = true
                this._html_goods_count.visible = false
                this._box_goods_con.visible = false
            }
        }
        return bool
    }

    public UpdateNotActiveView() {
        let suit_data = this.model.GetSuitData(this.cur_suit_id)

        let attr = this.model.GetSuitAttr(this.cur_suit_id)
        let high_attr, per_attr
        for (let v of attr) {
            if (v[0] == local_FashionModel.SuitHighActiveCount) {
                high_attr = v[1]
            } else if (v[0] == local_FashionModel.SuitPerfectActiveCount) {
                per_attr = v[1]
            }
        }

        this._lb_high_value.text = `(${suit_data.conform_num}/${local_FashionModel.SuitHighActiveCount})`
        this._lb_high_value.color = suit_data.conform_num >= local_FashionModel.SuitHighActiveCount ? ColorUtil.GetColorDark(ColorType.GREEN, false) : ColorUtil.GetColorDark(ColorType.RED, false)
        this._html_high_attr.innerHTML = this.GetAttrDesc(high_attr)
        if (suit_data.active_num >= local_FashionModel.SuitHighActiveCount) {
            this._img_high_active.visible = false
            this._img_high_active_state.visible = true
            this._img_high_active_red.visible = false
        }
        else {
            this._img_high_active.visible = true
            this._img_high_active_state.visible = false
            this._img_high_active_red.visible = suit_data.conform_num >= local_FashionModel.SuitHighActiveCount
        }


        this._lb_per_value.text = `(${suit_data.conform_num}/${local_FashionModel.SuitPerfectActiveCount})`
        this._lb_per_value.color = suit_data.conform_num >= local_FashionModel.SuitPerfectActiveCount ? ColorUtil.GetColorDark(ColorType.GREEN, false) : ColorUtil.GetColorDark(ColorType.RED, false)
        this._html_per_attr.innerHTML = this.GetAttrDesc(per_attr)
        if (suit_data.active_num >= local_FashionModel.SuitPerfectActiveCount) {
            this._img_per_active.visible = false
            this._img_per_active_state.visible = true
            this._img_per_active_red.visible = false
        }
        else {
            this._img_per_active.visible = true
            this._img_per_active_state.visible = false
            this._img_per_active_red.visible = suit_data.conform_num >= local_FashionModel.SuitPerfectActiveCount
        }
    }

    public GetAttrDesc(attr_list) {
        let str = ""
        for (let vo of attr_list) {
            str += `${WordManager.GetProperties(vo[0])}&nbsp;`
            str += HtmlColorTxt(`+${WordManager.ConvertToPercentValue(vo[0], vo[1])}`, "'#d15e00'")
            str += "<br>"
        }
        return str
    }

    public CreateModel() {
        if (this.cur_suit_id == this.show_suit_id) return
        this.show_suit_id = this.cur_suit_id
        this._box_sprite.visible = false
        this._box_shengqi.visible = false
        this._box_horse.visible = false
        let role_vo = RoleManager.GetInstance().GetMainRoleVo()

        let model_id, head_id, weapon_model_id, wing_id, back_ornament_id
        let texture_id = 0, head_texture_id = 0

        let condition = this.model.GetSuitCond(this.cur_suit_id)
        for (let vo of condition) {
            var v = vo[1]
            var type = v[0]
            var sub_type = v[1]
            var id = v[2]
            /**
             * 类型: 1 时装模块  子类型: 1 时装 3 头饰   id:对应时装id
             * 类型: 2 培养物的幻化模块  子类型: 1:坐骑 2：精灵 3: 翅膀 4:圣器 5：神兵 12：背饰  id:对应幻化id
             */
            //时装
            if (type == 1) {
                let key = `${sub_type}@${id}@${role_vo.career}@${role_vo.sex}@0`
                let cfg = Config.PRELOAD_SERVER_CONFIG.config_fashion_model[key]
                //衣服
                if (sub_type == 1) {
                    model_id = cfg.model_id
                    texture_id = 0
                    //头发
                } else if (sub_type == 3) {
                    head_id = cfg.model_id
                    head_texture_id = 0
                }
            } else if (type == 2) {

                let key = `${sub_type}@${id}@${role_vo.career}`
                let cfg = Config.PRELOAD_SERVER_CONFIG.config_mount_figure[key]
                //坐骑
                if (sub_type == 1) {
                    this.CreateHorse(cfg.ride_figure)
                    //精灵
                } else if (sub_type == 2) {
                    this.CreateSprite(cfg.ride_figure)
                    //翅膀
                } else if (sub_type == 3) {
                    wing_id = cfg.ride_figure
                    //圣器
                } else if (sub_type == 4) {
                    this.CreateShengqi(cfg.ride_figure)
                    //神兵
                } else if (sub_type == 5) {
                    weapon_model_id = cfg.ride_figure
                    //背饰   
                } else if (sub_type == 12) {
                    weapon_model_id = cfg.ride_figure
                }
            }
        }

        let data = {
            type: UI_MODEL_TYPE.ROLE,
            career: role_vo.career,
            sex: role_vo.sex,
            scale: 0.85,
            position: new Vector3(0, 1.2, 0),
            clothe_res_id: model_id,
            fashion_model_id: model_id,
            texture_id: texture_id,
            weapon_res_id: weapon_model_id,
            weapon_clothe_id: 0,
            wing_id: wing_id,
            head_wear_id: head_id,
            head_clothe_id: head_texture_id,
            back_ornament_id: back_ornament_id,
            can_rotate: true,
        }
        ResManager.GetInstance().SetRoleModel(this, this._box_model, data)
    }

    public CreateHorse(id) {
        let ratio = 1
        if (this.cur_suit_cfg) {
            ratio = this.cur_suit_cfg.ratio
        }
        this._box_horse.visible = true
        let scale = 0.5 * ratio,
            position = new Vector3(-4, 1.6, 0),
            rotate = 160
        let data = {
            clothe_res_id: id,
            type: UI_MODEL_TYPE.HORSE,
            scale: scale,
            position: position,
            rotate: rotate,
        }
        ResManager.GetInstance().SetRoleModel(this, this._box_horse, data)
    }

    public CreateSprite(id) {
        this._box_sprite.visible = true
        let scale = 0.8,
            position = new Vector3(3.5, 1, 0),
            rotate
        let data = {
            clothe_res_id: id,
            type: UI_MODEL_TYPE.SPRITE,
            scale: scale,
            position: position,
            rotate: rotate,
        }
        ResManager.GetInstance().SetRoleModel(this, this._box_sprite, data)
    }

    public CreateShengqi(id) {
        this._box_shengqi.visible = true
        let scale,
            position = new Vector3(3.5, 6, 0),
            rotate
        let data = {
            clothe_res_id: id,
            type: UI_MODEL_TYPE.ARTIFACT,
            scale: scale,
            position: position,
            rotate: rotate,
        }
        ResManager.GetInstance().SetRoleModel(this, this._box_shengqi, data)
    }

    public InitEvent() {
        this.BindEvent(this.model, local_FashionModel.SELECT_SUIT, (index) => {
            this.SwitchTab(index)
        })

        this.BindEvent(this.model, local_FashionModel.UPDATE_SUIT_DATA, (suit_id) => {
            if (suit_id) {
                if (this.cur_suit_cfg && this.cur_suit_id == suit_id) {
                    this.UpdateView()
                }
            }
            else {
                this.UpdateView()
            }
        })

        Util.AddClickEvent(this._img_high_active, () => {
            if (this.cur_suit_id)
                this.model.Fire(local_FashionModel.SCMD_REQUEST, 41314, this.cur_suit_id, local_FashionModel.SuitHighActiveCount)
        }, this, true)

        Util.AddClickEvent(this._img_per_active, () => {
            if (this.cur_suit_id)
                this.model.Fire(local_FashionModel.SCMD_REQUEST, 41314, this.cur_suit_id, local_FashionModel.SuitPerfectActiveCount)
        }, this, true)


        Util.AddClickEvent(this._img_up, () => {
            if (this.cur_suit_id) {
                if (this.up_show_tips) {
                    Message.show(this.up_show_tips)
                    return
                }
                this.model.Fire(local_FashionModel.SCMD_REQUEST, 41315, this.cur_suit_id)
            }
        }, this, true)


        let change_func = () => {
            if (this.use_delete_method) return
            if (this.cur_suit_id) {
                let cond = this.model.GetSuitCond(this.cur_suit_id)
                let role_vo = RoleManager.GetInstance().GetMainRoleVo()
                for (let vo of cond) {
                    /**
                     * vo
                     * {1,{1,1,12010030}}
                     * {格子位置,{类型,子类型,id}}
                     * 类型: 1 时装模块  子类型: 1 时装 3 头饰   id:对应时装id
                     * 类型: 2 培养物的幻化模块  子类型: 1:坐骑 2：精灵 3: 翅膀 4:圣器 5：神兵 12：背饰  id:对应幻化id
                     */
                    var v = vo[1]
                    var type = v[0]
                    var sub_type = v[1]
                    var id = v[2]

                    //时装
                    if (type == 1) {
                        let wear_fashion_id = this.model.fashion_info_dic[sub_type].wear_fashion_id
                        if (wear_fashion_id != id) {
                            this.model.Fire(local_FashionModel.SCMD_REQUEST, 41302, sub_type, id, 0)
                        }
                    } else if (type == 2) {

                        let illusion_id = this.outward_model.outward_illu_data_list[sub_type].illusion_id
                        if (illusion_id != id) {
                            this.outward_model.Fire(local_OutWardBaseModel.ILLUSION_OUTWARD, sub_type, 2, id, 0)
                        }
                    }

                }
            }
        }

        Util.AddClickEvent(this._img_change, () => {
            Alert.Show("是否穿戴套装?", Alert_Type.Two, () => {
                change_func()
            })
        }, this, true)


        this.BindEvent(this.model, local_FashionModel.UPDATEVIEW, (pos_id) => {
            if (this.model.GetSuitActiveState(this.cur_suit_id)) {
                this.UpdateCond()
                this.UpdateWearBtnState()
            }
        })


        this.BindEvent(this.outward_model, local_OutWardBaseModel.UPDATE_OUTWARD_ILLUSION_VIEW, (data) => {
            if (this.model.GetSuitActiveState(this.cur_suit_id)) {
                this.UpdateCond()
            }
        })

        this.BindEvent(this.outward_model, local_OutWardBaseModel.ILLUSION_OUTWARD_SUCCESS, (data) => {
            if (this.model.GetSuitActiveState(this.cur_suit_id)) {
                this.UpdateWearBtnState()
            }
        })

        this.BindEvent(GoodsModel.GetInstance(), GoodsModel.UPDATE_GOODS_NUM, (goods_list) => {
            if (this.use_delete_method) {
                return
            }
            if (this.model.GetSuitActiveState(this.cur_suit_id)) {
                this.UpdateCond()
            }
        })
    }

    /**更新穿戴状态 */
    public UpdateWearBtnState(){
        if(!this.cur_suit_id){
            return 
        }
        if(!this.model.GetSuitActiveState(this.cur_suit_id)){
            this._img_change.visible = false
            this._img_changed.visible = false
            return
        }

        let all_wear = true
        
        let cond = this.model.GetSuitCond(this.cur_suit_id)
        for (let vo of cond) {
            /**
             * vo
             * {1,{1,1,12010030}}
             * {格子位置,{类型,子类型,id}}
             * 类型: 1 时装模块  子类型: 1 时装 3 头饰   id:对应时装id
             * 类型: 2 培养物的幻化模块  子类型: 1:坐骑 2：精灵 3: 翅膀 4:圣器 5：神兵 12：背饰  id:对应幻化id
             */
            var v = vo[1]
            var type = v[0]
            var sub_type = v[1]
            var id = v[2]

            //时装
            if (type == 1) {
                let wear_fashion_id = this.model.fashion_info_dic[sub_type].wear_fashion_id
                if (wear_fashion_id != id) {
                    all_wear = false
                    break
                }
            } else if (type == 2) {

                let illusion_id = this.outward_model.outward_illu_data_list[sub_type].illusion_id
                if (illusion_id != id) {
                    all_wear = false
                    break
                }
            }
        }

        this._img_change.visible = !all_wear
        this._img_changed.visible = all_wear
    }

    public DeleteMe() {
        if (this.fight_item) {
            this.fight_item.DeleteMe()
            this.fight_item = null
        }

        if (this.up_cost_item) {
            this.up_cost_item.DeleteMe()
            this.up_cost_item = null
        }

        if (this.tab_item_list) {
            for (let item of this.tab_item_list) {
                item.DeleteMe()
            }
            this.tab_item_list = undefined
        }
        if (this.goods_item_dic) {
            for (let i in this.goods_item_dic) {
                this.goods_item_dic[i].DeleteMe()
            }
            this.goods_item_dic = undefined
        }
        this.tab_data_list = undefined
        this.tab_data_list = undefined
        this.cur_suit_cfg = undefined
        this.show_suit_id = undefined
        this.cur_suit_id = undefined
        super.DeleteMe()
    }

    _box_horse: Laya.Box
    _box_sprite: Laya.Box
    _box_shengqi: Laya.Box
    _box_model: Laya.Box
    _img_bg: Laya.Image
    _img_active_state: Laya.Image
    _img_left: Laya.Image
    _img_right: Laya.Image
    _img_change: Laya.Image
    _img_changed: Laya.Image
    _lb_name: Laya.Label
    _lb_stage: Laya.Label
    _box_not_active: Laya.Box
    _img_high_active_state: Laya.Image
    _img_per_active_state: Laya.Image
    _img_high_active: Laya.Image
    _img_high_active_red: Laya.Image
    _img_per_active: Laya.Image
    _img_per_active_red: Laya.Image
    _lb_high_value: Laya.Label
    _lb_per_value: Laya.Label
    _panel_high_attr: Laya.Panel
    _html_high_attr: Laya.HTMLDivElement
    _panel_per_attr: Laya.Panel
    _html_per_attr: Laya.HTMLDivElement
    _box_active: Laya.Box
    _html_now_attr0: Laya.HTMLDivElement
    _html_now_attr1: Laya.HTMLDivElement
    _html_now_attr2: Laya.HTMLDivElement
    _html_now_attr3: Laya.HTMLDivElement
    _html_skill_desc: Laya.HTMLDivElement
    _html_up_cond: Laya.HTMLDivElement
    _html_goods_count: Laya.HTMLDivElement
    _box_goods_con: Laya.Box
    _img_up: Laya.Image
    _img_up_red: Laya.Image
    _img_max_stage: Laya.Image
    _box_item: Laya.Box
    _box_fighting: Laya.Box
    _panel_tab: Laya.Panel
    public GetComponents() {
        [
            this._box_horse,
            this._box_sprite,
            this._box_shengqi,
            this._box_model,
            this._img_bg,
            this._img_active_state,
            this._img_left,
            this._img_right,
            this._img_change,
            this._img_changed,
            this._lb_name,
            this._lb_stage,
            this._box_not_active,
            this._img_high_active_state,
            this._img_per_active_state,
            this._img_high_active,
            this._img_high_active_red,
            this._img_per_active,
            this._img_per_active_red,
            this._lb_high_value,
            this._lb_per_value,
            this._panel_high_attr,
            this._html_high_attr,
            this._panel_per_attr,
            this._html_per_attr,
            this._box_active,
            this._html_now_attr0,
            this._html_now_attr1,
            this._html_now_attr2,
            this._html_now_attr3,
            this._html_skill_desc,
            this._html_up_cond,
            this._html_goods_count,
            this._box_goods_con,
            this._img_up,
            this._img_up_red,
            this._img_max_stage,
            this._box_item,
            this._box_fighting,
            this._panel_tab,
        ]
            = this.GetChildrenByNames([

                "_box_horse",
                "_box_sprite",
                "_box_shengqi",
                "_box_model",
                "_img_bg",
                "_img_active_state",
                "_img_left",
                "_img_right",
                "_img_change",
                "_img_changed",
                "_lb_name",
                "_lb_stage",
                "_box_not_active",
                "_img_high_active_state",
                "_img_per_active_state",
                "_img_high_active",
                "_img_high_active_red",
                "_img_per_active",
                "_img_per_active_red",
                "_lb_high_value",
                "_lb_per_value",
                "_panel_high_attr",
                "_html_high_attr",
                "_panel_per_attr",
                "_html_per_attr",
                "_box_active",
                "_html_now_attr0",
                "_html_now_attr1",
                "_html_now_attr2",
                "_html_now_attr3",
                "_html_skill_desc",
                "_html_up_cond",
                "_html_goods_count",
                "_box_goods_con",
                "_img_up",
                "_img_up_red",
                "_img_max_stage",
                "_box_item",
                "_box_fighting",
                "_panel_tab",
            ])
    }
}
window["FashionSuitView"] = FashionSuitView