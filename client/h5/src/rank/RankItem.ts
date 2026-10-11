import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { DressModel, DressType } from "../commonModel/DressModel"
import { FriendModel, FriendEvent } from "../commonModel/FriendModel"
import { RankModel, RankModelEvent, RANK_CONFIG } from "../commonModel/RankModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Util, SetSizeDeltaX, SetLocalScaleX, SetLocalScaleY, SetSizeDelta, RefBoxChildsLayout } from "../util/Util"
import { Config } from "../common/Config"
import { WordManager } from "../common/WordManager"
import { Point } from "../scene/AstarManager"
import { GameResPath } from "../util/GameResPath"
import { MedalModel } from "../commonModel/MedalModel"
export class RankItem extends BaseItemRenderer {

	_fmodel
	_model
	role_id
	_playerHead_item


	public static width = 555
	public static height = 115
	public constructor(parent) {
		super()


		this.role_id = 0;
		this.base_file = "rank"
		this.layout_file = "RankItem"
		this._model = RankModel.GetInstance()
		this._fmodel = FriendModel.GetInstance()
		this.WIDTH = 550
		this.HEIGT = 97
		// this.load_callback = () => {

		// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
		// 	this._value_title_label.size  = 20
		// 	this._turn_label.size  = 20
		// 	this._fight_label.size  = 20
		// }

		//lua_resM:SetOutsideImageSprite(this, this._bg, GameResPath.GetIcon("rank","uilwfb_029"),true)
		//this:dataChanged()
		// }
		this.Load()
	}

	public load_callback() {
		this._playerHead_item = new CustomHeadItem(this._playerHead)
		this._playerHead_item.Load()
		this._playerHead_item.SetActiveBg(false)
		this._playerHead_item.SetActiveLevel(false)
		this._playerHead_item.ExcuteCallback(() => {
			this._playerHead_item.SetScale(0.8)
		})
		this.InitEvents()
	}

	public InitEvents() {

		Util.AddClickEvent(this._img_click, (target?, x?, y?) => {
			let point = new Laya.Point(this.mouseX, this.mouseY)
			this.localToGlobal(point)
			this.touchHandler(point.x, point.y)
		}, this)

		this.BindEvent(this._fmodel, FriendEvent.MENU_DATA_UPDTE, (id?) => {
			if (this.role_id && id == this.role_id) {
				this.checkMenu(id)
			}
		})
	}

	public dataChanged() {
		if (!super.dataChanged()) return
		// if(this.data.player_id==0){
		// 	this._info_group.visible=false
		// 	this._null_label.visible=true
		// 	this._rank_label.text=this.data.rank
		// 	return	
		// }
		this.role_id = null
		let rank = this.data.rank
		let type = this._model.rank_type
		this._rank_label.text = String(rank)
		this._rank_icon.visible = rank <= 3

		this._img_medal.visible = this._vip_icon.visible = this.title_gp.visible = false

		ResManager.GetInstance().SetTexture(this.base_item, this._bg, GameResPath.GetIcon("rank", "ui_task_05"), null, null, true)
		if (rank <= 3) {
			ResManager.GetInstance().SetImageSprite(this, this._rank_icon, "rank_asset", "rank_icon_" + rank + "", true)
		}
		this._null_label.visible = this.data.player_id == 0
		this._info_group.visible = !this._null_label.visible
		if (this._info_group.visible) {
			this.role_id = type == RankModel.RANK_TYPE.GUILD && this.data.chairman_id || this.data.player_id
			this._name_label.text = this.data.name
			let fight_label = ""
			if (type == RankModel.RANK_TYPE.FIGHT) {
				// this._Group4.visible=true
				// this._Group6.visible=false
				this._fight_label.text = this.data.first_value
				// }else{
				// 	this._Group6.visible=true
				// 	this._Group4.visible=false
			}
			if (type == RankModel.RANK_TYPE.NOBILITY) {
				// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
				// 	fight_label = "Lv." + this.data.first_value
				// }else{
				fight_label = this.data.first_value + "级"
				// }
			} else if (type == RankModel.RANK_TYPE.ONHOOK) {
				fight_label = WordManager.ConvertNum(this.data.first_value, true) + "/分"
			} else {
				let lv = this.data.first_value > 370 && this.data.first_value - 370 || this.data.first_value

				// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
				// 	fight_label = type == RankModel.RANK_TYPE.LEVEL && "Lv." + lv || this.data.first_value
				// }else{
				fight_label = type == RankModel.RANK_TYPE.LEVEL && lv + "级" || this.data.first_value
				// }

			}
			SetSizeDeltaX(this.destiny_img, type == RankModel.RANK_TYPE.LEVEL && this.data.first_value > 370 && 23 || 0)
			this._turn_label.text = type == RankModel.RANK_TYPE.LEVEL && this.data.turn > 0 && "【" + this.data.turn + "转】" || ""
			this._fight_label.text = fight_label
			let vip_Lv = this.data.vip_flag
			this._vip_icon.visible = vip_Lv > 0
			let supreme_vip = this.data.supreme_vip > 0
			if (this._vip_icon.visible) {
				if(this.data.is_hide_vip){
					if (supreme_vip) {
						ResManager.GetInstance().SetImageSprite(this, this._vip_icon, "mainUI_asset", "SVIP-x", true)
					} else {
						ResManager.GetInstance().SetImageSprite(this, this._vip_icon, "mainUI_asset", "VIP-x", true)
					}
				}
				else{
					if (supreme_vip) {
						ResManager.GetInstance().SetImageSprite(this, this._vip_icon, "mainUI_asset", "VIP_" + vip_Lv + "", true)
					} else {
						ResManager.GetInstance().SetImageSprite(this, this._vip_icon, "mainUI_asset", "uivip_zjm_" + vip_Lv + "", true)
					}
				}
			}

			this._playerHead_item.SetData(this.data.player_id, this.data.career, this.data.sex, this.data.picture, this.data.picture_ver)

			let is_show_tj = this.data.title_id && this.data.title_id > 0
			this.base_item.ClearUIEffect(this.title_gp)
			if (is_show_tj) {
				this._img_medal.visible = false
				let title_id = this.data.title_id
				let title_cfg = Config.PRELOAD_CLIENT_CONFIG.ClientTitleNameBordWidth[title_id]

				let config_title_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_title_cfg", false)
				let cfg = config_title_cfg && config_title_cfg[title_id + "@0"]
				if (cfg && title_cfg) {

					let eff_id = title_id - 1000
					let pos
					let scale = 8
					let w = title_cfg.width
					if (title_cfg) {
						pos = { x: eff_id <= 5 ? -2 : 0, y: 0 }
						scale = title_cfg.scale
					}
					SetSizeDelta(this.title_gp, eff_id <= 5 ? w - 8 : w, title_cfg.height)
					let eff_url = MedalModel.GetInstance().GetTitleEffetName(eff_id)
					this.title_gp.visible = true
					this.base_item.AddUIEffect(eff_url, this.title_gp, pos, scale, true)
				}

			} else {
				this.title_gp.visible = false
				if (this.data.medal_id && this.data.medal_id > 0) {
					let config_medal = RankModel.GetInstance().config[RANK_CONFIG.MEDAL]
					let cfg = config_medal[this.data.medal_id]
					if (cfg && cfg.title > 0) {
						this._img_medal.visible = true
						ResManager.GetInstance().SetImageSprite(this, this._img_medal, "mainUI_asset", "tx_" + cfg.title + "", true)
					}
				}

			}
			RefBoxChildsLayout(this._Group3, 12, null, true, "left")
		}
		this._value_title_label.text = this._model.getNameByType(type) + ":"

	}

	public touchHandler(x?, y?) {

		if (this._info_group.visible) {
			this._fmodel.Fire(FriendEvent.REQUEST_MENU_DATA, this.role_id, x, y)
		}
	}

	public checkMenu(id?) {

		if (id == RoleManager.GetInstance().GetMainRoleId()) {
			return
		}
		let data = this._fmodel.getMenuData(this.role_id)
		let point = data.point
		let isPicture = Number(this.data.picture) == this.role_id
		this._model.Fire(RankModelEvent.OPEN_MENU_VIEW, point, this.role_id, null, null, isPicture)
	}

	public DeleteMe() {
		this.base_item.ClearUIEffect(this.title_gp)
		if (this._playerHead_item) {
			this._playerHead_item.DeleteMe()
			this._playerHead_item = null
		}

		super.DeleteMe()
	}

	_bg: Laya.Image
	_Group1: Laya.Box
	_Image1: Laya.Image
	_rank_label: Laya.Label
	_rank_icon: Laya.Image
	_info_group: Laya.Box
	_Group3: Laya.Box
	_vip_icon: Laya.Image
	title_gp: Laya.Box
	_img_medal: Laya.Image
	_name_label: Laya.Label
	_Group5: Laya.Box
	_Group6: Laya.HBox
	_value_title_label: Laya.Label
	_turn_label: Laya.Label
	destiny_img: Laya.Image
	_fight_label: Laya.Label
	_playerHead: Laya.Box
	_null_label: Laya.Label
	_img_click: Laya.Image
	public GetComponents() {
		[
			this._bg,
			this._Group1,
			this._Image1,
			this._rank_label,
			this._rank_icon,
			this._info_group,
			this._Group3,
			this._vip_icon,
			this.title_gp,
			this._img_medal,
			this._name_label,
			this._Group5,
			this._Group6,
			this._value_title_label,
			this._turn_label,
			this.destiny_img,
			this._fight_label,
			this._playerHead,
			this._null_label,
			this._img_click,
		]
			= this.GetChildrenByNames([

				"_bg",
				"_Group1",
				"_Image1",
				"_rank_label",
				"_rank_icon",
				"_info_group",
				"_Group3",
				"_vip_icon",
				"title_gp",
				"_img_medal",
				"_name_label",
				"_Group5",
				"_Group6",
				"_value_title_label",
				"_turn_label",
				"destiny_img",
				"_fight_label",
				"_playerHead",
				"_null_label",
				"_img_click",
			])
	}
}
window["RankItem"] = RankItem