import { EventName } from "../common/EventName"
import { RoleManager } from "../commonModel/RoleManager"
import { AliveState } from "../sysInfo/MessageItem"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { EventDispatcher } from "../util/EventDispatcher"
import { GoodsModel } from "./GoodsModel"
import { ShopModel, ShopMoneyType } from "./ShopModel"

export let TopVipEvent = { OPEN_TOP_VIP_View: "OPEN_TOP_VIP_View", TOP_VIP_REQUEST_PROTO: "TOP_VIP_REQUEST_PROTO", UPDATE_TOP_VIP_MAIN_VIEW: "UPDATE_TOP_VIP_MAIN_VIEW", UPDATE_TOP_VIP_SKILL_VIEW: "UPDATE_TOP_VIP_SKILL_VIEW", UPDATE_TOP_VIP_SHOP_VIEW: "UPDATE_TOP_VIP_SHOP_VIEW", UPDATE_TOP_VIP_TASK_VIEW: "UPDATE_TOP_VIP_TASK_VIEW", UPDATE_TOP_VIP_PROMOTION_VIEW: "UPDATE_TOP_VIP_PROMOTION_VIEW", CHANGE_TOP_VIP_SKILL_RECEIVE_STAGE: "CHANGE_TOP_VIP_SKILL_RECEIVE_STAGE", CHANGE_TOP_VIP_Task_RECEIVE_STAGE: "CHANGE_TOP_VIP_Task_RECEIVE_STAGE", UPDATE_TOP_VIP_BASE_TAB: "UPDATE_TOP_VIP_BASE_TAB", ADD_SKILL_EFFECT: "ADD_SKILL_EFFECT", BUY_SUCCESS: "BUY_SUCCESS", CHANGE_RECEIVE_LABLE: "CHANGE_RECEIVE_LABLE" ,UPDATE_SHOP_RED: "UPDATE_SHOP_RED"}
export let TopVipShopType = 10
export let TopVipMoneyId = 36255042
const TopVipModuleId = 451
export class TopVipModel extends EventDispatcher {
	AddItemGoodsIdByKey
	CheckDayRewardRed
	CheckMainRoleCanBuySupremeVipLevel
	CheckOpenTopViSkill
	CheckSkillRed
	CheckSupremeVipIconRed
	CheckTaskRed
	CheckShopRed
	CleanShopItemGoodsIdByKeyList
	CleanSupremeVipCreateShopItemNum
	DeleteEffectPosIndex
	GetDayRewardRed
	GetShopItemGoodsIdByKey
	GetSkillTaskList
	GetSkillTaskRed
	GetShopRed
	GetSupremeVip
	GetSupremeVipTaskList
	GetTaskRed
	effect_pos_index
	my_top_vip_vo
	receive_list
	skill_task_vo
	supreme_vip_create_shop_item_key_id_before
	supreme_vip_shop_goods_list
	supreme_vip_task_vo
	static Instance
	public constructor() {
		super()


		this.supreme_vip_create_shop_item_key_id_before = 0;
		this.receive_list = []
		this.DeleteEffectPosIndex = () => {
			this.effect_pos_index = null
		}
		let role_mgr = RoleManager.GetInstance()
		let local_GlobalEventSystem = GlobalEventSystem
		let update_window_red_event = EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE
		let supreme_vip_ = null
		let supreme_vip_shp_item_key_goods_id_ = []
		let is_receive_day_reward_ = false
		let is_receive_task_ = false
		let is_receive_skill_task_ = false
		let is_can_buy = false
		this.GetSupremeVip = () => {
			supreme_vip_ = role_mgr.GetMainRoleVo().supreme_vip
			return supreme_vip_
		}

		this.CleanSupremeVipCreateShopItemNum = () => {
			this.supreme_vip_create_shop_item_key_id_before = 0
		}

		this.GetSkillTaskList = () => {
			let task_list = []
			if (this.skill_task_vo) {
				task_list = this.skill_task_vo.task_list
			}
			return task_list
		}

		this.CheckOpenTopViSkill = () => {
			if (this.my_top_vip_vo.supvip_type == 0) {
				return false
			} else {
				return true
			}
		}

		this.AddItemGoodsIdByKey = (key_id?, goods_id?) => {
			// [ts2lua]supreme_vip_shp_item_key_goods_id_下标访问可能不正确
			supreme_vip_shp_item_key_goods_id_[key_id] = goods_id
		}

		this.GetShopItemGoodsIdByKey = (key_id?) => {
			// [ts2lua]supreme_vip_shp_item_key_goods_id_下标访问可能不正确
			return supreme_vip_shp_item_key_goods_id_[key_id]
		}

		this.CleanShopItemGoodsIdByKeyList = () => {
			supreme_vip_shp_item_key_goods_id_ = []
		}

		this.GetDayRewardRed = () => {
			return is_receive_day_reward_
		}

		this.GetSkillTaskRed = () => {
			return is_receive_skill_task_
		}

		this.GetTaskRed = () => {
			return is_receive_task_
		}

		this.GetShopRed = () => {
			return is_can_buy
		}

		this.CheckDayRewardRed = (scmd?) => {
			let data_str = null
			for (let _tmpi in scmd.right_list) {
				var v = scmd.right_list[_tmpi]
				data_str = ErlangParser.GetInstance().Parse(v.data_str)[0]
				if (data_str == "1") {
					is_receive_day_reward_ = true
				} else {
					is_receive_day_reward_ = false
				}
				local_GlobalEventSystem.Fire(update_window_red_event, "TopVipBaseView", 0, is_receive_day_reward_)
			}
		}

		this.CheckSkillRed = (task_list?) => {
			let index = 1
			let model = this
			let is_vip = this.GetSupremeVip()
			for (let _tmpi in task_list) {
				var task = task_list[_tmpi]
				if ((task.is_finish == 1 && task.is_commit == 0) && is_vip && is_vip != 0) {
					is_receive_skill_task_ = true
					break
				}
				if (index == task_list.length) {
					is_receive_skill_task_ = false
				}
				index = index + 1
			}
			local_GlobalEventSystem.Fire(update_window_red_event, "TopVipBaseView", 1, is_receive_skill_task_)
		}

		this.CheckTaskRed = (task_list?) => {
			let index = 1
			let model = this
			let is_vip = this.GetSupremeVip()
			for (let _tmpi in task_list) {
				var task = task_list[_tmpi]
				if ((task.is_finish == 1 && task.is_commit == 0) && is_vip && is_vip != 0) {
					is_receive_task_ = true
					break
				}
				if (index == task_list.length) {
					is_receive_task_ = false
				}
				index = index + 1
			}
			local_GlobalEventSystem.Fire(update_window_red_event, "TopVipBaseView", 2, is_receive_task_)
		}

		this.CheckShopRed = () => {
			is_can_buy = false
			let enough, gap, my_have, alert_str;
			let goods_list = this.GetSupremeVipShopGoodsList()
			for (let key in goods_list) {
				[enough, gap, my_have, alert_str] = ShopModel.GetInstance().MoneyIsEnough(ShopMoneyType.TopVip, goods_list[key].price)
				if (enough && goods_list[key].sold_out < goods_list[key].quota_num) {
					is_can_buy = true
				}
			}
			local_GlobalEventSystem.Fire(update_window_red_event, "TopVipBaseView", 3, is_can_buy)
		}

		this.CheckSupremeVipIconRed = () => {
			let is_show = false
			if ((is_receive_day_reward_ || is_receive_skill_task_) || is_receive_task_ || is_can_buy) {
				is_show = true
			} else {
				is_show = false
			}
			local_GlobalEventSystem.Fire(EventName.REFRESH_ACTIVITY_ICON_RED_DOT, 451, is_show)
		}

		this.CheckMainRoleCanBuySupremeVipLevel = () => {
			let level = role_mgr.GetMainRoleVo().level
			if (level >= 160) {
				return true
			} else {
				return false
			}
		}

		this.GetSupremeVipTaskList = (config_supreme_vip_skill?, config_supreme_vip_skill_replace?) => {
			let task_list = []
			let index = 0
			let skill_vo = this.GetSkillTask()
			if (!skill_vo) { return }
			let stage = skill_vo.stage
			let sub_stage = skill_vo.sub_stage
			if (!role_mgr.GetMainRoleVo().supreme_vip) {
				return task_list
			}
			for (let key in config_supreme_vip_skill) {

				// [ts2lua]config_supreme_vip_skill下标访问可能不正确
				let cfg = config_supreme_vip_skill[key]
				if (cfg.stage > stage) {
					break
				}
				if ((cfg.stage < stage || sub_stage == 8) && cfg.sub_stage == 8) {
					let skill_list = ErlangParser.GetInstance().Parse(cfg.skill_list)
					for (let _tmpi in skill_list) {
						var id = skill_list[_tmpi]
						let skill_id = id[0]
						for (let skill in config_supreme_vip_skill_replace) {

							// [ts2lua]config_supreme_vip_skill_replace下标访问可能不正确
							let skill_cfg = config_supreme_vip_skill_replace[skill]
							if (skill_cfg.skill_id == skill_id) {
								// [ts2lua]task_list下标访问可能不正确
								task_list[skill_cfg.replace_skill_id] = skill_id
							}
						}
					}
				}
			}
			return task_list
		}


	}

	public static GetInstance() {

		if (!TopVipModel.Instance) {
			TopVipModel.Instance = new TopVipModel()
		}
		return TopVipModel.Instance
	}

	public SetMyTopVipVo(vo?) {

		this.my_top_vip_vo = vo
	}

	public GetMyTopVipVo() {

		return this.my_top_vip_vo
	}

	public SetSkillTask(vo?) {

		this.skill_task_vo = vo
	}
	public SetSkillTaskVo(task_id?, is_up?) {

		let task_list = this.skill_task_vo.task_list
		//if (is_up && is_up != 0 ) {
		//this.skill_task_vo.sub_stage = 0
		//}else{
		this.skill_task_vo.sub_stage = this.skill_task_vo.sub_stage + 1

		//}

		this.SetSkillEffectPosIndex(this.skill_task_vo.sub_stage - 1)
		for (let _ in task_list) {
			var v = task_list[_]
			if (v.task_id == task_id) {
				v.is_finish = 1
				v.is_commit = 1
			}
		}
	}

	public GetSkillTask() {

		return this.skill_task_vo
	}
	public SetReceiveTask(id?) {

		this.receive_list[id] = true
	}
	public GetReceiveTask(id?) {

		return this.receive_list[id]
	}

	public SetSupremeVipTaskVo(vo?) {

		this.supreme_vip_task_vo = vo
	}

	public GetSupremeVipTaskVo() {

		return this.supreme_vip_task_vo
	}

	public SetSkillEffectPosIndex(index?) {

		this.effect_pos_index = index
	}

	public GetSkillEffectPosIndex() {

		return this.effect_pos_index
	}

	public SetSupremeVipShopGoodsList(list?) {

		this.supreme_vip_shop_goods_list = list
	}

	public GetSupremeVipShopGoodsList() {

		return this.supreme_vip_shop_goods_list
	}

	public SetSupremeVipCreateShopItemKeyIdBefore(n?) {

		this.supreme_vip_create_shop_item_key_id_before = n
	}

	public GetSupremeVipCreateShopItemKeyIdBefore() {

		return this.supreme_vip_create_shop_item_key_id_before
	}
}
window["TopVipModel"] = TopVipModel