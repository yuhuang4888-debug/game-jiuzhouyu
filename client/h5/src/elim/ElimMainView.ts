import { Alert, Alert_Type } from "../alert/Alert"
import { BaseItem1 } from "../common/BaseItem1"
import { BaseView1 } from "../common/BaseView1"
import { EventName, LoginStateEvent } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { SoundManager } from "../common/SoundManager"
import { table } from "../common/table"
import { GuildActEvent, GuildActivityModel } from "../commonModel/GuildActivityModel"
import { GuildModel } from "../commonModel/GuildModel"
import { MiniGameModel } from "../commonModel/MiniGameModel"
import { RoleManager } from "../commonModel/RoleManager"
import { LoginManager } from "../login/LoginManager"
import { Message } from "../sysInfo/SysInfoController"
import { ColorUtil, Enum_ColorUtil_Dark, Enum_ColorUtil_Light, Enum_ColorUtil_NEW } from "../util/ColorUtil"
import { ClientConfig, GlobalEventSystem, LOAD_QUEUE } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { SYTweenLite } from "../util/SYTweenLite"
import { GlobalTimerQuest, HtmlColorTxt, PlayBigEffect, RefBoxChildsLayout, SetHtmlCenter, SetHtmlStyle, Util } from "../util/Util"
import { ElimDefine } from "./ElimDefine"
import { ElimGameMgr } from "./ElimGameMgr"
/**创角后的消消乐 配合买量需求 */
export class ElimMainView extends BaseView1 {
	feast_logic
	game_mgr: ElimGameMgr
	guild_model
	img1
	img2
	instruction_id
	item_list
	mini_game_model: MiniGameModel
	timer_dic
	ChessType = ElimDefine.ChessType
	/***游戏是否结束 */
	is_end = false
	time_fun
	/**是否正在计算分数中 */
	adding = false
	last_add = 0
	rank_time
	time_fun1 = {}
	score_list = []
	score_index = 0
	time_id_

	//倒计时
	endTimer_
	CancelTimer
	StartGameTime
	TimeFunc
	left_time
	close_time_

	mouse_down_fun
	mouse_up_fun
	mouse_move_fun
	is_play = false

	//游戏类型  类型0 普通消消乐  类型1 关卡回合制消消乐
	_game_type
	_call_back
	tween_list = []
	round_max_ = 0               //轮数
	round_num_ = 1
	is_change_round = false

	public constructor(parent?) {
		super()

		this.base_file = "elim"
		this.layout_file = "ElimMainView"
		this.layer_value = Enum_UILayer.FightingUp
		this.guild_model = GuildModel.GetInstance()
		this.feast_logic = this.guild_model.feast_logic
		this.destroy_imm = true

		this.mini_game_model = MiniGameModel.GetInstance()
		this.item_list = []
		this.preload_client_config = {
			"ConfigInstruction": false
		}
		this.preload_server_config = {
			"config_mini_game_kv": false
		}
		this.load_callback = () => {
			SetHtmlStyle(this._lb_gk,{c:"#663915",f:28,w:672,ww:false})
			SoundManager.GetInstance().PlaySceneSound(0.1, null, "new")

			this._img_eff_bg.visible = false
			this.ResizeBg()
			this.is_play = false


			//倒计时
			if (this._game_type == 1) {
				this.left_time = ClientConfig && ClientConfig["elim_single_round_time"] || 45
				this.round_max_ = ClientConfig && ClientConfig["elim_round"] || 2
			} else {
				this.left_time = ClientConfig && ClientConfig["elim_time"] || 60
			}
			this._score.text = this.left_time > 0 ? this.left_time : 0


			let img_str = ClientConfig && ClientConfig["elim_bg_url"] || "ui_ghdt_002"
			ResManager.GetInstance().SetOutsideImageSprite(this, this.bg3, GameResPath.GetIconOtherPath("elim", img_str))
			this.mini_game_model.is_open_client = true
			ResManager.GetInstance().LoadFont(this, "elim_fnt_2", this._score, undefined, false)
			ResManager.GetInstance().LoadFont(this, "elim_fnt_3", this._game_score, undefined, false)
			ResManager.GetInstance().LoadFont(this, "elim_fnt_1", this._count_down, undefined, false)

			this._lb_gk.visible = this._game_type == 1
			if (this._game_type == 1) {
				this.UpdateRound()
			}
			this.display_obj.centerX = this.display_obj.centerY = 0
			this.LoadSuccess()
			this.PreLoadEffectRes()
		}

		this.close_callback = () => {
			this.mini_game_model.is_open_client = false
			this.Remove()
		}


		this.CancelTimer = () => {
			if (this.endTimer_) {
				GlobalTimerQuest.CancelQuest(this.endTimer_)
				this.endTimer_ = null
			}
		}

		this.StartGameTime = () => {
			this.CancelTimer()
			this.endTimer_ =
				GlobalTimerQuest.AddPeriodQuest(() => {
					this.TimeFunc()
				}, 1)
			this.TimeFunc()
		}


		this.TimeFunc = () => {
			if (this.is_loaded) {

				this.left_time--
				this._score.text = this.left_time > 0 ? this.left_time : 0
				if (this.left_time <= 0) {

					this.CancelTimer()
					if (this._game_type == 1) {
						if (this.close_time_) {
							clearTimeout(this.close_time_)
							this.close_time_ = null
						}


						if (this.round_num_ >= this.round_max_) {
							if (!this.is_play) {
								this.is_play = true
								this._img_eff_bg.visible = true
								this.AddUIEffect("ui_renwuwancheng", this._box_eff, null, 2, false)
							}

							this.is_end = true
							MiniGameModel.GetInstance().StopMiniGame()

							this.close_time_ = setTimeout(() => {
								this.start_img.visible = false
								this.NewRound()
							}, 2500);
						} else {

							//本关完成
							this.is_change_round = true
							this._img_eff_bg.visible = true
							this.start_img.visible = true
							this.SetImgStart("ui_rwwc01", 500, 227)

							this.close_time_ = setTimeout(() => {
								this.start_img.visible = false
								this.NewRound()
							}, 2500);

						}
					} else {
						if (this.close_time_) {
							clearTimeout(this.close_time_)
							this.close_time_ = null
						}

						this.is_end = true
						MiniGameModel.GetInstance().StopMiniGame()
						if (!this.is_play) {
							this.is_play = true
							this._img_eff_bg.visible = true
							this.AddUIEffect("ui_renwuwancheng", this._box_eff, null, 2, false)
						}
						this.close_time_ = setTimeout(() => {
							this.Close()
							LoginManager.GetInstance().is_wait_video = false
							LoginManager.GetInstance().Fire(LoginStateEvent.OPEN_VIEW, "LoginLoadingView");
						}, 2500);
					}

				}

			}
		}

		this.mouse_move_fun = (e: Laya.Event) => {
			let pos = this.SetPos({ x: e.stageX, y: e.stageY })
			if (pos.x >= 0 && pos.x <= 600 && pos.y >= 0 && pos.y <= 600) {
				if (!this.is_end && !this.adding && !ElimGameMgr.GetInstance().is_eliming) {

					this.game_mgr.Fire(ElimDefine.ElimEvent.DRAG, pos)

				}
			}

		}
		this.mouse_down_fun = (e: Laya.Event) => {
			if(this.is_change_round)return
			let pos = this.SetPos({ x: e.stageX, y: e.stageY })
			if (pos.x >= 0 && pos.x <= 600 && pos.y >= 0 && pos.y <= 600) {

				if (this.mini_game_model.GetWaitState() && !this.is_end && !this.adding && !ElimGameMgr.GetInstance().is_eliming) {
					this.game_mgr.Fire(ElimDefine.ElimEvent.DRAG_BEGIN, pos)
					//Message.show("按下")
				}
			}

		}
		this.mouse_up_fun = (e: Laya.Event) => {
			let pos = this.SetPos({ x: e.stageX, y: e.stageY })
			if (pos.x >= 0 && pos.x <= 600 && pos.y >= 0 && pos.y <= 600) {
				if (!this.is_end) {
					this.game_mgr.Fire(ElimDefine.ElimEvent.DRAG_END, pos)
					//Message.show("抬起")
				}
			}
		}
	}

	public DeleteMe() {
		super.DeleteMe()
	}

	public Remove() {
		SoundManager.GetInstance().PlaySceneSound(0.1, null, "main")
		this.ClearTween()
		this.ClearUIEffect(this._box_eff)

		if (this.time_id_) {
			clearTimeout(this.time_id_)
			this.time_id_ = null
		}

		if (this.close_time_) {
			clearTimeout(this.close_time_)
			this.close_time_ = null
		}

		//清空对象池
		if (this.pool_boxs && this.pool_boxs.length > 0) {
			for (let i = 0; i < this.pool_boxs.length; i++) {
				this.ClearUIEffect(this.pool_boxs[i])
				this.pool_boxs[i].removeSelf()
				this.pool_boxs[i].destroy()
				this.pool_boxs[i] = null
			}
			this.pool_boxs = []
		}

		//this.ClearUIEffect(this.eff_board)
		Laya.stage.off(Laya.Event.MOUSE_DOWN, this, this.mouse_down_fun);
		Laya.stage.off(Laya.Event.MOUSE_MOVE, this, this.mouse_move_fun);
		Laya.stage.off(Laya.Event.MOUSE_UP, this, this.mouse_up_fun);
		if (this.time_fun1) {
			for (let key in this.time_fun1) {
				let time = this.time_fun1[key]
				GlobalTimerQuest.CancelQuest(time)
				delete this.time_fun1[key]
			}
			this.time_fun1 = {}
		}
		if (this.rank_time) {
			GlobalTimerQuest.CancelQuest(this.rank_time)
			this.rank_time = null
		}
		this.CancleTime()
		this.mini_game_model.SetBoardData(null)
		this.mini_game_model.ClearCountDownTimer()
		for (let i = 0; i < this.item_list.length; i++) {
			var item = this.item_list[i]
			item.DeleteMe()
			item = null
		}
		this.item_list = []

		// 结束游戏
		if (this.game_mgr) this.game_mgr.StopGame()
		this.ClearTimer()
		//this.mini_game_model.RemoveCountDownFunc(this)
	}

	public LoadSuccess() {
		ResManager.GetInstance().SetOutsideImageSprite(this, this.bg1, GameResPath.GetIconOtherPath("elim", "ui_ghxxl_bg_03"))
		ResManager.GetInstance().SetOutsideImageSprite(this, this.bg2, GameResPath.GetIconOtherPath("elim", "uihhyh_017"))
		this.game_mgr = ElimGameMgr.GetInstance()
		this._score.text = "0"
		this.InitEvent()
		this.InitGame()

		if (this._game_type == 1) {
			this.UpdateTime2()
		} else {
			this.UpdateTime()
		}

	}

	public SetPos(pos) {
		let point = this._panel_con_board.globalToLocal(new Laya.Point(pos.x, pos.y))
		return { x: point.x, y: point.y }
	}
	public CancleTime() {
		if (this.time_fun) {
			GlobalTimerQuest.CancelQuest(this.time_fun)
			this.time_fun = null
		}

	}

	public InitEvent() {

		this.BindEvent(GlobalEventSystem, EventName.STATE_RESET_SIZE, (width, height) => {
			this.CallLater(() => {
				if (this.use_delete_method) return
				this.ResizeBg()
			})
		})


		Laya.stage.on(Laya.Event.MOUSE_DOWN, this.con_board, this.mouse_down_fun)

		Laya.stage.on(Laya.Event.MOUSE_MOVE, this.con_board, this.mouse_move_fun)

		Laya.stage.on(Laya.Event.MOUSE_UP, this.con_board, this.mouse_up_fun)


		this.BindEvent(this.game_mgr, ElimDefine.ElimEvent.FIRE_BLOCK_EFFECT, (x, y, buff_type) => {

			//限制
			if (buff_type > 3) return

			let gap = 1.6 //不同格子间 特效间隔距离
			let max = 5.6   //ui界面 特效对正后，第一行第一列特效的位置

			//坐标转换
			let local_x = max - (gap * y)
			let local_y = max - (gap * x)


			//特效名称
			let eff_name
			let time_out = ElimGameMgr.GetInstance().GetEffPlayTime(buff_type)
			switch (buff_type) {
				case ElimDefine.ChessBuffType.Circle:
					eff_name = "effect_popgame_vortex_big"
					break;
				case ElimDefine.ChessBuffType.Row:
					eff_name = "effect_popgame_horizontal"
					break;
				case ElimDefine.ChessBuffType.Col:
					eff_name = "effect_popgame_vertical"
					break;
			}

			if (eff_name) {
				ElimGameMgr.GetInstance().cur_play_eff_num++
				//获取一个窗口
				let eff_box_temp = this.GetEffBox()
				this.ClearUIEffect(eff_box_temp)


				this.AddUIEffect(eff_name, eff_box_temp, { x: local_x, y: local_y }, 3, false, time_out, () => {
					if (ElimGameMgr.GetInstance().cur_play_eff_num > 0) ElimGameMgr.GetInstance().cur_play_eff_num--
					this.ReleaseBox(eff_box_temp)
				})

			}

		})
		// this.BindEvent(this.mini_game_model, MiniGameModel.GAME_OVER, () => {
		// 	this.is_end = true
		// 	MiniGameModel.GetInstance().StopMiniGame()
		// 	this.end_img.visible = true
		// 	this._game_score.text = "0"
		// })


		this.BindEvent(this.game_mgr, ElimDefine.ElimEvent.UPDATE_SCORE, (score?) => {
			if (this.is_end) {
				this.CancleTime()
				if (this.time_fun1) {
					for (let key in this.time_fun1) {
						let time = this.time_fun1[key]
						GlobalTimerQuest.CancelQuest(time)
						delete this.time_fun1[key]
					}
					this.time_fun1 = {}
				}
				this.add_num.text = ""
				return
			}
			if (score && this._game_score) {
				this.CancleTime()
				if (!this.adding) {
					this.adding = true
					this.add_num.visible = true
					this.last_add = (Number(score) - Number(this._game_score.text))
					// if (this.last_add > 0)
					// 	this.add_num.text = `+${this.last_add}`

				}
				else {
					//用分数score作为句柄 因为分数不会重复
					table.insert(this.score_list, score)
					this.time_fun1[this.score_index] = GlobalTimerQuest.AddDelayQuest(() => {
						if (this.use_delete_method) return
						this._game_score.text = String(this.last_add + Number(this._game_score.text))
						let s = this.score_list.splice(0, 1)
						this.last_add = (Number(s) - Number(this._game_score.text))
						// if (this.last_add > 0)
						// 	this.add_num.text = `+${this.last_add}`
					}, 0)//0.3 * (this.score_index + 1)
					this.score_index += 1
				}
				this.time_fun = GlobalTimerQuest.AddDelayQuest(() => {
					if (!this.use_delete_method) {
						this.score_index = 0
						this.score_list = []
						this.adding = false
						this.add_num.visible = false
						this._game_score.text = String(this.last_add + Number(this._game_score.text))
						this.last_add = 0
					}
				}, 0)
			}//(0.3 * this.score_index) + 1)
		})

		// //点击测试
		// Util.AddClickEvent(this._img_count, () => {
		// 	// this.NewRound()
		// 	this.Close()
		// }, this, true)
	}

	/**新一轮 */
	private NewRound() {
		if (this.round_num_ >= this.round_max_) {
			//结束
			this.Close()
			if(this._call_back){
				this._call_back()
			}
			return
		}
		this.ClearAllEff()
		this.ClearTween()
		this.CancelTimer()
		this.last_add = 0
		this._game_score.text = "0"
		this._score.text = "0"
		this.con_board.y = 0
		this._lb_gk.innerHTML = ``
		table.insert(this.tween_list, SYTweenLite.to(this, this.con_board, SYTweenLite.UiAnimationType.POSY, this.con_board.height * 1.5, 0.3, () => {

			//新的一轮
			ElimGameMgr.GetInstance().Fire(ElimDefine.ElimEvent.ELIM_RESET_BOARD)
			this.round_num_++
			this.UpdateRound()

			table.insert(this.tween_list, SYTweenLite.to(this, this.con_board, SYTweenLite.UiAnimationType.POSY, 0, 0.3, () => {
				this.UpdateTime2(() => {
					this.is_change_round =false
					this.left_time = ClientConfig && ClientConfig["elim_single_round_time"] || 45
					this.StartGameTime()
				})
			}))
		}))
	}

	/**更新轮数 */
	private UpdateRound() {
		let num_str = HtmlColorTxt(this.round_num_,Enum_ColorUtil_Dark.GREEN)
		this._lb_gk.innerHTML = `第${num_str}关`
		SetHtmlCenter(this._lb_gk,{x:0,w:672})
		ResManager.GetInstance().SetImageSprite(this,this._lb_round,"elim",`elim_num${this.round_num_}`)
		RefBoxChildsLayout(this._box_round, 10, null, true, "center")
	}


	/**清理缓动 */
	private ClearTween() {
		if (this.tween_list) {
			for (let i = 0; i < this.tween_list.length; i++) {
				SYTweenLite.Stop(this.tween_list[i])
			}
		}
		this.tween_list.length = 0
	}



	private pool_boxs: Array<Laya.Box> = []
	private pool_act_obj = {} //激活&&在使用的 会放到这个里面保存

	/**清理所有特效 */
	private ClearAllEff() {
		if (!this.pool_boxs) return
		for (let i = 0; i < this.pool_boxs.length; i++) {
			if (this.pool_act_obj[i]) {
				this.ClearUIEffect(this.pool_boxs[i])
				this.ReleaseBox(this.pool_boxs[i])
			}
		}
	}

	/***特效播放对象池 */
	private GetEffBox() {
		if (!this.display_obj) return null

		//获取没激活的box
		let eff_box: Laya.Box
		for (let i = 0; i < this.pool_boxs.length; i++) {
			if (this.pool_act_obj[i]) continue
			eff_box = this.pool_boxs[i]
			this.pool_act_obj[i] = 1
			eff_box.visible = true
			return eff_box
		}

		//新建
		if (!eff_box) {
			eff_box = new Laya.Box()
			this.display_obj.addChild(eff_box)
			eff_box.width = this._panel_con_board.width
			eff_box.height = this._panel_con_board.height
			eff_box.x = this._panel_con_board.x
			eff_box.y = this._panel_con_board.y
			eff_box.mouseEnabled = false

			let index = this.pool_boxs.length == 0 ? 0 : this.pool_boxs.length - 1
			eff_box.name = `eb_${index}`
			table.insert(this.pool_boxs, eff_box)
			this.pool_act_obj[index] = 1
		}

		eff_box.visible = true
		return eff_box
	}

	/**放回对象池 */
	private ReleaseBox(box: Laya.Box) {
		if (!box) return
		let box_name = box.name
		let strs = box_name.split('_')
		box.visible = false
		delete this.pool_act_obj[Number(strs[1])]
	}

	public GetResName(chess_type) {
		let sp_name = "uihhyh_006"
		if (chess_type == this.ChessType.Color1) {
			sp_name = "uihhyh_006"
		} else if (chess_type == this.ChessType.Color2) {
			sp_name = "uihhyh_007"
		} else if (chess_type == this.ChessType.Color3) {
			sp_name = "uihhyh_008"
		} else if (chess_type == this.ChessType.Color4) {
			sp_name = "uihhyh_009"
		} else if (chess_type == this.ChessType.Color5) {
			sp_name = "uihhyh_010"
		} else if (chess_type == this.ChessType.ColorStar) {
			sp_name = "uihhyh_006"
		}
		return sp_name
	}

	public InitGame() {
		ElimGameMgr.GetInstance().Init()
	}

	/**文字流程1 */
	public UpdateTime(value?) {
		if (this.mini_game_model.is_resume) {
			this._count_down.visible = false
			this.StartGame()
		} else {
			let count_down = value ? value : 7
			this._count_down.visible = false
			this._box_round.visible = false
			this.StartTimer(1, () => {
				count_down = count_down - 1
				switch (count_down) {
					case 6:
						this._img_eff_bg.visible = true
						this.start_img.visible = true
						this.SetImgStart("ui_rwwc", 512, 224)
						this._count_down.visible = false
						break;
					case 4:
					case 3:
					case 2:
						this._box_round.visible = false
						this._img_eff_bg.visible = true
						this.start_img.visible = false
						this._count_down.visible = true
						this._count_down.centerX = 0
						this._count_down.text = String(count_down - 1)
						break;
					case 1:
						this._img_eff_bg.visible = true
						this.SetImgStart("ui_rwks", 458, 120)
						this.start_img.visible = true
						this._count_down.visible = false
						break;
					case 0:
						this._img_eff_bg.visible = false
						this.start_img.visible = false
						this._count_down.visible = false
						this.ClearTimer()
						this.StartGame()
						break;
				}

			})
		}
		//}
	}

	/**文字流程2 */
	public UpdateTime2(call_back?) {
		if (this.mini_game_model.is_resume) {
			this._count_down.visible = false
			this.StartGame()
		} else {
			let count_down = call_back ? 7 : 9

			this._count_down.visible = false
			this._box_round.visible = false
			this.StartTimer(1, () => {
				count_down = count_down - 1
				switch (count_down) {
					case 8:
						this._img_eff_bg.visible = true
						this.start_img.visible = true
						this.SetImgStart("ui_rwwc", 512, 224)
						this._count_down.visible = false
						break;
					case 6:
						if (this._game_type == 1) {
							if (this.round_num_ == this.round_max_) {
								this.start_img.visible = true
								this.SetImgStart("ui_rwwc011", 419, 123)
								this._box_round.visible = false
							} else {
								this.start_img.visible = false
								this._box_round.visible = true
							}
						}
						break;
					case 4:
					case 3:
					case 2:
						this._box_round.visible = false
						this._img_eff_bg.visible = true
						this.start_img.visible = false
						this._count_down.visible = true
						this._count_down.centerX = 0
						this._count_down.text = String(count_down - 1)
						break;
					case 1:
						this._img_eff_bg.visible = true
						this.SetImgStart("ui_ghxxl_basal_02", 256, 117)
						this.start_img.visible = true
						this._count_down.visible = false
						break;
					case 0:
						this._img_eff_bg.visible = false
						this.start_img.visible = false
						this._count_down.visible = false

						if (this.round_num_==1) {
							this.UpdateRound()
							this.ClearTimer()
							this.StartGame()
						}

						if (call_back) {
							call_back()
						}
						break;
				}

			})
		}
		//}
	}

	private SetImgStart(name, width, height) {
		ResManager.GetInstance().SetImageSprite(this, this.start_img, "elim", name)
		this.start_img.width = width
		this.start_img.height = height
	}


	public StartTimer(type?, loop_func?) {

		if (!this.timer_dic) {
			this.timer_dic = {}
		}
		this.ClearTimer(type)
		this.timer_dic[type] = GlobalTimerQuest.AddPeriodQuest(loop_func, 1, -1)
		loop_func()
	}

	public ClearTimer(type?) {

		if (type) {
			if (this.timer_dic[type]) {
				GlobalTimerQuest.CancelQuest(this.timer_dic[type])
				delete this.timer_dic[type]
			}
		} else {
			if (this.timer_dic) {
				for (let _ in this.timer_dic) {
					let id = this.timer_dic[_]
					GlobalTimerQuest.CancelQuest(id)
					delete this.timer_dic[_]
				}
			}
			this.timer_dic = {}
		}
	}

	public StartGame() {

		this.game_mgr.Fire(ElimDefine.ElimEvent.START_SHOW, this.con_board)
		this.StartGameTime()
	}



	/**预加载所需要的资源 */
	public PreLoadEffectRes() {
		let rescores = []
		let name_list = ["effect_popgame_spark", "effect_popgame_vortex_big", "effect_popgame_horizontal", "effect_popgame_vertical", "ui_renwuwancheng"]
		for (let i = 0; i < name_list.length; i++) {
			table.insert(rescores, `${ResManager.GetInstance().cdn_res_path}resource/effect/objs/ui_effect/${name_list[i]}.lh`)
		}

		if (rescores && rescores.length > 0) {
			Laya.loader.create(rescores)
		}
	}


	private ResizeBg() {
		this._img_bg.width = Laya.stage.width
		this._img_bg.height = Laya.stage.height
	}

	public Open(...new_args) {
		this._game_type = new_args && new_args[0] || 0
		this._call_back = new_args && new_args[1] || null
		super.Open()
	}


_img_bg:Laya.Image
bg3:Laya.Image
bg1:Laya.Image
bg2:Laya.Image
_panel_con_board:Laya.Panel
con_board:Laya.Box
_img_count:Laya.Image
_score:Laya.Label
_lb_myscore:Laya.Label
_game_score:Laya.Label
add_num:Laya.Label
_lb_gk:Laya.HTMLDivElement
_img_eff_bg:Laya.Image
start_img:Laya.Image
_box_round:Laya.Box
_lb_round:Laya.Image
_count_down:Laya.Label
_box_eff:Laya.Box
public GetComponents() {
[
this._img_bg,
this.bg3,
this.bg1,
this.bg2,
this._panel_con_board,
this.con_board,
this._img_count,
this._score,
this._lb_myscore,
this._game_score,
this.add_num,
this._lb_gk,
this._img_eff_bg,
this.start_img,
this._box_round,
this._lb_round,
this._count_down,
this._box_eff,
]
 = this.GetChildrenByNames([

"_img_bg",
"bg3",
"bg1",
"bg2",
"_panel_con_board",
"con_board",
"_img_count",
"_score",
"_lb_myscore",
"_game_score",
"add_num",
"_lb_gk",
"_img_eff_bg",
"start_img",
"_box_round",
"_lb_round",
"_count_down",
"_box_eff",
])
}
}
 window["ElimMainView"]= ElimMainView