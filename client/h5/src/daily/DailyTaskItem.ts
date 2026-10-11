import { Alert, Alert_Type } from "../alert/Alert";
import { BaseItem1 } from "../common/BaseItem1";
import { BaseItemRenderer } from "../common/BaseItemRenderer";
import { OpenFun } from "../common/OpenFun";
import { ResManager } from "../common/ResManager";
import { DailyModel } from "../commonModel/DailyModel";
import { GuildModel } from "../commonModel/GuildModel";
import { TaskType, TaskModel } from "../commonModel/TaskModel";
import { RoleManager } from "../commonModel/RoleManager";
import { GameResPath } from "../util/GameResPath";
import { Util, Trim } from "../util/Util";
import { DailyEvent } from "./DailyEvent";
import { PlatformManager } from "../PlatformManager";

export class DailyTaskItem extends BaseItemRenderer {
	public WIDTH = 344
	public HEIGT = 120

	cfg_finish = false
	model: DailyModel
	public constructor() {
		super()

		this.cfg_finish = false;
		this.base_file = "daily"
		this.layout_file = "DailyTaskItem"
		this.model = DailyModel.GetInstance()
		// this.is_delay_callback = false
		this.Load()
	}

	public load_callback() {
		Util.SetImageGray(this.doneBtn, true);
		this.open_time.leading = 8;
		this.InitEvents();
	}

	public InitEvents() {
		let btn_fun2 = () => {
			if (this.data) {
				if (this.data.module == 300) {
					let task_type = (this.data.module_sub == 1 && (TaskType.DAILY) || (TaskType.GUILD))
					if (task_type == TaskType.GUILD && RoleManager.GetInstance().GetMainRoleVo().guild_id == 0) {
						let ok_func = () => {
							GuildModel.GetInstance().OpenGuildView()
						}
						Alert.Show("需要加入结社才可以接取结社任务", Alert_Type.Two, ok_func, null, "前往", "取消")
						return
					}
					if (task_type == TaskType.DAILY && this.model.daily_task_first_red) {
						this.model.daily_task_first_red = false
						this.get_btn_dot.visible = false
					}
					if (!TaskModel.GetInstance().HaveThisTypeTask(task_type)) {
						TaskModel.GetInstance().Fire(TaskModel.REQUEST_CCMD_EVENT, 30011, task_type)
					}
				} else {
					OpenFun.OpenFunHandler(this.data.ac_cfg.jump_id)
				}
				if (this.data.ac_cfg.jump_id != 89 && this.data.ac_cfg.jump_id != 197) {
					this.model.Fire(DailyEvent.DAILY_CLOSE_VIEW, "DailyView")
				}
			}
		}

		Util.AddClickEvent(this.goBtn, btn_fun2, this, true)

		let get_fun = () => {
			if (this.data) {
				this.model.Fire(DailyEvent.DAILY_REQUEST_PROTO, 15717, "ih", this.data.module, this.data.module_sub)
			}
		}
		Util.AddClickEvent(this.getBtn, get_fun, this, true)

		let click_bg_fun = () => {
			if (this.data) {
				this.model.Fire(DailyEvent.OPEN_VIEW, "DailyLimitActivityTipsView", this.data)
			}
		}
		Util.AddClickEvent(this.click_bg, click_bg_fun, this, true)
	}

	public DeleteMe() {

		super.DeleteMe()
	}


	public dataChanged() {
		if (super.dataChanged()) {

			if ((this.data && this.data.liveness_cfg) && this.data.ac_cfg) {
				this.title.text = this.data.liveness_cfg.act_name
				ResManager.GetInstance().SetImageSpriteTrans(this, this.icon, GameResPath.GetDailyIconPath(this.data.ac_cfg.ac_icon))
				let str = ""
				let liveness = ""
				this.getBtn.visible = false
				this.get_btn_dot.visible = false
				this.destiny_img.visible = false
				this.open_time.text = ""
				let show_live = this.data.live + this.data.can_get_live
				if (this.data.state == 1 || this.data.state == 2) {
					//写死判断日常任务
					if (this.data.module == 300 && this.data.module_sub == 1) {
						if (this.model.daily_task_first_red) {
							this.get_btn_dot.visible = true
						}
					}
					this.condition.visible = false
					let max_time = this.data.liveness_cfg.max
					let max_liveness = this.data.liveness_cfg.live * max_time
					let config_ac_kv = ResManager.GetInstance().GetGameConfigFromCache(this.base_item, "config_ac_kv", false)
					if (this.data.module == 460 && this.data.module_sub == 2) {
						let config_num_by_vip = ResManager.GetInstance().GetGameConfigFromCache(this.base_item, "config_num_by_vip", false);
						[max_time, max_liveness] = this.model.GetPersonalBossTimesAndLiveness(this.data.liveness_cfg.live, config_ac_kv, config_num_by_vip)
					}
					if (max_time == 0) {
						this.goBtn.visible = true;
						this.doneBtn.visible = false;
						this.black_bg.visible = false;
						str = "次数: <font color='#0a853e'>" + this.data.num + "</font>/不限";
						liveness = "活跃: <font color='#0a853e'>" + this.data.live + "</font>/无限";
					}
					else if (this.data.num < this.data.max_num) {
						this.goBtn.visible = true;
						this.doneBtn.visible = false;
						this.black_bg.visible = false;
						str = "次数: <font color='#0a853e'>" + this.data.num + "</font>/" + this.data.max_num;
						liveness = "活跃: <font color='#0a853e'>" + this.data.live + "</font>/" + this.data.max_live;
					} else {
						this.goBtn.visible = false;
						this.doneBtn.visible = true;
						this.black_bg.visible = true;
						str = "次数: <font color='#0a853e'>" + this.data.num + "</font>/" + this.data.max_num;
						liveness = "活跃: <font color='#0a853e'>" + this.data.live + "</font>/" + this.data.max_live;
					}
					if (this.data.state == 2) {
						let [str_arr, state] = this.model.GetTimeStr(this.data.ac_cfg.time_region)
						if (str_arr[1]) {
							this.goBtn.visible = false
							if (!this.doneBtn.visible) {
								this.open_time.text = str_arr[1] + (" - ") + str_arr[2]
							}
						}
					}
				}
				else if (this.data.state == 3) {
					this.goBtn.visible = false
					this.doneBtn.visible = false
					this.black_bg.visible = true
					this.condition.visible = true
					let lv = Number(this.data.liveness_cfg.start_lv)
					let level = lv > 370 && lv - 370 || lv
					this.condition.text = level + "级开启"
					let show_destiny = lv > 370
					this.destiny_img.visible = show_destiny
					this.condition.x = show_destiny ? 145 : 120
					str = ""
					liveness = ""
				}
				let desc = ""

				// 次数为0不显示次数
				str = this.data.liveness_cfg.max ? str : '';
				// 活跃度为0不显示活跃度
				liveness = this.data.liveness_cfg.live ? liveness : '';
				if(PlatformManager.IsEyouPlatform()){
					this.huoyue.style.leading = 0.1
					str +="<br>" 
				}

				desc = this.data.liveness_cfg.live > 0 && (str + " " + liveness) || (str + " ")
				if (this.data.module == 132 && this.data.module_sub == 0) {
					desc = ""
				}
				this.huoyue.style.fontSize = 18
				this.huoyue.width = 220
				this.huoyue.style.color = "#5a1c20"
				this.huoyue.innerHTML = desc
				if (this.data.can_get_live > 0) {
					this.open_time.text = ""
					this.getBtn.visible = true
					this.get_btn_dot.visible = true
					this.goBtn.visible = false
					this.doneBtn.visible = false
					this.black_bg.visible = false
				}
				if ((this.data.module == 157 && this.data.module_sub == 0) && this.data.ac_sub == 0) {
					if (this.data.state != 3) {
						this.condition.visible = false
						this.desc_txt.visible = true
						this.desc_txt.text = Trim(this.data.ac_cfg.about)
						this.huoyue.visible = false
					}
				} else {
					this.desc_txt.visible = false
					this.huoyue.visible = true
				}
				this.corner_type.visible = this.data.liveness_cfg.act_sub_type != 0
				let source = this.data.liveness_cfg.act_sub_type == 1 && "uixrw_021" || "uixrw_022"
				ResManager.GetInstance().SetImageSprite(this, this.corner_type, "daily_asset", source)
			}
		}
	}
	bg: Laya.Image
	title: Laya.Label
	huoyue: Laya.HTMLDivElement
	desc_txt: Laya.Label
	_Image2: Laya.Image
	icon: Laya.Image
	_Image3: Laya.Image
	open_time: Laya.Label
	destiny_img: Laya.Image
	condition: Laya.Label
	corner_type: Laya.Image
	click_bg: Laya.Box
	goBtn: Laya.Box
	_Image4: Laya.Image
	goBtnLabel: Laya.Label
	doneBtn: Laya.Box
	_Image5: Laya.Image
	doneBtnLabel: Laya.Label
	getBtn: Laya.Box
	_Image11: Laya.Image
	labelDisplay: Laya.Label
	get_btn_dot: Laya.Image
	black_bg: Laya.Image
	public GetComponents() {
		[
			this.bg,
			this.title,
			this.huoyue,
			this.desc_txt,
			this._Image2,
			this.icon,
			this._Image3,
			this.open_time,
			this.destiny_img,
			this.condition,
			this.corner_type,
			this.click_bg,
			this.goBtn,
			this._Image4,
			this.goBtnLabel,
			this.doneBtn,
			this._Image5,
			this.doneBtnLabel,
			this.getBtn,
			this._Image11,
			this.labelDisplay,
			this.get_btn_dot,
			this.black_bg,
		]
			= this.GetChildrenByNames([

				"bg",
				"title",
				"huoyue",
				"desc_txt",
				"_Image2",
				"icon",
				"_Image3",
				"open_time",
				"destiny_img",
				"condition",
				"corner_type",
				"click_bg",
				"goBtn",
				"_Image4",
				"goBtnLabel",
				"doneBtn",
				"_Image5",
				"doneBtnLabel",
				"getBtn",
				"_Image11",
				"labelDisplay",
				"get_btn_dot",
				"black_bg",
			])
	}
}
window["DailyTaskItem"] = DailyTaskItem