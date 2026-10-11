import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { PlatformManager } from "../PlatformManager"
import { Message } from "../sysInfo/SysInfoController"
import { GameResPath } from "../util/GameResPath"
import { Mathf } from "../util/Mathf"
import { RefGridLayout, SetAnchoredPositionX, Util } from "../util/Util"
import { FtvShopItem } from "./FtvShopItem"
import { FtvShopItemTwo } from "./FtvShopItemTwo"

export class FtvShopView extends BaseItem1 {
	_img_title: Laya.Image
	_gp_time: Laya.Box
	_gp_item: Laya.Box
	_Group1: Laya.Box
	_Image1: Laya.Image
	_lb_desc: Laya.HTMLDivElement
	_img_refresh: Laya.Image
	_img_time_bg:Laya.Image
	CustomMehod
	InitEvent
	InitView
	LoadSuccess
	Local_DeleteMe
	RefBtn
	RefItem
	RefRewardSort
	itemm_box_data
	public constructor(parent?) {
		super(parent)


		this.base_file = "ftvShop"
		this.layout_file = "FtvShopView"
		let model = CustomActivityModel.GetInstance()
		let local_Message = Message
		let info_ = null
		let data_ = null
		let timer_ = null
		let item_list_ = []
		let all_layer_ = 0
		let cur_layer_ = 1
		let is_right_ = true
		this.preload_client_config = {
			"ConfigCustomActivityView": false,
			"ConfigCustomActivity": false
		}
		this.itemm_box_data={
			h_gap:0,
			v_gap:20,
			column:3,
			item_w:185,
			item_h:300
		}
		this.load_callback = () => {

			this.LoadSuccess()
			this.InitEvent()
			this.InitView()

			if (PlatformManager.IsEyouEnPlatform()) {
				this._lb_desc.style.fontSize = 18

				if (this._img_refresh.visible) {
					SetAnchoredPositionX(this._lb_desc, -95)
				} else {
					SetAnchoredPositionX(this._lb_desc, 0)
				}
			}
		}

		this.LoadSuccess = () => {

		}

		this.InitEvent = () => {
			if (this._img_refresh) {
				Util.AddClickEvent(this._img_refresh, () => {
					if (all_layer_ > 0) {
						if (is_right_) {
							cur_layer_ = cur_layer_ + 1
						} else {
							cur_layer_ = cur_layer_ - 1
						}
						if (cur_layer_ == all_layer_) {
							is_right_ = false
							ResManager.GetInstance().SetImageSprite(this, this._img_refresh, "ftvShop_asset", "uiqgsd_001", true)
						} else if (cur_layer_ == 1) {
							is_right_ = true
							ResManager.GetInstance().SetImageSprite(this, this._img_refresh, "ftvShop_asset", "uiqgsd_001a", true)
						}
						this.RefItem()
					}
				}, this, true)
			}

			this.BindEvent(model, CustomActivityDefine.EVENT.UPDATE_VIEW, (...new_args) => {
				let args = new_args
				if (!info_) {
					return
				}
				if (info_.base_type == args[0] && info_.sub_type == args[1]) {
					data_ = model.GetActData(args[0], args[1])
					this.RefRewardSort()
					this.RefItem()
				}
			}
			)

			// if (this._btn_last) {
			// 	let last_func = () => {
			// 		cur_layer_ = cur_layer_ - 1
			// 		this.RefBtn(-1)
			// 		this.RefItem()
			// 	}
			// 	Util.AddClickEvent(this._btn_last, last_func, this, true)
			// }

			// if (this._btn_next) {
			// 	let next_func = () => {
			// 		cur_layer_ = cur_layer_ + 1
			// 		this.RefBtn(1)
			// 		this.RefItem()
			// 	}
			// 	Util.AddClickEvent(this._btn_next, next_func, this, true)
			// }
		}

		this.InitView = () => {
			if (!info_) {
				return
			}
			ResManager.GetInstance().SetTexture(this,this._img_time_bg,GameResPath.GetIcon("ftvShop","uixys_007"))
			let b = info_.base_type
			let s = info_.sub_type
			let show_id = info_.show_id
			let cfg = this.preload_client_config["ConfigCustomActivityView"]
			if (cfg && info_ && b == 59) {
				model.LoadCompontRes(this, cfg, "FtvShopView", show_id)
			}
			let desc = (b == this.preload_client_config["ConfigCustomActivity"].ACT_ID.SNAPUP && ("") || ("部分商品"))
			let cond = model.GetActCondition(b, s, "info")
			if (cond) {
				let clean = Number(cond.clean)
				if (clean != null){// && this._gp_desc) {
					let desc_bool = (clean == 1 && (false) || (true))
					// this._gp_desc.visible = desc_bool
					if (desc_bool) {
						let time = clean == 2 ? 0 : 4
						this._lb_desc.innerHTML = Util.StrToHTML(desc + "购买次数每天<font color='#cf4702'>" + time + "</font>点刷新"
						)
					}
				} else {
					this._lb_desc.innerHTML = Util.StrToHTML(desc + "购买次数每天<font color='#cf4702'>0</font>点刷新"
					)
				}
			}
			this._lb_desc.x=this._Group1.width/2-this._lb_desc.contextWidth/2
			timer_ = model.LoadActTimer(this._gp_time, info_.etime, 20, "#2cff40", null, "#ffffff", "活动剩余时间:",true)
			model.CloseACTRed(info_.base_type, info_.sub_type, null, info_.show_id)
			data_ = model.GetActData(info_.base_type, info_.sub_type)
			if (!data_) {
				return
			}
			all_layer_ = Mathf.Ceil(data_.reward_list.length / 6)
			if (this._img_refresh) {
				let ref_bool = (all_layer_ > 1 && (true) || (false))
				this._img_refresh.visible = ref_bool
			// } else if (this._btn_last && this._btn_next) {
			// 	this.RefBtn()
			}
			this.RefRewardSort()
			this.RefItem()
		}

		this.RefBtn = (add_num?) => {
			if (cur_layer_ <= 1) {
				if (add_num == -1 && cur_layer_ < 1) {
					local_Message.show("当前为第一页")
				}
				cur_layer_ = 1
			}
			if (cur_layer_ >= all_layer_) {
				if (add_num == 1 && cur_layer_ > all_layer_) {
					local_Message.show("当前为最后一页")
				}
				cur_layer_ = all_layer_
			}
		}

		this.RefRewardSort = () => {
			let sort_callback = (a?, b?) => {
				return a.grade < b.grade
			}
			table.sort(data_.reward_list, sort_callback)

			let buy_list = []
			let list = []
			for (let _tmpi in data_.reward_list) {
				var v = data_.reward_list[_tmpi]
				if (v.status != 2) {
					table.insert(list, v)
				} else {
					table.insert(buy_list, v)
				}
			}
			data_.reward_list = list.concat(buy_list) //table.merge(list, buy_list)
		}

		this.RefItem = () => {
			if (!data_) {
				return
			}
			if (item_list_.length > 0) {
				for (let _tmpi in item_list_) {
					var item = item_list_[_tmpi]
					item.SetVisible(false)
				}
			}

			let cur_index = cur_layer_ * 6 - 5 -1
			for (let i = cur_index; i <= cur_index + 5; i++) {
				let reward = data_.reward_list[i]
				if (!reward) {
					break
				}
				let item = item_list_[i]
				if (!item) {
					if (this._img_refresh) {
						item = new FtvShopItem(this._gp_item)
					// } else if (this._btn_last) {
					// 	item = new FtvShopItemTwo(this._gp_item)
					}
					if (item) {
						item.Load()
						table.insert(item_list_, item)
					}

				}
				if (item) {
					item.ExcuteCallback(() => {
						RefGridLayout(this._gp_item,this.itemm_box_data,false)
						item.SetVisible(true)
						item.SetData(data_.reward_list[i], info_.base_type, info_.sub_type)
					}
					)
				}
			}

		}

		this.Local_DeleteMe = () => {
			if (timer_) {
				timer_.DeleteMe()
				timer_ = null
			}
			if (item_list_.length > 0) {
				for (let _tmpi in item_list_) {
					var item = item_list_[_tmpi]
					item.DeleteMe()
				}
				item_list_ = []
			}
		}

		this.CustomMehod = (index?, pram?) => {
			if (pram) {
				info_ = pram
			}
		}


	}

	public DeleteMe() {

		this.Local_DeleteMe()
		super.DeleteMe()
	}



	public GetComponents() {
		[
			this._img_title,
			this._gp_time,
			this._gp_item,
			this._Group1,
			this._Image1,
			this._lb_desc,
			this._img_refresh,
			this._img_time_bg
		]
			= this.GetChildrenByNames([

				"_img_title",
				"_gp_time",
				"_gp_item",
				"_Group1",
				"_Image1",
				"_lb_desc",
				"_img_refresh",
				"_img_time_bg"
			])
		this._lb_desc.style.fontSize=22
		this._lb_desc.style.color="#663915"
		this._lb_desc.style.wordWrap=false
	}
}
window["FtvShopView"]=FtvShopView