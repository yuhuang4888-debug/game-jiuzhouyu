import { BaseView1 } from "../common/BaseView1"
import { Config } from "../common/Config";
import { Enum_UILayer } from "../common/LayerManager";
import { ResManager } from "../common/ResManager";
import { LuaSoundManager } from "../common/SoundManager";
import { SpecialCharKey } from "../common/SpecialCharKey";
import { RuneEvent, RuneModel } from "../commonModel/RuneModel";
import { SkillManager } from "../skill/SkillManager";
import { SkillVo } from "../skill/SkillVo";
import { ColorUtil } from "../util/ColorUtil";
import { ErlangParser } from "../util/ErlangParser";
import { GameResPath } from "../util/GameResPath";
import { AtlasUrl, Util } from "../util/Util";
import { RuneSkillItem } from "./RuneSkillItem";



export class RuneSkillView extends BaseView1 {

	InitEvent
	InitView
	SelectSkill
	CloseFunc
	constructor() {
		super()
		this.base_file = "rune"
		this.layout_file = "RuneSkillView"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.destroy_imm = true
		let model = RuneModel.GetInstance(),
			local_RuneEvent = RuneEvent,
			local_Util = Util,
			local_ColorUtil = ColorUtil,
			res_mgr = ResManager.GetInstance(),
			skillItemList_,
			/**当前选中技能id*/
			skillLv_,
			skillVo_: SkillVo,
			canActive_,
			activeLv_,
			posList_ = [[310, 534], [121, 470], [413, 387], [207, 309], [24, 282], [217, 167], [406, 137], [222, 42], [49, 12]]
		this.load_callback = function () {
			this._Scroller1.vScrollBar.visible = false
			// res_mgr.SetOutsideImageSprite(this, this._bg, GameResPath.GetIcon("common", "uisy_023"))
			res_mgr.SetTexture(this, this.skillBg, "resource/game/rune/texture/uifwjn_004.jpg")
			this.InitView()
			this.InitEvent()
		}

		this.close_callback = function () {
			this.CloseFunc()
		}
		this.preload_server_config = {
			"config_rune_awake_skill": false
		}

		this.InitEvent = () => {
			this.BindEvent(model, local_RuneEvent.SELECT_SKILL, (skillLv) => {
				this.SelectSkill(skillLv)
			})

			local_Util.AddClickEvent(this._btn_close, () => {
				this.Close()
			}, this, true)

			this.BindEvent(model, local_RuneEvent.SKILL_LV_UP, () => {
				this.InitView()
				this.SelectSkill()
			})
		}

		this.InitView = () => {
			skillVo_ = SkillManager.GetInstance().getSkill(RuneModel.SkillId)
			if (!skillItemList_) {
				skillItemList_ = {}
			}
			let defaultSelect = model.rune_info[`skill_lv`]
			if (defaultSelect < 0) {
				defaultSelect = 0
			}
			if (defaultSelect > posList_.length - 1) {
				defaultSelect = posList_.length - 1
			}
			for (let i = 0; i < posList_.length; i++) {
				let Pos = posList_[i]
				let item: RuneSkillItem = skillItemList_[i]
				if (!item) {
					item = new RuneSkillItem(this.skillItemGp)
					item.Load()
					skillItemList_[i] = item
				}
				item.SetPosition(Pos[0], Pos[1])
				if (i == posList_.length - 1) {
					item.ExcuteCallback(() => {
						item.SetLast()
					})
				}
				let condText = ``
				let config_rune_awake_skill = ResManager.GetInstance().GetGameConfigFromCache(this, "config_rune_awake_skill", false);
				if (config_rune_awake_skill) {
					let condCfg = config_rune_awake_skill[`${RuneModel.SkillId}@${i + 1}`]
					if (condCfg) {
						let condList = JSON.parse(condCfg.condition)
						for (let vo of condList) {
							if (vo[2] > 0) {
								condText = `${vo[2]}级觉醒${local_ColorUtil.GetColorName(vo[0])}*${vo[1]}`
							} else {
								condText = `${local_ColorUtil.GetColorName(vo[0])}*${vo[1]}解锁`
							}
						}
					}
				}
				item.InitItem(skillVo_.getLevelVo(i + 1), i, condText)
				if (defaultSelect == i) {
					this.SelectSkill(defaultSelect)
				}
				item.SetGary((model.rune_info[`skill_lv`]) <= i)
				let source = "uifwjn_006"
				let lv = model.rune_info[`skill_lv`]
				for (let i = 2; i < 10; i++) {
					source = (lv <= (i - 1)) ? "uifwjn_005" : "uifwjn_006"
					this[`_Image${i}`].skin = AtlasUrl("rune", source)
				}
			}
		}

		this.SelectSkill = (skillLv?) => {
			if (skillLv == skillLv_) {
				return
			}
			let item = skillItemList_[skillLv_]
			if (item) {
				item.SetSelect(false)
			}
			skillLv_ = skillLv == undefined ? skillLv_ : skillLv
			let newItem = skillItemList_[skillLv_]
			if (newItem) {
				newItem.SetSelect(true)
				let skillVo = skillVo_.getLevelVo(skillLv_ + 1)
				let skillCfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_rune_awake_skill", false);
				if (skillVo && skillCfg) {
					this.skillName.text = `${skillVo.lv_name}`
					let skillLvCfg = skillCfg[`${RuneModel.SkillId}@${skillLv_ + 1}`]
					let str = ``
					if (skillLvCfg) {
						let tmp = String(skillLvCfg.doc).replace(/<color/g, "<font color")
						tmp = tmp.replace(/<\/color>/g, "</font>")
						str += `解锁条件:${tmp}<br/> `
					}
					this.lockLb.style.fontSize = 18
					this.lockLb.width = 440
					this.lockLb.style.leading = 8
					this.lockLb.style.color = "#663915"
					let desc = String(skillVo.desc).replace(SpecialCharKey.RuneSkillView2, SpecialCharKey.RuneSkillView1)
					if(window["ChatModel"]){
						desc = window["ChatModel"].GetInstance().FormatColorTag(desc, false);
					}
					this.lockLb.innerHTML = local_Util.StrToHTML(`${str}技能描述:${desc}`)
					this.lockLb.height = this.lockLb.contextHeight + 10
					res_mgr.SetTexture(this, this.skillImg, GameResPath.GetSkillIconPath(skillVo.icon))
				} let nowLv = model.rune_info.skill_lv
				// let canActive = nowLv == skillLv_ && model.CanSkillUp(skillLv_ + 1, skillCfg)
				// this.activeRed.visible = canActive_ = canActive
				local_Util.SetImageGray(this.skillImg, skillLv_ >= nowLv)
			}
		}

		this.CloseFunc = () => {
			if (skillItemList_) {
				for (let key in skillItemList_) {
					skillItemList_[key].DeleteMe();
					delete skillItemList_[key]
				}
				skillItemList_ = null
			}
			skillLv_ = null
		}
	}
	_bg: Laya.Image
	_Group1: Laya.Box
	_img_title: Laya.Image
	_img_title0: Laya.Label
	_btn_close: Laya.Image
	skillBg: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Image4: Laya.Image
	_Image5: Laya.Image
	_Image6: Laya.Image
	_Image7: Laya.Image
	_Image8: Laya.Image
	_Image9: Laya.Image
	skillItemGp: Laya.Box
	_Image11: Laya.Image
	skillName: Laya.Label
	skillImg0: Laya.Image
	skillImg: Laya.Image
	activeRed: Laya.Image
	_Scroller1: Laya.Panel
	lockLb: Laya.HTMLDivElement
	public GetComponents() {
		[
			this._bg,
			this._Group1,
			this._img_title,
			this._img_title0,
			this._btn_close,
			this.skillBg,
			this._Image2,
			this._Image3,
			this._Image4,
			this._Image5,
			this._Image6,
			this._Image7,
			this._Image8,
			this._Image9,
			this.skillItemGp,
			this._Image11,
			this.skillName,
			this.skillImg0,
			this.skillImg,
			this.activeRed,
			this._Scroller1,
			this.lockLb,
		]
			= this.GetChildrenByNames([

				"_bg",
				"_Group1",
				"_img_title",
				"_img_title0",
				"_btn_close",
				"skillBg",
				"_Image2",
				"_Image3",
				"_Image4",
				"_Image5",
				"_Image6",
				"_Image7",
				"_Image8",
				"_Image9",
				"skillItemGp",
				"_Image11",
				"skillName",
				"skillImg0",
				"skillImg",
				"activeRed",
				"_Scroller1",
				"lockLb",
			])
	}
}
window["RuneSkillView"] = RuneSkillView