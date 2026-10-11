import { Alert, Alert_Type } from "../alert/Alert"
import { BaseView1 } from "../common/BaseView1"
import { Config } from "../common/Config"
import { CookieWrapper } from "../common/CookieWrapper"
import { DownDropBtn } from "../common/DownDropBtn"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { WordManager } from "../common/WordManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { HolySealModel } from "../commonModel/HolySealModel"
import { PlatformManager } from "../PlatformManager"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil } from "../util/ColorUtil"
import { LOAD_QUEUE } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { HolySealDecomposeItem } from "./HolySealDecomposeItem"

export class HolySealDecomposeView extends BaseView1 {
	//eui
	// private _dgp_bag_con: eui.DataGroup
	// private _scroll_bag_con: eui.Scroller
	// private _img_bg: eui.Image
	// private _img_close: eui.Image
	// private _lb_income: eui.Label
	// private _img_icon: eui.Image
	// private _lb_tips: eui.Label
	// private _img_arrow: eui.Image
	// private _gp_decompose: eui.Group
	// private _gp_effect: eui.Group
	// private _gp_empty: eui.Group
	// private _img_decompose: eui.Image

	// public text:eui.Label;

	Remove
	InitEvent
	LoadSuccess
	UpdateView
	GetBagList
	UpdateBag
	RefreshItem
	GetDecomposeList
	UpdateDecomposeReward
	UpdateAutoDecomposeState
	ClickColor
	ClickStage
	AutoDecompose
	Decompose


	_drop_color: DownDropBtn
	_drop_pos: DownDropBtn
	bag_loop_mgr
	public constructor() {
		super()
		this.base_file = "holySeal"
		this.layout_file = "HolySealDecomposeView"
		this.layer_value = Enum_UILayer.Activity
		let model = HolySealModel.GetInstance(),
			cookie_wrapper = CookieWrapper.GetInstance(),
			local_CookieWrapper = CookieWrapper,
			local_Util = Util,
			local_Message = Message,
			local_HolySealModel = HolySealModel,
			goods_model = GoodsModel.GetInstance(),
			local_GoodsModel = GoodsModel,
			local_ColorUtil = ColorUtil,
			res_mgr = ResManager.GetInstance(),
			auto_decompose_state_ = false,
			PRELOAD_SERVER_CONFIG_ = {
				config_goods_decompose: null,
			},
			select_goods_dic_,
			holy_seal_bag_,
			drop_color_ = 2,
			drop_stage_ = 8,
			decompose_reward_,
			decompose_reward_cache_,
			_time_id_

		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true
		this.show_open_movie = true
		this.destroy_imm = true
		this.load_callback = function () {
			this.LoadSuccess()
		}
		this.destroy_callback = function () {
			this.Remove()
		}
		this.preload_server_config = {
			"config_seal_equip": false,
			"config_seal_kv": false
		}

		this.Remove = () => {
			let obj = {
				auto_decompose_state: auto_decompose_state_,
				drop_color: drop_color_,
				drop_stage: drop_stage_,
			}
			cookie_wrapper.SaveCookie(local_CookieWrapper.HOLY_SEAL_DECOMPOSE_INFO, JSON.stringify(obj), true)
			drop_color_ = 2
			drop_stage_ = 8
			auto_decompose_state_ = undefined
			select_goods_dic_ = undefined

			if (this._drop_pos) {
				this._drop_pos.DeleteMe()
				this._drop_pos = undefined
			}
			if (this._drop_color) {
				this._drop_color.DeleteMe()
				this._drop_color = undefined
			}

			if (this.bag_loop_mgr) {
				this.bag_loop_mgr.DeleteMe()
				this.bag_loop_mgr = undefined
			}
		}

		this.InitEvent = () => {

			local_Util.AddClickEvent(this._img_close, () => {
				this.Close()
			}, this, true)

			local_Util.AddClickEvent(this._gp_decompose, () => {
				let goods_list = this.GetDecomposeList()


				if (goods_list.length) {

					let have_color_more_than_orange = false
					let decompose_func = () => {
						this.Decompose(goods_list)
					}

					for (let goods_vo of goods_list) {
						//橙色圣印才提示
						if (goods_vo.color >= 4 && goods_vo.type == HolySealModel.GOODS_TYPE) {
							have_color_more_than_orange = true
							break
						}
					}

					let alert = model.alert_decompose
					if (have_color_more_than_orange && !alert) {
						let str = `所选中的影装中包含橙色及以上品质的影装，是否确定继续分解`
						let content = local_Util.StrToHTML(str)
						Alert.Show(content, Alert_Type.AlertTypeCheckBox, decompose_func, undefined, undefined, undefined, undefined, false, (bool: boolean) => {
							model.alert_decompose = bool
						}, "本次登录不再提示")
					}
					else {
						decompose_func()
					}

				}
				else {
					local_Message.show("请先选择需要分解的物品")
				}
			}, this, true)

			local_Util.AddClickEvent(this._img_arrow, () => {
				auto_decompose_state_ = !auto_decompose_state_
				this.UpdateAutoDecomposeState()
				if (auto_decompose_state_)
					this.AutoDecompose()
			}, this, true)

			this.BindEvent(model, local_HolySealModel.SELECT_BREAK_DOWN_ITEM, (data) => {
				if (data.is_selected)
					select_goods_dic_[data.equip_info.goods_id] = data.equip_info
				else
					delete select_goods_dic_[data.equip_info.goods_id]

				this.UpdateDecomposeReward()
			})

			this.BindEvent(goods_model, local_GoodsModel.GOODS_DECOMPOSE_SUCCESS, () => {
				if (decompose_reward_cache_) {
					let config_seal_kv = res_mgr.GetGameConfigFromCache(this, "config_seal_kv", false)
					let type_id = model.GetkeyValue(2, config_seal_kv)
					let goods_vo = goods_model.GetGoodsBasicByTypeId(type_id)
					if (goods_vo) {
						let color = local_ColorUtil.GetColorLight(goods_vo.color)
						local_Message.show(`<font color='#ffffff'>获得</font><font color=${color}>${goods_vo.goods_name} x${decompose_reward_cache_}</font>`)
					}
					decompose_reward_cache_ = undefined
				}
			})

			this.BindEvent(goods_model, local_GoodsModel.CHANGE_HOLY_SEAL_BAG_LIST, () => {
				this.UpdateView()
			})
		}


		this.LoadSuccess = async () => {
			let config_seal_kv = res_mgr.GetGameConfigFromCache(this, "config_seal_kv", false)
			res_mgr.SetTexture(this, this._img_icon, GameResPath.GetGoodsIconPath(model.GetkeyValue(2, config_seal_kv)))
			for (let config_name in PRELOAD_SERVER_CONFIG_) {
				PRELOAD_SERVER_CONFIG_[config_name] = await res_mgr.LoadGameConfig(res_mgr, config_name, false, LOAD_QUEUE.HIGHT)
			}

			select_goods_dic_ = {}

			this._lb_tips.style.fontSize = 24
			this._lb_tips.style.color = "#4A3A32"
			this._lb_tips.style.width = 300

			this._lb_tips.innerHTML = `自动分解${Util.HtmlColorTxt("紫色品质", "'#a376ff'")}以下影装`
			if(PlatformManager.IsEyouPlatform()){
				this._lb_tips.style.leading = 0.1
				this._lb_tips.style.wordWrap = true
				this._lb_tips.style.width = 400
			}

			this._drop_pos = new DownDropBtn(this.display_obj)
			this._drop_pos.SetPosition(363, 546)
			// this.addChild()

			this._drop_color = new DownDropBtn(this.display_obj)
			this._drop_color.SetPosition(79, 546)
			// this.addChild(this._drop_color)

			let obj = cookie_wrapper.GetCookie(local_CookieWrapper.HOLY_SEAL_DECOMPOSE_INFO, true)
			if (obj) {
				let info = JSON.parse(obj)
				auto_decompose_state_ = info.auto_decompose_state || false
				drop_color_ = info.drop_color || drop_color_
				drop_stage_ = info.drop_stage || drop_stage_
			}
			else {
				auto_decompose_state_ = false
			}
			let stage_drop_list = model.GetStageDropData()
			this._drop_pos.Init(stage_drop_list, this.ClickStage, `${WordManager.ConvertNum(drop_stage_)}阶以下`, "content", undefined, 6, undefined, false)
			let color_drop_list = model.GetColorDropData()
			this._drop_color.Init(color_drop_list, this.ClickColor, `${local_ColorUtil.GetColorName(drop_color_)}以下`, "content", undefined, 6, undefined, false)


			this._drop_color.Load()
			this._drop_pos.Load()

			this.InitEvent()
			this.UpdateAutoDecomposeState()

			if (this.AutoDecompose()) {
				this.UpdateView()
			}
		}

		this.UpdateView = () => {
			select_goods_dic_ = {}
			this._lb_income.text = "0"
			this.UpdateBag()
			this.RefreshItem()
			this.UpdateDecomposeReward()
		}

		this.GetBagList = (color, stage) => {
			//添加红点判断 只要有分解材料在背包里面 就显示红点
			let decompose_red = false
			let list = []
			let holy_seal_bag_goods_list = goods_model.holy_seal_bag_goods_list
			for (let equip_info of holy_seal_bag_goods_list) {
				if (equip_info.type != local_HolySealModel.GOODS_TYPE) {
					list.push({ equip_info: equip_info, is_selected: true })
					select_goods_dic_[equip_info.goods_id] = equip_info
					decompose_red = true
				}
				else {
					if (local_HolySealModel.MAX_DECOMPOSE_COLOR >= equip_info.color) {
						let config_seal_equip = ResManager.GetInstance().GetGameConfigFromCache(this, "config_seal_equip", false)
						let holy_seal_data = model.GetHolySealData(equip_info.type_id, config_seal_equip)
						let equip_holy_seal = model.GetWearEquipByPos(holy_seal_data.pos)
						if (equip_holy_seal && equip_holy_seal.rating >= equip_info.rating) {
							if ((!color || color >= equip_info.color) && (!stage || stage >= holy_seal_data.stage)) {
								list.push({ equip_info: equip_info, is_selected: true })
								select_goods_dic_[equip_info.goods_id] = equip_info
							} else {
								list.push({ equip_info: equip_info, is_selected: false })

							}
						}
					}
				}
			}

			this._img_decompose_red.visible = decompose_red
			return list
		}

		this.UpdateBag = () => {

			let list = this.GetBagList(drop_color_, drop_stage_)

			let len = list.length
			this._lb_none.visible = len == 0
			this._list_bag_con.visible = len != 0

			holy_seal_bag_ = list

		}

		this.RefreshItem = () => {

			if (this.bag_loop_mgr) {
				this.bag_loop_mgr.replaceAll(holy_seal_bag_)
			}
			else {
				this.bag_loop_mgr = new LoopScrowViewMgr()
				this.bag_loop_mgr.SetData(this._list_bag_con, HolySealDecomposeItem, holy_seal_bag_, LoopScrCon.Vertical)
			}
		}

		this.GetDecomposeList = () => {
			let list = []
			for (let id in select_goods_dic_) {
				let goods_vo = select_goods_dic_[id]
				list.push({ goods_id: goods_vo.goods_id, goods_num: goods_vo.goods_num, color: goods_vo.color })
			}
			return list
		}


		this.UpdateDecomposeReward = () => {
			let reward_value = 0
			for (let key in select_goods_dic_) {
				let info = select_goods_dic_[key]
				if (info) {
					let cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods_decompose.name, info.type_id, false, PRELOAD_SERVER_CONFIG_.config_goods_decompose)
					if (cfg) {
						let reward = JSON.parse(cfg.regular_mat)//[[0,14010004,3],[0,17010002,2],[0,20010001,1]]
						for (let vo of reward) {
							reward_value += (vo[2] * info.goods_num)
						}
					}
				}
			}

			decompose_reward_ = reward_value
			this._lb_income.text = String(reward_value)
		}

		this.UpdateAutoDecomposeState = () => {
			ResManager.GetInstance().SetImageSprite(this, this._img_arrow,"common", auto_decompose_state_ ? `com_ui_gx1` : `com_ui_gx`)
		}

		this.ClickColor = (index, data) => {
			if (this.use_delete_method) return
			drop_color_ = data.cond
			this.UpdateView()
		}

		this.ClickStage = (index, data) => {
			if (this.use_delete_method) return
			drop_stage_ = data.cond
			this.UpdateView()
		}

		this.AutoDecompose = () => {
			if (!auto_decompose_state_)
				return true
			select_goods_dic_ = {}
			let list = this.GetBagList(local_HolySealModel.AUTO_DECOMPOSE_COLOR, 0)

			let goods_list = this.GetDecomposeList()
			if (goods_list.length) {
				holy_seal_bag_ = list
				this.RefreshItem()
				this.Decompose(goods_list)
			}
			return goods_list.length == 0
		}


		this.Decompose = (goods_list) => {
			if (_time_id_) return
			if (!select_goods_dic_) return
			let list = []
			for (let key in holy_seal_bag_) {
				let goods_vo = holy_seal_bag_[key]
				if (select_goods_dic_[goods_vo.equip_info.goods_id]) {
					list[key] = true
				}
			}

			let now_index = {}
			let len = this._list_bag_con.numChildren
			// for (let i = 0; i < len; i++) {
			// 	let item = <HolySealDecomposeItem>this._list_bag_con.getChildAt(i)
			// 	now_index[item.itemIndex] = { x: item.x, y: item.y - this._list_bag_con.scrollV }
			// }

			// let register_protocals = false
			// for (let index in list) {
			// 	let pos = now_index[index]
			// 	if (pos) {
			// 		let group = new eui.Group()
			// 		group.x = pos.x + 87 / 2
			// 		group.y = pos.y + 87 / 2
			// 		this._gp_effect.addChild(group)
			// 		let call_back = () => {
			// 			egret.Tween.removeTweens(group)
			// 			this._gp_effect.removeChild(group)
			// 			if (register_protocals) {
			// 				register_protocals = true
			// 			}
			// 		}
			// 		this.AddUIEffect("ui_tunshi_glow", group, null, null, false, null, call_back, null, null, true)
			// 	}
			// }

			// _time_id_ = egret.setTimeout(() => {
			// 	_time_id_ = undefined
			// 	decompose_reward_cache_ = decompose_reward_
			// 	goods_model.Fire(local_GoodsModel.RESOLVE_GOODS, goods_list)
			// }, this, 300)

			decompose_reward_cache_ = decompose_reward_
			goods_model.Fire(local_GoodsModel.RESOLVE_GOODS, goods_list)
		}
	}

	_img_bg: Laya.Image
	_img_title_bg: Laya.Image
	_img_close: Laya.Image
	_img_arrow: Laya.Image
	_img_content_bg: Laya.Image
	_gp_value: Laya.HBox
	_lb_income: Laya.Label
	_img_icon: Laya.Image
	_list_bag_con: Laya.List
	_lb_tips: Laya.HTMLDivElement
	_lb_none: Laya.Label
	_lb_title: Laya.Label
	text: Laya.Label
	_gp_decompose: Laya.Box
	image2: Laya.Image
	label1: Laya.Label
	_img_decompose_red: Laya.Image
	public GetComponents() {
		[
			this._img_bg,
			this._img_title_bg,
			this._img_close,
			this._img_arrow,
			this._img_content_bg,
			this._gp_value,
			this._lb_income,
			this._img_icon,
			this._list_bag_con,
			this._lb_tips,
			this._lb_none,
			this._lb_title,
			this.text,
			this._gp_decompose,
			this.image2,
			this.label1,
			this._img_decompose_red,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_title_bg",
				"_img_close",
				"_img_arrow",
				"_img_content_bg",
				"_gp_value",
				"_lb_income",
				"_img_icon",
				"_list_bag_con",
				"_lb_tips",
				"_lb_none",
				"_lb_title",
				"text",
				"_gp_decompose",
				"image2",
				"label1",
				"_img_decompose_red",
			])
	}
}
window["HolySealDecomposeView"] = HolySealDecomposeView