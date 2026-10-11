import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { BaseDungeonModel, DUN_TYPE } from "../commonModel/BaseDungeonModel"
import { TaskTipType } from "../commonModel/TaskModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, HtmlColorTxt, MakeListCenter, RefBoxVLayout, SetHtmlCenter, SetHtmlStyle, Util } from "../util/Util"
import { DungeonEnterView } from "./DungeonEnterView"
import { DungeonFailureStrengItem } from "./DungeonFailureStrengItem"
import { CommonManager } from "../common/CommonManager"
import { SoundManager } from "../common/SoundManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { table } from "../common/table"
import { CongratulationObtainItem } from "../common/CongratulationObtainItem"
import { CommonRewardItem } from "../common/CommonRewardItem"
import { FirstRechargeModel } from "../commonModel/FirstRechargeModel"
import { Enum_ColorUtil_Dark } from "../util/ColorUtil"
import { Config } from "../common/Config"
import { OpenFun } from "../common/OpenFun"
export class DungeonFailureView extends BaseView1 {


	CancelTime
	LoadSuccess
	Local_Open
	Remove
	StartTime
	item_loopmgr: LoopScrowViewMgr
	GetCfgIndex
	GetCfgIcon
	GetCfgDesc
	GetCfgBanner
	GetCfgTime
	GetCfg
	banner_cfg
	goods_items_list

	public static LeftTime = 5

	//失败类型
	public static TYPE_EXP = 1  //经验
	public static TYPE_BIND_MONEY = 2  //绑玉
	public static TYPE_EQUIP = 3  //装备
	public static TYPE_STRENG = 4  //通用
	public static TYPE_PET = 5     //伙伴

	public static TYPE_DEFAULT = "default" //公会
	public static TYPE_GUILD = "505@0" //公会


	public constructor() {
		super()

		this.base_file = "dungeonCommon"
		this.layout_file = "DungeonFailureView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.background_alpha = 1
		this.not_show_main_msg = true
		this.is_center = true
		this.destroy_imm = true
		this.click_bg_toClose = true
		let model = BaseDungeonModel.GetInstance()
		this.item_loopmgr = null
		this.banner_cfg = null

		let local_TimeUtil = TimeUtil
		let local_DUN_TYPE = DUN_TYPE
		let local_GlobalEventSystem = GlobalEventSystem
		let local_EventName = EventName
		let local_DungeonEnterView = DungeonEnterView
		let local_laya = Laya
		let dun_type_ = null
		let show_type = null
		let reward_list = null
		let item_list_ = null
		let time_id_ = null
		let time_func_ = null
		let voice



		this.load_callback = () => {
			this.GetCfgIndex()
			this.LoadSuccess()
		}

		this.preload_server_config = {
			"config_to_be_strong": false
		}

		this.preload_client_config = {
			"ConfigFailureShow": false
		}

		this.open_callback = () => {
			voice = CommonManager.GetInstance().PlayFightingVoice(1)
		}

		this.close_callback = () => {
			if (this.item_loopmgr) {
				this.item_loopmgr.DeleteMe()
				this.item_loopmgr = null
			}

			if (this.goods_items_list) {
				this.goods_items_list.DeleteMe()
				this.goods_items_list = null
			}
			this.Remove()
		}

		this.Local_Open = (...new_args) => {
			let param = new_args
			if (param.length > 0) {
				dun_type_ = param[0]
				show_type = param[1]
				reward_list = param[2]
			}
		}

		this.LoadSuccess = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("dungeonCommon", "com_up_bg2"))
			ResManager.GetInstance().SetImageSpriteTrans(this, this._img_title, GameResPath.GetIcon("dungeonCommon", "ui_copy_67"))
			SetHtmlStyle(this._html_desc, { c: "#663915", f: 22, w: this._box3.width, ww: false })
			SetHtmlStyle(this._html_desc2, { c: "#663915", f: 22, w: this._box3.width, ww: false })
			//ResManager.GetInstance().SetImageSpriteTrans(this, this._img_title_bg, GameResPath.GetIcon("dungeonCommon", "ui_copy_69"))


			Util.AddClickEvent(this.goBtn, () => {
				if (this.banner_cfg && this.banner_cfg.jump_id) {
					model.SetDunFailureJumpData(this.banner_cfg.jump_id)
					this.Close()
				}
			}, this, true)


			Util.AddClickEvent(this._btn_close, () => {
				this.Close()
			}, this, true)

			// let level = RoleManager.GetInstance().GetMainRoleVo().level
			// let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_to_be_strong", false) //Config.Tobestrong
			// if (!cfg) {
			// 	return
			// }
			// let list = []
			// let type = DungeonFailureView.TYPE_STRENG
			// if (dun_type_ == local_DUN_TYPE.Pet) {
			// 	type = DungeonFailureView.TYPE_PET
			// }
			// for (let key in cfg) {

			// 	let vo = cfg[key]
			// 	if (vo) {
			// 		if (vo.type == type && level >= vo.lv) {
			// 			// table.insert(list, vo)
			// 			list.push(vo)
			// 		}
			// 	}
			// }

			let idxs = this.GetCfgIndex()
			let list = this.GetCfgIcon(idxs)
			this.banner_cfg = null//this.GetCfgBanner([0])//this.GetCfgBanner(idxs)

			// list.sort((a, b) => {
			// 	return - a.star + b.star
			// })


			if (!this.item_loopmgr) {
				this.item_loopmgr = new LoopScrowViewMgr()
				this.item_loopmgr.SetData(this._gp_streng, DungeonFailureStrengItem, list, LoopScrCon.Horizontal, 1, (index) => {

				})
			} else {
				this.item_loopmgr.replaceAll(list)
			}

			MakeListCenter(this._gp_streng, 5, 142, 89)

			//文本描述
			SetHtmlStyle(this._desc, { c: "#663915", f: 20, w: 720, ww: true, a: "center", lh: 25 })
			this._desc.innerHTML = this.GetCfgDesc([0])// this.GetCfgDesc(idxs)
			SetHtmlCenter(this._desc, { x: 0, w: 720 })
			this._desc.height = this._desc.contextHeight

			//banner
			this._box2.visible = true
			this.goBtn.visible = this._img_activity.visible = false
			// if (this.banner_cfg) {
			// 	this._box2.visible = true
			// 	ResManager.GetInstance().SetOutsideImageSprite(this, this._img_activity, GameResPath.GetIconOtherPath("dungeonCommon", this.banner_cfg.id))
			// }
			//奖励
			//reward_list=[{ size: 87, vo: { style: 0, typeId: 16010001, count: 1 } },{ size: 87, vo: { style: 0, typeId: 16010001, count: 1 } }]
			this.goods_list.visible = false
			if (reward_list) {
				this.goods_list.visible = true
				if (!this.goods_items_list) {
					this.goods_items_list = new LoopScrowViewMgr()
					this.goods_items_list.SetData(this.goods_list, CommonRewardItem, reward_list, LoopScrCon.Horizontal, null)
				} else {
					this.goods_items_list.replaceAll(reward_list)
				}
				MakeListCenter(this.goods_list, 5, 56, 87)
			}

			//倒计时
			let count_time = this.GetCfgTime()
			let end_time = count_time + local_TimeUtil.getServerTime()
			if (count_time != 0) {
				let time_func = () => {
					let left_time = end_time - local_TimeUtil.getServerTime()
					this._confiim.changeText(`确认(${left_time})`)
					if (left_time < 0) {
						this.Close()
					}
				}
				this.StartTime(time_func)
			} else {
				this._confiim.changeText(`确认`)
			}

			//推荐战力
			this._box3.visible = false
			if (dun_type_ == local_DUN_TYPE.TOWER_LIMIT) {
				this._box3.visible = true
				let next_dun_id = model.GetNextChallenge(true)
				if (next_dun_id > 0) {
					let dun_cfg = Config.PRELOAD_SERVER_CONFIG.config_dungeon[next_dun_id]
					if (dun_cfg) {
						this._html_desc.innerHTML = `推荐战力：${HtmlColorTxt(dun_cfg.recommend_power, Enum_ColorUtil_Dark.GREEN)}`
						let fighting = RoleManager.GetInstance().GetMainRoleVo().fighting
						let color = fighting >= dun_cfg.recommend_power ? Enum_ColorUtil_Dark.GREEN : Enum_ColorUtil_Dark.RED
						this._html_desc2.innerHTML = `我的战力：${HtmlColorTxt(fighting + "", color)}`

						SetHtmlCenter(this._html_desc, { w: this._box3.width, x: 0 })
						SetHtmlCenter(this._html_desc2, { w: this._box3.width, x: 0 })
					}
				}
			}

			//音效
			voice = CommonManager.GetInstance().PlayFightingVoice(1)

			//布局
			let space = 10
			let offset = 10
			//RefBoxVLayout会重设box的高度
			if (!this._box2.visible) {
				offset += this._box2.height - 20
			}
			RefBoxVLayout(this._box_info1, space, true)
			this._img_bg.height = (this._box_info1.y - this._img_bg.y) + this._box_info1.height - (this._box2.height + this._btn_close.height + space) + offset
		}

		//获取显示的下标
		this.GetCfgIndex = () => {
			let list = []
			//if (!show_type) return [0]
			let cfg = this.GetCfg()
			if (cfg) {
				let level = RoleManager.GetInstance().GetMainRoleVo().level
				let open_day = ServerTimeModel.GetInstance().GetOpenServerDay()
				let conditon = cfg["conditon"]
				if (conditon.length == 0) return [0]
				for (let i = 0; i < conditon.length; i++) {
					let vo = conditon[i]
					let day_boo = false
					if (vo["day"]) {
						if (vo["day"].length == 2) {
							day_boo = open_day >= vo["day"][0] && open_day <= vo["day"][1]
						} else {
							day_boo = open_day >= vo["day"][0]
						}
					} else {
						day_boo = true
					}


					let lv_boo = false
					if (vo["lv"]) {
						if (vo["lv"].length == 2) {
							lv_boo = level >= vo["lv"][0] && level <= vo["lv"][1]
						} else {
							lv_boo = level >= vo["lv"][0]
						}
					} else {
						lv_boo = true
					}

					if (day_boo && lv_boo) {
						list.push(i)
					}

				}
				return list
			}
			return [0]
		}

		this.GetCfgIcon = (index_list) => {
			let list = []
			let obj = {} //过滤重复
			let cfg = this.GetCfg()
			if (cfg) {
				let arr = cfg["conditon_icon"]
				for (let i = 0; i < index_list.length; i++) {
					if (arr[index_list[i]]) {
						let icons = arr[index_list[i]]
						for (let p = 0; p < icons.length; p++) {
							if (!obj[icons[p]["id"]]) {
								table.insert(list, icons[p])
								obj[icons[p]["id"]] = 1
							}
						}
					}
				}
			}
			return list
		}

		this.GetCfgDesc = (index_list) => {
			let list = []
			let obj = {} //过滤重复
			let cfg = this.GetCfg()
			if (cfg) {
				let arr = cfg["conditon_streng"]
				for (let i = 0; i < index_list.length; i++) {
					if (arr[index_list[i]]) {
						let txts = arr[index_list[i]]
						if (!obj[txts]) {
							table.insert(list, txts)
							obj[txts] = 1
						}
					}
				}
			}
			return list.join('<br>')
		}

		this.GetCfgBanner = (index_list) => {
			let cfg = this.GetCfg()
			if (cfg) {
				let arr = cfg["conditon_banner"]
				for (let i = 0; i < index_list.length; i++) {
					let ban_data = arr[index_list[i]] || null
					if (ban_data) {
						//是否首充
						let is_frist = FirstRechargeModel.GetInstance().IsDoneFirstRecharge()
						//Vip等级
						let role_vip = RoleManager.GetInstance().mainRoleInfo.vip_flag

						if (is_frist) {
							if (role_vip >= 4) {
								ban_data = ban_data.scv4 || ban_data.msc
							} else {
								ban_data = ban_data.scmv4 || ban_data.msc
							}
						} else {
							ban_data = ban_data.msc
						}

						return ban_data
					}
				}
			}
			return null
		}

		this.GetCfgTime = () => {
			let cfg = this.GetCfg()
			if (cfg) {
				let time = cfg["count_time"]
				return time
			}
			return 0
		}

		this.GetCfg = () => {
			let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigFailureShow", true)
			if (!cfg) return null
			if (cfg[show_type]) {
				return cfg[show_type]
			} else {
				return cfg["default"]
			}
		}

		this.Remove = () => {

			if (voice) {
				SoundManager.GetInstance().StopSoundEffect(voice)
				voice = null
			}

			if (!this.close_imme) {
				switch (dun_type_) {
					case local_DUN_TYPE.Material_Mount:
					case local_DUN_TYPE.Material_Partner:
					case local_DUN_TYPE.Material_WING:
					case local_DUN_TYPE.Material_Copper:
					case local_DUN_TYPE.NEW_AMULET:
					case local_DUN_TYPE.NEW_MOUNT:
					case local_DUN_TYPE.NEW_WEAPON:
					case local_DUN_TYPE.NEW_BACK_ORNAMENT:
					case local_DUN_TYPE.NEW_WING:
						let MainLineTaskVo = this.task_model.GetMainLineTaskVo()
						if ((!MainLineTaskVo || MainLineTaskVo.task_tips_type != TaskTipType.FinDunType) || (MainLineTaskVo.id != local_DUN_TYPE.Material_Mount && MainLineTaskVo.id != local_DUN_TYPE.Material_Partner) && MainLineTaskVo.id != local_DUN_TYPE.Material_WING) {
							if (!model.streng_item_click) {
								local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DungeonEnterView", local_DungeonEnterView.Index.Material)
							}
						}
						break
					case local_DUN_TYPE.Partner:
						if (!model.streng_item_click) {
							GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DungeonEnterView", DungeonEnterView.Index.DungeonPartner)
						}
						break
					case local_DUN_TYPE.Partner:
						model.pet_Monster_instance_id_list = []
						model.select_pet_instance_id = null
						if (!model.streng_item_click) {
							//local_GlobalEventSystem:Fire(local_EventName.OPEN_VIEW, "DungeonEnterView", local_DungeonEnterView.Index.Pet)
						}
						break
					case local_DUN_TYPE.Rune:
						if (!model.streng_item_click) {
							setTimeout(() => {
								local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "DungeonEnterView", local_DungeonEnterView.Index.Rune)
							}, 1)
						}
						break
					case local_DUN_TYPE.Vip_Rerson_Boss:
						if (!model.streng_item_click) {
							// local_GlobalEventSystem.Fire(local_EventName.OPEN_VIEW, "BossEnterView", BossModel.Index.Vip_Person_Boss)
						}
						break
					case local_DUN_TYPE.TOWER_LIMIT:
						OpenFun.OpenFunHandler(237)
						break

				}
			}

			this.CancelTime()

			// if (this._gp_activity_effect ) {
			// 	Laya.Tween.removeTweens(this._gp_activity_effect)
			// 	Laya.Tween.removeTweens(this._gp_failure_effect)
			// }

			if (item_list_) {
				for (let _tmpi in item_list_) {
					var obj = item_list_[_tmpi]
					obj.DeleteMe()
				}
				item_list_ = null
			}

			if (SceneManager.GetInstance().IsDungeonScene() && model.IsInDunTypeScene(dun_type_)) {
				model.Fire(BaseDungeonModel.SCMD_REQUEST, 61002)
			}
			model.SetDungeonResultInfo(null)
			model.SetDungeonMonsterDeadPos(null)
			model.streng_item_click = false
			local_GlobalEventSystem.Fire(local_EventName.CLOSE_DUNGEON_RESULT_VIEW)
		}

		this.StartTime = (time_func?) => {
			this.CancelTime()
			// time_func_ = time_func
			// time_id_ = local_laya. new Timer(1000, 0)
			// time_id_.addEventListener(Laya.TimerEvent.TIMER, time_func_, this)
			// time_id_.start()

			time_id_ = GlobalTimerQuest.AddPeriodQuest(time_func, 1, -1)
			time_func()
		}

		this.CancelTime = () => {
			if (time_id_) {
				GlobalTimerQuest.CancelQuest(time_id_)
				time_id_ = null
			}
		}
	}

	public Open(...new_args) {
		this.Local_Open(...new_args)
		super.Open()
	}



	_img_bg: Laya.Image
	_img_title: Laya.Image
	_box_info1: Laya.Box
	goods_list: Laya.List
	_box3: Laya.Box
	_html_desc: Laya.HTMLDivElement
	_html_desc2: Laya.HTMLDivElement
	_box1: Laya.Box
	_img_title_bg: Laya.Image
	_img_title3: Laya.Image
	_img_title2: Laya.Image
	_gp_streng: Laya.List
	_desc: Laya.HTMLDivElement
	_box2: Laya.Box
	_img_activity: Laya.Image
	goBtn: Laya.Box
	_btn_close: Laya.Box
	_confiim: Laya.Label
	public GetComponents() {
		[
			this._img_bg,
			this._img_title,
			this._box_info1,
			this.goods_list,
			this._box3,
			this._html_desc,
			this._html_desc2,
			this._box1,
			this._img_title_bg,
			this._img_title3,
			this._img_title2,
			this._gp_streng,
			this._desc,
			this._box2,
			this._img_activity,
			this.goBtn,
			this._btn_close,
			this._confiim,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_title",
				"_box_info1",
				"goods_list",
				"_box3",
				"_html_desc",
				"_html_desc2",
				"_box1",
				"_img_title_bg",
				"_img_title3",
				"_img_title2",
				"_gp_streng",
				"_desc",
				"_box2",
				"_img_activity",
				"goBtn",
				"_btn_close",
				"_confiim",
			])
	}
}
window["DungeonFailureView"] = DungeonFailureView