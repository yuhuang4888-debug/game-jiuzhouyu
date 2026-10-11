import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { SkillUIModel } from "../commonModel/SkillUIModel"
import { SkillManager } from "../skill/SkillManager"
import { Enum_ColorUtil_Dark, Enum_ColorUtil_Light } from "../util/ColorUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { Mathf } from "../util/Mathf"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { SetSizeDeltaX, SetAnchoredPosition, Util, GlobalTimerQuest, HtmlColorTxt, Trim } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { Vector3 } from "../util/Vector3"
import { RoleManager } from "../commonModel/RoleManager"
import { SkillInitiativeItem } from "./SkillInitiativeItem"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { PlatformManager } from "../PlatformManager"

export class SkillInitiativeSubItem extends BaseItem1 {

	Emp_btn_over
	Out_lb_name
	Scr_scroller_cur
	Scr_scroller_next
	_cur_content
	_cur_sel_data

	_img_career

	_item_list
	_item_list_tween
	_item_pos_list

	_model
	_next_content
	_skill_dic
	_skill_list
	_timer_id

	career_pos
	config_item
	is_delay_callback
	skill_mgr
	timer_list

	public constructor(parent) {
		super(parent)

		this.base_file = "role"
		this.layout_file = "SkillInitiativeSubItem"
		this.is_delay_callback = false

		this._item_pos_list = [[220.4272, 2.9245]]
		this._skill_dic = [];
		this._skill_list = [];
		this.timer_list = []
		this._cur_sel_data = null
		this._timer_id = null
		this._item_list = null
		this._model = SkillUIModel.GetInstance()
		this.skill_mgr = SkillManager.GetInstance()
		this.config_item
		this._item_list_tween = []
		this.career_pos = [[20, 90],
		[22, 37],
		[22, 39],
		[27, 42]]
		this.preload_server_config = {
			"config_task": false
		}
		this.load_callback = () => {
			if (PlatformManager.IsEyouEnPlatform()) {
				this._Group5.centerX = 0
			}
			this._lb_content_now.style.fontSize = 22
			this._lb_content_now.style.color = "#4A3A32"
			this._lb_content_now.style.leading = 13
			this._scroller_cur.vScrollBar.visible = false
			this._lb_content_next.style.fontSize = 22
			this._lb_content_next.style.color = "#4A3A32"
			this._lb_content_next.style.leading = 13
			this._scroller_next.vScrollBar.visible = false
			this._lb_level.style.width = 82
			this._lb_level.style.fontSize = 22
			this._lb_level.style.color = "#3C8E00"


			this.LoadSuccess()
		}
	}

	public DeleteMe() {
		this._cur_sel_data = null
		this.StopAction()
		this.ClearTweenTimer()
		this.ClearActionTimer()
		this.ClearItemList()
		super.DeleteMe()
	}

	public LoadSuccess() {

		let career = RoleManager.GetInstance().GetMainRoleVo().career
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, "resource/game/role/texture/uijn_001.jpg")
		this._img_circle.x = 50
		this._img_circle.y = 70
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_circle, "resource/game/role/texture/uirw_046.png")
		let path = "uijn_00" + career
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_boy, "resource/game/role/texture/" + path + ".png", true)
		SetAnchoredPosition(this._img_boy, this.career_pos[career - 1][0], this.career_pos[career - 1][1])


		this.InitEvent()
		this.InitItems()
		this.ForbiddenSkillBtnVisible()
	}

	public InitEvent() {

		this.BindEvent(this._model, SkillUIModel.SELECT_SKILL_ITEM, (data?, scmd?) => {
			this._cur_sel_data = data
			this.UpdateShowData()
		}
		)

		let wear_fun = () => {
			//this._model.Fire(SkillUIModel.OPEN_SKILL_UI_VIEW, ForbiddenSkillAssemblyView)
		}
		Util.AddClickEvent(this.skill_wear_btn, wear_fun, this, true)

		this.BindEvent(this._model, SkillUIModel.UPDATE_FORBIDDEN_SKILL_INFO, () => {
			if (!this.use_delete_method) {
				this.ForbiddenSkillBtnVisible()
			}
		}
		)

		let update_fun = () => {
			if (!this.use_delete_method) {
				this.InitItems()
			}
		}
		this.BindEvent(this.skill_mgr, SkillManager.UPDATE_SKILL_BAR_INFO, update_fun)
		this.BindEvent(SkillManager.GetInstance(), SkillManager.UPDATE_SKILL_LIST, update_fun)
	}

	public ClearItemList() {

		if (this._item_list) {
			for (let key in this._item_list) {

				this._item_list[key].DeleteMe()
			}
			this._item_list = []
		}
	}

	public InitItems() {

		let list = this.GetSkillList() // <=6个
		this._skill_list = list
		this.ClearItemList()
		if (!this._item_list) {
			this._item_list = []
		}

		for (let i = 0; i < list.length; i++) {
			let info = list[i]
			let item = new SkillInitiativeItem(this._group_item)
			item.Load()
			let value = (i - 1.8) * (Mathf.PI * 2 / 9)
			item.SetCircle(value, value)
			item.SetVisible(false)
			item.ExcuteCallback(() => {
				item.SetData(info)
			}
			)
			this._item_list[info.skill_id] = item
			if (i == 0) {
				item.ExcuteCallback(() => {
					item.Select(true)
				}
				)
				this._cur_sel_data = info
				this.UpdateShowData()
			}
		}

		this.ClearActionTimer()
		let on_timer = () => {
			this.StartAction()
		}
		this._timer_id = GlobalTimerQuest.AddPeriodQuest(on_timer, 0.1, 0)
	}

	public ClearActionTimer() {

		if (this._timer_id) {
			GlobalTimerQuest.CancelQuest(this._timer_id)
			this._timer_id = null
		}
	}

	public SendSelect() {

		if (!this._cur_sel_data) {
			return
		}
	}

	public UpdateShowData() {

		if (!this._cur_sel_data) {
			return
		}
		let data = this._cur_sel_data

		let lv_lock = true
		if (data.type == 1) {
			let role_lv = RoleManager.GetInstance().GetMainRoleVo().level
			lv_lock = role_lv < data.open_lv
		} else if (data.type == 2) {
			lv_lock = (data.level == 0 && (true) || (false))
		}
		if (data.task_id) {
			lv_lock = !this._model.CheckTaskFinish(data.task_id)
		}

		let next_data = data.next_lv_data

		let cur_desc = ""
		let next_desc
		if (next_data) {
			if (window["ChatModel"]) {
				next_desc = window["ChatModel"].GetInstance().FormatColorTag(next_data.desc, false);
			}
			else {
				next_desc = next_data.desc
			}
		}
		else {
			next_desc = ""
		}
		this._lb_content_next.style.width = 250
		this._lb_content_now.style.width = 250
		if (lv_lock) {
			if (data.type == 1) {
				let open_lv = HtmlColorTxt(data.open_lv, Enum_ColorUtil_Dark.RED)
				if (data.task_id) {
					cur_desc = "完成任务" + HtmlColorTxt(this.preload_server_config["config_task"][data.task_id][1], Enum_ColorUtil_Dark.RED) + "解锁技能"
				} else {
					cur_desc = "人物达到" + open_lv + "级解锁"
				}
				this._img_max.visible = !next_data
				this._lb_content_now.innerHTML = Util.StrToHTML(cur_desc)
				this._lb_content_next.innerHTML = Util.StrToHTML(next_desc)
			} else if (data.type == 2) {
				let sp_skill_cfg = Config.PRELOAD_SERVER_CONFIG.config_dungeon_learn_skill
				let taskVo = Config.GetConfigVo("config_task", sp_skill_cfg[31003].task_id, false)//ConfigItemMgr.Instance.GetTaskData(sp_skill_cfg[31003].task_id)
				if (taskVo) {
					let open_lv = HtmlColorTxt(taskVo.level, Enum_ColorUtil_Dark.RED)
					let open_task = HtmlColorTxt(Trim(taskVo.name), Enum_ColorUtil_Dark.RED)
					cur_desc = "达到" + open_lv + "级，完成" + open_task + "解锁技能"
				}
				if (data.level == 0) {
					this._img_max.visible = false
					this._lb_content_now.innerHTML = Util.StrToHTML(cur_desc)
					this._lb_content_next.innerHTML = Util.StrToHTML(data.desc)
				} else {
					this._img_max.visible = !next_data
					this._lb_content_now.innerHTML = Util.StrToHTML(cur_desc)
					this._lb_content_next.innerHTML = Util.StrToHTML(next_desc)
				}
			}
		} else {
			cur_desc = data.desc
			this._img_max.visible = !next_data
			this._lb_content_now.innerHTML = Util.StrToHTML(cur_desc)
			this._lb_content_next.innerHTML = Util.StrToHTML(next_desc)
		}

		if (next_data && data.turn) {
			next_desc = next_desc + HtmlColorTxt("（人物达到" + data.turn + "转）", Enum_ColorUtil_Light.RED)
		}

		this._lb_name.text = data.name
		this._lb_level.width=150
		if (PlatformManager.IsEyouEnPlatform()) {
			this._lb_level.innerHTML = Util.StrToHTML(lv_lock && "<font color=\"#ff4f50\">[Locked]</font>" || (data && "[Level" + data.level + "]" || "[Lv. 0]"))
		}else{
		this._lb_level.innerHTML = Util.StrToHTML(lv_lock && "<font color=\"#ff4f50\">[未解锁]</font>" || (data && "[" + data.level + "级]" || "[0级]"))
		}
		this._Group3.height=this._lb_content_now.contextHeight
		this._Group4.height=this._lb_content_next.contextHeight
		this._scroller_cur.vScrollBar.value=0
		this._scroller_next.vScrollBar.value=0
		this._scroller_cur.refresh()
		this._scroller_next.refresh()
		this.CallLater(() => {
			this._Group5.refresh()
			this._Group5.width = this._lb_name.width + this._Group5.space + this._lb_level.contextWidth
		})
	}

	public InitShowSkill() {

		let career = RoleManager.GetInstance().GetMainRoleVo().career
		let skill_ui_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigSkillUI", true)
		let skill_client_cfg = skill_ui_cfg["carrerSkillList"][career]
		let list = []
		if (skill_client_cfg) {
			for (let _tmpi in skill_client_cfg) {
				var vo = skill_client_cfg[_tmpi]
				table.insert(list, vo)
			}

			let sort_fun = (a?, b?) => {
				return a.skill_id < b.skill_id
			}
			if (career == 4) return list
			table.sort(list, sort_fun)
		}
		return list
	}

	public GetSkillList() {

		let show_skill = this.InitShowSkill()
		let list = []
		if (show_skill) {
			for (let k in show_skill) {
				var value = show_skill[k]
				let vo
				vo = {}
				let cfg = Config.GetConfigVo("config_skill", value.skill_id) //Config.PRELOAD_SERVER_CONFIG.config_skill [value.skill_id]
				let break_id = null
				if (cfg) {
					vo.name = cfg.name
					vo.skill_id = value.skill_id
					break_id = this._model.GetBreakSkillId(value.skill_id)
					if (break_id && this.skill_mgr.mySkillList[break_id]) {
						vo.skill_id = break_id
					}
					vo.type = cfg.type
					let lv_data = cfg.lv_data
					lv_data = JSON.parse(lv_data)
					if (lv_data) {
						let skillVo = this.skill_mgr.mySkillList[vo.skill_id]
						let lv = skillVo && skillVo.level || 0
						if (vo.type == 2) {
							//特殊处理的被动技能（职业专属技能
							lv = BaseDungeonModel.GetInstance().GetHeartSkillLv(vo.skill_id) || 0
							if (lv == 0) {
								vo.open_lock = true
							} else if (lv > 0) {
								vo.open_lock = false
							}
						}
						let index = Mathf.Max(lv, 1)
						index = index - 1
						vo.level = lv
						vo.power = Number(lv_data[index].power)
						if (window["ChatModel"]) {
							vo.desc = window["ChatModel"].GetInstance().FormatColorTag(lv_data[index].desc, false);
						}
						else {
							vo.desc = lv_data[index].desc
						}
						vo.open_lv = this._model.GetLvCacheAndSet(vo.skill_id, cfg)
						vo.task_id = this._model.GetTaskCacheAndSet(vo.skill_id, cfg)
						vo.next_lv_data = lv_data[lv]
						vo.turn = lv_data[lv] && this._model.GetTurnCacheAndSet(vo.skill_id, cfg, lv)
					}
					table.insert(list, vo)
					this._skill_dic[vo.skill_id] = vo
				} else {
					table.insert(list, { skill_id: value.skill_id, ignore: true })
				}

			}
		}
		return list
	}

	public StartAction() {
		this.StopAction()
		let list = this._skill_list
		for (let i = 0; i <= list.length - 1; i++) {
			let info = list[i]
			let item = this._item_list[info.skill_id]
			let item_timer = () => {
				if (this.use_delete_method) {
					return
				}
				let item_trans = item// item.GetTransform()
				let tween_id = SYTweenLite.to(this.display_obj, item_trans, SYTweenLite.UiAnimationType.SCALE, new Vector3(0.8, 0.8, 0.8), 0.08, () => {
					GlobalTimerQuest.CancelQuest(item_timer)
				}, SYTweenFunc.EASE_IN_OUT)
				item.SetVisible(true)
				table.insert(this._item_list_tween, tween_id)
			}
			let item_timer_id = GlobalTimerQuest.AddPeriodQuest(item_timer, i * 0.055, 0)
		}
	}

	public ClearTweenTimer() {

		for (let i in this.timer_list) {
			var v = this.timer_list[i]
			if (this.timer_list[i]) {
				GlobalTimerQuest.CancelQuest(this.timer_list[i])
				this.timer_list[i] = null
			}
		}

	}

	public StopAction() {

		if (this._item_list_tween.length == 0) {
			return
		}
		for (let key in this._item_list_tween) {

			let item_tween = this._item_list_tween[key]
			SYTweenLite.Stop(item_tween)
		}
	}

	public ForbiddenSkillBtnVisible() {

		let bool = this._model.forbbiden_skill_info && this._model.forbbiden_skill_info.core_type
		this.skill_wear_btn.visible = bool
	}

_img_bg:Laya.Image
attr_bg_img:Laya.Image
_img_circle:Laya.Image
_img_girl:Laya.Image
_img_boy:Laya.Image
_img_border:Laya.Image
_Image1:Laya.Image
_group_title_cur:Laya.Box
_Image2:Laya.Image
_Label1:Laya.Label
_group_title_next:Laya.Box
_Image3:Laya.Image
_Label2:Laya.Label
_Group1:Laya.Box
_Image4:Laya.Image
_group_item:Laya.Box
_scroller_cur:Laya.Panel
_Group3:Laya.Box
_lb_content_now:Laya.HTMLDivElement
_img_max:Laya.Image
_scroller_next:Laya.Panel
_Group4:Laya.Box
_lb_content_next:Laya.HTMLDivElement
skill_wear_btn:Laya.Image
_Group5:Laya.HBox
_lb_name:Laya.Label
_lb_level:Laya.HTMLDivElement
public GetComponents() {
[
this._img_bg,
this.attr_bg_img,
this._img_circle,
this._img_girl,
this._img_boy,
this._img_border,
this._Image1,
this._group_title_cur,
this._Image2,
this._Label1,
this._group_title_next,
this._Image3,
this._Label2,
this._Group1,
this._Image4,
this._group_item,
this._scroller_cur,
this._Group3,
this._lb_content_now,
this._img_max,
this._scroller_next,
this._Group4,
this._lb_content_next,
this.skill_wear_btn,
this._Group5,
this._lb_name,
this._lb_level,
]
 = this.GetChildrenByNames([

"_img_bg",
"attr_bg_img",
"_img_circle",
"_img_girl",
"_img_boy",
"_img_border",
"_Image1",
"_group_title_cur",
"_Image2",
"_Label1",
"_group_title_next",
"_Image3",
"_Label2",
"_Group1",
"_Image4",
"_group_item",
"_scroller_cur",
"_Group3",
"_lb_content_now",
"_img_max",
"_scroller_next",
"_Group4",
"_lb_content_next",
"skill_wear_btn",
"_Group5",
"_lb_name",
"_lb_level",
])
}
}
 window["SkillInitiativeSubItem"]= SkillInitiativeSubItem