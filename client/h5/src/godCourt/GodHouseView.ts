import { BaseView1 } from "../common/BaseView1"
import { Util, SetAnchoredPosition } from "../util/Util"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { OpenFun } from "../common/OpenFun"
import { Runner } from "../util/Runner"
import { Message } from "../sysInfo/SysInfoController"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { InstructionType } from "../common/InstructionType"
import { ColorUtil, ColorType } from "../util/ColorUtil"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { Alert, Alert_Type } from "../alert/Alert"
import { MaterialsTool } from "../common/MaterialsTool"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GodCourtModel } from "../commonModel/GodCourtModel"
import { GCRewardItem } from "./GCRewardItem"
import { GCCryItem } from "./GCCryItem"

import "./GodCourtRewardView"
import "./GodHouseRewardView"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"

export class GodHouseView extends BaseView1 {
	DesFunc
	InitColorImg
	InitEvent
	InitKeyData
	InitView
	PlayColorAni
	RewardGp
	RomoveRune
	Update
	UpdateColor
	UpdateLvData
	UpdateScroller
	RefreshRed

	cfg_god_house_cr
	cfg_god_house_lv
	cfg_god_court_kv
	loop_mgr

	public constructor() {
		super()
		this.base_file = "godCourt"
		this.layout_file = "GodHouseView"
		this.layer_value = Enum_UILayer.Activity
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.preload_server_config = {
			"config_god_house_crystal": false,
			"config_god_house_lv": false,
			"config_god_court_kv": false
		}

		let model = GodCourtModel.GetInstance()
		let local_runer = Runner.GetInstance()
		let AniList = [
			{ x1: 205, y1: 200, scale: 1, alpha: 1 },
			{ x1: 400, y1: 130, scale: 1, alpha: 0.65 },
			{ x1: 300, y1: 10, scale: 1, alpha: 0.5 },
			{ x1: 100, y1: 10, scale: 1, alpha: 0.5 },
			{ x1: 0, y1: 130, scale: 1, alpha: 0.65 }
		]
		let showColor = 0
		let schedule = 0
		let showAni = false
		let curRealColor = 0
		let cryItemList = []
		let runId = null
		let AniShow = []
		// let rewardList = null
		let oldColorIndex = null

		this.load_callback = () => {
			this.cfg_god_house_cr = ResManager.GetInstance().GetGameConfigFromCache(this, "config_god_house_crystal", false)
			this.cfg_god_house_lv = ResManager.GetInstance().GetGameConfigFromCache(this, "config_god_house_lv", false)
			this.cfg_god_court_kv = ResManager.GetInstance().GetGameConfigFromCache(this, "config_god_court_kv", false)
			model.Fire(GodCourtModel.SEND_SCMD, "23306")

			this._Scroller1.hScrollBarSkin = ""
			this.curColorLv.style.fontSize = 20
			this.curColorLv.style.color = "#0a953e"
			this.curColorLv.style.wordWrap = false
			this.colorUpNum.style.fontSize = 20
			this.colorUpNum.style.color = "#663915"
			this.colorUpNum.style.wordWrap = false

			this.InitView()
			this.InitEvent()
		}

		this.destroy_callback = () => {
			this.DesFunc()
		}

		this.InitView = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg1, "resource/game/godCourt/other/u_Divinei_05.png")
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_line, GameResPath.GetIcon("common2", "com_line_5"))
			this.img_right_red.visible = false
			let i = 0
			do {
				let item = new GCCryItem(this.cryItemGp)
				item.SetColor(i)
				item.Load()
				cryItemList[i] = item
				i = i + 1
			} while ((i < 5))
			this.UpdateLvData()
			this.UpdateColor()
			let func = () => {
				this.RefreshRed()
			}
			this._Scroller1.scrollBar.on(Laya.Event.CHANGE, this, func)
			this.RefreshRed()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._btn_close, () => {
				this.Close()
			}, this, true)

			Util.AddClickEvent(this._btn_shop, () => {
				OpenFun.OpenFunHandler(173)
				this.Close()
			}, this, true)

			Util.AddClickEvent(this.insBtn, () => {
				GlobalEventSystem.Fire(EventName.OPEN_INSTRUCTION_VIEW, InstructionType.GodHouse)
			}, this, true)

			Util.AddClickEvent(this._btn_upColor, () => {
				let curData = model.houseData
				if (curData && curData.crystal_color >= ColorType.ORANGE) {
					if (curData.crystal_color == ColorType.ORANGE) {
						Message.show("当前已是橙色品质无需再提升")
					} else {
						Message.show("当前已是最高品质无需再提升")
					}
				} else {
					let OpenFunc = () => {
						model.Fire(GodCourtModel.SEND_SCMD, 23307)
					}
					let enough = GoodsModel.GetInstance().GetTypeGoodsNum(801707) > 0
					if (!enough && model.CheckUpColor) {
						Alert.Show("当前" + GoodsModel.GetGoodsNameWithColorDark(801707) + "道具不足，花费勾玉升橙后也无法开启水晶，是否继续？", Alert_Type.AlertTypeCheckBox, OpenFunc, null, null, null, null, null, (bool?) => {
							model.CheckUpColor = bool
						}
						)
					} else {
						OpenFunc()
					}
				}
			}
				, this, true)

			Util.AddClickEvent(this._btn_open, () => {
				let enough = GoodsModel.GetInstance().GetTypeGoodsNum(801707) > 0
				if (!enough) {
					MaterialsTool.GetInstance().materialsTips(801707)
				} else {
					this.InitColorImg(showColor)
					model.Fire(GodCourtModel.SEND_SCMD, 23308)
				}
			}, this, true)

			this.BindEvent(model, GodCourtModel.UPDATE_COLOR, () => {
				this.UpdateColor(true)
			})
			this.BindEvent(model, GodCourtModel.UPDATE_LVDATA, () => {
				this.UpdateLvData()
			})
			this.BindEvent(model, GodCourtModel.UPDATE_HOUSE, () => {
				this.UpdateColor()
				this.UpdateLvData()
			})
			this.BindEvent(model, GodCourtModel.REFRESH_RED, (type?) => {
				if (type == 8) {
					this.openRed.visible = model.lotteryRed
				}
			})
			this.BindEvent(GoodsModel.GetInstance(), GoodsModel.CHANGE_BAG_LIST, () => {
				if (this.use_delete_method) {
					return
				}
				let goodsNum = GoodsModel.GetInstance().GetTypeGoodsNum(801707)
				let color = goodsNum >= 1 && "#0a953e" || "#ff4f50"
				this.keyLb.color = color
				this.keyLb.text = goodsNum + "/1"
			})
			this.BindEvent(GlobalEventSystem, EventName.MATERIAL_VIEW_CLOSE, () => {
				this.Close()
			})
			Util.AddClickEvent(this.keyImg, () => {
				UIToolTipMgr.GetInstance().AppendGoodsTips(801707)
			}, this, true)

			this.InitKeyData()
			this.UpdateColor()
		}

		this.PlayColorAni = () => {
			if (runId) {
				return
			}
			runId = local_runer.AddRunObj(this)
		}

		this.Update = (now_time?, elapse_time?) => {
			schedule = schedule + elapse_time * 1.4
			if (schedule > 1) {
				schedule = 1
			}
			let i = 0
			do {
				let item = cryItemList[i]
				let posInfo = AniList[(i + 6 - curRealColor) % 5]
				let nextInfo = null
				let left = showColor > curRealColor
				if (left) {
					nextInfo = AniList[(i + 5 - curRealColor) % 5]
				} else {
					nextInfo = AniList[(i + 7 - curRealColor) % 5]
				}
				if (item) {
					item.SetPos(posInfo.x1 + (nextInfo.x1 - posInfo.x1) * schedule, posInfo.y1 + (nextInfo.y1 - posInfo.y1) * schedule)
					item.SetScale(posInfo.scale + (nextInfo.scale - posInfo.scale) * schedule)
					item.SetAlpha(posInfo.alpha + (nextInfo.alpha - posInfo.alpha) * schedule)
				}
				i = i + 1
			} while ((i < 5))
			if (schedule >= 1) {
				curRealColor = showColor > curRealColor && (curRealColor + 1) || (curRealColor - 1)
				schedule = 0
				if (showColor == curRealColor) {
					let i = 0
					do {
						cryItemList[i].SetEffect(showColor == i + 1)
						i = i + 1
					} while ((i < 5))
					this.RomoveRune()
				}
			}
		}

		this.UpdateLvData = () => {
			let cfg = this.cfg_god_house_lv
			this.houseLvLb.text = "Lv." + model.houseLv
			let houseData = model.houseData
			if (houseData) {
				let curCfg = cfg && cfg[model.houseLv + 1]
				let str = null
				if (!curCfg) {
					str = "已满级"
					this.expImg.width = 327
				} else {
					this.expImg.width = Math.min(houseData.house_exp / curCfg.exp, 1) * 327
					str = houseData.house_exp + "/" + curCfg.exp
				}
				this.expLb.text = str
			}
		}

		this.RefreshRed = () => {
			let curData = model.houseData.grand_status
			let bool = false
			if (this._Scroller1.scrollBar) {
				let value = this._Scroller1.scrollBar.value
				let item_width = 90
				let length
				for (let index in curData) {
					let tab = curData[index]
					if (tab && tab.status == 1) {
						length = item_width * (Number(index) + 1) - this._Scroller1.width - 20 // 20 计算向左的偏移量
						if (length > value) {
							bool = true
							break
						}
					}
				}
			}
			if (this.img_right_red){
				this.img_right_red.visible = bool
			}
		}

		this.UpdateColor = (showAni?) => {
			let colorCfg = this.cfg_god_house_cr
			let curData = model.houseData
			if ((colorCfg && curData) && curData.grand_status != 0) {
				let color = curData.crystal_color
				// color = 5
				if (showAni) {
					showColor = color
					this.PlayColorAni()
				} else {
					this.InitColorImg(color)
				}
				this.ClearUIEffect(this.colorEffectGp)
				for (let i = 1; i <= 5; i++) {
					let obj = this["color" + i]
					// obj.gray = true
					obj.alpha = 0.3
				}
				let show_obj = this["color" + color]
				// show_obj.gray = false
				show_obj.alpha = 1
				let res = GodCourtModel.GetColorEffectName(color) + "2"
				let pos = {
					1:33,
					2:17,
					3:0,
					4:-17,
					5:-33
				}
				this.AddUIEffect(res, this.colorEffectGp, { x: pos[color], y: 0 }, 15, true)
				// if (!rewardList) {
					// rewardList = []
				// }

				// for (let _tmpi in curData.grand_status) {
				// 	let vo = curData.grand_status[_tmpi]
				// 	let item = rewardList[vo.times]
				// 	if (!item) {
				// 		item = new GCRewardItem(this.Content)
				// 		item.Load()
				// 		//item.SetSortOrder(this.cacheSortOrder)
				// 		rewardList[vo.times] = item
				// 	}
				// 	item.SetData(vo)
				// }

				if(!this.loop_mgr){
					this.loop_mgr = new LoopScrowViewMgr()
					this.loop_mgr.SetData(this._Scroller1, GCRewardItem, curData.grand_status, LoopScrCon.Horizontal)
				}else{
					this.loop_mgr.replaceAll(curData.grand_status)
				}


				if (color >= ColorType.ORANGE) {
					this.upNeedLb.text = ""
					this.upColorImg.visible = false
				} else if (colorCfg[color]) {
					let cost = JSON.parse(colorCfg[color].origin_cost)
					let [type_id, bind] = GoodsModel.GetInstance().GetMappingTypeId(cost[0][0], cost[0][1])
					ResManager.GetInstance().SetOutsideImageSprite(this, this.upColorImg, GameResPath.GetGoodsIconPath(type_id.toString()))
					this.upNeedLb.text = cost[0][2]
					this.upColorImg.visible = true
				}
				this.colorUpNum.innerHTML = Util.StrToHTML("勾玉提升次数：<font color='#0a953e'>" + curData.daily_num + "（周一4点重置）</font>")
				this.curColorLv.innerHTML = Util.StrToHTML("当前最高可开出<font color=" + ColorUtil.GetColorDark(color) + ">" + ColorUtil.GetColorName(color) + "</font>纹章")
				this.UpdateScroller(color)
				this.RefreshRed()
			}
		}

		this.InitColorImg = (needShowColor?) => {
			let i = 0
			do {
				let item = cryItemList[i]
				let colorInfo = AniList[(i + 6 - needShowColor) % 5]
				if (item && colorInfo) {
					//SetAnchoredPosition(item.display_obj, colorInfo.x1, colorInfo.y1)
					item.SetPos(colorInfo.x1, colorInfo.y1)
					item.SetScale(colorInfo.scale)
					item.SetAlpha(colorInfo.alpha)
					item.SetEffect((i + 1) == needShowColor)
				}
				i = i + 1
			} while ((i < 5))
			showColor = needShowColor
			curRealColor = showColor
		}

		this.UpdateScroller = (color?) => {

		}

		this.InitKeyData = () => {
			let kvCfg = this.cfg_god_court_kv
			if (kvCfg) {
				let matCfg = kvCfg[5]
				if (matCfg) {
					let MatData = JSON.parse(matCfg.value)
					let [type_id, bind] = GoodsModel.GetInstance().GetMappingTypeId(MatData[0][0], MatData[0][1])
					let goodsBasic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
					let goodsNum = GoodsModel.GetInstance().GetTypeGoodsNum(type_id)
					if (goodsBasic) {
						ResManager.GetInstance().SetOutsideImageSprite(this, this.keyImg, GameResPath.GetGoodsIconPath(goodsBasic.goods_icon))
					}
					let color = goodsNum >= 1 && "#0a953e" || "#ff4f50"
					this.keyLb.color = color
					this.keyLb.text = goodsNum + "/1"
				}
				this.openRed.visible = model.lotteryRed
			}
		}

		this.RomoveRune = () => {
			if (runId) {
				local_runer.RemoveRunObj(runId)
				runId = null
			}
		}

		this.DesFunc = () => {
			this.RomoveRune()
			if (this.loop_mgr) {
				this.loop_mgr.DeleteMe()
				this.loop_mgr = null
			}
			
			for (let _tmpi in cryItemList) {
				let vo = cryItemList[_tmpi]
				vo.DeleteMe()
			}
			cryItemList = []
			this.ClearUIEffect(this.colorEffectGp)
		}
	}

	_img_bg0: Laya.Image
	_img_bg1: Laya.Image
	_img_bg2: Laya.Image
	_img_bg3: Laya.Image
	_img_line: Laya.Image
	_img_title: Laya.Image
	_lb_title: Laya.Label
	_btn_close: Laya.Image
	_gp_icon: Laya.Image
	_lb_house: Laya.Label
	houseLvLb: Laya.Label
	_lb_tips1: Laya.Label
	cryItemGp: Laya.Box
	curColorLv: Laya.HTMLDivElement
	_btn_shop: Laya.Image
	color1: Laya.Image
	color2: Laya.Image
	color3: Laya.Image
	color4: Laya.Image
	color5: Laya.Image
	colorEffectGp: Laya.Box
	colorImg: Laya.Image
	_img_tips: Laya.Image
	insBtn: Laya.Image
	upColorImg: Laya.Image
	keyImg: Laya.Image
	arrow1: Laya.Image
	arrow2: Laya.Image
	arrow3: Laya.Image
	arrow4: Laya.Image
	_btn_upColor: Laya.Box
	_img_upBtn: Laya.Image
	_lb_upBtn: Laya.Label
	_btn_open: Laya.Box
	_img_openBtn: Laya.Image
	_lb_openBtn: Laya.Label
	openRed: Laya.Image
	_img_proBg: Laya.Image
	expImg: Laya.Image
	expLb: Laya.Label
	keyLb: Laya.Label
	upNeedLb: Laya.Label
	colorUpNum: Laya.HTMLDivElement
	_lb_tips2: Laya.Label
	_Scroller1: Laya.List
	// Content: Laya.HBox
	img_arrow_left: Laya.Image
	img_arrow_right: Laya.Image
	img_right_red
	public GetComponents() {
		[
			this._img_bg0,
			this._img_bg1,
			this._img_bg2,
			this._img_bg3,
			this._img_line,
			this._img_title,
			this._lb_title,
			this._btn_close,
			this._gp_icon,
			this._lb_house,
			this.houseLvLb,
			this._lb_tips1,
			this.cryItemGp,
			this.curColorLv,
			this._btn_shop,
			this.color1,
			this.color2,
			this.color3,
			this.color4,
			this.color5,
			this.colorEffectGp,
			this.colorImg,
			this._img_tips,
			this.insBtn,
			this.upColorImg,
			this.keyImg,
			this.arrow1,
			this.arrow2,
			this.arrow3,
			this.arrow4,
			this._btn_upColor,
			this._img_upBtn,
			this._lb_upBtn,
			this._btn_open,
			this._img_openBtn,
			this._lb_openBtn,
			this.openRed,
			this._img_proBg,
			this.expImg,
			this.expLb,
			this.keyLb,
			this.upNeedLb,
			this.colorUpNum,
			this._lb_tips2,
			this._Scroller1,
			// this.Content,
			this.img_arrow_left,
			this.img_arrow_right,
			this.img_right_red
		]
			= this.GetChildrenByNames([

				"_img_bg0",
				"_img_bg1",
				"_img_bg2",
				"_img_bg3",
				"_img_line",
				"_img_title",
				"_lb_title",
				"_btn_close",
				"_gp_icon",
				"_lb_house",
				"houseLvLb",
				"_lb_tips1",
				"cryItemGp",
				"curColorLv",
				"_btn_shop",
				"color1",
				"color2",
				"color3",
				"color4",
				"color5",
				"colorEffectGp",
				"colorImg",
				"_img_tips",
				"insBtn",
				"upColorImg",
				"keyImg",
				"arrow1",
				"arrow2",
				"arrow3",
				"arrow4",
				"_btn_upColor",
				"_img_upBtn",
				"_lb_upBtn",
				"_btn_open",
				"_img_openBtn",
				"_lb_openBtn",
				"openRed",
				"_img_proBg",
				"expImg",
				"expLb",
				"keyLb",
				"upNeedLb",
				"colorUpNum",
				"_lb_tips2",
				"_Scroller1",
				// "Content",
				"img_arrow_left",
				"img_arrow_right",
				"img_right_red"
			])
	}
}
window["GodHouseView"] = GodHouseView