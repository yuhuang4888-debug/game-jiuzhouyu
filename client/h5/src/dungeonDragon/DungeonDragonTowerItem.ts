import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseItem1 } from "../common/BaseItem1"
import { SceneEventType } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { Scene } from "../scene/Scene"
import { SceneManager } from "../scene/SceneManager"
import { SceneObj } from "../scene/sceneobj/SceneObj"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { SetSizeDeltaX, Util } from "../util/Util"
import { Vector2 } from "../util/Vector2"

export class DungeonDragonTowerItem extends BaseItem1 {
	BindHp
	DeleteMe
	InitEvent
	LoadSuccess
	RefreshHp
	SetTwoerTypeId
	UnBindHp
	UpdateTowerVo
	UpdateView
	hp_id
	index
	need_refresh_data
	tower_id
	tower_vo

	//血条
	circle_mask: Laya.Sprite = null
	CreatShape
	ClearShape
	PrintShape

	public static ProgressWidth = 147;
	public constructor(parent?) {
		super(parent)

		this.base_file = "dungeonDragon"
		this.layout_file = "DungeonDragonTowerItem"
		let scene = Scene.GetInstance()
		let local_GlobalEventSystem = GlobalEventSystem
		let local_SceneEventType = SceneEventType
		this.load_callback = () => {
			this.CreatShape()
			this.LoadSuccess()
		}

		this.LoadSuccess = () => {
			this.InitEvent()
			if (this.need_refresh_data) {
				this.UpdateView()
				this.need_refresh_data = false
			}
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._gp_con, () => {
				if (this._Image1.gray) {
					Message.show("目标已被摧毁")
					return
				}
				if (this.tower_vo && this.tower_vo.type_id == this.tower_id) {
					let real_x = this.tower_vo.pos_x / SceneObj.GetLogicRealRatio().x
					let real_y = this.tower_vo.pos_y / SceneObj.GetLogicRealRatio().y
					scene.SetClickTarget(null)
					AutoFightManager.GetInstance().SetAutoFight(false)
					scene.MainRoleMove(new Vector2(real_x, real_y), 0, () => {
						AutoFightManager.GetInstance().SetAutoFight(true)
					})
				}
			}
				, this, true)
			this.BindEvent(local_GlobalEventSystem, local_SceneEventType.MONSTER_VO_ADD, (instance_id?, monster_vo?) => {
				if (monster_vo.type_id == this.tower_id) {
					this.UpdateTowerVo()
				}
			}
			)
			this.BindEvent(local_GlobalEventSystem, local_SceneEventType.MONSTER_VO_REMOVE, (ins_id?, type_id?, vo?) => {
				if (type_id == this.tower_id) {
					this.UnBindHp()
					this._img_hp.visible=false
					this.PrintShape(0)
					this._lb_hp.text = "0%"
					this._Image1.gray = true
				}
			}
			)
		}

		this.SetTwoerTypeId = (index?, tower_id?) => {
			this.tower_id = Number(tower_id)
			this.index = index + 1
			if (this.is_loaded) {
				this.UpdateView()
			} else {
				this.need_refresh_data = true
			}
		}

		this.BindHp = () => {
			this.UnBindHp()
			this._img_hp.visible=true
			this.hp_id = this.tower_vo.BindOne("hp", (event_name?, a?, b?) => {
				this.RefreshHp(event_name, a)
			})
			this.RefreshHp()
		}

		this.RefreshHp = (event_name?, value?) => {
			if (this.tower_vo&& this.hp_id) {
				let v = value || this.tower_vo.hp
				if (v == 0) {
					this.UnBindHp()
				}
				this.PrintShape(Math.floor(v / this.tower_vo.maxHp* 100)/100)
				this._Image1.gray = v <= 0
				this._lb_hp.text = Math.floor(v / this.tower_vo.maxHp * 100) + "%"
			}
		}

		this.UnBindHp = () => {
			if (this.tower_vo && this.hp_id) {
				this.tower_vo.UnBind(this.hp_id)
				this.hp_id = null
			}
		}

		this.UpdateView = () => {
			let index = 104 + this.index * 2
			ResManager.GetInstance().SetImageSprite(this, this._Image1, this.base_file, `ui_copy_${index}`)
			this.UpdateTowerVo()
		}

		this.UpdateTowerVo = () => {
			let tower_vo = SceneManager.GetInstance().GetMonsterVoByTypeId(this.tower_id)
			this.tower_vo = tower_vo
			if (tower_vo) {
				this.BindHp()
			}
		}



		this.CreatShape = () => {
			this.circle_mask = new Laya.Sprite()
			this.circle_mask.x = this._img_hp.width / 2
			this.circle_mask.y = this._img_hp.height / 2
			this._img_hp.mask = this.circle_mask
		}

		this.ClearShape = () => {
			if (this.circle_mask && !this.circle_mask.destroyed) {
				this.circle_mask.removeSelf()
				this.circle_mask.destroy()
				this.circle_mask = null
			}
		}

		this.PrintShape = (angle) => {
			if (!this.circle_mask) return
			angle = 1 - angle
			this.circle_mask.graphics.clear();
			this.circle_mask.graphics.drawPie(0, 0, 50, 90, 360 + 90 - angle * 360, 0x000000)
		}



		this.DeleteMe = () => {
			this.ClearShape()
			this.UnBindHp()
			this.tower_vo = null
			super.DeleteMe()
		}





	}

	_gp_con: Laya.Box
	_Image1: Laya.Image
	_Image2: Laya.Image
	_img_hp: Laya.Image
	_img_bg: Laya.Image
	_lb_hp: Laya.Label
	public GetComponents() {
		[
			this._gp_con,
			this._Image1,
			this._Image2,
			this._img_hp,
			this._img_bg,
			this._lb_hp,
		]
			= this.GetChildrenByNames([

				"_gp_con",
				"_Image1",
				"_Image2",
				"_img_hp",
				"_img_bg",
				"_lb_hp",
			])
	}
}
window["DungeonDragonTowerItem"] = DungeonDragonTowerItem