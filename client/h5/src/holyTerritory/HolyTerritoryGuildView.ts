import { BaseItem1 } from "../common/BaseItem1"
import { HolyTerritoryModel, HTEvent } from "../commonModel/HolyTerritoryModel"
import { Util, SetLocalScale, SetSizeDeltaY, SetAnchoredPositionY, SetHtmlCenter, SetHtmlStyle } from "../util/Util"
import { OpenFun } from "../common/OpenFun"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { table } from "../common/table"
import { GlobalTimerQuest } from "../util/Util"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { HTGuildRankRenderer } from "./HTGuildRankRenderer"
import { HTTopItem } from "./HTTopItem"
import { HTRoleRankRenderer } from "./HTRoleRankRenderer"

export class HolyTerritoryGuildView extends BaseItem1 {
	CancelTimer
	CustomMehod
	InitEvent
	InitView
	LocalDeleteMe
	Request
	SelectRank
	SetGuildRank
	SetRoleRank
	gRankScroller
	loop_mgr
	loop_mgr1
	loop_mgr2
	rRankScroller
	topRankScroller

	public constructor(parent?) {
		super(parent)

		let model = HolyTerritoryModel.GetInstance()
		let local_HTEvent = HTEvent
		let topArr_ = null
		let gArr_ = null
		let rArr_ = null
		let topItemList_ = null
		let dsgtId_ = [306001, 306002, 306003]
		let dsgtScale_ = [1.5, 1.3, 1.2]
		//let BG9Grid_ = Laya. new Rectangle(0, 100, 0, 268)
		let defaultSelect_ = null
		let requestTimer_ = null
		this.base_file = "holyTerritory"
		this.layout_file = "HolyTerritoryGuildView"
		this.preload_server_config = {
			"config_dsgt": false,
			"config_sanctuary_designation": false
		}
		this.load_callback = () => {
			SetHtmlStyle(this.gRankLabel, { c: "#663915", f: 20, w: 250, lh: 25 })
			SetHtmlStyle(this.rRankLabel, { c: "#663915", f: 20, w: 250, lh: 25 })
			model.Fire(local_HTEvent.REQUEST_PROTO, 28302)
			model.Fire(local_HTEvent.REQUEST_PROTO, 28310)
			this.InitView()
			this.InitEvent()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this.dsgtBtn, () => {
				OpenFun.OpenFunHandler(79)
			}
				, this, true)
			Util.AddClickEvent(this.rRankBtn, () => {
				this.SelectRank(1)
			}
				, this, true)
			Util.AddClickEvent(this.gRankBtn, () => {
				this.SelectRank(2)
			}
				, this, true)
			this.BindEvent(model, local_HTEvent.UPDATE_GUILD_RANk, () => {
				this.SetGuildRank()
			}
			)
			this.BindEvent(model, local_HTEvent.UPDATE_ROLE_RANK, () => {
				this.SetRoleRank()
			}
			)
		}

		this.InitView = () => {
			let i = 0
			let _cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_dsgt", false)
			do {

				let dsgt = _cfg[dsgtId_[i]]
				if (dsgt) {
					if (dsgt.type == 1) {
						this["dsgt" + i].width = 720
						this["dsgt" + i].height = 1280
						this["dsgt" + i].mouseThrough = true
						this["dsgt" + i].mouseEnabled = false

						this.ClearUIEffect(this["dsgt" + i])
						this.AddUIEffect(dsgt.resource_id, this["dsgt" + i])
						// [ts2lua]this下标访问可能不正确
						// [ts2lua]this下标访问可能不正确
						// [ts2lua]this下标访问可能不正确
						//this.AddUIEffect2(dsgt.resource_id, this["transdsgt" + i], null, {x=1.5, y=1.5}, true)//{x=this["dsgt" + i].width / 2, y=this["dsgt" + i].height / 2}
					} else {
						//let img = eui. new Image()
						//// [ts2lua]this下标访问可能不正确
						//this["dsgt" + i].addChild(img)
						//let url = "resource/game/dsgt/dsgtIcon/" + dsgt.resource_id + ".png"
						//lua_resM:SetOutsideImageSprite(this, img, url)
						//img.horizontalCenter = 0
						//img.scaleY = dsgtScale_[i]
						//img.scaleX = img.scaleY

						let img = new Laya.Image()//UiFactory.CreateChild(this["transdsgt" + i],UIType.Image).transform
						// img.pivot = Vector2(0.5, 0.5)
						// img.anchorMin = Vector2(0.5, 0.5)
						// img.anchorMax = Vector2(0.5, 0.5)
						// img.anchoredPosition = Vector2(0, 0)
						this["dsgt" + i].addChild(img)
						img.centerX = img.centerY = 0
						let url = GameResPath.GetDesignImage(dsgt.resource_id)
						ResManager.GetInstance().SetOutsideImageSprite(this, img, url, true)
						SetLocalScale(img, dsgtScale_[i])
					}
				}
				i = i + 1
			} while ((i < 3))


			//this.topRankGroup.itemRenderer = HTGuildRankRenderer
			//topArr_ = eui. new ArrayCollection()
			//this.topRankGroup.dataProvider = topArr_


			//this.gRankGroup.itemRenderer = HTGuildRankRenderer
			//gArr_ = eui. new ArrayCollection()
			//this.gRankGroup.dataProvider = gArr_


			//this.rRankGroup.itemRenderer = HTRoleRankRenderer
			//rArr_ = eui. new ArrayCollection()
			//this.rRankGroup.dataProvider = rArr_


			this.SetGuildRank()
			this.SetRoleRank()
			this.SelectRank(defaultSelect_ || 1)
			//ResManager.GetInstance().SetOutsideImageSprite(this, this.guild_title_bg, GameResPath.GetIcon("holyTerritory", "ui_Guild_27"))
			//lua_resM:SetOutsideImageSprite(this, this._Image11111, GameResPath.GetIcon("holyTerritory","uisy_024"),true)
			//ResManager.GetInstance().SetOutsideImageSprite(this, this._Image11111, GameResPath.GetIcon("holyTerritory", "uisy_024"), true)
			this.CancelTimer()
			if (!requestTimer_) {
				requestTimer_ = GlobalTimerQuest.AddPeriodQuest(this.Request, 60, -1)
			}
		}

		this.CustomMehod = (index?, arg?) => {
			if (arg) {
				if (this.is_loaded) {
					this.SelectRank(arg)
				} else {
					defaultSelect_ = arg[0]
				}
			}
		}

		this.SelectRank = (type?) => {
			this.guildGroup.visible = (type == 1)
			this.roleGroup.visible = (type != 1)
			if (type == 1) {
				this._Label10.text = "今日23:00结算"
			} else {
				this._Label10.text = "每小时整点结算"
			}
		}

		this.SetGuildRank = () => {
			ResManager
			let rankData = model.gRankData
			if (rankData && rankData.rank_list) {
				let data = rankData.rank_list
				let sortFunc = (a?, b?) => {
					return a.rank < b.rank
				}
				table.sort(data, sortFunc)
				let topData = []
				let otherData = []
				let i1 = 0
				let top_power = ""
				if (i1 < data.length && i1 < 3) {
					do {
						if (data[i1].rank == rankData.my_guild_rank) {
							data[i1].this = true
						}
						table.insert(topData, data[i1])
						top_power = data[i1].avg_power
						i1 = i1 + 1
					} while ((i1 < data.length && i1 < 3))
				}
				let i = 3
				if (i < data.length) {
					do {
						if (data[i].rank == rankData.my_guild_rank) {
							data[i].this = true
						}
						table.insert(otherData, data[i])
						i = i + 1
					} while ((i < data.length))
				}

				if (!this.loop_mgr) {
					this.loop_mgr = new LoopScrowViewMgr()
					this.loop_mgr.SetData(this.Content11, HTGuildRankRenderer, otherData, LoopScrCon.Vertical, 1)
				} else {
					this.loop_mgr.replaceAll(otherData)
				}
				//topArr_:replaceAll(topData)

				for (let _ in topData) {
					var v = topData[_]
					v.top_power = top_power
				}
				if (!this.loop_mgr2) {
					this.loop_mgr2 = new LoopScrowViewMgr()
					this.loop_mgr2.SetData(this.Content1, HTGuildRankRenderer, topData, LoopScrCon.Vertical, 1)
				} else {
					this.loop_mgr2.replaceAll(topData)
				}

				this.rRankLabel.innerHTML = Util.StrToHTML("结社排行:<font color='#0a953e'>" + (rankData.my_guild_rank < 3 && ("前三") || ("第" + rankData.my_guild_rank)) + "</font><br>结社战力:<font color='#0a953e'>" + rankData.my_guild_power_ten + "</font>")
				this.rRankLabel.style.width = 250
			}
		}

		this.SetRoleRank = () => {
			let rankData = model.rRankData
			if (rankData && rankData.rank_list) {
				let data = rankData.rank_list
				let sortFunc = (a?, b?) => {
					return a.rank < b.rank
				}
				table.sort(data, sortFunc)
				if (!topItemList_) {
					topItemList_ = []
				}
				let BottomData = []
				let i = 0
				if (i < data.length) {
					let _cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_dsgt", false)
					do {
						if (data[i].rank == rankData.my_rank) {
							this.sRank.text = data[i].rank
							this.sName.text = data[i].role_name
							this.sFight.text = data[i].power
							let dsgt = _cfg[data[i].desination]
							// [ts2lua]lua中0和空字符串也是true，此处dsgt && data[i].desination需要确认
							this.sDsgt.text = (dsgt && data[i].desination && (dsgt.name) || ("未获得称号"))
						}
						if (i < 4) {
							let topItem = topItemList_[i]
							if (!topItem) {
								if (i == 0) {
									topItem = new HTTopItem(this.topGroup)
								} else {
									topItem = new HTTopItem(this.topGroup1)
								}
								topItemList_[i] = topItem
								topItem.Load()
							}
							//topItem:ExcuteCallback(() => {
							topItem.SetIndex(i)
							topItem.SetData(data[i])
							//}
							//)
						} else {
							table.insert(BottomData, data[i])
						}
						i = i + 1
					} while ((i < data.length))
				}
				if (!this.loop_mgr1) {
					this.loop_mgr1 = new LoopScrowViewMgr()
					this.loop_mgr1.SetData(this.Content, HTRoleRankRenderer, BottomData, LoopScrCon.Vertical, 1)
				} else {
					this.loop_mgr1.replaceAll(BottomData)
				}
				this.gRankLabel.innerHTML = Util.StrToHTML("个人排行:<font color='#0a953e'>" + rankData.my_rank + "</font><br>个人战力:<font color='#0a953e'>" + rankData.my_power + "</font>")
				this.gRankLabel.style.width = 250
			}
		}

		this.Request = () => {
			model.Fire(local_HTEvent.REQUEST_PROTO, 28302)
			model.Fire(local_HTEvent.REQUEST_PROTO, 28310)
		}

		this.CancelTimer = () => {
			if (requestTimer_) {
				GlobalTimerQuest.CancelQuest(requestTimer_)
				requestTimer_ = null
			}
		}

		this.LocalDeleteMe = () => {
			if (topItemList_) {
				for (let i in topItemList_) {

					if (topItemList_[i]) {
						topItemList_[i].DeleteMe()
						topItemList_[i] = null
					}
				}
				topItemList_ = null
			}
			if (this.loop_mgr) {
				this.loop_mgr.DeleteMe()
				this.loop_mgr = null
			}
			if (this.loop_mgr1) {
				this.loop_mgr1.DeleteMe()
				this.loop_mgr1 = null
			}
			if (this.loop_mgr2) {
				this.loop_mgr2.DeleteMe()
				this.loop_mgr2 = null
			}
			this.CancelTimer()
			let i = 0
			do {
				// [ts2lua]this下标访问可能不正确
				if (this["dsgt" + i]) {
					// [ts2lua]this下标访问可能不正确
					this.ClearUIEffect(this["dsgt" + i])
				}
				i = i + 1
			} while ((i < 3))
		}
	}

	public DeleteMe() {

		this.LocalDeleteMe()
		super.DeleteMe()
	}

	guildBG: Laya.Image
	guild_bg_2: Laya.Image
	guild_title_bg: Laya.Image
	guildGroup: Laya.Box
	_img_01: Laya.Image
	_Image11111: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Image4: Laya.Image
	dsgt0: Laya.Box
	dsgt1: Laya.Box
	dsgt2: Laya.Box
	_Image5: Laya.Image
	_Image6: Laya.Image
	_Image7: Laya.Image
	_Group1: Laya.Box
	_Label1: Laya.Label
	_Label2: Laya.Label
	_Label3: Laya.Label
	_Label4: Laya.Label
	_Label5: Laya.Label
	Content1: Laya.List
	Content11: Laya.List
	rRankLabel: Laya.HTMLDivElement
	gRankBtn: Laya.Box
	_Image111: Laya.Image
	labelDisplay1: Laya.Label
	_Image8: Laya.Image
	_Image9: Laya.Image
	roleGroup: Laya.Box
	topGroup: Laya.Box
	topGroup1: Laya.HBox
	_Group2: Laya.Box
	_Label6: Laya.Label
	_Label7: Laya.Label
	_Label8: Laya.Label
	_Label9: Laya.Label
	Content: Laya.List
	_Group3: Laya.Box
	_Image10: Laya.Image
	sRank: Laya.Label
	sName: Laya.Label
	sFight: Laya.Label
	sDsgt: Laya.Label
	gRankLabel: Laya.HTMLDivElement
	rRankBtn: Laya.Box
	_Image1: Laya.Image
	labelDisplay: Laya.Label
	_Image1111: Laya.Image
	_Label10: Laya.Label
	dsgtBtn: Laya.Box
	_Image11: Laya.Image
	labelDisplay11: Laya.Label
	public GetComponents() {
		[
			this.guildBG,
			this.guild_bg_2,
			this.guild_title_bg,
			this.guildGroup,
			this._img_01,
			this._Image11111,
			this._Image2,
			this._Image3,
			this._Image4,
			this.dsgt0,
			this.dsgt1,
			this.dsgt2,
			this._Image5,
			this._Image6,
			this._Image7,
			this._Group1,
			this._Label1,
			this._Label2,
			this._Label3,
			this._Label4,
			this._Label5,
			this.Content1,
			this.Content11,
			this.rRankLabel,
			this.gRankBtn,
			this._Image111,
			this.labelDisplay1,
			this._Image8,
			this._Image9,
			this.roleGroup,
			this.topGroup,
			this.topGroup1,
			this._Group2,
			this._Label6,
			this._Label7,
			this._Label8,
			this._Label9,
			this.Content,
			this._Group3,
			this._Image10,
			this.sRank,
			this.sName,
			this.sFight,
			this.sDsgt,
			this.gRankLabel,
			this.rRankBtn,
			this._Image1,
			this.labelDisplay,
			this._Image1111,
			this._Label10,
			this.dsgtBtn,
			this._Image11,
			this.labelDisplay11,
		]
			= this.GetChildrenByNames([

				"guildBG",
				"guild_bg_2",
				"guild_title_bg",
				"guildGroup",
				"_img_01",
				"_Image11111",
				"_Image2",
				"_Image3",
				"_Image4",
				"dsgt0",
				"dsgt1",
				"dsgt2",
				"_Image5",
				"_Image6",
				"_Image7",
				"_Group1",
				"_Label1",
				"_Label2",
				"_Label3",
				"_Label4",
				"_Label5",
				"Content1",
				"Content11",
				"rRankLabel",
				"gRankBtn",
				"_Image111",
				"labelDisplay1",
				"_Image8",
				"_Image9",
				"roleGroup",
				"topGroup",
				"topGroup1",
				"_Group2",
				"_Label6",
				"_Label7",
				"_Label8",
				"_Label9",
				"Content",
				"_Group3",
				"_Image10",
				"sRank",
				"sName",
				"sFight",
				"sDsgt",
				"gRankLabel",
				"rRankBtn",
				"_Image1",
				"labelDisplay",
				"_Image1111",
				"_Label10",
				"dsgtBtn",
				"_Image11",
				"labelDisplay11",
			])
	}
}
window["HolyTerritoryGuildView"] = HolyTerritoryGuildView