
import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { FightingShowSmallItem } from "../common/FightingShowSmallItem"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { achvModel } from "../commonModel/achvModel"
import { FuncFirstOpenKey, FuncFirstOpenManager } from "../commonModel/FuncFirstOpenManager"
import { StoryModel } from "../commonModel/StoryModel"
import { TaskTipType } from "../commonModel/TaskModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { Util, SetSizeDeltaX, SetAnchoredPositionX, PlayBigEffect } from "../util/Util"
import { AchvChildItem } from "./AchvChildItem"
import { AchvPropItem } from "./AchvPropItem"
import { achvSubItem } from "./achvSubItem"
import { AchvTabBar } from "./AchvTabBar"
import { AchvTotalItem } from "./AchvTotalItem"
import { Message } from "../sysInfo/SysInfoController"
import { PlatformManager } from "../PlatformManager"

export class achvView extends BaseItem1 {
	Content
	Content1
	Content11
	Content111
	CustomMehod
	DrawRound
	Empactive_btn
	FindNextRed
	GetTabInfo
	InfoList
	InitEvent
	InitTabBar
	LoadSuccess
	PlayAni
	PlayExpAni
	SelectSub
	SelectTab
	SetPropImte
	SetSpecific
	SetStarLabel
	SetTotal
	SetTotalInfo
	SetView
	SortFunc
	UpDateDisRed
	UpdateTotalRed
	_Scroller3
	acCfg
	achv_group
	achv_item_list
	achv_scroller
	active_btn
	aniList
	ani_group_list
	Content1111
	categoryCfg
	childList
	curStageStar
	defaultSub
	defaultTab
	disArr
	dispersionGp
	expMask
	exp_effect_group
	exp_image: Laya.Image
	exp_label
	extend_active_btn
	finishList
	firstOpen
	listGp
	lv_label
	noReqTime
	oldStage
	playingAni
	preload_server_config
	propItemList
	red_dot
	roundImg
	selectType
	showCurStar
	starCfg
	subTypeCfg
	tabBar
	tabScroller
	totalArr
	totalGp
	totalId
	totalLb: Laya.Label
	totalList
	totalMask
	totalTypeCfg
	ui_bg
	ui_bg1
	UpDateDisRed2
	UpdateTotalRed2
	exp_image_width
	_Image1
	_Image11: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_Image4: Laya.Image
	_Image5: Laya.Image
	_Image6: Laya.Image
	_Scroller1: Laya.Panel
	achv_effect: Laya.Box
	labelDisplay: Laya.Label
	_Scroller2: Laya.Panel

	Font_name: string = "fight_small"
	bitmapFont: Laya.BitmapFont
	roundBox

	_ty
	beginY

	public constructor(parent?) {
		super(parent)

		this.ani_group_list = [];
		this.SelectTab = 0;
		this.SelectSub = 0;
		this.showCurStar = 0;
		this.playingAni = false;
		this.propItemList = [];
		this.aniList = [];
		this.firstOpen = true;
		this.oldStage = 0;
		this.curStageStar = 0;
		this.totalList = [];
		this.totalId = 1;
		this.finishList = [];
		this.exp_image_width == 216;

		let model = achvModel.GetInstance()
		let local_achvModel = achvModel
		let local_TimeUtil = TimeUtil
		let local_laya = Laya
		let local_Math = Math
		let local_AchvPropItem = AchvPropItem
		let local_AchvTabBar = AchvTabBar
		let local_AchvChildItem = AchvChildItem
		this.base_file = "achv"
		this.layout_file = "AchvMainView"
		this.load_callback = () => {
			this.Content111.on(Laya.Event.MOUSE_DOWN, this, this.OnMouseDown);
			//this.extend_active_btn = this.GetChild("totalGp/active_btn/_Image1").GetComponent("ImageExtend")
			model.Fire(local_achvModel.OP_AC_V)
			this.LoadSuccess()
			GlobalEventSystem.Fire(EventName.SELECT_STORY_TARGET, StoryModel.StoryTargetName.RoleIcon, false)
		}

		this.preload_server_config = { "config_achievement": false, "config_achievement_star_reward": false, "config_achievement_category": false, "config_achievement_type_new": false, "config_achievement_stage_reward": false }
		this.LoadSuccess = () => {
			this.acCfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_achievement", false)
			this.categoryCfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_achievement_category", false)
			this.starCfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_achievement_star_reward", false)
			this.totalTypeCfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_achievement_type_new", false)
			this.subTypeCfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_achievement_stage_reward", false)

			// this.totalArr = eui. new ArrayCollection()
			// this.achv_group.itemRenderer = AchvTotalItem
			// this.achv_group.dataProvider = this.totalArr
			this.totalArr = new LoopScrowViewMgr()
			this.totalArr.SetData(this.Content1, AchvTotalItem, [], LoopScrCon.Vertical)

			// this.disArr = eui. new ArrayCollection()
			// this.listGp.itemRenderer = achvSubItem
			// this.listGp.dataProvider = this.disArr

			this.disArr = new LoopScrowViewMgr()
			// this.disArr.SetData(this.Content, achvSubItem, {}, this._Scroller3, null, null, null, 2)
			// this.disArr.SetData(this.Content, achvSubItem, {}, this._Scroller3, null, null, null, 1)
			this.disArr.SetData(this.Content, achvSubItem, [], LoopScrCon.Vertical)

			if (this.acCfg && this.starCfg) {
				this.oldStage = model.curAcStage
				this.InitTabBar()
				this.InitEvent()
				this.SetStarLabel()
			}
			ResManager.GetInstance().SetOutsideImageSprite(this, this.ui_bg, "resource/game/achv/texture/uicj_002.png", true)

			this.UpdateFuncFirstState()
		}

		this.InitEvent = () => {
			this.BindEvent(model, local_achvModel.U_AC_V, () => {
				this.SetPropImte(model.curAcStage)
				this.FindNextRed()
			}
			)
			this.BindEvent(model, local_achvModel.U_AC_LIST, () => {
				this.SetSpecific()
			}
			)
			this.BindEvent(model, local_achvModel.U_STAR_COUNT, (star?) => {
				this.SetStarLabel()
			}
			)
			this.BindEvent(model, local_achvModel.U_ITEM_POS, () => {
			}
			)
			this.BindEvent(model, local_achvModel.PLAY_ANI, (star_pos?) => {
				//好像没用了
				// this.PlayAni(star_pos)
			}
			)
			Util.AddClickEvent(this.active_btn, () => {
				if (!this.noReqTime || this.noReqTime <= local_TimeUtil.getServerTimeMs()) {
					if(this._Image1.gray){
						Message.show("成就点不足")
					}
					else{
						model.Fire(local_achvModel.REQUEST_PROTO, 40902, "i", model.curAcStage + 1)
						this.noReqTime = local_TimeUtil.getServerTimeMs() + 220
						this.FuncFirstOpenClick()
					}
				}

			}
				, this, true)
			this.BindEvent(model, local_achvModel.U_AC_LV, () => {

				// this.achv_effect.visible = true;
				// this.AddUIEffect("ui_shengjitexiao", this.achv_effect, { x: 0, y: 0 }, 7, false, 1, () => {
				// 	this.achv_effect.visible = false;
				// }, null, null, null, true)

				Laya.timer.frameOnce(3, this, () => {
					PlayBigEffect("ui_shengjitexiao")
				}, null, true)


				// this.AddUIEffect2("ui_emblemupgrade_glow", this.achv_effect)
				// if (this.exp_image.mask ) {
				// 	this.exp_image.mask.width = 0
				// 	this.playingAni = false
				// 	Laya.Tween.removeTweens(this.exp_image.mask)
				// }
				SetSizeDeltaX(this.exp_image, 0)
				this.playingAni = false
			}
			)
			this.BindEvent(model, local_achvModel.UPDATE_SPECIFIC, (data?) => {
				if (data.category == this.totalId) {
					this.SetTotal(data.list)
				}
			}
			)
			this.BindEvent(model, local_achvModel.UPDATE_TOTAL_POINT, () => {
				//当前选择的不是成就总览页面 许多组件会失效
				if (this.SelectTab == 0) {
					this.SetTotalInfo()
				}
			}
			)
			this.BindEvent(model, local_achvModel.U_AC_REDDOT, () => {
				this.UpDateDisRed2()
				this.UpdateTotalRed2()
			}
			)
			this.BindEvent(model, local_achvModel.U_AC_D, (achvVo?) => {
				if (achvVo) {
					let cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_achievement.name, achvVo.id, false, this.acCfg)
					if (cfg) {
						// [ts2lua]this.subTypeCfg下标访问可能不正确
						let subtypeCfg = this.subTypeCfg[cfg.category]
						if (subtypeCfg && subtypeCfg.subtype == this.selectType) {
							model.Fire(local_achvModel.REQUEST_PROTO, 40909, "h", cfg.category)
						}
					}
				}
			}
			)
		}

		this.SetStarLabel = () => {
			if (!this.is_loaded || !this.starCfg) {
				return
			}
			// if (! this.expMask ) {
			// 	this.expMask = local_laya. new Rectangle(0, -2, 0, this.exp_image.height + 4)
			// 	this.exp_image.mask = this.expMask
			// 	this.exp_effect_group.x = this.exp_image.x + this.exp_image.mask.width
			// 	this.AddUIEffect2("ui_progressbar_glow1", this.exp_effect_group, {x=-2, y=11}, null, true)
			// }
			SetAnchoredPositionX(this.exp_effect_group, this.exp_effect_group.x + this.exp_image.width)

			let cfg = this.starCfg[model.curAcStage + 1]
			this.showCurStar = model.curStarCount || 0
			this.lv_label.text = "Lv." + model.curAcStage
			if (cfg) {
				let star = cfg.star
				let end_pos = this.showCurStar / star
				let can_receive = this.showCurStar >= star && star != 0
				//Util.SetImageGray(this.extend_active_btn, ! can_receive)
				// Util.SetImageGray(this._Image1, ! can_receive)
				this._Image1.gray = !can_receive
				this.red_dot.visible = can_receive
				this.active_btn.touchEnabled = this.red_dot.visible
				//this.Empactive_btn.touchEnabled = this.red_dot.visible
				this.curStageStar = star
				let exp_ani = { pos: end_pos }
				table.insert(this.aniList, exp_ani)
				this.exp_label.text = this.showCurStar + "/" + star
				this.oldStage = model.curAcStage
				if (!this.playingAni) {
					this.PlayExpAni()
				}
			} else {
				this.active_btn.touchEnabled = false
				//this.Empactive_btn.touchEnabled = false
				//Util.SetImageGray(this.extend_active_btn, true)
				// Util.SetImageGray(this._Image1, true)
				this._Image1.gray = true
				// Laya.Tween.removeTweens(this.exp_image.mask)
				// this.exp_image.mask.width = this.exp_image.width
				// SetSizeDeltaX(this.exp_image, this.exp_image.sizeDelta.x)
				SetSizeDeltaX(this.exp_image, 216)
				this.exp_effect_group.visible = false
				this.exp_label.text = "已满级"
				this.active_btn.visible = false
				this.red_dot.visible = false
			}
			this.SetPropImte(model.curAcStage)
		}

		//这个方法好像没用了
		this.PlayAni = (star_pos?) => {
			// if (! star_pos ) {
			// 	return
			// }
			// let group = null
			// if (this.ani_group_list.length == 0 ) {
			// 	group = eui. new Group()
			// 	this.addChild(group)
			// }else{
			// 	group = this.ani_group_list.pop()
			// 	this.ClearUIEffect(group)
			// }
			// let fixed_group = eui. new Group()
			// if (this.ani_group_list.length == 0 ) {
			// 	fixed_group = eui. new Group()
			// 	this.addChild(fixed_group)
			// }else{
			// 	fixed_group = this.ani_group_list.pop()
			// 	this.ClearUIEffect(fixed_group)
			// }
			// let local_star = this.globalToLocal(star_pos.x, star_pos.y)
			// group.x = local_star.x
			// group.y = local_star.y
			// fixed_group.x = local_star.x
			// fixed_group.y = local_star.y
			// let delayFunc = () => {
			// 	this.AddUIEffect2("ui_achievementglow3", group, null, null, false, null,() => {
			// 			this.ClearUIEffect(group)
			// 			table.insert(this.ani_group_list, group)
			// 		}
			// 	)
			// }

			// this.AddUIEffect2("ui_achievementglow1", fixed_group, null, null, false, null,() => {
			// 		this.ClearUIEffect(fixed_group)
			// 		table.insert(this.ani_group_list, fixed_group)
			// 	}
			// 	, null, null, true)
			// this.AddUIEffect2("ui_achievementglow2", group, null, null, false)
			// Laya.Tween.get(group):to({x=this.exp_image.x + this.exp_image.width / 2, y=this.exp_image.y + this.exp_image.height / 2}, 625, Laya.Ease.circInOut).call(delayFunc)
		}

		this.PlayExpAni = () => {
			// let end_pos = null
			// if (this.aniList.length > 0 ) {
			// 	this.playingAni = true
			// 	while ((this.aniList.length > 0)
			// 		) {
			// 			let vo = this.aniList.shift()
			// 			if (vo ) {
			// 				end_pos = vo.pos
			// 			}
			// 		}
			// 		if (end_pos > 1 ) {
			// 			end_pos = 1
			// 		}
			// 		let OnchangeFunc = () => {
			// 			if (this.exp_effect_group ) {
			// 				if (this.exp_image.mask.width == this.exp_image.width || this.exp_image.mask.width == 0 ) {
			// 					this.exp_effect_group.visible = false
			// 				}else{
			// 					this.exp_effect_group.visible = true
			// 				}
			// 				this.exp_effect_group.x = this.exp_image.x + this.exp_image.mask.width
			// 			}
			// 		}

			// 		Laya.Tween.get(this.exp_image.mask, {onChange=OnchangeFunc}):to({width=end_pos * this.exp_image.width}, 400).call(() => {
			// 				if (this.exp_image && this.exp_image.mask ) {
			// 					Laya.Tween.removeTweens(this.exp_image.mask)
			// 					this.PlayExpAni()
			// 				}
			// 			}
			// 		)
			// 	}else{
			// 		this.playingAni = false
			// 		return
			// 	}
			// }
			if (this.aniList.length > 0) {
				//let pos = this.aniList[this.aniList].pos.length
				let pos = this.aniList[this.aniList.length - 1].pos
				pos = Math.min(pos, 1)
				SetSizeDeltaX(this.exp_image, 216 * pos)
			}
		}

		this.SetPropImte = (level?) => {
			if (!this.starCfg) {
				return
			}
			// [ts2lua]this.starCfg下标访问可能不正确
			let cfg = this.starCfg[level]
			// [ts2lua]this.starCfg下标访问可能不正确
			let next_cfg = this.starCfg[level + 1]
			// [ts2lua]lua中0和空字符串也是true，此处cfg需要确认
			let cur_attr_list = (cfg && (JSON.parse(cfg.reward)) || (null))
			// [ts2lua]lua中0和空字符串也是true，此处next_cfg需要确认
			let next_attr_list = (next_cfg && (JSON.parse(next_cfg.reward)) || (null))
			let main_att_list = null
			if (cur_attr_list && cur_attr_list.length > 0) {
				main_att_list = cur_attr_list
			} else {
				main_att_list = next_attr_list
			}
			// let i = 0
			// do {
			// 	let prop_item = this.propItemList[i]
			// 	if (! prop_item ) {
			// 		prop_item =  new local_AchvPropItem(this.Content11)
			// 		prop_item.Load()
			// 		this.propItemList[i] = prop_item
			// 	}
			// 	prop_item.visible = true
			// 	prop_item.ExcuteCallback(() => {
			// 			// [ts2lua]lua中0和空字符串也是true，此处cur_attr_list需要确认
			// 			// [ts2lua]lua中0和空字符串也是true，此处next_attr_list需要确认
			// 			prop_item.SetData((cur_attr_list && ( cur_attr_list[i] ) || ( null ) ), (next_attr_list && ( next_attr_list[i] ) || ( null ) ))
			// 		}
			// 	)
			// 	i=i+1
			// } while ((i < main_att_list.length))

			for (let i in main_att_list) {
				let prop_item = this.propItemList[i]
				if (!prop_item) {
					prop_item = new local_AchvPropItem(this.Content11)
					prop_item.Load()
					this.propItemList[i] = prop_item
				}
				prop_item.visible = true
				prop_item.ExcuteCallback(() => {
					// [ts2lua]lua中0和空字符串也是true，此处cur_attr_list需要确认
					// [ts2lua]lua中0和空字符串也是true，此处next_attr_list需要确认
					prop_item.SetData((cur_attr_list && (cur_attr_list[i]) || (null)), (next_attr_list && (next_attr_list[i]) || (null)))
				}
				)
			}

			for (let i = main_att_list.length + 1; i <= this.propItemList.length; i++) {
				let item = this.propItemList[i]
				if (item) {
					item.SetVisible(false)
				}
			}
		}

		this.DrawRound = (angle?) => {
			// if (angle > 1 ) {
			// 	angle = 1
			// }
			if (!this.totalMask) {
				this.totalMask = new Laya.Sprite()
				this.totalMask.texture = "resource/game/achv/texture/uicj_011.png"
				this.roundBox.addChild(this.totalMask)
				this.roundBox.mask = this.totalMask
			}
			let startPos = -90 + angle * 360
			this.roundBox.graphics.clear()
			let pie = this.roundBox.graphics.drawPie(this.roundImg.width / 2, this.roundImg.height / 2, 90, startPos, 270, "#ac394a");
			this.totalMask.visible = false
			// this.totalMask.graphics.clear()
			// this.totalMask.graphics.beginFill("#00ffff", 2)
			// this.totalMask.graphics.lineTo(94, 0)
			// //this.totalMask.graphics.drawArc(0, 0, 84, -local_Math.PI / 2, local_Math.PI * 2 * angle - 1 / 2, false)
			// let startpos=-local_Math.PI / 2+local_Math.PI*angle/1*2
			// let endpos=local_Math.PI*1.5
			// this.totalMask.graphics.drawArc(0, 0, 94, startpos, endpos, true)
			// this.totalMask.graphics.lineTo(0, 0)
			// this.totalMask.graphics.endFill()

			//this.roundImg.fillAmount = angle
		}

		this.GetTabInfo = () => {
			let nameInfo = []
			let cfgInfo = []
			let list = []
			let dataList = []
			if (this.totalTypeCfg && this.categoryCfg) {
				let cateCfg = this.categoryCfg
				for (let key in cateCfg) {

					// [ts2lua]cateCfg下标访问可能不正确
					let info = cateCfg[key]
					// [ts2lua]dataList下标访问可能不正确
					if (!dataList[info.subtype]) {
						// [ts2lua]dataList下标访问可能不正确
						dataList[info.subtype] = []
					}
					// [ts2lua]dataList下标访问可能不正确
					table.insert(dataList[info.subtype], info)
				}
				let TabIndex = -1
				let achvData = model.GetAchvDataList()
				let needFind = this.defaultSub == null && this.defaultTab == null
				let Cfg = this.totalTypeCfg
				for (let key2 in Cfg) {

					TabIndex = TabIndex + 1
					// [ts2lua]Cfg下标访问可能不正确
					let cfg = Cfg[key2]
					let total = []
					total[0] = cfg.desc
					total[1] = []
					let subList = []
					let subType = JSON.parse(cfg.subtypes)
					if (cfg.id != 1) {
						let SubIndex = -1
						for (let _tmpi in subType) {
							var vo = subType[_tmpi]
							vo = Number(vo)
							SubIndex = SubIndex + 1
							// [ts2lua]dataList下标访问可能不正确
							if ((needFind && achvData) && dataList[vo]) {
								// [ts2lua]dataList下标访问可能不正确
								for (let _tmpi in dataList[vo]) {
									var specVo = dataList[vo][_tmpi]
									// [ts2lua]achvData下标访问可能不正确
									// [ts2lua]achvData下标访问可能不正确
									if (achvData[specVo.category] && achvData[specVo.category].status == 1) {
										needFind = false
										this.SelectTab = TabIndex
										this.SelectSub = SubIndex
									}
								}
							}
							if (key2 == this.defaultTab && vo == this.defaultSub) {
								this.SelectTab = TabIndex
								this.SelectSub = SubIndex
							}
							// [ts2lua]this.subTypeCfg下标访问可能不正确
							let subCfg = this.subTypeCfg[vo]
							if (subCfg) {
								table.insert(total[1], subCfg.desc)
							}
							// [ts2lua]dataList下标访问可能不正确
							table.insert(subList, dataList[vo] || {})
						}
					}
					table.insert(nameInfo, total)
					table.insert(cfgInfo, { type: cfg.id, sub: subType, info: subList })
				}
			}
			this.InfoList = cfgInfo
			return nameInfo
		}

		this.SetView = (tabIndex?, subIndex?) => {
			// [ts2lua]this.InfoList下标访问可能不正确
			let tabInfo = this.InfoList[tabIndex]
			// console.log("11111111this.InfoList")
			// PrintTable(tabInfo)
			if (tabInfo) {
				this.finishList = []
				this.SelectTab = tabIndex
				this.SelectSub = subIndex
				if (tabInfo.type == 1) {
					this.totalGp.visible = true
					this.dispersionGp.visible = false
					// [ts2lua]model.specificList下标访问可能不正确
					let info = model.specificList[this.totalId]
					this.selectType = this.totalId
					this.SetTotalInfo()
					// [ts2lua]model.changeList下标访问可能不正确
					if (info && !model.changeList[this.selectType]) {
						this.SetTotal(info.list)
					} else {
						model.Fire(local_achvModel.REQUEST_PROTO, 40909, "h", this.totalId)
					}
				} else {
					this.totalGp.visible = false
					this.dispersionGp.visible = true
					// [ts2lua]tabInfo.sub下标访问可能不正确
					//this.selectType = tabInfo.sub[subIndex + 1]
					this.selectType = tabInfo.sub[subIndex]
					// [ts2lua]tabInfo.info下标访问可能不正确
					//let list = tabInfo.info[subIndex + 1]
					let list = tabInfo.info[subIndex]
					let allFinish = true
					if (list) {
						for (let _tmpi in list) {
							var vo = list[_tmpi]
							if (vo) {
								let id = vo.category
								// [ts2lua]this.finishList下标访问可能不正确
								this.finishList[id] = true
							}
						}
					}
					this.SetSpecific()
				}
			}
		}

		this.FindNextRed = () => {
			// //领取总成就和升级不跳转
			// if (0 == this.SelectTab ) {
			// 	return
			// }
			let AchvInfo = this.InfoList
			let DataList = model.GetAchvDataList()
			if (AchvInfo) {
				let Func = (i?) => {
					let info = AchvInfo[i].info
					if (info) {
						let j = 0
						if (i == this.SelectTab) {
							j = this.SelectSub
						}
						let isHaveGet: boolean = false;
						do {
							for (let _tmpi in info[j] || {}) {
								var achvVo = info[j] || {}[_tmpi]
								// [ts2lua]DataList下标访问可能不正确
								// [ts2lua]DataList下标访问可能不正确
								for (let voIndex in achvVo) {
									if (DataList && DataList[achvVo[voIndex].category] && DataList[achvVo[voIndex].category].status == 1) {
										if ((this.SelectTab != i || this.SelectSub != j) && this.tabBar) {
											this.tabBar.SetSelectTab(i, j, true)
										}
										isHaveGet = true;
										return true
									}
								}
							}
							j = j + 1
						} while ((j < info.length));
						if(!isHaveGet){
							this.SelectTab = this.SelectSub = 0;
							this.tabBar.SetSelectTab(this.SelectTab, this.SelectTab)
							this.SetView(this.SelectTab, this.SelectSub)
							// this.tabBar.SetSelectTab(this.SelectTab, this.SelectSub);
						}
					}
				}

				//如果当前是成就总览并且有红点，保持在当前页，不跳转
				let red = model.redList[-1] || model.redList[this.totalId]
				if (0 == this.SelectTab && red) {
					return
				}

				for (let i = this.SelectTab; i < AchvInfo.length; i++) {
					if (Func(i)) {
						return
					}
				}

				for (let i = 1; i <= this.SelectTab; i++) {
					if (Func(i)) {
						return
					}
				}
			}
		}

		this.SetTotalInfo = () => {
			if (!this.childList) {
				this.childList = []
				let cfg = this.totalTypeCfg
				let vBox = new Laya.VBox()
				let childnum = 0
				// let childInfo = null
				for (let key in cfg) {
					if (key != "1") {
						// [ts2lua]cfg下标访问可能不正确
						let childInfo = cfg[key]
						if(PlatformManager.IsEyouEnPlatform()){
							vBox.space = 5
						}
						let item = new local_AchvChildItem(vBox)
						item.Load()
						// [ts2lua]this.childList下标访问可能不正确
						this.childList[childInfo.id] = item
						item.ExcuteCallback(() => {
							item.SetInfo(childInfo)
						}
						)
						childnum++;
					}
					if (childnum == 3) {
						this.Content111.addChild(vBox)
						vBox = new Laya.VBox()
						if(PlatformManager.IsEyouEnPlatform()){
							vBox.space = 5
						}
						childnum = 0
					}
				}
			}
			let info = null
			let curValue = 0
			let totalValue = 0
			let list = model.totalPointList
			if (list) {
				for (let _tmpi in list) {
					var vo = list[_tmpi]
					// [ts2lua]this.childList下标访问可能不正确
					let item = this.childList[vo.type]
					if (item) {
						item.SetSchedule(vo)
					}
					curValue = curValue + vo.now_star
					totalValue = totalValue + vo.total_star
				}
			}
			let totalText = String(curValue) + "/17360"
			this.totalLb.text = totalText
			this.DrawRound(curValue / totalValue)
		}


		this.SetTotal = (info?) => {
			if (info) {
				// this.totalArr.replaceAll(this.SortFunc(info))
				// this.totalArr.SetData(this.Content1, AchvTotalItem, this.SortFunc(info), this.achv_scroller)
				this.totalArr.replaceAll(this.SortFunc(info))
			}
		}

		this.SetSpecific = () => {
			let list = []
			let acList = model.GetAchvDataList()
			for (let key in this.finishList) {

				// [ts2lua]acList下标访问可能不正确
				if (acList && acList[key]) {
					// [ts2lua]acList下标访问可能不正确
					// list.unshift(acList[key])
					table.unshift(list, acList[key])
				}
			}
			//先按category来排序
			table.sort(list, (a?, b?) => {
				return a.category > b.category
			})

			if (list) {
				if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.AchvAward) && !this.task_model.IsCurrMainTaskHasFinish()) {
					for (let _tmpi in list) {
						var vo = list[_tmpi]
						if (vo.status == 1) {
							model.guide_id = vo.id
							break
						}
					}
				}
				// this.disArr.source = this.SortFunc(list)
				// this.disArr.refresh()
				let data = this.SortFunc(list)
				this.disArr.replaceAll(data)
			}
		}

		this.SortFunc = (info?) => {
			let finishList = []
			let unfinishList = []
			let receviedList = []
			// let i = info.length - 1
			// do {
			// 	if (info ) {
			// 		if (info[i].status == 0 ) {
			// 			table.insert(unfinishList, info[i])
			// 		} else if (info[i].status == 1 ) {
			// 			table.insert(finishList, info[i])
			// 		}else{
			// 			table.insert(receviedList, info[i])
			// 		}
			// 	}
			// 	i=i-1
			// } while ((i >= 0))


			for (let i = info.length - 1; i >= 0; i -= 1) {
				if (info) {
					if (info[i].status == 0) {
						table.insert(unfinishList, info[i])
					} else if (info[i].status == 1) {
						table.insert(finishList, info[i])
					} else {
						table.insert(receviedList, info[i])
					}
				}
			}
			//return table.merge(finishList, table.merge(unfinishList, receviedList))
			return finishList.concat(unfinishList.concat(receviedList))

		}

		this.InitTabBar = () => {
			if (!this.tabBar) {
				this.tabBar = new local_AchvTabBar(this.Content1111)
				this.tabBar.Load()
				let list = this.GetTabInfo()
				let clickFunc = (tab?, sub?) => {
					this.SetView(tab, sub)
				}

				let tabFunc = (index?) => {
					if (index == 0) {
						this.SetView(0, 0)
					}
				}
				this.tabBar.SetTabBar(list, clickFunc, this.tabScroller.width, tabFunc)
				this.UpDateDisRed()
				this.UpdateTotalRed()
				this.tabBar.ExcuteCallback(() => {
					this.SetView(this.SelectTab, this.SelectSub)
					//每次achvmainview打开都会调用一次
					// this.UpDateDisRed2()
					// this.UpdateTotalRed2()
				}
				)
			}
			if (this.tabBar) {
				this.tabBar.SetSelectTab(this.SelectTab, this.SelectSub)
			}
		}

		this.UpDateDisRed2 = () => {
			let redList = model.redList
			if (this.tabBar && model.redList) {
				for (let i = 1; i < this.tabBar.tab_list.length; i++) {
					let showRed
					for (let j = 0; j < this.tabBar.tab_list[i][1].length; j++) {
						let info = this.InfoList[i].info[j]
						if (this.tabBar.tab_item_list[i] && this.tabBar.tab_item_list[i].sub_tab_item_list) {//第一次打开每个tabbtn的tabsubbtn都还没有加载完 因此这个方法可以用来第二次加载的时候使用
							let item = this.tabBar.tab_item_list[i].sub_tab_item_list[j]
							if (info && info.length > 0) {
								let tabRed = null
								for (let _tmpi in info) {
									var vo = info[_tmpi]
									// [ts2lua]redList下标访问可能不正确
									if (redList[vo.category]) {
										showRed = true
										tabRed = true
									}
								}
								if (item) {
									item.SetRedDot(tabRed)
								}
							} else if (item) {
								item.SetRedDot(false)
							}
						}
					}
					if (this.tabBar.tab_item_list[i] && this.tabBar.tab_item_list[i].sub_tab_item_list) {
						this.tabBar.tab_item_list[i].SetRedDot(showRed)
					}
				}
			}
		}

		this.UpdateTotalRed2 = () => {
			// [ts2lua]model.redList下标访问可能不正确
			// [ts2lua]model.redList下标访问可能不正确
			let red = model.redList[-1] || model.redList[this.totalId]
			if (this.tabBar) {
				if (this.tabBar.tab_item_list[0]) {
					this.tabBar.tab_item_list[0].SetRedDot(red)
				}
			}
		}

		this.CustomMehod = (index?, parms?) => {
			if (parms) {
				if (this.is_loaded) {
					// [ts2lua]this.InfoList下标访问可能不正确
					let info = this.InfoList[parms[0] - 1]
					if (info) {
						let i = 0
						do {
							if (parms[1] == info.sub[i]) {
								let sub = i
								if (this.tabBar && (this.SelectTab != parms[0] - 1 || this.SelectSub != i)) {
									this.tabBar.SetSelectTab(this.SelectTab, this.SelectSub)
								}
								this.SetView(parms[0] - 1, i)
							}
							i = i + 1
						} while ((i < info.sub.length))
					}
				} else {
					this.defaultTab = parms[0]
					this.defaultSub = parms[1]
				}
			}
		}
		this.UpDateDisRed = () => {
			let redList = model.redList
			if (this.tabBar && model.redList) {
				for (let i = 1; i < this.tabBar.tab_list.length; i++) {
					let showRed = false
					for (let j = 0; j < this.tabBar.tab_list[i][1].length; j++) {
						let info = this.InfoList[i].info[j]
						if (info && info.length > 0) {
							let tabRed = false
							for (let _tmpi in info) {
								var vo = info[_tmpi]
								// [ts2lua]redList下标访问可能不正确
								if (redList[vo.category]) {
									showRed = true
									tabRed = true
								}
							}
							this.tabBar.tab_sub_red_list[i][j] = tabRed;
						} else {
							this.tabBar.tab_sub_red_list[i][j] = false
						}
					}
					// this.tabBar.tab_item_list[i].SetRedDot(showRed)
					this.tabBar.tab_item_red_list[i] = showRed
				}
			}
		}

		this.UpdateTotalRed = () => {
			// [ts2lua]model.redList下标访问可能不正确
			// [ts2lua]model.redList下标访问可能不正确
			let red = model.redList[-1] || model.redList[this.totalId]
			if (this.tabBar) {
				this.tabBar.tab_item_red_list[0] = red
			}
		}

	}


	public DeleteMe() {
		if (this.tabBar) {
			this.tabBar.DeleteMe()
		}
		for (let _tmpi in this.propItemList) {
			var prop_item = this.propItemList[_tmpi]
			if (prop_item) {
				prop_item.DeleteMe()
				prop_item = null
			}
		}
		this.propItemList = []
		// for (let index in this.achv_item_list) {

		// 	// [ts2lua]this.achv_item_list下标访问可能不正确
		// 	let item = this.achv_item_list[index]
		// 	item.DeleteMe()
		// 	// [ts2lua]this.achv_item_list下标访问可能不正确
		// 	this.achv_item_list[index] = null
		// }
		// this.achv_item_list = null
		for (let _tmpi in this.ani_group_list) {
			var vo = this.ani_group_list[_tmpi]
			// this.ClearUIEffect(vo)
			// Laya.Tween.removeTweens(vo)
		}
		if (this.childList) {
			for (let index in this.childList) {

				this.childList[index].DeleteMe()
				this.childList[index] = null
			}
		}
		// if (this.exp_image && this.exp_image.mask ) {
		// 	Laya.Tween.removeTweens(this.exp_image.mask)
		// }
		// if (this.tabBar ) {
		// 	this.tabBar.DeleteMe()
		// 	this.tabBar = null
		// }
		this.acCfg = null
		this.starCfg = null
		// this.bitmapFont=null
		// this.totalLb=null
		// this.ClearUIEffect(this.exp_effect_group)

		if (this.totalArr) {
			this.totalArr.DeleteMe()
			this.totalArr = null
		}
		if (this.disArr) {
			this.disArr.DeleteMe()
			this.disArr = null
		}
		this.ClearFuncFirst()
		super.DeleteMe()
	}

	public OnMouseDown() {
		this.beginY = this.Content111.y
		this._ty = Laya.stage.mouseY;
		Laya.stage.on(Laya.Event.MOUSE_MOVE, this, this.mouseMove);
		Laya.stage.once(Laya.Event.MOUSE_UP, this, this.mouseUp);
		Laya.stage.once(Laya.Event.MOUSE_OUT, this, this.mouseUp);
		// this.value_text.text=this.value.toString()
	}

	private mouseMove(e: Event): void {
		let stage = Laya.stage;
		this.Content111.y += stage.mouseY - this._ty
		if (this.Content111.y > 50) {
			this.Content111.y = 50
		} else if (this.Content.y <= -50) {
			this.Content111.y = -50;
		}
		this._ty = stage.mouseY;
	}


	private mouseUp(e: Event): void {
		Laya.Tween.to(this.Content111, { y: this.beginY }, 1000, Laya.Ease.circOut, Laya.Handler.create(this, () => {
		}))
		let stage = Laya.stage;
		stage.off(Laya.Event.MOUSE_MOVE, this, this.mouseMove);
		stage.off(Laya.Event.MOUSE_UP, this, this.mouseUp);
		stage.off(Laya.Event.MOUSE_OUT, this, this.mouseUp);
	}

	public FuncFirstOpenClick(){
		if(this.has_set_func_first_state){
			let func_first_mgr = FuncFirstOpenManager.GetInstance()
			func_first_mgr.AddStep(FuncFirstOpenKey.Achv)
			this.ClearFuncFirst()
		}
	}


	has_set_func_first_state
	public UpdateFuncFirstState(){
		let func_first_mgr = FuncFirstOpenManager.GetInstance()
		if(this.CheckFuncFirstValue() && !func_first_mgr.CheckFuncFirstOpenState(FuncFirstOpenKey.Achv)){
			func_first_mgr.AddStepSprite(FuncFirstOpenKey.Achv, 1, this.active_btn)
			func_first_mgr.UpdateStepState(FuncFirstOpenKey.Achv)
			this.has_set_func_first_state = true
		}
		else{
			this.ClearFuncFirst()
		}
	}

	//当前数据源是否是需要引导的那条数据
	public CheckFuncFirstValue(){
		return !this._Image1.gray
	}

	public ClearFuncFirst(){
		if(this.has_set_func_first_state){
			this.has_set_func_first_state = false
			let func_first_mgr = FuncFirstOpenManager.GetInstance()
			func_first_mgr.ClearStepSprite(FuncFirstOpenKey.Achv, 1)
			GlobalEventSystem.Fire(EventName.HIDE_FINGER, this.active_btn)
		}
	}

	public GetComponents() {
		[
			this._Image11,
			this.totalGp,
			this.ui_bg,
			this.ui_bg1,
			this._Image2,
			this.exp_image,
			this.roundImg,
			this._Image3,
			this._Image4,
			this._Image5,
			this._Image6,
			this.totalLb,
			this._Scroller1,
			this.Content11,
			this.achv_scroller,
			this.Content1,
			this.achv_effect,
			this.exp_effect_group,
			this.active_btn,
			this._Image1,
			this.labelDisplay,
			this.red_dot,
			this._Scroller2,
			this.Content111,
			this.lv_label,
			this.exp_label,
			this.tabScroller,
			this.Content1111,
			this.dispersionGp,
			this._Scroller3,
			this.Content,
			this.roundBox
		]
			= this.GetChildrenByNames([

				"_Image11",
				"totalGp",
				"ui_bg",
				"ui_bg1",
				"_Image2",
				"exp_image",
				"roundImg",
				"_Image3",
				"_Image4",
				"_Image5",
				"_Image6",
				"totalLb",
				"_Scroller1",
				"Content11",
				"achv_scroller",
				"Content1",
				"achv_effect",
				"exp_effect_group",
				"active_btn",
				"_Image1",
				"labelDisplay",
				"red_dot",
				"_Scroller2",
				"Content111",
				"lv_label",
				"exp_label",
				"tabScroller",
				"Content1111",
				"dispersionGp",
				"_Scroller3",
				"Content",
				"roundBox"
			])

		ResManager.GetInstance().LoadFont(this, "fight_small", this.totalLb, 14)
	}


}

window["achvView"] = achvView