import { BaseView1 } from "../common/BaseView1"
import { Util, GetSizeDeltaY } from "../util/Util"
import { table } from "../common/table"
import { Enum_UILayer } from "../common/LayerManager"
import { ColorType } from "../util/ColorUtil"
import { WordManager } from "../common/WordManager"
import { longlangModel } from "../commonModel/longlangModel"
import { UIVerTabBar } from "../newgameui/UIVerTabBar"
import { longlangEquipItem } from "./longlangEquipItem"
import { ResManager } from "../common/ResManager"
import { longVerTabBtn } from "./longVerTabBtn"
import { longVerTabSubBtn } from "./longVerTabSubBtn"

export class longlangSuitView extends BaseView1 {
	CloseFunc
	GetSuitList
	InitTab
	InitView
	SwitchFunc

	tabbar
	cfg_draconic_suit
	cfg_draconic_equip

	public constructor() {
		super()
		this.base_file = "longlanguage"
		this.layout_file = "longlangSuitView"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.destroy_imm = true
		this.preload_server_config = {
			"config_draconic_suit": false,
			"config_draconic_equip": false
		}

		let local_longlangModel = longlangModel
		let local_longlangModelIns = local_longlangModel.GetInstance()
		let local_wordMgr = WordManager
		let suitInfo_ = []
		let EquipList_ = []
		let curSuitInfo_ = []
		let textList_ = []

		this.load_callback = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this.bg2, "resource/game/longlanguage/other/ui_lybg_2.jpg")
			this.cfg_draconic_suit = ResManager.GetInstance().GetGameConfigFromCache(this, "config_draconic_suit", false)
			this.cfg_draconic_equip = ResManager.GetInstance().GetGameConfigFromCache(this, "config_draconic_equip", false)
			this._Scroller1.vScrollBarSkin = ""
			this._lb_attrs.style.fontSize = 20
			this._lb_attrs.style.color = "#663915"
			this._lb_attrs.width = 300
			this._lb_attrs.style.leading = 6
		}

		this.open_callback = () => {
			this.InitView()
		}

		this.destroy_callback = () => {
			this.CloseFunc()
		}

		this.InitView = () => {
			Util.AddClickEvent(this.closeBtn, () => {
				this.Close()
			}, this, true)

			if (!this.tabbar) {
				this.tabbar = new UIVerTabBar(this._gp_tab)
				this.tabbar.Load()
			}
			this.BindEvent(local_longlangModelIns, local_longlangModel.SUIT_INOF, (scmd?) => {
				curSuitInfo_ = []
				for (let _tmpi in scmd.suit) {
					let vo = scmd.suit[_tmpi]
					curSuitInfo_[vo.suit_id] = vo.num
				}
				this.InitTab(scmd)
			}
			)
			local_longlangModelIns.Fire(local_longlangModel.SEND_PROTO, 62209)
			//this:AddUIEffect("ui_draconic_arrary", this.effect0, null, 0.7, true)
			//this:AddUIEffect("ui_draconic_eye", this.effect1, null, 0.7, true)
			//this:AddUIEffect("ui_draconic_wenli_life", this.effect2, null, 0.7, true)
			//this:AddUIEffect("ui_draconic_wenli_right", this.effect3, null, 0.7, true)
			// this.AddUIEffect("UI_1303e", this.layer_value, this.effect1, null, null, true)
			// this.AddUIEffect("UI_1303d", this.layer_value, this.effect0, null, 0.7, true, {
			// 	custom_sorting_order = this.cover_effect_cache_sort_order, load_call_back =() => {
			// 		this.CoverEffect(this.equipGp, this.layer_value, this.cover_effect_cache_sort_order)
			// 	}
			// })
		}

		this.InitTab = (scmd?) => {
			let tabList = this.GetSuitList()
			this.tabbar.SetTabBar(tabList, (a?, b?) => {
				this.SwitchFunc(a, b)
			}, GetSizeDeltaY(this._gp_tab), null, longVerTabBtn, null, null, longVerTabSubBtn)
			this.tabbar.SetSelectTab(0, 0)
			// this.tabbar.RefreshSrollerPos()
			this.SwitchFunc(0, 0)
		}

		this.SwitchFunc = (index?, subIndex?) => {
			let cfg = this.cfg_draconic_suit
			let equipCfg = this.cfg_draconic_equip
			let showPos = []
			if (cfg && equipCfg) {
				let data = suitInfo_[index] && suitInfo_[index][1][subIndex]
				if (data) {
					let curSuit = cfg[data]
					if (curSuit) {
						let draconic = JSON.parse(curSuit.draconic)
						let haveCount = curSuitInfo_[data] || 0
						for (let _tmpi in draconic) {
							let vo1 = draconic[_tmpi]
							let v_0 = Number(vo1)
							let equipData = equipCfg[v_0]
							if (equipData) {
								// let wearEquip = local_longlangModelIns.GetWearEquipByPos(equipData.pos)
								showPos[equipData.pos] = vo1
							}
						}
						let all_str = ""
						let suitStr = null
						// let color = "#7a5f51"
						let count = 0
						let suitAttr = JSON.parse(curSuit.attr)
						let i = 0
						do {
							suitStr = ""
							let vo = suitAttr[i]
							vo[0] = Number(vo[0])
							if (haveCount >= vo[0]) {
								// color = "#639c12"
								count = vo[0]
							} else {
								// color = "#7a5f51"
								count = haveCount
							}
							suitStr = suitStr + "穿戴" + vo[0] + "件装备激活【" + count + "/" + vo[0] + "】<br>"
							for (let _tmpi in vo[1]) {
								let attr = vo[1][_tmpi]
								let str = local_wordMgr.GetProperties(attr[0])
								suitStr = suitStr + "&nbsp;&nbsp;&nbsp;" + str + " :<font color='#d15e00'>" + local_wordMgr.ConvertToPercentValue(attr[0], attr[1]) + "</font><br>"
							}

							if (i == (suitAttr.length - 1)) {
								all_str = all_str + suitStr
							} else {
								all_str = all_str + suitStr + "&nbsp;<br>"
							}
							i = i + 1
						} while ((i < suitAttr.length))
						this._lb_attrs.innerHTML = all_str
						this._lb_attrs.width = 300
						this.Content.height = this._lb_attrs.contextHeight
					}
				}
			}
			let i = 1
			do {
				let id = showPos[i]
				let item = EquipList_[i]
				if (id) {
					if (!item) {
						let parent = this["_gp_" + (i - 1)]
						item = new longlangEquipItem(parent)
						item.Load()
						EquipList_[i] = item
					}
					item.SetVisible(true)
					item.SetData({ equip_type: i, type_id: id, suit: true })
				} else if (item) {
					item.SetVisible(false)
				}
				i = i + 1
			} while ((i <= local_longlangModel.EQUIP_COUNT))
		}

		this.GetSuitList = () => {
			let suitCfg = this.cfg_draconic_suit
			suitInfo_ = []
			let tabList = []
			let stageList = []
			let dataList = []
			// let infoList = []
			if (suitCfg) {
				// let local_colorType = ColorType
				for (let key in suitCfg) {
					let vo = suitCfg[key]
					let stageInfo = stageList[vo.stage]
					if (!stageInfo) {
						stageInfo = [vo.stage + "阶套装", []]
					}
					let subArr = stageInfo[1]
					// let color = "6193ca"
					// if (local_colorType.PURPLE == vo.color) {
					// 	color = "9f71d2"
					// } else if (local_colorType.ORANGE == vo.color) {
					// 	color = "e37e35"
					// } else if (local_colorType.RED == vo.color) {
					// 	color = "ed674b"
					// } else if (local_colorType.PINK == vo.color) {
					// 	color = "e85070"
					// }
					table.insert(subArr, [vo.color, vo.color + "@" + vo.name, vo.id])

					let data = dataList[vo.stage]
					if (!data) {
						data = [vo.stage, []]
					}
					let dataArr = data[1]
					table.insert(dataArr, vo.id)
					stageList[vo.stage] = stageInfo
					dataList[vo.stage] = data
				}
				for (let key in stageList) {
					table.insert(tabList, stageList[key])
				}
				for (let key in dataList) {
					table.insert(suitInfo_, dataList[key])
				}
				for (let _ in tabList) {
					let v = tabList[_]
					if (v[1] && v[1].length > 1) {
						table.sort(v[1], (a?, b?) => {
							return a[2] < b[2]
						})
					}
				}
				for (let _ in suitInfo_) {
					let v = suitInfo_[_]
					if (v[1] && v[1].length > 1) {
						table.sort(v[1], (a?, b?) => {
							return a < b
						})
					}
				}
			}
			return tabList
		}

		this.CloseFunc = () => {
			if (this.tabbar) {
				this.tabbar.DeleteMe()
				this.tabbar = null
			}
			if (EquipList_) {
				for (let key in EquipList_) {
					EquipList_[key].DeleteMe()
					EquipList_[key] = null
				}
				EquipList_ = []
			}
			if (textList_) {
				textList_ = []
			}
		}
	}

	bg: Laya.Image
	bg2: Laya.Image
	bg3: Laya.Image
	closeBtn: Laya.Image
	_img_title: Laya.Image
	_lb_title: Laya.Label
	_img_title2: Laya.Image
	_lb_title2: Laya.Label
	_img_title3: Laya.Image
	_lb_title3: Laya.Label
	equipGp: Laya.Box
	_gp_0: Laya.Box
	_gp_1: Laya.Box
	_gp_2: Laya.Box
	_gp_3: Laya.Box
	_gp_4: Laya.Box
	_gp_5: Laya.Box
	_gp_6: Laya.Box
	_gp_7: Laya.Box
	_gp_8: Laya.Box
	_gp_9: Laya.Box
	_gp_10: Laya.Box
	_Scroller1: Laya.Panel
	Content: Laya.VBox
	_lb_attrs: Laya.HTMLDivElement
	_gp_tab: Laya.Box
	public GetComponents() {
		[
			this.bg,
			this.bg2,
			this.bg3,
			this.closeBtn,
			this._img_title,
			this._lb_title,
			this._img_title2,
			this._lb_title2,
			this._img_title3,
			this._lb_title3,
			this.equipGp,
			this._gp_0,
			this._gp_1,
			this._gp_2,
			this._gp_3,
			this._gp_4,
			this._gp_5,
			this._gp_6,
			this._gp_7,
			this._gp_8,
			this._gp_9,
			this._gp_10,
			this._Scroller1,
			this.Content,
			this._lb_attrs,
			this._gp_tab,
		]
			= this.GetChildrenByNames([
				"bg",
				"bg2",
				"bg3",
				"closeBtn",
				"_img_title",
				"_lb_title",
				"_img_title2",
				"_lb_title2",
				"_img_title3",
				"_lb_title3",
				"equipGp",
				"_gp_0",
				"_gp_1",
				"_gp_2",
				"_gp_3",
				"_gp_4",
				"_gp_5",
				"_gp_6",
				"_gp_7",
				"_gp_8",
				"_gp_9",
				"_gp_10",
				"_Scroller1",
				"Content",
				"_lb_attrs",
				"_gp_tab",
			])
	}
}
window["longlangSuitView"] = longlangSuitView