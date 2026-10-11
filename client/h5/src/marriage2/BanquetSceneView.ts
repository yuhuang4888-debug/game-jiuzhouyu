import { BaseView1 } from "../common/BaseView1"
import { EquipmentItem } from "../common/EquipmentItem"
import { EventName, SceneEventType } from "../common/EventName"
import { Enum_UILayer, LayerManager } from "../common/LayerManager"
import { MainUIManager } from "../common/MainUIManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { BanqEvent, BanquetModel } from "../commonModel/BanquetModel"
import { ChatModel, ChatModelEvent, CHAT_TYPE } from "../commonModel/ChatModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { MainFunc, MainUIModel } from "../commonModel/MainUIModel"
import { MarriageModel } from "../commonModel/MarriageModel"
import { Scene } from "../scene/Scene"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { SYTweenLite } from "../util/SYTweenLite"
import { TimeUtil } from "../util/TimeUtil"
import { GetSizeDeltaX, GlobalTimerQuest, SetAnchoredPosition, SetSizeDelta, Util } from "../util/Util"
import { BanquetAniManager } from "./BanquetAniManager"
import { BarrageItem } from "./BarrageItem"
import "./BanquetGoodsView"
import "./BanBarrageView"
import "../mainUI/FlowerEffectView"
import { MainUIController } from "../commonController/MainUIController"
import { Message } from "../sysInfo/SysInfoController"
import { AutoFightManager } from "../autofight/AutoFightManager"
import { SceneManager } from "../scene/SceneManager"
import { GameMath } from "../util/GameMath"
export class BanquetSceneView extends BaseView1 {
	AddBarrage
	BarriageState
	CancelEndTimer
	CancelFireTimer
	CancelTopTime
	ClearTimeOut
	FindSuger
	HideSpeBarriage
	InitBanInfo
	InitCfg
	InitInfo
	PlayFire
	SetAura
	SetEndText
	SetPeopleText
	ShowSpeBarriage
	StarTopTime
	StartEndTimer
	StopSYTweenLite
	TimeText
	aniBanBtn
	aniSendBtn
	animation_is_open
	auraCfg
	auraItemList
	autoCollect
	autoFireTimer
	back_login_toClose
	banqEndTime
	banqEndTimer
	// banqRed
	barTotalList
	// barrageGp
	barrageList
	barrageNum
	destroy_callback
	destroy_imm

	endTime
	id
	isMaster
	manager: BanquetAniManager
	percentHeight
	percentWidth
	preload_server_config
	// recivedImg
	showList
	// topImg2
	topTimer
	tween_id1
	tween_id2
	tweens
	currQifen = 0;
	FindCollect
	last_stage_id//上一个阶段的id 用于判断婚宴结束进行寻路找糖果和蛋糕
	InitLastStageId
	collecting = false
	public constructor() {
		super()

		this.manager = BanquetAniManager.GetInstance();
		this.barrageList = [];
		this.barTotalList = [];
		this.showList = [];
		this.barrageNum = 0;
		this.animation_is_open = false;
		this.autoCollect = false;
		this.isMaster = false;
		this.base_file = "marriage2"
		this.layout_file = "BanquetSceneView"
		this.destroy_imm = true
		this.back_login_toClose = true
		this.layer_value = Enum_UILayer.Main
		let model: BanquetModel = BanquetModel.GetInstance()

		let local_BanqEvent = BanqEvent
		let local_GlobalEventSystem = GlobalEventSystem
		let local_SceneEventType = SceneEventType
		let chat_model = ChatModel.GetInstance()
		let local_laya = Laya
		let layer_mgr = LayerManager.GetInstance()
		let mainUI_model = MainUIModel.GetInstance()
		let local_MainUIModel = MainUIModel
		let goods_model = GoodsModel.GetInstance()
		let scene = Scene.GetInstance()
		// let local_eui = eui
		let local_TimeUtil = TimeUtil
		this.tweens = []
		this.load_callback = () => {

			//MainUIManager.GetInstance().AddMoveComponent(this, this._box_bottom, false, MainUIManager.MOVE_TYPE.Buttom)
			MainUIManager.GetInstance().AddMoveComponent(this, this.leaveBtn, false, MainUIManager.MOVE_TYPE.Left)
			MainUIManager.GetInstance().AddMoveComponent(this, this.rightGp, false, MainUIManager.MOVE_TYPE.Right)
			MainUIManager.GetInstance().AddMoveComponent(this, this.TopGp, false, MainUIManager.MOVE_TYPE.Top)
			MainUIManager.GetInstance().AddMoveComponent(this, this.leftGp, false, MainUIManager.MOVE_TYPE.Left)


			this.InitCfg()
			this.InitInfo()
		}

		this.destroy_callback = () => {
			MainUIManager.GetInstance().RemoveMoveComponent(this)
			Laya.timer.clearAll(this)
			if (this.auraItemList) {
				for (let _tmpi in this.auraItemList) {
					var vo = this.auraItemList[_tmpi]
					vo.DeleteMe()
					vo = null
				}
				this.auraItemList = []
			}
			if (this.barTotalList) {
				for (let _tmpi in this.barTotalList) {
					var vo = this.barTotalList[_tmpi]
					//local_laya.Tween.removeTweens(vo)
					vo.DeleteMe()
					vo = null
				}
				this.barTotalList = []
				this.barrageList = []
				this.showList = []
			}
			for (let k in this.tweens) {
				var v = this.tweens[k]
				SYTweenLite.Stop(v)
			}
			this.tweens = []
			this.CancelTopTime()
			this.CancelFireTimer()
			this.CancelEndTimer()
			this.manager.stopWeddingAnimation()
			this.StopSYTweenLite()
			if (this.barrageGp) {
				// destroy(this.barrageGp.gameObject, true)
				this.barrageGp = null
			}
			this.auraCfg = null
			this.manager.Reset()
			this.ClearTimeOut()
		}

		this.StopSYTweenLite = () => {
			if (this.tween_id1) {
				SYTweenLite.Stop(this.tween_id1)
				this.tween_id1 = null
			}
			if (this.tween_id2) {
				SYTweenLite.Stop(this.tween_id2)
				this.tween_id2 = null
			}
		}


		this.preload_server_config = {
			"config_wedding_aura": false,
			"config_wedding_time_stage": false
		}
		// this.preload_server_config = [config_wedding_aura=false, config_wedding_time_stage=false]
		this.InitCfg = () => {
			this.auraCfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_wedding_aura", false)
			//this._gp_con.percentHeight = 100
			//this._gp_con.percentWidth = this._gp_con.percentHeight
			// this.form.pivot = new Vector2(0.5, 0)
			// this.form.anchorMin = new Vector2(0, 0)
			// this.form.anchorMax = new Vector2(1, 0)
			// this.form.sizeDelta = new Vector2(0, 1280)
		}


		this.FindCollect = (skip_mon_ins_id?,is_another_collect?) => {
			if (this.use_delete_method) return
			if (!AutoFightManager.GetInstance().GetAutoFightState()) return
			if (this.collecting) {
				return
			}

			let monster
			let target
			let monVo
			let x = null
			let y = null
			let distance = null
			let scene = Scene.GetInstance()
			let attacker = scene.main_role
			let monsterList = scene.GetMonsterList()
			for (let k in monsterList) {
				monster = monsterList[k];
				monVo = monster.GetVo()

				if(is_another_collect){
					if(skip_mon_ins_id&&skip_mon_ins_id==monVo.instance_id){
						if(!BanquetModel.GetInstance().CanSuger(monVo.type_id,monVo.instance_id))continue //喜糖只能一个人采集
					}
				}else{
					if(skip_mon_ins_id&&skip_mon_ins_id==monVo.instance_id)continue
				}
				

				if (model.CanSuger(monVo.type_id, monVo.instance_id) || model.CanEat(monVo.type_id, monVo.instance_id)) {
					

					//计算距离
					x = monster.x
					y = monster.y

					let newdistance = GameMath.GetDistance(attacker.x, attacker.y, x, y)
					if (distance == null) {
						distance = newdistance
						target = monster
					}else if(newdistance<distance){
						distance = newdistance
						target = monster
					}
				}
			}


			
			if (target) {
				scene.MainRoleAttackMonster(target)
				scene.SetClickTarget(target)
			}else{
				scene.SetClickTarget(null)
			}
		}

		this.InitInfo = () => {

			this.endLabel.style.fontSize = this.peopleLb.style.fontSize = this.expLabel.style.fontSize = this.nomSugerLb.style.fontSize = this.expSugerLb.style.fontSize = this.nextStageLb.style.fontSize = 18;
			this.endLabel.style.wordWrap = this.peopleLb.style.wordWrap = this.expLabel.style.wordWrap = this.nomSugerLb.style.wordWrap = this.expSugerLb.style.wordWrap = this.nextStageLb.style.wordWrap = false;
			this.endLabel.style.color = this.peopleLb.style.color = this.expLabel.style.color = this.nomSugerLb.style.color = this.expSugerLb.style.color = this.nextStageLb.style.color = "#663915";

			Util.AddClickEvent(this.nomSugerGp, () => {
				this.FindSuger(0)
			}
				, this, true)
			Util.AddClickEvent(this.expSugerGp, () => {
				this.FindSuger(1)
			}
				, this, true)
			Util.AddClickEvent(this.banBtn, () => {
				this.BarriageState()
			}
				, this, true)
			Util.AddClickEvent(this.sendBtn, () => {
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "BanBarrageView")
			}
				, this, true)
			Util.AddClickEvent(this.fireBtn, () => {//烟花
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "BanquetGoodsView", 2)
				this.ClearUIEffect(this.fireEffect)
			}
				, this, true)
			Util.AddClickEvent(this.sugerBtn, () => {//喜糖
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "BanquetGoodsView", 1)
				this.ClearUIEffect(this.sugerEffect)
			}
				, this, true)
			Util.AddClickEvent(this.guestBtn, () => {//宾客管理
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "BanquetInviteView")
			}
				, this, true)
			Util.AddClickEvent(this.leaveBtn, () => {
				model.Fire(local_BanqEvent.REQUET_PROTO, 17264)
			}
				, this, true)
			this.BindEvent(model, local_BanqEvent.UPDATE_GOODS_INFO, (info?) => {
				if (info.if_master == 1) {
					this.guestBtn.visible = true
					this.sugerBtn.visible = true
					this.isMaster = true
					this.banqRed.visible = model.newApply
					// this.AddUIEffect("ui_function_glow", this.sugerEffect, null, null, true)
				} else {
					this.guestBtn.visible = false
					this.sugerBtn.visible = false
				}
			}
			)
			this.BindEvent(model, local_BanqEvent.BANQUET_INFO, () => {
				this.InitBanInfo()
			}
			)


			this.BindEvent(GlobalEventSystem, EventName.START_TO_COLLECT, () => {
				this.collecting = true
			}
			)


			this.BindEvent(model, local_BanqEvent.EXP, (scmd?) => {
				this.expLabel.innerHTML = `累计经验:${Util.HtmlColorTxt(scmd.all_exp, "'#0a953e'")}`;
			}
			)
			model.Fire(local_BanqEvent.REQUET_PROTO, 17275)
			this.BindEvent(model, local_BanqEvent.AURA, (vo?) => {
				this.SetAura(vo)
			}
			)
			// this.BindEvent(local_GlobalEventSystem, local_SceneEventType.ROLE_VO_ADD, (role_id?, role_vo?) => {
			// 	this.SetPeopleText()
			// 	// this.manager.AddVo(role_id)
			// }
			// )

			// this.BindEvent(local_GlobalEventSystem, local_SceneEventType.ROLE_VO_REMOVE, () => {
			// 	this.SetPeopleText()
			// }
			// )
			this.BindEvent(chat_model, ChatModelEvent.CHAT_CHANNEL_MSG_UPDATE, (channel?) => {
				if (channel == CHAT_TYPE.BARRAGE) {
					let list = chat_model.getChannelChat(CHAT_TYPE.BARRAGE)
					if (list) {
						let i = list.length
						if (i >= 0) {
							do {
								let info = table.remove(list) //list:pop()
								if (info) {
									this.AddBarrage(info)
								}
								i = i - 1
							} while ((i >= 0))
						}
					}
				}
			}
			)
			this.BindEvent(local_GlobalEventSystem, local_SceneEventType.MONSTER_VO_ADD, (mon_id?, monVo?) => {
				Laya.timer.frameOnce(10, this, this.FindCollect)
			}
			)
			this.BindVar(model, "newApply", (value?) => {
				if (this.guestBtn.visible) {
					this.banqRed.visible = model.newApply
				}
			}
			)
			let i = 1
			do {
				// [ts2lua]this下标访问可能不正确
				Util.AddClickEvent(this["objstage" + i], () => {
					local_GlobalEventSystem.Fire(EventName.OPEN_INSTRUCTION_VIEW, "17203")
				}
					, this, true)
				i = i + 1
			} while ((i <= 3))
			this.CancelFireTimer()
			if (!this.autoFireTimer) {
				this.autoFireTimer = GlobalTimerQuest.AddPeriodQuest(this.PlayFire, 30, -1)
			}
			this.BindEvent(model, local_BanqEvent.BARRIAGE_STATE, (bool?) => {
				if (bool) {
					this.ShowSpeBarriage()
				} else {
					this.HideSpeBarriage()
				}

				this.SetVisible(bool)
			}
			)

			this.BindEvent(GlobalEventSystem, EventName.BROADCAST_COLLECT_RESULT, (flag?, monster_type_id?, monster_ins_id?) => {
				this.collecting = false
				switch (flag) {
					case 2:
						//收集一个完成后，判断是否是挂机状态，挂机状态自动去采集别的东西，喜糖或者蛋糕
						if (!AutoFightManager.GetInstance().GetAutoFightState()) return
						this.FindCollect(monster_ins_id)

						break
					case 13:
						//如果有人正在采集该物品  则自动寻找其他物品采集
						if (!AutoFightManager.GetInstance().GetAutoFightState()) return
						this.FindCollect(monster_ins_id,true)
						break
				}


			})


			// let count_down_offset_h = layer_mgr.stageWidth / 2 + GetSizeDeltaX(this.display_obj) / 2
			// this.BindEvent(mainUI_model, local_MainUIModel.UPDATE_ACTIVITY_STATE, (bool?) => {
			// 	this.StopSYTweenLite();
			// 	if (bool) {
			// 		this.tween_id1 = SYTweenLite.to(this, this._gp_con, SYTweenLite.UiAnimationType.POSX, -count_down_offset_h, local_MainUIModel.Move_Time_Interval, () => {
			// 			SYTweenLite.Stop(this.tween_id1)
			// 			this.tween_id1 = null
			// 		})
			// 	} else {
			// 		this.tween_id1 = SYTweenLite.to(this, this._gp_con, SYTweenLite.UiAnimationType.POSX, 0, local_MainUIModel.Move_Time_Interval, () => {
			// 			SYTweenLite.Stop(this.tween_id1)
			// 			this.tween_id1 = null
			// 		})
			// 	}
			// }
			// )

			//MainUIManager.GetInstance().AddMoveComponent(this, this._gp_con, false, MainUIManager.MOVE_TYPE.Right)

			model.Fire(local_BanqEvent.REQUET_PROTO, 17272)
			model.Fire(local_BanqEvent.REQUET_PROTO, 17262)
			model.Fire(local_BanqEvent.REQUET_PROTO, 17265)
			this.InitLastStageId()
			this.InitBanInfo()

			// this.SetPeopleText()
			this.StartEndTimer()
			//this:AddUIEffect2("ui_function_glow", this.fireEffect, null, null, true)
			mainUI_model.Fire(local_MainUIModel.CHANGE_ACTIVITY_STATE, false)
			if (!this.barrageGp) {
				// this.barrageGp = UiFactory.CreateChild(layer_mgr.GetUILayer(Enum_UILayer.UI), UIType.EmptyObject, "barrageGp").transform
				SetSizeDelta(this.barrageGp, Laya.stage.designWidth, Laya.stage.displayHeight);// ScreenWidth, ScreenHeight)
				//this.barrageGp.touchEnabled = false
				//this.barrageGp.touchChildren = true
				// layer_mgr:GetUILayer(Enum_UILayer.UIRoot):addChild(this.barrageGp)
			}
		}


		this.InitLastStageId = () => {
			let info = model.BanquetData
			if (info && info.stage_id > 0) {
				this.last_stage_id = info.stage_id
			}
		}

		this.InitBanInfo = () => {
			let info = model.BanquetData
			if (info && info.stage_id > 0) {
				this.StartEndTimer()
				SetAnchoredPosition(this.topLb, (info.stage_id - 1 || 0) * 186 + 57, this.topLb.y)
				//this.topLb.x = info.stage_id - 1 || 0 * 186 + 57
				this.endTime = info.stage_end_time
				this.StarTopTime()

				if (info.stage_id == 1) {
					this.stage2.gray = this.stage3.gray = true;
					this.end1.visible = this.end2.visible = this.end3.visible = false;
					this.topImg1.visible = true;
					this.topImg2.visible = this.topImg3.visible = false;
					this.last_stage_id = info.stage_id
				}
				else if (info.stage_id == 2) {
					this.stage1.gray = this.stage2.gray = false;
					this.stage3.gray = true;
					this.end1.visible = true;
					this.end2.visible = this.end3.visible = false;
					this.topImg2.visible = true;
					this.topImg1.visible = this.topImg3.visible = false;
					this.last_stage_id = info.stage_id
				}
				else if (info.stage_id == 3) {
					this.stage1.gray = this.stage2.gray = this.stage3.gray = false;
					this.end1.visible = this.end2.visible = true;
					this.topImg3.visible = true;
					this.topImg1.visible = this.topImg2.visible = false;

					if (this.last_stage_id != info.stage_id) {
						this.FindCollect()
					}
					this.last_stage_id = info.stage_id

					let monsterList = Scene.GetInstance().GetMonsterList()
					let asas=1
				}


				// let i = 1
				// do {
				// 	if (this["imgstage" + i]) {
				// 		if (info.stage_id == i) {
				// 			ResManager.GetInstance().SetImageSprite(this, this["imgstage" + i], "marriage2_asset", "uijh_" + (181 + i), true)
				// 			this["objend" + i].visible = false
				// 			this["objtopImg" + i].visible = true
				// 		} else {
				// 			ResManager.GetInstance().SetImageSprite(this, this["imgstage" + i], "marriage2_asset", "uijh_" + (181 + i) + "b", true)
				// 			this["objtopImg" + i].visible = false
				// 			if (i < info.stage_id) {
				// 				this["objend" + i].visible = true
				// 			} else {
				// 				this["objend" + i].visible = false
				// 			}
				// 		}
				// 	}
				// 	i = i + 1
				// } while ((i <= 3))

				this.peopleLb.innerHTML = `当前在场人数:${Util.HtmlColorTxt(info.guests_num, "'#d15e00'")}`;
				this.SetAura(info.aura)
				let candyInfo1 = model.CandyInfo(0)
				if (candyInfo1) {
					this.nomLessLb.text = "剩余:" + (candyInfo1.limit_num - info.less_normal_candies)
					this.nomSugerLb.innerHTML = `普通喜糖:${Util.HtmlColorTxt(info.less_normal_candies + "/" + candyInfo1.limit_num, "'#0a953e'")}`;

				}
				let candyInfo2 = model.CandyInfo(1)
				if (candyInfo2) {
					this.expLessLb.text = "剩余:" + (candyInfo2.limit_num - info.less_special_candies)
					this.expSugerLb.innerHTML = `豪华喜糖:${Util.HtmlColorTxt(info.less_special_candies + "/" + candyInfo2.limit_num, "'#0a953e'")}`;
				}
				if (info.stage_id == 2 && model.weddingRoleList) {//动画阶段
					if (!this.manager.start_one) {
						this.animation_is_open = true
						let wedding_time_stage_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_wedding_time_stage", false)
						// [ts2lua]lua中0和空字符串也是true，此处wedding_time_stage_cfg需要确认
						let c_time = (wedding_time_stage_cfg && (wedding_time_stage_cfg[2].continue_time) || (15))
						this.manager.now_run_time = info.stage_end_time - c_time;

						//今日发现出现了个问题，服务器结束时间戳-减去阶段2时间，还要比当前服务器时间大很多，这里暂时做个容错处理
						this.manager.now_run_time = this.manager.now_run_time > local_TimeUtil.getServerTime() ? local_TimeUtil.getServerTime() : this.manager.now_run_time;
						if (local_TimeUtil.getServerTime() - this.manager.now_run_time < 60) {
							if (this.manager.now_run_time > 0) {
								this.ClearTimeOut()
								this.id = setTimeout(() => {
									this.manager.setUpdateState(true)
								}, 1000)
							} else {
								this.manager.setUpdateState(true)
							}
						}
					}
				} else {
					if (this.animation_is_open) {
						this.manager.stopWeddingAnimation()
						this.animation_is_open = false
						this.manager.start_one = false
					}
				}
			}
		}

		this.ClearTimeOut = () => {
			if (this.id) {
				clearTimeout(this.id)
				this.id = null
			}
		}

		this.StarTopTime = () => {
			this.CancelTopTime()
			this.topTimer = GlobalTimerQuest.AddPeriodQuest(this.TimeText, 1, -1)
			this.TimeText()
		}

		this.CancelTopTime = () => {
			if (this.topTimer) {
				GlobalTimerQuest.CancelQuest(this.topTimer)
				this.topTimer = null
			}
		}

		this.CancelFireTimer = () => {
			if (this.autoFireTimer) {
				GlobalTimerQuest.CancelQuest(this.autoFireTimer)
				this.autoFireTimer = null
			}
		}

		// this.SetPeopleText = () => {
		// 	let list = SceneManager.GetInstance().GetAllRoleVos()
		// 	if (list) {

		// 		this.peopleLb.innerHTML = `当前在场人数:${Util.HtmlColorTxt((Util.TableSize(list) + 1), "'#d15e00'")}`;
		// 	}
		// }

		this.TimeText = () => {
			if (this.topLb && this.endTime - local_TimeUtil.getServerTime()) {
				this.topLb.text = local_TimeUtil.timeConvert(this.endTime - local_TimeUtil.getServerTime(), "mm:ss")
			} else {
				this.CancelTopTime()
			}
		}

		this.SetAura = (aura?) => {
			let cfg = this.auraCfg
			if (cfg) {
				let getAll = true
				for (let index in cfg) {

					// [ts2lua]cfg下标访问可能不正确
					if (aura <= cfg[index].aura_num) {
						// [ts2lua]cfg下标访问可能不正确
						this.nextStageLb.innerHTML = `下一阶段:${Util.HtmlColorTxt(aura + "/" + cfg[index].aura_num, "'#d15e00'")}`;
						if (!this.auraItemList) {
							this.auraItemList = []
						}
						// [ts2lua]cfg下标访问可能不正确
						let rewad = JSON.parse(cfg[index].reward_list)
						var i = 0
						if (i < rewad.length) {
							do {
								let item: EquipmentItem = this.auraItemList[i]
								if (!item) {
									item = new EquipmentItem(this.Content)
									item.Load()
									item.SetScale(0.5)
									this.auraItemList[i] = item
								}
								let v = rewad[i]
								item.ExcuteCallback(() => {
									let arr = goods_model.GetMappingTypeId(v[0], v[1])
									let type_id = arr[0], lock = arr[1]
									let goods_vo = goods_model.GetGoodsBasicByTypeId(type_id)
									if (goods_vo) {
										item.SetData(goods_vo.type_id, v[2])
									}
								})
								i = i + 1
							} while ((i < rewad.length))
						}
						// i = rewad.length
						// if (i < this.auraItemList.length) {
						// 	do {
						// 		let item: EquipmentItem = this.auraItemList[i]
						// 		if (item) {
						// 			item.display_obj.visible = false
						// 		}
						// 		i = i + 1
						// 	} while ((i < this.auraItemList.length))
						// }
						getAll = false
						break
					}
				}
				if (getAll) {
					if (this.currQifen != 0 && aura > this.currQifen && !this.recivedImg.visible) {
						let local_main_ui_down_view = MainUIController.GetInstance().main_ui_down_view;
						let endpos = local_main_ui_down_view.GetIconPos(MainFunc.Bag, { x: 0, y: 0 })
						if (endpos) {
							GlobalEventSystem.Fire(EventName.REWARD_FLY, JSON.parse(cfg[1].reward_list));
						}
						else {
							GlobalEventSystem.Fire(EventName.REWARD_FLY, JSON.parse(cfg[1].reward_list), null, { x: 680, y: 1150 });
						}
					}
					this.nextStageLb.innerHTML = "已全部领取"
					this.recivedImg.visible = true
				} else {
					this.recivedImg.visible = false
				}
				this.currQifen = aura;
			}
		}

		this.FindSuger = (index?) => {
			let list = []
			// [ts2lua]model.sugerId下标访问可能不正确
			let Id = model.sugerId[index]
			if (Id) {
				let boss = scene.GetMonsterByTypeId(Id)
				if (boss) {
					scene.MainRoleAttackMonster(boss)
					scene.SetClickTarget(boss)
				}
			}
		}

		this.AddBarrage = (info?) => {
			if (model.BanMsg) {
				return
			}
			if (info.msg == "*&^") {
				Message.show("聊天内容中含有敏感词")
				return;
			}
			let item: BarrageItem = this.barrageList.pop()
			if (!item) {
				item = new BarrageItem(this.barrageGp)
				// table.insert(this.barTotalList, item)
				// this.barrageList.push(item);
				item.Load();
			}
			item.ExcuteCallback(() => {
				item.SetInfo(info)
				this.barrageNum = this.barrageNum + 1
				item.SetVisible(true)
				let x = Laya.stage.width;
				let y = this.barrageNum % 4 * 50 + 300 + Util.GetLiuhaiHeight() || 0
				SetAnchoredPosition(item.display_obj, x, y)
				let index = this.barTotalList.length
				let id = SYTweenLite.to(this, item.display_obj, SYTweenLite.UiAnimationType.POSX, -1500, 20, () => {
					item.SetVisible(false);
					this.barrageList.push(item);
					// table.insert(this.barrageList, item)
				})
				table.insert(this.tweens, id)


				//local_laya.Tween.get(item):to({x=-1200}, 20000).call(() => {
				//item.transform.visible = false  
				//table.insert(this.barrageList, item)
				//}
				//)
			}
			)

		}

		this.PlayFire = () => {
			MarriageModel.GetInstance().PlayFlowerEffectByName("uifx_giftlv3")
		}

		this.BarriageState = () => {
			if (model.BanMsg) {
				model.BanMsg = false
				// for (let _tmpi in this.barTotalList) {
				// 	var vo = this.barTotalList[_tmpi]
				// 	if (vo) {
				// 		vo.transform.visible = true
				// 	}
				// }
				this.barrageGp.visible = true;
				ResManager.GetInstance().SetImageSprite(this, this.banBtn, "marriage2_asset", "uijh_193", true)
				if (this.aniBanBtn) {
					ResManager.GetInstance().SetImageSprite(this, this.aniBanBtn.GetComponent("Image"), "marriage2_asset", "uijh_193", true)
				}
			} else {
				model.BanMsg = true
				// for (let _tmpi in this.barTotalList) {
				// 	var vo = this.barTotalList[_tmpi]
				// 	if (vo) {
				// 		vo.transform.visible = false
				// 	}
				// }
				this.barrageGp.visible = false;
				ResManager.GetInstance().SetImageSprite(this, this.banBtn, "marriage2_asset", "uijh_194", true)
				if (this.aniBanBtn) {
					ResManager.GetInstance().SetImageSprite(this, this.aniBanBtn.GetComponent("Image"), "marriage2_asset", "uijh_194", true)
				}
			}
		}

		this.ShowSpeBarriage = () => {
			if (!this.aniBanBtn) {
				let func = () => {
					this.BarriageState()
				}
				// this.aniBanBtn = NewImage(this, this.barrageGp, null, Enum_UILayer.Main, true, func, "aniBanBtn", "marriage2_asset", "uijh_193", null, null, null, null, true)
				//this.barrageGp.addChild(this.aniBanBtn)
				//this.aniBanBtn.source = "marriage2_asset.uijh_193"
				//let banPos = this.banBtn.localToGlobal(0, 0)
				// SetAnchoredPosition(this.aniBanBtn, GetGlobalPositionX(this.banBtn), GetGlobalPositionY(this.banBtn))
				//this.aniBanBtn.x = banPos.x
				//this.aniBanBtn.y = banPos.y
			}
			// this.aniBanBtn.visible = true
			if (!this.aniSendBtn) {
				if (!this.aniSendBtn) {
					let func = () => {
						GlobalEventSystem.Fire(EventName.OPEN_VIEW, "BanBarrageView")
					}
					// this.aniSendBtn = NewImage(this, this.barrageGp, null, Enum_UILayer.Main, true, func, "aniBanBtn", "marriage2_asset", "uijh_195", null, null, null, null, true)
					//this.barrageGp.addChild(this.aniSendBtn)
					//let sendPos = this.sendBtn.localToGlobal(0, 0)
					// SetAnchoredPosition(this.aniSendBtn, GetGlobalPositionX(this.sendBtn), GetGlobalPositionY(this.sendBtn))
					//this.aniSendBtn.x = sendPos.x
					//this.aniSendBtn.y = sendPos.y
					//AddClickEvent(this.aniSendBtn,() => {
					//
					//}
					//, this)
				}
			}
			// this.aniSendBtn.visible = true
		}

		this.HideSpeBarriage = () => {
			if (this.aniBanBtn) {
				this.aniBanBtn.visible = false
			}
			if (this.aniSendBtn) {
				this.aniSendBtn.visible = false
			}
		}

		this.StartEndTimer = () => {
			let curStage = null
			let endTime = 0
			let info = model.BanquetData
			this.CancelEndTimer()
			if (info) {
				curStage = info.stage_id
				let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_wedding_time_stage", false)
				if (cfg) {
					for (let index in cfg) {

						// [ts2lua]cfg下标访问可能不正确
						if (cfg[index].stage_id > curStage) {
							// [ts2lua]cfg下标访问可能不正确
							endTime = endTime + cfg[index].continue_time
							// [ts2lua]cfg下标访问可能不正确
						} else if (cfg[index].stage_id == curStage) {
							endTime = endTime + info.stage_end_time - local_TimeUtil.getServerTime()
						}
					}
				}
				this.banqEndTime = local_TimeUtil.getServerTime() + endTime
				if (!this.banqEndTimer) {
					this.banqEndTimer = GlobalTimerQuest.AddPeriodQuest(this.SetEndText, 1, -1)
					//this.banqEndTimer.addEventListener(local_laya.TimerEvent.TIMER, this.SetEndText, this)
					//this.banqEndTimer.start()
				}
			}
		}

		this.SetEndText = () => {
			if (this.banqEndTime >= local_TimeUtil.getServerTime()) {

				this.endLabel.innerHTML = `婚礼剩余时长:${Util.HtmlColorTxt(local_TimeUtil.timeConvert(this.banqEndTime - local_TimeUtil.getServerTime(), "mm:ss"), "'#d15e00'")}`;
			} else {
				this.CancelEndTimer()
			}
		}

		this.CancelEndTimer = () => {
			if (this.banqEndTimer) {
				GlobalTimerQuest.CancelQuest(this.banqEndTimer)
				this.banqEndTimer = null
			}
		}


	}


	public DeleteMe() {
		super.DeleteMe()
	}

	_Image1: Laya.Image
	_box_bottom: Laya.Box
	nomSugerGp: Laya.Box
	_Image7: Laya.Image
	_Image8: Laya.Image
	nomLessLb: Laya.Label
	expSugerGp: Laya.Box
	_Image9: Laya.Image
	_Image10: Laya.Image
	expLessLb: Laya.Label
	leaveBtn: Laya.Image
	barrageGp: Laya.Box
	rightGp: Laya.Box
	banBtn: Laya.Image
	sendBtn: Laya.Image
	guestBtn: Laya.Image
	banqRed: Laya.Image
	leftGp: Laya.Box
	endLabel: Laya.HTMLDivElement
	peopleLb: Laya.HTMLDivElement
	_Label1: Laya.Label
	expLabel: Laya.HTMLDivElement
	nomSugerLb: Laya.HTMLDivElement
	expSugerLb: Laya.HTMLDivElement
	nextStageLb: Laya.HTMLDivElement
	_Label2: Laya.Label
	_Label3: Laya.Label
	_Scroller1: Laya.Panel
	Content: Laya.HBox
	recivedImg: Laya.Image
	fireBtn: Laya.Image
	sugerBtn: Laya.Image
	sugerEffect: Laya.Box
	fireEffect: Laya.Box
	TopGp: Laya.Box
	stage1: Laya.Image
	stage2: Laya.Image
	stage3: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	topImg1: Laya.Image
	topImg2: Laya.Image
	topImg3: Laya.Image
	topLb: Laya.Label
	end1: Laya.Image
	end2: Laya.Image
	end3: Laya.Image
	public GetComponents() {
		[
			this._Image1,
			this._box_bottom,
			this.nomSugerGp,
			this._Image7,
			this._Image8,
			this.nomLessLb,
			this.expSugerGp,
			this._Image9,
			this._Image10,
			this.expLessLb,
			this.leaveBtn,
			this.barrageGp,
			this.rightGp,
			this.banBtn,
			this.sendBtn,
			this.guestBtn,
			this.banqRed,
			this.leftGp,
			this.endLabel,
			this.peopleLb,
			this._Label1,
			this.expLabel,
			this.nomSugerLb,
			this.expSugerLb,
			this.nextStageLb,
			this._Label2,
			this._Label3,
			this._Scroller1,
			this.Content,
			this.recivedImg,
			this.fireBtn,
			this.sugerBtn,
			this.sugerEffect,
			this.fireEffect,
			this.TopGp,
			this.stage1,
			this.stage2,
			this.stage3,
			this._Image2,
			this._Image3,
			this.topImg1,
			this.topImg2,
			this.topImg3,
			this.topLb,
			this.end1,
			this.end2,
			this.end3,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_box_bottom",
				"nomSugerGp",
				"_Image7",
				"_Image8",
				"nomLessLb",
				"expSugerGp",
				"_Image9",
				"_Image10",
				"expLessLb",
				"leaveBtn",
				"barrageGp",
				"rightGp",
				"banBtn",
				"sendBtn",
				"guestBtn",
				"banqRed",
				"leftGp",
				"endLabel",
				"peopleLb",
				"_Label1",
				"expLabel",
				"nomSugerLb",
				"expSugerLb",
				"nextStageLb",
				"_Label2",
				"_Label3",
				"_Scroller1",
				"Content",
				"recivedImg",
				"fireBtn",
				"sugerBtn",
				"sugerEffect",
				"fireEffect",
				"TopGp",
				"stage1",
				"stage2",
				"stage3",
				"_Image2",
				"_Image3",
				"topImg1",
				"topImg2",
				"topImg3",
				"topLb",
				"end1",
				"end2",
				"end3",
			])
	}
}
window["BanquetSceneView"] = BanquetSceneView