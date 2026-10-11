import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseItem1 } from "../common/BaseItem1"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { BossSceneManager } from "../commonController/BossSceneManager"
import { BossModel } from "../commonModel/BossModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Scene } from "../scene/Scene"
import { SceneBaseType } from "../scene/SceneConfig"
import { SceneManager } from "../scene/SceneManager"
import { Message } from "../sysInfo/SysInfoController"
import { Vector2 } from "../util/Vector2"

export class BossTargetItem extends BaseItem1 {

	role_mgr: RoleManager
	boss_scene_mgr: BossSceneManager
	auto_fight_mgr: AutoFightManager
	boss_model: BossModel

	need_refresh_data
	item_loop_mgr:LoopScrowViewMgr

	data
	start_pos

	public constructor(parent?) {
		super(parent)



		this.base_file = "boss"
		this.layout_file = "BossTargetItem"

		this.need_refresh_data = false

		this.role_mgr = RoleManager.GetInstance()
		this.boss_scene_mgr = BossSceneManager.GetInstance()
		this.auto_fight_mgr = AutoFightManager.GetInstance()
		this.boss_model = BossModel.GetInstance()

		// this.preload_server_config = {
		// 	"config_picture":false
		// }
		this.load_callback = () => {
			this.LoadSuccess()
		}
	}

	InitEvent = () => {

		this.BindEvent(this.boss_scene_mgr, BossSceneManager.SWITCH_ITEM, (index?) => {
			this.SwitchItem(index)
		})

		this.BindVar(this.role_mgr.GetMainRoleVo(), "pk_status", (event_name?, pk_status?) => {
			if ((pk_status == 0 && this.boss_scene_mgr.GetAttackTarget()) && this.boss_scene_mgr.GetAttackTarget()._type == SceneBaseType.Role) {
				this.auto_fight_mgr.SetAutoFight(false)
				this.boss_scene_mgr.SetAttackTarget(null)
			}
		}
		)
	}

	LoadSuccess(){
		let pos = this.start_pos || new Vector2(0, 0)
		this.display_obj.x = pos.x
		this.display_obj.y = pos.y

		this.InitEvent()

		if (this.need_refresh_data) {
			this.UpdateItem()
			this.need_refresh_data = false
		}
	}

	SetData(data?){
		this.data = data
		if (this.is_loaded) {
			this.UpdateItem()
		} else {
			this.need_refresh_data = true
		}
	}

	SetStartPos(anch_x?, anch_y?){
		if (!anch_x) {
			anch_x = 0
		}
		if (!anch_y) {
			anch_y = 0
		}
		this.start_pos = new Vector2(anch_x, anch_y)
	}

	UpdateItem (){

		if (!this.data) {
			return
		}

		let view_class = window["BossTargetSubItem"]
		if(!view_class) return
		if (this.item_loop_mgr) {
			this.item_loop_mgr.replaceAll(this.data)
		} else {
			this.item_loop_mgr = new LoopScrowViewMgr()
			this.item_loop_mgr.SetData(this._list_item, view_class, this.data, LoopScrCon.Horizontal)
		}
	}

	SwitchItem = (index?) => {
		let attackObj = this.data[index]
		if (attackObj && attackObj._type) {
			if (attackObj._type && attackObj._type == SceneBaseType.Monster) {
				if (!attackObj.vo || !this.boss_scene_mgr.JudgeTired(null, null, attackObj.vo.type_id)) {
					return
				}
				this.boss_scene_mgr.SetAutoState(true)
				this.boss_model.CheckDomainBossMsg()
			} else {
				let canFight = SceneManager.GetInstance().IsCanAttackByMainRole(attackObj.vo, false, true)
				if (!canFight) {
					this.boss_scene_mgr.SetAutoState(true)
					return
				}
				this.boss_scene_mgr.SetAutoState(false)
			}
			this.boss_scene_mgr.SetAttackTarget(attackObj)
			Scene.GetInstance().SetClickTarget(attackObj)
			this.auto_fight_mgr.SetAutoFight(true)
			this.boss_model.Fire(BossModel.CHANGE_BOSS_TARGET, attackObj)
		} else if (attackObj && attackObj.role_id && attackObj.role_id == this.role_mgr.GetMainRoleId()) {
			Message.show("无法攻击自己!")
		} else {
			Message.show("大妖已死亡!")
		}
	}

	ScrollerChangeHandler(){
		// if (this._item_scroller && this._item_scroller.viewport ) {
		// 	let now = this._item_scroller.viewport.scrollV
		// 	let max = this._item_scroller.viewport.contentHeight - this._item_scroller.viewport.height
		// 	this._scrollerV = now
		// 	this._img.visible = now < max
		// }
	}

	public DeleteMe() {

		if (this.item_loop_mgr) {
			this.item_loop_mgr.DeleteMe()
		}
		this.item_loop_mgr = undefined
		super.DeleteMe()
	}


	_img_bg: Laya.Image
	_list_item: Laya.List
	public GetComponents() {
		[
			this._img_bg,
			this._list_item,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_list_item",
			])
	}
}
window["BossTargetItem"] = BossTargetItem