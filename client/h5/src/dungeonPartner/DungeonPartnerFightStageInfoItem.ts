import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { ResManager } from "../common/ResManager"
import { DungeonPartnerModel } from "../commonModel/DungeonPartnerModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ErlangParser } from "../util/ErlangParser"
import { DungeonPartnerVsRewardItem } from "./DungeonPartnerVsRewardItem"

export class DungeonPartnerFightStageInfoItem extends BaseItem1 {


	data
	need_refresh_data
	model: DungeonPartnerModel
	item_list = []
	public constructor(parent) {
		super(parent)

		this.base_file = "dungeonPartner"
		this.layout_file = "DungeonPartnerFightStageInfoItem"
		this.model = DungeonPartnerModel.GetInstance()
		this.is_delay_callback = false

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


	}

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
		let config_dungeon_grade = Config.PRELOAD_SERVER_CONFIG.config_dungeon_grade
		let cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_dungeon_grade.name, this.data.dun_id + "@" + this.data.star + "@" + this.data.star, false, config_dungeon_grade)
		if(cfg)
		{
			let reward_list = ErlangParser.GetInstance().Parse(cfg.reward)
	
			let item, v
			for (let i = 0; i < reward_list.length; i++) {
				v = reward_list[i]
				item = this.item_list[i]
				if (!item) {
					item = new DungeonPartnerVsRewardItem(this._panel_reward)
					item.Load()
					this.item_list[i] = item
				}
				item.SetData({ is_finish: this.data.is_finish, goods_vo: v, size: 60 })
				item.SetPosition(65 * i, 0)
			}
		}
	}

	public DeleteMe() {
		for (let i = 0; i < this.item_list.length; i++) {
			let v = this.item_list[i]
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
window["DungeonPartnerFightStageInfoItem"] = DungeonPartnerFightStageInfoItem
