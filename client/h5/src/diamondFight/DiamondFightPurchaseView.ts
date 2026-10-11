import { Alert, Alert_Type } from "../alert/Alert"
import { BaseView1 } from "../common/BaseView1"
import { Config } from "../common/Config"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { LuaSoundManager } from "../common/SoundManager"
import { DiamondFightModel } from "../commonModel/DiamondFightModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { GameResPath } from "../util/GameResPath"
import { NotEnougnDiamond, Util } from "../util/Util"

export class DiamondFightPurchaseView extends BaseView1 {

	diamond_fight_model: DiamondFightModel
	goods_model: GoodsModel
	role_mgr: RoleManager
	res_mgr: ResManager

	public constructor() {
		super()

		this.base_file = "diamondFight"
		this.layout_file = "DiamondFightPurchaseView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.show_open_movie = true
		this.change_scene_close = true
		this.click_bg_toClose = true
		this.use_background = true
		this.is_center = true

		this.diamond_fight_model = DiamondFightModel.GetInstance()
		this.goods_model = GoodsModel.GetInstance()
		this.role_mgr = RoleManager.GetInstance()
		this.res_mgr = ResManager.GetInstance()

		this.preload_server_config = {
			"config_drumwar_value": false
		}
		this.load_callback = () => {
			this.LoadSuccess()
		}
	}

	public InitEvent() {


		this.BindEvent(this.goods_model, GoodsModel.UPDATE_GOODS_NUM, (goods_list?) => {
			if (this.use_delete_method) {
				return
			}
			for (let _tmpi in goods_list) {
				var vo = goods_list[_tmpi]
				if (vo.type_id == DiamondFightModel.TICKET_ID) {
					this._lb_count1.text = "x" + this.goods_model.GetTypeGoodsNum(DiamondFightModel.TICKET_ID)
					this.UpdateCost()
					break
				}
			}
		})

		this.BindEvent(this.diamond_fight_model, DiamondFightModel.UPDATE_LIFE, (life?) => {
			this.SetLive(life)
		})

		this.BindVar(this.role_mgr.GetMainRoleVo(), "jin", (event_name?, value?) => {
			this._lb_count2.text = "x" + value
			this.UpdateCost()
		})

		Util.AddClickEvent(this._box_buy, () => {
			let info = this.diamond_fight_model.waiting_info
			if (info.life_num == 3) {
				Message.show("您已达到命数上限，无需购买~")
				return
			}
			let check_ticket = () => {
				return this.goods_model.GetTypeGoodsNum(DiamondFightModel.TICKET_ID) == 0
			}

			let buy_func = () => {
				this.diamond_fight_model.Fire(DiamondFightModel.REQUEST_SCMD, 13706, 1)
			}

			if (check_ticket()) {
				let config_drumwar_value = this.res_mgr.GetGameConfigFromCache(this, "config_drumwar_value", false)
				let cost = this.diamond_fight_model.GetValueByKey(5, config_drumwar_value)
				let jin = this.role_mgr.GetMainRoleVo().jin
				if (jin < cost) {
					NotEnougnDiamond()
					return
				}
				Alert.Show(`是否用<font color='#d15e00'>${cost}勾玉</font>购买命数～？`, Alert_Type.Two, () => {
					buy_func()
				}, null, "确定", "取消")
			} else {
				buy_func()
			}
		}, this, true)

		Util.AddClickEvent(this._img_close,() => {
			this.Close()
		}, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)

	}

	public LoadSuccess() {


		//resource/game/suitActivity/texture/ui_sstz_004.png
		this.res_mgr.SetOutsideImageSprite(this, this._img_bg5, GameResPath.GetIcon("suitActivity", "ui_sstz_004"))

		this.res_mgr.SetOutsideImageSprite(this, this._img_icon1, GameResPath.GetGoodsIconPath(DiamondFightModel.TICKET_ID),true)
		let icon = Config.PRELOAD_CLIENT_CONFIG.ConfigNotNormalGoods[1].goods_id
		this.res_mgr.SetOutsideImageSprite(this, this._img_icon2, GameResPath.GetGoodsIconPath(icon),true)
		
		let scale = 0.35
		this._img_icon1.scale(scale,scale)
		this._img_icon2.scale(scale,scale)
		this._img_icon.scale(scale,scale)

		this["_lb_count1"].text = "x" + this.goods_model.GetTypeGoodsNum(DiamondFightModel.TICKET_ID)
		this["_lb_count2"].text = "x" + this.role_mgr.GetMainRoleVo().jin

		this.InitEvent()
		this.UpdateView()
	}

	public UpdateView() {

		let info = this.diamond_fight_model.waiting_info
		if (!info) {
			return
		}
		this.SetLive(info.life_num)
		this.UpdateCost()
	}

	public UpdateCost() {

		let ticket_num = this.goods_model.GetTypeGoodsNum(DiamondFightModel.TICKET_ID)
		if (ticket_num > 0) {
			this.res_mgr.SetOutsideImageSprite(this, this["_img_icon"], GameResPath.GetGoodsIconPath(DiamondFightModel.TICKET_ID),true)
			this._lb_count.text = "x1"
		} else {
			let config_drumwar_value = this.res_mgr.GetGameConfigFromCache(this, "config_drumwar_value", false)
			let icon = Config.PRELOAD_CLIENT_CONFIG.ConfigNotNormalGoods[1].goods_id
			this.res_mgr.SetOutsideImageSprite(this, this["_img_icon"], GameResPath.GetGoodsIconPath(icon),true)
			this._lb_count.text = "x" + this.diamond_fight_model.GetValueByKey(5, config_drumwar_value)
		}
	}

	public SetLive(life?) {

		let i = 0
		do {
			this.res_mgr.SetImageSprite(this, this["_img_heart" + i], "diamondFight", i < life && "uizsdz_010a" || "uizsdz_010b")
			i = i + 1
		} while ((i < 3))
	}



	_img_bg: Laya.Image
	_img_bg2: Laya.Image
	_img_bg3: Laya.Image
	_img_bg4: Laya.Image
	_img_bg5: Laya.Image
	_lb_title: Laya.Label
	_lb_desc: Laya.Label
	_html_desc: Laya.HTMLDivElement
	_lb_tips: Laya.Label
	_box_heart: Laya.HBox
	_img_heart0: Laya.Image
	_img_heart1: Laya.Image
	_img_heart2: Laya.Image
	_box_buy: Laya.Box
	_img_buy: Laya.Image
	_lb_buy: Laya.Label
	_img_icon: Laya.Image
	_lb_count: Laya.Label
	_img_icon1: Laya.Image
	_lb_count1: Laya.Label
	_img_icon2: Laya.Image
	_lb_count2: Laya.Label
	_img_close: Laya.Image
	public GetComponents() {
		[
			this._img_bg,
			this._img_bg2,
			this._img_bg3,
			this._img_bg4,
			this._img_bg5,
			this._lb_title,
			this._lb_desc,
			this._html_desc,
			this._lb_tips,
			this._box_heart,
			this._img_heart0,
			this._img_heart1,
			this._img_heart2,
			this._box_buy,
			this._img_buy,
			this._lb_buy,
			this._img_icon,
			this._lb_count,
			this._img_icon1,
			this._lb_count1,
			this._img_icon2,
			this._lb_count2,
			this._img_close,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_bg2",
				"_img_bg3",
				"_img_bg4",
				"_img_bg5",
				"_lb_title",
				"_lb_desc",
				"_html_desc",
				"_lb_tips",
				"_box_heart",
				"_img_heart0",
				"_img_heart1",
				"_img_heart2",
				"_box_buy",
				"_img_buy",
				"_lb_buy",
				"_img_icon",
				"_lb_count",
				"_img_icon1",
				"_lb_count1",
				"_img_icon2",
				"_lb_count2",
				"_img_close",
			])
	}
}
window["DiamondFightPurchaseView"] = DiamondFightPurchaseView
