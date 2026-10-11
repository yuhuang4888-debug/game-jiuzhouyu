import { BaseView1 } from "../common/BaseView1"
import { Config } from "../common/Config"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { LuaSoundManager } from "../common/SoundManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { EquipmentItem } from "../common/EquipmentItem"
import { Util, SetAnchoredPositionX, LoadLuaConfigAB, GlobalTimerQuest } from "../util/Util"
import { PlatformManager } from "../PlatformManager"

export class DiamondGiftView extends BaseView1 {
	_group_eff_1: Laya.Box
	_img_box: Laya.Image
	_img_girl: Laya.Image
	_img_tips: Laya.Image
	_btn_close: Laya.Image
	_img_discount: Laya.Image
	_lb_tips: Laya.Label
	_Group1: Laya.Box
	_lb_diamond: Laya.Label
	_img_goods: Laya.Image
	_btn_open: Laya.Box
	_Image1: Laya.Image
	_Label1: Laya.Label
	_Scroller1: Laya.Panel
	Content: Laya.HBox
	_Group2: Laya.HBox
	_group_orgin: Laya.Box
	_img_orgin: Laya.Image
	_lb_origin: Laya.Label
	_group_line: Laya.Box
	_group_cur: Laya.Box
	_img_cur: Laya.Image
	_lb_cur: Laya.Label
	_group_eff_2: Laya.Box

	Font_name: string = "diamondFont"
    bitmapFont: Laya.BitmapFont

	InitEvent
	_group_item
	show_open_movie
	Scr_Scroller1
	open_callback
	Clear
	UpdateItems
	use_background
	LoadSuccess
	StartTimer
	ClearLine
	GetAwardList
	click_bg_toClose
	ClearTimer
	UpdateView
	DrawLine
	GetCondition
	Local_Open
	destroy_callback
	preload_server_config
	UpdateTimer

	public constructor() {
		super()

		let local_TimeUtil = TimeUtil

		let local_Util = Util
		let goods_model = GoodsModel.GetInstance()
		let local_GameResPath = GameResPath
		let local_Config = Config
		// let local_laya = Laya
		let _shape_ = null
		let _item_list_ = null
		let _goods_vo_ = null
		let _price_cur_ = null
		let _price_type_ = null
		let _timer_id_ = null
		this.base_file = "diamondGift"
		this.layout_file = "DiamondGiftView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.click_bg_toClose = true
		this.show_open_movie = true
		this.is_center = true

		
		this.load_callback = () => {
			this._Scroller1.hScrollBar.visible = false
			this.LoadSuccess()
			// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
			// 	SetAnchoredPositionX(this._img_tips,308)
			// 	SetAnchoredPositionX(this._img_tips,308)
			// }
		}

		this.open_callback = () => {
			this.UpdateView()
			// this.RegisterMask(this._group_item)
		}

		this.destroy_callback = () => {
			this.Clear()
		}

		this.preload_server_config = { "config_gift_box": false, "config_gift_reward": false }
		this.Local_Open = (parms?) => {
			_goods_vo_ = parms
			if (!_goods_vo_) {
				this.Close()
				return
			}
			let time = _goods_vo_.expire_time - local_TimeUtil.getServerTime()
			if (time < 0) {
				Message.show("物品已过期")
				this.Close()
				return
			}
			super.Open()
		}

		this.Clear = () => {
			this.ClearTimer()
			this.ClearLine()
		}

		this.LoadSuccess = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_box, GameResPath.GetIcon("diamondGift", "uicjlb_001"), true)
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_girl, GameResPath.GetIcon("diamondGift", "uicjlb_002"), true)
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._img_tips, GameResPath.GetIcon("diamondGift", "uicjlb_003"), true)
			//this:AddUIEffect("ui_giftbag_glow1", this._group_eff_1, null, null, true)
			//this:AddUIEffect("ui_giftbag_glow2", this._group_eff_2, null, null, true)
			_item_list_ = []
			this.InitEvent()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_close, () => {
				this.Close()
			}
				, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)
			Util.AddClickEvent(this._btn_open, () => {
				if (!_goods_vo_) {
					return
				}
				if (!_price_cur_) {
					return
				}
				if (!_price_type_) {
					return
				}
				let enough = goods_model.CheckCoinEnough(_price_type_, _price_cur_, true, () => {
					goods_model.Fire(GoodsModel.USE_BAG_GOODS, _goods_vo_.goods_id, 1)
					this.Close()
				}
				)
			}
				, this, true)
		}

		this.UpdateView = () => {
			if (!_goods_vo_) {
				return
			}
			let cond = this.GetCondition()
			if (!cond) {
				return
			}
			let price_cur = Number(cond[2])
			let price_origin = Number(cond[1])
			_price_cur_ = price_cur
			let discount = Math.ceil(price_cur / price_origin * 10)
			//let path = "resource/game/diamondGift/texture/df_sale_" + discount + ".png"
			ResManager.GetInstance().SetImageSprite(this, this._img_discount, "diamondGift_asset", "df_sale_" + discount,true)
			this._lb_cur.text = String(price_cur)
			this._lb_origin.text = String(price_origin)
			this._lb_diamond.text = String(price_cur)
			let type = cond[0]
			_price_type_ = Number(type)
			let type_id = goods_model.GetMappingTypeId(type, -1)
			let basic = goods_model.GetGoodsBasicByTypeId(type_id)
			if (basic) {
				ResManager.GetInstance().SetOutsideImageSprite(this, this._img_cur, local_GameResPath.GetGoodsIconPath(basic.goods_icon))
				ResManager.GetInstance().SetOutsideImageSprite(this, this._img_orgin, local_GameResPath.GetGoodsIconPath(basic.goods_icon))
			}
			let goods_path = ""
			if (_price_type_ == 1) {
				goods_path = "uicjlb_004"
			} else if (_price_type_ == 2) {
				goods_path = "uicjlb_004b"
			}
			//this._img_goods.source = goods_path
			ResManager.GetInstance().SetImageSprite(this, this._img_goods, "diamondGift_asset", goods_path)
			this.ClearTimer()
			this.StartTimer()
			this.UpdateTimer()
			this.UpdateItems()
			let no_change = price_cur == price_origin
			this._group_orgin.visible = !no_change
			let x = no_change ? -30 : 0
			this._group_cur.centerX = x
			// this._group_orgin.includeInLayout = !no_change
			if (!no_change) {
				this.DrawLine(this._lb_origin)
			} else {
				this.ClearLine()
			}
			// LayoutRebuilder(this._Group1)
		}

		this.GetCondition = () => {
			let config = ResManager.GetInstance().GetGameConfigFromCache(this, "config_gift_box", false)
			//let cfg = null
			//if (config ) {
			// [ts2lua]config下标访问可能不正确
			let cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_gift_box.name, _goods_vo_.type_id, false, config)
			//}
			if (!cfg) {
				return
			}
			let cond_list = JSON.parse(cfg.condition)
			return cond_list[0][1][0]
		}

		this.GetAwardList = (type_id?) => {
			if (this.use_delete_method) {
				//lua_resM:DestroyAllReferenceRes(this.hashCode)
				return
			}
			let gift_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_gift_reward", false)
			let role_vo = RoleManager.GetInstance().GetMainRoleVo()
			let lv = role_vo.level
			let info = null
			if (gift_cfg) {
				for (let key in gift_cfg) {

					info = local_Config.GetConfigVo(local_Config.ConfigHasDefaultValue.config_gift_reward.name, key, false, gift_cfg)
					if (type_id == info.goods_id && (info.slv == 0 || lv >= info.slv) && (info.elv == 0 || lv <= info.elv)) {
						return JSON.parse(info.fixed_gifts)
						//break
					}
					//if (info.slv && lv < info.slv ) {
					//break
					//}
					//if (info.elv && lv > info.elv ) {
					//break
					//}
				}
			}
		}

		this.UpdateItems = () => {
			LoadLuaConfigAB("Giftreward", () => {
				let list = this.GetAwardList(_goods_vo_.type_id) || []
				for (let i = 0; i < list.length; i++) {
					let item = _item_list_[i]
					let info = list[i]
					if (!item) {
						item = new EquipmentItem(this.Content)
						// item.SetUseMask(true)
						item.Load()
						item.SetItemSize(85, 85)
						_item_list_[i] = item
					}
					let [type_id] = goods_model.GetMappingTypeId(info[0], info[1])
					// let basic = goods_model.GetGoodsBasicByTypeId(type_id)
					item.SetData(type_id, info[2])
					item.SetVisible(true)
				}
				for (let i = list.length; i < _item_list_.length; i++) {
					_item_list_[i].SetVisible(false)
				}
			})
		}

		this.DrawLine = (label?) => {
			//if (! _shape_ ) {
			//_shape_ = local_laya. new Shape()
			//this._group_line.addChild(_shape_)
			//}
			//let lPos =  new Point(0, 0)
			//_shape_.graphics.clear()
			//_shape_.graphics.lineStyle(3, "#9C9C9C")
			//_shape_.graphics.lineTo(lPos.x, lPos.y + label.textHeight * 0.5)
			//_shape_.graphics.lineTo(lPos.x + label.textWidth, lPos.y + label.textHeight * 0.5)
			//_shape_.graphics.endFill()
		}

		this.ClearLine = () => {
			//if (_shape_ ) {
			//_shape_.graphics.clear()
			//this._group_line.removeChild(_shape_)
			//_shape_ = null
			//}
		}

		this.UpdateTimer = () => {
			if ((_goods_vo_ && _goods_vo_.expire_time != null) && this._lb_tips) {
				let time = _goods_vo_.expire_time - local_TimeUtil.getServerTime()
				if (time > 0) {
					let timeStr = local_TimeUtil.timeConvert(time, "hh-mm-ss")
					// if (PlatformMgr.GetInstance().IsEyouEnPlatform()) {
					// 	this._lb_tips.text = "Giftpack will disappear in " + timeStr
					// } else {
					this._lb_tips.text = "本礼包将于" + timeStr + "后消失"
					// }
				} else {
					this.Close()
				}
			}
		}

		this.ClearTimer = () => {
			if (_timer_id_) {
				//_timer_id_:stop()
				//_timer_id_:removeEventListener(Laya.TimerEvent.TIMER, this.UpdateTimer, this)
				GlobalTimerQuest.CancelQuest(_timer_id_)
				_timer_id_ = null
			}
		}

		this.StartTimer = () => {
			//_timer_id_ = local_laya. new Timer(1000, 0)
			//_timer_id_:addEventListener(Laya.TimerEvent.TIMER, this.UpdateTimer, this)
			//_timer_id_:start()

			_timer_id_ = GlobalTimerQuest.AddPeriodQuest(this.UpdateTimer, 1, -1)
		}

	}

	public Open(...new_args) {
		this.Local_Open(...new_args)
	}


	public GetComponents() {
		[
			this._group_eff_1,
			this._img_box,
			this._img_girl,
			this._img_tips,
			this._btn_close,
			this._img_discount,
			this._lb_tips,
			this._Group1,
			this._lb_diamond,
			this._img_goods,
			this._btn_open,
			this._Image1,
			this._Label1,
			this._Scroller1,
			this.Content,
			this._Group2,
			this._group_orgin,
			this._img_orgin,
			this._lb_origin,
			this._group_line,
			this._group_cur,
			this._img_cur,
			this._lb_cur,
			this._group_eff_2,
		]
			= this.GetChildrenByNames([

				"_group_eff_1",
				"_img_box",
				"_img_girl",
				"_img_tips",
				"_btn_close",
				"_img_discount",
				"_lb_tips",
				"_Group1",
				"_lb_diamond",
				"_img_goods",
				"_btn_open",
				"_Image1",
				"_Label1",
				"_Scroller1",
				"Content",
				"_Group2",
				"_group_orgin",
				"_img_orgin",
				"_lb_origin",
				"_group_line",
				"_group_cur",
				"_img_cur",
				"_lb_cur",
				"_group_eff_2",
			])
			ResManager.GetInstance().LoadFont(this, "diamondFont", this._lb_diamond, 20)
	}
}
window["DiamondGiftView"] = DiamondGiftView