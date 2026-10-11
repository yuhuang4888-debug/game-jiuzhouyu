import { BaseItem1 } from "../common/BaseItem1"
import { FigureProtoVo } from "../common/FigureProtoVo"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { UIModelClass3D, UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { ArenaModel } from "../commonModel/ArenaModel"
import { TaskTipType } from "../commonModel/TaskModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneBaseType } from "../scene/SceneConfig"
import { SceneManager } from "../scene/SceneManager"
import { SetAnchoredPosition, Util, Color } from "../util/Util"
import { Vector3 } from "../util/Vector3"

export class ArenaEnterRoleItem extends BaseItem1 {
	_img_bg: Laya.Image
	_gp_role: Laya.Box
	_img_down_bg: Laya.Image
	_Group1: Laya.Box
	_Image1: Laya.Image
	_lb_floor_count: Laya.Label
	_Group2: Laya.HBox
	_Image2: Laya.Image
	_lb_fight: Laya.Label
	_gp_ok: Laya.Box
	_img_ok: Laya.Image
	_lb_ok: Laya.Label
	_lb_name: Laya.Label
	Emp_gp_ok
	challage_state
	index
	len
	line_lb_ok
	model
	need_refresh_data
	need_refresh_pos
	parent_mask
	pos
	role_mgr
	role_model
	story_obj_list
	time_list
	vo

	public constructor(parent?) {
		super(parent)


		this.vo = null
		this.pos = null
		this.role_model = null
		this.challage_state = null
		this.time_list = []

		this.base_file = "arena"
		this.layout_file = "ArenaEnterRoleItem"
		this.model = ArenaModel.GetInstance()
		this.role_mgr = RoleManager.GetInstance()
		this.need_refresh_data = false
		this.need_refresh_pos = false

		this.load_callback = () => {

			this.LoadSuccess()
			this.InitEvent()
			// if (PlatformMgr.GetInstance().IsEyouIdnPlatform()) {
			// 	this._lb_floor_count.size = 18
			// }
		}


	}

	public createChildren() {
		if (this["GetComponents"]){
			this["GetComponents"]()
			this.is_get = true
		}
		if ((this.model.guide_info && this.vo) && this.vo.rank == this.model.guide_info.rank) {
			this.story_obj_list = this.story_obj_list || {}
			this.story_obj_list[TaskTipType.JoinJcc] = []
			this.story_obj_list[TaskTipType.JoinJcc][this.model.guide_info.rank] = [this._gp_ok]
		}
		super.createChildren()
	}

	public LoadSuccess() {

		let bg_url = "uijb_0"
		let down_url = "uijd_0"
		if (this.vo && this.vo.rank <= 3) {
			bg_url = "uijb_" + this.vo.rank
			down_url = "uijd_" + this.vo.rank
		}
		// ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, "resource/game/arena/texture/" + bg_url + ".png", true)
		// ResManager.GetInstance().SetImageSprite(this, this._img_down_bg, "arena_asset", down_url, true)

		if (this.need_refresh_data) {
			this.need_refresh_data = false
			this.UpdateView()
		}

		if (this.need_refresh_pos) {
			SetAnchoredPosition(this.display_obj, this.pos[0], this.pos[1])
		}
	}

	public InitEvent() {

		Util.AddClickEvent(this._gp_ok, () => {
			if (this.vo) {
				this.model.enemy_fight = this.vo.combat
				ArenaModel.GetInstance().Fire(ArenaModel.REQUEST_CCMD_EVENT, 28003, this.model.GetMyRank(), this.vo.role_id, this.vo.rank, this.challage_state)
			}
		}, this, true)
	}

	public UpdateView() {

		if (this.vo) {
			this._lb_name.text = this.vo.name
			if(this.vo.combat>10000000){
				this._lb_fight.fontSize=18
			}else{
				this._lb_fight.fontSize=22
			}
			this._lb_fight.text ="战力:"+ this.vo.combat
			this._lb_floor_count.text = this.vo.rank
			// LayoutRebuilder(this._Group2)

			this.CreateModel()

			this.UpdateInfo()
		}
	}

	public UpdateInfo() {

		if (this.vo) {
			let my_rank = this.model.GetMyRank()
			if (my_rank > 0 && this.vo.rank > this.model.GetMyRank()) {
				this.challage_state = 1
				this._img_ok.skin = "resource/game/arena/texture/ui_button_rect3.png"
				this._lb_ok.text = "扫荡"
				this._lb_ok.strokeColor="#c95b37"
				// this.line_lb_ok.effectColor = Color(204 / 255, 118 / 255, 82 / 255, 1)
			} else {
				this.challage_state = 0
				this._img_ok.skin = "resource/game/common/texture/com_rect_btn1.png"
				let str = "挑战"
				this._lb_ok.text = str
				this._lb_ok.strokeColor="#c95b37"
				// this.line_lb_ok.effectColor = Color(130 / 255, 171 / 255, 32 / 255, 1)
			}
		}

	}

	public SetData(vo?, index?, len?) {

		this.vo = vo
		this.index = index
		this.len = len
		if (this.is_loaded) {
			this.UpdateView()
		} else {
			this.need_refresh_data = true
		}
	}

	public SetLocalPos(x?, y?) {

		this.pos = [x, y]
		if (this.is_loaded) {
			SetAnchoredPosition(this.display_obj, this.pos[0], this.pos[1])
		} else {
			this.need_refresh_pos = true
		}
	}

	public SetMask(parent_mask?) {

		this.parent_mask = parent_mask
	}

	public CreateModel() {

		let mainvo=RoleManager.GetInstance().GetMainRoleVo()
		let [head_id, head_texture_id] = Util.GetRoleHeadId(this.vo)
		let [clothe_id, clothe_texture_id] = Util.GetRoleClotheId(this.vo)

		let weapon_res = Util.GetWeaponClotheId(this.vo)
		let wing_res = Util.GetWingClotheId(this.vo)//mainvo.GetFigureId(this.vo.figure_list, FigureProtoVo.FigureType.Wing)
		let horse_res = mainvo.GetFigureId(FigureProtoVo.FigureType.Horse)
		let back_ornament_res =  Util.GetBackOrnamentId(this.vo)
		let liveness_id =  Util.GetLivenessId(this.vo)

		let create_callback = () => {
			let delay_fun
			delay_fun = () => {
				if (this.use_delete_method) {
					return
				}

				if (this.role_model && this.role_model.CheckIsLoading()) {
					table.insert(this.time_list, setTimeout(delay_fun, 0.1))
					return
				}

				// let cur_model = ResManager.GetInstance().GetPartModel(this, this._gp_role)
				// SceneManager.GetInstance().SetModelMaskShader(this.parent_mask, cur_model)
				this._gp_role.visible = true
			}
			// table.insert(this.time_list, setTimeout(delay_fun, 0.55))
		}

		// if (this.index <= this.len - 2) {
		// 	this._gp_role.visible = false
		// }
		let data = {
			career : this.vo.career,
			sex : this.vo.sex,
			type : UI_MODEL_TYPE.ROLE,
			layer_value : Enum_UILayer.UI,
			clothe_res_id : clothe_id,
			fashion_model_id : clothe_id,
			texture_id : clothe_texture_id,
			head_wear_id : head_id,
			head_clothe_id : head_texture_id,
			weapon_res_id : weapon_res,
			wing_id : wing_res,
			//horse_id = horse_res,
			position : new Vector3(0, 2.3, 0),
			scale : 0.6,
			load_call_back : create_callback,
			back_ornament_id: back_ornament_res,
			liveness_id: liveness_id
		}
		let r_model = ResManager.GetInstance().SetRoleModel(this, this._gp_role, data)
		// this.role_model = r_model[this._gp_role]

	}

	public DeleteMe() {

		if (this.time_list.length > 0) {
			for (let k in this.time_list) {
				var v = this.time_list[k]
				clearTimeout(v)
			}
			this.time_list = []
		}

		this.role_model = null
		super.DeleteMe()
	}

	public ReOpen_callback() {

		this.CreateModel()
	}


	public GetComponents() {
		[
			this._img_bg,
			this._gp_role,
			this._img_down_bg,
			this._Group1,
			this._Image1,
			this._lb_floor_count,
			this._Group2,
			this._Image2,
			this._lb_fight,
			this._gp_ok,
			this._img_ok,
			this._lb_ok,
			this._lb_name,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_gp_role",
				"_img_down_bg",
				"_Group1",
				"_Image1",
				"_lb_floor_count",
				"_Group2",
				"_Image2",
				"_lb_fight",
				"_gp_ok",
				"_img_ok",
				"_lb_ok",
				"_lb_name",
			])
	}
}
window["ArenaEnterRoleItem"]=ArenaEnterRoleItem