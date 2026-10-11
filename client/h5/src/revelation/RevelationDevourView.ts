import { BaseView1 } from "../common/BaseView1"
import { Util, SetAnchoredPosition } from "../util/Util"
import { table } from "../common/table"
import { Enum_UILayer } from "../common/LayerManager"
import { GameResPath } from "../util/GameResPath"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"
import { Message } from "../sysInfo/SysInfoController"
import { RedDotManager, ModuleType } from "../common/RedDotManager"
import { InstructionType } from "../common/InstructionType"
import { SkillManager } from "../skill/SkillManager"
import { RevelationModel, RevelationEvent } from "../commonModel/RevelationModel"
import { RevelationDevourItem } from "./RevelationDevourItem"
import { RevelationDevourPropItem } from "./RevelationDevourPropItem"
import { ResManager } from "../common/ResManager"
import "../revelation/RevelationSkillView"
import "../revelation/RevelationSelectView"

export class RevelationDevourView extends BaseView1 {
	model
	res_mgr
	red_mgr

	DesCallback
	InitEvent
	InitView
	SelectEquip
	SetSkillInfo

	public constructor() {
		super()
		this.base_file = "revelation"
		this.layout_file = "RevelationDevourView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.show_open_movie = true
		this.destroy_imm = true

		this.res_mgr = ResManager.GetInstance()
		this.model = RevelationModel.GetInstance()
		this.red_mgr = RedDotManager.GetInstance()

		let local_redType = ModuleType.REVE_DEVOUR_RED
		let defaultEquipList_ = [72010004, 72020004, 72030004, 72040004, 72050004, 72060004, 72070004, 72080004, 72090004, 72100004]
		let propItemArray_ = null
		let equipItemList_ = []
		let posList_ = [
			{ 1: 222, 2: -5 }, { 1: 357, 2: 37 }, { 1: 441, 2: 152 }, { 1: 441, 2: 293 }, { 1: 358, 2: 406 },
			{ 1: 224, 2: 451 }, { 1: 89, 2: 406 }, { 1: 7, 2: 293 }, { 1: 7, 2: 153 }, { 1: 90, 2: 39 }
		]
		let effectPosList_ = [
			{ 1: 266, 2: 164 }, { 1: 340, 2: 180 }, { 1: 395, 2: 240 }, { 1: 392, 2: 322 }, { 1: 347, 2: 393 },
			{ 1: 268, 2: 409 }, { 1: 191, 2: 390 }, { 1: 141, 2: 325 }, { 1: 142, 2: 242 }, { 1: 190, 2: 176 }
		]
		let selectPosId_ = null
		let arrowEffectList_ = []
		let defaultIndex_ = null
		let selectedItem_ = null

		this.load_callback = () => {
			this.gp_attr.vScrollBar.visible = false
			this.res_mgr.SetOutsideImageSprite(this, this.img_bg2, GameResPath.GetIcon("revelation", "ui_Apocalypse_02"))
			this.res_mgr.SetOutsideImageSprite(this, this.img_bg3,GameResPath.GetIcon("revelation", "ui_Apocalypse_01"))

			this.InitEvent()
		}

		this.open_callback = () => {
			this.InitView()
			/*
			if (PlatformMgr.GetInstance().IsEyouIdnPlatform()) {
				this.skillNameLb.size = 18
				this._Label1.size = 16
			}*/
		}

		this.destroy_callback = () => {
			this.DesCallback()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this.btn_close, () => {
				this.Close()
			}, this, true)

			Util.AddClickEvent(this.btn_ins, () => {
				GlobalEventSystem.Fire(EventName.OPEN_INSTRUCTION_VIEW, InstructionType.Revelation)
			}, this, true)

			Util.AddClickEvent(this.img_skill, () => {
				this.model.Fire(RevelationEvent.OPEN_VIEW, "RevelationSkillView")
			}, this, true)

			Util.AddClickEvent(this.btn_devour, () => {
				let info = selectedItem_ && selectedItem_.data
				if (info) {
					if (info.preview) {
						Message.show("3星天启装备可开启聚灵功能")
						return
					}
					this.model.Fire(RevelationEvent.OPEN_VIEW, "RevelationSelectView", info.equip_type)
				}
			}, this, true)

			Util.AddClickEvent(this.btn_up, () => {
				let info = selectedItem_ && selectedItem_.data
				if (info) {
					if (info.preview) {
						Message.show("3星天启装备可开启聚灵功能")
						return
					}
					this.model.Fire(RevelationEvent.REQUEST_PROTO, 28604, "c", info.equip_type)
				}
			}, this, true)

			this.BindEvent(this.model, RevelationEvent.SELECT_DEVOUR_ITEM, (posId?) => {
				this.SelectEquip(posId)
			})

			this.BindEvent(this.model, RevelationEvent.UPDATE_EQUIP_DATA, () => {
				this.SelectEquip(selectPosId_)
				this.SetSkillInfo()
			})

			this.BindEvent(this.model, RevelationEvent.EQUIP_DEVOUR_SUCCESS, (scmd?) => {
				if (scmd) {
					this.SelectEquip(selectPosId_)
				}
			})

			this.BindEvent(this.model, RevelationEvent.EQUIP_LV_UP_SUCCESS, () => {
				this.AddUIEffect("ui_shengjitexiao", this._gp_effect, null, 1, false, null, null, null, null, null, null, null, false)
			})

			this.BindVar(this.model, "skillRed", () => {
				this.img_redSkill.visible = this.model.skillRed
			})
		}

		this.InitView = () => {
			for (let _tmpi in RevelationModel.PosIndex) {
				let vo = RevelationModel.PosIndex[_tmpi]
				let item = new RevelationDevourItem(this.gp_item)
				item.Load()
				let equipData = this.model.GetWearEquipByPos(vo)
				let EquipCfg = equipData && this.res_mgr.GetGameConfigFromCache(this, "config_revelation_equip_attr", false)[equipData.type_id]
				let data = null
				//let group = arrowEffectList_[vo]
				if (EquipCfg && EquipCfg.star >= 3) {
					/*
					if (!group) {
						group = UiFactory.CreateChild(this.arrowGP, UIType.EmptyObject).transform
						SetAnchoredPosition(group, effectPosList_[vo][1], -effectPosList_[vo][2])
						arrowEffectList_[vo] = group
					}
					*/
					//this:AddUIEffect("ui_Apocalypse_strip2", group, null, null, true, null, null, null, null, null, null, null, null, null, 36 * vo - 1)
					data = equipData
				} else {
					data = { type_id: defaultEquipList_[vo - 1], equip_type: vo, preview: true }
					/*
					if (group) {
						this.ClearUIEffect(group)
					}
					*/
				}
				item.SetData(data)
				item.SetPosition(posList_[vo - 1][1], posList_[vo - 1][2])
				equipItemList_[vo] = item
				if (!defaultIndex_) {
					if (this.red_mgr.CheckRedStatus(local_redType, vo) || this.red_mgr.CheckRedStatus(local_redType, 10 + vo)) {
						defaultIndex_ = vo
					}
				}
			}

			this.SelectEquip(defaultIndex_ || 1)
			this.SetSkillInfo()

			//local_resMgr:SetOutsideImageSprite(this, this.bg3, GameResPath.GetIcon("revelation","uitq_001z"),true)
			//this:AddUIEffect("ui_Apocalypse_iconglow", this.effectGp1, null, null, true)
		}

		this.SelectEquip = (posId?) => {
			let info = equipItemList_[posId].data
			if (info) {
				this.img_redDev.visible = this.red_mgr.CheckRedStatus(local_redType, posId)
				this.img_redUp.visible = this.red_mgr.CheckRedStatus(local_redType, posId + 10)
				let devourLvCfg = this.res_mgr.GetGameConfigFromCache(this, "config_revelation_equip_gathering", false)
				if (devourLvCfg) {
					let equipData = this.model.equipData.gathering
					let curExp = equipData && equipData[10 - posId].exp || 0
					let curLv = equipData && equipData[10 - posId].lv || 0
					let curCfg = devourLvCfg[posId + "@" + curLv]
					let nextCfg = devourLvCfg[posId + "@" + (curLv + 1)]
					let curAttr = curCfg && JSON.parse(curCfg.attr)
					let nextAttr = nextCfg && JSON.parse(nextCfg.attr)
					if (!propItemArray_) {
						propItemArray_ = []
					}
					let mainAttr = nextAttr || curAttr
					if (mainAttr) {
						curAttr = curAttr || {}
						nextAttr = nextAttr || {}
						table.unshift(curAttr, { 1: 999, 2: curLv })
						if (nextCfg) {
							table.unshift(nextAttr, { 1: 999, 2: (curLv + 1) })
							this.btn_devour.visible = true
							this.btn_up.visible = true
						} else {
							this.btn_devour.visible = false
							this.btn_up.visible = false
						}

						let i = 0
						do {
							let propItem = propItemArray_[i]
							if (!propItem) {
								propItem = new RevelationDevourPropItem(this.gp_attrCon)
								propItem.Load()
								propItemArray_[i] = propItem
							}
							propItem.SetVisible(true)
							propItem.SetData(curAttr[i], nextAttr[i])
							i = i + 1
						} while ((i < mainAttr.length))
						i = mainAttr.length
						do {
							let propItem = propItemArray_[i]
							if (propItem) {
								propItem.SetVisible(false)
							}
							i = i + 1
						} while ((i < propItemArray_.length))
					}
					if (curCfg && curCfg.exp) {
						this.lb_exp.text = curExp + "/" + curCfg.exp
						this.img_exp.width = Math.min(1, curExp / curCfg.exp) * 510
					} else {
						this.lb_exp.text = "已满级"
						this.img_exp.width = 510
					}
				}
				//SetImageGray(this.upBtn, info.preview)
				//SetImageGray(this.devourBtn, info.preview)

				if (selectedItem_) {
					selectedItem_.SetSelect(false)
				}
				let item = equipItemList_[posId]
				if (item) {
					selectPosId_ = posId
					selectedItem_ = item
					item.SetSelect(true)
				}
			}
		}

		this.SetSkillInfo = () => {
			let skillList = this.model.equipData.skill_list
			let skillId = 400101
			let skillLv = 0
			if (skillList && skillList.length > 0) {
				skillId = skillList[skillList.length - 1].skill_id
				skillLv = skillList[skillList.length - 1].lv
			}
			let skill_vo = SkillManager.GetInstance().getSkill(skillId)
			this.lb_skill.text = skill_vo.GetLvName(skillLv)
			if (skillLv != 0) {
				this.lb_lv.color = '#d15e00'
				this.lb_lv.text = "Lv." + skillLv
			} else {
				this.lb_lv.color = '#fe1a1a'
				this.lb_lv.text = "未激活"
			}
			let icon = skill_vo.GetIcon((skillLv == 0 && 1 || skillLv))
			this.img_redSkill.visible = this.model.skillRed
			this.res_mgr.SetOutsideImageSprite(this, this.img_skill, GameResPath.GetSkillIconPath(icon != 0 && icon || skillId))
		}

		this.DesCallback = () => {
			if (propItemArray_) {
				for (let _tmpi in propItemArray_) {
					let propItem = propItemArray_[_tmpi]
					propItem.DeleteMe()
				}
				propItemArray_ = null
			}
			if (equipItemList_) {
				for (let key in equipItemList_) {
					equipItemList_[key].DeleteMe()
					equipItemList_[key] = null
				}
				equipItemList_ = []
			}

			/*
			for (let key in arrowEffectList_) {
				let group = arrowEffectList_[key]
				if (group) {
					this.ClearUIEffect(group)
				}
				arrowEffectList_[key] = null
			}
			arrowEffectList_ = []
			this.ClearUIEffect(this.effectGp)
			this.ClearUIEffect(this.effectGp1)
			*/

			defaultIndex_ = null
		}
	}

	img_bg1: Laya.Image
	img_bg2: Laya.Image
	img_bg3: Laya.Image
	img_bg4: Laya.Image
	img_title: Laya.Image
	lb_title: Laya.Label
	btn_close: Laya.Image
	gp_arrow: Laya.Box
	_Image1: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Image4: Laya.Image
	_Image5: Laya.Image
	_Image6: Laya.Image
	_Image7: Laya.Image
	_Image8: Laya.Image
	_Image9: Laya.Image
	_Image10: Laya.Image
	gp_item: Laya.Box
	img_tips: Laya.Image
	lb_tips: Laya.Label
	img_skill: Laya.Image
	img_redSkill: Laya.Image
	gp_skill: Laya.HBox
	lb_skill: Laya.Label
	lb_lv: Laya.Label
	gp_attr: Laya.Panel
	gp_attrCon: Laya.VBox
	img_prog: Laya.Image
	img_exp: Laya.Image
	lb_exp: Laya.Label
	btn_ins: Laya.Image
	btn_up: Laya.Image
	img_redUp: Laya.Image
	lb_up: Laya.Label
	btn_devour: Laya.Image
	img_redDev: Laya.Image
	lb_devour: Laya.Label
	_gp_effect: Laya.Box
	public GetComponents() {
		[
			this.img_bg1,
			this.img_bg2,
			this.img_bg3,
			this.img_bg4,
			this.img_title,
			this.lb_title,
			this.btn_close,
			this.gp_arrow,
			this._Image1,
			this._Image2,
			this._Image3,
			this._Image4,
			this._Image5,
			this._Image6,
			this._Image7,
			this._Image8,
			this._Image9,
			this._Image10,
			this.gp_item,
			this.img_tips,
			this.lb_tips,
			this.img_skill,
			this.img_redSkill,
			this.gp_skill,
			this.lb_skill,
			this.lb_lv,
			this.gp_attr,
			this.gp_attrCon,
			this.img_prog,
			this.img_exp,
			this.lb_exp,
			this.btn_ins,
			this.btn_up,
			this.img_redUp,
			this.lb_up,
			this.btn_devour,
			this.img_redDev,
			this.lb_devour,
			this._gp_effect,
		]
			= this.GetChildrenByNames([

				"img_bg1",
				"img_bg2",
				"img_bg3",
				"img_bg4",
				"img_title",
				"lb_title",
				"btn_close",
				"gp_arrow",
				"_Image1",
				"_Image2",
				"_Image3",
				"_Image4",
				"_Image5",
				"_Image6",
				"_Image7",
				"_Image8",
				"_Image9",
				"_Image10",
				"gp_item",
				"img_tips",
				"lb_tips",
				"img_skill",
				"img_redSkill",
				"gp_skill",
				"lb_skill",
				"lb_lv",
				"gp_attr",
				"gp_attrCon",
				"img_prog",
				"img_exp",
				"lb_exp",
				"btn_ins",
				"btn_up",
				"img_redUp",
				"lb_up",
				"btn_devour",
				"img_redDev",
				"lb_devour",
				"_gp_effect",
			])
	}
}
window["RevelationDevourView"] = RevelationDevourView