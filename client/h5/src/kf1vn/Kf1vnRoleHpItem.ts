import { BaseItem1 } from "../common/BaseItem1"
import { SceneEventType } from "../common/EventName"
import { Kf1vnModel } from "../commonModel/Kf1vnModel"
import { SceneManager } from "../scene/SceneManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"

//敌人血条
export class Kf1vnRoleHpItem extends BaseItem1 {
	hp_change_event_id
	model
	needRefresh
	role_add_event_id
	role_vo
	vo

	public constructor(parent?) {
		super(parent)

		this.base_file = "kf1vn"
		this.layout_file = "Kf1vnRoleHpItem"
		this.model = Kf1vnModel.GetInstance()
		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvents()
		}
	}

	public DeleteMe() {

		if (this.hp_change_event_id && this.role_vo) {
			this.role_vo.UnBind(this.hp_change_event_id)
			this.hp_change_event_id = null
		}
		if (this.role_add_event_id) {
			GlobalEventSystem.UnBind(this.role_add_event_id)
			this.role_add_event_id = null
		}
		super.DeleteMe()
	}

	public LoadSuccess() {


	}
	public InitEvents() {

		this.BindEvent(GlobalEventSystem, SceneEventType.ROLE_VO_REMOVE, (role_id?) => {
			if (this.vo && this.vo.player_id == role_id) {
				this.SetData(this.vo)
			}
		}
		)
		if (this.needRefresh) {
			this.SetData(this.vo)
		}
	}

	public SetData(vo?) {

		this.vo = vo
		if (this.is_loaded && this.vo) {
			this.txt.text = "【S" + this.vo.server_num + "】 " + this.vo.name
			if (this.role_vo) {
				if (this.hp_change_event_id) {
					this.role_vo.UnBind(this.hp_change_event_id)
					this.hp_change_event_id = null
				}
			}
			this.role_vo = SceneManager.GetInstance().GetRoleVo(this.vo.player_id)
			if (!this.role_vo) {
				this.SetProgress(0, -1)
				if (this.role_add_event_id) {
					GlobalEventSystem.UnBind(this.role_add_event_id)
					this.role_add_event_id = null
				}
				let onAddRoleHandler = (role_id?, role_vo?) => {
					if (this.vo && this.vo.player_id == role_id) {
						this.role_vo = role_vo
						this.SetProgress(this.role_vo.hp, this.role_vo.maxHp)
						this.BindHpChangeEvent()
						if (this.role_add_event_id) {
							GlobalEventSystem.UnBind(this.role_add_event_id)
							this.role_add_event_id = null
						}
					}
				}

				this.role_add_event_id = GlobalEventSystem.Bind(SceneEventType.ROLE_VO_ADD, onAddRoleHandler)
			} else {
				this.SetProgress(this.role_vo.hp, this.role_vo.maxHp)
				this.BindHpChangeEvent()
			}
		} else {
			this.needRefresh = true
		}
	}

	public BindHpChangeEvent() {

		if (this.role_vo) {
			if (this.hp_change_event_id) {
				this.role_vo.UnBind(this.hp_change_event_id)
				this.hp_change_event_id = null
			}
			this.hp_change_event_id = this.role_vo.BindOne("hp", (varName?, value?) => {
				this.SetProgress(value, this.role_vo.maxHp)
			}
			)
		}
	}

	public SetProgress(value?, max?) {

		if (max == -1) {
			this.txt.text = `${this.vo.name}(击败)`
			this.progress_front.width = 0
		} else {
			if (value <= 0) {
				this.txt.text = `${this.vo.name}(击败)`
				this.progress_front.width = 0
				return
			}
			this.txt.text = value + "/" + max
			this.progress_front.width = Number(value) / Number(max) * 232
		}

	}

	progress_bg: Laya.Image
	progress_front: Laya.Image
	txt: Laya.Label
	public GetComponents() {
		[
			this.progress_bg,
			this.progress_front,
			this.txt,
		]
			= this.GetChildrenByNames([

				"progress_bg",
				"progress_front",
				"txt",
			])
	}
}
window["Kf1vnRoleHpItem"] = Kf1vnRoleHpItem