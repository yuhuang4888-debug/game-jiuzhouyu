import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { Trim, Util } from "../util/Util"
import { Config } from "../common/Config"

export class TopVipSkillIntroduceView extends BaseView1 {
	bg_img: Laya.Image
	_Image1: Laya.Image
	skill_img: Laya.Image
	name_lb: Laya.Label
	_Scroller1: Laya.Panel
	Content: Laya.VBox
	des_tip_lb: Laya.Label
	des_lb: Laya.HTMLDivElement
	sure_btn: Laya.Box
	_Image11: Laya.Image
	labelDisplay: Laya.Label
	Empsure_btn
	InitEvent
	Scr_Scroller1
	SetData
	_Group1
	click_bg_toClose
	is_center
	show_open_movie
	use_background

	public constructor() {
		super()


		this.base_file = "topVip"
		this.layout_file = "TopVipSkillIntroduceView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.show_open_movie = true

		let need_refresh_ = false
		let skill_id_ = null
		let type_id_ = null
		this.load_callback = () => {

			this.InitEvent()
			if (need_refresh_) {
				this.SetData(skill_id_)
			}
		}

		this.SetData = (skill_id?) => {
			skill_id_ = skill_id
			if (this.is_loaded) {
				need_refresh_ = false
				let url = "resource/game/skillIcon/" + skill_id_ + ".png"
				ResManager.GetInstance().SetOutsideImageSprite(this, this.skill_img, url)
				let config_skill = ResManager.GetInstance().GetGameConfigFromCache(this, "Skill", false)
				let cfg = Config.PRELOAD_SERVER_CONFIG.config_skill[skill_id_]

				this.name_lb.text = cfg.name
				let lv_data = JSON.parse(cfg.lv_data)
				for (let _tmpi in lv_data) {
					var data = lv_data[_tmpi]
					if(window["ChatModel"]){
						this.des_lb.innerHTML = window["ChatModel"].GetInstance().FormatColorTag(data.desc, false);
					}else{
						this.des_lb.innerHTML = data.desc
					}
				}
			} else {
				need_refresh_ = true
			}
		}

		this.InitEvent = () => {
			let OnColseBtnClick = () => {
				this.Close()
			}

			Util.AddClickEvent(this.sure_btn, OnColseBtnClick, this, true)
		}


	}

	public Open(...new_args) {

		let parm = new_args
		if (parm && parm.length > 0) {
			this.SetData(parm[0])
		}
		super.Open()
	}

	public GetComponents() {
		[
			this.bg_img,
			this._Image1,
			this.skill_img,
			this.name_lb,
			this._Scroller1,
			this.Content,
			this.des_tip_lb,
			this.des_lb,
			this.sure_btn,
			this._Image11,
			this.labelDisplay,
		]
			= this.GetChildrenByNames([

				"bg_img",
				"_Image1",
				"skill_img",
				"name_lb",
				"_Scroller1",
				"Content",
				"des_tip_lb",
				"des_lb",
				"sure_btn",
				"_Image11",
				"labelDisplay",
			])
		this.des_lb.style.fontSize=22
		this.des_lb.style.color="#663915"
		this.des_lb.style.leading=5
		this.des_lb.style.width=280
		this._Scroller1.vScrollBar.visible=false
	}
}
window["TopVipSkillIntroduceView"]=TopVipSkillIntroduceView