import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { GoodsModel } from "../commonModel/GoodsModel"
import { VipModel } from "../commonModel/VipModel"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"

export class VipWeekGiftView extends BaseView1 {
	newbg: Laya.Image
	bg: Laya.Image
	_Image1: Laya.Image
	_Image2: Laya.Image
	title_text: Laya.Label
	image6: Laya.Image
	image: Laya.Image
	_Image3: Laya.Image
	_Image4: Laya.Image
	close_btn: Laya.Image
	_Image5: Laya.Image
	reward_scroller: Laya.Panel
	Content: Laya.HBox
	bottom_text: Laya.Label

	DestroyCallback
	InitEvent
	LoadSuccess
	Open
	click_bg_toClose
	destroy_callback
	destroy_imm
	is_center
	open_callback
	use_background


	public constructor() {
		super()

		this.base_file = "vip"
		this.layout_file = "VipWeekGiftView"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.click_bg_toClose = true
		this.use_background = true
		this.destroy_imm = true
		let vip_model = VipModel.GetInstance()
		let gModel = GoodsModel.GetInstance()
		let reward_list_ = []
		let data_ = null
		let vip_lv_ = null
		let show_lv_ = 1
		this.preload_server_config = {
			"config_vip_config": false
		}
		this.open_callback = () => {

			this.LoadSuccess()
			this.InitEvent()
		}

		this.destroy_callback = () => {
			this.DestroyCallback()
		}

		this.Open = (lv?) => {
			show_lv_ = lv
			// super.Open()
			super.Open()
		}

		this.LoadSuccess = () => {
			ResManager.GetInstance().SetTexture(this,this.newbg,GameResPath.GetIcon("vip","bg_031"))
			ResManager.GetInstance().SetTexture(this,this._Image2,GameResPath.GetIcon("vip","ui_content_bg11"))
			let key = show_lv_
			// let cfg = Config.PRELOAD_SETVER_CONFIG.config_vip_config
			let cfg = this.preload_server_config["config_vip_config"]
			if (cfg) {
				// [ts2lua]cfg下标访问可能不正确
				let lv_cfg = cfg[key]
				if (lv_cfg) {
					let week_rewards = JSON.parse(lv_cfg.week_rewards)
					if (week_rewards && week_rewards.length > 1) {
						let sortfunc = (a?, b?) => {
							let agoods_vo = gModel.GetGoodsBasicByTypeId(a[1])
							let bgoods_vo = gModel.GetGoodsBasicByTypeId(b[1])
							if (agoods_vo && bgoods_vo) {
								return bgoods_vo.color < agoods_vo.color
							}
							// return 1
							return false
						}

						// week_rewards.sort(sortfunc)
						table.sort(week_rewards, sortfunc)
					}
					this.reward_scroller.width=week_rewards.length*89 +week_rewards.length*10
					this.reward_scroller.refresh()
					let i = 0
					do {
						let reward = week_rewards[i]
						if (!reward_list_) {
							reward_list_ = []
						}
						let item = reward_list_[i]
						if (!item) {
							item = new BaseAwardItem(this.Content)
							reward_list_[i] = item
							item.Load()
							item.SetScale(0.7)
						}
						if (item) {
							let [type_id, lock] = gModel.GetMappingTypeId(reward[0], reward[1])
							let goods_vo = gModel.GetGoodsBasicByTypeId(type_id)
							if (goods_vo) {
								item.SetData(goods_vo.type_id, reward[2], lock)
							} else {
								// console.log("goodsVo is null type_id:" + type_id)
								console.log("goodsVo is null type_id:" + type_id)
							}
						}
						i = i + 1
					} while ((i < week_rewards.length))
					// [ts2lua]lua中0和空字符串也是true，此处vip_model:GetVipLevel() == 0需要确认
					let reward_num = (vip_model.GetVipLevel() == 0 && (0) || (lv_cfg.week_max_times))
					this.bottom_text.text = "VIP" + show_lv_ + "礼包"
				}
			}
		}

		this.InitEvent = () => {
			let OnCloseBtnClick = () => {
				this.Close()
			}

			Util.AddClickEvent(this.close_btn, OnCloseBtnClick, this, true)
		}

		this.DestroyCallback = () => {
			for (let index in reward_list_) {

				// [ts2lua]reward_list_下标访问可能不正确
				let item = reward_list_[index]
				item.DeleteMe()
				// [ts2lua]reward_list_下标访问可能不正确
				reward_list_[index] = null
			}
			reward_list_ = null
		}
	}


	public GetComponents() {
		[
			this.newbg,
			this.bg,
			this._Image1,
			this._Image2,
			this.title_text,
			this.image6,
			this.image,
			this._Image3,
			this._Image4,
			this.close_btn,
			this._Image5,
			this.reward_scroller,
			this.Content,
			this.bottom_text,
		]
			= this.GetChildrenByNames([

				"newbg",
				"bg",
				"_Image1",
				"_Image2",
				"title_text",
				"image6",
				"image",
				"_Image3",
				"_Image4",
				"close_btn",
				"_Image5",
				"reward_scroller",
				"Content",
				"bottom_text",
			])
		this.reward_scroller.hScrollBar.visible=false
	}
}
window["VipWeekGiftView"]=VipWeekGiftView