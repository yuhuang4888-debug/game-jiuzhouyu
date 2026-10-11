import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { SkillManager } from "../skill/SkillManager"
import { Util } from "../util/Util"

export class LungSkillTipsView extends BaseView1 {

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

	public constructor() {
		super()

		this.base_file = "lung"
		this.layout_file = "LungSkillTipsView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.show_open_movie = true
		let local_skillMgr = SkillManager.GetInstance()
		let need_refresh_ = false
		let skill_id = null
        let skill_lv = 1;
        let skill_desc = "";
		this.load_callback = () => {
			// ResManager.GetInstance().SetTexture(this, this._Image1, GameResPath.GetIcon("common2", "uity_016j"))
			this.InitEvent()
			if (need_refresh_) {
				this.SetData(skill_id, skill_lv, skill_desc)
			}
		}

		this.Local_Open = (...parm) => {
			super.Open()
			let _skill_id = parm[0]
			let _skill_lv = parm[1]
            let _skill_desc = parm[2]
			if (_skill_id && _skill_lv != null) {
				this.SetData(_skill_id, _skill_lv, _skill_desc)
			}
		}

		this.SetData = (_skill_id?, _skill_lv?, _skill_desc?) => {
			skill_id = _skill_id
			skill_lv = _skill_lv || 1;
            skill_desc = _skill_desc
			if (this.is_loaded) {
				this.lv_text.width=150
				need_refresh_ = false
				let cfg = local_skillMgr.getSkillFromConfig(skill_id)
				let skill_vo = local_skillMgr.getSkill(skill_id)
				this.name_text.text = cfg.name
				this.lv_text.innerHTML = `等级：<font color='#0a953e'>${skill_lv}级</font>`
				let show_icon = (skill_vo && skill_vo.level == 0) ? skill_vo.GetIcon(1) : skill_vo.GetIcon()
				if (show_icon) {
					let url = "resource/game/skillIcon/" + show_icon + ".png"
					ResManager.GetInstance().SetOutsideImageSprite(this, this.icon, url)
				}
                if(skill_desc){
                    this.des_text.style.fontSize = 18
                    this.des_text.style.color = "#663915"
                    this.des_text.style.leading= 5
                    this.des_text.width= 290
					this.des_text.height = 66;
                    this.des_text.innerHTML = Util.StrToHTML(skill_desc)
                }
			} else {
				need_refresh_ = true
			}
		}

		this.InitEvent = () => {
			let OnColseBtnClick = () => {
				this.Close()
			}
			Util.AddClickEvent(this.enter_btn, OnColseBtnClick, this, true)
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
		this.lv_text.style.fontSize=20
		this.lv_text.style.color="#663915"

		this.des_scroller.vScrollBar.visible=false
	}
}
window["LungSkillTipsView"]=LungSkillTipsView