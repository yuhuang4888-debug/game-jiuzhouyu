import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { Config } from "../common/Config"
import { ResManager } from "../common/ResManager"
import { SuitActivityModel } from "../commonModel/SuitActivityModel"
import { SkillManager } from "../skill/SkillManager"
import { Util } from "../util/Util"

export class SuitSkillView extends BaseView1 {
	skill_bg: Laya.Image
	icon_bg: Laya.Image
	icon: Laya.Image
	_Image1: Laya.Image
	des_text0: Laya.Label
	name_text: Laya.Label
	lv_text: Laya.HTMLDivElement
	des_scroller: Laya.Panel
	des_group: Laya.VBox
	des_text: Laya.HTMLDivElement
	fight_text: Laya.Label
	enter_btn: Laya.Box
	enter_img: Laya.Image
	enter_lb: Laya.Label

	InitEvent
	SetData
	Local_Open
	suit_id
	model
	cfg_suit_proc

	public constructor() {
		super()
		this.base_file = "pet"
		this.layout_file = "PetSkillView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.show_open_movie = true

		this.model = SuitActivityModel.GetInstance()
		let local_skillMgr = SkillManager.GetInstance()
		let need_refresh_ = false

		this.load_callback = () => {
			this.des_text.style.fontSize = 18
			this.des_text.style.color = "#663915"
			this.des_text.style.leading = 5
			this.lv_text.style.fontSize = 20
			this.lv_text.style.color = "#663915"
			this.lv_text.style.wordWrap = false
			this.des_scroller.vScrollBar.visible = false
			this.cfg_suit_proc = Config.PRELOAD_SERVER_CONFIG.config_suit_clt_process

			this.InitEvent()
			if (need_refresh_) {
				need_refresh_ = false
				this.SetData()
			}
		}

		this.Local_Open = (...parm) => {
			super.Open()
			this.suit_id = parm[0]
			this.SetData()
		}

		this.SetData = () => {
			if (!this.is_loaded) {
				need_refresh_ = true
				return
			}
			
			if (!this.suit_id) {
				return
			}
			let suit_cfg = this.cfg_suit_proc[this.suit_id + "@8"]
			if(!suit_cfg || !suit_cfg.skill_id) {
				return
			}
			let skill_id = suit_cfg.skill_id
			let stage = this.model.GetCurStage(this.suit_id)
			let max = stage == 8
			let cfg = local_skillMgr.getSkillFromConfig(skill_id)
			let skill_vo = local_skillMgr.getSkill(skill_id)
			this.name_text.text = cfg.name
			let state_str = max ? "<font color='#0a953e'>已激活</font>" : "<font color='#ff4f50'>未激活</font>"
			this.lv_text.innerHTML = "激活状态：" + state_str
			let show_icon = (skill_vo && skill_vo.level == 0) ? skill_vo.GetIcon(1) : skill_vo.GetIcon()
			if (show_icon) {
				let url = "resource/game/skillIcon/" + show_icon + ".png"
				ResManager.GetInstance().SetOutsideImageSprite(this, this.icon, url)
			}
			this.des_text.innerHTML = Util.StrToHTML(skill_vo.getDesc(0, false))
			this.des_text.width = 290
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this.enter_btn, () => {
				this.Close()
			}, this, true)
		}
	}

	public Open(...parm) {
		this.Local_Open(...parm)
	}

	public GetComponents() {
		[
			this.skill_bg,
			this.icon_bg,
			this.icon,
			this._Image1,
			this.des_text0,
			this.name_text,
			this.lv_text,
			this.des_scroller,
			this.des_group,
			this.des_text,
			this.fight_text,
			this.enter_btn,
			this.enter_img,
			this.enter_lb,
		]
			= this.GetChildrenByNames([
				"skill_bg",
				"icon_bg",
				"icon",
				"_Image1",
				"des_text0",
				"name_text",
				"lv_text",
				"des_scroller",
				"des_group",
				"des_text",
				"fight_text",
				"enter_btn",
				"enter_img",
				"enter_lb",
			])
	}
}
window["SuitSkillView"] = SuitSkillView