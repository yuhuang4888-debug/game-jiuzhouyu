import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseItem1 } from "../common/BaseItem1"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { BossSceneManager } from "../commonController/BossSceneManager"
import { BossModel } from "../commonModel/BossModel"
import { PK_STATUS } from "../commonModel/PkStatusModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Scene } from "../scene/Scene"
import { SceneBaseType } from "../scene/SceneConfig"
import { SceneManager } from "../scene/SceneManager"
import { Message } from "../sysInfo/SysInfoController"
import { RefBoxChildsLayout } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { BossTargetPanelItem } from "./BossTargetPanelItem"

export class BossTargetPanel extends BaseItem1 {
	InitEvent
	LoadSuccess
	Scr_item_scroller
	ScrollerChangeHandler
	SetData
	SetStartPos
	SwitchItem
	UpdateItem
	auto_fight_mgr
	boss_model
	boss_scene_mgr
	item_loop_mgr
	need_refresh_data
	role_mgr
	startPos
	vo_list

	item_list


	public constructor(parent?) {
		super(parent)
		this.base_file = "boss"
		this.layout_file = "BossTargetPanel"
		this.layer_value = "Main"
		this.need_refresh_data = false
		this.role_mgr = RoleManager.GetInstance()
		this.boss_scene_mgr = BossSceneManager.GetInstance()
		this.auto_fight_mgr = AutoFightManager.GetInstance()
		this.boss_model = BossModel.GetInstance()
		this.item_list=[]
		
		this.load_callback = () => {
			
			this._scroller.hScrollBarSkin=""
			this.LoadSuccess()
		}

		this.InitEvent = () => {

			this.BindEvent(this.boss_scene_mgr, BossSceneManager.SWITCH_ITEM, (index?) => {
				this.SwitchItem(index)
			})

			this.BindVar(this.role_mgr.GetMainRoleVo(), "pk_status", (event_name?, pk_status?) => {
				if ((pk_status == PK_STATUS.Peace && this.boss_scene_mgr.GetAttackTarget()) && this.boss_scene_mgr.GetAttackTarget()._type == SceneBaseType.Role) {
					this.auto_fight_mgr.SetAutoFight(false)
					this.boss_scene_mgr.SetAttackTarget(null)
				}
			}
			)
		}

		this.LoadSuccess = () => {
			this.InitEvent()

			if (this.need_refresh_data) {
				this.UpdateItem()
				this.need_refresh_data = false
			}
		}

		this.SetData = (data?) => {
			this.vo_list = data
			if (this.is_loaded) {
				this.UpdateItem()
			} else {
				this.need_refresh_data = true
			}
		}

		this.SetStartPos = (anch_x?, anch_y?) => {
			if (!anch_x) {
				anch_x = 0
			}
			if (!anch_y) {
				anch_y = 0
			}
			this.startPos = new Vector2(anch_x, anch_y)
		}

		this.UpdateItem = () => {

			if (!this.vo_list) {
				return
			}

			let len = this.vo_list.length
			for(let i=0;i<len;i++){
				let item:BossTargetPanelItem = this.item_list[i]
				if (!item) {
					item = new BossTargetPanelItem(this.Content)
					item.Load()
					this.item_list[i] = item
				}
				item.SetVisible(true)
				item.SetData(this.vo_list[i],i)
			}


			for (let p = len ; p < this.item_list.length; p++) {
                if(this.item_list[p])this.item_list[p].SetVisible(false)
			}


			RefBoxChildsLayout(this.Content, 4, 73, true, "left")
            this.Content.width = len * 73 + (len - 1) * 4

		}

		this.SwitchItem = (index?) => {
			let attackObj = this.vo_list[index]
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

		this.ScrollerChangeHandler = () => {
			// if (this._item_scroller && this._item_scroller.viewport ) {
			// 	let now = this._item_scroller.viewport.scrollV
			// 	let max = this._item_scroller.viewport.contentHeight - this._item_scroller.viewport.height
			// 	this._scrollerV = now
			// 	this._img.visible = now < max
			// }
		}
	}

	public DeleteMe() {

		// if (this.item_loop_mgr) {
		// 	this.item_loop_mgr.DeleteMe()
		// }
		// this.item_loop_mgr = false
		for(let i=0;i<this.item_list.length;i++){
			this.item_list[i].DeleteMe()
			this.item_list[i]=null
		}
		this.item_list=[]
		super.DeleteMe()
	}

_Image1:Laya.Image
_Image2:Laya.Image
_num_lb:Laya.Label
_scroller:Laya.Panel
Content:Laya.Box
_img:Laya.Image
public GetComponents() {
[
this._Image1,
this._Image2,
this._num_lb,
this._scroller,
this.Content,
this._img,
]
 = this.GetChildrenByNames([

"_Image1",
"_Image2",
"_num_lb",
"_scroller",
"Content",
"_img",
])
}
}
 window["BossTargetPanel"]= BossTargetPanel