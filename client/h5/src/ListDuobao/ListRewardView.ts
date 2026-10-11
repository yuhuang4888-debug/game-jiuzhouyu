import { BaseView1 } from "../common/BaseView1"
import { Config } from "../common/Config"
import { Util } from "../util/Util"
import { ResManager } from "../common/ResManager"
import { ListDuobaoModel } from "../commonModel/ListDuobaoModel"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { ListRewardItem } from "./ListRewardItem"
import { Enum_UILayer } from "../common/LayerManager"
import { table } from "../common/table"

export class ListRewardView extends BaseView1 {
	model
	res_mgr
	loop_mgr

	public constructor() {
		super()
		this.base_file = "listDuobao"
		this.layout_file = "ListRewardView"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.destroy_imm = true

		this.model = ListDuobaoModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()

		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvent()
		}
		
		this.open_callback = () => {
			this.InitView()
		}

		this.close_callback = () => {
			this.Remove()
		}
	}

	private Remove() {
		if (this.loop_mgr) {
			this.loop_mgr.DeleteMe()
			this.loop_mgr = null
		}
	}

	private LoadSuccess() {
		this.res_mgr.SetOutsideImageSprite(this, this._img_bg, "resource/game/listDuobao/other/ui_content_bg2.png")
		this._gp_reward.vScrollBarSkin = ""
	}

	private InitEvent() {
		Util.AddClickEvent(this._btn_close, () => {
			this.Close()
		}, this, true)
	}

	private InitView() {
		let cfg = Config.PRELOAD_SERVER_CONFIG.config_rush_treasure_stage_reward
		if (!cfg) {
			return
		}
		let base_type = this.model.base_type
		let sub_type = this.model.sub_type
		let list = []
		for(let i in cfg) {
			let vo = cfg[i]
			if (vo.type = base_type && vo.sub_type == sub_type) {
				let type = this.model.CheckStageTypeById(vo.reward_id)
				list.push([vo, type])
			}
		}
		table.sort(list, (a, b) => {
			let x = a[1] == 2 ? 1 : 0
			let y = b[1] == 2 ? 1 : 0
			return x < y
		})
		if (!this.loop_mgr) {
			this.loop_mgr = new LoopScrowViewMgr()
			this.loop_mgr.SetData(this._gp_reward, ListRewardItem, list, LoopScrCon.Vertical)
		} else {
			this.loop_mgr.replaceAll(list)
		}
	}

	_img_bg: Laya.Image
	_img_bg2: Laya.Image
	_btn_close: Laya.Image
	_img_title: Laya.Image
	_gp_reward: Laya.List
	public GetComponents() {
		[
			this._img_bg,
			this._img_bg2,
			this._btn_close,
			this._img_title,
			this._gp_reward,
		]
			= this.GetChildrenByNames([
				"_img_bg",
				"_img_bg2",
				"_btn_close",
				"_img_title",
				"_gp_reward",
			])
	}
}
window["ListRewardView"] = ListRewardView