import { BaseComponent } from "../../common/BaseComponent"
import { EventName, SceneEventType } from "../../common/EventName"
import { LayerManager } from "../../common/LayerManager"
import { ResManager } from "../../common/ResManager"
import { SoundManager } from "../../common/SoundManager"
import { ViewManager } from "../../common/ViewManager"
import { GoodsModel } from "../../commonModel/GoodsModel"
import { MainUIModel } from "../../commonModel/MainUIModel"
import { SettingModel } from "../../commonModel/SettingModel"
import { SourceOperateMove } from "../../operation/SourceOperateMove"
import { ParticleManager } from "../../particalEffect/ParticleManager"
import { RoleManager } from "../../commonModel/RoleManager"
import { Message } from "../../sysInfo/SysInfoController"
import { ColorType } from "../../util/ColorUtil"
import { GlobalEventSystem, LOAD_QUEUE } from "../../util/DeclareGlobalVar"
import { EventDispatcher } from "../../util/EventDispatcher"
import { GameMath } from "../../util/GameMath"
import { GameResPath } from "../../util/GameResPath"
import { Mathf } from "../../util/Mathf"
import { Status } from "../../util/Status"
import { GlobalTimerQuest, ResetTransform, Set3DLocalPosition, Set3DLocalRotation, Set3DLocalRotationEuler, Set3DLocalScale, Util } from "../../util/Util"
import { Vector2 } from "../../util/Vector2"
import { Vector3 } from "../../util/Vector3"
import { DropManager } from "../DropManager"
import { Scene } from "../Scene"
import { EffectResType, SceneBaseType, SceneModelScale, SceneRotateX, SceneRotateY } from "../SceneConfig"
import { SceneManager } from "../SceneManager"
import { SceneObj } from "./SceneObj"


export class Drop extends BaseComponent {

	public static ClientCount = 0
	public static CREATE_COUNT = 0

	static ShowType = {
		Box: 0,
		Pic: 2,
		Diamond: 3,
	}

	static Color2BoxModel = {
		[ColorType.BLUE]: "15010061",
		[ColorType.PURPLE]: "15010062",
		[ColorType.ORANGE]: "15010063",
		[ColorType.RED]: "15010064",
		[ColorType.PINK]: "15010065",
	}

	static Is3DModel = (show_type) => {
		if (show_type == Drop.ShowType.Box || show_type == Drop.ShowType.Diamond) {
			return true
		}
		return false
	}

	static DropType = {
		Born: 1,
		//出生
		WaitPick: 2,
		//等待拾取
		StartPick: 3,
		//开始拾取
		EndPick: 4,
		//结束拾取
		Disappear: 5,
		//消失
		Stay: 6,
		//等待
		Move: 7,
		//移动
		Dead: 8
	}

	static Color2Rad = {
		[ColorType.ORANGE]: 200,
		[ColorType.RED]: 100,
		[ColorType.PINK]: 10,
	}


	drop_id
	vo
	load_queue

	/**
	 * 0 普通需要拾取的掉落 1 直接进背包 2也只直接进背包 但是会走客户端模拟的掉落流程
	 */
	show_type
	sound_id


	drop_mgr: DropManager
	scene: Scene
	scene_mgr: SceneManager
	main_role_mgr: RoleManager
	res_mgr: ResManager
	setting_model

	is_in_cache_pool
	// shadow_gameObject

	goods_basic

	state

	move_speed
	add_speed
	is_picking
	can_not_pick
	pick_success
	pick_last_time
	start_pick

	init_state_born
	init_state_wait_pick
	init_state_start_pick
	init_state_end_pick
	init_state_disappear
	init_state_stay
	init_state_move
	create_time
	step_start_time

	parent_transform: Laya.Transform3D
	parent_sprite: Laya.Sprite3D

	icon_sprite: Laya.Sprite3D
	icon_transform: Laya.Transform3D
	icon_material: Laya.UnlitMaterial
	icon_mesh_sprite: Laya.MeshSprite3D

	model_parent_sprite: Laya.Sprite3D
	model_parent_transform: Laya.Transform3D

	effect_parent_sprite: Laya.Sprite3D
	effect_parent_transform: Laya.Transform3D

	model_res_id
	model_res_name

	model_sprite: Laya.Sprite3D
	model_transform: Laya.Transform3D

	icon_res_id
	icon_data

	effect_name
	effect_sprite: Laya.Sprite3D
	effect_transform: Laya.Transform3D
	goods_name

	direction
	curr_rotate = new Laya.Vector3(0, 0, 0)
	direction_angle
	rotate_y

	color
	add_effect_type
	drop_height
	end_pos
	every_time
	h_move_dir
	is_load_effect = false
	max_scale
	move_last_time
	move_dist

	no_anim
	particle_id
	real_pos


	start_pos
	start_scale
	timer
	timer_id
	cur_scale

	particle_dic = {}
	_type
	compress_id
	public constructor() {
		super()

		this._type = SceneBaseType.Drop

		this.drop_mgr = DropManager.GetInstance()
		this.setting_model = SettingModel.GetInstance()
		this.direction = new Vector2()
		this.direction_angle = 90
		this.rotate_y = 0

		//根父容器
		let parent_sprite = new Laya.Sprite3D("Drop" + ++Drop.CREATE_COUNT)
		this.parent_sprite = parent_sprite
		this.parent_transform = parent_sprite.transform

		//初始化图片
		let icon_sprite = new Laya.Sprite3D("Icon")
		parent_sprite.addChild(icon_sprite)

		let icon_mesh_sprite = icon_sprite.addChild(new Laya.MeshSprite3D(Laya.PrimitiveMesh.createPlane(0.5, 0.5, 1, 1))) as Laya.MeshSprite3D
		let mat = new Laya.UnlitMaterial();
		mat.renderMode = Laya.UnlitMaterial.RENDERMODE_TRANSPARENT
		icon_mesh_sprite.meshRenderer.material = mat;

		this.icon_sprite = icon_sprite
		this.icon_mesh_sprite = icon_mesh_sprite
		this.icon_transform = icon_sprite.transform
		// this.icon_transform.localScale = new Laya.Vector3(1, 1, 1)
		Set3DLocalScale(this.icon_transform, 1, 1, 1)
		this.icon_material = mat
		this.icon_sprite.active = false

		//初始化角度
		// this.icon_transform.localRotationEuler = new Laya.Vector3(90, 180, 0)//SceneObj.StartRotate
		Set3DLocalRotationEuler(this.icon_transform, 90, 180, 0)


		//初始化挂接模型节点
		let model_parent_sprite = new Laya.Sprite3D("Model")
		parent_sprite.addChild(model_parent_sprite)
		this.model_parent_sprite = model_parent_sprite
		this.model_parent_transform = model_parent_sprite.transform

		// this.model_parent_transform.localRotation = Laya.Quaternion.DEFAULT
		Util.tempVector3.setValue(0, SceneObj.StartRotate.y, 0)
		this.model_parent_transform.rotate(Util.tempVector3, true, false)
		Util.tempVector3.setValue(SceneObj.StartRotate.x, 0, 0)
		this.model_parent_transform.rotate(Util.tempVector3, true, false)

		//初始化挂接特效节点
		let effect_parent_sprite = new Laya.Sprite3D("Effect")
		parent_sprite.addChild(effect_parent_sprite)
		this.effect_parent_sprite = effect_parent_sprite
		this.effect_parent_transform = effect_parent_sprite.transform
		Util.tempVector3.setValue(0, SceneObj.StartRotate.y, 0)
		this.effect_parent_transform.rotate(Util.tempVector3, true, false)
		Util.tempVector3.setValue(SceneObj.StartRotate.x, 0, 0)
		this.effect_parent_transform.rotate(Util.tempVector3, true, false)





		this.load_queue = LOAD_QUEUE.MIDDLE

		this.scene = Scene.Instance
		this.scene_mgr = SceneManager.Instance
		this.main_role_mgr = RoleManager.GetInstance()
		this.res_mgr = ResManager.GetInstance()

		this.move_speed = 250
		this.start_scale = 0.6
		this.max_scale = 1
		this.every_time = 3 * 60 //多少秒后其他人可以拾取归属掉落

		this.ResetState()
		this.InitEvents()
	}

	public InitTransformData() {
		// this.effect_parent_transform.localPosition = new Laya.Vector3(0, -0.3, 0)
		Set3DLocalPosition(this.effect_parent_transform, 0, 0.3, 0)
	}

	public GetDropVo() {
		return this.vo
	}

	public InitEvents() {
		this.BindEvent(GlobalEventSystem, SceneEventType.CAN_NOT_PICK_SCENE_DROP, (drop_id?) => {
			if (this.drop_id == drop_id) {
				this.can_not_pick = true
				this.is_picking = false
				this.ChangeState(Drop.DropType.WaitPick)
			}
		}
		)

		this.BindEvent(GlobalEventSystem, SceneEventType.START_PICK_SCENE_DROP, (vo?) => {
			if (this.drop_id == vo.drop_id) {
				this.start_pick = true
				this.init_state_start_pick = false
				this.ChangeState(Drop.DropType.StartPick)
			}
		}
		)

		this.BindEvent(GlobalEventSystem, SceneEventType.PICK_SCENE_DROP_SUCCESS, (vo?) => {
			if (this.drop_id == vo.drop_id) {
				this.pick_success = true
				this.start_pick = false
				this.is_picking = false
				this.ChangeState(Drop.DropType.Disappear)
			}
		}
		)

		this.BindEvent(GlobalEventSystem, SceneEventType.DISMISS_SCENE_DROP, (drop_id?) => {
			if (this.drop_id == drop_id) { //and ! this.IsPicking()
				this.is_picking = false
				this.ChangeState(Drop.DropType.Disappear)
			}
		}
		)
	}

	public InitDropVo(vo?) {

		this.vo = vo
		this.no_anim = vo.no_anim
		this.drop_id = vo.drop_id
		this.show_type = vo.show_type
		this.compress_id = Scene.GetInstance().CompressObjId(SceneBaseType.Drop, this.drop_id)

		// if (this.parent_sprite && !this.parent_sprite.activeInHierarchy) {
		// 	this.parent_sprite.active = true
		// }
		LayerManager.GetInstance().Scene3D.addChild(this.parent_sprite)

		this.InitTransformData()

		if (vo) {
			let [goods_Id, lock] = GoodsModel.GetInstance().GetMappingTypeId(vo.drop_type, vo.type_id)
			this.goods_basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(goods_Id)

			if (this.goods_basic) {
				this.color = this.goods_basic.color || 1
				this.goods_name = this.goods_basic.goods_name

				if (Drop.Is3DModel(this.show_type)) {
					this.LoadModel()
				} else if (this.show_type == Drop.ShowType.Pic) {
					this.LoadIcon()
				}
				this.effect_parent_sprite.active = false
			}

			this.create_time = Status.NowTime

			this.StartTime()
			this.SetAlpha(1)


			if (this.show_type == Drop.ShowType.Box) {
				if (vo.no_anim) {
					// this.model_parent_sprite.active = false
					this.SetRealPos(vo.pos_x, vo.pos_y)
					this.ChangeState(Drop.DropType.WaitPick)
					this.SetRotateY(Math.floor(Math.random() * 360))
				} else {
					this.model_parent_sprite.active = false
					this.SetRealPos(vo.mon_pos_x, vo.mon_pos_y)
					this.ChangeState(Drop.DropType.Born)
					vo.no_anim = true //只播放一次 避免出入屏的时候 播放动画
				}
			}
			else if (this.show_type == Drop.ShowType.Pic) {
				this.SetRealPos(vo.mon_pos_x, vo.mon_pos_y)
				this.ChangeState(Drop.DropType.Born)
			}
		}
	}

	public LoadModel() {
		let model_res_id
		if (this.show_type == Drop.ShowType.Box) {
			model_res_id = Drop.Color2BoxModel[this.color] || "15010061"
		} else if (this.show_type == Drop.ShowType.Diamond) {
			model_res_id = "15010037"//"2000145"
		}
		if (model_res_id) {
			let model_res_name = GameResPath.GetModelClotheRes(this._type, model_res_id)

			if (model_res_name) {
				let load_call_back = (obj) => {
					if (Util.IsNull(obj)) {
						console.warn("cannot find res = " + model_res_id)
						return
					}

					if (this.use_delete_method || this.is_in_cache_pool || !this.model_res_name || !model_res_name) {
						obj.destroy()
						return
					}

					let new_entity = obj

					if (this.model_sprite) {
						if (model_res_name == this.model_res_name) {
							this.RemoveAllParticle()
							this.RemoveModelGameObject()
						} else {
							new_entity.destroy() //最后加载的模型不是最新的 就删掉该模型
							return
						}
					}

					this.model_res_id = model_res_id
					this.model_sprite = new_entity

					// this.model_parent_transform.localScale = new Laya.Vector3(1, 1, 1)
					Set3DLocalScale(this.model_parent_transform, 1, 1, 1)
					// this.model_parent_transform.localPosition = new Laya.Vector3(0, 0, 0)
					Set3DLocalPosition(this.model_parent_transform, 0, 0, 0)
					// this.model_parent_transform.localRotation = new Laya.Quaternion(0, 0, 0)

					this.model_transform = new_entity.transform
					this.model_parent_sprite.addChild(this.model_sprite)

					// this.model_transform.localPosition = new Laya.Vector3(0, 0, 0)
					Set3DLocalPosition(this.model_transform, 0, 0, 0)
					// this.model_transform.localRotation = new Laya.Quaternion(0, 0, 0)
					Set3DLocalRotation(this.model_transform, 0, 0, 0)

					if (this.show_type == Drop.ShowType.Diamond) {
						// this.model_transform.localScale = new Laya.Vector3(2, 2, 2)
						Set3DLocalScale(this.model_transform, 2, 2, 2)
					} else {
						// this.model_transform.localScale = new Laya.Vector3(SceneModelScale, SceneModelScale, SceneModelScale)
						Set3DLocalScale(this.model_transform, SceneModelScale, SceneModelScale, SceneModelScale)
					}
				}

				this.model_res_name = model_res_name
				let model_res_full_url = GameResPath.GetTypePath(this._type, model_res_name)
				this.res_mgr.CreatePrefab(this.hashCode, model_res_full_url, load_call_back, this.load_queue)
			}
		}
	}

	public LoadIcon() {
		let goods_icon = this.goods_basic.goods_icon
		let icon_res_id = this.vo.drop_icon
		if (!icon_res_id || icon_res_id.trim() == "" || icon_res_id.trim() == "0") {
			icon_res_id = goods_icon
		}

		let load_call_back = (icon_data) => {
			if (!icon_data) {
				console.warn("cannot find res = " + icon_res_id)
				return
			}

			if (this.use_delete_method || this.is_in_cache_pool || !this.icon_res_id || !icon_res_id) {
				return
			}

			let new_icon_data = icon_data

			if (icon_res_id != this.icon_res_id) {
				// texture.destroy() //最后加载的模型不是最新的 就删掉该模型
				return
			}

			this.icon_data = new_icon_data

			if (this.icon_material) {
				this.icon_material.albedoTexture = icon_data
			} else {
				console.warn("cannot find icon_material ")
			}

		}


		this.icon_res_id = icon_res_id
		let img_full_url = GameResPath.GetGoodsIconPath(icon_res_id)
		this.res_mgr.GetResByUrl(this.hashCode, img_full_url, load_call_back, this, Laya.Loader.IMAGE, this.load_queue, false, this)

		if (this.real_pos) {
			this.UpdateModelPos(this.real_pos.x, this.real_pos.y)
		}
	}

	public LoadBoxEffect() {
		if (this.is_load_effect) {
			return
		}
		this.is_load_effect = true
		// return


		let y_offset = 0
		let effect_name
		if (this.show_type == Drop.ShowType.Box) {
			if (this.color == ColorType.ORANGE) {
				effect_name = "function_common_getobj01"
				y_offset = 0
			} else if (this.color == ColorType.RED) {
				effect_name = "function_common_getobj02"
				y_offset = 0
			} else if (this.color == ColorType.PINK) {
				effect_name = "function_common_getobj03"
				y_offset = 0
			}
		}

		if (effect_name) {
			this.effect_name = effect_name
			this.effect_parent_sprite.active = true
			// this.effect_parent_transform.localPosition = new Laya.Vector3(0, y_offset, 0)
			Set3DLocalPosition(this.effect_parent_transform, 0, -y_offset, 0)
			// this.effect_parent_transform.localRotation = new Laya.Quaternion(0, 0, 0)

			this.ClearEffect()

			// let effect_sprite = this.drop_mgr.GetObjFormPool(this, effect_name)
			// if (effect_sprite) {
			// 	this.add_effect_type = 1
			// 	let transform = effect_sprite.transform
			// 	this.effect_parent_sprite.addChild(effect_sprite)
			// 	transform.setParent(this.effect_parent_transform)
			// 	transform.setLocalPosition(0, 0, 0)
			// 	transform.setLocalRotation(0, 0, 0)
			// 	effect_sprite.active = true
			// 	this.effect_sprite = effect_sprite
			// } else {
			this.add_effect_type = 2
			this.particle_id = ParticleManager.GetInstance().AddTargetEffect(effect_name, this.compress_id, true, null, null, 7, null, null, 1, null, null, null, null, null, EffectResType.Other)
			// }
		} else {
			this.effect_parent_sprite.active = false
		}
	}


	//主动添加挂在自己身上的例子特效
	public AddParticle(id, particle_tranform: Laya.Transform3D) {
		this.effect_parent_sprite.addChild(particle_tranform.owner)
		ResetTransform(particle_tranform)
		this.particle_dic[id] = particle_tranform
	}

	//删除挂在自己身上的特效
	public RemoveParticle(id) {
		delete this.particle_dic[id]
		ParticleManager.GetInstance().DelEffect(id)
	}


	//主动删除挂在自己身上的所有粒子特效
	public RemoveAllParticle() {
		this.is_load_effect = null
		for (let id in this.particle_dic) {
			ParticleManager.GetInstance().DelEffect(id)
		}
		this.particle_dic = {}
	}


	public StartTime() {
		let vo = this.vo
		if (vo.display_time && vo.display_time != 0) {
			this.CancelTimer()
			let time = 0
			let timer_func = () => {
				time = time + 1
				if (time >= vo.display_time) {
					this.CancelTimer()
					if (!this.pick_success) { //and this.state != 9
						//消失
						//this.step_start_time = Status.NowTime
						this.ChangeState(Drop.DropType.Disappear)
						//this.state = 9
					}
					//} else if (time >= this.every_time ) {
					////变成可拾取状态
					//if (! this.pick_success && this.state != 9 ) {
					//this.step_start_time = Status.NowTime
					//this.state = 2
					//}
				}
			}
			if (!this.timer) {
				this.timer = GlobalTimerQuest.AddPeriodQuest(timer_func, 1, -1)
			}
		} else {
			this.CancelTimer()
		}
	}

	public CancelTimer() {

		if (this.timer) {
			GlobalTimerQuest.CancelQuest(this.timer)
			this.timer = null
		}
	}

	public CancelDelayTimer() {

		if (this.timer_id) {
			GlobalTimerQuest.CancelQuest(this.timer_id)
			this.timer_id = null
		}
	}
	public PlaySound(sound_name?) {

		if (!this.CanPlaySound()) {
			return
		}

		if (ViewManager.is_lock_screen) {
			return
		}

		SoundManager.GetInstance().StopSoundEffect(this.sound_id)
		this.sound_id = SoundManager.GetInstance().PlaySoundEffect(sound_name, false)
	}

	public RemoveModelGameObject() {
		if (!Util.IsNull(this.model_sprite)) {
			this.model_sprite.destroy()
		}
		this.model_sprite = null
		this.model_transform = null
		this.model_res_id = null
		this.model_res_name = null
	}

	public Show() {
		this.is_in_cache_pool = false
		return this.parent_sprite.active = true
	}

	public Hide() {
		return this.parent_sprite.active = false
	}

	public GetState() {
		return this.state
	}

	public SetRealPos(posx?, posy?) {
		if (this.real_pos == null) {
			this.real_pos = new Vector2(posx, posy)
		} else {
			this.real_pos.x = posx
			this.real_pos.y = posy
		}
		this.UpdateModelPos(this.real_pos.x, this.real_pos.y) //更新位置到模型
	}

	public GetRealPos() {
		if (this.real_pos == null)
			this.real_pos = new Vector2(0, 0)
		return this.real_pos
	}


	public UpdateModelPos(posx?, posy?) {
		if (this.parent_transform) {
			let z = this.scene_mgr.GetSceneObjDepth(posy)
			// console.warn("------UpdateModelPos------", posx, posy, z)
			Set3DLocalPosition(this.parent_transform, posx * 0.01, posy * 0.01, z)
		}
	}

	public SetScale(scale?) {
		if (scale > this.max_scale) {
			scale = this.max_scale
		}
		// this.parent_transform.localScale = new Laya.Vector3(scale * SceneModelScale, scale * SceneModelScale, scale * SceneModelScale)
		Set3DLocalScale(this.parent_transform, scale * SceneModelScale, scale * SceneModelScale, scale * SceneModelScale)
	}

	//设置身体的位置  真实坐标不变
	public SetBodyXY(x?, y?) {
		if (this.icon_transform) {
			// this.icon_transform.localPosition = new Laya.Vector3(x * 0.01, y * 0.01, 0)
			Set3DLocalPosition(this.icon_transform, -x * 0.01, -y * 0.01, 0)
		}
	}

	public Update(now_time?, elapse_time?) {
		if (this.state == Drop.DropType.Born) { //出生
			this.BornStep(now_time, elapse_time)
		} else if (this.state == Drop.DropType.WaitPick) { //等待拾取
			this.WaitPickStep(now_time, elapse_time)
		} else if (this.state == Drop.DropType.StartPick) { //开始拾取
			this.StartPickStep(now_time, elapse_time)
		} else if (this.state == Drop.DropType.EndPick) { //结束拾取
			this.EndPickStep(now_time, elapse_time)
		} else if (this.state == Drop.DropType.Disappear) { //消失
			this.DisappearStep(now_time, elapse_time)
		} else if (this.state == Drop.DropType.Stay) { //等待
			this.StayStep(now_time, elapse_time)
		} else if (this.state == Drop.DropType.Move) { //飞回玩家
			this.MoveToMainRole(now_time, elapse_time)
		}
	}

	public ChangeState(state?) {
		// console.log("//////DropLog//////@ChangeState","time:",Status.NowTime,"ins_id:",this.hashCode,"drop_id:",this.drop_id,"last_state:",this.state,"now_state:",state,"is_picking:",this.is_picking)
		this.state = state
	}

	public BornStep(now_time?, elapse_time?) {

		let vo = this.vo
		if (!this.init_state_born) {
			if (this.show_type == Drop.ShowType.Pic) {
				this.SetScale(this.max_scale)
				let radian = Util.RandomRange(1, 360) * Math.PI / 180
				this.h_move_dir = new Vector2()
				this.h_move_dir.x = Math.cos(radian)
				this.h_move_dir.y = Math.sin(radian)
				this.h_move_dir.normalise()

				let base_time = 0.25
				this.move_last_time = base_time + Math.random() * base_time * 0.4
				this.drop_height = this.move_last_time / base_time * 250
				this.icon_sprite.active = true
			} else if (this.show_type == Drop.ShowType.Box || this.show_type == Drop.ShowType.Diamond) {
				this.model_parent_sprite.active = true
				this.SetScale(this.start_scale)
				this.start_pos = new Vector2(this.real_pos.x, this.real_pos.y)
				this.end_pos = new Vector2(this.vo.pos_x, this.vo.pos_y)

				let move_dir = new Vector2()
				move_dir.x = this.start_pos.x - this.end_pos.x
				move_dir.y = this.start_pos.y - this.end_pos.y
				let distance = move_dir.normalise()
				this.move_dist = distance
				this.SetDirection(move_dir)
				this.move_last_time = this.move_dist / 400//this.move_speed

				// console.warn("------BornStep1------", Laya.timer.currTimer)
				// this.SetRotateY(180)
			}

			this.step_start_time = now_time
			this.init_state_born = true
		}

		let pase_time = now_time - this.step_start_time
		let p = pase_time / this.move_last_time

		let x, y, height
		if (this.show_type == Drop.ShowType.Pic) {
			x = this.real_pos.x + this.h_move_dir.x * elapse_time * this.move_speed
			y = this.real_pos.y + this.h_move_dir.y * elapse_time * this.move_speed

			this.SetBodyXY(0, Math.sin(p * Math.PI) * this.drop_height)
		} else {
			let cur_scale = Mathf.Lerp(this.start_scale, this.max_scale, p)
			this.SetScale(cur_scale)

			let new_obj_h = this.move_dist * 3 * (p - p * p)
			x = Mathf.Lerp(this.start_pos.x, this.end_pos.x, p)
			y = Mathf.Lerp(this.start_pos.y, this.end_pos.y, p) - new_obj_h


			// console.warn("------BornStep------", p, x, y, cur_scale)
		}
		if (x && y) {
			this.SetRealPos(x, y)
		}

		if (pase_time > this.move_last_time) {
			// console.warn("------BornStep2------", Laya.timer.currTimer)
			this.step_start_time = now_time
			this.OnEndBornStep()
			if (Drop.Is3DModel(this.show_type)) {
				this.ChangeState(Drop.DropType.WaitPick)
			} else {
				this.ChangeState(Drop.DropType.Stay)
			}
			this.init_state_born = false
		}
	}

	public OnEndBornStep() {

		if (this.show_type == Drop.ShowType.Pic) { return }

		let x = this.end_pos.x, y = this.end_pos.y
		if (x && y) {
			this.SetRealPos(x, y)
		}
	}

	// show_type: 0 宝箱
	public WaitPickStep(now_time?, elapse_time?) {

		if (!this.init_state_wait_pick) {
			this.step_start_time = now_time
			this.init_state_wait_pick = true

			if (this.show_type == Drop.ShowType.Box) {
				this.LoadBoxEffect()
			}
		}
	}

	//开始拾取
	public StartPickStep(now_time?, elapse_time?) {

		if (!this.init_state_start_pick && this.start_pick) {
			this.step_start_time = now_time
			this.pick_last_time = now_time + this.vo.pick_up_time + 0.2 //加0.1s容错
			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "DropProgress", this.pick_last_time)
			//console.log("//////开始拾取//////",now_time)
			this.init_state_start_pick = true
		}

		if (this.pick_last_time && now_time > this.pick_last_time) {
			//console.log("//////拾取结束//////",now_time)
			GlobalEventSystem.Fire(SceneEventType.REQUEST_PICK_UP_SCENE_DROP, this.vo.drop_id)
			this.ChangeState(Drop.DropType.EndPick)
			this.init_state_start_pick = false
			this.pick_last_time = false
		}
	}

	//拾取结束
	public EndPickStep(now_time?, elapse_time?) {

		if (!this.init_state_end_pick && this.start_pick) {
			this.step_start_time = now_time
			this.init_state_end_pick = true
		}

		if (this.pick_success) {
			this.start_pick = false
			this.ChangeState(Drop.DropType.Disappear)
			this.init_state_end_pick = false
		}
	}

	// 消失
	public DisappearStep(now_time?, elapse_time?) {

		if (!this.init_state_disappear) {
			this.step_start_time = now_time
			this.init_state_disappear = true
			this.ShowDropTip()
		}

		let t = now_time - this.step_start_time

		let alpha = 1 - t / 0.3

		if (alpha < 0) {
			alpha = 0
			this.ChangeState(Drop.DropType.Dead)
			this.init_state_disappear = false
		}

		this.SetAlpha(alpha)
	}

	//飞到主角身上
	public MoveToMainRole(now_time?, elapse_time?) {

		if (!this.init_state_move) {
			this.h_move_dir = new Vector2()

			this.move_last_time = 1
			this.step_start_time = now_time
			this.init_state_move = true
		}

		let main_role_vo = this.main_role_mgr.GetMainRoleVo()
		let pase_time = now_time - this.step_start_time
		let scale = (this.max_scale - (pase_time / this.move_last_time * 0.2)) * this.parent_transform.localScale.x

		this.SetScale(scale)

		this.h_move_dir.x = main_role_vo.pos_x - this.real_pos.x
		this.h_move_dir.y = main_role_vo.pos_y - this.real_pos.y

		let dist_with_main_role = this.h_move_dir.normalise()

		if (dist_with_main_role <= 30) {
			this.SetRealPos(main_role_vo.pos_x, main_role_vo.pos_y)
		} else {
			let x = this.real_pos.x + this.h_move_dir.x * elapse_time * this.add_speed
			let y = this.real_pos.y + this.h_move_dir.y * elapse_time * this.add_speed
			this.SetRealPos(x, y)

			this.add_speed = this.add_speed + this.add_speed * elapse_time
		}

		if (pase_time > this.move_last_time || dist_with_main_role < 30) {
			this.ChangeState(Drop.DropType.Dead)
			this.init_state_move = false
		}
	}

	public StayStep(now_time?, elapse_time?) {

		if (!this.init_state_stay) {
			this.step_start_time = now_time
			this.move_last_time = 1
			this.init_state_stay = true
		}

		if (now_time - this.step_start_time > 1.2) {
			this.ChangeState(Drop.DropType.Move)
			this.init_state_stay = false
		}
	}

	public PickUp() {
		// console.log("//////DropLog//////@PickUp","time:",Status.NowTime,"ins_id:",this.hashCode,"drop_id",this.drop_id,"now_state:",this.state)

		GlobalEventSystem.Fire(SceneEventType.REQUEST_PICK_UP_SCENE_DROP, this.vo.drop_id, this.show_type)
		if (this.vo.pick_up_time != null && this.vo.pick_up_time > 0) {
			//this:ChangeState(Drop.DropType.StartPick)
			this.is_picking = true
		} else {
			this.ChangeState(Drop.DropType.EndPick)
		}

	}

	//超过15秒， 其他人可拾取归属掉落
	public IsOutTime() {

		return Status.NowTime - this.create_time >= this.every_time
	}

	public GetDropId() {

		return this.drop_id
	}

	public CanPlaySound() {

		return !this.no_anim
	}

	public IsFinishState() {

		return this.state == Drop.DropType.Dead
	}

	public ClearEffect() {

		if (this.particle_id) {
			ParticleManager.GetInstance().DelEffect(this.particle_id)
			this.particle_id = null
		}
		if (this.effect_sprite && this.vo) {
			let effect_name = this.effect_name
			this.drop_mgr.AddObjToPool(this, effect_name, effect_name, this.effect_sprite)
		}
		this.effect_name = null
		this.effect_sprite = null
		this.effect_transform = null
		this.add_effect_type = 0
	}
	public ResetObj() {

		this.Show()
	}

	public IsCanPickUp() {

		// 检测装备是否开启自动拾取
		let can_pick = this.setting_model.EquipCanPickUp(this.vo)
		if (!can_pick) {
			return false
		}

		// 出生状态需等到动画完成才能拾取
		let bool = (this.state == Drop.DropType.WaitPick) && !this.can_not_pick && !this.is_picking

		if (bool) {
			let main_role_vo = this.main_role_mgr.GetMainRoleVo()
			if (this.vo.camp > 0 && this.vo.camp != main_role_vo.camp) {
				bool = false
			}
			if (bool) {
				if (this.vo.server_id > 0 && this.vo.server_id != main_role_vo.server_unique_id) {
					bool = false
				}
				if (this.vo.guild_id > 0 && this.vo.guild_id != main_role_vo.guild_id) {
					bool = false
				}
			}

			// if (bool && this.scene_mgr.IsHolyTerritory() && HolyTerritoryModel.GetInstance().IsSelfHT() ) {
			// 	bool = false
			// }

			if (bool) {
				if (this.IsOutTime()) {
					bool = true
				} else if (this.vo.team_id > 0 && this.vo.team_id != main_role_vo.team_id) {
					bool = false
				} else if (this.vo.role_id > 0 && this.vo.role_id != main_role_vo.role_id) {
					bool = false
				}
			}
		}
		return bool
	}

	//正在被拾取中
	public IsPicking() {

		return this.is_picking
	}

	public SetAlpha(alpha?) {
		if (this.icon_material) {
			// console.warn("@@@@@@@@@@@@@@@@@@@@@", alpha, this.icon_material.opacity)
			this.icon_material.albedoColorA = alpha
		}
	}

	public GetPickItemTip() {
		let str = ""
		if (this.vo && this.goods_name) {
			str = "获得 " + this.goods_name + " x " + this.vo.drop_num
		}

		return str
	}

	public ShowDropTip() {
		// if (!this.scene_mgr.IsShowDropRemindScene()) {
		// 	let tip = this.GetPickItemTip()
		// 	if (tip != "" ) {
		// 		Message.show(tip)
		// 	}
		// 	if (this.vo && this.goods_name ) {
		// 		let goods_id = 0
		// 		let drop_num = this.vo.drop_num
		// 		if (this.vo.drop_type == 0 ) {    //物品
		// 			goods_id = this.vo.type_id
		// 		} else if (this.vo.drop_type == 3 ) { //金币
		// 			goods_id = GoodsModel.GetInstance().GetMappingTypeId(this.vo.drop_type)
		// 			MainUIModel.GetInstance().PlayGoodsFlyList({goods_id})
		// 		}
		// 	}
		// }
	}


	//设置方向
	//real_pos 参数是否是具有x y坐标的方向
	public SetDirection(dir1?, dir2?, real_pos?) {

		let angle = null
		if (real_pos) {
			angle = this.scene_mgr.GetAngle(dir1, dir2, real_pos)
		} else {
			angle = this.scene_mgr.GetAngle(dir1.x, dir1.y)
		}
		if (this.direction_angle != angle) {
			this.SetRotateY(angle)
		}
	}

	public SetRotateY(rotate) {
		rotate = rotate % 360

		this.direction_angle = rotate

		let radian = this.direction_angle / 180 * Math.PI
		this.direction.x = Math.cos(radian)
		this.direction.y = Math.sin(radian)
		this.direction.normalise()

		let cur_rotate = - this.direction_angle + 90
		this.curr_rotate.y = cur_rotate - this.rotate_y
		this.model_parent_transform.rotate(this.curr_rotate, true, false)
		this.rotate_y = cur_rotate
	}

	public IsNeedPickTime() {
		return this.vo.pick_up_time != null && this.vo.pick_up_time > 0
	}

	public ReleaseObj() {

		this.is_in_cache_pool = true
		this.no_anim = false
		this.parent_sprite.removeSelf()
		this.Hide()
		this.CancelTimer()
		this.CancelDelayTimer()
		this.RemoveModelGameObject()
		this.ClearEffect()

		if (this.sound_id) {
			SoundManager.GetInstance().StopSoundEffect(this.sound_id)
			this.sound_id = null
		}
		this.SetScale(this.max_scale)
		if (this.rotate_y != 0) {
			this.curr_rotate.y = -this.rotate_y
			this.model_parent_transform.rotate(this.curr_rotate, true, false)
		}
		this.rotate_y = 0
		this.direction_angle = 90

		this.icon_sprite.active = false
		if (this.icon_data) {
			this.icon_material.albedoTexture = undefined
		}
		this.icon_data = null
		this.icon_res_id = null

		this.ResetState()
		this.is_load_effect = false

		this.res_mgr.DestroyAllReferenceRes(this.hashCode)
	}

	public ResetState() {
		this.add_speed = 700
		this.state = 0 //  1 出生动画 2 静止地面等待拾取  3 等待发送协议 4 飞到角色身上 9 变透明
		this.is_picking = false

		this.can_not_pick = false
		this.pick_success = false
		this.pick_last_time = false

		this.init_state_born = false
		this.init_state_wait_pick = false
		this.init_state_start_pick = false
		this.init_state_end_pick = false
		this.init_state_disappear = false
		this.init_state_stay = false
		this.init_state_move = false
		this.create_time = 0 //记录掉落创建时间
		this.step_start_time = 0 // 步骤的开始时间
	}

	public DeleteMe() {

		this.ClearEffect()
		this.CancelTimer()
		this.CancelDelayTimer()
		this.RemoveModelGameObject()
		this.RemoveAllParticle()

		if (!Util.IsNull(this.parent_sprite)) {
			this.parent_sprite.destroy()
		}

		this.parent_sprite = null
		this.parent_transform = null

		this.icon_sprite = null
		this.icon_transform = null
		this.icon_material = null

		this.model_parent_sprite = null
		this.model_parent_transform = null

		this.effect_parent_sprite = null
		this.effect_parent_transform = null

		super.DeleteMe()
	}

}
window["Drop"] = Drop