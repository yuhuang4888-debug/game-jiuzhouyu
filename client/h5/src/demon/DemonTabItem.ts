import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { ResManager } from "../common/ResManager";
import { DemonDefine } from "../commonModel/DemonDefine";
import { DemonEvent } from "../commonModel/DemonEvent";
import { DemonModel } from "../commonModel/DemonModel";
import { ColorUtil } from "../util/ColorUtil";
import { GameResPath } from "../util/GameResPath";
import { Util } from "../util/Util";

export class DemonTabItem extends BaseItemRenderer {
	_img_bg: Laya.Image
	_gp_con: Laya.Box
	_img_icon: Laya.Image
	_img_name_bg: Laya.Image
	_img_level_bg: Laya.Image
	_lb_level: Laya.Label
	_lb_name: Laya.HTMLDivElement
	_gp_stars: Laya.Box
	_img_tips: Laya.Image
	_select: Laya.Image
	_img_red: Laya.Image

	demon_model: DemonModel

	public constructor() {
		super()
		// this.skinName = "resource/game/demon/exml/DemonTabItemExml.exml"
		this.base_file = "demon"
		this.layout_file = "DemonTabItem"
		this.HEIGT=192
		this.WIDTH=151
		this.demon_model = DemonModel.GetInstance()
		this.Load()
	}
	public createChildren() {
		super.createChildren()


	}
	public load_callback() {
		this.BindEvent(this.demon_model, DemonEvent.UPDATE_DEMON_DATA, (demon_id?) => {
			if (this.data.demon_id == demon_id) {
				this.UpdateData()
			}
		})

		this.BindEvent(this.demon_model, DemonEvent.REFRESH_RED_FLAG, (flag?, key?) => {
			if ((
				flag == DemonModel.RedFlag.Level
				|| flag == DemonModel.RedFlag.Star
				|| flag == DemonModel.RedFlag.LifeSkill
			) && key == this.data.demon_id) {
				this.UpdateRedState()
			} else if (flag == DemonModel.RedFlag.Skill && this.data.skill_dic[key]) {
				this.UpdateRedState()
			} else if (flag == DemonModel.RedFlag.Talent) {
				this.UpdateRedState()
			}
		})
	}
	public dataChanged() {
		if (!super.dataChanged()) return
		this._lb_name.width=150
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_icon,GameResPath.GetIcon("demon",`demon_card_head_${this.data.demon_id}`),true)
		this._lb_name.style.color = ColorUtil.GetColorDark(this.data.color,false)
		if(this.data.color==3){
			this._lb_name.style.color="#e036f4"
		}else if(this.data.color==4){
			this._lb_name.style.color="#ff5400"
		}else{
			this._lb_name.style.color="#fe1a1a"
		}
		this._lb_name.innerHTML = this.data.demons_name


		let tips_source = DemonDefine.tips_source[this.data.realm + "@" + this.data.color]
		if (tips_source) {
			this._img_tips.skin =GameResPath.GetIcon(tips_source[0],tips_source[1]) //tips_source
		}

		let setting_cfg = DemonDefine.Quality2Setting[this.data.color]
		if (setting_cfg) {
			this._img_bg.skin = GameResPath.GetIcon(setting_cfg.bg_source[0],setting_cfg.bg_source[1])// setting_cfg.bg_source
			this._img_name_bg.skin = GameResPath.GetIcon(setting_cfg.name_bg_source[0],setting_cfg.name_bg_source[1])// setting_cfg.name_bg_source
			this._img_level_bg.skin = GameResPath.GetIcon(setting_cfg.level_bg_source[0],setting_cfg.level_bg_source[1])// setting_cfg.level_bg_source
		}

		this.UpdateData()
		this.UpdateRedState()
		this._lb_name.x=this._gp_con.width/2-this._lb_name.contextWidth/2
		this._select.visible=this.selected 
	}

	public UpdateData() {
		let data = this.demon_model.GetDemonData(this.data.demon_id)
		if (data) {
			Util.SetImageGray(this._img_icon, false)
			this._img_level_bg.visible = true
			this._lb_level.visible = true
			this._lb_level.text = "Lv" + data.level
			DemonModel.SetStars(this._gp_stars, data.star)
		} else {
			Util.SetImageGray(this._img_icon, true)
			this._img_level_bg.visible = false
			this._lb_level.visible = false
			DemonModel.SetStars(this._gp_stars, 0)
		}
	}

	public UpdateRedState() {
		let bool = false
		if (!this.demon_model.IsActive(this.data.demon_id)) {
			bool = this.demon_model.GetRedFlagState(DemonModel.RedFlag.Star, this.data.demon_id)
		} else {
			bool = this.demon_model.GetRedFlagState(DemonModel.RedFlag.Level, this.data.demon_id)
			if (!bool) {
				bool = this.demon_model.GetRedFlagState(DemonModel.RedFlag.Star, this.data.demon_id)
			}
			if (!bool) {
				bool = this.demon_model.GetRedFlagState(DemonModel.RedFlag.LifeSkill, this.data.demon_id)
			}
			if (!bool) {
				let talent_red_list = this.demon_model.GetRedFlagState(DemonModel.RedFlag.Talent, this.data.demon_id)

				if (talent_red_list) {
					for (let _ in talent_red_list) {
						let state = talent_red_list[_]
						let cond_star = this.demon_model.unlock_talent_slot_cond[_] || 0
						if (state && this.data.star >= cond_star) {
							bool = true
							break
						}
					}
				}
			}
		}
		this._img_red.visible = bool
	}

	public GetComponents() {
		[
			this._img_bg,
			this._gp_con,
			this._img_icon,
			this._img_name_bg,
			this._img_level_bg,
			this._lb_level,
			this._lb_name,
			this._gp_stars,
			this._img_tips,
			this._select,
			this._img_red,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_gp_con",
				"_img_icon",
				"_img_name_bg",
				"_img_level_bg",
				"_lb_level",
				"_lb_name",
				"_gp_stars",
				"_img_tips",
				"_select",
				"_img_red",
			])
		this._lb_name.style.fontSize=20
		this._lb_name.style.color="#ffffff"
	}
}
window["DemonTabItem"]=DemonTabItem