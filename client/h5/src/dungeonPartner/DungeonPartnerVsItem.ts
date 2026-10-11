import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { DungeonPartnerModel } from "../commonModel/DungeonPartnerModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ErlangParser } from "../util/ErlangParser"
import { DungeonPartnerVsRewardItem } from "./DungeonPartnerVsRewardItem"

export class DungeonPartnerVsItem extends BaseItem1 {

	model: DungeonPartnerModel
	item_list = []
	need_refresh_data
	data

	public constructor(parent) {
		super(parent)

		this.base_file = "dungeonPartner"
		this.layout_file = "DungeonPartnerVsItem"
		this.layer_value = Enum_UILayer.UI

		this.model = DungeonPartnerModel.GetInstance()
		this.load_callback = () => {
			this.LoadSuccess()
		}
	}

	public LoadSuccess() {
		this._panel_reward.hScrollBarSkin = ""
		this.InitEvent()

		if (this.need_refresh_data) {
			this.UpdateItem()
			this.need_refresh_data = null
		}

	}


	public InitEvent() {

		let onClickBtnHandler = (target, x, y) => {
			// if (target == this.form || target == this.btn_vs ) {
			// 	GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DungeonPartnerVsView")
			// }
		}
		// Util.AddClickEvent(this.form, onClickBtnHandler)
		// Util.AddClickEvent(this.btn_vs, onClickBtnHandler)
	}

	//{dun_id, star, is_finish}
	public SetData(data?) {

		this.data = data
		if (this.is_loaded) {
			this.UpdateItem()
		} else {
			this.need_refresh_data = true
		}
	}

	public UpdateItem() {

		this._lb_title.text = `首次${this.data.star}星通关`
		let cfgs = Config.PRELOAD_SERVER_CONFIG.config_dungeon_grade
		let cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_dungeon_grade.name, `${this.data.dun_id}@${this.data.star}@${this.data.star}`, false, cfgs)

		let reward_list = ErlangParser.GetInstance().Parse(cfg.reward)
		let goods_model = GoodsModel.GetInstance()

		let item, v
		for (let i = 0; i < reward_list.length; i++) {
			v = reward_list[i]
			item = this.item_list[i]
			if(!item){
				item = new DungeonPartnerVsRewardItem(this._panel_reward)
				item.Load()
				this.item_list[i] = item
			}
			item.SetData({ is_finish: this.data.is_finish, goods_vo: v })
			item.SetPosition(i * 87, 0)
		}
	}

	public DeleteMe() {
		let v
		for (let i = 0; i < this.item_list.length; i++) {
			v = this.item_list[i]
			v.DeleteMe()
		}
		this.item_list.length = 0
		super.DeleteMe()
	}

	_img_bg: Laya.Image
	_lb_title: Laya.Label
	_panel_reward: Laya.Panel
	public GetComponents() {
		[
			this._img_bg,
			this._lb_title,
			this._panel_reward,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_lb_title",
				"_panel_reward",
			])
	}
}

window["DungeonPartnerVsItem"] = DungeonPartnerVsItem
