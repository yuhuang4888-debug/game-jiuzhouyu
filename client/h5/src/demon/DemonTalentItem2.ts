import { BaseItem1 } from "../common/BaseItem1";
import { EventName } from "../common/EventName";
import { ResManager } from "../common/ResManager";
import { DemonEvent } from "../commonModel/DemonEvent";
import { DemonModel } from "../commonModel/DemonModel";
import { SkillVo } from "../skill/SkillVo";
import { Message } from "../sysInfo/SysInfoController";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { GameResPath } from "../util/GameResPath";
import { Util } from "../util/Util";
import { DemonTalentItem } from "./DemonTalentItem";
/**学习技能书 */
export class DemonTalentItem2 extends BaseItem1 {
	item_bg: Laya.Image
	_icon_mask: Laya.Image
	_icon: Laya.Image
	_add: Laya.Image
	_lock: Laya.Box
	Image: Laya.Image
	Image1: Laya.Image
	_red: Laya.Image
	_tips: Laya.Image
	_lv: Laya.Label


	demon_id
	demon_model: DemonModel
	has_activated
	has_learned
	is_goods_data
	need_refresh_data
	show_red
	slot
	unlock_cond
	unlock_state
	res_mgr

	public constructor(parent?) {
		super(parent)

		this.base_file = "demon"
		this.layout_file = "DemonTalentItem2"
		this.demon_model = DemonModel.GetInstance()
		this.res_mgr = ResManager.GetInstance()

		this.is_goods_data = false
		this.show_red = false

		this.load_callback = () => {
			// this._icon.mask = this._icon_mask
			this.LoadSuccess()
		}
	}

	public LoadSuccess() {

		Util.AddClickEvent(this.item_bg, () => {
			if (!this.has_activated) {
				Message.show("尚未激活该妖灵")
				return
			}
			if (!this.unlock_state && this.unlock_cond) {
				Message.show(this.unlock_cond + "星解锁")
				return
			}
			//if (this.has_learned ) {
			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DemonTalentSelectView", this.slot, this.demon_id);
			//}
		}, false)

		this.BindEvent(this.demon_model, DemonEvent.REFRESH_RED_FLAG, (flag?, key?, key2?) => {
			if (flag == DemonModel.RedFlag.Talent && this.demon_id == key && this.slot == key2) {
				this.UpdateRedState()
			}
		})

		if (this.need_refresh_data) {
			this.UpdateView()
			this.need_refresh_data = false
		}
	}

	public SetData(slot?, demon_id?) {
		this.demon_id = demon_id
		this.slot = slot
		if (this.is_loaded) {
			this.UpdateView()
		} else {
			this.need_refresh_data = true
		}
	}

	public UpdateView() {
		let goods_basic = null
		let skill_id = null
		let quality = null
		let skill_lv = 0

		//当前技能栏解锁条件
		this.unlock_cond = this.demon_model.unlock_talent_slot_cond[this.slot]

		//使魔是否激活
		let demon_data = this.demon_model.GetDemonData(this.demon_id)
		if (demon_data) {
			this.has_activated = true
		} else {
			this.has_activated = false
		}

		this.unlock_state = true

		if (this.unlock_cond != undefined) {
			if (demon_data) {
				this.unlock_state = demon_data.star >= this.unlock_cond
			} else {
				this.unlock_state = false
			}
		}

		this._lock.visible = !this.unlock_state

		let talent_data = demon_data && demon_data.GetTalentData(this.slot)

		//当前槽位是否学习技能
		this.has_learned = false
		if (this.has_activated && talent_data) {
			this.has_learned = true
		}

		if (this.unlock_state) {
			if (this.has_learned) {
				let skill_vo = new SkillVo(talent_data.sk_id)
				this.res_mgr.SetTexture(this, this._icon, GameResPath.GetSkillIconPath(skill_vo.GetIcon()))

				let demons_skill_add_cfgs = this.res_mgr.GetGameConfigFromCache(this, "config_demons_skill_add", false)
				let skill_cfg = demons_skill_add_cfgs[talent_data.sk_id]
				this._tips.skin =GameResPath.GetIcon("demon",`uism_068${DemonTalentItem.Level2Str[skill_cfg.quality-1]}`)// `demon_json.uism_068${DemonTalentItem.Level2Str[skill_cfg.quality]}_png`

				this._lv.text = "l" + talent_data.sk_lv
				this._lv.visible = false
				this._add.visible = false
				this._icon.visible = true
				this._tips.visible = true
			} else {
				this._add.visible = true
				this._icon.visible = false
				this._tips.visible = false
				this._lv.visible = false
			}
		} else {
			this._add.visible = false
			this._icon.visible = false
			this._tips.visible = false
			this._lv.visible = false
		}
		this.UpdateRedState()
	}

	public UpdateRedState() {
		let demons_skill_add_cfgs = this.res_mgr.GetGameConfigFromCache(this, "config_demons_skill_add", false)
		let boo1= this.demon_model.DemonTalentRedDot(this.demon_id,demons_skill_add_cfgs,this.slot)
		// this._red.visible = this.demon_model.GetRedFlagState(DemonModel.RedFlag.Talent, this.demon_id, this.slot) && this.unlock_state
		this._red.visible = boo1 && this.unlock_state
	}

	public ShowNum(str?) {
		// this._lv.visible = str != ""
		// if (this._lv.visible) {
		// 	this._lv.text = str
		// }
	}

	public GetComponents() {
		[
			this.item_bg,
			this._icon_mask,
			this._icon,
			this._add,
			this._lock,
			this.Image,
			this.Image1,
			this._red,
			this._tips,
			this._lv,
		]
			= this.GetChildrenByNames([

				"item_bg",
				"_icon_mask",
				"_icon",
				"_add",
				"_lock",
				"Image",
				"Image1",
				"_red",
				"_tips",
				"_lv",
			])
	}
}
window["DemonTalentItem2"]=DemonTalentItem2