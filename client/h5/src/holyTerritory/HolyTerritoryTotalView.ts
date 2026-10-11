
import { HolyTerritoryModel, HTEvent } from "../commonModel/HolyTerritoryModel"
import { BaseItem1 } from "../common/BaseItem1"
import { Util } from "../util/Util"
import { OpenFun } from "../common/OpenFun"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { RoleManager } from "../commonModel/RoleManager"
import { table } from "../common/table"
import { Message } from "../sysInfo/SysInfoController"
import { TimeUtil } from "../util/TimeUtil"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { EquipmentItem } from "../common/EquipmentItem"
import { SYTweenLite } from "../util/SYTweenLite"
import { SYTweenFunc } from "../util/SYTweenFunc"

export class HolyTerritoryTotalView extends BaseItem1 {
	ClearArrowAni
	InitEvent
	InitView
	LocalDeleteMe
	Refrsh
	SetTerData
	SetTips
	StartArrowAni
	ani_list

	public constructor(parent?) {
		super(parent)


		let model = HolyTerritoryModel.GetInstance()
		let local_HTEvent = HTEvent
		let local_HolyTerritoryModel = HolyTerritoryModel
		let local_Message = Message

		let local_TimeUtil = TimeUtil
		let rewardItemList_ = null
		let monsterCfg_ = null
		let clientCfg_ = null
		let refreshTimer_ = null
		let minTime_ = null
		let ArrowAniList_ = []
		this.base_file = "holyTerritory"
		this.layout_file = "HolyTerritoryTotalView"
		this.preload_server_config = {
			"config_sanctuary_mon": false
		}
		this.preload_client_config = {
			"ClientHolyTerritory": false,
			"ConfigInstruction": false
		}
		this.load_callback = () => {
			this._Scroller1.hScrollBar.visible = false
			this._Scroller2.vScrollBar.visible = false
			//this.terMonster1.lineSpacing = 1
			// if (PlatformMgr.GetInstance().IsEyouEnPlatform()) {
			// 	this.terMonster1.lineSpacing = 0.85
			// }
			// if (PlatformMgr.GetInstance().IsEyouPlatform()) {
			// 	this.terMonster1.lineSpacing = 1
			// 	this.terMonster2.lineSpacing = 1
			// 	this.terMonster3.lineSpacing = 1
			// }
			// if (PlatformMgr.GetInstance().IsEyouKrPlatform()) {
			// 	this._Label1.size = 18
			// 	this._Label2.size = 18
			// 	this._Label3.size = 18
			// 	SetAnchoredPositionX(this._Label1, 9)
			// 	SetAnchoredPositionX(this._Label2, 9)
			// 	SetAnchoredPositionX(this._Label3, 9)
			// }
			// let mask = this.GetChild("_Scroller1/rewardGroup").GetComponent("Image")
			// this.RegisterMask(mask)
			let i = 1
			do {
				model.Fire(local_HTEvent.REQUEST_PROTO, 28301, "c", i)
				i = i + 1
			} while ((i <= 3))
			this.InitView()
			this.SetRed()
			this.InitEvent()
			this.StartArrowAni()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this.desertGp, () => {
				if (model.IsRealOpen("异域活动")) {
					model.Fire(local_HTEvent.OPEN_VIEW, "HolyTerritoryMapView", 3)
				} else {
					// local_Message.show("开服第二天开启异域活动")
				}
				model.showArrow = false
			}
				, this, true)
			Util.AddClickEvent(this.winterGp, () => {
				if (model.IsRealOpen("异域活动")) {
					model.Fire(local_HTEvent.OPEN_VIEW, "HolyTerritoryMapView", 1)
				} else {
					// local_Message.show("开服第二天开启异域活动")
				}
				model.showArrow = false
			}
				, this, true)
			Util.AddClickEvent(this.vineGp, () => {
				if (model.IsRealOpen("异域活动")) {
					model.Fire(local_HTEvent.OPEN_VIEW, "HolyTerritoryMapView", 2)
				} else {
					// local_Message.show("开服第二天开启异域活动")
				}
				model.showArrow = false
			}
				, this, true)
			Util.AddClickEvent(this.territoryBtn, () => {
				local_HolyTerritoryModel.BackIndex = 1
				OpenFun.OpenFunHandler(4, 2, 1)
			}
				, this, true)
			this.BindEvent(model, local_HTEvent.UPDATE_MONSTER_DATA, () => {
				this.Refrsh()
			}
			)
			this.BindEvent(GlobalEventSystem, ServerTimeModel.DAY_CHANGE, () => {
				this.SetTips()
			}
			)
			this.BindEvent(model, local_HTEvent.UPDATE_RED, () => {
				this.SetRed()
			}
			)
		}

		this.InitView = () => {
			monsterCfg_ = ResManager.GetInstance().GetGameConfigFromCache(this, "config_sanctuary_mon", false)
			clientCfg_ = ResManager.GetInstance().GetGameConfigFromCache(this, "ClientHolyTerritory", true)

			if (clientCfg_) {
				let reward = clientCfg_.reward
				if (!rewardItemList_) {
					rewardItemList_ = []
				}
				let i = 0
				if (reward.length) {
					do {
						let item = new EquipmentItem(this.Content)
						rewardItemList_[i] = item
						item.SetUseMask(true)
						item.Load()
						item.SetScale(0.65)

						//item:ExcuteCallback(() => {
						item.SetData(reward[i][0], reward[i][1])
						//}
						//)
						i = i + 1
					} while ((i < reward.length))
				}
			}
			let str = ""
			let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigInstruction", true)
			let ht_cfg = cfg[28302]
			if (ht_cfg) {
				let content = ht_cfg[0].content.item_List[0].item_content
				let zise = content.length
				for (let _ in content) {
					var k = content[_]
					str = str + k
					if (_ != zise) {
						str = str + "<br/>"
					}
				}
			}
			this.desLabel.style.fontSize = 20
			this.desLabel.style.align = "left"
			this.desLabel.style.color = "#663915"
			this.desLabel.width = 624
			this.desLabel.style.lineHeight = 24
			this.desLabel.innerHTML = str
			this.Refrsh()
			this.SetTips()
			// ResManager.GetInstance().SetOutsideImageSprite(this, this.desertBG, GameResPath.GetIcon("holyTerritory", "uisyld_012"), true)
			// ResManager.GetInstance().SetOutsideImageSprite(this, this.winterBG, GameResPath.GetIcon("holyTerritory", "uisyld_014"), true)
			// ResManager.GetInstance().SetOutsideImageSprite(this, this.vineBG, GameResPath.GetIcon("holyTerritory", "uisyld_013"), true)
		}

		this.SetTerData = (data?, index?) => {
			if (this.is_loaded && monsterCfg_) {
				if (!data && index) {
					let bossInfo = []
					let cfg = model.monCfg
					if (cfg) {
						for (let key in cfg) {

							// [ts2lua]cfg下标访问可能不正确
							if (cfg[key].sanctuary_id == index) {
								// [ts2lua]cfg下标访问可能不正确
								table.insert(bossInfo, { boss_id: cfg[key].mon_id, reborn_time: 0 })
							}
						}
					}
					data = { sanctuary_id: index, point: 0, boss_info: bossInfo }
				}
				let survive = [0, 0, 0]
				if (!data) {
					return
				}
				// [ts2lua]this下标访问可能不正确
				// [ts2lua]lua中0和空字符串也是true，此处data.belong != RoleManager.GetInstance().GetMainRoleVo().guild_id && local_HolyTerritoryModel.IsOpen()需要确认
				this["Tips" + data.sanctuary_id].visible = (data.belong == 0 || data.belong != RoleManager.GetInstance().GetMainRoleVo().guild_id )&& model.IsRealOpen() ? true : false
				this["terGuild" + data.sanctuary_id].style.fontSize = 20
				this["terGuild" + data.sanctuary_id].style.align = "left"
				this["terGuild" + data.sanctuary_id].style.color = "#ffe064"
				this["terGuild" + data.sanctuary_id].width = 250
				this["terGuild" + data.sanctuary_id].parent.refresh()
				if (data.belong && data.belong > 0) {
					// [ts2lua]this下标访问可能不正确
					this["terGuild" + data.sanctuary_id].innerHTML = data.belong_name + "占领"
				} else {
					// [ts2lua]this下标访问可能不正确
					this["terGuild" + data.sanctuary_id].innerHTML = "<font color = '#ff4f50'>暂无结社占领</font>"
				}
				for (let _tmpi in data.boss_info) {
					var vo = data.boss_info[_tmpi]
					// [ts2lua]monsterCfg_下标访问可能不正确
					if ((vo.reborn_time == 0 || vo.reborn_time < local_TimeUtil.getServerTime()) && monsterCfg_[data.sanctuary_id + "@" + vo.boss_id]) {
						// [ts2lua]monsterCfg_下标访问可能不正确
						// [ts2lua]survive下标访问可能不正确
						// [ts2lua]monsterCfg_下标访问可能不正确
						// [ts2lua]survive下标访问可能不正确
						survive[monsterCfg_[data.sanctuary_id + "@" + vo.boss_id].mon_type - 1] = survive[monsterCfg_[data.sanctuary_id + "@" + vo.boss_id].mon_type - 1] + 1
					} else {
						if (!minTime_ || minTime_ > vo.reborn_time) {
							minTime_ = vo.reborn_time
						}
					}
				}
				// [ts2lua]lua中0和空字符串也是true，此处survive[3] > 0需要确认
				let str = "领主存活:<font color='" + (survive[2] > 0 && ("#00fa64") || ("#ff4f50")) + "'>" + survive[2] + "</font><br/>"
				// [ts2lua]lua中0和空字符串也是true，此处survive[2] > 0需要确认
				str = str + "妖将存活:<font color='" + (survive[1] > 0 && ("#00fa64") || ("#ff4f50")) + "'>" + survive[1] + "</font><br/>"
				// [ts2lua]lua中0和空字符串也是true，此处survive[1] > 0需要确认
				str = str + "守卫存活:<font color='" + (survive[0] > 0 && ("#00fa64") || ("#ff4f50")) + "'>" + survive[0] + "</font><br/>"
				// [ts2lua]this下标访问可能不正确
				this["terMonster" + data.sanctuary_id].style.fontSize = 18
				this["terMonster" + data.sanctuary_id].style.align = "left"
				this["terMonster" + data.sanctuary_id].style.color = "#ffffff"
				this["terMonster" + data.sanctuary_id].width = 250
				this["terMonster" + data.sanctuary_id].style.leading = 1
				this["terMonster" + data.sanctuary_id].innerHTML = Util.StrToHTML(str)
				this["terMonster" + data.sanctuary_id].parent.refresh()
			}
		}

		this.Refrsh = () => {
			if (refreshTimer_) {
				clearTimeout(refreshTimer_)
				refreshTimer_ = null
				minTime_ = null
			}
			if (monsterCfg_) {
				let i = 1
				do {
					let data = model.GetTerData(i)
					this.SetTerData(data, i)
					i = i + 1
				} while ((i <= 3))
				if (minTime_ && minTime_ > local_TimeUtil.getServerTime()) {
					refreshTimer_ = setTimeout(() => {
						this.Refrsh()
					}, minTime_ - local_TimeUtil.getServerTime() + 1)
				}
			}
		}

		this.StartArrowAni = () => {
			let i = 1
			let pos_list = [-51.05, -55, -28.7]
			this.ani_list = []
			do {
				// [ts2lua]this下标访问可能不正确
				let tips = this["Tips" + i]
				if (tips) {
					let startPos = tips.y
					let id = SYTweenLite.to(this, tips, SYTweenLite.UiAnimationType.ANCHORED_POSY, startPos + 10, 1, null, SYTweenFunc.PINGPONG, true)
					this.ani_list[i - 1] = id
				}
				i = i + 1
			} while ((i <= 3))
		}

		this.ClearArrowAni = () => {
			if (this.ani_list) {
				for (let _ in this.ani_list) {
					var id = this.ani_list[_]
					SYTweenLite.Stop(id)
					id = null
				}
				this.ani_list = null
			}
		}

		this.SetTips = () => {
			let day = model.maxDay - ServerTimeModel.GetInstance().GetOpenServerDay() + 1
			this.tipsLb.style.fontSize = 20
			this.tipsLb.style.valign = "center"
			this.tipsLb.style.color = "#ffffff"
			this.tipsLb.width = 500
			this.tipsLb.innerHTML = Util.StrToHTML("tips:开服第5天开启<font color='#b3ff48'>[跨服异域]</font>")
		}

		this.LocalDeleteMe = () => {
			if (rewardItemList_) {
				for (let _tmpi in rewardItemList_) {
					var item = rewardItemList_[_tmpi]
					if (item) {
						item.DeleteMe()
						item = null
					}
				}
				rewardItemList_ = null
			}
			if (refreshTimer_) {
				clearTimeout(refreshTimer_)
				refreshTimer_ = null
			}
			model.showArrow = false
			this.ClearArrowAni()
		}
	}


	public DeleteMe() {

		this.LocalDeleteMe()
		super.DeleteMe()
	}
	public SetRed() {
		let ht_red_list = HolyTerritoryModel.GetInstance().ht_red_dir
		for (let id in ht_red_list) {
			this[`red${id}`].visible = ht_red_list[id] ? true : false
		}
	}


	desertGp: Laya.Box
	desertBG: Laya.Image
	_Image11: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Image4: Laya.Image
	_Image5: Laya.Image
	_Group1: Laya.Box
	terGuild3: Laya.HTMLDivElement
	terMonster3: Laya.HTMLDivElement
	Tips3: Laya.Box
	_Image6: Laya.Image
	_Label1: Laya.Label
	winterGp: Laya.Box
	winterBG: Laya.Image
	_Image7: Laya.Image
	_Image8: Laya.Image
	_Group2: Laya.Box
	terGuild1: Laya.HTMLDivElement
	terMonster1: Laya.HTMLDivElement
	Tips1: Laya.Box
	_Image9: Laya.Image
	_Label2: Laya.Label
	vineGp: Laya.Box
	vineBG: Laya.Image
	_Image10: Laya.Image
	_Image111: Laya.Image
	_Group3: Laya.Box
	terGuild2: Laya.HTMLDivElement
	terMonster2: Laya.HTMLDivElement
	Tips2: Laya.Box
	_Image12: Laya.Image
	_Label3: Laya.Label
	territoryBtn: Laya.Box
	_Image1: Laya.Image
	labelDisplay: Laya.Label
	_Label4: Laya.Label
	_Scroller2: Laya.Panel
	desLabel: Laya.HTMLDivElement
	_Scroller1: Laya.Panel
	Content: Laya.HBox
	_Image13: Laya.Image
	arrowGp: Laya.Box
	_Image14: Laya.Image
	tipsLb: Laya.HTMLDivElement
	red2: Laya.Image
	red1: Laya.Image
	red3: Laya.Image
	public GetComponents() {
		[
			this.desertGp,
			this.desertBG,
			this._Image11,
			this._Image2,
			this._Image3,
			this._Image4,
			this._Image5,
			this._Group1,
			this.terGuild3,
			this.terMonster3,
			this.Tips3,
			this._Image6,
			this._Label1,
			this.winterGp,
			this.winterBG,
			this._Image7,
			this._Image8,
			this._Group2,
			this.terGuild1,
			this.terMonster1,
			this.Tips1,
			this._Image9,
			this._Label2,
			this.vineGp,
			this.vineBG,
			this._Image10,
			this._Image111,
			this._Group3,
			this.terGuild2,
			this.terMonster2,
			this.Tips2,
			this._Image12,
			this._Label3,
			this.territoryBtn,
			this._Image1,
			this.labelDisplay,
			this._Label4,
			this._Scroller2,
			this.desLabel,
			this._Scroller1,
			this.Content,
			this._Image13,
			this.arrowGp,
			this._Image14,
			this.tipsLb,
			this.red2,
			this.red1,
			this.red3
		]
			= this.GetChildrenByNames([

				"desertGp",
				"desertBG",
				"_Image11",
				"_Image2",
				"_Image3",
				"_Image4",
				"_Image5",
				"_Group1",
				"terGuild3",
				"terMonster3",
				"Tips3",
				"_Image6",
				"_Label1",
				"winterGp",
				"winterBG",
				"_Image7",
				"_Image8",
				"_Group2",
				"terGuild1",
				"terMonster1",
				"Tips1",
				"_Image9",
				"_Label2",
				"vineGp",
				"vineBG",
				"_Image10",
				"_Image111",
				"_Group3",
				"terGuild2",
				"terMonster2",
				"Tips2",
				"_Image12",
				"_Label3",
				"territoryBtn",
				"_Image1",
				"labelDisplay",
				"_Label4",
				"_Scroller2",
				"desLabel",
				"_Scroller1",
				"Content",
				"_Image13",
				"arrowGp",
				"_Image14",
				"tipsLb",
				"red2",
				"red1",
				"red3"
			])
	}
}
window["HolyTerritoryTotalView"] = HolyTerritoryTotalView