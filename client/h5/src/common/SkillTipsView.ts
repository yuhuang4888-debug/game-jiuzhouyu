import { SkillManager } from "../skill/SkillManager"
import { GameResPath } from "../util/GameResPath"
import { Util, Trim } from "../util/Util"
import { BaseView1 } from "./BaseView1"
import { Enum_UILayer } from "./LayerManager"
import { ResManager } from "./ResManager"

export class SkillTipsView extends BaseView1 {
	SetData
	Local_Open
	Scrdes_scroller
	LoadSuccess
	InitEvent

	public constructor() {
		super()

		let skill_mgr = SkillManager.GetInstance()

		let _need_refresh = false
		let _skill_data = null
		let _icon_type = null
		this.base_file = "common"
		this.layout_file = "SkillTipsView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.show_open_movie = true
		
		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvent()
			if (_skill_data) {
				this.SetData(_skill_data)
			}
		}

		this.open_callback = () => {
		}
		this.close_callback = () => {
		}
		this.destroy_callback = () => {
		}
		this.Local_Open = (skill_data?, icon_type?) => {
			_skill_data = skill_data
			_icon_type = icon_type
			if (this.is_loaded) {
				this.SetData(_skill_data)
			}
			super.Open()
		}

		this.SetData = (skill_data?) => {
			_skill_data = skill_data
			if (this.is_loaded) {
				if (!skill_data.skill_lv) {
					skill_data.skill_lv = 1
				}

				let skill_id
				if (skill_data.skill_id instanceof Array) {
					skill_id = skill_data.skill_id[0]
				} else {
					skill_id = skill_data.skill_id
				}
				if (skill_id) {
					skill_id = Number(skill_id)
				}

				if (skill_data.is_fake) {
					ResManager.GetInstance().SetOutsideImageSprite(this, this.icon, skill_data.path)
					this.des_text.innerHTML = skill_data.desc
					this.lv_text.innerHTML = "等级:" + skill_data.skill_lv
					this.name_text.text = skill_data.name
				} else {
					let cfg = skill_mgr.getSkillFromConfig(skill_id)
					let skill_vo = skill_mgr.getSkill(skill_id)
					if (skill_vo) {
						if (skill_data.skill_lv) {
							let lv_data = skill_vo.getLevelVo(Number(skill_data.skill_lv))
							let has_icon = lv_data && lv_data.icon != ""
							let key = has_icon ? lv_data.icon : skill_id
							ResManager.GetInstance().SetOutsideImageSprite(this, this.icon, GameResPath.GetSkillIconPath(key))
							this.des_text.innerHTML = Trim(Util.StrToHTML(lv_data.desc))
							this.lv_text.innerHTML = has_icon ? "等级:1级" : `等级:${skill_data.skill_lv}级`
							this.name_text.text = Trim((lv_data.lv_name != "" && (lv_data.lv_name) || (cfg.name)))
						} else {
							let url = "resource/game/skillIcon/" + skill_id + ".png"
							ResManager.GetInstance().SetOutsideImageSprite(this, this.icon, url)
							this.des_text.innerHTML = Util.StrToHTML(skill_vo.getDesc(skill_data.skill_lv - 1))
							this.name_text.text = Trim(cfg.name)
						}
					}
				}
				this.des_text.width = 290

				if (_icon_type == 2) {
					//ResManager.GetInstance().SetOutsideImageSprite(this, this.icon_bg, "resource/game/role/role_15.png")
				}
			}
		}

		this.LoadSuccess = () => {
			this.des_scroller.vScrollBar.visible = false
			this.labelDisplay.text = "确定"
			
			this.lv_text.style.fontSize = 20
			this.lv_text.style.color = "#783528"
			this.lv_text.style.wordWrap = false
			
			this.des_text.width = 290
			this.des_text.style.fontSize = 18
			this.des_text.style.color = "#783528"
			this.des_text.style.leading = 8
			
		}

		this.InitEvent = () => {
			let OnColseBtnClick = () => {
				this.Close()
			}
			Util.AddClickEvent(this.enter_btn, OnColseBtnClick, this, true)
		}
	}

	public Open(skill_data?, icon_type = 1) {
		this.Local_Open(skill_data, icon_type)
	}

	skill_bg: Laya.Image
	icon_bg: Laya.Image
	icon: Laya.Image
	name_text: Laya.Label
	lv_text: Laya.HTMLDivElement
	enter_btn: Laya.Box
	_Image1: Laya.Image
	labelDisplay: Laya.Label
	des_scroller: Laya.Panel
	Content: Laya.Box
	des_text: Laya.HTMLDivElement
	img_title: Laya.Image
	_Label1: Laya.Label
	public GetComponents() {
		[
			this.skill_bg,
			this.icon_bg,
			this.icon,
			this.name_text,
			this.lv_text,
			this.enter_btn,
			this._Image1,
			this.labelDisplay,
			this.des_scroller,
			this.Content,
			this.des_text,
			this.img_title,
			this._Label1,
		]
			= this.GetChildrenByNames([

				"skill_bg",
				"icon_bg",
				"icon",
				"name_text",
				"lv_text",
				"enter_btn",
				"_Image1",
				"labelDisplay",
				"des_scroller",
				"Content",
				"des_text",
				"img_title",
				"_Label1",
			])
	}
}
window["SkillTipsView"] = SkillTipsView