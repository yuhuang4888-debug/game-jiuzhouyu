import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { MaterialsTool } from "../common/MaterialsTool"
import { ResManager } from "../common/ResManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { PetEquipTypeList } from "../commonModel/PetEquipDefine"
import { SkillUIModel } from "../commonModel/SkillUIModel"
import { SkillManager } from "../skill/SkillManager"
import { SkillVo } from "../skill/SkillVo"
import { GameResPath } from "../util/GameResPath"
import { Mathf } from "../util/Mathf"
import { Util, Trim, SetHtmlStyle } from "../util/Util"
import { SkillPassiveItem } from "./SkillPassiveItem"

export class SkillPassiveSubItem extends BaseItem1 {
	public _img_bg: Laya.Image;
	public _img_icon: Laya.Image;
	public _lb_name: Laya.Label;
	public _gp_desc1: Laya.Box;
	public _lb_now: Laya.HTMLDivElement;
	public _lb_next: Laya.HTMLDivElement;
	public _gp_desc2: Laya.Box;
	public lb_open: Laya.Label;
	public lb_desc: Laya.HTMLDivElement;
	public _gp_desc3: Laya.Box;
	public _lb_open3: Laya.Label;
	public _lb_desc3: Laya.HTMLDivElement;
	public _gp_expend: Laya.Box;
	public _img_cost: Laya.Image;
	public _lb_cost: Laya.Label;
	public _gp_level_up: Laya.Box;
	public _img_red: Laya.Image;
	public scr1: Laya.List;

	public _gp_effect_con: Laya.Box;
	img_1: Laya.Image
	img_2: Laya.Image
	img_3: Laya.Image
	img_4: Laya.Image
	// img_5: Laya.Image
	lb_1: Laya.Label
	lb_2: Laya.Label
	btn_bg_1: Laya.Image
	btn_lb: Laya.Label
	_Scroller1: Laya.List



	Scr_scroller
	data_list
	default_index
	list_loop_mgr
	now_index

	public static guide_skill_id = null

	public constructor(parent?) {
		super(parent)


		this.default_index = 0
		this.now_index = null
		this.data_list = null
		this.base_file = "role"
		this.layout_file = "SkillPassiveSubItem"
		this.load_callback = () => {
			this.InitEvent()
			this.LoadSuccess()
		}
	}

	public InitEvent() {

		Util.AddClickEvent(this._gp_level_up, () => {
			if (this.data_list && this.now_index != null) {
				let vo = this.data_list[this.now_index]
				if (vo) {
					let next_vo = vo.getLevelVo(vo.level + 1)
					if (next_vo) {
						let goods_info = next_vo.condition.goods
						//let goods_info = null
						//if (cond ) {
						//goods_info = cond.split(",")
						//}
						let bool = goods_info && goods_info.length == 2
						let my_count = GoodsModel.GetInstance().GetTypeGoodsNum(goods_info[1])
						let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(goods_info[1])
						if (bool) {
							let count = goods_info[2]
							if (count > my_count) {
								MaterialsTool.GetInstance().materialsTips(goods_info[1])
							} else {
								SkillManager.GetInstance().Fire(SkillManager.REQUEST_CCMD_EVENT, 21001, vo.id)
							}
						}
					}
				}
			}
		}, this, true)

		this.BindEvent(SkillManager.GetInstance(), SkillManager.UPDATE_SKILL_LIST, () => {
			SkillUIModel.GetInstance().UpdateTabDot()
			let skill_ui_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigSkillUI", true)
			let data = SkillManager.GetInstance().GetShowPassitiveSkillList(skill_ui_cfg)
			if (data && this.list_loop_mgr) {
				// table.insert(data, this.GetAddExpRadioSkillData())
				this.data_list = data
				this.list_loop_mgr.replaceAll(data)
				this.RefreshIndex()
				this.UpdateShowSkillInfo()
			}
		}
		)
		this.BindEvent(SkillManager.GetInstance(), SkillManager.LEVEL_UP_SUCCESS, () => {
			// ResManager.GetInstance().SetUIEffect(this,"UI_1404", this.layer_value, this._gp_effect_con, null, 1.2, false)
		}
		)
		this.BindEvent(SkillUIModel.GetInstance(), SkillUIModel.UPDATE_RED_DOT, () => {
			this.UpdateShowSkillInfo()
		}
		)
	}

	public RefreshIndex() {

		let data = this.data_list
		if (data) {
			let index = this.now_index || this.default_index
			for (let key in data) {

				let vo = data[key]
				if (!vo) {
					break
				}
				let next_vo = vo.getLevelVo(vo.level + 1)
				if (next_vo) {
					let goods_info = next_vo.condition.goods
					//let goods_info = null
					//if (cond ) {
					//goods_info = cond.split(",")
					//}
					let bool = goods_info && goods_info.length == 2
					if (bool) {
						let my_count = GoodsModel.GetInstance().GetTypeGoodsNum(goods_info[1])
						if (my_count >= Number(goods_info[2])) {
							index = Number(key)
							break
						}
					}
				}
			}
			this.list_loop_mgr.SetSelectIndex(index)
			this.now_index = index
		}
	}

	public LoadSuccess() {
		SetHtmlStyle(this._lb_desc3,{c:"#663519",f:22,w:475,lh:25})
		// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
		// 	this.lb_desc.size  = 18
		// 	this.lb_open.size  = 18
		// 	this._lb_open3.size  = 18
		// 	this._lb_desc3.size  = 18
		// }
		// this.img_5.visible=false
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, "resource/game/role/texture/uijn_001.jpg")
		// ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, "resource/asset/icon/role/uirw_049.png")
		// ResManager.GetInstance().SetOutsideImageSprite(this, this._Image4, "resource/asset/icon/common2/uity_066b.png")

		Util.SetCircleMask(this._img_icon)

		let skill_ui_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "ConfigSkillUI", true)
		let data_list = SkillManager.GetInstance().GetShowPassitiveSkillList(skill_ui_cfg)
		let data = this.ReplaceSkill(data_list)

		// 增加“杀怪经验加成”被动技能（此界面只作显示，实际效果由主线本处理）
		// table.insert(data, this.GetAddExpRadioSkillData())

		this.data_list = data

		this.list_loop_mgr = new LoopScrowViewMgr()
		this.list_loop_mgr.SetData(this._Scroller1, SkillPassiveItem, this.data_list, LoopScrCon.Vertical, 4, this.RefSelType)
		// this._list_item_con.addEventListener(Laya.ItemTapEvent.ITEM_TAP, this.RefSelType, this)
		this.RefreshIndex()
		this.UpdateShowSkillInfo()
	}
	// _scroller(_list_item_con: Laya.List, skillPassiveItem: typeof SkillPassiveItem, data_list: any, _scroller: any, arg4: number, arg5: (item?: any) => void) {
	// 	throw new Error("Method not implemented.")
	// }

	public UpdateShowSkillInfo() {

		let info = this.data_list[this.now_index]
		//let dungeon_learn_skill_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_dungeon_learn_skill", false)
		if (info) {
			this.lb_desc.style.width = 487
			this._lb_now.style.width = 487
			this._lb_next.style.width = 487
			let icon = info.GetIcon && info.GetIcon()
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_icon, GameResPath.GetSkillIconPath(icon != 0 && icon || info.id))
			if (info.id >= 300201 && info.id <= 300207) {
				let open = info.level > 0
				let openStr = open && "" || "(未激活)"
				this.lb_open.text = openStr
				this._lb_name.text = info.getBasic("name")
				let now_vo = info.getLevelVo(info.level, false)
				this.lb_desc.innerHTML = info.getDesc(info.level, false)
				this._gp_desc1.visible = false
				this._gp_desc2.visible = true
				this._gp_desc3.visible = false
				this._gp_expend.visible = false
				this._gp_level_up.visible = false

				// } else if (info.id == BaseDungeonModel.MAIN_LINE_ADD_EXP_RADIO_SKILL_ID ) {
				// 	this.lb_open.text = ""
				// 	this._lb_name.text = "野外经验加成"
				// 	let level = BaseDungeonModel.GetInstance().GetMainLineLevel()
				// 	let enchantment_guard_boss_cfg = Config.Enchantmentguardboss
				// 	let radio = BaseDungeonModel.GetInstance().GetLevel2AddExpRatio(level, enchantment_guard_boss_cfg) * 100
				// 	if (level == 0 ) {
				// 		radio = 0
				// 	}
				// 	let desc = Mathf.Abs(radio - Mathf.Round(radio)) < 0.1 && Mathf.Round(radio) || string.format("%.1f",String(radio))

				// 	this.lb_desc.text = "当前野外经验加成" + desc + "%\n挑战主线关卡获得的经验增益技能"

				// 	this._gp_desc1.visible = false 
				// 	this._gp_desc2.visible = true 
				// 	this._gp_expend.visible = false 
				// 	this._gp_desc3.visible = false 
				// 	this._gp_level_up.visible = false 
			} else if (1) {//BaseDungeonModel.GetInstance().IsHeartSkill(info.id, dungeon_learn_skill_cfg)
				this._gp_desc3.visible = true
				let desc = ""
				//

				//if (370001 == info.id ) {
				//desc = "达到155级，完成技能觉醒I解锁技能 "
				//},
				//if (370002 == info.id ) {
				//desc = "达到160级，完成技能觉醒II解锁技能 "
				//},
				//if (370003 == info.id ) {
				//desc = "达到185级，完成技能觉醒III解锁技能 "
				//},
				//if (370004 == info.id ) {
				//desc = "达到215级，完成技能觉醒IV解锁技能 "
				//},
				//if (370005 == info.id ) {
				//desc = "达到245级，完成技能觉醒V解锁技能 "
				//},
				//if (370006 == info.id ) {
				//desc = "达到285级，完成技能觉醒VI解锁技能"
				//},
				//if (370007 == info.id ) {
				//desc = "达到325级，完成技能觉醒VII解锁技能 "
				//}
				//}
				//
				let taskVo = Config.GetConfigVo("config_task", info.taskId, false)// ConfigItemMgr.Instance.GetTaskData()
				if (taskVo) {
					// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
					// 	desc = "Reach Level" + taskVo.level + "and complete " + Trim(taskVo.name) + " to unlock"
					// }else{
					desc = "达到" + taskVo.level + "级，完成" + Trim(taskVo.name) + "解锁技能"
					// }
				}
				if (info.level == 0) {
					desc = desc + "(未激活)"
				}
				this._lb_open3.text = desc
				this._lb_name.text = info.getBasic("name")
				// let now_vo = info.getLevelVo(1, false)
				// this._lb_desc3.innerHTML = Trim(now_vo.desc)
				this._lb_desc3.innerHTML = info.getDesc(1, false)
				this._lb_desc3.style.width=475
				this._gp_desc1.visible = false
				this._gp_desc2.visible = false
				this._gp_expend.visible = false
				this._gp_level_up.visible = false
			} else {
				this._lb_name.text = info.getBasic("name")
				if (info.level) {
					// let now_vo = info.getLevelVo(info.level)
					// if (now_vo) {
					// 	this._lb_now.innerHTML = Util.StrToHTML(now_vo.desc)
					// }
					this._lb_now.innerHTML = info.getDesc(info.level, false)
				} else {
					this._lb_now.innerHTML = "暂未学习"
				}
				let next_vo = info.getLevelVo(info.level + 1)
				if (next_vo) {
					let goods_info = next_vo.condition.goods
					//let goods_info = null
					//if (cond ) {
					//goods_info = cond.split(",")
					//}
					if (!goods_info) {
						return
					}
					let bool = goods_info && goods_info.length == 2
					this._gp_expend.visible = bool
					this._gp_level_up.visible = bool
					let my_count = GoodsModel.GetInstance().GetTypeGoodsNum(goods_info[1])
					let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(goods_info[1])
					if (goods_vo) {
						ResManager.GetInstance().SetOutsideImageSprite(this, this._img_cost, GameResPath.GetGoodsIconPath(goods_vo.goods_icon))
					}
					if (bool) {
						let count = Number(goods_info[2])
						this._lb_cost.text = my_count + "/" + count
						this._img_red.visible = count <= my_count
					}
					// this._lb_next.innerHTML = Util.StrToHTML(next_vo.desc)
					this._lb_next.innerHTML = info.getDesc(info.level + 1, false)
				} else {
					this._lb_next.innerHTML = "已满级"
					this._gp_expend.visible = false
					this._gp_level_up.visible = false
				}
				this._gp_desc1.visible = true
				this._gp_desc2.visible = false
				this._gp_desc3.visible = false
			}
		}
	}

	public GetAddExpRadioSkillData() {

		// let skill_vo =  new SkillVo(BaseDungeonModel.MAIN_LINE_ADD_EXP_RADIO_SKILL_ID)
		// skill_vo.basic = [name="杀怪经验加成"]
		// return skill_vo
	}

	public CustomMehod(index?, args?) {

		if (args) {
			SkillPassiveSubItem.guide_skill_id = args[1]
		}
	}

	public ReplaceSkill(data_list?) {

		let task_list = []
		// let config_supreme_vip_skill = Config.Supremevipskill
		// let config_supreme_vip_skill_replace = Config.Supremevipskillreplace
		// task_list = TopVipModel.GetInstance().GetSupremeVipTaskList(config_supreme_vip_skill, config_supreme_vip_skill_replace)
		if (Util.TableSize(task_list) == 0) {
			return data_list
		}
		for (let i = 1; i <= data_list.length; i++) {
			for (let key in task_list) {

				let task = task_list[key]
				if (Number(key) == data_list[i].id) {
					data_list[i] = new SkillVo(task)
				}
			}
		}
		return data_list
	}
	public RefSelType = (item?) => {
		if (item.real_index == this.now_index) {
			return
		}
		// if (SkillPassiveSubItem.guide_skill_id ) {
		// SkillPassiveSubItem.guide_skill_id = null
		this.list_loop_mgr.replaceAll(this.data_list)
		// }
		this.now_index = this.list_loop_mgr.parent.selectedIndex  //this._list_item_con.selectedIndex //item.real_index
		this.UpdateShowSkillInfo()
	}
	public DeleteMe() {
		if(this.list_loop_mgr){
			this.list_loop_mgr.DeleteMe()
			this.list_loop_mgr = null
		}
		super.DeleteMe()
	}


	public GetComponents() {
		[
			this._img_bg,
			this.img_1,
			this.img_2,
			this.img_3,
			this.img_4,
			this._img_icon,
			this._lb_name,
			this._gp_desc1,
			this._lb_now,
			this.lb_1,
			this._lb_next,
			this._gp_desc2,
			this.lb_open,
			this.lb_desc,
			this._gp_desc3,
			this._lb_open3,
			this._lb_desc3,
			this._gp_expend,
			this.lb_2,
			this._img_cost,
			this._lb_cost,
			this._gp_level_up,
			this.btn_bg_1,
			this.btn_lb,
			this._img_red,
			this._Scroller1,
			this._gp_effect_con,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"img_1",
				"img_2",
				"img_3",
				"img_4",
				"_img_icon",
				"_lb_name",
				"_gp_desc1",
				"_lb_now",
				"lb_1",
				"_lb_next",
				"_gp_desc2",
				"lb_open",
				"lb_desc",
				"_gp_desc3",
				"_lb_open3",
				"_lb_desc3",
				"_gp_expend",
				"lb_2",
				"_img_cost",
				"_lb_cost",
				"_gp_level_up",
				"btn_bg_1",
				"btn_lb",
				"_img_red",
				"_Scroller1",
				"_gp_effect_con",
			])
	}
}
window["SkillPassiveSubItem"] = SkillPassiveSubItem