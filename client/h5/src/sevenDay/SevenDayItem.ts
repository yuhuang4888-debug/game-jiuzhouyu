import { SetSizeDeltaX, SetAnchoredPosition, Color, Util } from "../util/Util"
import { BaseItem1 } from "../common/BaseItem1"
import { SevenDayModel } from "../commonModel/SevenDayModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"



export class SevenDayItem extends BaseItem1 {
	_gp_item: Laya.Box
	_gp_normal: Laya.Box
	_img_normal: Laya.Image
	_gp_special: Laya.Box
	_img_special: Laya.Image
	_img_good: Laya.Image
	_gp_num: Laya.Box
	_img_num: Laya.Image
	_img_icon: Laya.Image
	_img_selected: Laya.Image
	_img_red: Laya.Image

	_lb_eight: Laya.Label
	_lb_count: Laya.Label
	_lb_day: Laya.Text
	num_text: Laya.Label
	num_img: Laya.Image

	InitEvent
	InitView
	OnBtnClick
	SetData
	SetEightDay
	SetMergeSeven
	SetSelect
	SetSevenDay
	ray_gp_item

	public constructor(parent?) {
		super(parent)


		this.base_file = "sevenDay"
		this.layout_file = "SevenDayItem"
		let reward_info = null
		let type = null
		let day_type = null
		let view_type = null
		let icon_info = null
		let current_day = null
		let need_ref = false
		let local_SevenDayModel = SevenDayModel
		let local_GoodsModel = GoodsModel.GetInstance()
		let local_ResManager = ResManager.GetInstance()
		let sevenday_model = SevenDayModel.GetInstance()
		this.load_callback = () => {
			//this.GetComponents()
			this.LoadSuccess()
			//local_ResManager.SetOutsideImageSprite(this, this._img_selected, GameResPath.GetIcon("sevenDay", "uiqrdl_005"), true)
		}

		this.InitView = () => {
			// if ("SevenDayView" == view_type) {
			// 	let y = 0
			// 	SetAnchoredPosition(this._gp_item, this._gp_item.x, y)
			// }
			if (need_ref) {
				this.SetData(reward_info, icon_info, type, current_day, day_type, view_type)
				need_ref = false
			}
		}

		this.InitEvent = () => {
			this.OnBtnClick()
			this.BindEvent(sevenday_model, local_SevenDayModel.SELECT_DAY, (bool?, day_id?, type?) => {
				if (((type == type && reward_info) && reward_info.day_id != day_id) && this._img_selected.visible != bool) {
					this.SetSelect(bool)
				}
			}
			)
		}

		this.SetData = (_reward_info?, _icon_info?, _open_type?, _current_day?, _day_type?, _view_type?) => {
			if (!_reward_info) {
				return
			}
			reward_info = _reward_info
			type = _open_type
			day_type = _day_type
			view_type = _view_type
			icon_info = _icon_info
			current_day = _current_day
			if (!this.is_loaded) {
				need_ref = true
				return
			}
			// [ts2lua]lua中0和空字符串也是true，此处_reward_info.status == 1需要确认
			this._img_red.visible = _reward_info.status == 1 ? true : false
			// [ts2lua]lua中0和空字符串也是true，此处_reward_info.status == 2需要确认
			this._img_icon.visible = _reward_info.status == 2 ? true : false
			if (_icon_info) {
				let [type_id, lock] = local_GoodsModel.GetMappingTypeId(_icon_info[0], _icon_info[1])
				let cfg = local_GoodsModel.GetGoodsBasicByTypeId(type_id)
				if (cfg) {
					if (cfg.type == 999 && cfg.subtype == 3) {
						//this._img_good.source = "sevenDay_asset." + cfg.goods_icon + ""
						local_ResManager.SetImageSprite(this, this._img_good, "sevenDay_asset", cfg.goods_icon)
					} else {
						local_ResManager.SetOutsideImageSprite(this, this._img_good, GameResPath.GetGoodsIconPath(cfg.goods_icon))
					}
				}
				if ("SevenDayView" == view_type) {
					this.SetSevenDay(_reward_info)
				} else if ("SevenEightDayView" == view_type) {
					this.SetEightDay(_reward_info, _current_day)
				} else if ("SevenMergeView" == view_type) {
					this.SetMergeSeven(_reward_info)
				}
			}
		}

		this.SetSevenDay = (_reward_info?) => {
			if (!_reward_info) {
				return
			}
			if (_reward_info.day_id == 2 || _reward_info.day_id == 7) {
				this._gp_special.visible = true
			} else {
				this._gp_normal.visible = true
			}
			//this._img_num.source = "sevenDay_asset." + _reward_info.day_id + ""
			//local_ResManager.SetImageSprite(this, this._img_num, "sevenDay_asset", _reward_info.day_id)
			//this.num_text.text = _reward_info.day_id
			ResManager.GetInstance().SetImageSprite(this, this.num_img, "sevenDay_asset", _reward_info.day_id, true)
		}

		this.SetEightDay = (_reward_info?, _current_day?) => {
			if (!_reward_info) {
				return
			}
			this._lb_eight.visible = true
			let day = _reward_info.day_id - _current_day
			let str = null
			let width = 81
			if (day <= 0 && _reward_info.status == 2) {
				str = "已领取"
			} else if (day <= 0 && _reward_info.status == 1) {
				str = "今天奖励"
			} else if (day == 1) {
				str = "明天可领"
			} else if (day > 1) {
				str = day + "天后领取"
				width = 60
			}
			//SetSizeDeltaX(this._lb_eight, width)
			this._lb_eight.text = "第" + _reward_info.day_id + "天"
			let cfg = local_ResManager.GetGameConfigFromCache(this, "config_login_reward_day", false)
			if (!cfg) {
				return
			}
			// [ts2lua]cfg下标访问可能不正确
			let cur_cfg = cfg[_reward_info.day_id]
			if (cur_cfg) {
				this._lb_count.text = cur_cfg.name
			}
		}

		this.SetMergeSeven = (_reward_info?) => {
			if (!_reward_info) {
				return
			}
			// if (PlatformMgr.GetInstance().IsEyouEnPlatform()) {
			// 	this._lb_day.text = _reward_info.day_id + "d"
			// } else {
			this._lb_day.text = "第" + _reward_info.day_id + "天"
			//}
		}

		this.SetSelect = (bool?) => {
			this._gp_item.mouseEnabled = !bool
			this._gp_item.mouseEnabled = !bool

			this._img_selected.visible = bool
			let y = null
			let height = bool ? 206 : 186
			

			if ("SevenDayView" == view_type) {
				//y = -28
				// [ts2lua]lua中0和空字符串也是true，此处bool需要确认
				y = bool ? 73 : 53
				SetAnchoredPosition(this._img_red, this._img_red.x, bool ? 45 : 20)
				this._img_special.height = height
				this._gp_num.y = bool ? 143 : 123
				this._img_normal.height = height
			} else if ("SevenEightDayView" == view_type) {
				//y = 76
				// [ts2lua]lua中0和空字符串也是true，此处bool需要确认
				this._gp_normal.visible = bool ? false : true
				// [ts2lua]lua中0和空字符串也是true，此处bool需要确认
				let color = bool ? "#d15e00" : "#bb8264"
				this._lb_count.color = color
				// [ts2lua]lua中0和空字符串也是true，此处bool需要确认
				//let stroke = bool && 1 || 0
				//this.outlinet_lb_count.effectDistance =  new Vector2(stroke,-stroke)
				let color2 = bool ? "#d15e00" : "#bb8264"
				//this._lb_count.strokeColor = color2// "#D5624E"
				//this._lb_count.strokeColor = "#D5624E"
				// [ts2lua]lua中0和空字符串也是true，此处bool需要确认
				let color1 = bool ? Color(157 / 255, 53 / 255, 32 / 255, 255 / 255) : Color(255 / 255, 255 / 255, 255 / 255, 255 / 255)
				//this._lb_eight.color = color1
				this._img_normal.height = height
			} else if ("SevenMergeView" == view_type) {
				y = 0
			}
			// [ts2lua]lua中0和空字符串也是true，此处bool需要确认
			//this._gp_item.y = bool ? y : 0
			if (y)
				this._img_good.y = y

			//SetAnchoredPosition(this._gp_item, this._gp_item.x, bool && y || 0)
		}

		this.OnBtnClick = () => {
			let target = this._gp_item
			Util.AddClickEvent(target, () => {
				if (!this._img_selected.visible && reward_info) {
					this.SetSelect(true)
					sevenday_model.Fire(local_SevenDayModel.SELECT_DAY, false, reward_info.day_id, type)
				}
			}, this, true)

		}


	}

	public LoadSuccess() {

		this.InitView()
		this.InitEvent()
	}


	public GetComponents() {
		[
			this._gp_item,
			this._gp_normal,
			this._img_normal,
			this._gp_special,
			this._img_special,
			this._img_good,
			this._gp_num,
			this._img_num,
			this._img_icon,
			this._img_selected,
			this._img_red,
			this.num_text,
			this.num_img
		]
			= this.GetChildrenByNames([

				"_gp_item",
				"_gp_normal",
				"_img_normal",
				"_gp_special",
				"_img_special",
				"_img_good",
				"_gp_num",
				"_img_num",
				"_img_icon",
				"_img_selected",
				"_img_red",
				"num_text",
				"num_img"
			])
	}
}
window["SevenDayItem"] = SevenDayItem