import { BaseComponent } from "../../common/BaseComponent"
import { ObjectEventType, SceneEventType } from "../../common/EventName"
import { Enum_UILayer, LayerManager } from "../../common/LayerManager"
import { ResManager } from "../../common/ResManager"
import { table } from "../../common/table"
import { ParticleManager } from "../../particalEffect/ParticleManager"
import { GlobalEventSystem } from "../../util/DeclareGlobalVar"
import { GameResPath } from "../../util/GameResPath"
import { Runner } from "../../util/Runner"
import { Status } from "../../util/Status"
import { Set3DLocalPosition, SetLocalScale, SetLocalScaleY, Util } from "../../util/Util"
import { CameraManager } from "../CameraManager"
import { MapManager } from "../MapManager"
import { Scene } from "../Scene"
import { SceneRotateX, SceneRotateY } from "../SceneConfig"
import { SceneManager } from "../SceneManager"
import { SceneObj } from "../sceneobj/SceneObj"


export enum EarlyWarnType{
	Circle = 1,
	Line,
	Sector,
	Cross
}
window["EarlyWarnType"] = EarlyWarnType

let local_EarlyWarnType = EarlyWarnType
//技能预警
export class EarlyWarningManager extends BaseComponent {
	warn_list = {}

	scene: Scene
	runner: Runner
	map_mgr :MapManager
	res_mgr:ResManager

	temp_obj:Laya.MeshSprite3D
	static Instance: EarlyWarningManager
	public constructor() {
		super()
		if (EarlyWarningManager.Instance) {
			return
		}

		EarlyWarningManager.Instance = this

		this.scene = Scene.GetInstance()
		this.runner = Runner.GetInstance()
		this.map_mgr = MapManager.GetInstance()
		this.res_mgr = ResManager.GetInstance()

		this.runner.AddRunObj(this, 1)

		let dead_fun = (ins_id?, type_id?, vo?) => {
			this.DeleteAllWarningById(ins_id)
		}
		GlobalEventSystem.Bind(SceneEventType.MONSTER_VO_REMOVE, dead_fun)

		let update_move_fun = (x?, y?, id?) => {
			this.RefershWarningPos(x, y, id)
		}
		GlobalEventSystem.Bind(ObjectEventType.MONSTER_MOVE, update_move_fun)
		// GlobalEventSystem.Bind(ObjectEventType.ROLE_MOVE, update_move_fun)
	}

	public static GetInstance() {

		if (!EarlyWarningManager.Instance) {
			EarlyWarningManager.Instance = new EarlyWarningManager()
		}
		return EarlyWarningManager.Instance
	}

	//预警更新函数
	public Update(now_time?, elapse_time?) {

		if (this.warn_list){
			let type_list
			let list
			let img
			let warn_max_scale
			let warn_all_time
			let warn_stop_time
			let gap
			let warn_max_scale_height
			for(let owner_id in this.warn_list){
				type_list = this.warn_list[owner_id]
				if (type_list){
					for(let warn_type in type_list){
						list = type_list[warn_type]
						if (list){
							if (list.end_time && list.count_down){
								if (list.end_time - Status.NowTime <= list.count_down && !list.showing_count_down){
									this.ShowCountDown(owner_id, warn_type)
								}
							}
							warn_all_time = list.warn_all_time
							if (Number(warn_type) == local_EarlyWarnType.Cross){
								if (list.cross_list && list.cross_list_scale){
									let vo 
									for(let i = 0; i < list.cross_list.length; i++){
										vo = list.cross_list[i]
										warn_max_scale = list.cross_list_scale[i]
										if (vo && warn_max_scale && vo.width <= warn_max_scale * 100){
											gap = (warn_max_scale * 100) * elapse_time / warn_all_time
											vo.width = vo.width + gap
											// gap = (warn_max_scale * 100) * elapse_time / warn_all_time
											// img.width = img.width + gap
										}
									}
								}
							}else{
								warn_max_scale_height = list.warn_max_scale_height
								warn_max_scale = list.warn_max_scale
								img = list.warn_img
								if (img && warn_max_scale && warn_all_time){
									if (Number(warn_type) == local_EarlyWarnType.Circle){
										gap = (warn_max_scale - 0) * elapse_time / warn_all_time
										if (img.scaleX <= warn_max_scale && img.scaleX + gap < warn_max_scale) {
											img.scaleX = img.scaleX + gap
											img.scaleY = img.scaleY + gap
										} else {
											img.scaleX = img.scaleY = warn_max_scale
										}
									}else if (Number(warn_type) == local_EarlyWarnType.Line){
										if (img.width <= warn_max_scale * 100){
											gap = (warn_max_scale * 100) * elapse_time / warn_all_time
											img.width = img.width + gap
										}
									}else if (Number(warn_type) == local_EarlyWarnType.Sector){
										if (warn_max_scale_height){
											let gap = (warn_max_scale - 0) * elapse_time / warn_all_time
											let gap2 = (warn_max_scale * warn_max_scale_height - 0) * elapse_time / warn_all_time
											if (img.scaleX <= warn_max_scale && img.scaleX + gap < warn_max_scale) {
												img.scaleX = img.scaleX + gap
												img.scaleY = (img.scaleY + gap2)
											} else {
												img.scaleX = warn_max_scale
												img.scaleY = warn_max_scale * warn_max_scale_height
											}
										}
									}
								}
							}
							warn_stop_time = list.warn_stop_time
							if (warn_stop_time){
								if (Status.NowTime - warn_stop_time >= 0) {
									this.DeleteWarning(owner_id, warn_type)
								}
							}
						}
					}
				}
			}
		}
	}

	//显示预警
	public ShowWarning(owner_id?, warn_type?, area?, time?, pos?, distance?, attack_angle?, count_down?) {

		this.DeleteWarning(owner_id, warn_type)
		if (!owner_id || !warn_type){
			return
		}
		if (warn_type == local_EarlyWarnType.Circle){
			if (area == undefined || time == undefined){
				return
			}
		}else if (warn_type == local_EarlyWarnType.Line || warn_type == local_EarlyWarnType.Sector){
			if (area == undefined || time == undefined || distance == undefined || pos == undefined || attack_angle == undefined){
				return
			}
		}

		attack_angle = attack_angle || 0
		if (warn_type == local_EarlyWarnType.Cross){
			this.CreatWarningImg(owner_id, warn_type, area, time, pos, distance, attack_angle, count_down)
			this.CreatWarningImg(owner_id, warn_type, area, time, pos, distance, attack_angle + 180, count_down)
			let angle = this.GetCrossAnger(attack_angle)
			this.CreatWarningImg(owner_id, warn_type, area, time, pos, distance, angle, count_down)
			this.CreatWarningImg(owner_id, warn_type, area, time, pos, distance, angle + 180, count_down)
		}else{
			this.CreatWarningImg(owner_id, warn_type, area, time, pos, distance, attack_angle, count_down)
		}
	}

	//十字预警的另一个角度
	public GetCrossAnger(attack_angle?) {
		let radian = attack_angle * Math.PI / 180
		let cos_x = Math.cos(radian + Math.PI / 2)
		let cos_y = Math.sin(radian + Math.PI / 2) / 2
		let cross_radian = Math.atan2(cos_y, cos_x)
		let angle = 180 * cross_radian / Math.PI + 360
		return Number(angle)
	}

	public CreatWarningImg(owner_id?, warn_type?, area?, time?, pos?, distance?, attack_angle?, count_down?) {

		// egret.log("attack_angle+++++++++++++++++++:", attack_angle)
		if (attack_angle > 360){
			attack_angle = attack_angle - 360
		}
		if (!this.warn_list){
			this.warn_list = {}
		}
		if (!this.warn_list[owner_id]){
			this.warn_list[owner_id] = {}
		}
		if (!this.warn_list[owner_id][warn_type]){
			this.warn_list[owner_id][warn_type] = {}
		}
		let warn_img = new Laya.Image()
		let external_warn_img = new Laya.Image()
		if (warn_type == local_EarlyWarnType.Cross){
			if (!this.warn_list[owner_id][warn_type].cross_list){
				this.warn_list[owner_id][warn_type].cross_list = []
			}
			if (!this.warn_list[owner_id][warn_type].external_cross_list){
				this.warn_list[owner_id][warn_type].external_cross_list = []
			}
			this.warn_list[owner_id][warn_type].cross_list.push(warn_img)
			this.warn_list[owner_id][warn_type].external_cross_list.push(external_warn_img)
		}else{
			this.warn_list[owner_id][warn_type].warn_img = warn_img
			this.warn_list[owner_id][warn_type].external_warn_img = external_warn_img
		}
		this.warn_list[owner_id][warn_type].warn_all_time = time
		this.warn_list[owner_id][warn_type].end_time = Status.NowTime + time
		this.warn_list[owner_id][warn_type].warn_stop_time = Status.NowTime + time
		this.warn_list[owner_id][warn_type].count_down = count_down
		
		let scale_height = 1
		let scale_width = 1
		let bevel_angle = attack_angle
		let warn_max_scale = 1
		if (warn_type == local_EarlyWarnType.Circle){
			warn_max_scale = area / (150 - 10) //10偏移
		} else if (warn_type == local_EarlyWarnType.Line || warn_type == local_EarlyWarnType.Cross){
			scale_height = area / 100 //* (0.7 + Math.abs(Math.sin(radian))*0.3) * extra
			scale_width = distance / 100 //* (0.5 + Math.abs(Math.cos(radian))*0.5)
			warn_max_scale = scale_width

			// let radian = attack_angle * Math.PI / 180
			// bevel_angle = - (attack_angle % 45 % 30 % 10)
			// let extra = 1 / Math.abs(Math.cos(bevel_angle * Math.PI / 180)) 
			// scale_height = area / 100 * (0.7 + Math.abs(Math.sin(radian))*0.3) * extra
			// scale_width = distance / 100 * (0.5 + Math.abs(Math.cos(radian))*0.5)
			// warn_max_scale = scale_width

			if (!this.warn_list[owner_id][warn_type].cross_list_scale){
				this.warn_list[owner_id][warn_type].cross_list_scale = []
			}
			this.warn_list[owner_id][warn_type].cross_list_scale.push(warn_max_scale)
		} else if (warn_type == local_EarlyWarnType.Sector){
			let radian = attack_angle * Math.PI / 180
			scale_height = (0.5 + Math.abs(Math.sin(radian))*0.5)
			scale_width = distance / 100 * (0.5 + Math.abs(Math.cos(radian))*0.5)
			warn_max_scale = scale_width
			this.warn_list[owner_id][warn_type].warn_max_scale_height = scale_height
		}
		if (warn_type != local_EarlyWarnType.Cross){
			this.warn_list[owner_id][warn_type].warn_max_scale = warn_max_scale
		}
		
		LayerManager.GetInstance().GetUILayer(Enum_UILayer.Shadow).addChild(warn_img);
		LayerManager.GetInstance().GetUILayer(Enum_UILayer.Shadow).addChild(external_warn_img);
		let call_fun = () => {
			if (this.use_delete_method || !warn_img || !warn_img.parent){
				return
			}
			if (warn_type == local_EarlyWarnType.Circle){
				warn_img.height = warn_img.height * 0.5
				warn_img.anchorX = 0.5
				warn_img.anchorY = 0.5
				warn_img.scaleX = warn_img.scaleY = 0
			} else if (warn_type == local_EarlyWarnType.Line || warn_type == local_EarlyWarnType.Cross){
				warn_img.anchorX = 0
				warn_img.anchorY = 0.5
				warn_img.sizeGrid = "40,40,40,40"
				warn_img.width = 80
				warn_img.height = scale_height * 100
				// warn_img.skewX = Number(bevel_angle)
				warn_img.rotation = attack_angle
			} else if (warn_type == local_EarlyWarnType.Sector){
				warn_img.anchorX = 0.5;
				warn_img.anchorY = 0.5;
				warn_img.scaleX = 0
				warn_img.scaleY = 0
				warn_img.rotation = attack_angle
			}
			warn_img.x = pos.x
			warn_img.y = pos.y
		}
		let external_call_fun = () => {
			if (this.use_delete_method || !external_warn_img  || !external_warn_img.parent){
				return
			}
			if (warn_type == local_EarlyWarnType.Circle){
				external_warn_img.height = external_warn_img.height * 0.5
				external_warn_img.anchorX = 0.5;
				external_warn_img.anchorY =  0.5;
				external_warn_img.scaleX = external_warn_img.scaleY = warn_max_scale
			} else if (warn_type == local_EarlyWarnType.Line || warn_type == local_EarlyWarnType.Cross){
				external_warn_img.anchorX = 0;
				external_warn_img.anchorY =  0.5;
				external_warn_img.sizeGrid = "40,40,40,40"
				external_warn_img.width = scale_width * 100
				external_warn_img.height = scale_height * 100
				// external_warn_img.skewX = Number(bevel_angle)
				external_warn_img.rotation = attack_angle
			} else if (warn_type == local_EarlyWarnType.Sector){
				external_warn_img.anchorX = external_warn_img.width * 0.5;
				external_warn_img.anchorY = 0.5;
				external_warn_img.scaleX = scale_width
				external_warn_img.scaleY = scale_width * scale_height
				external_warn_img.rotation = attack_angle
			}
			external_warn_img.x = pos.x
			external_warn_img.y = pos.y
		}
		let img_sour = "circle_in"
		let external_img_sour = "circle_out"
		if (warn_type == local_EarlyWarnType.Line || warn_type == local_EarlyWarnType.Cross){
			img_sour = "line_in"
			external_img_sour = "line_out"
		}else if (warn_type == local_EarlyWarnType.Sector){
			img_sour = "uicjgx_004"
			external_img_sour = "uicjgx_003"
		}
		
		this.res_mgr.SetImageSpriteTrans(this, warn_img, GameResPath.GetIcon("common4", img_sour), false, call_fun)
		this.res_mgr.SetImageSpriteTrans(this, external_warn_img, GameResPath.GetIcon("common4", external_img_sour), false, external_call_fun)
	}

	//停止预警
	public StopWarning(owner_id?, warn_type?, stop_time?) {

		if ((this.warn_list && this.warn_list[owner_id]) && this.warn_list[owner_id][warn_type]) {
			if (this.warn_list[owner_id][warn_type].warn_max_scale) {
				this.warn_list[owner_id][warn_type].warn_max_scale = null
			}
			if (this.warn_list[owner_id][warn_type].cross_list_scale) {
				this.warn_list[owner_id][warn_type].cross_list_scale = null
			}
			if (stop_time > 0) {
				this.warn_list[owner_id][warn_type].warn_stop_time = Status.NowTime + stop_time
			} else {
				this.DeleteWarning(owner_id, warn_type)
			}
		}
	}

	//删除预警
	public DeleteWarning(owner_id?, warn_type?) {

		if (this.warn_list && this.warn_list[owner_id] && this.warn_list[owner_id][warn_type]){
			if (Number(warn_type) == local_EarlyWarnType.Cross){
				if (this.warn_list[owner_id][warn_type].cross_list && this.warn_list[owner_id][warn_type].external_cross_list){
					let list = this.warn_list[owner_id][warn_type].cross_list
					let external_list = this.warn_list[owner_id][warn_type].external_cross_list
					for(let i = 0; i < list.length; i++){
						this.RemoveImgFromParent(list[i], external_list[i])
					}
				}
				this.warn_list[owner_id][warn_type].cross_list = null
				this.warn_list[owner_id][warn_type].external_cross_list = null
			}else{
				this.RemoveImgFromParent(this.warn_list[owner_id][warn_type].warn_img, this.warn_list[owner_id][warn_type].external_warn_img)
			}
			this.warn_list[owner_id][warn_type].warn_max_scale = null
			this.warn_list[owner_id][warn_type].cross_list_scale = null
			this.warn_list[owner_id][warn_type].warn_stop_time = null
			this.warn_list[owner_id][warn_type].warn_all_time = null
			this.warn_list[owner_id][warn_type].warn_max_scale_height = null
			if (this.warn_list[owner_id][warn_type].showing_count_down){
				this.StopShowCountDown(owner_id)
				this.warn_list[owner_id][warn_type].showing_count_down = null
			}
			this.warn_list[owner_id][warn_type] = null
			delete this.warn_list[owner_id]
			// if (Util.IsTableEmpty(this.warn_list)){
				
			// }
		}
	}

	//destory控件
	public RemoveImgFromParent(img_obj?, external_img_obj?) {

		if (img_obj) {
			img_obj.destroy()
			img_obj = null
		}
		if (external_img_obj) {
			external_img_obj.destroy()
			external_img_obj = null
		}
	}

	//删除所有的预警
	public DeleteAllWarning() {

		if (this.warn_list) {
			let list = null
			for (let owner_id in this.warn_list) {

				list = this.warn_list[owner_id]
				if (list) {
					for (let warn_type in list) {

						this.DeleteWarning(owner_id, warn_type)
					}
				}
			}
		}
	}

	//通过怪物id删除预警
	public DeleteAllWarningById(id?) {

		if (this.warn_list && id) {
			let list = null
			list = this.warn_list[id]
			if (list) {
				for (let warn_type in list) {
					this.DeleteWarning(id, warn_type)
				}
			}
		}
	}

	//刷新位置
	public RefershWarningPos(x?, y?, owner_id?) {
		if (this.warn_list && this.warn_list[owner_id]){
			let list
			let vo 
			for(let warn_type in this.warn_list[owner_id]){
				list = this.warn_list[owner_id][warn_type]
				if (list){
					if (Number(warn_type) == local_EarlyWarnType.Cross){
						if (list.cross_list && list.external_cross_list){
							for(let i = 0; i < list.cross_list.length; i++){
								vo = list.cross_list[i]
								if (vo){
									vo.x = x
									vo.y = y
								}
							}
							for(let i = 0; i < list.external_cross_list.length; i++){
								vo = list.external_cross_list[i]
								if (vo){
									vo.x = x
									vo.y = y
								}
							}
						}
					}else{
						if (list.warn_img && list.external_warn_img){
							list.warn_img.x = x
							list.warn_img.y = y
							list.external_warn_img.x = x
							list.external_warn_img.y = y
						}
					}
				}
			}
		}
	}

	public ShowCountDown(owner_id?, warn_type?) {

		if (this.warn_list[owner_id] && this.warn_list[owner_id][warn_type] && !this.warn_list[owner_id][warn_type].showing_count_down
			&& this.warn_list[owner_id][warn_type].count_down) {
			let mon = this.scene.GetMonster(owner_id)
			if (mon) {
				this.warn_list[owner_id][warn_type].showing_count_down = true
				mon.hide_nameboard = true
				mon.hide_name_by_model = false
				mon.SetHideNameBord(false)
				if (mon.name_board) {
					//mon.name_board.StartCountDownTimer(this.warn_list[owner_id][warn_type].count_down)
				}
			}
		}
	}

	public StopShowCountDown(owner_id?) {

		if (owner_id) {
			let mon = this.scene.GetMonster(owner_id)
			if (mon && mon.name_board) {
				//mon.name_board.ClearCountDownTimer()
			}
		}
	}
}
window["EarlyWarningManager"] = EarlyWarningManager