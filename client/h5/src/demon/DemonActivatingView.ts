import { BaseView1 } from "../common/BaseView1";
import { Config } from "../common/Config";
import { FightingShowSmallItem } from "../common/FightingShowSmallItem";
import { Enum_UILayer } from "../common/LayerManager";
import { ResManager } from "../common/ResManager";
import { UI_MODEL_TYPE } from "../common/UIModelClass3D";
import { UnrealToolTips } from "../common/UnrealToolTips";
import { WordManager } from "../common/WordManager";
import { DemonModel } from "../commonModel/DemonModel";
import { ErlangParser } from "../util/ErlangParser";
import { GameResPath } from "../util/GameResPath";
import { TimeUtil } from "../util/TimeUtil";
import { HtmlColorTxt, Util, GlobalTimerQuest } from "../util/Util";

export class DemonActivatingView extends BaseView1 {
	_Group1: Laya.Box
	_gp_effect0: Laya.Box
	_img_bg1: Laya.Image
	_gp_effect: Laya.Box
	_gp_model: Laya.Box
	_Image1: Laya.Image
	_Image2: Laya.Image
	_img_title: Laya.Image
	_img_name: Laya.Image
	_lb_name: Laya.Label
	_fight_show_con: Laya.Box
	_gp_star_up: Laya.Box
	_img_bg: Laya.Image
	_img_bg0: Laya.Image
	_gp_stars: Laya.Box
	_lb_attr0: Laya.HTMLDivElement
	_lb_attr1: Laya.HTMLDivElement
	_lb_count_down: Laya.Label
	click: 	Laya.Image


	data
	demon_model
	fighting_show_item
	left_time
	show_model
	time_func
	time_id
	res_mgr: ResManager

	public constructor() {
		super()

		this.base_file = "demon"
		this.layout_file = "DemonActivatingView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.is_center = true
		this.change_scene_close = true
		this.use_background = true
		this.click_bg_toClose = true
		this.demon_model = DemonModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()

		this.left_time = 10
		this.time_id = null
		this.time_func = null
		this.data = null
		this.show_model = null

		this.preload_server_config = {
			"config_demons": false,
			"config_demons_star": false
		}

		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvent()
		}

		this.open_callback = () => {
			if (!this.fighting_show_item) {
                this.fighting_show_item = new FightingShowSmallItem(this._fight_show_con)
                this.fighting_show_item.Load()
            }
            this.fighting_show_item.Updatefighting(this.data.power)
		}

		// this.ReOpen_callback = () => {
		// 	let demons_cfg = Config.Demons && Config.Demons[this.data.demons_id]
		// 	if (demons_cfg) {
		// 		this.ShowModel(demons_cfg.resource, demons_cfg.scale)
		// 	}
		// }

		this.destroy_callback = () => {
			this.Remove()
		}
	}

	public InitEvent() {
		Util.AddClickEvent(this.click,()=>{
			this.Remove()
			this.Close()
		},this,false)
	}

	public LoadSuccess() {
		this.res_mgr.SetTexture(this, this._img_bg, GameResPath.GetIcon("demon", "ui_shape_29"))
		// this.res_mgr.SetTexture(this, this._img_bg0, GameResPath.GetIcon("demon", "uijs_041"))
		this.res_mgr.SetTexture(this, this._img_bg1, GameResPath.GetIcon("demon", "ui_shape_28"))
		// this.AddUIEffect("ui_Pokemon_arrary2", this._gp_effect, null, null, true)
		// this.AddUIEffect("ui_Background_glow", this._gp_effect0, null, null, true)
		let is_activation = this.data.star == 0
		this.res_mgr.SetTexture(this, this._img_title, "resource/game/demon/texture/" + (is_activation ? "uijs_046.png" : "uijs_039.png"))
		//this._gp_star_up.visible = ! is_activation 

		DemonModel.SetStars(this._gp_stars, this.data.star, 39, 6)
		// this.res_mgr.SetTexture(this, this._img_name, "resource/game/demon/texture/demon_name/" + this.data.demons_id + ".png")

		let demons_cfgs = this.res_mgr.GetGameConfigFromCache(this, "config_demons", false)
		let demons_cfg = demons_cfgs && demons_cfgs[this.data.demons_id]
		if (demons_cfg) {
			this._lb_name.text=demons_cfg.demons_name
			this.ShowModel(demons_cfg.resource, demons_cfg.scale)
		}
		//let group_height = this._gp_star_up.sizeDelta.y
		//if (! is_activation ) {
		let demons_star_cfgs = this.res_mgr.GetGameConfigFromCache(this, "config_demons_star", false)
		let now_demons_star_cfg = demons_star_cfgs && demons_star_cfgs[this.data.demons_id + "@" + this.data.star]
		if (now_demons_star_cfg) {
			let now_attr_list = JSON.parse(now_demons_star_cfg.attr)
			let attr0 = ""
			let attr1 = ""
			let index = 0
			for (let _tmpi in now_attr_list) {
				let vo = now_attr_list[_tmpi]
				if (index % 2 == 0) {
					attr0 = attr0 + WordManager.GetProperties(vo[0]) + ":"
					attr0 = attr0 + HtmlColorTxt(WordManager.ConvertToPercentValue(vo[0], vo[1]), "'#d15e00'") + "<br/>"
				} else {
					attr1 = attr1 + WordManager.GetProperties(vo[0]) + ":"
					attr1 = attr1 + HtmlColorTxt(WordManager.ConvertToPercentValue(vo[0], vo[1]), "'#d15e00'") + "<br/>"
				}
				index = index + 1
			}
			this._lb_attr0.width=200
			this._lb_attr1.width=200
			this._lb_attr0.innerHTML = Util.StrToHTML(attr0)
			this._lb_attr1.innerHTML = Util.StrToHTML(attr1)

		}
		let end_time = TimeUtil.getServerTime() + this.left_time
		this.StartTime(() => {
			let left_time = end_time - TimeUtil.getServerTime()
			if (left_time < 0) {
				this.CancelTime()
				this.Close()
				return
			}
			// if(!this._lb_count_down || left_time) return
			this._lb_count_down.text = left_time + "秒后自动关闭"
		})
	}

	public StartTime(time_func?) {
		this.CancelTime()
		this.time_func = time_func
		Laya.timer.loop(1000,this,this.time_func)
		time_func()
	}

	public CancelTime() {
		// if (this.time_id) {
			// this.time_id.stop()
			// this.time_id.removeEventListener(Laya.TimerEvent.TIMER, this.time_func, this)
			// this.time_id = undefined
			// this.time_func = undefined
			Laya.timer.clearAll(this)
		// }
	}

	public ShowModel(mon_res?, scale?) {
		let data = {
			clothe_res_id: mon_res,
			type: UI_MODEL_TYPE.DEMON,
			layer_value: this.layer_value,
			action_name_list: ["idle"],
			scale: 1.5,
			can_rotate: true,
		}
		ResManager.GetInstance().SetRoleModel(this, this._gp_model, data)
	}

	public Remove() {
		this.CancelTime()
		if (this.fighting_show_item) {
			this.fighting_show_item.DeleteMe()
			this.fighting_show_item = false
		}
	}

	public Open(...parms) {
		this.data = parms[0]
		super.Open()
	}

	public GetComponents() {
		[
			this._Group1,
			this._gp_effect0,
			this._img_bg1,
			this._gp_effect,
			this._gp_model,
			this._Image1,
			this._Image2,
			this._img_title,
			this._img_name,
			this._lb_name,
			this._fight_show_con,
			this._gp_star_up,
			this._img_bg,
			this._img_bg0,
			this._gp_stars,
			this._lb_attr0,
			this._lb_attr1,
			this._lb_count_down,
			this.click,
		]
			= this.GetChildrenByNames([

				"_Group1",
				"_gp_effect0",
				"_img_bg1",
				"_gp_effect",
				"_gp_model",
				"_Image1",
				"_Image2",
				"_img_title",
				"_img_name",
				"_lb_name",
				"_fight_show_con",
				"_gp_star_up",
				"_img_bg",
				"_img_bg0",
				"_gp_stars",
				"_lb_attr0",
				"_lb_attr1",
				"_lb_count_down",
				"click"
			])
		this._lb_attr0.style.fontSize=22
		this._lb_attr0.style.color="#663915"
		this._lb_attr0.style.leading=5
		this._lb_attr1.style.fontSize=22
		this._lb_attr1.style.color="#663915"
		this._lb_attr1.style.leading=5
	}
}
window["DemonActivatingView"]=DemonActivatingView