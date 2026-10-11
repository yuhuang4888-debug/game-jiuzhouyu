import { OpenMode } from "../common/BaseView1"
import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { EventName } from "../common/EventName"
import { RoleManager } from "../commonModel/RoleManager"
import { TopVipModel, TopVipEvent } from "../commonModel/TopVipModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import  "./TopVipMainView"
import  "./TopVipShopView"
import  "./TopVipSkillView"
import  "./TopVipTaskView"

export class TopVipBaseView extends BaseWindowComponent {
	InitMyEvent
	bg_list
	destroy_imm
	money_list
	open_mode
	tabStrList
	tab_loop_mgr
	tab_new_cond
	titleList
	viewClassList
	viewList
	window_load_back
	window_open_back

	public constructor() {
		super()


		//this.dependent_res = ["topVip"]
		this.destroy_imm = true
		this.open_mode = OpenMode.OpenToggle
		let model = TopVipModel.GetInstance()
		let local_GlobalEventSystem = GlobalEventSystem
		let UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE = EventName.UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE
		let local_Number = Number
		let vip_title = ["topVip.uifb_001_01", "topVip.uifb_001_03", "topVip.uifb_001_05", "topVip.uifb_001_07"]
		let title = ["topVip.uifb_001_01", "topVip.uifb_001_03", "topVip.uifb_001_05", "topVip.uifb_001_07"]
		this.tabStrList = [{ label: "至尊特权" }, { label: "至尊技能" }, { label: "特权任务" }, { label: "至尊商店" }]
		this.bg_list = ["uizz_028.jpg", "uizz_011.jpg","", "uizzsd_001.jpg"]
		this.viewClassList = ["TopVipMainView", "TopVipSkillView", "TopVipTaskView", "TopVipShopView"]
		let is_super_vip = RoleManager.GetInstance().GetMainRoleVo().supreme_vip
		if (is_super_vip && is_super_vip!= 0 ) {
			this.titleList = vip_title
		}else {
			this.titleList = title
		}
		this.money_list = [2, 1, 0]
		this.window_load_back = () => {
			this.InitMyEvent()
			local_GlobalEventSystem.Fire(UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "TopVipBaseView", 0, model.GetDayRewardRed())
			local_GlobalEventSystem.Fire(UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "TopVipBaseView", 1, model.GetSkillTaskRed())
			local_GlobalEventSystem.Fire(UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "TopVipBaseView", 2, model.GetTaskRed())
			local_GlobalEventSystem.Fire(UPDATE_BASE_WINDOWS_COMPONENT_RED_STATE, "TopVipBaseView", 3, model.GetShopRed())
		}

		this.window_open_back = () => { }

		this.tab_new_cond = () => {
			let is_super_vip = RoleManager.GetInstance().GetMainRoleVo().supreme_vip
			return is_super_vip && is_super_vip != 0

		}
		this.InitMyEvent = () => {
			this.BindEvent(model, TopVipEvent.UPDATE_TOP_VIP_BASE_TAB, () => {
				if (this._list_tab_con.numChildren == 4) { return }
				let is_super_vip = RoleManager.GetInstance().GetMainRoleVo().supreme_vip
				if (is_super_vip && is_super_vip != 0) {
					this.titleList = vip_title
				} else {
					this.titleList = title
				}
				let new_Viewlist = []
				if (this.tab_loop_mgr) {
					this.tab_loop_mgr.DeleteMe()
					this.tab_loop_mgr = null
				}
				// [ts2lua]this._list_tab_con.dataProvider下标访问可能不正确
				// [ts2lua]this._list_tab_con.dataProvider下标访问可能不正确
				// [ts2lua]lua中0和空字符串也是true，此处this._list_tab_con.dataProvider["source"]需要确认
				let count = this._list_tab_con.numChildren && this._list_tab_con.numChildren || 0
				if (count >= this.tabStrList.length) {
					for (let key in this.viewList) {

						// [ts2lua]this.viewList下标访问可能不正确
						let view = this.viewList[key]
						let add = 0
						for (let key2 in this.tab_new_cond) {

							// [ts2lua]this.tab_new_cond下标访问可能不正确
							let cond = this.tab_new_cond[key2]
							if (local_Number(key) > local_Number(key2)) {
								add = add + 1
							}
						}
						// [ts2lua]new_Viewlist下标访问可能不正确
						new_Viewlist[local_Number(key) - add] = view
					}
					this.viewList = new_Viewlist
					this.InitTabItem()
				} else {
					for (let key in this.viewList) {

						// [ts2lua]this.viewList下标访问可能不正确
						let view = this.viewList[key]
						let add = 0
						for (let key2 in this.tab_new_cond) {

							// [ts2lua]this.tab_new_cond下标访问可能不正确
							let cond = this.tab_new_cond[key2]
							if (local_Number(key) >= local_Number(key2)) {
								add = add + 1
							}
						}
						// [ts2lua]new_Viewlist下标访问可能不正确
						new_Viewlist[local_Number(key) + add] = view
					}
					this.viewList = new_Viewlist
					this.InitTabItem()
				}

				//let tab_list = []
				//for (let k in this.tabStrList) {

				//let cond = this.tab_new_cond[k] && this.tab_new_cond[k] ||() => {
				//return true
				//}
				//let can_open = cond()
				//if (can_open ) {
				//table.insert(tab_list,this.tabStrList[k])
				//}
				//}
				//this.tab_loop_mgr.replaceAll(tab_list)
			}
			)
		}


	}

}
window["TopVipBaseView"]=TopVipBaseView