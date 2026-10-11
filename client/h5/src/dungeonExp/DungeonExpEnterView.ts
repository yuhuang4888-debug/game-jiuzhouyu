import { Alert, Alert_Type } from "../alert/Alert"
import { BaseItem1 } from "../common/BaseItem1"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { BaseDungeonModel, DUN_TYPE } from "../commonModel/BaseDungeonModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ShopEvent, ShopModel } from "../commonModel/ShopModel"
import { TaskModel, TaskTipType } from "../commonModel/TaskModel"
import { VipModel } from "../commonModel/VipModel"
import { PlatformManager } from "../PlatformManager"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { Enum_ColorUtil_Light } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, HtmlColorTxt, Util } from "../util/Util"
import { EquipmentItem } from "../common/EquipmentItem"
import { MaterialsTool } from "../common/MaterialsTool"
import { FirstRechargeModel } from "../commonModel/FirstRechargeModel"
import { GuardModel } from "../commonModel/GuardModel"
import { BagModel } from "../commonModel/BagModel"
import { SceneManager } from "../scene/SceneManager"

export class DungeonExpEnterView extends BaseItem1 {
	public static From_Enter_View = false

	enter_state
	merge_count
	check_box_select

	model: BaseDungeonModel
	role_mgr: RoleManager
	goods_model: GoodsModel
	shop_model: ShopModel
	vip_model: VipModel
	res_mgr: ResManager

	cur_data
	left_time
	time_id
	time_id1
	item
	is_opentip = false
	guard_model
	guard_item
	guard = 1
	again_goods_item

	public constructor(parent?) {
		super(parent)
		this.base_file = "dungeonExp"
		this.layout_file = "DungeonExpEnterView"

		this.preload_client_config = {
			"ConfigDungeonClient": false
		}

		this.enter_state = false
		this.merge_count = 1

		this.check_box_select = false

		this.model = BaseDungeonModel.GetInstance()
		this.role_mgr = RoleManager.GetInstance()
		this.goods_model = GoodsModel.GetInstance()
		this.shop_model = ShopModel.GetInstance()
		this.vip_model = VipModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()
		this.guard_model = GuardModel.GetInstance()

		this.load_callback = () => {
			if(PlatformManager.IsEyouEnPlatform()){
				this._box_check.pos(510,896)
				this._box_start.pos(535,933)
				this._img_red.pos(655,924)
				this._html_times.x=209
				this._img_add_times.x = 252
				this._box_add_effect.x = 271
				this._box_time_effect.centerX = -52
				this._img_point_icon.x = 315
				this._img_cost_icon.x = 177
				this._html_count.x = 217
				this._lb_start.fontSize = 18
			}
			this.LoadSuccess()
		}

		this.createChildren = () => {
			if (this["GetComponents"]) {
				this["GetComponents"]()
				this.is_get = true
			}
			this.story_obj_list = this.story_obj_list || {}
			this.story_obj_list[TaskTipType.FinDunType] = this.story_obj_list[TaskTipType.FinDunType] || {}
			this.story_obj_list[TaskTipType.FinDunType][DUN_TYPE.Exp] = [this._box_start]
			super.createChildren()
		}
	}

	LoadSuccess() {
		this._box_time_effect.width = 720
		this._box_time_effect.height = 1280
		this.AddUIEffect("ZengJia", this._box_time_effect, null, { x: 1, y: 1, z: 1 }, true)

		this._html_times.style.color = "#00fa64"
		this._html_times.style.fontSize = 22
		this._html_times.style.wordWrap = false

		this._html_count.style.color = "#00fa64"
		this._html_count.style.fontSize = 22
		this._html_count.style.wordWrap = false


		this.SetExpCheckBox(false)

		let main_role_level = this.role_mgr.GetMainRoleVo().level
		let bool = main_role_level >= 300 && true || false

		this._box_check.visible = bool
		// this.model.Fire(BaseDungeonModel.SCMD_REQUEST, 61020, DUN_TYPE.Exp)
		this.model.Fire(BaseDungeonModel.SCMD_REQUEST, 61045, BaseDungeonModel.EXP_DUN_ID)

		this.res_mgr.SetOutsideImageSprite(this, this._img_line, GameResPath.GetIcon("common2", "com_line_5"))
		this.res_mgr.SetOutsideImageSprite(this, this._img_line1, GameResPath.GetIcon("common2", "com_line_5"))
		this.res_mgr.SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("dungeonExp", "ui_copy_15"))

		let cfg = this.res_mgr.GetGameConfigFromCache(this, "ConfigDungeonClient", true)
		if (cfg) {
			this._html_tips.style.color = "#ffffff"
			this._html_tips.style.fontSize = 20
			this._html_tips.style.leading = 13
			this._html_tips.innerHTML = cfg["exp"]["tips"]
			if(PlatformManager.IsEyouPlatform()){
				this._html_tips.width = 430
				this._html_tips.style.leading = 5
			}else{
			this._html_tips.width = 450
			}
		}
		this.InitEvent()
		this.UpdateView()
		this.DoubleExp()
		this.UpdateGuard()
		this.UpdateAgain()
	}

	InitEvent() {
		let update_view = (dun_type?) => {
			if (dun_type == DUN_TYPE.Exp) {
				this.UpdateView()
			}
		}
		this.BindEvent(this.model, BaseDungeonModel.UPDATE_DUNGEON_TYPE_VIEW, update_view)

		let challenge_func = () => {
			if (this.cur_data) {
				let MainLineTaskVo = TaskModel.GetInstance().GetMainLineTaskVo()
				if (MainLineTaskVo && MainLineTaskVo.task_id == BaseDungeonModel.GUILD_TASK_ID) {
					if (MainLineTaskVo.has_finish == 1) {
						Message.show("已通关副本,请继续主线任务")
						return
					}
					let ticket_count = this.goods_model.GetTypeGoodsNum(BaseDungeonModel.EXP_TICKET_ID)
					if (ticket_count >= this.merge_count) {
						DungeonExpEnterView.From_Enter_View = true
						this.model.Fire(BaseDungeonModel.SCMD_REQUEST, 61001, BaseDungeonModel.GUILD_EXP_ID)
					} else {
						let need_goods_num = this.merge_count - ticket_count
						this.shop_model.Fire(ShopEvent.SHOP_OPEN_VIEW, "QuickBuyView", { type_id: BaseDungeonModel.EXP_TICKET_ID, goods_num: need_goods_num })
					}
					return
				}


				if (SceneManager.GetInstance().IsSuitBossScene()) {
					Message.show("当前场景不能进入")
					return
				}

				//先退出队伍
				if (!BaseDungeonModel.GetInstance().TryToEnterDungeon(this.cur_data.dun_id)) return


				if (this.enter_state) {
					let ticket_count = this.goods_model.GetTypeGoodsNum(BaseDungeonModel.EXP_TICKET_ID)

					if (ticket_count >= this.merge_count) {
						DungeonExpEnterView.From_Enter_View = true
						//GlobalEventSystem:Fire(EventName.OPEN_VIEW, "DungeonFightSceneView")
						if (FirstRechargeModel.GetInstance().IsCreatRoleFirstDayTwithExp() && !this.is_opentip && FirstRechargeModel.GetInstance().IsNoFirstRecharge()) {
							GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DoubleExpTipView")
							this.is_opentip = true
							return
						}
						this.model.Fire(BaseDungeonModel.SCMD_REQUEST, 61001, this.cur_data.dun_id)
					} else {
						let need_goods_num = this.merge_count - ticket_count
						this.shop_model.Fire(ShopEvent.SHOP_OPEN_VIEW, "QuickBuyView", { type_id: BaseDungeonModel.EXP_TICKET_ID, goods_num: need_goods_num })
					}
				} else {
					Message.show("进入冷却中")
				}
			}
		}
		Util.AddClickEvent(this._box_start, challenge_func, this, true)

		Util.AddClickEvent(this._img_add_times, () => {
			if (this.cur_data) {
				GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DungeonBuyTimeView", this.cur_data.dun_id)
			}
		}, this, true)

		Util.AddClickEvent(this._img_cost_icon, () => {
			UIToolTipMgr.GetInstance().AppendGoodsTips(BaseDungeonModel.EXP_TICKET_ID)
		}, this, true)

		Util.AddClickEvent(this._img_check_bg, () => {
			if (!this.check_box_select) {
				let str = "勾选后,本次副本将合并所有次数进入.\n是否确认勾选?"
				let content = Util.StrToHTML(str)
				Alert.Show(content, Alert_Type.Two, () => {
					this.SetExpCheckBox(true)
					this.model.Fire(BaseDungeonModel.SCMD_REQUEST, 61063, BaseDungeonModel.EXP_DUN_ID, 1, 0, 1, 0)
				}
				)
			} else {
				this.SetExpCheckBox(false)
				this.model.Fire(BaseDungeonModel.SCMD_REQUEST, 61063, BaseDungeonModel.EXP_DUN_ID, 1, 0, 0, 0)
			}
		}, this, false)

		Util.AddClickEvent(this.add, () => {
			MaterialsTool.GetInstance().materialsTips(37020002)
		}, true)

		Util.AddClickEvent(this.add2, () => {
			this.guard_model.Fire(GuardModel.OPEN_VIEW, 1)
		}, this, true)

		Util.AddClickEvent(this.gp_guard, () => {
			this.guard_model.Fire(GuardModel.OPEN_VIEW, this.guard)
		}, this, true)

		Util.AddClickEvent(this._box_again, () => {
			let goods_num = GoodsModel.GetInstance().GetBagGoodsNum(BaseDungeonModel.EXP_AGAIN_GOODS_ID)
			let goods_list = GoodsModel.GetInstance().GetTypeGoods(BaseDungeonModel.EXP_AGAIN_GOODS_ID)
			if(!goods_num){
				Message.show("物品不足")
				return
			}
			if (goods_num <= 1) {
				for(let vo of goods_list){
					this.goods_model.Fire(GoodsModel.USE_BAG_GOODS, vo.goods_id, 1)
					break
				}
				
			} else {
				for(let vo of goods_list){
					BagModel.GetInstance().Fire(BagModel.OPEN_VIEW, "BatchUseView", vo)
					break
				}
			}
		}, this, true)
		this.BindEvent(this.model, BaseDungeonModel.QUIT_DUNGEON_RETURN, (dun_id)=>{
			if(this.cur_data&&this.cur_data.dun_id==dun_id){
				challenge_func()
			}
		})

		this.BindEvent(this.model, BaseDungeonModel.UPDATE_MERGE_STAGE, (bool?, dun_id?) => {
			if (dun_id != BaseDungeonModel.EXP_DUN_ID) {
				return
			}
			BaseDungeonModel.GetInstance().SetMergeExpCount(bool)
			this.SetExpCheckBox(bool)
			if (!this.left_time || this.left_time == 0) {
				return
			}
			this.merge_count = (bool && bool != 0) && this.left_time || 1
			// this._lb_cost_pass.text = String(this.merge_count)
			let ticket_count = this.goods_model.GetTypeGoodsNum(BaseDungeonModel.EXP_TICKET_ID)
			let color = (ticket_count && ticket_count != 0 && ticket_count >= this.merge_count) && "'#00fa64'" || Enum_ColorUtil_Light.RED
			// this._lb_have_count.text = Util.StrToHTML("<font color=" + color + ">" + String(ticket_count) + "</font>")

			this._html_count.innerHTML = `${HtmlColorTxt(ticket_count, color)}/${this.merge_count}`
		})

		this.BindEvent(this.model, BaseDungeonModel.UPDATE_DUNGEON_TIME, (dun_id?) => {
			if (this.cur_data && this.cur_data.dun_id == dun_id) {
				this.UpdateView()
			}
		})

		this.BindEvent(this.model, BaseDungeonModel.UPDATE_ACTIVITY, (base_type?, sub_type?) => {
			if ((base_type && base_type == BaseDungeonModel.DOUBLE_ACTIVITY) && sub_type == 1 || !base_type) {
				this.UpdateView()
			}
		})

		this.BindEvent(this.goods_model, GoodsModel.UPDATE_GOODS_NUM, (goods_list?) => {
			if (this.use_delete_method) {
				return
			}
			for (let _tmpi in goods_list) {
				var info = goods_list[_tmpi]
				if (BaseDungeonModel.EXP_TICKET_ID == info.type_id) {
					let ticket_count = this.goods_model.GetTypeGoodsNum(BaseDungeonModel.EXP_TICKET_ID)
					let color = (ticket_count && ticket_count != 0 && ticket_count >= this.merge_count) && "'#00fa64'" || Enum_ColorUtil_Light.RED
					// this._lb_have_count.text = Util.StrToHTML("<font color='" + color + "'>" + String(ticket_count) + "</font>")
					this._html_count.innerHTML = `${HtmlColorTxt(ticket_count, color)}/${this.merge_count}`
					break
				} else if (BaseDungeonModel.EXP_AGAIN_GOODS_ID == info.type_id) {
					this.UpdateAgain()
					break
				}
			}
		})

		this.BindVar(this.model, "dun_cd_data", () => {
			this.UpdateDunCd()
		})

		this.model.Fire(BaseDungeonModel.SCMD_REQUEST, 61062, BaseDungeonModel.EXP_DUN_ID)

		this.BindEvent(this.guard_model, GuardModel.UPDATA_VIEW, () => {
			this.UpdateGuard()
		})
	}

	UpdateDunCd() {
		this.enter_state = true
		this.CancelCountDown()
		let next_time = this.model.GetDungeonCd(BaseDungeonModel.EXP_DUN_ID)
		let time = TimeUtil.getServerTime()
		if (next_time && next_time > time) {
			this.enter_state = false

			let OnTime = () => {
				let left_times = next_time - TimeUtil.getServerTime()
				if (left_times < 0) {
					this.CancelCountDown()
					this._lb_cd.text = ""
					this.model.Fire(BaseDungeonModel.SCMD_REQUEST, 61045, BaseDungeonModel.EXP_DUN_ID)
					return
				}
				this._lb_cd.text = TimeUtil.timeConvert(left_times, "mm:ss") + "后可进入"
			}
			this.time_id = GlobalTimerQuest.AddPeriodQuest(OnTime, 1)
			OnTime()
		}
	}

	CancelCountDown() {

		if (this.time_id) {
			GlobalTimerQuest.CancelQuest(this.time_id)
		}

	}

	UpdateView() {
		let data = this.model.GetDungeonInfo(DUN_TYPE.Exp)
		if (data && data.length > 0) {
			this.cur_data = data[0]
			let vip_card = this.vip_model.GetNobleCardState()
			let vip_flag = this.role_mgr.GetMainRoleVo().vip_flag
			if (vip_flag >= 1) {
				vip_card = 99
			}
			let vip_default_count = this.vip_model.GetVipPrivilegeValue(BaseDungeonModel.MODULE_ID, BaseDungeonModel.VIP_COUNT_PARAMETER + Number(DUN_TYPE.Exp), vip_card, vip_flag)
			let daily_default_count = Number(this.cur_data.count_cond) + vip_default_count
			let total_count = this.cur_data.vip_count + daily_default_count + this.cur_data.add_count
			let left_times = total_count - this.cur_data.daily_count
			let MainLineTaskVo = TaskModel.GetInstance().GetMainLineTaskVo()

			let bool_task = MainLineTaskVo && MainLineTaskVo.task_id == BaseDungeonModel.GUILD_TASK_ID && MainLineTaskVo.has_finish == 1
			this._img_red.visible = left_times > 0 && !bool_task
			this.left_time = left_times
			let color = (left_times && left_times != 0) && "'#00fa64'" || Enum_ColorUtil_Light.RED
			let desc = HtmlColorTxt(left_times, color) + "/" + total_count
			// this._lb_times.text = Util.StrToHTML(desc)
			this._html_times.innerHTML = `${HtmlColorTxt(left_times, color)}/${total_count}`
			let vip_max = this.vip_model.GetVipPrivilegeValue(BaseDungeonModel.MODULE_ID, BaseDungeonModel.VIP_PARAMETER + Number(DUN_TYPE.Exp), vip_card, vip_flag)
			if (vip_max != this.cur_data.vip_count) {
				//this.AddUIEffect("UI_2102", this._box_add_effect, null, null, false)
			} else {
				this.ClearUIEffect(this._box_add_effect)
			}
			let ticket_count = this.goods_model.GetTypeGoodsNum(BaseDungeonModel.EXP_TICKET_ID)
			let goods_vo = this.goods_model.GetGoodsBasicByTypeId(BaseDungeonModel.EXP_TICKET_ID)
			this.res_mgr.SetOutsideImageSprite(this, this._img_cost_icon, GameResPath.GetGoodsIconPath(goods_vo.goods_icon))
			this.merge_count = this.check_box_select && this.left_time || 1
			// this._lb_cost_pass.text = String(this.merge_count)
			color = (ticket_count && ticket_count >= this.merge_count) && "'#00fa64'" || Enum_ColorUtil_Light.RED
			// this._lb_have_count.text = Util.StrToHTML("<font color=" + color + ">" + String(ticket_count) + "</font>")
			this._html_count.innerHTML = `${HtmlColorTxt(ticket_count, color)}/${this.merge_count}`
			let point = this.model.getPoint(DUN_TYPE.Exp)
			this._img_point_icon.visible = point > 0
			if (this.time_id1) {
				clearTimeout(this.time_id1)
				this.time_id1 = null
			}
		}
	}

	SetExpCheckBox(bool?) {
		this.check_box_select = bool
		this._img_check.visible = bool
		// let str = bool && "com_ui_gx1" || "com_ui_gx"
		// this.res_mgr.SetImageSprite(this, this._img_check, "common", str)
	}
	public DoubleExp() {
		let goods_num = GoodsModel.GetInstance().GetBagGoodsNum(37020002)
		if (!this.item) {
			this.item = new EquipmentItem(this.gp_goods)
			this.item.Load()
			this.item.SetItemSize(85, 85)
		}
		this.item.ExcuteCallback(() => {
			this.item.SetData(37020002, goods_num, 0)
		}
		)
		this.mask_.visible = goods_num <= 0
	}

	private UpdateGuard() {
		let info = this.guard_model.info
		let guard = 1
		let active = false

		if (info) {
			for (let i in info) {
				let v = info[i]
				if (v.status == 1) {
					let lv = v.lv
					if (1 == lv) {
						guard = (guard == 3 && (3) || (lv))
						active = true
					} else if (3 == lv) {
						guard = (guard == 3 && (3) || (lv))
						active = true
					}
				}
			}
		}
		this.guard = guard
		let goods_id = 0
		if (guard == 1) {
			goods_id = this.guard_model.typeTogoods[1]
		} else if (guard == 3) {
			goods_id = this.guard_model.typeTogoods[3]
		}
		if (!this.guard_item) {
			this.guard_item = new EquipmentItem(this.gp_guard)
			this.guard_item.Load()
			this.guard_item.SetItemSize(85, 85)
		}
		this.guard_item.ExcuteCallback(() => {
			this.guard_item.SetData(goods_id)
			this.guard_item.SetShowTips(false)
		})
		this.mask2.visible = !active
		this.img_tag.visible = !active
	}

	public UpdateAgain() {
		let goods_num = GoodsModel.GetInstance().GetBagGoodsNum(BaseDungeonModel.EXP_AGAIN_GOODS_ID)
		if(goods_num > 0){
			this._box_again_con.visible = true
			if (!this.again_goods_item) {
				this.again_goods_item = new EquipmentItem(this._box_again_goods_con)
				this.again_goods_item.Load()
				this.again_goods_item.SetItemSize(85, 85)
			}
			this.again_goods_item.SetData(BaseDungeonModel.EXP_AGAIN_GOODS_ID, goods_num)
		}
		else{
			this._box_again_con.visible = false
		}
		
	}

	public DeleteMe() {
		this.CancelCountDown()
		this.ClearUIEffect(this._box_time_effect)
		if (this.time_id1) {
			clearTimeout(this.time_id1)
			this.time_id1 = null
		}
		if (this.item) {
			this.item.DeleteMe()
			this.item = null
		}
		if (this.guard_item) {
			this.guard_item.DeleteMe()
			this.guard_item = null
		}
		if (this.again_goods_item) {
			this.again_goods_item.DeleteMe()
			this.again_goods_item = null
		}
		this.ClearUIEffect(this._box_add_effect)
		super.DeleteMe()
	}


	_img_bg: Laya.Image
	_img_line: Laya.Image
	_img_line1: Laya.Image
	gp_goods: Laya.Box
	mask_: Laya.Box
	add: Laya.Image
	gp_guard: Laya.Box
	mask2: Laya.Box
	Image2: Laya.Image
	add2: Laya.Image
	img_tag: Laya.Image
	_img_point_icon: Laya.Image
	_lb_title: Laya.Label
	_html_tips: Laya.HTMLDivElement
	_lb_title2: Laya.Label
	_box_left_time: Laya.Box
	_lb_desc2: Laya.Label
	_html_times: Laya.HTMLDivElement
	_img_add_times: Laya.Image
	_box_add_effect: Laya.Box
	_box_time_effect: Laya.Box
	_box_cost: Laya.Box
	_lb_cost_desc: Laya.Label
	_img_cost_icon: Laya.Image
	_html_count: Laya.HTMLDivElement
	_box_start: Laya.Box
	_img_start: Laya.Image
	_lb_start: Laya.Label
	_img_red: Laya.Image
	_lb_cd: Laya.Label
	_box_check: Laya.Box
	_img_check: Laya.Image
	_img_check_bg: Laya.Image
	_lb_check_desc: Laya.Label
	_box_again_con: Laya.Box
	_img_again_bg: Laya.Image
	_img_again_title: Laya.Image
	_box_again_goods_con: Laya.Box
	_box_again: Laya.Box
	_img_again_bg2: Laya.Image
	_lb_again: Laya.Label
	_img_again_red: Laya.Image
	public GetComponents() {
		[
			this._img_bg,
			this._img_line,
			this._img_line1,
			this.gp_goods,
			this.mask_,
			this.add,
			this.gp_guard,
			this.mask2,
			this.Image2,
			this.add2,
			this.img_tag,
			this._img_point_icon,
			this._lb_title,
			this._html_tips,
			this._lb_title2,
			this._box_left_time,
			this._lb_desc2,
			this._html_times,
			this._img_add_times,
			this._box_add_effect,
			this._box_time_effect,
			this._box_cost,
			this._lb_cost_desc,
			this._img_cost_icon,
			this._html_count,
			this._box_start,
			this._img_start,
			this._lb_start,
			this._img_red,
			this._lb_cd,
			this._box_check,
			this._img_check,
			this._img_check_bg,
			this._lb_check_desc,
			this._box_again_con,
			this._img_again_bg,
			this._img_again_title,
			this._box_again_goods_con,
			this._box_again,
			this._img_again_bg2,
			this._lb_again,
			this._img_again_red,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_line",
				"_img_line1",
				"gp_goods",
				"mask_",
				"add",
				"gp_guard",
				"mask2",
				"Image2",
				"add2",
				"img_tag",
				"_img_point_icon",
				"_lb_title",
				"_html_tips",
				"_lb_title2",
				"_box_left_time",
				"_lb_desc2",
				"_html_times",
				"_img_add_times",
				"_box_add_effect",
				"_box_time_effect",
				"_box_cost",
				"_lb_cost_desc",
				"_img_cost_icon",
				"_html_count",
				"_box_start",
				"_img_start",
				"_lb_start",
				"_img_red",
				"_lb_cd",
				"_box_check",
				"_img_check",
				"_img_check_bg",
				"_lb_check_desc",
				"_box_again_con",
				"_img_again_bg",
				"_img_again_title",
				"_box_again_goods_con",
				"_box_again",
				"_img_again_bg2",
				"_lb_again",
				"_img_again_red",
			])
	}
}
window["DungeonExpEnterView"] = DungeonExpEnterView