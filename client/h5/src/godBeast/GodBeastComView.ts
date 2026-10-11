import { Alert, Alert_Type } from "../alert/Alert"
import { BaseView1 } from "../common/BaseView1"
import { CommonManager } from "../common/CommonManager"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { CookieWrapper } from "../common/CookieWrapper"
import { DownDropBtn } from "../common/DownDropBtn"
import { EquipmentItem } from "../common/EquipmentItem"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { CompositeModel } from "../commonModel/CompositeModel"
import { GodBeastEvent, GodBeastModel } from "../commonModel/GodBeastModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { HaloModel, HaloPrivilegeType } from "../commonModel/HaloModel"
import { MainFunc } from "../commonModel/MainUIModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { PlayBigEffect, SetHtmlCenter, Util } from "../util/Util"
import { GodBeastComBagItem } from "./GodBeastComBagItem"

/**蜃妖合成界面*/
export class GodBeastComView extends BaseView1 {

	static SelectColor = {

	}


	public itemList = []
	public targetItem: EquipmentItem
	// public bagArr: eui.ArrayCollection
	public downBtn: DownDropBtn
	/**当前选中的装备列表*/
	public idToItem = {}

	InitView
	ColorClick
	InitEvent
	CheckTips
	AutoSelect
	SelectItem
	UpdateBag
	CloseFunc
	SetTarget
	Clear
	InitHalo
	UpdateHalo
	UpdateMergeCheckBox
	ComFunc
	TryShowAwardView

	bag_loop_list
	bag_loop_mgr: LoopScrowViewMgr
	auto_composite_list
	try_close_auto_com
	public constructor() {
		super()
		let model = GodBeastModel.GetInstance(),
			// comModel = CompositeModel.GetInstance(),
			res_mgr = ResManager.GetInstance(),
			cookie_wrapper = CookieWrapper.GetInstance(),
			local_CookieWrapper = CookieWrapper,
			local_Util = Util,
			local_TimeUtil = TimeUtil,
			local_GodBeastEvent = GodBeastEvent,
			local_Message = Message,
			goods_model = GoodsModel.GetInstance(),
			selectList_ = {},
			/**目标的等级和星数*/
			targetColor_,
			targetStar_,
			comId_,
			comSelectId_,
			cfg_,
			clickTime_

		this.base_file = "godBeast"
		this.layout_file = "GodBeastComView"
		this.is_center = true
		this.click_bg_toClose = true
		this.use_background = true
		this.destroy_imm = true
		this.layer_value = Enum_UILayer.Activity
		this.load_callback = function () {
			this.InitView()
			this.InitEvent()
		}
		this.destroy_callback = function () {
			this.CloseFunc()
		}
		this.preload_client_config = {
			"ConfigGodBeast": false
		}
		this.preload_server_config = {
			"config_eudemons_equip_attr": false,
			"config_eudemons_compose": false,
		}
		this.InitView = () => {
			cfg_ = res_mgr.GetGameConfigFromCache(this, "config_eudemons_compose", false)
			let config_god_beast = res_mgr.GetGameConfigFromCache(this, "ConfigGodBeast", true)

			let com_id = cookie_wrapper.GetCookie(local_CookieWrapper.BEAST_COM_ID, true)
			if (com_id) {
				comSelectId_ = Number(com_id)
			}

			let color_cfg = model.GetDonwDropData("com_color_cfg", config_god_beast)
			if (color_cfg) {
				let defaultText
				let lastVo
				for (let key in color_cfg) {
					let vo = color_cfg[key]
					if (vo.id == comSelectId_) {
						defaultText = vo.content
					}
					lastVo = vo
				}
				if(!defaultText && lastVo){
					defaultText = lastVo.content
					comSelectId_ = lastVo.id
				}
				if(comSelectId_){
					this.downBtn = new DownDropBtn(this._down_btn)
					this.downBtn.Init(color_cfg, this.ColorClick, defaultText, "content", undefined, 4, false, false)
					this.downBtn.Load()
				}
			}

			this.bag_loop_list = []
			this.bag_loop_mgr = new LoopScrowViewMgr()
			this.bag_loop_mgr.SetData(this.bagGp, GodBeastComBagItem, this.bag_loop_list, LoopScrCon.Vertical)


			res_mgr.SetTexture(this, this.bg0, "resource/game/godBeast/texture/ui_rare_16.png")
			let auto = this.AutoSelect()
			if (!auto) {
				this.UpdateBag()
				this.CheckTips()
			}
			this._img_red.visible = model.beastComRed

			this.InitHalo()
		}

		this.InitHalo = () => {
			//光环
			this.UpdateHalo()
			Util.AddClickEvent(this._lb_halo_tips, () => {
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "HaloMainView")
			}, this, false)

			Util.AddClickEvent(this._img_merge_count, () => {
				if(!HaloModel.GetInstance().CheckPrivilegeOpenState(HaloPrivilegeType.GodBeastComposite)){
                    return
                }
				let state = HaloModel.GetInstance().GetSettingData(HaloPrivilegeType.GodBeastComposite, 0)
				if (!state) {
					let str = "勾选后,开启一键合成.<br>是否确认勾选?"
					let content = Util.StrToHTML(str)
					Alert.Show(
						content,
						Alert_Type.Two, () => {
							HaloModel.GetInstance().Fire(HaloModel.REQUEST_SCMD, 51402, "hhc", HaloPrivilegeType.GodBeastComposite, 0, 1)
						}
					)
				} else {
					HaloModel.GetInstance().Fire(HaloModel.REQUEST_SCMD, 51402, "hhc", HaloPrivilegeType.GodBeastComposite, 0, 0)
				}
			}, this, true)

			this.BindEvent(HaloModel.GetInstance(), HaloModel.RecvFmt51302, (id, type) => {
				if (id == HaloPrivilegeType.GodBeastComposite) {
					this.UpdateMergeCheckBox()
				}
			}
			)
			this.UpdateMergeCheckBox()
		}

		this.UpdateHalo = () => {
			if (HaloModel.GetInstance().GetOpenState()) {
				this._box_halo.visible = true
				if (HaloModel.GetInstance().GetHaloOpenState()) {
					this._img_merge_count.visible = true
					this._lb_halo_tips.visible = false
				}
				else {
					this._img_merge_count.visible = false
					this._lb_halo_tips.visible = true
				}
			}
			else {
				this._box_halo.visible = false
			}
		}

		this.UpdateMergeCheckBox = () => {
			let state = HaloModel.GetInstance().GetSettingData(HaloPrivilegeType.GodBeastComposite, 0)
			this._img_merge_count.skin = GameResPath.GetIcon("common", state && "com_ui_gx1" || "com_ui_gx")
			if(!state && model.auto_composite_state){
				this.try_close_auto_com = true
			}
		}

		this.ColorClick = (index, data) => {
			comSelectId_ = data.id
			this.Clear()
			this.AutoSelect()
			// if (!comId_) {
				
			// }
		}

		this.ComFunc = () =>{
			if (comId_) {
				model.Fire(local_GodBeastEvent.COM_EQUIP, comId_, selectList_)
			}
		}

		this.TryShowAwardView = () =>{
			if(this.auto_composite_list && this.auto_composite_list.length > 0){
				let list = []
				for(let vo of this.auto_composite_list){
					if(goods_model.beastbag_goods_dic[vo[3]]){
						list.push(vo)
					}
				}
				this.auto_composite_list.length = 0
				if(list.length > 0){
					let view = new CongratulationObtainView(list, 10)
					view.Open()
				}
			}
		}

		this.InitEvent = () => {
			local_Util.AddClickEvent(this.comBtn, () => {

				if (clickTime_ && clickTime_ > local_TimeUtil.getServerTime()) {
					return
				}
				clickTime_ = local_TimeUtil.getServerTime() + 0.2

				if (comId_) {
					if(model.auto_composite_state){
						this.try_close_auto_com = true
						return
					}
					this.ComFunc()
					let state = HaloModel.GetInstance().GetSettingData(HaloPrivilegeType.GodBeastComposite, 0)
					if(state){
						if(!model.auto_composite_state){
							model.auto_composite_state = true
							this.labelDisplay1.text = "取消"
						}
					}
				} else {
					local_Message.show(`请先放入4件相同等级的蜃妖装备`)
				}
			}, this, true)

			local_Util.AddClickEvent(this.closeBtn, () => {
				this.Close()
			}, this, true)

			this.BindEvent(model, local_GodBeastEvent.SELECT_COM_EQUIP, this.SelectItem)

			this.BindEvent(goods_model, GoodsModel.CHANGE_BEAST_BAG_LIST, () => {
				this.UpdateBag()
			})

			this.BindEvent(model, local_GodBeastEvent.COM_SUCCESS, (list) => {
				this.Clear()
				let auto = this.AutoSelect()

				if(model.auto_composite_state){
					if(!this.auto_composite_list){
						this.auto_composite_list = []
					}
					this.auto_composite_list = this.auto_composite_list.concat(list)
					
					if(auto && !this.try_close_auto_com){
						this.ComFunc()
					}
					else{
						this.try_close_auto_com = false
						model.auto_composite_state = false
						this.labelDisplay1.text = "铸造"
						Message.show("自动合成结束")
						this.TryShowAwardView()
					}
				}
				
				// PlayBigEffect("ui_zhuzhaochenggong")
			})

			local_Util.AddClickEvent(this.goBtn, () => {
				OpenFun.OpenFunHandler(86)
				this.Close()
			}, this, true)

			local_Util.AddClickEvent(this.com1Btn, () => {
				let open = CommonManager.GetInstance().CheckFuncOpenState("GodBeastCompositeView", false)
				if (!open) return
				GlobalEventSystem.Fire(EventName.SWITCH_MAIN_FUNC_VIEW, MainFunc.Composite, CompositeModel.Index.GodBeast)
				this.Close()
			}, this, true)

			this.BindVar(model, "beastComRed", () => {
				this._img_red.visible = model.beastComRed
			})
		}

		this.CheckTips = () => {
			let count = 0
			if (this.itemList) {
				for (let vo of this.itemList) {
					if (vo && vo.goods_id) {
						count++
					}
				}
			}
			this.tipsLb.style.fontSize = 20
			this.tipsLb.style.color = "#663915"
			// this.tipsLb.style.leading = 10
			this.tipsLb.width = 370
			this.tipsLb.height = 32
			if (count == 4) {
				this.tipsLb.innerHTML = local_Util.StrToHTML(`<font color='#0a953e'>获得部位随机</font>`)
			} else {
				this.tipsLb.innerHTML = local_Util.StrToHTML(`添加<font color='#0a953e'>4件</font>相同等级蜃装进行铸造`)
			}
			SetHtmlCenter(this.tipsLb, { "x": 0, "w": 720 })
			// this.tipsLb.style.padding = [(this.tipsLb.height - this.tipsLb.contextHeight) / 2, 0, 0, 0]
		}

		/**自动选择最低等级的可合成物品*/
		this.AutoSelect = () => {
			let config_god_beast = res_mgr.GetGameConfigFromCache(this, "ConfigGodBeast", true)
			let color_cfg = model.GetDonwDropData("com_color_cfg", config_god_beast)
			let cur_vo
			for (let key in color_cfg) {
				let vo = color_cfg[key]
				if (vo.id == comSelectId_) {
					cur_vo = vo
				}
			}
			if(!cur_vo) return

			let eudemons_compose_cfg = res_mgr.GetGameConfigFromCache(this, "config_eudemons_compose", false)
			let list = model.GetBeastAutoCom(eudemons_compose_cfg, cur_vo.cond, cur_vo.star)
			if (list) {
				let i = 0
				let size = local_Util.TableSize(list[0])
				for (let key in list[0]) {
					i++
					if (i == size) {
						this.SelectItem(key, 1)
					} else {
						this.SelectItem(key, 1, true)
					}
				}
				return true
			}
		}
		//type 0 取出 1  放入 
		this.SelectItem = (goods_id, type, auto?) => {
			if (type == 0) {
				let nogoods = true
				for (let itemVo of this.itemList) {
					if (itemVo.goods_id == goods_id) {
						itemVo.goods_id = null
						itemVo.item.SetVisible(false)
						delete selectList_[goods_id]
					}
					if (itemVo.goods_id) {
						nogoods = false
					}
				}
				if (nogoods) {
					targetColor_ = undefined
					targetStar_ = undefined
					this.SetTarget(null)
				} this.CheckTips()
				this.UpdateBag()
			} else if (type == 1) {
				let goodsVo = goods_model.beastbag_goods_dic[goods_id]
				if (!goodsVo) {
					return
				}
				if (targetColor_ != undefined && targetColor_ != goodsVo.color) {
					local_Message.show(`相同等级品质的蜃装才可以进行铸造`)
					return
				}
				let eudemons_equip_attr_cfg = res_mgr.GetGameConfigFromCache(this, "config_eudemons_equip_attr", false)
				let godBasic = model.GetEquipData(goodsVo.type_id, eudemons_equip_attr_cfg)
				if (!godBasic) {
					return
				}
				if (targetStar_ != undefined && targetStar_ != godBasic.star) {
					local_Message.show(`相同等级品质的蜃装才可以进行铸造`)
					return
				}
				for (let i = 0; i < 4; i++) {
					let itemVo = this.itemList[i]
					if (!itemVo) {
						itemVo = { index: i }
						this.itemList[i] = itemVo
					}
					if (!itemVo.goods_id) {
						let item: EquipmentItem = itemVo.item
						if (!item) {
							item = new EquipmentItem(this[`itemGp${itemVo.index}`])
							item.Load()
							// item.SetScale(0.75)
							item.SetItemSize(85, 85)
							itemVo.item = item
						}
						item.SetData(goodsVo.type_id)
						item.SetClickCallBack(() => {
							if (goodsVo.type == 39) {
								UIToolTipMgr.GetInstance().AppendGodBeastTips(goodsVo.type_id, undefined, undefined, goodsVo, undefined, [5])
							}
						})
						item.SetStrengthen(goodsVo.stren)
						selectList_[goods_id] = true
						itemVo.goods_id = goods_id
						item.SetVisible(true)
						if (i == 0 && targetColor_ == undefined) {
							targetColor_ = goodsVo.color
							targetStar_ = godBasic.star
							this.SetTarget(goodsVo.type_id)
						}
						if (!auto) {
							this.UpdateBag()
							this.CheckTips()
						}
						break
					}
				}
			}
		}

		this.UpdateBag = () => {
			let baglist = goods_model.beastbag_goods_list
			let list = []
			for (let vo of baglist) {
				if (vo.type != 39 || selectList_[vo.goods_id] || model.GetWearEquipInfo(vo.goods_id)) {
					continue
				}
				let eudemons_equip_attr_cfg = res_mgr.GetGameConfigFromCache(this, "config_eudemons_equip_attr", false)
				let data = model.GetEquipData(vo.type_id, eudemons_equip_attr_cfg)
				let star = data ? data.star : 0
				// if (vo.color >= 5 && star >= 3) {
				//     continue
				// }
				list.push(vo)
			}
			list.sort((a, b) => { return b.rating - a.rating })
			this.bag_loop_mgr.replaceAll(list)
			this.goGp.visible = list.length == 0
		}

		this.CloseFunc = () => {
			if(comSelectId_){
				cookie_wrapper.SaveCookie(local_CookieWrapper.BEAST_COM_ID, String(comSelectId_))
			}
			for (let itemVo of this.itemList) {
				if (itemVo.item) {
					itemVo.item.DeleteMe()
				}
				itemVo = null
			}
			if (this.targetItem) {
				this.targetItem.DeleteMe()
				this.targetItem = null
			}
			cfg_ = null
			if (this.downBtn) {
				this.downBtn.DeleteMe()
				this.downBtn = null
			}
			this.itemList = []
			this.Clear()
			if (this.bag_loop_mgr) {
				this.bag_loop_mgr.DeleteMe()
				this.bag_loop_mgr = null
			}
			model.auto_composite_state = false
			this.try_close_auto_com = false
			this.auto_composite_list = null
			// this.TryShowAwardView()
		}	

		this.SetTarget = (id, comId?) => {
			if (!id) {
				if (this.targetItem) {
					this.targetItem.SetVisible(false)
				}
				return
			}
			if (cfg_) {
				for (let key in cfg_) {
					let cfgVo = cfg_[key]
					let goodsList = ErlangParser.GetInstance().Parse(cfgVo.material)
					if (goodsList.indexOf(String(id)) != -1) {
						if (!this.targetItem) {
							this.targetItem = new EquipmentItem(this.targetGp)
							this.targetItem.Load()
							this.targetItem.SetItemSize(85, 85)
							// this.targetItem.SetScale(0.8)
						}
						let targetList = JSON.parse(cfgVo.reward)
						let tarId = targetList[0][1]
						this.targetItem.SetData(tarId)
						this.targetItem.SetVisible(true)
						comId_ = key
						break
					}
				}
			}
		}

		this.Clear = () => {
			targetColor_ = undefined
			targetStar_ = undefined
			selectList_ = {}
			comId_ = null
			for (let vo of this.itemList) {
				vo.goods_id = null
				if (vo.item) {
					vo.item.SetVisible(false)
				}
			}
			if (this.targetItem) {
				this.targetItem.SetVisible(false)
			}
		}
	}


	bg1: Laya.Image
	bg0: Laya.Image
	bg2: Laya.Image
	_Image111: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Image4: Laya.Image
	_Image5: Laya.Image
	_Image6: Laya.Image
	_Image7: Laya.Image
	_Image8: Laya.Image
	_Image9: Laya.Image
	_Image10: Laya.Image
	_Image11: Laya.Image
	_img_title: Laya.Image
	_Image12: Laya.Image
	bg3: Laya.Image
	_Image15: Laya.Image
	closeBtn: Laya.Image
	_Label1: Laya.Label
	_Label2: Laya.Label
	tipsLb: Laya.HTMLDivElement
	_Label3: Laya.Label
	itemGp0: Laya.Box
	itemGp1: Laya.Box
	itemGp2: Laya.Box
	itemGp3: Laya.Box
	targetGp: Laya.Box
	_down_btn: Laya.Box
	_Scroller1: Laya.Panel
	bagGp: Laya.List
	comBtn: Laya.Box
	_Image1: Laya.Image
	labelDisplay1: Laya.Label
	_img_red: Laya.Image
	com1Btn: Laya.Box
	_Image1111: Laya.Image
	labelDisplay: Laya.Label
	goGp: Laya.Box
	goBtn: Laya.Box
	_Image11111: Laya.Image
	labelDisplay11: Laya.Label
	_Image16: Laya.Image
	_Label4: Laya.Label
	_Image31: Laya.Image
	_Label31: Laya.Label
	_box_halo: Laya.Box
	_img_merge_count: Laya.Image
	_lb_halo_tips: Laya.Label
	public GetComponents() {
		[
			this.bg1,
			this.bg0,
			this.bg2,
			this._Image111,
			this._Image2,
			this._Image3,
			this._Image4,
			this._Image5,
			this._Image6,
			this._Image7,
			this._Image8,
			this._Image9,
			this._Image10,
			this._Image11,
			this._img_title,
			this._Image12,
			this.bg3,
			this._Image15,
			this.closeBtn,
			this._Label1,
			this._Label2,
			this.tipsLb,
			this._Label3,
			this.itemGp0,
			this.itemGp1,
			this.itemGp2,
			this.itemGp3,
			this.targetGp,
			this._down_btn,
			this._Scroller1,
			this.bagGp,
			this.comBtn,
			this._Image1,
			this.labelDisplay1,
			this._img_red,
			this.com1Btn,
			this._Image1111,
			this.labelDisplay,
			this.goGp,
			this.goBtn,
			this._Image11111,
			this.labelDisplay11,
			this._Image16,
			this._Label4,
			this._Image31,
			this._Label31,
			this._box_halo,
			this._img_merge_count,
			this._lb_halo_tips,
		]
			= this.GetChildrenByNames([

				"bg1",
				"bg0",
				"bg2",
				"_Image111",
				"_Image2",
				"_Image3",
				"_Image4",
				"_Image5",
				"_Image6",
				"_Image7",
				"_Image8",
				"_Image9",
				"_Image10",
				"_Image11",
				"_img_title",
				"_Image12",
				"bg3",
				"_Image15",
				"closeBtn",
				"_Label1",
				"_Label2",
				"tipsLb",
				"_Label3",
				"itemGp0",
				"itemGp1",
				"itemGp2",
				"itemGp3",
				"targetGp",
				"_down_btn",
				"_Scroller1",
				"bagGp",
				"comBtn",
				"_Image1",
				"labelDisplay1",
				"_img_red",
				"com1Btn",
				"_Image1111",
				"labelDisplay",
				"goGp",
				"goBtn",
				"_Image11111",
				"labelDisplay11",
				"_Image16",
				"_Label4",
				"_Image31",
				"_Label31",
				"_box_halo",
				"_img_merge_count",
				"_lb_halo_tips",
			])
	}
}
window["GodBeastComView"] = GodBeastComView