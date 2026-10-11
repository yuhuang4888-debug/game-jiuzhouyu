import { BaseClass } from "../common/BaseClass"
import { LayerManager } from "../common/LayerManager"
import { table } from "../common/table"
import { RoleManager } from "../commonModel/RoleManager"
import { GameMath } from "../util/GameMath"
import { CameraManager } from "./CameraManager"
import { Scene } from "./Scene"
import { SceneManager } from "./SceneManager"

let local_GameMath = GameMath
let local_table = table
let local_Laya = Laya
export class SapManager extends BaseClass {

	static Instance: SapManager
	static ObjType =
		{
			JumpPoint: 1,
			NPC: 2,
			Door: 3,
			Tile: 4,
			Effect: 5,
			Drop: 6,
		}

	static OperateType =
		{
			CreateOBJ: 1,
			DestoryOBJ: 2,
		}

	callback_func_list = []
	s_list = []
	_state = []
	last_update_time = 0
	lastCamPos = { x: 0, y: 0 }
	layer_mgr;
	public constructor() {
		super()
		this.layer_mgr = LayerManager.GetInstance()
	}

	public static GetInstance() {

		if (SapManager.Instance == null) {
			SapManager.Instance = new SapManager()
		}
		return SapManager.Instance
	}

	/* func结构
		operate.操作类型
		type.对象类型
		data.自定义数据
	*/
	public RegisterCallbackFunc(func?) {


		local_table.insert(this.callback_func_list, func)
	}

	/*   obj结构
		id.对象索引
		obj_type.对象类型 SapManager.ObjType
		pos.坐标 co.TableXY
		size.大小 co.TableXY
	*/
	public RegisterObj(obj?) {

		let id = `${obj.type}-${obj.id}`
		if (!this.s_list[id]) {
			obj.rect = {
				x1: obj.pos.x - obj.size.x / 2,
				y1: obj.pos.y,
				x2: obj.pos.x + obj.size.x / 2,
				y2: obj.pos.y + obj.size.y
			}

			this.s_list[id] = obj
			this._state[id] = false
		} else {
			console.warn("SapManager:RegisterObj id is registered", id)
		}
	}

	public UnRegisterObj(obj_type?, obj_index?) {

		let id = `${obj_type}-${obj_index}`
		if (this.s_list[id]) {
			if (this._state[id]) {
				let obj = this.s_list[id]
				for (let k in this.callback_func_list) {
					var func = this.callback_func_list[k]
					func(local_SapManager.OperateType.DestoryOBJ, obj.type, obj.data)
				}
			}
			delete this.s_list[id]
			delete this._state[id]
		}
	}

	public InRect(r1, r2) {
		return r1.x2 > r2.x1 && r1.x1 < r2.x2 && r1.y2 > r2.y1 && r1.y1 < r2.y2
	}

	public Update(cam_pos_x?: number, cam_pos_y?: number, force?) {

		if (!force) {
			if (cam_pos_x == this.lastCamPos.x && cam_pos_y == this.lastCamPos.y) {
				return
			}

			if (local_Laya.timer.currTimer * 0.001 - this.last_update_time < 0.5) {
				return
			}
		}

		this.last_update_time = local_Laya.timer.currTimer * 0.001
		this.lastCamPos.x = cam_pos_x
		this.lastCamPos.y = cam_pos_y
		let now_width = this.layer_mgr.stageWidth * 1.1
		let now_height = this.layer_mgr.stageHeight * 1.1
		let ct =
		{
			x1: cam_pos_x - now_width / 2,
			y1: cam_pos_y - now_height / 2,
			x2: cam_pos_x + now_width / 2,
			y2: cam_pos_y + now_height / 2,
		}

		let create_list = null
		let deleta_list = null

		for (let id in this.s_list) {
			var obj = this.s_list[id]
			if (this.InRect(ct, obj.rect)) {
				if (!this._state[id]) {
					this._state[id] = true
					if (create_list == null) {
						create_list = []
					}
					local_table.insert(create_list, id)
				}
			} else {
				if (this._state[id]) {
					this._state[id] = false
					if (deleta_list == null) {
						deleta_list = []
					}
					local_table.insert(deleta_list, id)
				}
			}
		}

		if (deleta_list) {
			//console.warn("------deleta_list------", deleta_list.length)
			for (let key in deleta_list) {
				var id = deleta_list[key]
				let obj = this.s_list[id]
				for (let k in this.callback_func_list) {
					var func = this.callback_func_list[k]
					func(local_SapManager.OperateType.DestoryOBJ, obj.type, obj.data)
				}
			}
		}

		if (create_list) {
			//console.warn("------create_list------", create_list.length)
			let sort_func = (a?, b?) => {
				let i = this.s_list[a]
				let j = this.s_list[b]
				let di = local_GameMath.GetDistance(i.pos.x, i.pos.y, this.lastCamPos.x, this.lastCamPos.y, true)
				let dj = local_GameMath.GetDistance(j.pos.x, j.pos.y, this.lastCamPos.x, this.lastCamPos.y, true)
				if (di < dj) {
					return true
				}
			}
			local_table.sort(create_list, sort_func)

			for (let key = 0; key < create_list.length; key++) {
				var id = create_list[key]
				let obj = this.s_list[id]
				for (let k in this.callback_func_list) {
					var func = this.callback_func_list[k]
					func(local_SapManager.OperateType.CreateOBJ, obj.type, obj.data)
				}
			}
		}
	}

	/**
	 * 刷新一次视野
	 */
	public RefreshView() {
		let main_role_vo = RoleManager.GetInstance().GetMainRoleVo()
		if (Scene.GetInstance().IsSceneLoaded()) {
			SapManager.GetInstance().Update(main_role_vo.pos_x, main_role_vo.pos_y, true)
		}
	}
}
var local_SapManager = SapManager
window["SapManager"] = SapManager