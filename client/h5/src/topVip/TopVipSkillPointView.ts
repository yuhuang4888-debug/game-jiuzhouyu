import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { WordManager } from "../common/WordManager"
import { ErlangParser } from "../util/ErlangParser"
import { SetAnchoredPosition, Util } from "../util/Util"
import { Vector2 } from "../util/Vector2"

export class TopVipSkillPointView extends BaseView1 {
	image: Laya.Image
	tip_gp: Laya.Box
	_Image1: Laya.Image
	_Label1: Laya.Label
	attribute_lb: Laya.HTMLDivElement
	InitEvent
	SetData
	bg
	destroy_imm
	is_center

	public constructor() {
		super()


		this.base_file = "topVip"
		this.layout_file = "TopVipSkillPointView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.is_center = true
		let local_WordManager = WordManager
		let need_refresh_ = false
		let _stage_ = null
		let _sub_stage_ = null
		let pos_ = null
		let _size = null
		this.click_bg_toClose=true
		this.use_background=true
		this.preload_server_config={
			"config_supreme_vip_skill":false
		}
		this.load_callback = () => {

			// this.form.anchoredPosition = Vector2(0, 0)
			// this.form.sizeDelta = Vector2(0,0)
			this.InitEvent()
			if (need_refresh_) {
				this.SetData(_stage_, _sub_stage_, pos_, _size)
			}
			// if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
			// 	this._Label1.size  = 20
			// }
		}

		this.SetData = (stage?, sub_stage?, pos?, size?) => {
			_stage_ = stage
			_sub_stage_ = sub_stage
			pos_ = pos
			_size = size
			if (this.is_loaded) {
				need_refresh_ = false
				// this.form.sizeDelta = _size
				// if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
				// 	SetAnchoredPosition(this.tip_gp,pos_.x - 20,pos_.y-40)
				// }else{
				SetAnchoredPosition(this.tip_gp, pos_.x, pos_.y - 40)
				// }
				let config_supreme_vip_skill = ResManager.GetInstance().GetGameConfigFromCache(this, "config_supreme_vip_skill", false)
				for (let key in config_supreme_vip_skill) {

					// [ts2lua]config_supreme_vip_skill下标访问可能不正确
					let cfg = config_supreme_vip_skill[key]
					if (cfg.stage == _stage_ && cfg.sub_stage == _sub_stage_) {
						let str_list = JSON.parse(cfg.attr)
						let attr_str = ""
						let i = 0
						do {
							let attr = str_list[i]
							if (i + 1 != str_list.length) {
								attr_str = attr_str + "<font color='#70625a'>" + local_WordManager.GetProperties(str_list[i][0]) + (" + </font>") + "<font color='#679e18'>" + local_WordManager.ConvertToPercentValue(str_list[i][0], str_list[i][1]) + "</font><br/>"
							} else {
								attr_str = attr_str + "<font color='#70625a'>" + local_WordManager.GetProperties(str_list[i][0]) + (" + </font>") + "<font color='#679e18'>" + local_WordManager.ConvertToPercentValue(str_list[i][0], str_list[i][1]) + "</font>"
							}
							i = i + 1
						} while ((i < str_list.length))
						this.attribute_lb.innerHTML = Util.StrToHTML(attr_str)
					}
				}
			} else {
				need_refresh_ = true
			}
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this.bg, () => {
				this.Close()
			}
				, this, false)
		}


	}

	public Open(...new_args) {

		let parm = new_args
		if (parm && parm.length > 0) {
			this.SetData(parm[0], parm[1], parm[2], parm[4])
		}
		super.Open()
	}

	public GetComponents() {
		[
			this.image,
			this.tip_gp,
			this._Image1,
			this._Label1,
			this.attribute_lb,
		]
			= this.GetChildrenByNames([

				"image",
				"tip_gp",
				"_Image1",
				"_Label1",
				"attribute_lb",
			])
		this.attribute_lb.style.fontSize=22
		this.attribute_lb.style.width=150
		this.attribute_lb.style.color="#663915"
	}
}
window["TopVipSkillPointView"]=TopVipSkillPointView