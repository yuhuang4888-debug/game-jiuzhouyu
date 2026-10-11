import { BaseView1 } from "../common/BaseView1"
import { Config } from "../common/Config"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { DungeonPartnerModel } from "../commonModel/DungeonPartnerModel"
import { SceneManager } from "../scene/SceneManager"
import { Message } from "../sysInfo/SysInfoController"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { DungeonPartnerVsItem } from "./DungeonPartnerVsItem"

export class DungeonPartnerVsView extends BaseView1 {


	need_refresh_data
	model: DungeonPartnerModel
	res_mgr: ResManager
	item_list = []
	data

	public constructor() {
		super()

		this.base_file = "dungeonPartner"
		this.layout_file = "DungeonPartnerVsView"
		this.layer_value = Enum_UILayer.UI
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true

		this.model = DungeonPartnerModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()

		this.preload_client_config = {
			"ConfigDungeonClient": false,
		}

		this.preload_server_config = {
			"config_dungeon": false,
			"config_dungeon_wave": false
		}

		this.load_callback = () => {
			this._panel_item.vScrollBarSkin = ""

			this._html_need_lv.style.color = "#663915"
			this._html_need_lv.style.fontSize = 20
			this._html_need_lv.style.wordWrap = false
			this._html_need_lv.style.bold = true

			this.InitEvent()

			// ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg3, GameResPath.GetIcon("dungeonPartner", "ui_copy_53"))

			if (this.need_refresh_data) {
				this.UpdateView()
				this.need_refresh_data = null
			}
		}

		this.destroy_callback = () => {
			this.Clear()
		}
	}

	public InitEvent() {

		let onClickBtnHandler = () => {
				if (SceneManager.GetInstance().IsSuitBossScene()) {
					Message.show("当前场景不能进入")
					return
				}
			//先退出队伍
			if (!BaseDungeonModel.GetInstance().TryToEnterDungeon(this.data.dun_id)) return
				BaseDungeonModel.GetInstance().Fire(BaseDungeonModel.SCMD_REQUEST, 61001, this.data.dun_id)
				this.Close()
		}
		Util.AddClickEvent(this._box_vs, onClickBtnHandler, this, true)
		Util.AddClickEvent(this._img_close, ()=>{
			this.Close()
		}, this, true)
		this.BindEvent(BaseDungeonModel.GetInstance(), BaseDungeonModel.QUIT_DUNGEON_RETURN, (dun_id)=>{
			if(this.data&&this.data.dun_id==dun_id){
				onClickBtnHandler()
			}
		})
	}

	//data {dun_id, score}
	public Open(data?) {
		this.data = data
		this.UpdateView()
		super.Open()
	}

	public UpdateView() {

		if (!this.is_loaded) {
			this.need_refresh_data = true
			return
		}

		let item
		for (let i = 2; i >= 0; i--) {
			item = this.item_list[i]
			if (!item) {
				item = new DungeonPartnerVsItem(this._panel_item)
				item.Load()
				this.item_list[i] = item
			}
			item.SetData({ dun_id: this.data.dun_id, star: i + 1, is_finish: this.data.score >= (i + 1) })
			item.SetPosition(0, (i - 2) * -145)
		}

		let config_dungeon = this.res_mgr.GetGameConfigFromCache(this, "config_dungeon", false)
		this._html_need_lv.innerHTML = `等级需求:<font color='#0a953e'>${this.model.GetStageUnlockLv(this.data.dun_id)}</font>`

		let cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_dungeon.name, this.data.dun_id, false, config_dungeon)
		// this.txt_zhanli.text = "推荐战力:" + cfg.recommend_power
		let ConfigDungeonClient = this.res_mgr.GetGameConfigFromCache(this, "ConfigDungeonClient")
		this._lb_zhanli.text = "推荐战力:" + (ConfigDungeonClient.recommend_power[this.data.dun_id][Math.min(this.data.score, 2)])
		this._lb_title.text = cfg.name.trim()
		this._img_vs_red.visible = this.model.IsDungeonChallengeRedPoint(this.data.dun_id)
		this.CreateModel()
	}

	public CreateModel() {

		let config_dungeon = this.res_mgr.GetGameConfigFromCache(this, 'config_dungeon', false)
		let dun_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, this.data.dun_id, false, config_dungeon)

		let config_dungeon_wave = this.res_mgr.GetGameConfigFromCache(this, 'config_dungeon_wave', false)
		let cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_dungeon_wave.name, `${this.data.dun_id}@${dun_cfg.scene_id}@1@1`, false, config_dungeon_wave)

		if(cfg){
			let mon_list = ErlangParser.GetInstance().Parse(cfg.mon_list)
			let mon_id = mon_list[0][0]
			let mon_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, mon_id, false)
	
			let model_id = mon_cfg.icon
	
			let action_name_list = ["attack", "idle"]
			let data = {
				clothe_res_id: model_id,
				type: UI_MODEL_TYPE.MONSTER,
				action_name_list: action_name_list,
				layout_file: "DungeonPartnerVsView"
			}
			ResManager.GetInstance().SetRoleModel(this, this._gp_model_con, data)
		}
	}

	public Clear() {

		for (let i = 0; i < this.item_list.length; i++) {
			let v = this.item_list[i]
			v.DeleteMe()
		}
		this.item_list.length = 0
	}


	_img_bg: Laya.Image
	_img_close: Laya.Image
	_img_title: Laya.Image
	_lb_title2: Laya.Label
	_lb_title: Laya.Label
	_img_bg2: Laya.Image
	_box_vs: Laya.Box
	_img_vs: Laya.Image
	_lb_vs: Laya.Label
	_img_vs_red: Laya.Image
	_img_bg3: Laya.Image
	_gp_model_con: Laya.Box
	_html_need_lv: Laya.HTMLDivElement
	_lb_zhanli: Laya.Label
	_panel_item: Laya.Panel
	public GetComponents() {
		[
			this._img_bg,
			this._img_close,
			this._img_title,
			this._lb_title2,
			this._lb_title,
			this._img_bg2,
			this._box_vs,
			this._img_vs,
			this._lb_vs,
			this._img_vs_red,
			this._img_bg3,
			this._gp_model_con,
			this._html_need_lv,
			this._lb_zhanli,
			this._panel_item,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_close",
				"_img_title",
				"_lb_title2",
				"_lb_title",
				"_img_bg2",
				"_box_vs",
				"_img_vs",
				"_lb_vs",
				"_img_vs_red",
				"_img_bg3",
				"_gp_model_con",
				"_html_need_lv",
				"_lb_zhanli",
				"_panel_item",
			])
	}
}
window["DungeonPartnerVsView"] = DungeonPartnerVsView