import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { table } from "../common/table"
import { Util } from "../util/Util"
import { ColorUtil } from "../util/ColorUtil"
import { CookieWrapper } from "../common/CookieWrapper"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { WordManager } from "../common/WordManager"
import { RedDotManager } from "../common/RedDotManager"
import { ErlangParser } from "../util/ErlangParser"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Message } from "../sysInfo/SysInfoController"
import { ModuleType } from "../common/RedDotManager"
import { ColorType } from "../util/ColorUtil"
import { Alert, Alert_Type } from "../alert/Alert"
import { longlangModel } from "../commonModel/longlangModel"
import { LoopScrowViewMgr, LoopScrCon } from "../common/LoopScrowViewMgr"
import { longlangDecItem } from "./longlangDecItem"
import { DownDropBtn } from "../common/DownDropBtn"

export class longlangDecView extends BaseItem1 {
	AutoDecompose
	ClickColor
	ClickStage
	Decompose
	GetBagList
	GetDecomposeList
	InitEvent
	LoadSuccess
	RefreshItem
	Remove
	UpdateAutoDecomposeState
	UpdateBag
	UpdateDecomposeReward
	UpdateView

	_dgp_bag_con
	_drop_color
	_drop_pos

	_time_id
	decompose_reward
	decompose_reward_cache
	loop_mgr
	cfg_draconic_equip

	public constructor(parent?) {
		super(parent)
		this.base_file = "longlanguage"
		this.layout_file = "longlangDecView"
		this.preload_server_config = {
			"config_draconic_equip": false
		}

		let local_longlangModel = longlangModel
		let local_longlangModelIns = local_longlangModel.GetInstance()
		let local_cookieW = CookieWrapper
		let local_msg = Message
		let local_goodsModel = GoodsModel
		let local_goodsModelIns = local_goodsModel.GetInstance()
		let local_resMgr = ResManager.GetInstance()
		let local_redMgr = RedDotManager.GetInstance()
		let local_colorUtil = ColorUtil
		let local_Erlang = ErlangParser.GetInstance()
		let auto_decompose_state_ = false
		let select_goods_dic_ = null
		let decBag_ = null
		let drop_color_ = 3
		let drop_stage_ = 8

		this.load_callback = () => {
			this.cfg_draconic_equip = ResManager.GetInstance().GetGameConfigFromCache(this, "config_draconic_equip", false)
			this._lb_tips.style.fontSize = 22
			this._lb_tips.style.color = "#663915"
			this._lb_tips.style.wordWrap = false
			this.LoadSuccess()
		}

		this.Remove = () => {
			//let obj = [auto_decompose_state=auto_decompose_state_, drop_color=drop_color_, drop_stage=drop_stage_]
			//local_cookieW:GetInstance():SaveCookie(local_cookieW.LONGLANG_DEC_INFO, local_Erlang.stringify(obj), true)
			drop_color_ = 3
			drop_stage_ = 8
			select_goods_dic_ = null
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._gp_decompose, () => {
				let goods_list = this.GetDecomposeList()
				if (goods_list.length && goods_list.length > 0) {
					let have_color_more_than_orange = false
					let decompose_func = () => {
						this.Decompose(goods_list)
					}
					for (let _tmpi in goods_list) {
						let goods_vo = goods_list[_tmpi]
						if (goods_vo.color >= 4) {
							have_color_more_than_orange = true
							break
						}
					}
					let alert = local_longlangModelIns.alertDec
					if (have_color_more_than_orange && !alert) {
						let content = Util.StrToHTML("所选中的神祭中包含橙色及以上品质的神祭，是否确定继续分解")
						Alert.Show(content, Alert_Type.AlertTypeCheckBox, decompose_func, null, null, null, null, false, (bool?) => {
							local_longlangModelIns.alertDec = bool
						}
							, "本次登录不再提示")
					} else {
						decompose_func()
					}
				} else {
					local_msg.show("请先选择需要分解的物品")
				}
			}, this, true)

			Util.AddClickEvent(this._img_arrow, () => {
				auto_decompose_state_ = !auto_decompose_state_
				local_longlangModelIns.auto_decompose_state_ = auto_decompose_state_
				this.UpdateAutoDecomposeState()
				if (auto_decompose_state_) {
					this.AutoDecompose()
				}
			}, this, true)

			this.BindEvent(local_longlangModelIns, local_longlangModel.SELECT_DEC_ITEM, (data?) => {
				if (data.is_selected) {
					select_goods_dic_[data.equip_info.goods_id] = data.equip_info
				} else {
					select_goods_dic_[data.equip_info.goods_id] = null
				}
				this.UpdateDecomposeReward()
			}
			)
			this.BindEvent(local_goodsModelIns, local_goodsModel.GOODS_DECOMPOSE_SUCCESS, () => {
				if (this.decompose_reward_cache) {
					let goods_vo = local_goodsModelIns.GetGoodsBasicByTypeId(local_longlangModel.MONEY_TYPE)
					if (goods_vo) {
						let color = local_colorUtil.GetColorLight(goods_vo.color)
						local_msg.show("<font color='#ffffff'>获得</font> <font color=" + color + ">" + goods_vo.goods_name + " x" + this.decompose_reward_cache + "</font>")
					}
					this.decompose_reward_cache = null
				}
			}
			)
			this.BindEvent(local_goodsModelIns, local_goodsModel.CHANGE_LONGLANG_BAG, () => {
				this.UpdateView()
			}
			)
			this.BindEvent(local_longlangModelIns, local_longlangModel.REFRESH_RED, (flag?) => {
				if (flag == 3) {
					this._img_decompose.visible = local_redMgr.CheckRedStatus(ModuleType.LONGLANG, 3)
				}
			}
			)
		}

		this.LoadSuccess = () => {
			local_resMgr.SetOutsideImageSprite(this, this._img_icon, GameResPath.GetGoodsIconPath(String(local_longlangModel.MONEY_TYPE)))

			select_goods_dic_ = []
			this._lb_tips.innerHTML = Util.StrToHTML("自动分解<font color='#e036f4'>紫色品质</font>以下神祭")

			this._drop_pos = new DownDropBtn(this._gp_pos)
			this._drop_color = new DownDropBtn(this._gp_color)

			let stage_drop_list = local_longlangModelIns.GetStageDropData()
			this._drop_pos.Init(stage_drop_list, this.ClickStage, WordManager.ConvertNum(drop_stage_) + "阶以下", "content", this.layer_value, 6, false, false)
			let color_drop_list = local_longlangModelIns.GetColorDropData()
			this._drop_color.Init(color_drop_list, this.ClickColor, local_colorUtil.GetColorName(drop_color_) + "以下", "content", this.layer_value, 5, false, false)
			this._drop_pos.Load()
			this._drop_color.Load()

			let obj = local_cookieW.GetInstance().GetCookie(local_cookieW.LONGLANG_DEC_INFO, true)
			if (obj) {
				let info = local_Erlang.Parse(obj)
				auto_decompose_state_ = info.auto_decompose_state || false
				drop_color_ = info.drop_color || drop_color_
				drop_stage_ = info.drop_stage || drop_stage_
			} else {
				auto_decompose_state_ = false
			}
			auto_decompose_state_ = local_longlangModelIns.auto_decompose_state_
			this.InitEvent()
			this.UpdateAutoDecomposeState()
			if (this.AutoDecompose()) {
				this.UpdateView()
			}
		}

		this.UpdateView = () => {
			select_goods_dic_ = []
			this._lb_income.text = "0"
			this.UpdateBag()
			this.RefreshItem()
			this.UpdateDecomposeReward()
		}

		this.GetBagList = (color?, stage?) => {
			let decompose_red = false
			let list = []
			let longlangBag = local_goodsModelIns.longlang_bag_list
			let equipCfg = this.cfg_draconic_equip
			if (equipCfg) {
				for (let _tmpi in longlangBag) {
					let equip_info = longlangBag[_tmpi]
					let dec_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods_decompose.name, equip_info.type_id, false)
					if (dec_cfg) {
						if (equip_info.type != local_longlangModel.GOODS_TYPE) {
							table.insert(list, { equip_info: equip_info, is_selected: true })
							select_goods_dic_[equip_info.goods_id] = equip_info
							decompose_red = true
						} else {
							if (local_longlangModel.MAX_DECOMPOSE_COLOR >= equip_info.color && !(equip_info.subtype > 6 && (equip_info.color == 5 || (equip_info.color == 4 && equip_info.stage > 3)))) {
								let longlangData = equipCfg[equip_info.type_id]
								if (longlangData) {
									let equipData = local_longlangModelIns.GetWearEquipByPos(longlangData.pos)
									if (equipData && (equipData.rating >= equip_info.rating || (equipData.color >= ColorType.ORANGE && equip_info.color <= ColorType.PURPLE))) {
										if (((!color || color >= equip_info.color) && (!stage || stage == 0 || stage >= longlangData.stage)) && equip_info.subtype < 7) {
											table.insert(list, { equip_info: equip_info, is_selected: true })
											select_goods_dic_[equip_info.goods_id] = equip_info
										} else {
											table.insert(list, { equip_info: equip_info, is_selected: false })
										}
									}
								}
							}
						}
					}
				}
			}
			let length = list.length
			let end = Math.max((6 -length % 6) + length, 24)
			for (let i = length; i < end; i++) {
				table.insert(list, { equip_info: { type_id: 0 }, is_selected: false })
			}
			this._img_decompose.visible = decompose_red || local_redMgr.CheckRedStatus(ModuleType.LONGLANG, 3)
			return list
		}

		this.UpdateBag = () => {
			let list = this.GetBagList(drop_color_, drop_stage_)
			let len = list.length
			this._scroll_bag_con.visible = len != 0
			decBag_ = list
		}

		this.RefreshItem = () => {
			if (!this.loop_mgr) {
				this.loop_mgr = new LoopScrowViewMgr(this.layer_value)
				this.loop_mgr.SetData(this._scroll_bag_con, longlangDecItem, decBag_, LoopScrCon.Vertical)
			} else {
				this.loop_mgr.replaceAll(decBag_)
			}
		}

		this.GetDecomposeList = () => {
			let list = []
			for (let id in select_goods_dic_) {
				let goods_vo = select_goods_dic_[id]
				table.insert(list, { goods_id: goods_vo.goods_id, goods_num: goods_vo.goods_num, color: goods_vo.color })
			}
			return list
		}

		this.UpdateDecomposeReward = () => {
			let reward_value = 0
			for (let key in select_goods_dic_) {
				let info = select_goods_dic_[key]
				if (info) {
					let cfgs = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_goods_decompose.name, info.type_id, false)
					if (cfgs) {
						let cfg = cfgs
						let reward = JSON.parse(cfg.regular_mat)
						for (let _tmpi in reward) {
							let vo = reward[_tmpi]
							reward_value = reward_value + vo[2] * info.goods_num
						}
					}
				}
			}
			this.decompose_reward = reward_value
			this._lb_income.text = String(reward_value)
		}

		this.UpdateAutoDecomposeState = () => {
			let source = auto_decompose_state_ && "com_ui_gx1" || "com_ui_gx"
			ResManager.GetInstance().SetImageSprite(this, this._img_arrow, "common", source)
		}

		this.ClickColor = (index?, data?) => {
			drop_color_ = data.cond
			this.UpdateView()
		}

		this.ClickStage = (index?, data?) => {
			drop_stage_ = data.cond
			this.UpdateView()
		}

		this.AutoDecompose = () => {
			if (!auto_decompose_state_) {
				return true
			}
			select_goods_dic_ = []
			let list = this.GetBagList(local_longlangModel.AUTO_DECOMPOSE_COLOR, 0)
			let goods_list = this.GetDecomposeList()
			if (goods_list.length && goods_list.length > 0) {
				decBag_ = list
				this.RefreshItem()
				this.Decompose(goods_list)
			}
			return goods_list.length == 0
		}

		this.Decompose = (goods_list?) => {
			if (this._time_id) {
				return
			}
			if (!select_goods_dic_) {
				return
			}
			let list = []
			for (let key in decBag_) {
				let goods_vo = decBag_[key]
				if (select_goods_dic_[goods_vo.equip_info.goods_id]) {
					list[key] = true
				}
			}
			// let now_index = []
			// let len = this.Content1.numChildren
			// let i = 0
			//do {
			//let item = this.Content1.GetChild(i)
			//// [ts2lua]now_index下标访问可能不正确
			//now_index[item.itemIndex] = [x=item.x, y=item.y - this._dgp_bag_con.scrollV]
			//i=i+1
			//} while ((i < len))
			//let register_protocals = false
			//for (let index in list) {

			//// [ts2lua]now_index下标访问可能不正确
			//let pos = now_index[index]
			//if (pos ) {
			//let group = local_eui. new Group()
			//group.x = pos.x + 87 / 2
			//group.y = pos.y + 87 / 2
			//this._gp_effect.addChild(group)
			//let call_back = () => {
			//Laya.Tween.removeTweens(group)
			//this._gp_effect.removeChild(group)
			//if (register_protocals ) {
			//register_protocals = true
			//}
			//}

			//this:AddUIEffect("ui_tunshi_glow", group, null, null, false, null, call_back, null, null, true)
			//}
			//}
			this._time_id = setTimeout(() => {
				this._time_id = null
				this.decompose_reward_cache = this.decompose_reward
				local_goodsModelIns.Fire(local_goodsModel.RESOLVE_GOODS, goods_list)
			}
				, 0.3)
		}
	}

	public DeleteMe() {
		if (this.loop_mgr) {
			this.loop_mgr.DeleteMe()
			this.loop_mgr = null
		}
		this.Remove()
		super.DeleteMe()
	}

	_img_bg: Laya.Image
	_gp_decompose: Laya.Box
	_Image2: Laya.Image
	_Label1: Laya.Label
	_img_decompose: Laya.Image
	_Label2: Laya.Label
	_Group1: Laya.HBox
	_lb_income: Laya.Label
	_img_icon: Laya.Image
	_lb_tips: Laya.HTMLDivElement
	_img_arrow: Laya.Image
	_scroll_bag_con: Laya.List
	_gp_color: Laya.Box
	_gp_pos: Laya.Box
	public GetComponents() {
		[
			this._img_bg,
			this._gp_decompose,
			this._Image2,
			this._Label1,
			this._img_decompose,
			this._Label2,
			this._Group1,
			this._lb_income,
			this._img_icon,
			this._lb_tips,
			this._img_arrow,
			this._scroll_bag_con,
			this._gp_color,
			this._gp_pos,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_gp_decompose",
				"_Image2",
				"_Label1",
				"_img_decompose",
				"_Label2",
				"_Group1",
				"_lb_income",
				"_img_icon",
				"_lb_tips",
				"_img_arrow",
				"_scroll_bag_con",
				"_gp_color",
				"_gp_pos",
			])
	}
}
window["longlangDecView"] = longlangDecView