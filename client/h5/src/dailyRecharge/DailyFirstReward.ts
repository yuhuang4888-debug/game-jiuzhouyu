import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { GameResPath } from "../util/GameResPath"
import { GetSizeDeltaX, Util } from "../util/Util"
import { DailyFirstRewardItem } from "./DailyFirstRewardItem"

export class DailyFirstReward extends BaseItem1 {
	_lb_dec: Laya.HTMLDivElement
	_Image1: Laya.Image
	_img_progress: Laya.Image
	_gp_reward: Laya.HBox
	money:Laya.Image
	InitRewardItem
	InitView
	SetData
	UpdateProgress
	UpdateView
	_reward_list

	public constructor(parent?) {
		super(parent)


		let _progress_mask = null
		let _data = null
		this._reward_list = []
		let _base_type = null
		let _sub_type = null
		this.base_file = "dailyRecharge"
		this.layout_file = "DailyFirstReward"
		this.load_callback = () => {
			this.InitView()
			this._lb_dec.visible = false
		}

		this.InitView = () => {

			// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
			// 	this._lb_dec.size  = 18
			// }
			// if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
			// 	this._lb_dec.size  = 16
			// 	this._lb_dec.lineSpacing = 0.8
			// 	SetSizeDeltaX(this._lb_dec, 410)
			// }
			ResManager.GetInstance().SetImageSpriteTrans(this, this._Image1, GameResPath.GetIcon("dailyRecharge", "mrsc_007a"))
			ResManager.GetInstance().SetImageSpriteTrans(this, this._img_progress, GameResPath.GetIcon("dailyRecharge", "mrsc_007b"))
		}

		this.SetData = (data?, base_type?, sub_type?) => {
			_data = data
			_base_type = base_type
			_sub_type = sub_type
			if (_data && _data[0]) {

				// if (PlatformMgr.GetInstance().IsEyouIdnPlatform() ) {
				// 	this._lb_dec.textFlow = Util.StrToHTML("Topup <font color='b3ff48'.length>" + _data[0].gold_num + "</font> berlian scr berturut-turut setiap hari utk dapatkan hadiah berikut")
				// }else{
				// this._lb_dec.style.fontSize = 22
				// //this._lb_refresh_time.style.valign = "center"
				// this._lb_dec.style.color = "#ffffff"
				// this._lb_dec.width = 500
				// this._lb_dec.innerHTML = Util.StrToHTML("连续每天充值<font color='#b3ff48'>" + _data[0].gold_num + "</font>钻石，即可领取以下奖励")
				//}
				ResManager.GetInstance().SetImageSprite(this, this.money, "dailyRecharge_asset", _data[0].gold_num)
				this.InitRewardItem(_data, base_type, sub_type)
				this.UpdateProgress(_data)
			}
		}

		this.InitRewardItem = (data?, base_type?, sub_type?) => {
			for (let index in data) {

				// [ts2lua]this._reward_list下标访问可能不正确
				let item = this._reward_list[index]
				if (!item) {
					item = new DailyFirstRewardItem(this._gp_reward)
					item.Load()
					table.insert(this._reward_list, item)
				}
				item.ExcuteCallback(() => {
					// [ts2lua]data下标访问可能不正确
					item.SetData(base_type, sub_type, data[index])
				}
				)
			}
		}

		this.UpdateView = (data?, base_type?, sub_type?) => {
			if (data) {
				for (let index in this._reward_list) {

					// [ts2lua]this._reward_list下标访问可能不正确
					// [ts2lua]data下标访问可能不正确
					this._reward_list[index].SetData(base_type, sub_type, data[index])
				}
				this.UpdateProgress(data)
			}
		}

		this.UpdateProgress = (data?) => {
			let percent = null
			let _percent = 0
			if (data[2] && data[0]) {
				if (data[2].val > 0) {
					let value = data[2].val
					if (value >= 3) {
						_percent = GetSizeDeltaX(this._gp_reward)
					} else {
						let item = this._gp_reward.getChildAt(value)
						if (item) {
							
						}
						_percent = value * 50 + (value - 1) * 95 + 47
					}
				}
			}
			percent = _percent / GetSizeDeltaX(this._gp_reward)
			this._img_progress.width = percent * 271
		}
	}

	public DeleteMe() {

		if (this._reward_list.length > 0) {
			for (let _tmpi in this._reward_list) {
				var item = this._reward_list[_tmpi]
				item.DeleteMe()
			}
			this._reward_list = []
		}
		super.DeleteMe()
	}


	public GetComponents() {
		[
			this._lb_dec,
			this._Image1,
			this._img_progress,
			this._gp_reward,
			this.money
		]
			= this.GetChildrenByNames([

				"_lb_dec",
				"_Image1",
				"_img_progress",
				"_gp_reward",
				"money"
			])
	}
}
window["DailyFirstReward"] = DailyFirstReward