
import { Vector2 } from "../../util/Vector2";
import { GameResPath } from "../../util/GameResPath";
import { Scene } from "../Scene";
import { AttachNode, EffectResType, ParticleAttachNode, PrintParticleInfo, SceneBaseType, SceneRotateX, SceneRotateY } from "../SceneConfig";
import { BaseClass } from "../../common/BaseClass";
import { StateMachineManager, PoseState } from "../../util/StateMachineManager";
import { Config } from "../../common/Config";
import { SceneManager } from "../SceneManager";
import { ParticleManager } from "../../particalEffect/ParticleManager";
import { ResManager } from "../../common/ResManager";
import { LayerManager, Enum_UILayer } from "../../common/LayerManager";
import { GlobalEventSystem, LOAD_QUEUE } from "../../util/DeclareGlobalVar";
import { ObjectEventType } from "../../common/EventName";
import { GetMaterialTexture, GetParams, GetSkinnedMeshSprite3D, ResetTransform, Set3DLocalPosition, Set3DLocalRotationEuler, Set3DLocalScale, SetLocalPosition, SetMaterialTexture, Util } from "../../util/Util";
import { NameBoardManager } from "../sceneboard/NameBoardManager";
import { Clothe } from "./Clothe";
import { TalkBoard } from "../sceneboard/TalkBoard";
import { FestivalBaseView } from "../../festival/FestivalBaseView";
import { GlobalTimerQuest } from "../../util/Util";
import { ErlangParser } from "../../util/ErlangParser";
let local_Math = Math
let local_Config_PRELOAD_CLIENT_CONFIG = Config.PRELOAD_CLIENT_CONFIG
let local_Vector2 = Vector2
let local_Laya = Laya
let local_SceneBaseType = SceneBaseType
let local_Util = Util
let local_GameResPath = GameResPath
let local_LayerManager = LayerManager
let local_Set3DLocalPosition = Set3DLocalPosition
let local_Set3DLocalScale = Set3DLocalScale
let local_GetParams = GetParams
let local_PoseState = PoseState
let local_ResManager //= ResManager这里赋值会有循环没有import完就使用的问题，改在实例化后赋值
export class SceneObj extends BaseClass {
	/**
	 * 2D地图 逻辑像素和真实像素的x,y比例
	 */
	static LogicRealRatio2D = new local_Vector2(60, 30)

	/**
	 * 2.5d场景对象基础旋转角度
	 */
	static StartRotate = new local_Laya.Vector3(SceneRotateX, SceneRotateY, 0)

	/**
	* 身体最大高度
	*/
	static MaxBodyHeight = 270

	/**
	 * 模型隐藏标识
	 */
	static ModelHideFlag = {
		/**
		 * 技能隐藏
		 */
		Skill: 0x002,
		/**
		 * 场景里的玩家数量过多时，要隐藏其他玩家  怪物也是这个字段
		 */
		RoleNumLimit: 0x004,
		/**
		 * 服务端隐藏
		 */
		ServerHide: 0x008,
		/**
		 * 单独隐藏自己 不依赖于主人 适用于精灵伙伴的单独隐藏
		 */
		IndependentHide: 0x010,
		/**
		 * 跟随物同步主角隐藏专用标志位
		 */
		IndependenRole: 0x020,
		/**
		 * 竞技场隐藏
		 */
		Arena: 0x040,
		All: 0
	}

	/**
	 * 获取逻辑坐标/真实坐标比例
	 * @returns 
	 */
	 public static GetLogicRealRatio() {
		return local_SceneObj.LogicRealRatio2D
	}

	/**
	 * 状态机
	 */
	protected _state_machine_manager: StateMachineManager = new StateMachineManager(this, "ChangeStateEnter", "ChangeStateLeave")

	/**
	 * 角色方向单位向量
	 */
	direction = new local_Vector2(0, -1)

	/**
	 * 角色朝向的旋转角度  右边朝向为0度 顺时针增加
	 */
	direction_angle = 90 

	/**
	 * 是否在缓存中
	 */
	is_in_cache_pool = false

	/**
	 * ID
	 */
	id

	/**
	 * 场景对象数据源
	 */
	vo

	/**
	 * 是否可以被拣选
	 */
	can_pick = true

	/**
	 * 模型资源大小 也就是衣服
	 */
	model_res_size = new local_Vector2(90, 160)

	/**
	 * 总的资源大小 包括坐骑等
	 */
	res_size = new local_Vector2(90, 160)

	/**
	 * 缩放值
	 */
	scale = 1


	/**
	 * 模型隐藏标识
	 */
	model_hide_flag = 0

	/**
	 * 当前角色角度
	 */
	curr_rotate: Laya.Vector3 = new local_Laya.Vector3(0, 0, 0)

	/**
	 * Y轴旋转
	 */
	rotateY = 0

	/**
	 * 逻辑坐标
	 */
	logic_pos:Vector2 = new local_Vector2(0, 0)

	/**
	 * 真实坐标
	 */
	real_pos = new local_Vector2(0, 0) 

	/**
	 * 是否需要更新talkboard
	 */
	update_talk_board = false

	/**
	 * 透明度
	 */
	alpha

	/**
	 * 姓名
	 */
	name = ""

	/**
	 * 身体高度
	 */
	curr_model_y
	
	/**
	 * ID
	 */
	compress_id

	/**
	 * 模型隐藏状态
	 */
	is_model_hiden

	/**
	 * 默认贴图
	 */
	default_main_texture
	
	/**
	 * 总的旋转量
	 */
	all_rotate_off
	
	/**
	 * 特效列表
	 */
	particle_list 

	/**
	 * 身体特效字典
	 */
	body_effect_dic

	/**
	 * 场景对象是特效时的id
	 */
	body_effect_id

	/**
	 * 隐藏姓名板的状态
	 */
	hide_nameboard
	/**
	 * 特效播放速度
	 */
	particle_speed = 1

	/**
	 * 是否忽略缓存
	 */
	ignore_pool

	/**
	 * 场景对象类型 SceneBaseType
	 */
	_type
	
	/**
	 * 姓名板对象
	 * NameBoard
	 */
	name_board

	/**
	 * 脚下阴影对象
	 */
	shadow_gameObject: Laya.Image

	/**
	 * 基础速度
	 */
	custom_speed

	/**
	 * 默认模型缩放
	 */
	default_model_scale = 1.1

	/**
	 * 对话的定时器
	 */
	talk_timer

	/**
	 * 正在显示对话
	 */
	talk_ing

	/**
	 * 根据模型隐藏的姓名板状态
	 */
	hide_name_by_model

	/**
	 * 模型资源名字
	 */
	model_res
	model_res_url

	cache_model_res
	cache_ignore_pool
	cache_force_load_clothe_type

	talk_board: TalkBoard
	scene: Scene
	scene_mgr: SceneManager
	particle_mgr: ParticleManager

	root_transform: Laya.Transform3D
	modelObj_transform: Laya.Transform3D
	gameObject: Laya.Sprite3D
	transform: Laya.Transform3D
	animator: Laya.Animator
	skin_mesh_renderer: Laya.SkinnedMeshSprite3D

	
	public constructor() {
		super()
		local_ResManager = ResManager
		if(!local_SceneObj.ModelHideFlag.All)
		{
			local_SceneObj.ModelHideFlag.All = local_SceneObj.ModelHideFlag.Skill
				+ local_SceneObj.ModelHideFlag.RoleNumLimit + local_SceneObj.ModelHideFlag.ServerHide
				+ local_SceneObj.ModelHideFlag.IndependentHide
				+ local_SceneObj.ModelHideFlag.IndependenRole
				+ local_SceneObj.ModelHideFlag.Arena
		}

		this._type = local_SceneBaseType.Unknown

		this.scene_mgr = SceneManager.GetInstance()
		this.particle_mgr = ParticleManager.GetInstance()
		this.scene = Scene.Instance

		//根父容器
		this.root_transform = new local_Laya.Sprite3D().transform
		local_Set3DLocalScale(this.root_transform, this.default_model_scale, this.default_model_scale, this.default_model_scale)

		//模型对象父容器
		this.modelObj_transform = new local_Laya.Sprite3D().transform
		this.root_transform.owner.addChild(this.modelObj_transform.owner)


		//脚下阴影
		this.shadow_gameObject = new local_Laya.Image()
		local_ResManager.GetInstance().SetImageSprite(this, this.shadow_gameObject, "common4", "shadow")
		this.shadow_gameObject.anchorX = this.shadow_gameObject.anchorY = 0.5
		this.shadow_gameObject.scaleX = this.shadow_gameObject.scaleY = 2
		local_LayerManager.GetInstance().GetUILayer(Enum_UILayer.Shadow).addChild(this.shadow_gameObject)
	}

	

	/**
	 * 设置是否可以点选
	 * @param value 
	 */
	public SetPickInfo(value?) {
		this.can_pick = value
	}

	/*
		没有加载的情况
	*/
	public ExcuteCreateClotheSpriteFinished() {


	}

	/**
	 * 创建衣服
	 * @param role_res 资源id
	 * @param ignore_pool 忽略缓存
	 * @param force_load_clothe_type 强制设置资源类型
	 * @returns 
	 */
	public CreateClotheSprite(role_res, ignore_pool?, force_load_clothe_type?, load_level = LOAD_QUEUE.LOW) {
		if (role_res == null) {
			return
		}
		if (role_res == 0 && this.vo && this.vo.effect_res) {
			if (this.vo.effect_res != "") {
				//只创建特效 没有模型
				this.model_res_size.x = 150
				let height = local_Config_PRELOAD_CLIENT_CONFIG.ConfigSceneObjHeight.EffectBound[this.vo.effect_res]
				if (height) {
					this.model_res_size.y = height * (this.default_model_scale + 0.1)
				}
				this.res_size.x = this.model_res_size.x
				this.res_size.y = this.model_res_size.y

				this.CreateBodyParticleEffect()
				this.SetScale()
			}
			this.ExcuteCreateClotheSpriteFinished()
			return
		}
		this.ignore_pool = ignore_pool	//忽略缓存 不存入缓存 也不从缓存中取
		if (this.model_res && this.model_res != 0 && this.model_res == role_res && !this.ignore_pool) {
			if (this['fashion_res']) {
				this["ChangeClothe"](this['fashion_res'])
			} else {
				if (!local_Util.IsNull(this.skin_mesh_renderer) && this.default_main_texture) {
					let unlit_material: Laya.UnlitMaterial = this.skin_mesh_renderer.skinnedMeshRenderer.material as Laya.UnlitMaterial
					SetMaterialTexture(unlit_material, this.default_main_texture)
				}
			}
			this.ExcuteCreateClotheSpriteFinished()
			return
		}

		let local_model_res_type = force_load_clothe_type || this.GetType()
		let local_model_res_name = local_GameResPath.GetModelClotheRes(local_model_res_type, role_res)

		this.SetShadowVisible(true)

		let model_res_url = local_GameResPath.GetTypePath(local_model_res_type, local_model_res_name)

		let params = {
			module: this._type == local_SceneBaseType.MainRole ? "main_role" : local_GameResPath.GetTypeModuleName(local_model_res_type),
			name: "Scene",
			id: this.scene_mgr.GetSceneId(),
		}

		model_res_url += local_GetParams(params)
		this.model_res_url = model_res_url

		var load_call_back = (obj: Laya.Sprite3D) => {
			if (local_Util.IsNull(obj)) {
				console.warn("cannot find res = " + role_res)
				return
			}
			if (this.use_delete_method || this.is_in_cache_pool || !this.model_res_url) {
				local_ResManager.GetInstance().AddSprite3DToPool(this.hashCode, obj.url, obj)
				return
			}
			if (this.gameObject) {
				if (model_res_url == this.model_res_url) { //最后加载的模型是最新的
					this.LoadSameResCallback()
				} else {
					local_ResManager.GetInstance().AddSprite3DToPool(this.hashCode, obj.url, obj)
					return
				}
			}

			this.model_res = role_res
			this.gameObject = obj

			if (local_LayerManager.GetInstance().Scene3D.getChildIndex(this.root_transform.owner) == -1) {
				local_LayerManager.GetInstance().Scene3D.addChild(this.root_transform.owner)

				this.modelObj_transform.localRotation = local_Laya.Quaternion.DEFAULT
				local_Util.tempVector3.setValue(0, local_SceneObj.StartRotate.y, 0)
				this.modelObj_transform.rotate(local_Util.tempVector3, true, false)
				local_Util.tempVector3.setValue(local_SceneObj.StartRotate.x, 0, 0)
				this.modelObj_transform.rotate(local_Util.tempVector3, true, false)

				if (this.rotateY != 0) {
					this.curr_rotate.y = this.rotateY
					this.modelObj_transform.rotate(this.curr_rotate, true, false)
				}
			}
			this.root_transform.owner.name = this.compress_id
			local_Set3DLocalPosition(this.modelObj_transform)
			local_Set3DLocalScale(this.modelObj_transform)

			this.transform = obj.transform
			this.modelObj_transform.owner.addChild(obj)
			local_Set3DLocalPosition(this.transform)
			Set3DLocalRotationEuler(this.transform)

			this.animator = obj.getComponent(local_Laya.Animator)

			let skin_mesh_renderer = local_Util.GetComponent(obj, local_Laya.SkinnedMeshSprite3D)
			if(skin_mesh_renderer){

				this.ResetMaterialsProperty(skin_mesh_renderer)
				//第一个为默认材质
				this.skin_mesh_renderer = skin_mesh_renderer
				let unlit_material: Laya.UnlitMaterial = this.skin_mesh_renderer.skinnedMeshRenderer.material as Laya.UnlitMaterial
				this.default_main_texture = GetMaterialTexture(unlit_material)
			}

			this.model_res_size.x = 150
			if (this.skin_mesh_renderer) {
				let mesh_size_y = this.skin_mesh_renderer.skinnedMeshRenderer.localBounds.getExtent().x * 2 * 0.79 //cos38 模型倾斜角度
				let height = local_Config_PRELOAD_CLIENT_CONFIG.ConfigSceneObjHeight[role_res]
				if (height) {
					this.model_res_size.y = height * (this.default_model_scale + 0.1)
				} else {
					this.model_res_size.y = mesh_size_y * 100 * this.default_model_scale
				}
			}
			this.res_size.x = this.model_res_size.x
			this.res_size.y = this.model_res_size.y //* local_Math.cos(30 / 180 * local_Math.PI)

			this.BirthAngleChange()
			this.LoadClotheResComplete()	//加载模型资源完成 回调
			this.UpdateModelPos()
			this.SetScale(this.scale) //加载完资源 再重新设置scale
		}

		// //给血条赋值
		// if (this.name_board) {
		// 	this.name_board.SetGameObjectName(this.name || "静态对象")
		// }

		local_ResManager.GetInstance().CreatePrefab(this.hashCode, model_res_url, load_call_back, load_level, ignore_pool)
	}

	protected ResetMaterialsProperty(skin_mesh_renderers)
	{
	}

	protected LoadSameResCallback()
	{
		this.RemoveAllParticle()
		this.RemoveGameObject()
	}

	public BirthAngleChange() {
		if (this.direction_angle != 90) { return }

		if (this.GetCurState() == local_PoseState.MOVE) {
			if (!this.all_rotate_off) {
				this.SetRotateY(this.direction_angle, null, true)
			}
		} else if (this.vo && this.vo.birth_angle != null) {
			this.SetRotateY(this.vo.birth_angle + 90, null, true)
		} else {
			this.SetRotateY(local_Math.floor(local_Math.random() * 360), null, true)
		}
	}

	/**
	 * 只创建特效 没有模型
	 */
	public CreateBodyParticleEffect() {
		if (this.body_effect_id == null && this.vo && this.vo.effect_res && this.vo.effect_res != "") {
			let start_pos = new local_Vector2(this.vo.pos_x, this.vo.pos_y)
			let effect_res_type 
			if (this.GetType() == local_SceneBaseType.MainRole || this.GetType() == local_SceneBaseType.Role || this.GetType() == local_SceneBaseType.Fake_Role) {
				if (this.vo.CheckIsGod && this.vo.CheckIsGod()) {
					effect_res_type = EffectResType.God
				}
			} else if (this.GetType() == local_SceneBaseType.Partner) {
				effect_res_type = EffectResType.Pet
			} else if (this.GetType() == local_SceneBaseType.Shengqi) {
				effect_res_type = EffectResType.ShengQi
			} else if (this.GetType() == local_SceneBaseType.Sprite) {
				effect_res_type = EffectResType.Sprite
			} else if (this.GetType() == local_SceneBaseType.Demon) {
				effect_res_type = EffectResType.Demon
			} else if (this.GetType() == local_SceneBaseType.Monster) {
				effect_res_type = EffectResType.Monster
			}
			this.body_effect_id = this.particle_mgr.AddPosEffect(String(this.vo.effect_res), start_pos, true, null, null, null, null, null, null, 1, null, null, null, null, null, effect_res_type)
			if (this.vo.icon_scale) {
				this.particle_mgr.SetEffectScale(this.body_effect_id, this.vo.icon_scale)
			}
		}
	}

	/**
	 * 设置模型透明度
	 * @param alpha 
	 * @returns 
	 */
	public SetAlpha(alpha?) {
		if (this.alpha == alpha) { return }
		if (this.skin_mesh_renderer && !local_Util.IsNull(this.skin_mesh_renderer)) {
			let unlit_materials: Laya.UnlitMaterial[] = this.skin_mesh_renderer.skinnedMeshRenderer.materials as Laya.UnlitMaterial[]
			if (!unlit_materials || !unlit_materials.length) { return }
			let unlit_material
			if (alpha < 1) {
				for(let i = 0; i < unlit_materials.length; i++){
					unlit_material = unlit_materials[i]
					if(unlit_material)
					{
						if (unlit_material.renderMode != Laya.UnlitMaterial.RENDERMODE_TRANSPARENT)
							unlit_material.renderMode = Laya.UnlitMaterial.RENDERMODE_TRANSPARENT
						unlit_material.albedoColorA = alpha
					}
				}
			} else {
				for(let i = 0; i < unlit_materials.length; i++){
					unlit_material = unlit_materials[i]
					if(unlit_material)
					{
						if (unlit_material.renderMode != Laya.UnlitMaterial.RENDERMODE_OPAQUE)
							unlit_material.renderMode = Laya.UnlitMaterial.RENDERMODE_OPAQUE
						unlit_material.albedoColorA = 1
					}
				}
			}
		}
		this.alpha = alpha
	}

	/**
	 * 模型加载成功回调
	 * 继承类可以覆盖此方法做自己的操作
	 */
	public LoadClotheResComplete() {
		this.LoadModeParticle()
		this.RefreshHideFlag()
	}

	/**
	 * 加载Mode特效
	 */
	public LoadModeParticle() {

		//场景中不用模型特效
		if (false && this.model_res && this.transform && this.body_effect_dic == null) {
			let cfg, effect_res_type, cfgs = local_Config_PRELOAD_CLIENT_CONFIG.SceneObjectParticle
			if (this.GetType() == local_SceneBaseType.MainRole || this.GetType() == local_SceneBaseType.Role || this.GetType() == local_SceneBaseType.Fake_Role) {
				if (this.vo.CheckIsGod && this.vo.CheckIsGod()) {
					cfg = cfgs.God
					effect_res_type = EffectResType.God
				}
				else{
					cfg = cfgs.Body
					effect_res_type = EffectResType.Role
				}
			} else if (this.GetType() == local_SceneBaseType.Partner) {
				cfg = cfgs.Pet
				effect_res_type = EffectResType.Pet
			} else if (this.GetType() == local_SceneBaseType.Shengqi) {
				cfg = cfgs.FaBao
				effect_res_type = EffectResType.ShengQi
			} else if (this.GetType() == local_SceneBaseType.Sprite) {
				cfg = cfgs.Sprite
				effect_res_type = EffectResType.Sprite
			} else if (this.GetType() == local_SceneBaseType.Demon) {
				cfg = cfgs.Demon
				effect_res_type = EffectResType.Demon
			}

			if (!cfg) return

			let body_pvo = this["fashion_chartlet_id"] && cfg[`${this.model_res}_${this["fashion_chartlet_id"]}`] || cfg[this.model_res]

			if (body_pvo && body_pvo.always) {
				this.body_effect_dic = {}
				for (let bone_name in body_pvo.always) {
					let effect_vo = body_pvo.always[bone_name]
					if (this.body_effect_dic[bone_name] == null) {
						let bone = local_Util.FindBone(this.gameObject, bone_name)
						if (bone) {
							let load_call_back = (obj: Laya.Sprite3D) => {
								if (obj == null) {
									console.warn("!!!!!!!!!!!!!!!!!!!!找不到特效资源 Load body Particle" + effect_vo.name)
									return
								}
								if (this.use_delete_method || this.body_effect_dic == null || this.body_effect_dic[bone_name] == null) {
									obj.destroy()
									return
								}
								if (this.body_effect_dic[bone_name] && this.body_effect_dic[bone_name].particle_go) {
									obj.destroy()
									return
								}
								if (local_Util.IsNull(bone)) {
									obj.destroy()
									return
								}
								let new_go: Laya.Sprite3D = obj
								let transform: Laya.Transform3D = new_go.transform

								bone.addChild(new_go)
								local_Set3DLocalPosition(transform)
								Set3DLocalRotationEuler(transform)
								let scale = effect_vo.scale || 1
								local_Set3DLocalScale(transform, scale, scale, scale)

								new_go.active = true
								this.body_effect_dic[bone_name].particle_go = new_go
							}
							let full_url = local_GameResPath.GetEffectPath(effect_res_type, effect_vo.name)
							this.body_effect_dic[bone_name] = { res_url: full_url, particle_name: effect_vo.name, particle_go: null }
							local_ResManager.GetInstance().CreatePrefab(this.hashCode, full_url, load_call_back)
						}
					}
				}
			}
		}
	}

	/**
	 * 创建衣服需要子类继承实现
	 */
	public CreateWeaponSprite() {

	}

	/**
	 * 获取整个模型资源的高度
	 * @returns 
	 */
	public GetBodyHeight() {

		let res_height = null
		if (this.scale) {
			res_height = this.res_size.y * this.scale
		} else {
			res_height = this.res_size.y
		}
		if(res_height > SceneObj.MaxBodyHeight){
			res_height = SceneObj.MaxBodyHeight
		}
		return res_height
	}

	/**
	 * 检测该点是否在模型包围盒中
	 * @param point 
	 * @returns 
	 */
	public CheckInBound(point?) {
		if (this.can_pick != true) {
			return false
		}
		let body_height = this.GetBodyHeight()
		if (point.x < (this.real_pos.x - this.res_size.x / 2) || point.x > (this.real_pos.x + this.res_size.x / 2)
			|| point.y < (this.real_pos.y - body_height * 0.9)  || point.y > (this.real_pos.y + body_height * 0.2)) {
			return false
		}
		return true
	}

	/**
	 * 主动添加挂在自己身上的例子特效
	 * @param id 
	 * @param particle_tranform 
	 * @param attach_type 
	 * @param particle_speed 
	 * @param dir 
	 * @returns 
	 */
	public AddParticle(id?, particle_tranform?, attach_type?, particle_speed?, dir?) {
		let bone_name = ParticleAttachNode[attach_type] || attach_type
		// let transform = this.transform
		let gameObject = this.gameObject
		if (bone_name && this.transform) {
			let bone = null
			if (bone_name == AttachNode.SceneObj) {
				bone = this.root_transform.owner
			} else {
				if (attach_type >= 11 && attach_type <= 13 && this["GetWeapon"]) {
					let bone_go = this["GetWeapon"](bone_name)
					if (bone_go) {
						bone = bone_go
					}
				} else if (attach_type == 16 && this["GetHorseBone"]) {
					bone = this["GetHorseBone"](bone_name)
				} else {
					bone = local_Util.FindBone(gameObject, bone_name)
				}
			}
			if (bone == null) {
				console.warn("AddParticle " + this.name + " cannot find bone " + bone_name +" and particle name is =  " + particle_tranform.owner.name)
				this.particle_mgr.DelEffect(id)
				return
			}
			bone.addChild(particle_tranform.owner)
			ResetTransform(particle_tranform)
			if (bone_name == AttachNode.SceneObj) {
				local_Util.tempVector3.setValue(-local_SceneObj.StartRotate.x, 0, 0)
				particle_tranform.rotate(local_Util.tempVector3, true, false)
			}

			if(dir){
				let angle = this.scene_mgr.GetAngle(dir.x,dir.y)
				local_Util.tempVector3.setValue(0, angle, 0)
				particle_tranform.rotate(local_Util.tempVector3, true, false)
			}
			this.particle_list = this.particle_list || {}
			this.particle_list[id] = particle_tranform
			let effect = this.particle_mgr.GetEffect(id)
			if (effect) {
				let speed = particle_speed || this.particle_speed
				effect.SetSpeed(speed)
			}
		}
		else
		{
			console.warn("AddParticle " + this.name + " self.transform is null. particle name is =  " + particle_tranform.owner.name)
			this.particle_mgr.DelEffect(id)
		}
	}

	/**
	 * 删除指定名字的特效
	 * @param res_name 
	 * @returns 
	 */
	public RemoveParticleByResName(res_name?) {
		if(this.particle_list)
		{
			for (let id in this.particle_list) {
				let transform = this.particle_list[id]
				if (transform.entity.node.name == res_name) {
					this.particle_mgr.DelEffect(id)
					return
				}
			}
		}
	}

	/**
	 * 删除挂在自己身上的特效
	 * @param id 
	 * @param is_acive is_acive = false 被动删除挂在自己身上的粒子特效  由特效播放完来调用
	 * 				   is_acive = true 主动删除挂在自己身上的特效  会通知particlemanager去删除  默认false
	 */
	public RemoveParticle(id?, is_acive?) {
		if(this.particle_list)
		{
			delete this.particle_list[id]
			if (is_acive) {
				this.particle_mgr.DelEffect(id)
			}
		}
	}

	/**
	 * 主动删除挂在自己身上的所有粒子特效 通常是角色死亡 移除角色之类的
	 */
	public RemoveAllParticle() {

		if(this.particle_list)
		{
			for (let id in this.particle_list) {
				var _ = this.particle_list[id]
				this.particle_mgr.DelEffect(id)
				delete this.particle_list[id]
			}
		}
		if (this.body_effect_id) {
			this.particle_mgr.DelEffect(this.body_effect_id)
			this.body_effect_id = null
		}
	}

	public Update(now_time?, elapse_time?) {

		this._state_machine_manager.Update(now_time, elapse_time)
		if (this.talk_board) {
			if (this.update_talk_board || this.talk_board.CanUpdatePos()) {
				this.talk_board.UpdatePos(this.real_pos.x, this.real_pos.y)
				this.update_talk_board = false
			}
		}

		if (this.all_rotate_off) {
			let per_frame_rotate = local_Config_PRELOAD_CLIENT_CONFIG.ConfigOtherFightInfo.test_rotate * elapse_time
			if (this.all_rotate_off > 0) {
				if (this.all_rotate_off > per_frame_rotate) {
					this.AddRotateY(-per_frame_rotate, true)
					this.all_rotate_off = this.all_rotate_off - per_frame_rotate
				} else {
					this.AddRotateY(-this.all_rotate_off, true)
					this.all_rotate_off = false
				}
			} else {
				if (this.all_rotate_off < -per_frame_rotate) {
					this.AddRotateY(per_frame_rotate, true)
					this.all_rotate_off = this.all_rotate_off + per_frame_rotate
				} else {
					this.AddRotateY(-this.all_rotate_off, true)
					this.all_rotate_off = false
				}
			}
		}
	}

	public UpdatePos(pos?) {

	}

	public UpdateName() {

	}

	public SetScale(scale?) {

		this.scale = scale || this.scale

		if (this.transform && this.transform.localScaleX != this.scale) {
			local_Set3DLocalScale(this.transform, this.scale, this.scale, this.scale)
		}

		let res_height = this.GetBodyHeight()
		if (this.name_board) {
			this.name_board.SetAttachResHeight(res_height)
		}

		if (this.talk_board) {
			this.talk_board.SetAttachResHeight(res_height)
		}
	}

	//设置反方向
	public SetReverseDirection() {

		this.SetRotateY(180 + this.direction_angle, null, true)
	}

	//设置方向
	//real_pos 参数是否是具有x y坐标的方向
	//no_crossFade 没有旋转过渡步骤
	public SetDirection(dir1?, dir2?, real_pos?, no_crossFade?) {

		let angle = null
		if (real_pos) {
			angle = this.scene_mgr.GetAngle(dir1, dir2, real_pos)
		} else {
			angle = this.scene_mgr.GetAngle(dir1.x, dir1.y)
		}
		if (this.direction_angle != angle) {
			this.SetRotateY(angle, null, no_crossFade)
		}
	}

	/**
	 * 获取角色朝向的旋转角度
	 * @returns direction_angle
	 */
	public GetDirectionAngle() {
		return this.direction_angle
	}

	/**
	 * 获取角色当前方向
	 * @returns direction
	 */
	public GetDirection() {
		return this.direction
	}


	/**
	 * 设置角色当前旋转角度
	 * @param rotate 角度
	 * @param is_rotating 是否正在旋转
	 * @param no_crossFade 是否不过渡旋转
	 * @returns 
	 */
	public SetRotateY(rotate?, is_rotating?, no_crossFade?) {
		rotate = rotate % 360
		if (no_crossFade) {
			this.all_rotate_off = null
		} else {
			let curr_rotate_off = rotate - this.direction_angle

			//控制在最小旋转角度
			if (curr_rotate_off > 180) {
				curr_rotate_off = curr_rotate_off - 360
			} else if (curr_rotate_off < -180) {
				curr_rotate_off = 360 + curr_rotate_off
			}

			if (local_Math.abs(curr_rotate_off) > 10 && !is_rotating) { //转角大于一定角度 就要分帧旋转
				this.all_rotate_off = curr_rotate_off
				return
			} else if (!is_rotating) {
				this.all_rotate_off = null
			}
		}
		this.direction_angle = rotate
		let radian = this.direction_angle / 180 * local_Math.PI
		this.direction.x = local_Math.cos(radian)
		this.direction.y = local_Math.sin(radian)
		this.direction.normalise()
		let y_off = local_Config_PRELOAD_CLIENT_CONFIG.ConfigOtherFightInfo.test_ps_angle * local_Math.sin(this.direction_angle * 2 / 180 * local_Math.PI)
		let curRotate = - this.direction_angle + 90 + y_off

		if (this.modelObj_transform) {
			this.curr_rotate.y = curRotate - this.rotateY
			this.modelObj_transform.rotate(this.curr_rotate, true, false)
		}
		this.rotateY = curRotate
	}


	public AddRotateY(rotate?, is_rotating?) {
		this.SetRotateY(this.direction_angle - rotate, is_rotating)
	}

	public GetBodyScale() {
		return this.scale
	}

	public SetLogicPos(posx?, posy?) {
		let x = posx * local_SceneObj.GetLogicRealRatio().x
		let y = posy * local_SceneObj.GetLogicRealRatio().y
		this.SetRealPos(x, y)
	}

	//为了兼容旧项目代码，增加这x和y的get方法
	public get x(): number {
		return this.real_pos.x
	}

	//为了兼容旧项目代码，增加这x和y的get方法
	public get y(): number {
		return this.real_pos.y
	}

	// ignore_floor  忽略物体本身的高度，也就是本次高度不更新
	public SetRealPos(posx?, posy?, is_born?, ignore_floor?) {
		// if(isNaN(posx) || isNaN(posy)){
		// 	console.warn("------物体坐标设置有误------", posx, posy)
		// 	console.trace()
		// }
		this.real_pos.x = posx
		this.real_pos.y = posy
		if (this.vo) {
			this.vo.pos_x = posx
			this.vo.pos_y = posy
		}
		
		this.shadow_gameObject.x = posx
		this.shadow_gameObject.y = posy

		this.logic_pos.x = local_Math.floor(posx / local_SceneObj.GetLogicRealRatio().x)
		this.logic_pos.y = local_Math.floor(posy / local_SceneObj.GetLogicRealRatio().y)

		this.UpdateModelPos()	//更新位置到模型
		if (this.name_board) {
			this.name_board.UpdatePos(posx, posy)
		}
		this.update_talk_board = true
	}

	//设置身体的位置  真实坐标不变
	public SetBodyXY(x?, y?, force?) {

		if (this.curr_model_y == y && !force) { return }
		this.curr_model_y = y
		if (this.transform) {
			local_Set3DLocalPosition(this.transform, -x / 100, -y / 100)
		}
		if (this.name_board) {
			this.name_board.SetOffHeight(y)
		}
		if (this.talk_board) {
			this.talk_board.SetOffHeight(y)
		}

	}

	public IsInState(state) {
		return this._state_machine_manager.GetCurrState() == state
	}

	public GetCurState() {
		return this._state_machine_manager.GetCurrState()
	}

	public ChangeState(state: number) {
		this._state_machine_manager.ChangeState(state)
	}

	public ChangeStateEnter(state: number) {

	}

	public ChangeStateLeave(state: number) {
		if (this.vo) {
			this.vo.prePoseState = state
		}
	}

	/**
	 * 更新模型位置
	 */
	public UpdateModelPos() {
		let z = this.scene_mgr.GetSceneObjDepth(this.real_pos.y)
		local_Set3DLocalPosition(this.root_transform, this.real_pos.x * 0.01, this.real_pos.y * 0.01, z)
		// console.log("UpdateModelPos = " ,this.logic_pos.x, this.logic_pos.y)
	}

	//获取高度，但是是差值的，差值对象是 target_height
	public GetObjHeight() {
		return 0
	}

	public GetLogicPos() {
		return this.logic_pos
	}

	public GetRealPos() {
		return this.real_pos
	}
	

	public GetCompressID() {
		return this.compress_id
	}

	public ReleaseObj() {
		this.ReleaseSceneObj()
	}

	public ResetObj() {
		this.ResetSceneObj()
	}

	//销毁模型或者添加进对象缓存池
	public RemoveGameObject() {
		if (this.body_effect_dic) {
			for (let bone_name in this.body_effect_dic) {
				var vo = this.body_effect_dic[bone_name]
				if (vo.particle_name && vo.particle_go) {
					if (this.ignore_pool) {
						vo.particle_go.destroy()
					} else {
						local_ResManager.GetInstance().AddSprite3DToPool(this.hashCode, vo.res_url, vo.particle_go)
					}
				}
			}
			this.body_effect_dic = null
		}

		if (this.gameObject) {
			if (this.animator && !this.ignore_pool) {
				local_ResManager.GetInstance().AddSprite3DToPool(this.hashCode, this.gameObject.url, this.gameObject)
				if (!local_Util.IsNull(this.skin_mesh_renderer) && this.default_main_texture) {
					let unlit_material: Laya.UnlitMaterial = this.skin_mesh_renderer.skinnedMeshRenderer.material as Laya.UnlitMaterial
					SetMaterialTexture(unlit_material, this.default_main_texture)
				}
			} else {
				this.gameObject.destroy()
			}


			this.gameObject = undefined
			this.transform = undefined
			this.animator = undefined
			this.skin_mesh_renderer = undefined
			this.default_main_texture = undefined
			this.model_res = undefined
			this.model_res_url = null
		}
	}

	public ClearBodyEffect() {
		if (this.body_effect_dic) {
			for (let bone_name in this.body_effect_dic) {
				var vo = this.body_effect_dic[bone_name]
				if (vo.particle_name && vo.particle_go) {
					if (this.ignore_pool) {
						vo.particle_go.destroy()
					} else {
						local_ResManager.GetInstance().AddSprite3DToPool(this.hashCode, vo.res_url, vo.particle_go)
					}
				}
			}
			this.body_effect_dic = undefined
		}
	}

	public DeleteMe() {
		this.ReleaseObj()

		if (this.name_board) {
			this.name_board.DeleteMe()
			this.name_board = null
		}

		if (this.root_transform) {
			this.root_transform.owner.destroy()
			this.root_transform = null
		}

		if (this.shadow_gameObject) {
			this.shadow_gameObject.destroy()
			this.shadow_gameObject = null
		}
		super.DeleteMe()
	}

	public ResetSceneObj() {

		this.SetShadowVisible(false)


		if (this.name_board) {
			this.name_board.ResetData()
		}
		this.hide_nameboard = null
		if (this.talk_board) {
			this.talk_board.SetVisible(false)
		}

		this.is_in_cache_pool = false
	}
	
	public ReleaseSceneObj() {
		if (this.is_in_cache_pool) { return }
		this.is_in_cache_pool = true
		this._state_machine_manager.ChangeState(local_PoseState.NULL)
		GlobalEventSystem.Fire(ObjectEventType.REMOVE_SCENE_OBJECT, this.vo)
		this.SetModelHideFlag(local_SceneObj.ModelHideFlag.All, false)

		if(!local_Util.IsNull(this.scene.click_target_effect) && this.root_transform.owner.getChildIndex(this.scene.click_target_effect) >= 0){
			this.scene.click_target_effect.removeSelf()
		}


		this.model_res_size.x = 90
		this.model_res_size.y = 160
		this.res_size.x = 90
		this.res_size.y = 160
		this.direction.x = 0
		this.direction.y = -1
		this.scale = 1
		this.direction_angle = 90

		if (this.rotateY != 0) {
			this.curr_rotate.y = -this.rotateY
			this.modelObj_transform.rotate(this.curr_rotate, true, false)
		}
		this.rotateY = 0
		this.RemoveGameObject()
		this.is_model_hiden = false
		this.ignore_pool = false
		this.hide_name_by_model = false
		this.custom_speed = null
		this.root_transform.owner.removeSelf()
		if (this.name_board) {
			this.name_board.ReleaseData()
		}
		if (this.talk_board) {
			this.talk_board.DeleteMe()
			this.talk_board = null
		}
		this.SetShadowVisible(false)
		local_ResManager.GetInstance().DestroyAllReferenceRes(this.hashCode);
	}

	public SetModelHideFlag(flag?, hide?) {

		if (this.model_hide_flag == undefined || !flag) {
			return
		}
		let now_flag = 0
		if (hide) {
			now_flag = this.model_hide_flag | flag
		} else {
			now_flag = this.model_hide_flag & ~flag
		}

		if (now_flag == this.model_hide_flag) {
			return
		}

		this.model_hide_flag = now_flag
		this.RefreshHideFlag()
	}

	//是否包含指定flag
	public HasModelHideFlag(flag?) {
		flag = flag || local_SceneObj.ModelHideFlag.All
		return (this.model_hide_flag & flag) != 0
	}

	//根据model_hide_flag刷新Visible
	public RefreshHideFlag() {
		let old_hide_name_by_model = this.hide_name_by_model
		this.hide_name_by_model = false
		if ((this.model_hide_flag & local_SceneObj.ModelHideFlag.ServerHide) != 0
			|| (this.model_hide_flag & local_SceneObj.ModelHideFlag.Skill) != 0
			|| (this.model_hide_flag & local_SceneObj.ModelHideFlag.Arena) != 0
			|| (this.model_hide_flag & local_SceneObj.ModelHideFlag.IndependentHide) != 0
			|| (this.model_hide_flag & local_SceneObj.ModelHideFlag.IndependenRole) != 0) {

			if (this.modelObj_transform && this.modelObj_transform.owner.active) {
				this.modelObj_transform.owner.active = false
			}
			//@ts-ignore
			if (this.liveness_transform && this.liveness_transform.owner.active) {
				//@ts-ignore
				this.liveness_transform.owner.active = false
			}
			this.SetShadowVisible(false)
			this.SetBodyEffectVisible(false)
			this.is_model_hiden = true
			if (this.name_board) {
				this.hide_name_by_model = true
			}
			//设置界面隐藏其他玩家，只是隐藏model
		} else if ((this.model_hide_flag & local_SceneObj.ModelHideFlag.RoleNumLimit) != 0) {
			this.SetBodyEffectVisible(true)
			if (this.modelObj_transform && this.modelObj_transform.owner.active) {
				this.modelObj_transform.owner.active = false
			}
			//@ts-ignore
			if (this.liveness_transform && this.liveness_transform.owner.active) {
				//@ts-ignore
				this.liveness_transform.owner.active = false
			}

			this.SetShadowVisible(true)

			this.is_model_hiden = true
		} else {
			this.SetBodyEffectVisible(true)
			if (this.modelObj_transform && !this.modelObj_transform.owner.active) {
				this.modelObj_transform.owner.active = true
			}
			//@ts-ignore
			if (this.liveness_transform && !this.liveness_transform.owner.active) {
				//@ts-ignore
				this.liveness_transform.owner.active = true
			}
			this.SetShadowVisible(true)
			if(!this.gameObject)
			{
				if(this.cache_model_res)
				{
					if(!this.is_in_cache_pool)
					{
						this.CreateClotheSprite(this.cache_model_res, this.cache_ignore_pool, this.cache_force_load_clothe_type)
					}
					this.cache_model_res = null
					this.cache_ignore_pool = null
					this.cache_force_load_clothe_type = null
				}
			}else if(!this.gameObject.active){
				this.gameObject.active = true
			}
			this.is_model_hiden = false
			if (this["ReplayAction"]) {
				this["ReplayAction"]()
			}
		}

		if (old_hide_name_by_model != this.hide_name_by_model) {
			this.UpdateNameBoardVisible()
		}
	}

	public IsModelHiden() {

		return this.is_model_hiden
	}

	public SetBodyEffectVisible(visible?) {

		if (this.body_effect_id) {
			let effect = this.particle_mgr.GetEffect(this.body_effect_id)
			if (effect) {
				effect.ShowEffect(visible)
			}
		}
	}

	public SetShadowVisible(state?) {
		this.shadow_gameObject.visible = state
	}

	public UpdateNameBoardVisible() {

		if (this.hide_nameboard || this.hide_name_by_model) {
			if (this.name_board) {
				this.name_board.SetVisible(false)
			}
		} else {
			if (!this.name_board) {
				this.name_board = NameBoardManager.GetInstance().CreateNameBoard(null, this)
				this.SetScale()
			}
			this.name_board.SetVisible(true)
			this.name_board.UpdatePos(this.real_pos.x, this.real_pos.y)
			this.UpdateName()
		}
	}

	//设置隐藏/非隐藏名字
	public SetHideNameBord(state?) {

		if (this.hide_nameboard == state) {
			return
		}
		this.hide_nameboard = state
		this.UpdateNameBoardVisible()
	}

	public GetType() {
		return this._type
	}

	public SetType(type?) {
		this._type = type
	}


	//得到当前动作播放时长
	public GetCurActionTime() {
		if (!local_Util.IsNull(this.gameObject) && !local_Util.IsNull(this.animator)) {
			let cur_layer = this.animator.getControllerLayer()
			if (cur_layer) {
				let cur_state = cur_layer.getCurrentPlayState()
				if (cur_state && cur_state.duration) {
					return cur_state.duration
				}
			}
		}
		return 0
	}

	//设置模型和特效的播放速度
	public SetPlaySpeed(speed?, ignore_effect?) {

		if (this.animator) {
			if (this.custom_speed) {
				this.animator.speed = speed * this.custom_speed
			} else {
				this.animator.speed = speed
			}
		}
		if (!ignore_effect) {
			this.particle_speed = speed
			if(this.particle_list)
			{
				let effect = null
				for (let id in this.particle_list) {
					var _ = this.particle_list[id]
					effect = this.particle_mgr.GetEffect(id)
					if (effect) {
						effect.SetSpeed(speed)
					}
				}
			}
		}
	}


	//创建说话气泡
	public CreateTalkBoard(content?, type?, content_width?, time?, call_back?) {
		if (this.IsModelHiden() || !this.transform) {
			return
		}

		if (!this.talk_board) {
			let parent = local_LayerManager.GetInstance().GetUILayer(Enum_UILayer.TalkBoard)
			this.talk_board = new TalkBoard(parent)
			this.talk_board.Load()
			this.talk_board.SetVisible(false)
			this.talk_board.InitData(this.id, null, null, null, null)
		}

		if (content == undefined) {
			return
		}

		this.talk_board.ExcuteCallback(() => {
			this.talk_board.SetVisible(true)
			this.talk_board.SetContent(content)

			this.talk_board.UpdatePos(this.real_pos.x, this.real_pos.y)
			let height = this.GetBodyHeight()
			this.talk_board.SetAttachResHeight(height)

			if (this.hide_nameboard) {
				this.talk_board.SetOffHeight(50)
			} else {
				let is_show_hp = false
				if (this.name_board) {
					is_show_hp = this.name_board.IsShowHp()
				}

				if (is_show_hp) {
					this.talk_board.SetOffHeight(0)
				} else {
					this.talk_board.SetOffHeight(80)
				}
			}

			this.talk_board.StartTimer(time, call_back)
		})
	}

	//显示模型
	public ShowModel(bool?) {

		this.modelObj_transform.owner.active = bool
		this.SetHideNameBord(!bool)
	}

	public IsDead() {
		return false
	}

	public GetVo() {
		return this.vo
	}

	public CancelTalkTime() {
		this.talk_ing = false
		if (this.talk_timer) {
			GlobalTimerQuest.CancelQuest(this.talk_timer)
			this.talk_timer = false
		}
	}

	public CreatTalkTimer() {
		this.CancelTalkTime()
		let cfg = Config.PRELOAD_SERVER_CONFIG.config_scene_chat_bubble
		if (cfg) {
			let type
			if (this._type == local_SceneBaseType.Sprite) {
				type = 1
			} else if (this._type == local_SceneBaseType.Partner) {
				type = 2
			} else if (this._type == local_SceneBaseType.Npc) {
				type = 3
			} else if (this._type == local_SceneBaseType.Monster) {
				type = 4
			}

			for (let i in cfg) {
				let vo = cfg[i]
				let id = this.id
				if (this._type == local_SceneBaseType.Monster) {
					id = this.vo.type_id
				}
				if (vo && vo.bubble_type == 2 && vo.object_id == id && vo.condition != "" && vo.object_type == type) {
					let con = ErlangParser.GetInstance().Parse(vo.condition)[0]
					if (con[0] == "obj_id") {
						let talk_id = vo.bubble_id
						this.talk_timer = GlobalTimerQuest.AddPeriodQuest(() => {
							if (this.talk_ing) {
								return
							}
							if (Scene.GetInstance().StartObjTalk(this, talk_id)) {
								this.talk_ing = true
								GlobalTimerQuest.AddDelayQuest(() => {
									this.talk_ing = false
								}, 60)
							}
						}, 1.5)
						break
					}
				}
			}
		}
	}
}
var local_SceneObj = SceneObj
window["SceneObj"] = SceneObj