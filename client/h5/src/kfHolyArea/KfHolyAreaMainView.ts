import { BaseItem1 } from "../common/BaseItem1"
import { KfHolyAreaModel } from "../commonModel/KfHolyAreaModel"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { Util, HtmlColorTxt, SetSizeDeltaX, SetLocalPositionX, Trim, SetSizeDelta, SetAnchoredPosition, IsInTable } from "../util/Util"
import { Alert, Alert_Type } from "../alert/Alert"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"
import { InstructionType } from "../common/InstructionType"
import { table } from "../common/table"
import { ColorUtil, ColorType } from "../util/ColorUtil"
import { TimeUtil } from "../util/TimeUtil"
import { RoleManager } from "../commonModel/RoleManager"
import { ErlangParser } from "../util/ErlangParser"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { ShopIndex } from "../commonModel/ShopModel"
import { KfHolyAreaScoreRewardItem } from "./KfHolyAreaScoreRewardItem"
import { KfHolyAreaServerItem } from "./KfHolyAreaServerItem"
import { KfHolyAreaBuildItem } from "./KfHolyAreaBuildItem"
import { GlobalTimerQuest } from "../util/Util"
import { NineSkyModel } from "../commonModel/NineSkyModel"
import { kfStageModel } from "../commonModel/kfStageModel"

export class KfHolyAreaMainView extends BaseItem1 {
	_Scroller1: Laya.Panel
	Content: Laya.Box
	_img_map: Laya.Image
	_gp_path: Laya.Box
	_gp_build: Laya.Box
	_gp_shadow: Laya.Box
	_img_bg: Laya.Image
	_gp_camp: Laya.Box
	_Image1: Laya.Image
	_Label1: Laya.Label
	_gp_tips: Laya.Box
	_Image2: Laya.Image
	_Group1: Laya.HBox
	_lb_tips: Laya.Label
	_lb_tips0: Laya.Label
	_lb_refresh_time: Laya.HTMLDivElement
	_Scroller2: Laya.Panel
	Content1: Laya.Box
	_img_progress_bg: Laya.Image
	_img_progress: Laya.Image
	_img_lock: Laya.Image
	_Group2: Laya.HBox
	_lb_score: Laya.HTMLDivElement
	_img_tips: Laya.Image
	_gp_shop: Laya.Box
	_Image3: Laya.Image
	auction_gp: Laya.Box
	_Image4: Laya.Image
	effect_gp: Laya.Box
	_Group3: Laya.Box
	_Image5: Laya.Image
	auction_lb: Laya.Label
	_box_kf: Laya.Box
	_img_kf: Laya.Image
	_lb_kf: Laya.Label
	_img_bg2: Laya.Image
	_html_kf_mode: Laya.HTMLDivElement
	_img_lock_bg: Laya.Image
	_img_shop_red: Laya.Image
	_box_lock_bg_effect: Laya.Box

	Emp_gp_camp
	Emp_gp_shop
	Empauction_gp
	Scr_Scroller1
	Scr_Scroller2
	_gp_state_reward_con
	build_list
	kf_holy_seal_model
	map_cfg
	path_dic
	refresh_boss_time
	score_item_list
	server_list
	shadow_dic
	time_out
	timer

	btn_time_line: Laya.TimeLine

	public constructor(parent) {
		super(parent)

		this.base_file = "kfHolyArea"
		this.layout_file = "KfHolyAreaMainView"
		this.kf_holy_seal_model = KfHolyAreaModel.GetInstance()
		this.load_callback = () => {
			this._Scroller1.vScrollBar.visible = false
			this._Scroller1.hScrollBar.visible = false
			this._Scroller2.hScrollBar.visible = false
			this.LoadSuccess()
		}
	}

	public LoadSuccess() {
		this._html_kf_mode.style.color = "#663915"
		this._html_kf_mode.style.fontSize = 20
		this._html_kf_mode.style.wordWrap = false
		let info = NineSkyModel.GetInstance().GetStateInfo()
		if ((info && info.mod)) {
			this._html_kf_mode.innerHTML = `当前模式：<font color='#d15e00'>${(info.mod == 1 && "本" || info.mod)}服模式</font>`
		}


		//this.RegisterMask(this._gp_state_reward_con)

		ResManager.GetInstance().SetImageSpriteTrans(this, this._img_bg, GameResPath.GetIcon("kfHolyArea", "uikfsy_003"))
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_progress, GameResPath.GetIcon("kfHolyArea", "uikfsy_005"))
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_progress_bg, GameResPath.GetIcon("kfHolyArea", "uikfsy_004"))
		this.InitEvent()
		this.InitView()
		this.showBtnEff()
		this.kf_holy_seal_model.StartRefreshSceneData()
	}

	public InitEvent() {
		Util.AddClickEvent(this._box_kf, () => {
			kfStageModel.GetInstance().OpenKfStageView(kfStageModel.FUNC_284)
		}, this, true)

		this.BindVar(this.kf_holy_seal_model, "map_data", () => {
			this.UpdateMap()
			this.UpdateCampState()
		})

		this.BindVar(this.kf_holy_seal_model, "score_data", () => {
			this.UpdateScoreReward()
		})

		this.BindEvent(this.kf_holy_seal_model, KfHolyAreaModel.UPDATE_SCENE_DATA, (scene_id?) => {
			this.UpdateBuild(scene_id)
			// this.UpdatePath()
			// this.UpdateShadow()
		})

		this.BindEvent(GlobalEventSystem, ServerTimeModel.DAY_CHANGE, () => {
			this.UpdateModeTips()
		})

		this.BindEvent(this.kf_holy_seal_model, KfHolyAreaModel.BOSS_RELIVE, () => {
			this.UpdateBossRefreshTime()
		})

		this.BindEvent(this.kf_holy_seal_model, KfHolyAreaModel.UPDATE_REFRESH_BOSS_TIME, (end_time?) => {
			this.UpdateAuctionTime(end_time)
		})

		let score = this.kf_holy_seal_model.GetKeyValue("unlock_score")
		let cost = this.kf_holy_seal_model.GetKeyValue("unlock_stage_reward")
		cost = JSON.parse(cost)[0][2]
		Util.AddClickEvent(this._img_lock, () => {
			Alert.Show("是否消耗" + HtmlColorTxt(cost, ColorUtil.GetColorDark(ColorType.GREEN)) + "勾玉", Alert_Type.Three, () => {
				this.kf_holy_seal_model.Fire(KfHolyAreaModel.REQUEST_CCMD_EVENT, 28406)
			}
				, null, null, null, null, null, null, null, null, null, "解锁后续奖励？")
		}, this, true)


		Util.AddClickEvent(this._img_tips, () => {
			GlobalEventSystem.Fire(EventName.OPEN_INSTRUCTION_VIEW, InstructionType.KfHolyArea)
		}, this, true)

		Util.AddClickEvent(this._gp_shop, () => {
			GlobalEventSystem.Fire(EventName.OPEN_SHOP_MAIN_VIEW, ShopIndex.MedalShop, null, 104)
			this.kf_holy_seal_model.shop_red_status = false;
			this.checkShopRed()
		}, this, true)

		Util.AddClickEvent(this._lb_tips0, () => {
			GlobalEventSystem.Fire(EventName.OPEN_INSTRUCTION_VIEW, InstructionType.KfHolyArea1)
		}, this, true)

		Util.AddClickEvent(this.auction_gp, () => {
			this.ClearUIEffect(this.effect_gp)
			this.kf_holy_seal_model.Fire(KfHolyAreaModel.OPEN_VIEW, "KfHolyAreaAuctionIntroduceView")
		}, this, true)

		Util.AddClickEvent(this._gp_camp, () => {
			this.kf_holy_seal_model.Fire(KfHolyAreaModel.OPEN_VIEW, "KfHolyAreaCampView")
		}, this, true)

		//this.kf_holy_seal_model.Fire(KfHolyAreaModel.REQUEST_CCMD_EVENT, 28420)
	}

	public InitView() {

		this.UpdateMap()
		this.UpdateCampState()
		this.UpdateModeTips()
		this.UpdateScoreReward()
		this.UpdateBossRefreshTime()
		this.checkShopRed();
	}

	private checkShopRed(){
		let bol = this.kf_holy_seal_model.shop_red_status &&  this.kf_holy_seal_model.CheckKfHolyAreaShopRed()
		this._img_shop_red.visible = bol
	}

	public InitBronPos() {

		let server_list = this.server_list
		if (server_list) {
			let content_width = this.map_cfg.map_size[0]
			let window_width = this._Scroller1.width
			for (let _tmpi in server_list) {
				let item: KfHolyAreaServerItem = server_list[_tmpi]
				if ((item && item.vo && item.vo[0]) && item.vo[0].server_id == RoleManager.GetInstance().GetMainRoleVo().server_unique_id) {
					let scrollH
					let value = content_width - window_width
					let min = 0
					let max = item.display_obj.x + item.display_obj.width / 2 + window_width / 2 - window_width
					if (min < value && value < max)
						scrollH = value
					else if (value < min)
						scrollH = min
					else if (value > max)
						scrollH = max
					this._Scroller1.scrollTo(scrollH)
					break
				}
			}
		}
	}

	public UpdateScoreReward() {

		let score_data = this.kf_holy_seal_model.score_data
		if (score_data) {
			let score = score_data.score
			this._lb_score.style.fontSize = 20
			this._lb_score.style.color = "#ffffff"
			this._lb_score.style.wordWrap = false
			this._lb_score.innerHTML = "本周积分:" + HtmlColorTxt(score, "'#00fa64'")
			this._Group2.refresh()
			//LayoutRebuilder(this._Group2)
			let list = score_data.score_reward
			if (!this.score_item_list) {
				this.score_item_list = []
			}
			let lock_score = this.kf_holy_seal_model.GetKeyValue("unlock_score")
			let lock_index = null
			let find_lock_index = false
			let lock_x = 0
			let score_index = null
			let find_score_index = false
			let progress_width = 0
			let reward_index = undefined
			let reward_index1 = undefined
			for (let key in list) {

				let vo = list[key]
				if (vo.state == 1 && !reward_index && reward_index != 0)
					reward_index = key
				if (vo.state == 0 && !reward_index1 && reward_index1 != 0)
					reward_index1 = key
				let cfg = this.kf_holy_seal_model.GetScoreCfg(vo.score_cfg)
				let item = this.score_item_list[key]
				if (!item) {
					item = new KfHolyAreaScoreRewardItem(this.Content1)
					this.score_item_list[key] = item
					item.Load()
				}
				let x = 27 + (Number(key)) * (83 + 45)
				let y = 0
				item.SetData(vo, cfg, x, y)


				if (!find_lock_index && vo.score_cfg > Number(lock_score)) {
					find_lock_index = true
					lock_x = 27 + (Number(lock_index)) * (83 + 45) + 83 + 45 / 2 - 24
				} else if (!find_lock_index) {
					lock_index = key
				}
				if (!find_score_index && vo.score_cfg > score) {
					find_score_index = true
					if (score_index != null) {
						let last_score = list[score_index] && list[score_index].score_cfg
						if (last_score) {
							progress_width = 27 + (Number(score_index)) * (83 + 45) + 83 / 2
							progress_width = progress_width + (score - last_score) / (vo.score_cfg - last_score) * (83 + 45)
						}
					} else {
						progress_width = (score / vo.score_cfg) * (83 / 2 + 27)
					}
				} else if (!find_score_index) {
					score_index = key
				}
			}
			let i = 0
			if (reward_index || reward_index == 0)
				i = reward_index
			else if(reward_index1)
				i = reward_index1
			let value = (Number(i)) * (83 + 45)
			setTimeout(() => {
				if(this.use_delete_method) return
				this._Scroller2.hScrollBar.value = value
			}, 200)

			let bg_len = (list.length - 1) * (83 + 45) + 27 + 83 / 2
			SetSizeDeltaX(this._img_progress_bg, bg_len)
			SetSizeDeltaX(this.Content1, bg_len + 83 / 2)
			let bool = score_data.cost == 0
			this._img_lock.visible = bool
			this._img_lock_bg.visible = bool
			if (bool) {
				SetLocalPositionX(this._img_lock, lock_x + 22.5)
				SetLocalPositionX(this._img_lock_bg, lock_x - 3)
				// SetLocalPositionX(this._box_lock_bg_effect, lock_x - 3)
			}
			if (!find_score_index) {
				progress_width = 27 + (list.length - 1) * (83 + 45) + 83 / 2
			}
			if (bool && lock_x < progress_width) {
				progress_width = lock_x
			}
			SetSizeDeltaX(this._img_progress, progress_width)
		}
	}

	public UpdateBossRefreshTime() {

		let date = new Date(TimeUtil.getServerTime() * 1000)
		let now_hour = date.getHours()
		let now_minute = date.getMinutes()
		let refresh_cfg = this.kf_holy_seal_model.GetKeyValue("reborn_time")
		let time = null
		let min_time = null
		if (refresh_cfg) {
			refresh_cfg = JSON.parse(refresh_cfg)
			for (let key in refresh_cfg) {

				let vo = refresh_cfg[key]
				vo[0] = Number(vo[0])
				vo[1] = Number(vo[1])
				if (vo[0] == now_hour) {
					if (vo[1] > now_minute) {
						time = vo[0]
						if (vo[1] != 0) {
							time = time + ":" + vo[1]
						} else {
							time = time + ":00"
						}
						break
					}
				} else if (vo[0] > now_hour) {
					time = vo[0]
					if (vo[1] != 0) {
						time = time + ":" + vo[1]
					} else {
						time = time + ":00"
					}
					break
				}
				if ((!min_time || min_time[0] > vo[0]) || min_time[0] == vo[0] && min_time[1] > vo[1]) {
					min_time = vo
				}
			}
		}
		if (!time) {
			time = min_time[1] != 0 && min_time[0] + ":" + min_time[1] || min_time[0] + ":00"
		}
		this.refresh_boss_time = time
		this._lb_refresh_time.style.fontSize = 20
		//this._lb_refresh_time.style.valign = "center"
		this._lb_refresh_time.style.color = "#ffffff"
		this._lb_refresh_time.width = 250
		this._lb_refresh_time.innerHTML = "下一波首领刷新：" + HtmlColorTxt(time, "'#00fa64'")
	}

	public UpdateModeTips() {

		// let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
		// let data = this.kf_holy_seal_model.map_data
		// let san_type = data && data.san_type
		// if (san_type) {
		// 	let next_cfg = this.kf_holy_seal_model.GetTypeCfg(san_type + 1)
		// 	if (next_cfg) {
		// 		this._gp_tips.visible = true
		// 		this._lb_tips.text = "tips:" + (next_cfg.open_min - open_day) + "天后调整为"
		// 		this._lb_tips0.text = "[" + Trim(next_cfg.name) + "模式]"
		// 		this._lb_tips0.color = "#00fa64"//ColorUtil.TryParseHtmlString("#b3ff48")

		// 		// size=20

		// 		//LayoutRebuilder(this._Group1)
		// 	} else {
		// 		this._gp_tips.visible = false
		// 	}
		// } else {
		// 	this._gp_tips.visible = false
		// }
	}

	public UpdateMap() {

		let data = this.kf_holy_seal_model.map_data
		this.map_cfg = this.kf_holy_seal_model.GetMapCfg()
		if (!data || !this.map_cfg) {
			return
		}

		if (!this.server_list) {
			this.server_list = []
		}
		this._img_map.width = this.map_cfg.map_size[0]
		this._img_map.height = this.map_cfg.map_size[1]
		SetSizeDelta(this.Content, this._img_map.width, this._img_map.height)
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_map, GameResPath.GetIconJpg("kfHolyArea", this.map_cfg.map_source), true, (sp?) => {
			// if (sp && sp[0]) {
			// 	let sprite = sp[0]
			// 	SetSizeDelta(this.Content, sprite.rect.width, sprite.rect.height)
			// }


		})

		let server_list = this.map_cfg.server
		let server_data_dic = []
		for (let _tmpi in data.server_ids) {
			var vo = data.server_ids[_tmpi]
			if (!server_data_dic[vo.camp]) {
				server_data_dic[vo.camp] = []
			}
			table.insert(server_data_dic[vo.camp], vo)
		}
		let i = server_list.length
		if (i < this.server_list.length) {
			do {
				this.server_list[i].SetVisible(false)
				i = i + 1
			} while ((i < this.server_list.length)
			)
		}
		for (let key in server_list) {

			let vo = server_list[key]
			let item: KfHolyAreaServerItem = this.server_list[key]
			if (!item) {
				item = new KfHolyAreaServerItem(this._gp_build)
				item.Load()
				this.server_list[key] = item
			}
			//item.SetGameObjectName(vo.id)
			item.SetPosition(vo.pos[0], vo.pos[1])
			item.SetData(server_data_dic[vo.id] ? server_data_dic[vo.id] : [])
			item.SetVisible(true)
			item.ExcuteCallback(() => {
				setTimeout(() => {
					this.InitBronPos()
				}, 0.5)

			})
		}

		this.ResetBuild()

		let scene_dic = this.kf_holy_seal_model.scene_dic

		if (scene_dic) {
			for (let scene_id in scene_dic) {

				this.UpdateBuild(Number(scene_id))
			}
		}
	}

	public UpdateCampState() {

		if (this.kf_holy_seal_model.IsCampMode()) {
			this._gp_camp.visible = true
		} else {
			this._gp_camp.visible = false
		}
	}

	public ResetBuild() {

		if (this.build_list) {
			for (let key in this.build_list) {

				let obj = this.build_list[key]
				if (obj) {
					obj.DeleteMe()
				}
			}
			this.build_list = null
		}
	}

	public UpdateBuild(scene_id?) {

		let scmd = this.kf_holy_seal_model.GetSceneData(scene_id)
		if (!scmd) {
			return
		}
		if (!this.build_list) {
			this.build_list = []
		}
		let scene_cfgs = this.map_cfg.build
		let item = this.build_list[scene_id]
		if (!item) {
			item = new KfHolyAreaBuildItem(this._gp_build)
			item.Load()
			this.build_list[scene_id] = item
		}
		let scene_cfg = scene_cfgs[scene_id]
		if (scene_cfg) {
			//item.SetPosition(, )
		}
		//item.SetGameObjectName(scene_id)
		item.SetData(scmd, scmd.con_type, scene_cfg.pos[0], scene_cfg.pos[1])
		this.UpdatePath()
		this.UpdateShadow()
	}

	public UpdatePath() {

		let map_data = this.kf_holy_seal_model.map_data
		let server_ids = map_data && map_data.server_ids
		if (!server_ids) {
			return
		}
		let path_cfg = this.map_cfg.path
		let main_role_camp = this.kf_holy_seal_model.GetCampByServerId(RoleManager.GetInstance().GetMainRoleVo().server_unique_id)
		let born_point_list = null
		for (let key in server_ids) {

			let vo = server_ids[key]
			if (vo.camp == main_role_camp) {
				if (!born_point_list) {
					born_point_list = []
				}
				table.insert(born_point_list, vo.camp)
			}
		}
		let draw_dic = []
		let draw_path = (start?, tsvar_end?, start_is_server?) => {
			if (start_is_server == null) {
				start_is_server = false
			}
			let s = start_is_server ? "@" : "_"
			let key = start + s + tsvar_end
			if (!path_cfg[key]) {
				key = tsvar_end + s + start
				if (!path_cfg[key]) {
					return
				}
			}
			if (!this.path_dic) {
				this.path_dic = []
			}
			draw_dic[key] = true
			if (this.path_dic[key]) {
				return
			}
			let cfg = path_cfg[key]

			let img: Laya.Image = new Laya.Image()
			this._gp_path.addChild(img)
			img.mouseEnabled = false
			//img.pivot = Vector2(0,1)
			ResManager.GetInstance().SetOutsideImageSprite(this, img, GameResPath.GetIcon("kfHolyArea", cfg.source), true)
			SetAnchoredPosition(img, cfg.pos.x, cfg.pos.y)
			this.path_dic[key] = img
		}

		let list = []
		let GetCanAttackScene
		GetCanAttackScene = (scene_id?) => {
			scene_id = Number(scene_id)
			let scene_data = this.kf_holy_seal_model.GetSceneData(scene_id)
			if ((!IsInTable(scene_id, list) && scene_data) && (scene_data.bl_server == main_role_camp || scene_data.before_blserver == main_role_camp)) {
				table.insert(list, scene_id)
				let relation_cfg = this.kf_holy_seal_model.GetSceneRelationCfg(scene_id)
				let scene_list = ErlangParser.GetInstance().Parse(relation_cfg.scene_list)
				for (let key in scene_list) {

					let id = scene_list[key]
					draw_path(scene_id, id)
					GetCanAttackScene(id)
				}
			} else {
				return false
			}
		}

		if (born_point_list) {
			for (let _tmpi in born_point_list) {
				var point = born_point_list[_tmpi]
				let relation_cfg = this.kf_holy_seal_model.GetSceneRelationCfg(point)
				let scene_list = ErlangParser.GetInstance().Parse(relation_cfg.scene_list)
				for (let key in scene_list) {

					let scene_id = Number(scene_list[key])
					let scene_data = this.kf_holy_seal_model.GetSceneData(scene_id)
					draw_path(point, scene_id, true)
					if (scene_data && (scene_data.bl_server == main_role_camp || scene_data.before_blserver == main_role_camp)) {
						GetCanAttackScene(scene_id)
					}
				}
			}
		}
		if (this.path_dic) {
			for (let key in this.path_dic) {

				if (!draw_dic[key]) {
					//destroy(this.path_dic[key], true)
					this.path_dic[key] = null
				}
			}
		}
	}

	public UpdateShadow() {


		let shadow_cfg = this.map_cfg && this.map_cfg.shadow
		if (!shadow_cfg) {
			return
		}

		// if (!this.shadow_dic) {
		// 	this.shadow_dic = []
		// }
		this._gp_shadow.removeChildren()
		this.shadow_dic = []
		let now_shadow_dic = []

		let main_role_camp = this.kf_holy_seal_model.GetCampByServerId(RoleManager.GetInstance().GetMainRoleVo().server_unique_id)
		let server_ids = this.kf_holy_seal_model.map_data && this.kf_holy_seal_model.map_data.server_ids
		let server_list = this.map_cfg.server
		if (server_list) {
			for (let key in server_list) {

				let vo = server_list[key]
				let id = vo.id
				let data
				for (let key in server_ids) {
					let sever_data = server_ids[key]
					if(sever_data.camp == id){
						data = sever_data
						break
					}
				}
				if (data && data.camp == main_role_camp) {

				} else {
					let cfg = shadow_cfg[vo.id]
					if (cfg) {
						let obj: Laya.Image = this.shadow_dic[vo.id]
						if (!obj) {
							obj = new Laya.Image()
							this._gp_shadow.addChild(obj)
							this.shadow_dic[vo.id] = obj
						}
						let img = obj
						img.mouseEnabled = false
						//	img.transform.pivot = Vector2(0,1)
						ResManager.GetInstance().SetOutsideImageSprite(this, img, GameResPath.GetIcon("kfHolyArea", cfg.source), true)
						SetAnchoredPosition(obj, cfg.pos.x, -cfg.pos.y)
						now_shadow_dic[vo.id] = true
					}
				}
			}
		}
		let build_list = this.kf_holy_seal_model.build_data
		if (build_list) {
			for (let key in build_list) {

				let vo = build_list[key]
				if (!this.kf_holy_seal_model.IsCanAttackScene(vo.scene)) {
					let cfg = shadow_cfg[vo.scene]
					if (cfg) {
						let obj = this.shadow_dic[vo.scene]
						if (!obj) {
							obj = new Laya.Image()
							this.shadow_dic[vo.scene] = obj
						}
						let img: Laya.Image = obj
						this._gp_shadow.addChild(obj)
						img.mouseEnabled = false
						//img.transform.pivot = Vector2(0,1)
						ResManager.GetInstance().SetOutsideImageSprite(this, img, GameResPath.GetIcon("kfHolyArea", cfg.source), true)
						SetAnchoredPosition(obj, cfg.pos.x, cfg.pos.y)
						now_shadow_dic[vo.scene] = true
					}
				}
			}
		}

		if (this.shadow_dic) {
			for (let id in this.shadow_dic) {
				var obj = this.shadow_dic[id]
				if (!now_shadow_dic[id] && obj) {
					//destroy(obj,true)
					this.shadow_dic[id] = null
				}
			}
		}

	}

	public UpdateAuctionTime(end_time?) {

		let auction_produce_limit_time = this.kf_holy_seal_model.GetKeyValue("auction_produce_limit_time")
		let time = TimeUtil.getServerTime()
		let start_time = end_time - auction_produce_limit_time
		if (time > start_time && time < end_time) {
			// this.ClearUIEffect(this.effect_gp)
			// this.AddUIEffect("ui_function_glow", this.effect_gp, null, null, true)
			this.time_out = end_time - time
			this.UpdateTimer()
			this.StarTimer()
		} else {
			this.CancelTime()
			// this.ClearUIEffect(this.effect_gp)
			this.auction_lb.text = this.refresh_boss_time + "开启"
		}
	}

	public UpdateTimer() {

		if (this.time_out <= 0) {
			this.CancelTime()
			// this.ClearUIEffect(this.effect_gp)
			this.auction_lb.text = this.refresh_boss_time + "开启"
			return
		}
		this.time_out = this.time_out - 1
		let D = Math.floor(this.time_out / 60 / 60 / 24)
		let h = Math.floor(this.time_out / 60 / 60) % 24
		let m = Math.floor(this.time_out / 60) % 60
		let s = this.time_out % 60
		if (D >= 1) {
			this.auction_lb.text = D + "天" + h + "时"
		} else if (h >= 1) {
			this.auction_lb.text = h + "小时" + m + "分"
		} else if (m >= 1) {
			if (s >= 10) {
				this.auction_lb.text = m + "分" + s + "秒"
			} else {
				this.auction_lb.text = m + "分0" + s + "秒"
			}
		} else {
			if (s >= 10) {
				this.auction_lb.text = s + "秒"
			} else {
				this.auction_lb.text = "0" + s + "秒"
			}
		}
	}

	public StarTimer() {

		this.CancelTime()
		let loop_func = () => {
			this.UpdateTimer()
		}
		this.timer = GlobalTimerQuest.AddPeriodQuest(loop_func, 1, -1)
		loop_func()
	}

	public CancelTime() {

		if (this.timer) {
			GlobalTimerQuest.CancelQuest(this.timer)
			this.timer = null
		}
	}

	public DeleteMe() {

		if (this.score_item_list) {
			for (let _tmpi in this.score_item_list) {
				var obj = this.score_item_list[_tmpi]
				if (obj) {
					obj.DeleteMe()
				}
			}
			this.score_item_list = null
		}
		if (this.server_list) {
			for (let _tmpi in this.server_list) {
				var obj = this.server_list[_tmpi]
				if (obj) {
					obj.DeleteMe()
				}
			}
			this.server_list = null
		}
		if (this.build_list) {
			for (let key in this.build_list) {

				let obj = this.build_list[key]
				if (obj) {
					obj.DeleteMe()
				}
			}
			this.build_list = null
		}
		this.CancelTime()
		// this.ClearUIEffect(this.effect_gp)
		this.path_dic = null
		this.shadow_dic = null
		this.kf_holy_seal_model.CancelRefreshSceneData()
		if (this.btn_time_line) {
			this.btn_time_line.destroy()
			this.btn_time_line = undefined
			this._img_lock.rotation = 0
		}
		this.ClearUIEffect(this._box_lock_bg_effect)
		super.DeleteMe()
	}

	private showBtnEff(){
		// this._img_lock.rotation = 0
		// if (this.exp_ani_time_line) {
		// 	this.exp_ani_time_line.pause()
		// }
		if (!this.btn_time_line) {
			this.btn_time_line = new Laya.TimeLine()
			this.btn_time_line.addLabel("ShowExpAnimation1", 0).to(this._img_lock, { rotation: -20 }, 250, null, 1000)
			this.btn_time_line.addLabel("ShowExpAnimation2", 0).to(this._img_lock, { rotation: 20 }, 500, null, 0)
			this.btn_time_line.addLabel("ShowExpAnimation3", 0).to(this._img_lock, { rotation: 0 }, 250, null, 0)
			this.btn_time_line.play(0, true)
		}else {
			this.btn_time_line.resume()
		}
		this.AddUIEffect("ZengJia2", this._box_lock_bg_effect, { x: 0, y: 0 }, 25, true)
	}

	public GetComponents() {
		[
			this._Scroller1,
			this.Content,
			this._img_map,
			this._gp_path,
			this._gp_build,
			this._gp_shadow,
			this._img_bg,
			this._gp_camp,
			this._Image1,
			this._Label1,
			this._gp_tips,
			this._Image2,
			this._Group1,
			this._lb_tips,
			this._lb_tips0,
			this._lb_refresh_time,
			this._Scroller2,
			this.Content1,
			this._img_progress_bg,
			this._img_progress,
			this._img_lock,
			this._Group2,
			this._lb_score,
			this._img_tips,
			this._gp_shop,
			this._Image3,
			this.auction_gp,
			this._Image4,
			this.effect_gp,
			this._Group3,
			this._Image5,
			this.auction_lb,
			this._box_kf,
			this._img_kf,
			this._lb_kf,
			this._img_bg2,
			this._html_kf_mode,
			this._img_lock_bg,
			this._img_shop_red,
			this._box_lock_bg_effect
		]
			= this.GetChildrenByNames([

				"_Scroller1",
				"Content",
				"_img_map",
				"_gp_path",
				"_gp_build",
				"_gp_shadow",
				"_img_bg",
				"_gp_camp",
				"_Image1",
				"_Label1",
				"_gp_tips",
				"_Image2",
				"_Group1",
				"_lb_tips",
				"_lb_tips0",
				"_lb_refresh_time",
				"_Scroller2",
				"Content1",
				"_img_progress_bg",
				"_img_progress",
				"_img_lock",
				"_Group2",
				"_lb_score",
				"_img_tips",
				"_gp_shop",
				"_Image3",
				"auction_gp",
				"_Image4",
				"effect_gp",
				"_Group3",
				"_Image5",
				"auction_lb",
				"_box_kf",
				"_img_kf",
				"_lb_kf",
				"_img_bg2",
				"_html_kf_mode",
				"_img_lock_bg",
				"_img_shop_red",
				"_box_lock_bg_effect"
			])
	}
}
window["KfHolyAreaMainView"] = KfHolyAreaMainView