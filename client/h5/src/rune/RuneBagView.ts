import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName";
import { Enum_UILayer } from "../common/LayerManager";
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr";
import { ResManager } from "../common/ResManager";
import { LuaSoundManager } from "../common/SoundManager";
import { GoodsModel } from "../commonModel/GoodsModel";
import { RuneEvent, RuneModel } from "../commonModel/RuneModel";
import { Message } from "../sysInfo/SysInfoController";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { ErlangParser } from "../util/ErlangParser";
import { GameResPath } from "../util/GameResPath";
import { Util } from "../util/Util";
import { RuneBagItem } from "./RuneBagItem";
import { DungeonEnterViewIndex } from "../commonModel/BaseDungeonModel";
import { RuneTreasureModel } from "../commonModel/RuneTreasureModel";
import { RuneTreasureEvent } from "../commonModel/RuneTreasureModel";
import { PlatformManager } from "../PlatformManager";

export class RuneBagView extends BaseView1 {

	_type_
	pos_id_

	LoadSuccess
	InitEvent
	SortFun
	FormatBagList
	OpenCallback
	SetBagItemList
	public constructor() {
		super()

		this.base_file = "rune"
		this.layout_file = "RuneBagView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose = true
		this.show_open_movie = true
		this.is_center = true
		let model = RuneModel.GetInstance()
		let goods_model = GoodsModel.GetInstance()
		this._type_ = 1   //1穿戴 2替換
		this.pos_id_ = 1
		let item_list_ = null
		let bag_loop_mgr:LoopScrowViewMgr
		this.load_callback = () => {
			if (PlatformManager.IsEyouEnPlatform()) {
				this.tips.wordWrap = true
			}
			this.LoadSuccess()
			this.InitEvent()
		}

		this.open_callback = () => {
			this.OpenCallback()
		}

		this.destroy_callback = () => {
			for (let _tmpi in item_list_) {
				var item = item_list_[_tmpi]
				item.DeleteMe()
			}
			item_list_ = null
			if (bag_loop_mgr) {
				bag_loop_mgr.DeleteMe()
				bag_loop_mgr = null
			}
		}

		this.LoadSuccess = () => {
			item_list_ = []
			this.bag_scroll.scrollBar.visible = false
			// ResManager.GetInstance().SetOutsideImageSprite(this, this._Image11, GameResPath.GetIcon("rune", "uisy_023"))
		}

		this.InitEvent = () => {
			let close_fun = () => {
				this.Close()
			}
			Util.AddClickEvent(this.closeBtn, close_fun, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)

			Util.AddClickEvent(this.getBtn, () => {
				if (this.pos_id_ == 9 || this.pos_id_ == 10) {
					RuneTreasureModel.GetInstance().Fire(RuneTreasureEvent.RUNE_TREASURE_OPEN_VIEW, "RuneTreasureBaseView", 1)
				} else {
					GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DungeonEnterView", DungeonEnterViewIndex.Rune)
				}
				this.Close()
			}
				, this, true)
			this.BindEvent(model, RuneEvent.CLOSE_BAG_VIEW, () => {
				this.Close()
			})
		}

		this.OpenCallback = () => {
			this.SetBagItemList(goods_model.runebag_goods_list)
		}

		this.SetBagItemList = (rune_goods_list?) => {
			let bag_list = []
			bag_list = this.FormatBagList(rune_goods_list, this._type_, this.pos_id_)
			if ((bag_list.length > 0 && bag_list[0]) && bag_list[0].goods_vo) {
				model.guide_goods_id = bag_list[0].goods_vo.goods_id
			}
			if (!bag_loop_mgr) {
				bag_loop_mgr = new LoopScrowViewMgr()
				bag_loop_mgr.SetData(this.bag_scroll, RuneBagItem, bag_list, LoopScrCon.Vertical, undefined)
			} else {
				bag_loop_mgr.replaceAll(bag_list)
			}

			if (bag_list.length > 0) {
				this.none_conta.visible = false
			} else {
				this.none_conta.visible = true
				if (this.pos_id_ == 9 || this.pos_id_ == 10) {
					this.tips.text = "参与御魂夺宝可以获取更多御魂~"
				} else {
					this.tips.text = "通关御魂高塔可以获取更多御魂~"
				}
			}
		}

		this.FormatBagList = (list?, _type?, pos_id?) => {
			let can_insert = []
			let not_insert = []
			let new_list = []
			let not_fit = false
			let item_data = null
			let basic = null
			let is_exclude = null
			let is_include = null
			if (list) {
				for (let _tmpi in list) {
					var obj = list[_tmpi]
					if (obj.subtype != 99) {
						item_data = []
						item_data.can_use = true
						not_fit = false
						item_data.goods_vo = obj
						item_data.type = _type
						item_data.pos_id = this.pos_id_
						item_data.pro_list = model.GetRuneProList(obj.subtype, obj.level, obj.color)
						let awakeIndex = 0
						let wake_cfg = model.GetWakeUpCfg()
						for (let _tmpi in item_data.goods_vo.awake_list) {
							var vo = item_data.goods_vo.awake_list[_tmpi]
							if (vo.awake_lv > awakeIndex) {
								awakeIndex = vo.awake_lv
							}
							for (let _tmpi in item_data.pro_list) {
								var pro = item_data.pro_list[_tmpi]
								if (vo.attr_type == pro[0]) {
									let cfg = wake_cfg[item_data.goods_vo.color + "@" + pro[0] + "@" + vo.awake_lv]
									if (cfg) {
										pro[1] = pro[1] + JSON.parse(cfg.attr)[0][1]
									}
								}
							}
						}
						obj.awakeIndex = awakeIndex
						is_exclude = model.IsExcludeSubtypeByPosId(pos_id, obj.subtype)
						is_include = model.IsIncludeSubtypeByPosId(pos_id, obj.subtype)
						if (is_exclude || !is_include) {
							not_fit = true
						}
						if (pos_id != 9 && pos_id != 10) {
							let find_same = model.FindIsWearTheSame(obj, _type)
							let wear = model.GetRuneDataByPosId(pos_id)
							let subtype = null
							let can_replace = false
							if (wear) {
								basic = goods_model.GetGoodsBasicByTypeId(wear.goods_id)
								if (basic) {
									subtype = basic.subtype
								}
								if (wear.attr_list) {
									for (let i = 0; i < item_data.pro_list.length; i++) {
										var v = item_data.pro_list[i]
										for (let j = 0; j < wear.attr_list.length; j++) {
											var val = wear.attr_list[j]
											if (val.attr_id == v[0]) {
												can_replace = true
												break
											}
										}
										if (can_replace) {
											break
										}
									}
								}
							}
							if ((_type == 1 && find_same) || (_type == 2 && find_same && subtype != obj.subtype && !can_replace)) {
								not_fit = true
							}
						}
						if (!not_fit) {
							item_data.can_use = true
							can_insert.push(item_data)
						} else if (pos_id != 9 && pos_id != 10 && obj.subtype != RuneModel.IgnoreAttackSubType && obj.subtype != RuneModel.IgnoreDefendSubType) {
							item_data.can_use = false
							not_insert.push(item_data)
						}
					}
				}
			}
			this.SortFun(can_insert)
			this.SortFun(not_insert)
			for (let i = 0; i < can_insert.length; i++) {
				var v = can_insert[i]
				new_list.push(v)
			}
			for (let i = 0; i < not_insert.length; i++) {
				var v = not_insert[i]
				new_list.push(v)
			}
			return new_list
		}

		this.SortFun = (list?) => {
			if (list) {
				let sort_fun = (a?, b?) => {
					if (a.goods_vo && b.goods_vo) {
						if (a.goods_vo.awakeIndex != b.goods_vo.awakeIndex) {
							return b.goods_vo.awakeIndex - a.goods_vo.awakeIndex
						} else if (a.goods_vo.color == b.goods_vo.color) {
							if (a.goods_vo.subtype == b.goods_vo.subtype) {
								return b.goods_vo.level - a.goods_vo.level
							} else {
								return b.goods_vo.subtype - a.goods_vo.subtype
							}
						} else {
							return b.goods_vo.color - a.goods_vo.color
						}
					} else {
						return true
					}
				}
				list.sort(sort_fun)
			}
		}
	}

	public Open(...new_args) {
		if (new_args && new_args.length > 0) {
			[this._type_, this.pos_id_] = new_args
		}
		super.Open()
	}


	_Image11: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	bag_scroll: Laya.List
	none_conta: Laya.Box
	getBtn: Laya.Box
	_Image1: Laya.Image
	labelDisplay: Laya.Label
	tips: Laya.Label
	tips_icon: Laya.Image
	closeBtn: Laya.Image
	label1: Laya.Label
	public GetComponents() {
		[
			this._Image11,
			this._Image2,
			this._Image3,
			this.bag_scroll,
			this.none_conta,
			this.getBtn,
			this._Image1,
			this.labelDisplay,
			this.tips,
			this.tips_icon,
			this.closeBtn,
			this.label1,
		]
			= this.GetChildrenByNames([

				"_Image11",
				"_Image2",
				"_Image3",
				"bag_scroll",
				"none_conta",
				"getBtn",
				"_Image1",
				"labelDisplay",
				"tips",
				"tips_icon",
				"closeBtn",
				"label1",
			])
	}
}
window["RuneBagView"] = RuneBagView