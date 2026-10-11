import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { Util } from "../util/Util"
import { Vector3 } from "../util/Vector3"
import { FigureProtoVo } from "../common/FigureProtoVo"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { ResManager } from "../common/ResManager"
import { RoleManager } from "../commonModel/RoleManager"
import { TaskTipType } from "../commonModel/TaskModel"
import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { SuitActivityModel } from "../commonModel/SuitActivityModel"
import { SuitActivityEquip } from "./SuitActivityEquip"
import { SuitActivityItem } from "./SuitActivityItem"
import { GameResPath } from "../util/GameResPath"
import { SkillManager } from "../skill/SkillManager"
import { TaskModel } from "../commonModel/TaskModel"

import "./SuitSkillView"
import "./SuitEquipGetView"
import { table } from "../common/table"

export class SuitActivityView extends BaseItem1 {
	effectType
	equip_list
	has_set_cover
	level_bind
	mainVo
	model
	model_curr_sorting_order
	//outlint
	propItemList
	suit_cfg
	suit_skill_id
	res_mgr
	cfg_suit_clt
	cfg_suit_proc
	show_desc_ids = []

	public constructor(parent?) {
		super(parent)
		this.base_file = "suitActivity"
		this.layout_file = "SuitActivityView"

		this.model = SuitActivityModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()
		this.cfg_suit_clt = Config.PRELOAD_SERVER_CONFIG.config_suit_clt

		this.load_callback = () => {
			this.cfg_suit_proc = Config.PRELOAD_SERVER_CONFIG.config_suit_clt_process
			this.LoadSuccess()
			this.InitEvent()
			this.CreateModel()
		}
	}

	public LoadSuccess() {
		if (!this.suit_cfg) {
			return
		}
		this.res_mgr.LoadFont(this, "fighting_font", this.fight_text, 20)
		this.res_mgr.SetImageSprite(this, this.titleImg, "suitActivity", "uisstz" + this.suit_cfg.suit_id)
		this.res_mgr.SetOutsideImageSprite(this, this.img_bg, GameResPath.GetIcon("suitActivity", "ui_sstz_010"))
		this.res_mgr.SetOutsideImageSprite(this, this.img_sche, "resource/game/suitActivity/texture/ui_sstz_009.png")
		this.res_mgr.SetOutsideImageSprite(this, this.img_fill, "resource/game/suitActivity/texture/ui_sstz_009a.png")

		this.SetEquipData()
		let suit_cfg = this.suit_cfg
		this.fight_text.text = suit_cfg.power_show
		this.SetSuitData(this.model.GetCurStage(suit_cfg.suit_id))
		this.red_img.visible = this.model.red_list[suit_cfg.suit_id]
		this.lb_ac.text = this.model.red_list[suit_cfg.suit_id] ? "激活" : "前往获取"
		this.ShowSuitActivityFinger()
	}

	public InitEvent() {
		let ClickFun = () => {
			if (this.red_img.visible) {
				if (this.suit_cfg) {
					// 前4套有自动激活处理
					let max_stage = this.model.GetCurentMaxStage(this.suit_cfg.suit_id)
					this.model.Fire(SuitActivityModel.ACTIVITY_SUIT, this.suit_cfg.suit_id, max_stage)
					GlobalEventSystem.Fire(EventName.HIDE_FINGER, this.ac_btn)
				}
			} else {
				let lv = RoleManager.GetInstance().GetMainRoleLevel()
				if (lv < 100) {
					SuitActivityModel.GetInstance().Fire(SuitActivityModel.CLOSE_SUIT_VIEW)
					TaskModel.GetInstance().DoTask()
				} else {
					let cfg = Config.PRELOAD_SERVER_CONFIG.config_key_value["11"]
					if (cfg && cfg.value) {
						let list = []
						let funs = JSON.parse(cfg.value)
						for (let j in funs) {
							let vo = funs[j]
							list.push([vo])
						}
						this.model.Fire(SuitActivityModel.OPEN_VIEW, "SuitEquipGetView", list)
					}
				}
			}
		}
		Util.AddClickEvent(this.ac_btn, ClickFun, this, true)

		this.BindEvent(this.model, SuitActivityModel.UPDATE_ONE_SUIT, (suit_vo?) => {
			if (this.suit_cfg && this.suit_cfg.suit_id == suit_vo.suit_id) {
				this.SetEquipData()
				this.SetSuitData(this.model.GetCurStage(suit_vo.suit_id))
				let item = this.propItemList[suit_vo.cur_stage / 2]
				if (item) {
					item.ShowEffect()
				}
				let use = this.model.useFashion && this.model.useFashion == this.suit_cfg.suit_id
				this.img_wear.visible = use
				this.AddUIEffect("ui_ZiTi_Jihuo", this.effectCon, null, 2, null, null, null, null, null, null, null, null, false)
				this.ShowSuitActivityFinger(true)
			}
		})

		this.BindEvent(this.model, SuitActivityModel.UPDATE_TAB_RED, (suit_id?, bool?) => {
			if (suit_id) {
				if (suit_id == this.suit_cfg.suit_id) {
					this.red_img.visible = bool
					this.lb_ac.text = bool ? "激活" : "前往获取"
				}
			}
		})

		this.BindEvent(this.model, SuitActivityModel.UPDATE_EQUIP, (data?) => {
			if (data && data.suit_id == this.suit_cfg.suit_id) {
				this.SetEquipData()
				this.SetSuitData(this.model.GetCurStage(data.suit_id))
				let use = this.model.useFashion && this.model.useFashion == this.suit_cfg.suit_id
				this.img_wear.visible = use
				if (this.equip_list[data.equip_type]) {
					this.equip_list[data.equip_type].Refresh()
				}
			}
		})

		this.BindEvent(this.model, SuitActivityModel.UPDATE_WEAR_FASHION, () => {
			let use = this.model.useFashion && this.model.useFashion == this.suit_cfg.suit_id
			this.img_wear.visible = use
		})

		Util.AddClickEvent(this.wearBtn, () => {
			let newStatus = (!this.model.useFashion || this.model.useFashion != this.suit_cfg.suit_id) && 1 || 0
			this.model.Fire(SuitActivityModel.WEAR_FASHION, this.suit_cfg.suit_id, newStatus)
		}, this, true)

		Util.AddClickEvent(this._img_skill, () => {
			if (this.suit_skill_id) {
				this.model.Fire(SuitActivityModel.OPEN_VIEW, "SuitSkillView", this.suit_cfg.suit_id)
			}
		}, this, true)
	}

	public SetEquipData() {
		let suit_cfg = this.suit_cfg
		//设置固定显示的
		if (this.equip_list == null) {
			this.equip_list = []
		}

		let equip_list = ErlangParser.GetInstance().Parse(suit_cfg.show_equip)
		let i = 1
		for (let _ in equip_list) {
			let vo = equip_list[_]
			let index = Number(vo[0]) - 1
			let item = this.equip_list[index]
			if (item == null) {
				item = new SuitActivityEquip(i % 2 == 1 && this.equip_con1 || this.equip_con2)
				item.Load()
			}
			this.equip_list[index] = item
			item.SetData(vo, suit_cfg.suit_id)
			//item.SetAnchoredPosition(0, - (Math.ceil(i / 2) - 1) * 130)
			i = i + 1
		}
	}

	//设置套装可以变化的数据
	public SetSuitData(stage?) {
		stage = stage || 0
		if (this.propItemList == null) {
			this.propItemList = []
		}

		for (let i = 0; i < 4; i++) {
			let index = i + 1
			let suitPropItem = this.propItemList[i]
			if (!suitPropItem) {
				suitPropItem = new SuitActivityItem(this.propCon)
				suitPropItem.Load()
				this.propItemList[i] = suitPropItem
			}
			suitPropItem.SetData(index * 2, stage, this.suit_cfg.suit_id)
		}
		this.AddExpEffect(stage)
		// this.scheduleText.text = stage + "/8"
		let max = stage == 8
		this.ac_btn.visible = !max
		this.lb_ac.visible = !max
		this.maxImg.visible = max
		this.unActiveImg.visible = !max
		this.Image111.visible = max
		this._Label1.visible = max
		this.wearBtn.visible = max

		let use = this.model.useFashion && this.model.useFashion == this.suit_cfg.suit_id
		this.img_wear.visible = use

		// 套装技能
		let cfg = this.cfg_suit_proc[this.suit_cfg.suit_id + "@8"]
		if (cfg && cfg.skill_id) {
			this.suit_skill_id = cfg.skill_id
			let skill_vo = SkillManager.GetInstance().getSkill(this.suit_skill_id)
			let show_icon = (skill_vo && skill_vo.level == 0) ? skill_vo.GetIcon(1) : skill_vo.GetIcon()
			if (show_icon) {
				let url = "resource/game/skillIcon/" + show_icon + ".png"
				ResManager.GetInstance().SetOutsideImageSprite(this, this._img_skill, url)
			}
			this._img_skill.gray = !max
		}
		if(!this.show_desc_ids || this.show_desc_ids.length == 0){
			this.show_desc_ids = this.getShowActivityDescIds()
		}
		this._img_desc.visible = this.show_desc_ids.indexOf(this.suit_cfg.suit_id) > -1
	}


	public CustomMehod(index?, parms_?) {
		this.suit_cfg = this.cfg_suit_clt[parms_ + "@" + RoleManager.GetInstance().GetMainRoleCareer()]
	}

	public DeleteMe() {
		if (this.level_bind) {
			RoleManager.GetInstance().GetMainRoleVo().UnBind(this.level_bind)
			this.level_bind = null
		}
		if (this.equip_list) {
			for (let _ in this.equip_list) {
				let item = this.equip_list[_]
				item.DeleteMe()
				item = null
			}
			this.equip_list = null
		}
		if (this.propItemList) {
			for (let _ in this.propItemList) {
				let v = this.propItemList[_]
				v.DeleteMe()
			}
			this.propItemList = []
		}
		this.has_set_cover = null
		this.model_curr_sorting_order = null

		super.DeleteMe()
	}


	public ReOpen_callback() {
		this.CreateModel()
		this.AddExpEffect()
	}

	public CreateModel() {
		let modelRes = this.suit_cfg.fashion_id
		let colorRes = this.suit_cfg.fashion_color

		this.mainVo = RoleManager.GetInstance().GetMainRoleVo()
		//let model_id, texture_id = GetRoleClotheTextureId()
		let weapon_model_id = this.suit_cfg.equip_id
		let weapon_texture_id = this.suit_cfg.equip_color
		let head_model_id = this.suit_cfg.hair_id
		let head_clothe_id = this.suit_cfg.hair_color

		let data = {
			career: this.mainVo.career,
			sex: this.mainVo.sex,
			clothe_res_id: modelRes,
			weapon_res_id: weapon_model_id,
			weapon_clothe_id: weapon_texture_id,
			type: UI_MODEL_TYPE.ROLE,
			layer_value: this.layer_value,
			scale: 1.3,
			position: new Vector3(0, -1.5, 0),
			fashion_model_id: modelRes,
			texture_id: colorRes,
			wing_id: this.mainVo.GetFigureId(FigureProtoVo.FigureType.Wing),
			// liveness_id: this.mainVo.liveness_id,
			head_wear_id: head_model_id,
			head_clothe_id: head_clothe_id,
			back_ornament_id: this.mainVo.GetFigureId(FigureProtoVo.FigureType.NewBackOrnament),
			hair_id: 0//this.mainVo.GetRoleHairId()
		}
		ResManager.GetInstance().SetRoleModel(this, this.model_con, data)
		/*
		this.model_curr_sorting_order = this.AddCurrLayerSortingOrder(this.layer_value)
		if (!this.has_set_cover) {
			this.CoverMode(this.equip_con1, "UI", this.model_curr_sorting_order)
			this.CoverMode(this.equip_con2, "UI", this.model_curr_sorting_order)
			this.CoverMode(this.effectCon, "UI", this.model_curr_sorting_order)
			this.has_set_cover = true
		}
		*/
	}

	//引导
	public ShowSuitActivityFinger(from_protocal?) {

		if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.Suit_clt) && this.suit_cfg && this.suit_cfg.suit_id == 1) {
			let stage = this.model.GetCurStage(this.suit_cfg.suit_id)
			if (!this.red_img.visible && !((stage == 4 && from_protocal) || stage == 8)) {
				return
			}

			if (stage == 0) {
				this.story_model.curr_view_story_step = 0
				GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this.ac_btn, "UI")
			} else if (stage == 2) {
				this.story_model.curr_view_story_step = 1
				GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this.ac_btn, "UI")
			} else if (stage == 4) {
				if (from_protocal) {
					this.story_model.curr_view_story_step = 2
					GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._img_return)
				} else {
					this.story_model.curr_view_story_step = 0
					GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this.ac_btn, "UI")
				}
			} else if (stage == 6) {
				this.story_model.curr_view_story_step = 1
				GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this.ac_btn, "UI")
			} else if (stage == 8) {
				this.story_model.curr_view_story_step = 2
				GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._img_return)
			}
			// let delayFunc = () => {
			// 	if (!this.use_delete_method && this.ac_btn) {
			// 		// let finger = this.story_model.GetFinger(this, this.ac_btn)
			// 		// if (finger) {
			// 		// 	finger.SetCoverMode()
			// 		// }
			// 	}
			// }
			// setTimeout(delayFunc, 0.5)
		}
	}

	//effectType 1-4  对应2，4，6，8件套
	public AddExpEffect(effectType?) {
		let stage = effectType || 0
		this.img_fill.width = stage / 8 * 497
		/*
		if (effectType || this.effectType) {
			this.effectType = effectType || this.effectType
			this.AddUIEffect("UI_1157", "UI", this.scheduleCon, Vector2(40 * this.effectType, -7), Vector3(this.effectType / 4, 1, 1), true)
		}
		*/
	}

	//激活科技所新形象id列表
	private getShowActivityDescIds(){
		let cfg = this.cfg_suit_clt
		let sub_table = []
		let career = RoleManager.GetInstance().GetMainRoleCareer()
		let level = RoleManager.GetInstance().GetMainRoleLevel()
		let turn = RoleManager.GetInstance().GetMainRoleTurn()
		for (let _ in cfg) {
			let vo = cfg[_]
			if (career == vo.career && level >= vo.open_lv && turn >= vo.open_turn) {
				let sub_vo = {
					fashion_color: vo.fashion_color,
					suit_id: vo.suit_id,
					fashion_id: vo.fashion_id
				}
				table.insert(sub_table, sub_vo)
			}
		}
		table.sort(sub_table, (a?, b?) => {
			return a.suit_id < b.suit_id
		})
		let suitIdList = [];
		let addFashionMap = {};
		for (let i = 0, len = sub_table.length; i < len; i++) {
			let temp = sub_table[i]
			let isHave = false;
			for (const key in addFashionMap) {
				if(addFashionMap[key][0] == temp.fashion_id && addFashionMap[key][1] == temp.fashion_color){
					isHave = true
					break
				}
			}
			if(!isHave){
				addFashionMap[`${temp.suit_id}`] = [temp.fashion_id, temp.fashion_color]
				table.insert(suitIdList, temp.suit_id)
			}
		}
		return suitIdList
	}

	model_con: Laya.Box
	equip_con1: Laya.VBox
	equip_con2: Laya.VBox
	img_bg: Laya.Image
	lb_title2: Laya.Label
	fight_img: Laya.Image
	fight_text: Laya.Label
	propCon: Laya.VBox
	maxImg: Laya.Image
	ac_btn: Laya.Image
	lb_ac: Laya.Label
	red_img: Laya.Image
	effectCon: Laya.Box
	img_titlebg: Laya.Image
	titleImg: Laya.Image
	img_sche: Laya.Image
	img_fill: Laya.Image
	_img_skill: Laya.Image
	line1: Laya.Image
	line2: Laya.Image
	line3: Laya.Image
	line4: Laya.Image
	line5: Laya.Image
	line6: Laya.Image
	line7: Laya.Image
	scheduleText: Laya.Label
	Image111: Laya.Image
	wearBtn: Laya.Image
	img_wear: Laya.Image
	_Label1: Laya.Label
	unActiveImg: Laya.Image
	_img_desc: Laya.Image

	public GetComponents() {
		[
			this.model_con,
			this.equip_con1,
			this.equip_con2,
			this.img_bg,
			this.lb_title2,
			this.fight_img,
			this.fight_text,
			this.propCon,
			this.maxImg,
			this.ac_btn,
			this.lb_ac,
			this.red_img,
			this.effectCon,
			this.img_titlebg,
			this.titleImg,
			this.img_sche,
			this.img_fill,
			this._img_skill,
			this.line1,
			this.line2,
			this.line3,
			this.line4,
			this.line5,
			this.line6,
			this.line7,
			this.scheduleText,
			this.Image111,
			this.wearBtn,
			this.img_wear,
			this._Label1,
			this.unActiveImg,
			this._img_desc
		]
			= this.GetChildrenByNames([
				"model_con",
				"equip_con1",
				"equip_con2",
				"img_bg",
				"lb_title2",
				"fight_img",
				"fight_text",
				"propCon",
				"maxImg",
				"ac_btn",
				"lb_ac",
				"red_img",
				"effectCon",
				"img_titlebg",
				"titleImg",
				"img_sche",
				"img_fill",
				"_img_skill",
				"line1",
				"line2",
				"line3",
				"line4",
				"line5",
				"line6",
				"line7",
				"scheduleText",
				"Image111",
				"wearBtn",
				"img_wear",
				"_Label1",
				"unActiveImg",
				"_img_desc"
			])
	}
}
window["SuitActivityView"] = SuitActivityView