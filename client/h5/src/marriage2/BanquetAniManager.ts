import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseView1 } from "../common/BaseView1"
import { EventName, SceneEventType } from "../common/EventName"
import { Enum_UILayer, LayerManager } from "../common/LayerManager"
import { ViewManager } from "../common/ViewManager"
import { OperateManager } from "../operation/OperateManager"
import { RoleManager } from "../commonModel/RoleManager"
import { CameraManager } from "../scene/CameraManager"
import { Scene } from "../scene/Scene"
import { MOVE_TYPE, SceneBaseType } from "../scene/SceneConfig"
import { SceneManager } from "../scene/SceneManager"
import { FRAME_TYPE, GlobalEventSystem, LogicRealRatio_X, LogicRealRatio_Y } from "../util/DeclareGlobalVar"
import { Runner } from "../util/Runner"
import { Vector2 } from "../util/Vector2"
import { BanqEvent, BanquetModel } from "../commonModel/BanquetModel"
import { DialogueView } from "../dialogue/DialogueView"
import { TimeUtil } from "../util/TimeUtil"
import { Util, SetLocalPosition } from "../util/Util"
import { Character } from "../scene/sceneobj/Character"
import { MainUIController } from "../commonController/MainUIController"
import { ModelPartPos, RoleVo } from "../sharedata/RoleVo"
import { Role } from "../scene/sceneobj/Role"
import { ViewPopLevelModel } from "../commonModel/ViewPopLevelModel"
import { SceneObj } from "../scene/sceneobj/SceneObj"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"
import { EventDispatcher } from "../util/EventDispatcher"
import { MapManager } from "../scene/MapManager"

export class BanquetAniManager extends EventDispatcher {
	private static Instance: BanquetAniManager
	public bool_playing = false	//动画是否播放中
	public now_run_time = null
	public start_one = false	//开始一次
	public npc_id = 51519001

	public bool_update = false
	public event_list = {}
	public need_add_list = {}
	public bool_start_music = false
	public temp = 0
	public woman_feaker_id
	public man_feaker_id
	MakeFakerRole
	// reset_rotation
	/** 触发条件时候，会在BanquetSceneView调用此函数*/
	public setUpdateState;
	/** 婚宴仪式动画结束调用*/
	public stopWeddingAnimation;
	public Update;
	/** 检查动画播放的步骤*/
	private checkAnimationPlaying;
	/** 动画播放流程步骤处理逻辑*/
	private PlayAnimation;
	/** 婚宴仪式动画过程中设置隐藏图层，结束则调用显示出来*/
	SetLayerVisible;
	cache_boo = true
	check_layer_time = 0
	getMyIdentity
	/** 创建新郎*/
	public GetGroomObj;
	/** 创建新娘*/
	public GetBrideObj;
	private TalkState;
	/** 打开剧情对话界面*/
	private SetView;
	/** 设置时装*/
	private ChangeRoleCloth;
	/** 恢复原来的时装*/
	private ReSetRoleCloth;
	/** 中途加入处理*/
	private SetNowPos;
	/**动画进行到司仪位置的时候，将新娘新郎的本体移到司仪位置*/
	MoveReality
	Reset
	currTime = 0;
	Banquet_fashion_id
	Banquet_fashion_head_id
	faker_id = 1000000000 //用于区分假人
	public constructor() {
		super()
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let scene_mgr = SceneManager.GetInstance()
		let auto_fight_mgr = AutoFightManager.GetInstance()
		let runner = Runner.GetInstance()
		let view_mgr = ViewManager.GetInstance()
		let scene = Scene.Instance
		let camera_mgr = CameraManager.GetInstance()
		let operate_mgr = OperateManager.GetInstance()
		let role_mgr = RoleManager.GetInstance()
		let local_Vector2 = Vector2
		let local_SceneBaseType = SceneBaseType
		let local_Enum_UILayer = Enum_UILayer
		let ban_quet_model = BanquetModel.GetInstance()
		let layer_mgr = LayerManager.GetInstance(),
			model = BanquetModel.GetInstance(),
			now_go_time_ = 1,	//记录当前帧的时间
			last_go_time_ = 0,	//记录上一帧的时间
			move_speed_ = 160,	//婚礼动画的走路速度
			posCfg_,
			talk_cfg_,
			curr_talk_step_ = 0,
			manSpeed_ = 300,
			womanSpeed_ = 300,
			max_time_ = 60000,
			diaView_: DialogueView,
			runId_,
			/**速度监听事件*/
			manBindId_,
			womanBindId_

		this.Banquet_fashion_id = [1010005, 1020005, 1010005, 1020005] // 婚宴时装
		this.Banquet_fashion_head_id = [1011005, 1021005, 1011005, 1021005] // 婚宴时装发饰
		posCfg_ = model.PosCfg
		local_GlobalEventSystem.Bind(EventName.CHECK_TO_PLAY_NEXT_DIALOGUE, () => {
			//通过监听 剧情对话界面关闭，来检查一次，是否还有未完成对话
			if (scene_mgr.IsWeddingScene() && talk_cfg_) {
				curr_talk_step_++
				let cfg = talk_cfg_[curr_talk_step_]
				if (cfg) {
					this.SetView(cfg)
				} else {
					if (diaView_) {
						// diaView_.Close()
						diaView_ = null
					}
					this.stopWeddingAnimation()
				}
			}
		})

		let cache_OPENBIGVIEWFRAME
		/** 触发条件时候，会在BanquetSceneView调用此函数*/
		this.setUpdateState = (state) => {
			if (state) {
				this.check_layer_time = TimeUtil.getServerTimeMs()
				this.SetLayerVisible(false)
				auto_fight_mgr.SetAutoFight(false)
				this.bool_playing = true
				this.GetBrideObj()
				this.GetGroomObj()
				this.ChangeRoleCloth()
				if (!this.bool_update) {
					this.bool_update = true
					runId_ = runner.AddRunObj(this, 1, FRAME_TYPE.total)
				}
				let bg = view_mgr.GetBackGround()
				if (bg) {
					bg.mouseEnabled = false
					bg.visible = false
					let uiroot = LayerManager.GetInstance().GetUILayer(Enum_UILayer.UIRoot);
					uiroot.mouseEnabled = false;
				}

				//婚礼场景强制显示
				layer_mgr.SetLayerVisible(local_Enum_UILayer.Shadow, "BanquetAniManager", true)
                layer_mgr.SetLayerVisible(local_Enum_UILayer.TalkBoard, "BanquetAniManager", true)
                layer_mgr.SetLayerVisible(local_Enum_UILayer.DamageFont, "BanquetAniManager", true)

				MapManager.GetInstance().SetMapVisible("BanquetAniManager", true)
                layer_mgr.SetScene3DVisible("BanquetAniManager", true)
                CameraManager.GetInstance().SetMainCameraVisible("BanquetAniManager", true)
				
				cache_OPENBIGVIEWFRAME = ViewManager.OPENBIGVIEWFRAME
				ViewManager.OPENBIGVIEWFRAME = 1

			} else {
				this.SetLayerVisible(true)
				if (this.bool_update) {
					this.bool_update = false
					if (runId_) {
						runner.RemoveRunObj(runId_)
					}
				}
				let bg = view_mgr.GetBackGround()
				if (bg) {
					bg.mouseEnabled = true
					bg.visible = true
					let uiroot = LayerManager.GetInstance().GetUILayer(Enum_UILayer.UIRoot);
					uiroot.mouseEnabled = true;
				}
			}
		}

		this.stopWeddingAnimation = () => {
			// this.StopPlayWeddingMusic()
			if (this.bool_playing) {
				console.log("婚宴动画结束")
				this.bool_playing = false

				this.ReSetRoleCloth()
				this.SetLayerVisible(true)
				this.TalkState(false)
				this.setUpdateState(false)
				if (this.man_feaker_id) {
					scene_mgr.DeleteRoleVo(this.man_feaker_id)
					this.man_feaker_id = null
				}
				if (this.woman_feaker_id) {
					scene_mgr.DeleteRoleVo(this.woman_feaker_id)
					this.woman_feaker_id = null
				}
				auto_fight_mgr.SetAutoFight(true)
				let realPos = scene.GetMainRole().GetRealPos()
				if (realPos) {
					camera_mgr.SetCameraPos(realPos.x, realPos.y, true)
				}

				layer_mgr.SetLayerVisible(local_Enum_UILayer.Main, "BanquetAniManager", null)
				layer_mgr.SetLayerVisible(local_Enum_UILayer.UI, "BanquetAniManager", null)
				layer_mgr.SetLayerVisible(local_Enum_UILayer.Activity, "BanquetAniManager", null)
				layer_mgr.SetLayerVisible(local_Enum_UILayer.Top, "BanquetAniManager", null)
                layer_mgr.SetLayerVisible(local_Enum_UILayer.NameBoard, "BanquetAniManager", null)

				layer_mgr.SetLayerVisible(local_Enum_UILayer.Shadow, "BanquetAniManager", null)
                layer_mgr.SetLayerVisible(local_Enum_UILayer.TalkBoard, "BanquetAniManager", null)
                layer_mgr.SetLayerVisible(local_Enum_UILayer.DamageFont, "BanquetAniManager", null)

				MapManager.GetInstance().SetMapVisible("BanquetAniManager", null)
                layer_mgr.SetScene3DVisible("BanquetAniManager", null)
                CameraManager.GetInstance().SetMainCameraVisible("BanquetAniManager", null)

				if(cache_OPENBIGVIEWFRAME){
					ViewManager.OPENBIGVIEWFRAME = cache_OPENBIGVIEWFRAME
					cache_OPENBIGVIEWFRAME = null
				}

				//将暂存的界面显示出来
				ViewPopLevelModel.GetInstance().NextPop()

				//展示新娘
				let woman = scene.GetRole(model.GetBrideId())
				if (woman) {
					woman.HandleWeddingStateFlag()
				}
				let man = scene.GetRole(model.GetGroomId())
				if (man) {
					man.HandleWeddingStateFlag()
				}
				this.Reset()

			}
		}

		this.Update = (now_time, elapse_time) => {
			if (!this.now_run_time) {//婚宴动画开始起始的时间戳
				return
			}

			//设置图层可见性 用于强制设置图层的可见性，因为有时候断线重连会出现图层无法隐藏的情况
			if (TimeUtil.getServerTimeMs() - this.check_layer_time < 2000) {
				this.SetLayerVisible(this.cache_boo)
			}



			this.bool_update = true
			last_go_time_ = now_go_time_
			now_go_time_ = TimeUtil.getServerTimeMs() - this.now_run_time * 1000; //当前时间-开始时间戳 = 算出活动已经开始多久了
			if (model.ClientCfg) {
				let list = model.ClientCfg.aniStage//= Config.ConfigMarriage.wedding_animation_stage_info
				if (list && last_go_time_ >= 0 && now_go_time_ > 0 && now_go_time_ <= list[list.length - 1].time + 1000) {
					this.bool_playing = true
					// this.CheckPlayWeddingMusic()
					let info = model.weddingRoleList
					if (info && info.man_list && info.man_list[0] && info.woman_list && info.woman_list[0]) {
						this.checkAnimationPlaying()
						for (let vo of list) {
							if (vo.time > last_go_time_ && vo.time <= now_go_time_) {
								this.PlayAnimation(vo)
								// console.log("time" + vo.time);
								break
							}
						}
						let leader = scene.GetRole(this.man_feaker_id)
						if (leader && now_go_time_ > 300 && leader.x != 0 && leader.y != 0) {
							camera_mgr.SetCameraPos(leader.x, leader.y, true)
							// console.log("地图镜头移动" + leader.x + "----" + leader.y)
						}
					}
				}
				else {
					//断线重连 显示剧情
					let cfg: Array<any> = model.GetTalkCfg();
					for (let i: number = 0; i < cfg.length; i++) {
						if (now_go_time_ <= list[list.length - 1].time + (5000 * (i + 1))) {
							// console.log("跳出" + i);
							curr_talk_step_ = i;


							//设置新郎新娘的初始位置
							let temp = model.ClientCfg.aniStage[model.ClientCfg.aniStage.length - 2];
							for (let vo of temp.show_walk) {
								let roleObj: Character = null
								if (vo.kind == 1) {//新郎
									roleObj = this.GetGroomObj()
								} else if (vo.kind == 2) {//新娘
									roleObj = this.GetBrideObj()
								}
								if (roleObj && vo.pos) {
									roleObj.SetRealPos(vo.pos.x, vo.pos.y)
								}
							}

							let leader = scene.GetRole(this.man_feaker_id)
							if (leader && now_go_time_ > 300 && leader.x != 0 && leader.y != 0) {
								camera_mgr.SetCameraPos(leader.x, leader.y, true)
							}
							this.PlayAnimation(list[list.length - 1]);
							return;
						}
					}
					this.stopWeddingAnimation();
				}
				if (now_go_time_ > max_time_) {
					this.stopWeddingAnimation()
				}
			}

		}


		this.checkAnimationPlaying = () => {
			if (this.start_one) {
				return
			}
			if (now_go_time_ <= 100) {
				this.start_one = true
				return
			}
			let list = model.ClientCfg.aniStage
			this.start_one = true
			operate_mgr.StopMove()
			// this.SetLayerVisible(false)
			if (this.bool_playing) {
				for (let i = 0; i < list.length - 1; i++) {
					let lastStage = list[i]
					let goStage = list[i + 1]
					let now_go_time = now_go_time_
					if (now_go_time > lastStage.time && now_go_time < 3000) {
						// console.log("lastStage1" + "now_go_time---" + now_go_time)
						// console.log(lastStage)
						last_go_time_ = now_go_time
						this.PlayAnimation(lastStage)
					} else if (lastStage && goStage && lastStage.time < now_go_time && goStage.time >= now_go_time) {
						this.SetNowPos(lastStage, list[i - 1], goStage)
						last_go_time_ = now_go_time
						this.PlayAnimation(lastStage)
						// console.log("lastStage2" + "now_go_time--" + now_go_time)
						// console.log(lastStage)
						break
					}
				}
			}

		}

		/**测试宾客位置用 */
		this.MakeFakerRole = (i) => {
			let bride_id = 1000000000
			let bride = null
			let vo = new RoleVo()
			for (let index in model.weddingRoleList.woman_list[0]) {
				vo[index] = model.weddingRoleList.woman_list[0][index]
			}
			vo.role_id = bride_id + 1000000000 + i
			vo.name = "宾客" + i
			vo.ChangeVar("fashion_model_list", [], null, true)
			scene_mgr.AddRoleVo(vo)
			bride = scene.GetRole(bride_id + 1000000000 + i)
			return bride
		}

		this.PlayAnimation = (info) => {
			if (!info) {
				return
			}
			if (this.currTime == info.time) {
				return;
			}
			this.currTime = info.time;
			if (info.start_play) {
				// OperateManager.Instance.StopMove()
				this.start_one = true
				// this.SetLayerVisible(false)
			}


			//婚礼开始时，玩家的站位(宾客身份)
			if (info.guest_walk) {
				let kind = this.getMyIdentity()
				if (kind == 0) {
					let posList = posCfg_
					if (posList) {

						//红毯的起点和终点  用于设置宾客的朝向
						let pos1 = new Vector2(1830, 1724)
						let pos2 = new Vector2(3745, 2704)

						let my_pos_id = model.GetGuestPosId()
						// let tes= my_pos_id==1?19:1   19在红毯上方 1在红毯下方
						let standList = posList[my_pos_id]
						if (standList) {
							let endPos = new local_Vector2(standList.x, standList.y)
							let chui_zu: Vector2 = SeaHegemonyModel.GetInstance().MathGetPoint(pos1, pos2, endPos, true)//垂足

							let main_role: Role = scene.GetMainRole()

							//为了朝向 分两步走
							let move_off = 50 //随便设置的一个数值
							let K_ = (chui_zu.y - endPos.y) / (chui_zu.x - endPos.x)//斜率
							let B_ = chui_zu.y - K_ * chui_zu.x  //截距
							let end_pos_1_

							if (endPos.y > chui_zu.y) {
								//在红毯下方位置
								let end_pos_1_x = endPos.x - move_off
								let end_pos_1_y = K_ * end_pos_1_x + B_
								end_pos_1_ = new Vector2(end_pos_1_x, end_pos_1_y)
							} else {
								//在红毯上方位置
								let end_pos_1_x = endPos.x + move_off
								let end_pos_1_y = K_ * end_pos_1_x + B_
								end_pos_1_ = new Vector2(end_pos_1_x, end_pos_1_y)
							}


							if (main_role) {
								let end_pos_1 = new local_Vector2(end_pos_1_.x / LogicRealRatio_X, end_pos_1_.y / LogicRealRatio_Y)
								scene.MainRoleMove(end_pos_1, null, () => {

									let end_pos_2 = new local_Vector2(endPos.x / LogicRealRatio_X, endPos.y / LogicRealRatio_Y)
									scene.MainRoleMove(end_pos_2)

								})

							}


						}

						//测试宾客位置
						// for (let i = 1; i <= 41; i++) {
						// 	let standList = posList[i]
						// 	if (standList) {
						// 		let faker_role: Role = this.MakeFakerRole(i)
						// 		let endPos = new local_Vector2(standList.x, standList.y)
						// 		faker_role.SetRealPos(endPos.x, endPos.y)
						// 		let chui_zu: Vector2 = SeaHegemonyModel.GetInstance().MathGetPoint(pos1, pos2, endPos, true)//垂足
						// 		faker_role.SetDirection(endPos, chui_zu, endPos);
						// 	}
						// }

					}
				}
			}


			//隐藏新郎新娘本体 
			let bride: Role = scene.GetRole(model.GetBrideId())
			if (bride) {
				bride.HandleWeddingStateFlag()
			}
			let man = scene.GetRole(model.GetGroomId())
			if (man) {
				man.HandleWeddingStateFlag()
			}


			//设置起点
			if (info.show_stand) {
				for (let vo of info.show_stand) {
					let roleObj: Character = null
					if (vo.kind == 1) {//新郎
						roleObj = this.GetGroomObj()
					} else if (vo.kind == 2) {//新娘
						roleObj = this.GetBrideObj()
					}

					if (roleObj && vo.pos) {
						if (roleObj.GetType() == local_SceneBaseType.MainRole) {
							roleObj.SetRealPos(vo.pos.x, vo.pos.y, true)
						}
						else {
							roleObj.SetRealPos(vo.pos.x, vo.pos.y)
						}

					}
				}
			}


			//走红毯过程
			if (info.show_walk) {
				for (let vo of info.show_walk) {
					let roleObj: Character = null
					if (vo.kind == 1) {//新郎
						roleObj = this.GetGroomObj()
					} else if (vo.kind == 2) {//新娘
						roleObj = this.GetBrideObj()
					}

					if (roleObj && vo.pos) {
						let v = new local_Vector2(vo.pos.x, vo.pos.y)
						roleObj.DoMove(v)
					}
				}
			}


			//移动到司仪位置
			if (info.unlock_camera) {
				//转向
				let groom: Character = scene.GetRole(this.man_feaker_id)
				let bride: Character = scene.GetRole(this.woman_feaker_id)
				if (groom && bride) {
					let dir = { x: bride.real_pos.x - groom.real_pos.x, y: bride.real_pos.y - groom.real_pos.y };
					groom.SetDirection(dir, null, null, true)
					dir = { x: groom.real_pos.x - bride.real_pos.x, y: groom.real_pos.y - bride.real_pos.y };
					bride.SetDirection(dir, null, null, true)
				}
				if (runId_) {//移除定时器调用。
					runner.RemoveRunObj(runId_)
				}
				this.TalkState(true)
				this.MoveReality()
			}
		}

		this.MoveReality = (obj) => {
			if (RoleManager.GetInstance().GetMainRoleId() == model.GetGroomId()) {
				//新郎本体
				GlobalEventSystem.Fire(SceneEventType.MOVEREQUEST, 702, 957, MOVE_TYPE.BLINK)
				let man: Role = scene.GetRole(model.GetGroomId())
				if (man) {
					man.SetRealPos(702, 957)
				}

				//scene.MainRoleMove(movePos)
			}
			if (RoleManager.GetInstance().GetMainRoleId() == model.GetBrideId()) {
				//新娘本体
				GlobalEventSystem.Fire(SceneEventType.MOVEREQUEST, 784, 849, MOVE_TYPE.BLINK)
				let woman: Role = scene.GetRole(model.GetBrideId())
				if (woman) {
					woman.SetRealPos(784, 849)
				}
			}
		}


		this.SetLayerVisible = (bool) => {
			this.cache_boo = bool
			layer_mgr.SetLayerVisible(local_Enum_UILayer.Main, "BanquetAniManager", bool)
			layer_mgr.SetLayerVisible(local_Enum_UILayer.UI, "BanquetAniManager", bool)
			layer_mgr.SetLayerVisible(local_Enum_UILayer.Activity, "BanquetAniManager", bool)
			layer_mgr.SetLayerVisible(local_Enum_UILayer.NameBoard, "BanquetAniManager", bool)
			ban_quet_model.Fire(BanqEvent.BARRIAGE_STATE, bool)
		}

		this.getMyIdentity = () => {
			let roleId = role_mgr.GetMainRoleId()
			let identity = 0
			if (model.weddingRoleList) {
				if (roleId == model.GetGroomId()) {// weddingRoleList.man_list[0].role_id
					identity = 1
				} else if (roleId == model.GetBrideId()) {//model.weddingRoleList.woman_list[0].role_id
					identity = 2
				}
			}
			return identity
		}

		this.GetGroomObj = () => {
			let groom = null
			if (!this.man_feaker_id) {
				let groom_id = model.GetGroomId()
				let vo = new RoleVo()
				for (let index in model.weddingRoleList.man_list[0]) {
					vo[index] = model.weddingRoleList.man_list[0][index]
				}
				vo.role_id = groom_id + this.faker_id
				vo.level_model_list = []
				scene_mgr.AddRoleVo(vo)
				this.man_feaker_id = groom_id + this.faker_id
			} else {
				groom = scene.GetRole(this.man_feaker_id)
			}


			return groom
		}

		this.GetBrideObj = () => {

			let bride_id = model.GetBrideId()
			let bride = null
			if (!this.woman_feaker_id) {
				let vo = new RoleVo()
				for (let index in model.weddingRoleList.woman_list[0]) {
					vo[index] = model.weddingRoleList.woman_list[0][index]
				}
				vo.role_id = bride_id + this.faker_id
				vo.ChangeVar("fashion_model_list", [], null, true)
				scene_mgr.AddRoleVo(vo)
				this.woman_feaker_id = bride_id + this.faker_id
			} else {
				bride = scene.GetRole(this.woman_feaker_id)
			}
			return bride
		}

		this.TalkState = (value) => {
			if (value) {
				layer_mgr.SetLayerVisible(local_Enum_UILayer.Main, "BanquetAniManager", !value)
				layer_mgr.SetLayerVisible(local_Enum_UILayer.UI, "BanquetAniManager", !value)
				layer_mgr.SetLayerVisible(local_Enum_UILayer.Activity, "BanquetAniManager", !value)
				layer_mgr.SetLayerVisible(local_Enum_UILayer.Top, "BanquetAniManager", !value)
				if (!talk_cfg_) {
					talk_cfg_ = ban_quet_model.GetTalkCfg()
				}
				curr_talk_step_ = curr_talk_step_ ? curr_talk_step_ : 0;
				auto_fight_mgr.SetAutoFight(false)
				this.SetView(talk_cfg_[curr_talk_step_])
			} else {
				layer_mgr.SetLayerVisible(local_Enum_UILayer.Main, "BanquetAniManager", true)
				layer_mgr.SetLayerVisible(local_Enum_UILayer.UI, "BanquetAniManager", true)
				layer_mgr.SetLayerVisible(local_Enum_UILayer.Activity, "BanquetAniManager", true)
				layer_mgr.SetLayerVisible(local_Enum_UILayer.Top, "BanquetAniManager", true)
				local_GlobalEventSystem.Fire(local_EventName.OPEN_DIALOGUE_VIEW, true)
			}
		}

		this.SetView = (cfg) => {
			if (!diaView_) {
				diaView_ = new DialogueView()
			}
			// diaView_.autoTime = 2000
			// diaView_.canClick = false
			// diaView_.click_bg_toClose = false
			// diaView_.use_background = false
			diaView_.Open(cfg)
			// console.log(`更新任务对话`);
			// console.log(cfg);
		}

		this.ChangeRoleCloth = () => {
			//let manId = model.GetGroomId()
			if (this.man_feaker_id) {
				let ManVo: RoleVo = scene_mgr.GetRoleVo(this.man_feaker_id)
				if (ManVo) {
					manSpeed_ = ManVo.move_speed
					let role: Role = scene.GetRole(this.man_feaker_id)
					ManVo.ChangeVar("move_speed", move_speed_)
					if (role) {
						manBindId_ = ManVo.BindOne("move_speed", () => {
							role.SetMoveSpeed(move_speed_)
						})
					}
					// ManVo.ChangeVar("move_speed", move_speed_)// SetMoveSpeed(200)
					for (let i = 1; i <= 7; i++) {
						ManVo.SetFigureId(i, 0)
					}
					let clothId = BanquetModel.GetInstance().GetWedidingClothId(ManVo.sex)//ManVo.sex == 1 ? 1105 : 1205
					ManVo.ChangeVar("fashion_model_list",
						[
							{ part_pos: ModelPartPos.Clothe, fashion_model_id: clothId },
							{ part_pos: ModelPartPos.HeadWear, fashion_model_id: clothId }
						],
						null, true)
				}
			}
			//let womanId = model.GetBrideId()
			if (this.woman_feaker_id) {
				let womanVo: RoleVo = scene_mgr.GetRoleVo(this.woman_feaker_id)
				if (womanVo) {
					womanSpeed_ = womanVo.move_speed
					let role: Role = scene.GetRole(this.woman_feaker_id)
					womanVo.ChangeVar("move_speed", move_speed_)
					if (role) {
						womanBindId_ = womanVo.BindOne("move_speed", () => {
							role.SetMoveSpeed(move_speed_)
						})
					}
					// womanVo.ChangeVar("move_speed", move_speed_)
					for (let i = 1; i <= 7; i++) {
						womanVo.SetFigureId(i, 0)
					}
					let clothId = BanquetModel.GetInstance().GetWedidingClothId(womanVo.sex)//womanVo.sex == 1 ? 1105 : 1205
					womanVo.ChangeVar("fashion_model_list",
						[
							{ part_pos: ModelPartPos.Clothe, fashion_model_id: clothId },
							{ part_pos: ModelPartPos.HeadWear, fashion_model_id: clothId }
						],
						null, true)
					// womanVo.ChangeVar("level_model_list", [], null, true)
					// womanVo.ChangeVar("revelation_suit", 0)
				}
			}
		}


		this.ReSetRoleCloth = () => {
			let info = model.weddingRoleList
			if (info) {
				let manId = model.GetGroomId()
				if (manId) {
					let ManVo: RoleVo = scene_mgr.GetRoleVo(manId)
					if (ManVo) {
						if (manBindId_) {
							ManVo.UnBind(manBindId_)
							manBindId_ = null
						}
						ManVo.ChangeVar("move_speed", manSpeed_, false, true)
						let figure = model.GetGroomFigure()
						for (let v of figure.figure_list) {
							ManVo.SetFigureId(v.figure_type, v.figure_id)
						}
						ManVo.ChangeVar("fashion_model_list", figure.fashion_model_list, null, true)
						// ManVo.ChangeVar("level_model_list", figure.level_model_list, null, true)
						// ManVo.ChangeVar("revelation_suit", figure.revelation_suit, null, true)
					}
				}
				let womanId = model.GetBrideId()
				if (womanId) {
					let womanVo = scene_mgr.GetRoleVo(womanId)
					if (womanVo) {
						if (womanBindId_) {
							womanVo.UnBind(womanBindId_)
							womanBindId_ = null
						}
						womanVo.ChangeVar("move_speed", womanSpeed_, false, true)
						let figure = model.GetBrideFigure()
						for (let v of figure.figure_list) {
							womanVo.SetFigureId(v.figure_type, v.figure_id)
						}
						womanVo.ChangeVar("fashion_model_list", figure.fashion_model_list, null, true)
						// womanVo.ChangeVar("level_model_list", figure.level_model_list, null, true)
						// womanVo.ChangeVar("revelation_suit", figure.revelation_suit, null, true)
					}
				}
			}
		}

		/**中途加入时设置位置信息*/
		this.SetNowPos = (nowList, lastList, goList) => {
			console.warn("测试@中途加入")
			if (nowList && lastList && goList) {
				let LastFunc = lastList.show_walk || lastList.show_stand
				if (!nowList.show_walk) return
				for (let vo of nowList.show_walk) {
					let roleObj: Character = null
					if (vo.kind == 1) {//新郎
						roleObj = this.GetGroomObj()
					} else if (vo.kind == 2) {//新娘
						roleObj = this.GetBrideObj()
					}

					for (let vo1 of LastFunc) {
						if (vo.kind == vo1.kind && roleObj && vo1.pos) {
							let goTime = (now_go_time_ - nowList.time) / (goList.time - nowList.time)
							let posX = (vo.pos.x - vo1.pos.x) * goTime + vo1.pos.x
							let posY = (vo.pos.y - vo1.pos.y) * goTime + vo1.pos.y
							console.log(roleObj);
							if (roleObj.GetType() == local_SceneBaseType.MainRole) {
								roleObj.SetRealPos(posX, posY, true)
							} else {
								roleObj.SetRealPos(posX, posY)
							}
						}
					}
				}
			}
		}


		this.Reset = () => {
			this.bool_playing = false	//动画是否播放中
			this.now_run_time = null
			now_go_time_ = 0	//记录当前帧的时间
			last_go_time_ = 0	//记录上一帧的时间
			this.start_one = false	//开始一次
			this.bool_update = false
			curr_talk_step_ = 0
			this.check_layer_time=0
		}
	}

	public static GetInstance = () => {
		if (!BanquetAniManager.Instance) {
			BanquetAniManager.Instance = new BanquetAniManager()
		}
		return BanquetAniManager.Instance
	}
}

window["BanquetAniManager"] = BanquetAniManager