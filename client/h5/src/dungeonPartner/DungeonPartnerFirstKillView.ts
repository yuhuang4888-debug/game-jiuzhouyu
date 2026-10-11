import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { DungeonPartnerModel } from "../commonModel/DungeonPartnerModel"
import { PlatformManager } from "../PlatformManager"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { DungeonPartnerVsRewardItem } from "./DungeonPartnerVsRewardItem"

export class DungeonPartnerFirstKillView extends BaseView1 {

	click_pos
	data


	need_refresh_data
	model: DungeonPartnerModel
	res_mgr: ResManager
	item_list = []
	public constructor() {
		super()

		this.base_file = "dungeonPartner"
		this.layout_file = "DungeonPartnerFirstKillView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background2 = true
		this.click_bg_toClose = true
		this.background_alpha = 0

		this.model = DungeonPartnerModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()

		this.preload_server_config = {
			"config_boss_first_blood_plus_boss": false
		}
		this.load_callback = () => {
			this.InitEvent()
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._img_tips, GameResPath.GetIcon("dungeonPartner", "ui_copy_54"), true)
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

		let onClickBtnHandler = (e:Laya.Event) => {
			if (e.target == this._img_close) {
				this.Close()
			}
		}
		Util.AddClickEvent(this._img_close, onClickBtnHandler, this, true)
	}

	public Open(data?, click_pos?) {
		this.data = data
		this.click_pos = click_pos
		this.UpdateView()
		super.Open()
	}

	//data {dun_id, score}
	public UpdateView() {

		if (!this.is_loaded) {
			this.need_refresh_data = true
			return
		}
		let cfgs = this.res_mgr.GetGameConfigFromCache(this, "config_boss_first_blood_plus_boss", false)
		let cfg = cfgs[`97@1@${this.data.dun_id}`]
		let whole_first_blood_reward = ErlangParser.GetInstance().Parse(cfg.whole_first_blood_reward)

		let item
		for (let i = 0; i < whole_first_blood_reward.length; i++) {
			let v = whole_first_blood_reward[i]
			item = this.item_list[i]
			if(!item){
				item = new DungeonPartnerVsRewardItem(this._panel_reward)
				item.Load()
				this.item_list[i] = item
			}
			item.SetData({ is_finish: false, goods_vo: v })
			item.SetPosition(i * 90, 0)
		}

		this.display_obj.x = this.click_pos.x - this.display_obj.width / 2
		this.display_obj.y = this.click_pos.y - this.display_obj.height / 2
	}

	public Clear() {
		for (let i = 0; i < this.item_list.length; i++) {
			let v = this.item_list[i]
			v.DeleteMe()
		}
		this.item_list.length = 0
	}

	_img_bg: Laya.Image
	_img_bg2: Laya.Image
	_lb_title: Laya.Label
	_img_close: Laya.Image
	_img_tips: Laya.Image
	_panel_reward: Laya.Panel
	public GetComponents() {
		[
			this._img_bg,
			this._img_bg2,
			this._lb_title,
			this._img_close,
			this._img_tips,
			this._panel_reward,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_bg2",
				"_lb_title",
				"_img_close",
				"_img_tips",
				"_panel_reward",
			])
	}
}
window["DungeonPartnerFirstKillView"] = DungeonPartnerFirstKillView