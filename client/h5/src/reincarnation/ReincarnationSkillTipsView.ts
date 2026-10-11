import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { SkillManager } from "../skill/SkillManager"
import { GameResPath } from "../util/GameResPath"
import { Util, Trim, HtmlColorTxt } from "../util/Util"

export class ReincarnationSkillTipsView extends BaseView1 {
	SetData
	public constructor() {
		super()
		this.base_file = "reincarnation"
		this.layout_file = "ReincarnationSkillTipsView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.show_open_movie = true
		// let lcoal_resMgr = lua_resM
		let local_util = Util
		let local_skillMgr = SkillManager.GetInstance()
		let skill_data_ = null
		let need_refresh_ = null
		let skill_mask_ = null
		let skill_mask0_ = null
		let data_type_ = null
		this.load_callback = () => {
			if (need_refresh_) {
				this.SetData(skill_data_, data_type_)
			}
			// ResManager.GetInstance().SetOutsideImageSprite(this, this.bg, GameResPath.GetIcon("reincarnation", "uizs_skill_bg1"))
			// ResManager.GetInstance().SetOutsideImageSprite(this, this.bg0, GameResPath.GetIcon("reincarnation", "uizs_skill_bg1"))
			this.des_scroller1.vScrollBar.visible = false
			this.des_scroller0.vScrollBar.visible = false

			//SetCircleMask(this.skill_icon)
			//SetCircleMask(this.skill_icon0)
		}

		this.close_callback = () => {
			//if (skill_mask_ ) {
			//this:removeChild(skill_mask_)
			//skill_mask_ = null
			//}
			//if (skill_mask0_ ) {
			//this:removeChild(skill_mask0_)
			//skill_mask0_ = null
			//}
		}

		this.Open = (skill_data?, data_type?) => {
			skill_data_ = skill_data
			data_type_ = data_type
			if (this.is_loaded) {
				need_refresh_ = false
				this.SetData(skill_data_)
			} else {
				need_refresh_ = true
			}
			super.Open()
		}

		this.SetData = (skill_data?) => {
			if (!skill_data) {
				return
			}
			let skill_id = Number(skill_data[0])
			let skill_lv = Number(skill_data[1])
			let oldCfg = local_skillMgr.getSkillFromConfig(skill_id)
			let oldSkillVo = local_skillMgr.getSkill(skill_id)
			if (!oldCfg || !oldSkillVo) {
				return
			}
			this.skill_name.text = oldSkillVo.GetLvName(skill_lv)
			// this.skill_des1.text = Trim(string.gsub(oldSkillVo.getDesc(skill_lv), "+{1}", ""))
			// this.skill_des0.text = Trim(string.gsub(oldSkillVo.getDesc(skill_lv - 1), "+{1}", ""))
			this.skill_des1.style.fontSize = 20
			this.skill_des1.style.color = "#663915"
			this.skill_des1.style.width = 396
			this.skill_des1.style.leading = 10

			this.skill_des0.style.fontSize = 20
			this.skill_des0.style.color = "#663915"
			this.skill_des0.style.width = 396
			this.skill_des0.style.leading = 10


			this.skill_des1.innerHTML = String(oldSkillVo.getDesc(skill_lv, false)).replace("+{1}", "")
			this.skill_des0.innerHTML = String(oldSkillVo.getDesc(skill_lv - 1, false)).replace("+{1}", "")

			this.skill_name0.text = oldSkillVo.GetLvName(skill_lv - 1)
			let newCfg = local_skillMgr.getSkillFromConfig(skill_id)
			let newSkillVo = local_skillMgr.getSkill(skill_id)
			if (!newCfg || !newSkillVo) {
				return
			}
			let local_gamepath = GameResPath
			let url_str = local_gamepath.GetSkillIconPath(newSkillVo.GetIcon(skill_lv))
			ResManager.GetInstance().SetOutsideImageSprite(this, this.skill_icon, url_str)
			url_str = local_gamepath.GetSkillIconPath(newSkillVo.GetIcon(skill_lv - 1))
			ResManager.GetInstance().SetOutsideImageSprite(this, this.skill_icon0, url_str)
			let type_str = null
			if (oldCfg.type == 2) {
				type_str = "被动技能"
			} else {
				type_str = "主动技能"
			}
			this.skill_type.style.fontSize = 20
			this.skill_type.style.color = "#663915"
			this.skill_type.style.width = 300

			this.skill_type0.style.fontSize = 20
			this.skill_type0.style.color = "#663915"
			this.skill_type0.style.width = 300

			this.skill_type.innerHTML = Util.StrToHTML("类型:" + HtmlColorTxt(type_str, "'#4a3a32'"))
			this.skill_type0.innerHTML = Util.StrToHTML("类型:" + HtmlColorTxt(type_str, "'#4a3a32'"))
		}


	}

	bg: Laya.Image
	_Image1: Laya.Image
	mask1: Laya.Image
	skill_icon: Laya.Image
	skill_name: Laya.Label
	skill_type: Laya.HTMLDivElement
	des_group: Laya.Box
	_Label1: Laya.Label
	des_scroller1: Laya.Panel
	Content: Laya.Box
	skill_des1: Laya.HTMLDivElement
	bg0: Laya.Image
	_Image2: Laya.Image
	mask2: Laya.Image
	skill_icon0: Laya.Image
	skill_name0: Laya.Label
	skill_type0: Laya.HTMLDivElement
	des_group0: Laya.Box
	des_title0: Laya.Label
	des_scroller0: Laya.Panel
	Content1: Laya.Box
	skill_des0: Laya.HTMLDivElement
	public GetComponents() {
		[
			this.bg,
			this._Image1,
			this.mask1,
			this.skill_icon,
			this.skill_name,
			this.skill_type,
			this.des_group,
			this._Label1,
			this.des_scroller1,
			this.Content,
			this.skill_des1,
			this.bg0,
			this._Image2,
			this.mask2,
			this.skill_icon0,
			this.skill_name0,
			this.skill_type0,
			this.des_group0,
			this.des_title0,
			this.des_scroller0,
			this.Content1,
			this.skill_des0,
		]
			= this.GetChildrenByNames([

				"bg",
				"_Image1",
				"mask1",
				"skill_icon",
				"skill_name",
				"skill_type",
				"des_group",
				"_Label1",
				"des_scroller1",
				"Content",
				"skill_des1",
				"bg0",
				"_Image2",
				"mask2",
				"skill_icon0",
				"skill_name0",
				"skill_type0",
				"des_group0",
				"des_title0",
				"des_scroller0",
				"Content1",
				"skill_des0",
			])
	}
}
window["ReincarnationSkillTipsView"] = ReincarnationSkillTipsView