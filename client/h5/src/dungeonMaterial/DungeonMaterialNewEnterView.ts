import { BaseItem1 } from "../common/BaseItem1"
import { BaseDungeonModel, DUN_TYPE } from "../commonModel/BaseDungeonModel"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { Config } from "../common/Config"
import { CommonManager } from "../common/CommonManager"
import { table } from "../common/table"
import { RoleManager } from "../commonModel/RoleManager"
import { DungeonMaterialNewEnterItem } from "./DungeonMaterialNewEnterItem"
import { ResManager } from "../common/ResManager"
import { GameResPath } from "../util/GameResPath"
import { HtmlColorTxt, SetHtmlStyle, Util } from "../util/Util"
import { OpenFun } from "../common/OpenFun"
import { WeekCardModel } from "../commonModel/WeekCardModel"
import { Alert, Alert_Type } from "../alert/Alert"
import { Message } from "../sysInfo/SysInfoController"
import { EventName } from "../common/EventName"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ShopModel } from "../commonModel/ShopModel"
import { TaskTipType } from "../commonModel/TaskModel"
import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { FirstRechargeModel } from "../commonModel/FirstRechargeModel"


export class DungeonMaterialNewEnterView extends BaseItem1 {
	InitEvent
	loop_item: LoopScrowViewMgr
	SetList
	resmgr: ResManager
	InitUI
	TryOneKeySweep
	TryOneKeyChallenge
	mat_new_list
	UpdateWeekCard
	public constructor(parent?) {
		super(parent)
		this.base_file = "dungeonMaterial"
		this.layout_file = "DungeonMaterialNewEnterView"

		let material_type_dic_
		let local_DUN_TYPE = DUN_TYPE
		let dungeon_model = BaseDungeonModel.GetInstance()
		let role_mgr = RoleManager.GetInstance()
		this.resmgr = ResManager.GetInstance()

		// this.preload_server_config = {
		// 	"config_num_by_vip": false,
		// 	"config_num_by_vip_info": false
		// }
		this.load_callback = () => {
			this.InitUI()
			this.SetList()
			this.InitEvent()
		}

		this.InitUI = () => {
			SetHtmlStyle(this._html_txt, { c: "#663915", f: 20, ww: false, w: 560 })
			this.UpdateWeekCard()
			this.resmgr.SetTexture(this, this._img_1, GameResPath.GetIconOtherPath("dungeonMaterial", `ui_copy_zyfb_01`))
			this.resmgr.SetTexture(this, this._img_2, GameResPath.GetIconOtherPath("dungeonMaterial", `ui_copy_zyfb_02`))
			this.AddUIEffect("ui_anniu_6", this._box_eff_1, { x: 0, y: 0 }, { x: 8.5, y: 13.3, z: 1 }, true)
			this.AddUIEffect("ui_anniu_6", this._box_eff_2, { x: 0, y: 0 }, { x: 8.5, y: 13.3, z: 1 }, true)
		}

		this.InitEvent = () => {

			//一键扫荡
			Util.AddClickEvent(this._gp_sweeping_all, () => {
				this.TryOneKeySweep(2)
			}, this, true)

			//一键挑战
			Util.AddClickEvent(this._gp_challenge_all, () => {
				this.TryOneKeyChallenge(1)
			}, this, true)

			Util.AddClickEvent(this._btn_go, () => {
				// OpenFun.OpenFunHandler(452, 53)
				if (!FirstRechargeModel.GetInstance().IsNoFirstRecharge())
					OpenFun.OpenFunHandler(191)
				else{
					Message.show("购买首充后开启")
				}
			}, this, true)


			Util.AddClickEvent(this._html_txt2, () => {
				//OpenFun.OpenFunHandler(452, 53)
				if (!FirstRechargeModel.GetInstance().IsNoFirstRecharge())
					OpenFun.OpenFunHandler(191)
				else{
					Message.show("购买首充后开启")
				}
			}, this, true)


			this.BindEvent(WeekCardModel.GetInstance(), WeekCardModel.UPDATE_VIEW, (scmd) => {
				this.UpdateWeekCard()
			})


			this.BindEvent(dungeon_model, BaseDungeonModel.NEW_DUNGEON_UPDATE_NUM, () => {
				this.SetList()
			})
		}

		this.TryOneKeySweep = () => {
			let week_card = WeekCardModel.GetInstance().GetWeekCardData()
			if(!FirstRechargeModel.GetInstance().IsNoFirstRecharge()){ //是否未首充
				if (!week_card || (week_card && week_card.is_activity == 0)) {
					let open_handler = ()=> {
						OpenFun.OpenFunHandler(191)
					}
					let str = `购买周卡可获得一键扫荡资格，是否前往购买`
					Alert.Show(str, Alert_Type.Two, open_handler, null, "前往", "取消")
					return
				}
			}else{
				let open_handler = ()=> {
					OpenFun.OpenFunHandler(21)
				}
				let str = `购买周卡可获得一键扫荡资格，周卡需要首充才能购买，是否前往首充`
				Alert.Show(str, Alert_Type.Two, open_handler, null, "前往", "取消")
				return
			}

			let dun_list = []
			for (let key in material_type_dic_) {
				dun_list.push(Number(key))
			}

			let all_cha_count = dungeon_model.GetAllDungeonChallengeTimes(dun_list, true, true)
			let all_sweep_count = dungeon_model.GetAllDungeonSweepTimes(dun_list)
			//全部都没有挑战 起码需要挑战并通关一个关卡
			if (all_cha_count == dun_list.length) {
				Message.show("需进行挑战后方可进行副本的扫荡")
				return
			}

			if (all_sweep_count <= 0) {
				Message.show(`当前无可扫荡副本`)
				return
			}



			let all_cost = dungeon_model.GetAllCanSweepDunCost(dun_list)
			let ok_func = () => {
				dungeon_model.RequestDungeonChallenge(2)
			}

			//本次扫荡需花费X绑玉，是否扫荡

			let do_func = () => {
				let shop_model = ShopModel.GetInstance()
				let arr = shop_model.MoneyIsEnough(2, all_cost)
				if (!arr[0]) {
					let arr2 = shop_model.MoneyIsEnough(1, arr[1])
					if (arr2[0]) {
						let str = "当前绑玉数量不足，是否消耗<font color='#639c12'>" + arr[1] + "勾玉</font>代替？"
						let content = Util.StrToHTML(str)
						Alert.Show(content, Alert_Type.Two, ok_func, null, "确定", "取消")
						return
					} else {
						Message.show(arr[3])
						return
					}
				} else {
					ok_func()
				}
			}



			if (all_cost <= 0) {
				do_func()
			} else {
				let str = "本次一键扫荡需花费<font color='#34a064'>" + all_cost + "绑玉</font><br>是否扫荡?"
				let content = Util.StrToHTML(str)
				Alert.Show(content, Alert_Type.Two, () => {
					do_func()
				}, null, "确定", "取消")
			}

		}


		this.TryOneKeyChallenge = () => {
			let week_card = WeekCardModel.GetInstance().GetWeekCardData()
			if (!week_card || (week_card && week_card.is_activity == 0)) {
				Message.show(`购买周卡可获得一键挑战资格`)
				return
			}


			let dun_list = []
			for (let key in material_type_dic_) {
				dun_list.push(Number(key))
			}

			let all_cha_count = dungeon_model.GetAllDungeonChallengeTimes(dun_list, false, true)
			let ch_dun_data = dungeon_model.GetOneLowerDiffDun(dun_list)
			if (ch_dun_data) {
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DungeonMaterialNewHeigherView", ch_dun_data, all_cha_count)
				return
			}


			if (all_cha_count == 0) {
				Message.show(`一键挑战次数已用完`)
				return
			}


			dungeon_model.RequestDungeonChallenge(1)

		}

		this.UpdateWeekCard = () => {
			let week_card = WeekCardModel.GetInstance().GetWeekCardData()
			if (!week_card || (week_card && week_card.is_activity == 0)) {
				this._html_txt2.text = `激活周卡获得加成`
			} else {
				this._html_txt2.text = `已激活周卡收益加成`
			}
			this._html_txt.innerHTML = `一键挑战，一键扫荡可获取&nbsp;${HtmlColorTxt("当前记录", '"#fe1a1a"')}&nbsp;的收益`


			//计算定位
			let off_set = 10
			let start = (720 - (this._html_txt.contextWidth + this._html_txt2.textField.textWidth + off_set)) / 2
			this._html_txt.x = start
			this._html_txt2.x = start + this._html_txt.contextWidth + off_set
		}

		this.SetList = () => {
			if (!material_type_dic_) {
				material_type_dic_ = {}
			}
			let cfg = Config.PRELOAD_SERVER_CONFIG.config_dungeon_ui_tab
			for (let key in cfg) {
				let v = cfg[key]
				if (v.group == BaseDungeonModel.GROUP_TYPE) {
					material_type_dic_[v.dun_type] = v.index
				}
			}


			//全部副本都显示出来
			let list = []
			if (material_type_dic_) {
				// let role_lv = role_mgr.GetMainRoleVo() && role_mgr.GetMainRoleVo().level
				for (let dun_type in material_type_dic_) {
					// let data = dungeon_model.GetDungeonInfo(dun_type)
					// let open = dungeon_model.DungeonOpenCondition(dun_type)
					// if (((open && data) && data[0]) && Number(data[0].level) <= role_lv) {
					// 	table.insert(list, { dun_type: dun_type, index: material_type_dic_[dun_type] })
					// }
					table.insert(list, { dun_type: dun_type, index: material_type_dic_[dun_type] })
				}
			}


			table.sort(list, (a?, b?) => {


				//任务引导副本》新副本 50》新难度 20》挑战次数10》扫荡次数 1》未开启
				let a_value = 0
				let a_arr = dungeon_model.GetCurDifficult(a.dun_type)

				let b_value = 0
				let b_arr = dungeon_model.GetCurDifficult(b.dun_type)


				//任务引导  当前引导的任务的放在最前面
				if (this.task_model.MainTaskIsNewMaterialDunTaskType(a.dun_type)) {
					a_value += 200
				}
				if (this.task_model.MainTaskIsNewMaterialDunTaskType(b.dun_type)) {
					b_value += 200
				}


				//副本状态
				if (a_arr[1] == BaseDungeonModel.TYPE_NEW_DUNGEON) {
					a_value += 50
				} else if (a_arr[1] == BaseDungeonModel.TYPE_NEW_DIFF_SHOW) {
					a_value += 20
				}

				if (b_arr[1] == BaseDungeonModel.TYPE_NEW_DUNGEON) {
					b_value += 50
				} else if (b_arr[1] == BaseDungeonModel.TYPE_NEW_DIFF_SHOW) {
					b_value += 20
				}


				if (a_value != b_value) {
					return b_value < a_value
				} else {
					let a_cha_count = dungeon_model.GetAllDungeonChallengeTimes([a.dun_type])
					let b_cha_count = dungeon_model.GetAllDungeonChallengeTimes([b.dun_type])
					if (a_cha_count != b_cha_count) {
						return b_cha_count < a_cha_count
					} else {
						let a_sweep_count = dungeon_model.GetAllDungeonSweepTimes([a.dun_type])
						let b_sweep_count = dungeon_model.GetAllDungeonSweepTimes([b.dun_type])
						if (a_sweep_count != b_sweep_count) {
							return b_sweep_count < a_sweep_count
						}
					}
				}


				//未解锁的排序
				let lock_a_v = 0
				if (a_arr[1] == BaseDungeonModel.TYPE_NEW_INLOCK) {
					lock_a_v = dungeon_model.GetNewDungeonOpenTaskId(a_arr[0].dun_id)
				}

				let lock_b_v = 0
				if (b_arr[1] == BaseDungeonModel.TYPE_NEW_INLOCK) {
					lock_b_v = dungeon_model.GetNewDungeonOpenTaskId(b_arr[0].dun_id)
				}

				if (lock_b_v != lock_a_v) {
					return lock_b_v > lock_a_v
				}


				//默认
				return a.index < b.index
			}
			)


			if (!this.loop_item) {
				this.loop_item = new LoopScrowViewMgr()
				this.loop_item.SetData(this._list_item, DungeonMaterialNewEnterItem, list, LoopScrCon.Horizontal)
			} else {
				this.loop_item.replaceAll(list)
			}




			//特效
			let dun_list = []
			for (let key in material_type_dic_) {
				dun_list.push(Number(key))
			}

			let week_card = WeekCardModel.GetInstance().GetWeekCardData()
			let is_active = !(!week_card || (week_card && week_card.is_activity == 0))

			let all_cha_count = dungeon_model.GetAllDungeonChallengeTimes(dun_list, false, true)
			this._box_eff_1.visible = all_cha_count > 0 && is_active

			let all_sweep_count = dungeon_model.GetAllDungeonSweepTimes(dun_list)
			this._box_eff_2.visible = all_sweep_count > 0 && is_active

		}

	}

	public DeleteMe() {
		if (this.loop_item) {
			this.loop_item.DeleteMe()
			this.loop_item = null
		}

		if (this._box_eff_1) {
			this.ClearUIEffect(this._box_eff_1)
		}
		if (this._box_eff_2) {
			this.ClearUIEffect(this._box_eff_2)
		}
		super.DeleteMe()
	}

	public IsMatTask() {

		if(!this.mat_new_list){
			this.mat_new_list = BaseDungeonModel.GetInstance().mat_new_list
		}
		//资源副本任务引导
		let boo = false
		for (let i = 0; i < this.mat_new_list.length; i++) {
			if (this.task_model.MainTaskIsNewMaterialDunTaskType(this.mat_new_list[i])) {
				boo = true
			}
		}
		return boo
	}
	public createChildren() {
		if (this["GetComponents"]) {
			this["GetComponents"]()
			this.is_get = true
		}

		if (this.IsMatTask()) {
			this.story_model.curr_view_story_step=1
			GlobalEventSystem.Fire(EventName.HIDE_FINGER, BaseWindowComponent.CURR_BASE_WINDOW_COMPONENT._story_bar2)
		}
		super.createChildren()
	}

_img_1:Laya.Image
_img_2:Laya.Image
_list_item:Laya.List
_html_txt:Laya.HTMLDivElement
_html_txt2:Laya.Label
_gp_challenge_all:Laya.Box
_Image2:Laya.Image
_Label2:Laya.Label
_box_eff_1:Laya.Box
_gp_sweeping_all:Laya.Box
_Image3:Laya.Image
_Label3:Laya.Label
_box_eff_2:Laya.Box
_btn_go:Laya.Box
_Image1:Laya.Image
_Label1:Laya.Label
public GetComponents() {
[
this._img_1,
this._img_2,
this._list_item,
this._html_txt,
this._html_txt2,
this._gp_challenge_all,
this._Image2,
this._Label2,
this._box_eff_1,
this._gp_sweeping_all,
this._Image3,
this._Label3,
this._box_eff_2,
this._btn_go,
this._Image1,
this._Label1,
]
 = this.GetChildrenByNames([

"_img_1",
"_img_2",
"_list_item",
"_html_txt",
"_html_txt2",
"_gp_challenge_all",
"_Image2",
"_Label2",
"_box_eff_1",
"_gp_sweeping_all",
"_Image3",
"_Label3",
"_box_eff_2",
"_btn_go",
"_Image1",
"_Label1",
])
}
}
 window["DungeonMaterialNewEnterView"]= DungeonMaterialNewEnterView