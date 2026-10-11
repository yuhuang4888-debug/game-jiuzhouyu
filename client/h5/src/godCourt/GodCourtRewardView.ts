import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { Util } from "../util/Util"
import { GoodsModel } from "../commonModel/GoodsModel"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { GCRewardLopItem } from "./GCRewardLopItem"

export class GodCourtRewardView extends BaseView1 {
	LoadSuccess
	Open

	loop_mgr
	cfg_god_house_cr

	public constructor() {
		super()
		this.base_file = "godCourt"
		this.layout_file = "GodCourtRewardView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.preload_server_config = {
			"config_god_house_crystal": false
		}

		let _type_ = null
		let reward_config_ = null
		
		this.load_callback = () => {
			this.cfg_god_house_cr = ResManager.GetInstance().GetGameConfigFromCache(this, "config_god_house_crystal", false)
			this._item_scroller.vScrollBarSkin = ""
			this.LoadSuccess()
		}

		this.destroy_callback = () => {
			if(this.loop_mgr){
				this.loop_mgr.DeleteMe()
				this.loop_mgr = null
			}
		}

		this.Open = (...new_args) => {
			let parms = new_args
			if (parms) {
				_type_ = parms[0]
			}
			super.Open()
		}

		this.LoadSuccess = () => {
			reward_config_ = this.cfg_god_house_cr
			if (reward_config_ && reward_config_[_type_]) {
				let radomList = JSON.parse(reward_config_[_type_].random_reward)
				let radomList1 = JSON.parse(reward_config_[_type_].random_reward2)
				let list = []
				for (let _tmpi in radomList) {
					let vo = radomList[_tmpi]
					let goodsBasic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(vo[1])
					table.insert(list, [goodsBasic.color, goodsBasic.type_id, vo[2]])
				}
				for (let _tmpi in radomList1) {
					let vo = radomList1[_tmpi]
					let goodsBasic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(vo[1])
					table.insert(list, [goodsBasic.color, goodsBasic.type_id, vo[2]])
				}
				table.sort(list, (a?, b?) => {
					if (a[0] == b[0]) {
						return b[1] < a[1]
					} else {
						return b[0] < a[0]
					}
				})

				if (!this.loop_mgr){
					this.loop_mgr = new LoopScrowViewMgr()
					this.loop_mgr.SetData(this._item_scroller, GCRewardLopItem, list, LoopScrCon.Vertical)
				} else {
					this.loop_mgr.replaceAll(list)
				}
			}

			Util.AddClickEvent(this._btn_close, () => {
				this.Close()
			}, this, true)
		}
	}

	_img_bg1: Laya.Image
	_img_bg2: Laya.Image
	_btn_close: Laya.Image
	_img_title: Laya.Image
	_lb_title: Laya.Label
	_item_scroller: Laya.List
	public GetComponents() {
		[
			this._img_bg1,
			this._img_bg2,
			this._btn_close,
			this._img_title,
			this._lb_title,
			this._item_scroller,
		]
			= this.GetChildrenByNames([
				"_img_bg1",
				"_img_bg2",
				"_btn_close",
				"_img_title",
				"_lb_title",
				"_item_scroller",
			])
	}
}
window["GodCourtRewardView"] = GodCourtRewardView