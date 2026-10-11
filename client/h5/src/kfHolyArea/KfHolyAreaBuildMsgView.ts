import { BaseView1 } from "../common/BaseView1"
import { KfHolyAreaModel } from "../commonModel/KfHolyAreaModel"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { Util, HtmlColorTxt, GlobalTimerQuest, IsInTable } from "../util/Util"
import { LuaSoundManager } from "../common/SoundManager"
import { SceneManager } from "../scene/SceneManager"
import { Alert, Alert_Type } from "../alert/Alert"
import { KfHolyAreaDefine } from "./KfHolyAreaDefine"
import { table } from "../common/table"
import { ColorUtil, ColorType } from "../util/ColorUtil"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { KfHolyAreaBuildMsgBossItem } from "./KfHolyAreaBuildMsgBossItem"
import { KfHolyAreaBuildMsgScoreItem } from "./KfHolyAreaBuildMsgScoreItem"
import { TimeUtil } from "../util/TimeUtil"
import { RoleManager } from "../commonModel/RoleManager"
import { ErlangParser } from "../util/ErlangParser"
import { CommonRewardItem } from "../common/CommonRewardItem"
import { Message } from "../sysInfo/SysInfoController"
import { Config } from "../common/Config"
import { FriendModel, FriendEvent } from "../commonModel/FriendModel"

export class KfHolyAreaBuildMsgView extends BaseView1 {
	_Image1: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_img_close: Laya.Image
	_lb_scene_name: Laya.Label
	_Group1: Laya.HBox
	_Image4: Laya.Image
	_Image5: Laya.Image
	_Image6: Laya.Image
	_lb_tips: Laya.HTMLDivElement
	_Image7: Laya.Image
	_Label1: Laya.Label
	_Image8: Laya.Image
	Content: Laya.List
	_lb_mon: Laya.HTMLDivElement
	_Image9: Laya.Image
	gp_cur_boss: Laya.Box
	_img_boss_head: Laya.Image
	_lb_left_time: Laya.Label
	_lb_boss_name: Laya.Label
	Content11: Laya.List
	_Image10: Laya.Image
	Content1: Laya.List
	_lb_tips0: Laya.Label
	_lb_tips1: Laya.Label
	_gp_enter: Laya.Box
	_Image11: Laya.Image
	_Label2: Laya.Label
	_lb_none: Laya.Label
	_lb_Lead_person: Laya.HTMLDivElement
	boss_list
	boss_loop_mgr
	default_index
	model:KfHolyAreaModel
	need_refresh_data
	now_index
	record_list
	record_loop_mgr
	reward_list
	reward_loop_mgr
	scene_id

	public constructor() {
		super()
		this.base_file = "kfHolyArea"
		this.layout_file = "KfHolyAreaBuildMsgView"
		this.layer_value = Enum_UILayer.Activity
		this.show_open_movie = true
		this.destroy_imm = true
		this.change_scene_close = true
		this.click_bg_toClose = true
		this.use_background = true
		this.is_center = true

		this.model = KfHolyAreaModel.GetInstance()
		this.default_index = 0

		this.load_callback = () => {
			this._lb_tips.style.fontSize = 20
			//this._lb_refresh_time.style.valign = "center"
			this._lb_tips.style.color = "#663915"
			this._lb_tips.style.wordWrap = false

			this._lb_Lead_person.style.fontSize = 20
			//this._lb_refresh_time.style.valign = "center"
			this._lb_Lead_person.style.color = "#663915"
			this._lb_Lead_person.style.wordWrap = false
			this.LoadSuccess()
		}

		this.destroy_callback = () => {
			this.Remove()
		}
	}

	public Open(...new_args) {
		let parm = new_args
		if (parm) {
			this.scene_id = parm[0]

		}
		super.Open()

	}

	public LoadSuccess() {
		ResManager.GetInstance().SetImageSpriteTrans(this, this._Image7, GameResPath.GetIcon("kfHolyArea", "uikfsy_012"))
		this.InitEvent()
		this.InitView()
	}

	public InitEvent() {
		Util.AddClickEvent(this._img_close, () => {
			this.Close()
		}, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)


		Util.AddClickEvent(this._gp_enter, () => {
			if (!this.model.IsCanAttackScene(this.scene_id)) {
				let can_move_scene_list = this.model.GetCanMoveSceneList() 
				if(IsInTable(this.scene_id, can_move_scene_list)){
					Message.show("需要占领前置场景！")
				}
				else{
					Message.show("无法前往此场景！")
				}
				return
			}
			let data = this.boss_list && this.boss_list[this.now_index]
			if (!data) {
				return
			}

			let enter_func = () => {
				this.model.SetEnterInfo({ boss_id: data.bossid })
				this.model.Fire(KfHolyAreaModel.REQUEST_CCMD_EVENT, 28404, this.scene_id)
			}

			if (SceneManager.GetInstance().IsKfHolyAreaScene()) {
				let curr_scene_id = SceneManager.GetInstance().curr_scene_id
				if (curr_scene_id == this.scene_id) {
					this.model.Fire(KfHolyAreaModel.SCENE_EVENT.CHANGE_BOSS_TARGET, data.bossid)
					this.model.Fire(KfHolyAreaModel.CLOSE_VIEW, "KfHolyAreaBuildMsgView")
					this.model.Fire(KfHolyAreaModel.CLOSE_VIEW, "KfHolyAreaEnterView")
				} else {
					Alert.Show("是否离开当前场景?", Alert_Type.Two, () => {
						enter_func()
					}, null, "离开", "取消")
				}
			} else {
				if (SceneManager.GetInstance().IsNotChangeScene()) {
					Message.show("当前场景不能进入")
					return
				}
				if (!SceneManager.GetInstance().IsFieldScene()) {
					Alert.Show("是否离开当前场景?", Alert_Type.Two, () => {
						enter_func()
					}, null, "离开", "取消")
				} else {
					enter_func()
				}
			}

		}, this, true)

		this._lb_Lead_person.on(Laya.Event.LINK, this, this.Lead_person_click)

		if (this.need_refresh_data) {
			this.UpdateView()
			this.need_refresh_data = false
		}
	}

	private Lead_person_click(e?){
		if(e){
			let argsList = e.split(`@`);
			let server_id = Number(argsList[0]);
			let player_id = Number(argsList[1])
			FriendModel.GetInstance().requestPlayerMessage(player_id)
		}
		
	}

	public InitView() {
		let scene_data = this.model.GetSceneData(this.scene_id)
		if (scene_data) {
			let scene_info = SceneManager.GetInstance().GetSceneInfo(this.scene_id)
			this._lb_scene_name.text = scene_info.name + "概况"
			if (scene_data.bl_server > 0) {
				let color = KfHolyAreaDefine.Blserver_Color
				if (this.model.IsCampMode()) {
					this._lb_tips.innerHTML = "建筑归属:" + HtmlColorTxt(this.model.GetCampName(scene_data.bl_server) + "成功占领", color)
				} else {
					let server_list = this.model.GetCampServerList(scene_data.bl_server)
					let server_data = server_list[0]
					if (server_data) {
						this._lb_tips.innerHTML = "建筑归属:" + HtmlColorTxt("S" + server_data.server_num + "." + server_data.server_name + "成功占领", color)
					}
				}

			} else if (scene_data.before_blserver > 0) {
				let color = KfHolyAreaDefine.Before_Blserver_Color
				if (this.model.IsCampMode()) {
					this._lb_tips.innerHTML = "建筑归属:" + HtmlColorTxt("暂由" + this.model.GetCampName(scene_data.before_blserver) + "占领", color)
				} else {
					let server_list = this.model.GetCampServerList(scene_data.before_blserver)
					let server_data = server_list[0]
					if (server_data) {
						this._lb_tips.innerHTML = "建筑归属:" + HtmlColorTxt("暂由S" + server_data.server_num + "." + server_data.server_name + "占领", color)
					}
				}
			} else {
				let color = "'#fe1a1a'"//ColorUtil.GetColorDark(ColorType.RED)
				this._lb_tips.innerHTML = "建筑归属:" + HtmlColorTxt("暂无归属", color)
			}

			let list = []
			for (let key in scene_data.boss_info) {
				let info = scene_data.boss_info[key]
				if (info) {
					table.insert(list, info)
				}
			}

			this.boss_list = list
			if (this.boss_loop_mgr) {
				this.boss_loop_mgr.replaceAll(this.boss_list)
			} else {
				this.boss_loop_mgr = new LoopScrowViewMgr()
				this.boss_loop_mgr.SetData(this.Content11, KfHolyAreaBuildMsgBossItem, this.boss_list, LoopScrCon.Vertical, 5, (item?, is_click?) => {
					this.SwitchView(this.Content11.selectedIndex)
				})
			}

			let total_score = 0
			for (let _tmpi in scene_data.boss_info) {
				var vo = scene_data.boss_info[_tmpi]
				let type_cfg = this.model.GetMonsterTypeCfg(vo.mon_type, scene_data.con_type)
				if (type_cfg) {
					total_score = total_score + type_cfg.san_score
				}
			}

			let record_list = []
			for (let _tmpi in scene_data.server) {
				var vo = scene_data.server[_tmpi]
				table.insert(record_list, { vo: vo, total_score: total_score })
			}
			this.record_list = record_list
			if (this.record_loop_mgr) {
				this.record_loop_mgr.replaceAll(this.record_list)
			} else {
				this.record_loop_mgr = new LoopScrowViewMgr()
				this.record_loop_mgr.SetData(this.Content, KfHolyAreaBuildMsgScoreItem, this.record_list, LoopScrCon.Vertical, 1)
			}

			this._lb_none.visible = record_list.length == 0
			this.boss_loop_mgr.SetSelectIndex(this.now_index || this.default_index)
			let boss = 0
			let elite = 0
			let guard = 0
			let server_time = TimeUtil.getServerTime()
			for (let _tmpi in list) {
				var vo = list[_tmpi]
				if (!vo.reborn_time || server_time >= vo.reborn_time) {
					if (vo.mon_type == 6) {
						boss = boss + 1
					} else if (vo.mon_type == 5) {
						elite = elite + 1
					} else if (vo.mon_type == 4) {
						guard = guard + 1
					} else if (vo.mon_type == 3) {
						boss = boss + 1
					} else if (vo.mon_type == 2) {
						elite = elite + 1
					} else if (vo.mon_type == 1) {
						guard = guard + 1
					}
				}
			}
			let desc = "怪物列表:"
			desc = desc + "领主(" + HtmlColorTxt(boss, boss == 0 ? "'#fe1a1a'" : ColorUtil.GetColorDark(ColorType.GREEN)) + ") "
			desc = desc + "妖将(" + HtmlColorTxt(elite, elite == 0 ? "'#fe1a1a'" : ColorUtil.GetColorDark(ColorType.GREEN)) + ") "
			desc = desc + "守卫(" + HtmlColorTxt(guard, guard == 0 ? "'#fe1a1a'" : ColorUtil.GetColorDark(ColorType.GREEN)) + ") "
			this._lb_mon.style.fontSize = 22
			this._lb_mon.style.color = "#663915"
			this._lb_mon.style.wordWrap = false
			this._lb_mon.innerHTML = desc

			let bool = this.model.IsCanAttackScene(this.scene_id)
			// this._gp_enter.mouseEnabled = bool
			this._Image11.gray = !bool
			this._Label2.stroke = !bool ? 0 : 3
			this._lb_tips1.visible = false
		}
	}

	public SwitchView(index?) {
		if (this.now_index == index) {
			return
		}
		this.now_index = index
		this.UpdateView()
		this.updateCurSelectBoss()
	}

	time_id
	private updateCurSelectBoss() {
		let data = this.boss_list[this.now_index]
		let scene_info = this.model.GetSceneData(this.scene_id)
		this.ClearTimer()
		if (data && scene_info) {
			if (data.reborn_time > 0) {
				let loop_func = () => {
					if (data && data.reborn_time - TimeUtil.getServerTime() > 0) {
						this._lb_left_time.color = "#ff4f50"//ColorUtil.GetColorLight(ColorType.RED)
						this._lb_left_time.text = TimeUtil.convertTimeColor(data.reborn_time - TimeUtil.getServerTime())
					} else {
						this._lb_left_time.color = "#0a953e"//ColorUtil.GetColorLight(ColorType.GREEN)
						this._lb_left_time.text = "已复活"
						this.ClearTimer()
					}
				}
				this.time_id = GlobalTimerQuest.AddPeriodQuest(loop_func, 1, -1)
				loop_func()
			} else {
				this._lb_left_time.color = "#0a953e"//ColorUtil.GetColorLight(ColorType.GREEN)
				this._lb_left_time.text = "已复活"
			}

			let boss_info = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, data.bossid, false)
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_boss_head, GameResPath.GetMonsterHeadPath(boss_info.icon))
			this._lb_boss_name.text = boss_info.name
		}
	}

	public ClearTimer() {
		if (this.time_id) {
			GlobalTimerQuest.CancelQuest(this.time_id)
			this.time_id = null
		}
	}

	public UpdateView() {
		let data = this.boss_list[this.now_index]
		let scene_info = this.model.GetSceneData(this.scene_id)
		if (data && scene_info) {
			let drop_cfg = null
			let boss_cfg = this.model.GetMonsterCfg(data.bossid)
			if (boss_cfg) {
				let type_cfg = this.model.GetMonsterTypeCfg(boss_cfg.type, scene_info.con_type)
				let kill_score = type_cfg ? type_cfg.san_score : 0
				let score = type_cfg ? type_cfg.score : 0
				this._lb_tips0.text = "击杀可获" + kill_score + "势力值,归属服按照伤害占比分配" + score + "个人积分"
				let mode = this.model.map_data && this.model.map_data.san_type
				drop_cfg = this.model.GetBossRewardPeview(mode, scene_info.con_type, boss_cfg.type)
			}

			if (drop_cfg) {
				let list = []
				let career = RoleManager.GetInstance().GetMainRoleVo().career
				let reward = ErlangParser.GetInstance().Parse(drop_cfg.reward)
				if (reward) {
					for (let key in reward) {
						let data = reward[key]
						if (Number(data[0]) == career) {
							for (let _ = 0; _ < data[1].length; _++) {
								var vo = data[1][_]
								table.insert(list, {
									size: 85,
									vo: {
										style: Number(vo[0]),
										typeId: Number(vo[1]),
										count: Number(vo[2]),
									}
								})
							}
						}
					}
				}
				this.reward_list = list

			} else {
				this.reward_list = []
			}
			let _lead_person_name: string = ""
			if (scene_info.rank_list && scene_info.rank_list.length > 0) {
				let player_data = scene_info.rank_list[0];
				this._lb_Lead_person.visible = true
				_lead_person_name = scene_info.rank_list[0].role_name
				let _lead_person_str =  "<a href='" + player_data.server_id + "@" + player_data.player_id + "'>" + HtmlColorTxt(_lead_person_name, "'#d15e00'") + "</a>"
				FriendModel.GetInstance().Fire(FriendEvent.REQUEST_PLAYERMESSAGE_EVENT, player_data.server_id, player_data.player_id, 1)
				this._lb_Lead_person.innerHTML = "领军者：" + _lead_person_str
			} else {
				this._lb_Lead_person.visible = false
			}

		} else {
			this.reward_list = []

		}
		if (this.reward_loop_mgr) {
			this.reward_loop_mgr.replaceAll(this.reward_list)
		} else {
			this.reward_loop_mgr = new LoopScrowViewMgr()
			this.reward_loop_mgr.SetData(this.Content1, CommonRewardItem, this.reward_list, LoopScrCon.Vertical, 6)
		}

	}



	public Remove() {
		if (this.reward_loop_mgr) {
			this.reward_loop_mgr.DeleteMe()
			this.reward_loop_mgr = null
		}
		if (this.boss_loop_mgr) {
			this.boss_loop_mgr.DeleteMe()
			this.boss_loop_mgr = null
		}

		if (this.record_loop_mgr) {
			this.record_loop_mgr.DeleteMe()
			this.record_loop_mgr = null
		}
		this.now_index = null
		this._lb_Lead_person.off(Laya.Event.LINK, this, this.Lead_person_click)
		this.ClearTimer()
	}

	public GetComponents() {
		[
			this._Image1,
			this._Image2,
			this._Image3,
			this._img_close,
			this._lb_scene_name,
			this._Group1,
			this._Image4,
			this._Image5,
			this._Image6,
			this._lb_tips,
			this._Image7,
			this._Label1,
			this._Image8,
			this.Content,
			this._lb_mon,
			this._Image9,
			this.gp_cur_boss,
			this._img_boss_head,
			this._lb_left_time,
			this._lb_boss_name,
			this.Content11,
			this._Image10,
			this.Content1,
			this._lb_tips0,
			this._lb_tips1,
			this._gp_enter,
			this._Image11,
			this._Label2,
			this._lb_none,
			this._lb_Lead_person,
		]
			= this.GetChildrenByNames([
				"_Image1",
				"_Image2",
				"_Image3",
				"_img_close",
				"_lb_scene_name",
				"_Group1",
				"_Image4",
				"_Image5",
				"_Image6",
				"_lb_tips",
				"_Image7",
				"_Label1",
				"_Image8",
				"Content",
				"_lb_mon",
				"_Image9",
				"gp_cur_boss",
				"_img_boss_head",
				"_lb_left_time",
				"_lb_boss_name",
				"Content11",
				"_Image10",
				"Content1",
				"_lb_tips0",
				"_lb_tips1",
				"_gp_enter",
				"_Image11",
				"_Label2",
				"_lb_none",
				"_lb_Lead_person",
			])
	}
}
window["KfHolyAreaBuildMsgView"] = KfHolyAreaBuildMsgView