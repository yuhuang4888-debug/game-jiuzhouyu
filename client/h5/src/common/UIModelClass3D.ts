import { ParticleManager } from "../particalEffect/ParticleManager"

import { AttachNode, EffectResType, ModelPartName, ParticleAttachNode, PrintParticleInfo } from "../scene/SceneConfig"
import { Clothe } from "../scene/sceneobj/Clothe"
import { GlobalEventSystem, LOAD_QUEUE } from "../util/DeclareGlobalVar"
import { GameResPath } from "../util/GameResPath"
import { CommonCrossFadeAnim, CommonPlayAnim, GetParams, GetSkinnedMeshSprite3D, GlobalTimerQuest, ResetTransform, Set3DLocalPosition, Set3DLocalRotationEuler, Set3DLocalScale, SetMaterialTexture, Util } from "../util/Util"
import { Vector3 } from "../util/Vector3"
import { BaseClass } from "./BaseClass"
import { Config } from "./Config"
import { LayerManager } from "./LayerManager"
import { ResManager } from "./ResManager"
import { table } from "./table"

export enum UI_MODEL_TYPE {
	NONE = -1,
	ROLE = 0,
	MAINROLE = 1,
	HORSE = 2,//坐骑
	WING = 3,//翅膀
	WEAPON = 4,//武器、神兵
	ARTIFACT = 5,//圣器
	HOLYDEVICE = 6,
	SPRITE = 7,//精灵
	PARTNER = 8,//契灵
	BABY = 9,//宝宝
	GOD = 10,//降神
	DEMON = 11,//使魔
	PET = 12,
	Include_Horse = 13,
	MONSTER = 14,
	HAIR = 15,//头发
	NPC = 16,//npc
	GUARD = 17,	// 守护
	GUBAO = 18, //古宝
	ACT = 19,   //活动头发和服装都要
	BACKORNAMENT = 20,//背饰
	GHOST = 21,//仙灵
}
window["UI_MODEL_TYPE"] = UI_MODEL_TYPE;
//ui挂接模型处理

let local_Util = Util
let local_Laya = Laya
let local_GameResPath = GameResPath
let local_Set3DLocalPosition = Set3DLocalPosition
let local_Set3DLocalRotationEuler = Set3DLocalRotationEuler
let local_Set3DLocalScale = Set3DLocalScale
let local_CommonPlayAnim = CommonPlayAnim
export class UIModelClass3D extends BaseClass {
	static CURR_POS_INDEX = 1; //当前位置索引
	static POS_STEP_VALUE = 20; //单位距离
	static cross_animation_time = 0.1
	static no_particle = false


	sex
	load_call_back
	click_call_back
	can_click
	delay_play_action_timer_list
	career
	action_delta
	rotate
	pos_x
	custom_speed
	show_gray
	can_rotate
	type
	position
	is_loading_flag
	action_name_list
	scale
	head_wear_id
	timer
	default_state
	bone_effect


	resMgr: ResManager = ResManager.GetInstance()
	parent: Laya.Sprite
	scene: Laya.Scene3D
	cameraObject: Laya.Camera
	renderTexture: Laya.RenderTexture

	clothe: Clothe
	clothe_res_id //衣服资源id
	fashion_model_id //时装资源id
	texture_id// 时装贴图
	gameObject: Laya.Sprite3D
	transform: Laya.Transform3D

	weapon_res_id //武器资源id
	weapon_clothe_id //武器贴图id
	weapon_container //武器列表

	wing_id //翅膀id
	wing_gameObject: Laya.Sprite3D
	wing_transform: Laya.Transform3D

	horse_id//坐骑id
	horse_gameObject: Laya.Sprite3D
	horse_transform: Laya.Transform3D

	back_ornament_id //背饰资源id
	back_ornament_gameObject: Laya.Sprite3D
	back_ornament_transform: Laya.Transform3D


	headWear_skin_mesh_renderer: Laya.SkinnedMeshSprite3D
	skin_mesh_renderer: Laya.SkinnedMeshSprite3D
	default_head_go: Laya.Sprite3D
	head_clothe_id
	head_clothe: Clothe

	liveness_id
	liveness_particle

	body_particle_dic
	horse_particle_dic
	weapon_particle_dic
	wing_particle_dic
	back_ornament_particle_dic
	bone_particle_list
	action_particle_dic

	/**
	 * 根父容器
	 */
	root_transform: Laya.Transform3D
	/**
	 * 模型父容器，旋转用
	 */
	model_transform: Laya.Transform3D
	/**
	 * 默认模型缩放
	 */
	default_model_scale = 1.1

	public constructor(parent, data) {
		super()


		//根父容器
		this.root_transform = new local_Laya.Sprite3D().transform
		local_Set3DLocalScale(this.root_transform, this.default_model_scale, this.default_model_scale, this.default_model_scale)

		//模型对象父容器
		this.model_transform = new local_Laya.Sprite3D().transform
		this.root_transform.owner.addChild(this.model_transform.owner)


		this.parent = parent
		this.pos_x = 0
		this.custom_speed = 1
		this.SetData(parent, data)
		this.AddEvents()
	}

	public DeleteMe() {

		if (this.default_head_go) {
			this.default_head_go.removeSelf()
			this.default_head_go = null
		}
		this.ClearActionTimerList()
		this.RemoveAllParticle()

		if (this.clothe) {
			this.clothe.DeleteMe()
			this.clothe = null
		}
		if (this.head_clothe) {
			this.head_clothe.DeleteMe()
			this.head_clothe = null
		}
		if (this.horse_gameObject) {
			this.horse_gameObject.destroy()
		} else if (this.gameObject) {
			this.gameObject.destroy()
		}


		this.gameObject = null
		this.transform = null

		this.horse_gameObject = null
		this.horse_transform = null

		this.wing_gameObject = null
		this.wing_transform = null

		this.back_ornament_gameObject = null
		this.back_ornament_transform = null

		this.weapon_container = null

		if (this.scene) {
			this.scene.destroy()
			this.scene = null
		}

		if (this.cameraObject) {
			if (this.renderTexture) {
				this.renderTexture.destroy()
				this.renderTexture = null
			}
			this.cameraObject = null
		}
		if (this.root_transform) {
			this.root_transform.owner.destroy()
			this.root_transform = null
		}
		this.ClearTimer()
		super.DeleteMe()
	}

	public ClearActionTimerList() {

		if (this.delay_play_action_timer_list) {
			for (let i = 0; i < this.delay_play_action_timer_list.length; i++) {
				let id = this.delay_play_action_timer_list[i]
				GlobalTimerQuest.CancelQuest(id)
			}
			this.delay_play_action_timer_list.length = 0
		}
	}

	public PlayActions(action_name_list?, action_delta?, animator?: Laya.Animator) {

		if (!this.gameObject) { return }
		animator = animator || this.gameObject.getComponent(local_Laya.Animator)
		if (!local_Util.IsTableEmpty(action_name_list)) {
			let action_name = action_delta && action_name_list[0] || table.remove(action_name_list, 0)[0]
			if (action_name) {
				animator.speed = this.custom_speed
				local_CommonPlayAnim(animator, action_name)
				this.LoadActionParticle(action_name)
				if (!local_Util.IsTableEmpty(action_name_list)) {
					let next_frame = () => {
						this.delay_play_action_timer_list = this.delay_play_action_timer_list || []
						if (action_delta && local_Util.TableSize(action_name_list) > 1) {//设置了动作间隔，动作名列表>1才执行动做循环
							this.DelayPlayNextActionLoop(animator, action_name_list, action_delta)
						} else {
							this.DelayPlayNextAction(animator, action_name_list)
						}
					}
					setTimeout(next_frame, 10)
				}
			}
		}
	}

	//随机循环动作列表 暂时不添加音效
	//action_name_list.idle_name 默认待机动作
	public DelayPlayNextActionLoop(animator: Laya.Animator, action_name_list, action_delta) {

		if (local_Util.IsTableEmpty(action_name_list) || local_Util.IsNull(animator.owner as Laya.Sprite3D) || this.show_gray) { return }

		let layer: Laya.AnimatorControllerLayer = animator.getControllerLayer()
		let cur_state: Laya.AnimatorPlayState = layer && layer.getCurrentPlayState()
		let action_time = 0
		if (!cur_state) { return }
		action_time = cur_state.duration
		let idle_action = "idle"
		let delay_play = () => {
			if (!local_Util.IsNull(animator.owner as Laya.Sprite3D)) {
				let action_name = ""
				let random_index = local_Util.RandomRange(0, action_name_list.length - 1)
				action_name = action_name_list[random_index]
				if (action_name.search("casual") > -1) {
					animator.speed = 1
				} else {
					animator.speed = this.custom_speed
				}
				local_CommonPlayAnim(animator, action_name)
				this.LoadActionParticle(action_name)
				let next_frame = () => {
					this.DelayPlayNextActionLoop(animator, action_name_list, action_delta)
				}
				setTimeout(next_frame, 10)
			}
		}
		let play_idle = () => {
			if (!local_Util.IsNull(animator.owner as Laya.Sprite3D)) {
				let next_speed = 1
				if (idle_action.search("casual") > -1) {
					next_speed = 1
				} else {
					next_speed = this.custom_speed
				}

				let delay = () => {
					if (!local_Util.IsNull(animator.owner as Laya.Sprite3D)) {
						animator.speed = next_speed
					}
				}

				if (animator.speed > next_speed) {
					delay()
				} else {
					setTimeout(delay, UIModelClass3D.cross_animation_time)
				}
				CommonCrossFadeAnim(animator, idle_action, UIModelClass3D.cross_animation_time * animator.speed)
			}
		}
		//清理计时器列表
		if (this.delay_play_action_timer_list.length >= 20) {
			this.ClearActionTimerList()
		}
		action_delta = action_delta < action_time && action_time + 1 || action_delta
		if (cur_state.animatorState.name != idle_action) {//当前已经在播放idle动作，就不在延迟播放了。否则会抖一下
			let cross_time = UIModelClass3D.cross_animation_time * action_time
			table.insert(this.delay_play_action_timer_list, GlobalTimerQuest.AddDelayQuest(play_idle, action_time - cross_time))
		}
		table.insert(this.delay_play_action_timer_list, GlobalTimerQuest.AddDelayQuest(delay_play, action_delta))
	}

	//延迟播放下一个动作
	public DelayPlayNextAction(animator: Laya.Animator, action_name_list: string[]) {
		animator = animator || this.gameObject.getComponent(local_Laya.Animator)
		if (local_Util.IsNull(animator.owner as Laya.Sprite3D)) {
			return
		}
		let layer: Laya.AnimatorControllerLayer = animator.getControllerLayer()
		if (!local_Util.IsTableEmpty(action_name_list) && layer) {
			let cur_state: Laya.AnimatorPlayState = layer.getCurrentPlayState()
			let clip = cur_state && cur_state.animatorState && cur_state.animatorState.clip
			let action_time = 0
			if (clip) {
				action_time = clip.duration() - 0.1 //下一个动作是定时器触发，不是实时触发，可能导致卡帧，提前触发
				// console.warn("------DelayPlayNextAction------", cur_state.animatorState.name, action_time)
				let delay_play = () => {
					if (local_Util.IsNull(animator.owner as Laya.Sprite3D)) {
						return
					}
					let action_name = action_name_list.splice(0, 1)[0]

					let cur_state: Laya.AnimatorPlayState = layer.getCurrentPlayState()

					let is_repeat = false
					if (cur_state.animatorState && cur_state.animatorState.name == action_name) {
						is_repeat = true
					}
					if (action_name && !is_repeat) {

						animator.speed = this.custom_speed

						//let state_info = animator.GetCurrentAnimatorStateInfo(0)
						//console.log("播放前状态信息输出:",state_info.length,state_info.speed, animator.speed)
						//UIModelClass3D.cross_animation_time * animator.speed
						// animator.play(action_name)
						CommonCrossFadeAnim(animator, action_name, UIModelClass3D.cross_animation_time)
						this.LoadActionParticle(action_name)
						if (!local_Util.IsTableEmpty(action_name_list)) {
							this.DelayPlayNextAction(animator, action_name_list)
						}
					} else {
						return
					}
				}
				table.insert(this.delay_play_action_timer_list, GlobalTimerQuest.AddDelayQuest(delay_play, action_time - UIModelClass3D.cross_animation_time))
			} else {
				return
			}
		}
		return
	}

	public SetData(parent, data) {

		this.type = data.type
		this.career = data.career
		this.sex = data.sex
		this.clothe_res_id = data.clothe_res_id
		this.weapon_res_id = data.weapon_res_id
		let rotate
		if (data.rotate && typeof (data.rotate) == "number") {
			rotate = new local_Laya.Vector3(0, data.rotate, 0)
		}
		else {
			rotate = new local_Laya.Vector3(0, 180, 0)
		}
		this.rotate = rotate
		this.action_name_list = data.action_name_list
		this.can_rotate = data.can_rotate == null || data.can_rotate == true
		this.can_click = data.click == null || data.can_click == true
		this.click_call_back = data.click_call_back
		this.scale = data.scale || 1
		this.position = data.position
		this.action_delta = data.action_delta
		this.horse_id = data.horse_id
		this.weapon_clothe_id = data.weapon_clothe_id
		this.wing_id = data.wing_id
		this.back_ornament_id = data.back_ornament_id
		this.liveness_id = data.liveness_id
		this.head_wear_id = data.head_wear_id
		this.head_clothe_id = data.head_clothe_id
		this.fashion_model_id = data.fashion_model_id
		this.texture_id = data.texture_id
		this.show_gray = data.show_gray
		this.load_call_back = data.load_call_back//加载完回调
		this.is_loading_flag = {} //正在加载中的标识 全部部件加载完才能算加载完
		this.default_state = data.default_state
		this.bone_effect = data.bone_effect
		let curr_pos_index = UIModelClass3D.CURR_POS_INDEX;
		UIModelClass3D.CURR_POS_INDEX++;
		if (!this.scene || this.scene.destroyed) {
			this.scene = LayerManager.GetInstance().CreateUIScene3D()
		}
		let scene = this.scene
		let include_horse = false
		if (this.type == UI_MODEL_TYPE.Include_Horse) {
			include_horse = true
			this.type = UI_MODEL_TYPE.MAINROLE
		}
		let loadBodyCallback = async (obj: Laya.Sprite3D) => {
			if (local_Util.IsNull(obj)) {
				return
			}
			if (this.use_delete_method) {
				obj.destroy()
				return
			}

			this.RemoveAllParticle()

			if (this.gameObject) {
				this.gameObject.destroy()
			}
			this.gameObject = obj
			this.transform = this.gameObject.transform
			let animator = obj.getComponent(local_Laya.Animator) as Laya.Animator
			this.custom_speed = Config.PRELOAD_CLIENT_CONFIG.ConfigModelSpeed && Config.PRELOAD_CLIENT_CONFIG.ConfigModelSpeed.ModelActionSpeed[Number(data.clothe_res_id)] || 1
			if (this.type == UI_MODEL_TYPE.ROLE || this.type == UI_MODEL_TYPE.MAINROLE) {
				this.custom_speed = Config.PRELOAD_CLIENT_CONFIG.ConfigModelSpeed && Config.PRELOAD_CLIENT_CONFIG.ConfigModelSpeed.MainRoleActionSpeed.Idle || 1
			}
			if (animator) {
				animator.speed = this.custom_speed
				if (this.default_state) {
					let controller_layer = animator.getControllerLayer()
					if (controller_layer) {
						let defaultState = controller_layer.getAnimatorState(this.default_state)
						if (defaultState)
							controller_layer.defaultState = defaultState
					}
				}
			}

			if (this.show_gray) {
				let skin_mesh_renderers = local_Util.GetComponents(obj, local_Laya.SkinnedMeshSprite3D)
				let skin_mesh_renderer: Laya.SkinnedMeshSprite3D
				for (let i = 0; i < skin_mesh_renderers.length; i++) {
					skin_mesh_renderer = skin_mesh_renderers[i]
					if (skin_mesh_renderer) {
						let unlit_materials: Laya.UnlitMaterial[] = skin_mesh_renderer.skinnedMeshRenderer.materials as Laya.UnlitMaterial[]
						let unlit_material
						for (let i = 0; i < unlit_materials.length; i++) {
							unlit_material = unlit_materials[i]
							unlit_material.albedoColor = new local_Laya.Vector4(0.5, 0.5, 0.5, 1)
						}
					}
				}
			}
			else {
				this.LoadBodyParticle(data.clothe_res_id)
				if (this.bone_effect) {
					let list = this.bone_effect["clothe"]
					if (list) {
						let data, bone
						for (let bone_name in list) {
							bone = local_Util.FindBone(this.gameObject, bone_name)
							if (bone) {
								data = list[bone_name]
								this.AddBoneParticleEffect(bone, data.type, data.name)
							}
						}

					}
				}
			}
			let pos_x = curr_pos_index * UIModelClass3D.POS_STEP_VALUE// + 0.7;
			let pos_y = curr_pos_index * UIModelClass3D.POS_STEP_VALUE - 5;

			if (data.position) {
				pos_x += data.position.x
				pos_y += data.position.y
			}

			if (scene.getChildIndex(this.root_transform.owner) == -1) {
				scene.addChild(this.root_transform.owner)
			}

			local_Set3DLocalPosition(this.root_transform, -pos_x, -pos_y, 0)
			local_Set3DLocalRotationEuler(this.model_transform, this.rotate.x, this.rotate.y, this.rotate.z)

			if (include_horse) {//this.free_param为坐骑id
				let loadHorseCallback = (obj: Laya.Sprite3D) => {
					if (local_Util.IsNull(obj)) {
						return
					}
					if (this.use_delete_method) {
						obj.destroy()
						return
					}

					if (this.horse_gameObject) {
						this.horse_gameObject.destroy()
					}

					this.horse_gameObject = obj
					this.horse_transform = obj.transform

					this.model_transform.owner.addChild(this.horse_gameObject)
					local_Set3DLocalScale(this.horse_transform, 4 * data.scale, 4 * data.scale, 4 * data.scale)

					if (this.transform) {
						let bone: Laya.Sprite3D = local_Util.FindBone(this.horse_transform.owner, AttachNode.Ride)
						if (bone == null) {
							return
						}
						bone.addChild(this.transform.owner)
						local_Set3DLocalPosition(this.transform, 0, 0, 0)
						local_Set3DLocalRotationEuler(this.transform, 0, 0, 0)
						local_Set3DLocalScale(this.transform, 1, 1, 1)
					}


					let horse_animator: Laya.Animator = this.horse_gameObject.getComponent(local_Laya.Animator)
					local_CommonPlayAnim(horse_animator, "idle")
					let animator = this.gameObject.getComponent(local_Laya.Animator)
					local_CommonPlayAnim(animator, "ride")
					if (this.show_gray) {
						let skin_mesh_renderers = local_Util.GetComponents(obj, local_Laya.SkinnedMeshSprite3D)
						let skin_mesh_renderer: Laya.SkinnedMeshSprite3D
						for (let i = 0; i < skin_mesh_renderers.length; i++) {
							skin_mesh_renderer = skin_mesh_renderers[i]
							if (skin_mesh_renderer) {
								let unlit_materials: Laya.UnlitMaterial[] = skin_mesh_renderer.skinnedMeshRenderer.materials as Laya.UnlitMaterial[]
								let unlit_material
								for (let i = 0; i < unlit_materials.length; i++) {
									unlit_material = unlit_materials[i]
									unlit_material.albedoColor = new local_Laya.Vector4(0.5, 0.5, 0.5, 1)
								}
							}
						}
					}
					else {
						this.LoadHorseParticle(this.horse_id)
					}

					delete this.is_loading_flag["horse"]
					this.CheckAllLoadCallback()

				}
				this.is_loading_flag["horse"] = true
				let local_model_abName = local_GameResPath.GetUIModelClotheRes(UI_MODEL_TYPE.HORSE, this.horse_id)
				let full_url = local_GameResPath.GetUITypePath(UI_MODEL_TYPE.HORSE, local_model_abName)
				let params = {
					module: "mount",
					name: "UI"
				}
				full_url += GetParams(params)
				this.resMgr.CreatePrefab(this.hashCode, full_url, loadHorseCallback, LOAD_QUEUE.HIGHT, true)
			} else {

				this.model_transform.owner.addChild(this.gameObject)
				local_Set3DLocalScale(this.transform, 5 * data.scale, 5 * data.scale, 5 * data.scale)

				let action_name_list = data.action_name_list || ["idle"]
				if (!local_Util.IsTableEmpty(action_name_list)) {
					let action_name: string = data.action_delta && action_name_list[0] || action_name_list.splice(0, 1)[0]
					if (action_name) {
						let animator = this.gameObject.getComponent(local_Laya.Animator)
						if (animator) {
							if (action_name.search("casual") > -1) {
								animator.speed = 1
							} else {
								animator.speed = this.custom_speed
							}
							local_CommonPlayAnim(animator, action_name)
							this.LoadActionParticle(action_name)
							if (!local_Util.IsTableEmpty(action_name_list)) {
								let next_frame = () => {
									this.delay_play_action_timer_list = this.delay_play_action_timer_list || []
									if (data.action_delta && local_Util.TableSize(action_name_list) > 1) {//设置了动作间隔，动作名列表>1才执行动做循环
										this.DelayPlayNextActionLoop(animator, action_name_list, data.action_delta)
									} else {
										this.DelayPlayNextAction(animator, action_name_list)
									}
								}
								setTimeout(next_frame, 10)
							}
						}
					}
				}
			}
			if (data.weapon_res_id) {
				this.CreateWeapon(this.type, data.weapon_res_id, data.career, data.weapon_clothe_id)
			}
			if (data.texture_id) {
				this.CreateClothTexture(data.fashion_model_id, data.texture_id)
			}

			if (data.wing_id) {
				this.CreateWing(this.type, data.wing_id)
			} else {
				this.LoadWingParticle(data.wing_id)
			}

			if (data.liveness_id) {
				this.LoadLivenessParticle(this.type, data.liveness_id)
			}

			if (data.head_wear_id) {
				this.CreateHeadWear(this.type, data.head_wear_id, data.head_clothe_id, data.career)
			}

			if (data.back_ornament_id) {
				this.CreateBackOrnament(this.type, data.back_ornament_id)
			}

			delete this.is_loading_flag["body"]
			this.CheckAllLoadCallback()
		}
		this.is_loading_flag["body"] = true


		let camera = this.cameraObject = scene.addChild(new local_Laya.Camera(0, 0.3, 1000)) as Laya.Camera
		local_Set3DLocalPosition(camera.transform, -curr_pos_index * UIModelClass3D.POS_STEP_VALUE, -curr_pos_index * UIModelClass3D.POS_STEP_VALUE, -20)
		local_Set3DLocalRotationEuler(camera.transform, 0, 180, 0)
		local_Set3DLocalScale(camera.transform, 1, 1, 1)
		//清除摄像机的标记
		// camera.clearFlag = Laya.CameraClearFlags.DepthOnly;
		camera.clearFlag = local_Laya.CameraClearFlags.SolidColor;
		camera.clearColor = new local_Laya.Vector4(0.0, 0.0, 0.0, 0.0);
		if (local_Util.IsConch() || local_Util.IsMTGame()) {
			camera.enableHDR = false
		} else {
			if (data.enableHDR) {
				camera.enableHDR = true
			}
			else {
				camera.enableHDR = false
			}
		}
		camera.orthographic = true
		camera.useOcclusionCulling = false
		// camera.msaa = true
		// camera.fieldOfView = 60
		camera.orthographicVerticalSize = 12.8;
		this.renderTexture = local_Laya.RenderTexture.createFromPool(this.parent.width * 1, this.parent.height * 1, local_Laya.RenderTextureFormat.R8G8B8A8, local_Laya.RenderTextureDepthFormat.DEPTH_16)
		camera.renderTarget = this.renderTexture
		let img = window["GetImageFromPool"]() || new local_Laya.Image();
		img.source = window["GetTextureFromPool"](this.renderTexture)
		this.parent.addChild(img);

		let local_model_abName = local_GameResPath.GetUIModelClotheRes(this.type, data.clothe_res_id)
		let full_url = local_GameResPath.GetUITypePath(this.type, local_model_abName)
		let ignore_pool = false
		if (this.type == UI_MODEL_TYPE.ROLE || this.type == UI_MODEL_TYPE.MAINROLE) {
			ignore_pool = true
		}
		let action_name_list = data.action_name_list
		if (!ignore_pool && !local_Util.IsTableEmpty(action_name_list)) //判断当前cache中的是否包含所有ui需要的展示动作
		{
			let cache_obj: Laya.Sprite3D = local_Laya.loader.getRes(full_url)
			if (cache_obj && !cache_obj.destroyed) {
				let animator = cache_obj.getComponent(local_Laya.Animator)
				if (animator) {
					let controller_layer: Laya.AnimatorControllerLayer = animator.getControllerLayer()
					if (!controller_layer) {
						ignore_pool = true
					} else {
						for (var i = 0; i < action_name_list.length; i++) {
							if (!controller_layer.getAnimatorState(action_name_list[i])) {
								ignore_pool = true
								break
							}
						}
					}
				}
			}
		}
		let params = {
			module: local_GameResPath.GetUITypeModuleName(this.type),
			id: data.clothe_res_id,
		}
		if (action_name_list && !data.loadAniByCfg) {
			params['action_name_list'] = action_name_list
		}

		if (data.layout_file) {
			params["name"] = data.layout_file
		}
		else {
			params["name"] = "UI"
		}

		full_url += GetParams(params)
		this.resMgr.CreatePrefab(this.hashCode, full_url, loadBodyCallback, LOAD_QUEUE.HIGHT, ignore_pool)
	}

	public CheckAllLoadCallback() {

		if (local_Util.TableSize(this.is_loading_flag, true) <= 0) {
			if (this.load_call_back) {
				let local_load_call_back = this.load_call_back
				this.load_call_back = null
				let delaycallback = () => {
					if (this.use_delete_method) { return }
					local_load_call_back(this.gameObject)
				}
				this.timer = setTimeout(delaycallback, 10) //延迟一下 避免回调后设置overrideSorting 失效
			}
		}
	}

	public CheckIsLoading() {

		if (local_Util.TableSize(this.is_loading_flag) > 0) {
			return true
		}
	}

	public ClearTimer() {

		if (this.timer) {
			clearTimeout(this.timer)
			this.timer = null
		}
	}

	//加载坐骑特效
	public LoadHorseParticle(clothe_res_id?) {
		this.RemoveHorseParticle()
		//加载坐骑配置特效
		if (clothe_res_id && this.horse_transform && this.horse_particle_dic == null) {
			let horse_pvo = Config.PRELOAD_CLIENT_CONFIG.SceneObjectParticle.Horse[clothe_res_id]
			if (horse_pvo && horse_pvo.always) {
				this.horse_particle_dic = {}
				let horse_particle_index = 0
				for (let bone_name in horse_pvo.always) {
					let particle_vos = horse_pvo.always[bone_name]
					let particle_vo_list
					if (particle_vos.length == null) {
						particle_vo_list = [particle_vos]
					}
					else {
						particle_vo_list = particle_vos
					}

					for (let particle_vo of particle_vo_list) {
						let local_index = horse_particle_index
						if (this.horse_particle_dic[local_index] == null) {
							this.horse_particle_dic[local_index] = { bone_name: bone_name, particle_name: particle_vo.name, particle_go: null }
							let bone
							bone = local_Util.FindBone(this.horse_gameObject, bone_name)
							if (bone) {
								let load_call_back = (obj) => {
									if (local_Util.IsNull(obj)) {
										bone = local_Util.FindBone(this.horse_gameObject, bone_name)
										console.warn("!!!!!!!!!!!!!!!!!!!!找不到特效资源 Load horse Particle" + particle_vo.name)
										return
									}
									if (!this.horse_transform || this.use_delete_method || this.horse_particle_dic == null || this.horse_particle_dic[local_index] == null) {
										obj.destroy()
										return
									}
									if (local_Util.IsNull(bone)) {
										obj.destroy()
										return
									}
									if (this.horse_particle_dic[local_index] && this.horse_particle_dic[local_index].particle_go) {
										obj.destroy()
										return
									}
									let new_go = obj
									let transform = new_go.transform
									bone.addChild(new_go)
									ResetTransform(transform)

									let x = (particle_vo && particle_vo.rotate && particle_vo.rotate.x) && particle_vo.rotate.x || 0
									let y = (particle_vo && particle_vo.rotate && particle_vo.rotate.y) && particle_vo.rotate.y || 0
									let z = (particle_vo && particle_vo.rotate && particle_vo.rotate.z) && particle_vo.rotate.z || 0

									local_Set3DLocalRotationEuler(transform, x, y, z)

									this.horse_particle_dic[local_index].particle_go = new_go
									delete this.is_loading_flag["horse_particle" + local_index]
									this.CheckAllLoadCallback()
								}
								this.is_loading_flag["horse_particle" + local_index] = true
								this.resMgr.CreatePrefab(this.hashCode, local_GameResPath.GetEffectPath(EffectResType.Horse, particle_vo.name), load_call_back)
							}
						}
						++horse_particle_index
					}
				}
			}
		}


	}

	public RemoveHorseParticle() {
		if (this.horse_particle_dic) {
			for (let index in this.horse_particle_dic) {
				var vo = this.horse_particle_dic[index]
				if (vo.particle_name && vo.particle_go) {
					vo.particle_go.destroy()
				}
			}
			this.horse_particle_dic = null
		}
	}

	//加载身体粒子特效
	public LoadBodyParticle(clothe_res_id?) {
		this.RemoveBodyParticle()
		if (clothe_res_id && this.transform && this.body_particle_dic == null) {

			let data = this.GetObjectParticleData(this.type)
			let cfg = data.cfg, effect_res_type = data.effect_res_type

			if (!cfg) return
			let body_pvo = cfg[clothe_res_id]
			if (body_pvo && body_pvo.always) {
				this.body_particle_dic = {}
				let body_particle_index = 0
				for (let bone_name in body_pvo.always) {
					let particle_vos = body_pvo.always[bone_name]
					let particle_vo_list
					if (particle_vos.length == null) {
						particle_vo_list = [particle_vos]
					}
					else {
						particle_vo_list = particle_vos
					}

					for (let particle_vo of particle_vo_list) {
						let local_index = body_particle_index
						if (this.body_particle_dic[local_index] == null) {
							this.body_particle_dic[local_index] = { particle_name: particle_vo.name, bone_name: bone_name, particle_go: null }
							let bone = local_Util.FindBone(this.gameObject, bone_name)
							if (bone) {
								let load_call_back = (obj: Laya.Sprite3D) => {
									if (local_Util.IsNull(obj)) {
										console.warn("!!!!!!!!!!!!!!!!!!!!找不到特效资源 load body particle " + particle_vo.name)
										return
									}
									if (this.use_delete_method || this.body_particle_dic == null || this.body_particle_dic[local_index] == null) {
										obj.destroy()
										return
									}
									if (this.body_particle_dic[local_index] && this.body_particle_dic[local_index].particle_go) {
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

									local_Set3DLocalPosition(transform, 0, 0, 0)
									local_Set3DLocalRotationEuler(transform, 0, 0, 0)
									let scale = particle_vo.scale || 1
									local_Set3DLocalScale(transform, scale, scale, scale)

									new_go.active = true
									this.body_particle_dic[local_index].particle_go = obj
									delete this.is_loading_flag["body_particle" + local_index]
									this.CheckAllLoadCallback()
								}
								this.is_loading_flag["body_particle" + local_index] = true
								this.resMgr.CreatePrefab(this.hashCode, local_GameResPath.GetEffectPath(effect_res_type, particle_vo.name), load_call_back)
							}
						}
						++body_particle_index
					}
				}
			}
		}
	}

	public GetObjectParticleData(type) {
		let cfg, effect_res_type, cfgs = Config.PRELOAD_CLIENT_CONFIG.SceneObjectParticle
		if (type == UI_MODEL_TYPE.MAINROLE || type == UI_MODEL_TYPE.ROLE) {
			cfg = cfgs.Body
			effect_res_type = EffectResType.Role
		} else if (type == UI_MODEL_TYPE.GOD) {
			cfg = cfgs.God
			effect_res_type = EffectResType.God
		} else if (type == UI_MODEL_TYPE.MONSTER) {
			cfg = cfgs.Monster
			effect_res_type = EffectResType.Monster
		} else if (type == UI_MODEL_TYPE.PARTNER) {
			cfg = cfgs.Pet
			effect_res_type = EffectResType.Pet
		} else if (type == UI_MODEL_TYPE.ARTIFACT) {
			cfg = cfgs.FaBao
			effect_res_type = EffectResType.ShengQi
		} else if (type == UI_MODEL_TYPE.SPRITE) {
			cfg = cfgs.Sprite
			effect_res_type = EffectResType.Sprite
		} else if (type == UI_MODEL_TYPE.DEMON) {
			cfg = cfgs.Demon
			effect_res_type = UI_MODEL_TYPE.DEMON
		} else if (type == UI_MODEL_TYPE.WEAPON) {
			cfg = cfgs.Weapon
			effect_res_type = EffectResType.Weapon
		} else if (type == UI_MODEL_TYPE.HORSE) {
			cfg = cfgs.Horse
			effect_res_type = EffectResType.Horse
		} else if (type == UI_MODEL_TYPE.WING) {
			cfg = cfgs.Wing
			effect_res_type = EffectResType.Wing
		} else if (type == UI_MODEL_TYPE.BACKORNAMENT) {
			cfg = cfgs.BackOrnament
			effect_res_type = EffectResType.BackOrnament
		} else if (type == UI_MODEL_TYPE.GHOST) {
			cfg = cfgs.Ghost
			effect_res_type = EffectResType.Ghost
		}
		return { cfg, effect_res_type }
	}

	public RemoveBodyParticle() {
		if (this.body_particle_dic) {
			for (let index in this.body_particle_dic) {
				var vo = this.body_particle_dic[index]
				if (vo.particle_name && vo.particle_go) {
					vo.particle_go.destroy()
				}
			}
			this.body_particle_dic = null
		}
	}


	//加载武器粒子特效
	public LoadWeaponParticle(weapon_res_id?) {
		if (UIModelClass3D.no_particle) return
		this.RemoveWeaponParticle()
		if (!local_Util.IsTableEmpty(this.weapon_container) && weapon_res_id && weapon_res_id > 0 && this.weapon_particle_dic == null) {
			let weapon_pvo = Config.PRELOAD_CLIENT_CONFIG.SceneObjectParticle.Weapon[weapon_res_id]
			if (weapon_pvo && weapon_pvo.always) {
				this.weapon_particle_dic = {}
				for (let bone_name in weapon_pvo.always) {
					let particle_vo = weapon_pvo.always[bone_name]
					for (let weapon_bone_name in this.weapon_container) {
						let vo = this.weapon_container[weapon_bone_name]
						if (vo && vo.go) {
							let bone = local_Util.FindBone(vo.go, bone_name)
							if (bone) {
								if (this.weapon_particle_dic[weapon_bone_name] == null) {
									this.weapon_particle_dic[weapon_bone_name] = []
								}

								if (this.weapon_particle_dic[weapon_bone_name][bone_name] == null) {
									this.weapon_particle_dic[weapon_bone_name][bone_name] = { particle_name: particle_vo.name, particle_go: null }
									let load_call_back = (obj) => {
										if (local_Util.IsNull(obj)) {
											console.warn("!!!!!!!!!!!!!!!!!!!!找不到特效资源 Load weapon Particle" + particle_vo.name)
											return
										}
										if (this.use_delete_method
											|| this.weapon_particle_dic == null
											|| this.weapon_particle_dic[weapon_bone_name] == null
											|| this.weapon_particle_dic[weapon_bone_name][bone_name] == null) {
											obj.destroy()
											return
										}
										if (local_Util.IsNull(bone)) {
											obj.destroy()
											return
										}
										if (this.weapon_particle_dic[weapon_bone_name]
											&& this.weapon_particle_dic[weapon_bone_name][bone_name]
											&& this.weapon_particle_dic[weapon_bone_name][bone_name].particle_go) {
											obj.destroy()
											return
										}
										obj.visible = true

										let new_go = obj
										bone.addChild(new_go)

										ResetTransform(new_go.transform)
										this.weapon_particle_dic[weapon_bone_name][bone_name].particle_go = new_go
										delete this.is_loading_flag["weapon_particle" + bone_name]
										this.CheckAllLoadCallback()
									}
									this.is_loading_flag["weapon_particle" + bone_name] = true
									this.resMgr.CreatePrefab(this.hashCode, local_GameResPath.GetEffectPath(EffectResType.Weapon, particle_vo.name), load_call_back)
								}
							}
						}
					}
				}
			}
		}
	}

	public RemoveWeaponParticle() {
		if (this.weapon_particle_dic) {
			for (let weapon_bone_name in this.weapon_particle_dic) {
				let weapon_vo = this.weapon_particle_dic[weapon_bone_name]
				for (let bone_name in weapon_vo) {
					let vo = weapon_vo[bone_name]
					if (vo.particle_name && !local_Util.IsNull(vo.particle_go)) {
						vo.particle_go.destroy()
					}
				}
			}
			this.weapon_particle_dic = null
		}
	}

	public RemoveBackOrnamentParticle() {
		if (this.back_ornament_particle_dic) {
			for (let bone_name in this.back_ornament_particle_dic) {
				var vo = this.back_ornament_particle_dic[bone_name]
				if (vo.particle_name && vo.particle_go) {
					vo.particle_go.destroy()
				}
			}
			this.back_ornament_particle_dic = null
		}
	}

	public RemoveLivenessParticle() {
		if (this.liveness_particle) {
			this.liveness_particle.destroy()
			this.liveness_particle = null
		}
	}

	//加载翅膀粒子特效
	public LoadWingParticle(wing_id?) {
		if (UIModelClass3D.no_particle) return
		this.RemoveWingParticle()
		if (wing_id && wing_id > 0 && this.wing_transform && this.wing_particle_dic == null) {
			let wing_pvo = Config.PRELOAD_CLIENT_CONFIG.SceneObjectParticle.Wing[wing_id]
			if (wing_pvo && wing_pvo.always) {
				this.wing_particle_dic = {}
				for (let bone_name in wing_pvo.always) {
					let particle_vo = wing_pvo.always[bone_name]
					if (this.wing_particle_dic[bone_name] == null) {
						this.wing_particle_dic[bone_name] = { particle_name: particle_vo.name, particle_go: null }
						let bone = local_Util.FindBone(this.wing_gameObject, bone_name)
						if (bone) {
							let load_call_back = (obj: Laya.Sprite3D) => {
								if (local_Util.IsNull(obj)) {
									console.warn("!!!!!!!!!!!!!!!!!!!!找不到特效资源 Load wing Particle" + particle_vo.name)
									return
								}

								if (!this.wing_transform || this.use_delete_method || !this.wing_particle_dic || this.wing_particle_dic[bone_name] == null) {
									obj.destroy()
									return
								}
								//这里必须要重新获取一次,可能有多次加载这个bone 上面的bone可能是之前删除的,但是引用还在
								let bone = local_Util.FindBone(this.wing_gameObject, bone_name)
								if (local_Util.IsNull(bone)) {
									obj.destroy()
									return
								}
								if (this.wing_particle_dic[bone_name] && this.wing_particle_dic[bone_name].particle_go) {
									obj.destroy()
									return
								}

								obj.active = true

								let new_go = obj
								let transform = new_go.transform
								bone.addChild(new_go)
								ResetTransform(transform)
								this.wing_particle_dic[bone_name].particle_go = new_go

								delete this.is_loading_flag["wing_particle" + bone_name]
								this.CheckAllLoadCallback()

							}
							this.is_loading_flag["wing_particle" + bone_name] = true
							this.resMgr.CreatePrefab(this.hashCode, local_GameResPath.GetEffectPath(EffectResType.Wing, particle_vo.name), load_call_back)
						}
					}
				}
			}
		}
	}

	public RemoveWingParticle() {
		if (this.wing_particle_dic) {
			for (let bone_name in this.wing_particle_dic) {
				var vo = this.wing_particle_dic[bone_name]
				if (vo.particle_name && vo.particle_go) {
					vo.particle_go.destroy()
				}
			}
			this.wing_particle_dic = null
		}
	}

	//加载动作粒子特效
	public LoadActionParticle(action_name) {
		if (UIModelClass3D.no_particle) return
		this.RemoveActionParticle()

		if (this.clothe_res_id && this.transform && this.action_particle_dic == null) {
			let data = this.GetObjectParticleData(this.type)
			let cfg = data.cfg, effect_res_type = data.effect_res_type

			if (!cfg) return
			let body_pvo = cfg[this.clothe_res_id]
			if (body_pvo && body_pvo.action && body_pvo.action[action_name]) {
				this.action_particle_dic = {}
				let local_action_index = 0
				for (let bone_name in body_pvo.action[action_name]) {
					let particle_vos = body_pvo.action[action_name][bone_name]
					let particle_vo_list
					if (particle_vos.length == null) {
						particle_vo_list = [particle_vos]
					}
					else {
						particle_vo_list = particle_vos
					}
					for (let particle_vo of particle_vo_list) {
						let local_index = local_action_index
						if (this.action_particle_dic[local_index] == null) {
							this.action_particle_dic[local_index] = { particle_name: particle_vo.name, bone_name: bone_name, particle_go: null }
							let bone = local_Util.FindBone(this.gameObject, bone_name)
							if (bone) {
								let load_call_back = (obj: Laya.Sprite3D) => {
									if (local_Util.IsNull(obj)) {
										console.warn("!!!!!!!!!!!!!!!!!!!!找不到特效资源 load body particle " + particle_vo.name)
										return
									}
									if (this.use_delete_method || this.action_particle_dic == null || this.action_particle_dic[local_index] == null) {
										obj.destroy()
										return
									}
									if (this.action_particle_dic[local_index] && this.action_particle_dic[local_index].particle_go) {
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

									local_Set3DLocalPosition(transform, 0, 0, 0)
									local_Set3DLocalRotationEuler(transform, 0, 0, 0)
									let scale = particle_vo.scale || 1
									local_Set3DLocalScale(transform, scale, scale, scale)

									new_go.active = true
									this.action_particle_dic[local_index].particle_go = obj
								}
								this.resMgr.CreatePrefab(this.hashCode, local_GameResPath.GetEffectPath(effect_res_type, particle_vo.name), load_call_back)
							}
						}
						++local_action_index
					}
				}
			}
		}
	}

	public RemoveActionParticle() {
		if (this.action_particle_dic) {
			for (let index in this.action_particle_dic) {
				var vo = this.action_particle_dic[index]
				if (vo.particle_name && vo.particle_go) {
					vo.particle_go.destroy()
				}
			}
			this.action_particle_dic = null
		}
	}

	//加载活跃度粒子特效
	public LoadLivenessParticle(_type?, liveness_id?) {
		if (UIModelClass3D.no_particle) return
		this.RemoveLivenessParticle()
		if (this.transform && liveness_id && liveness_id != 0) {
			let config_dragon_ball_figure = Config.PRELOAD_SERVER_CONFIG.config_dragon_ball_figure
			if (!config_dragon_ball_figure) return
			let cfg
			for (let key in config_dragon_ball_figure) {
				var v = config_dragon_ball_figure[key]
				if (v.id == liveness_id) {
					cfg = v
					break
				}
			}
			if (!cfg) return
			let effect_name = cfg.model_id
			let transform = this.transform
			if (transform) {
				let load_call_back = (obj: Laya.Sprite3D) => {
					if (local_Util.IsNull(obj)) {
						console.warn("!!!!!!!!!!!!!!!!!!!!找不到特效资源 Load Other Particle" + effect_name)
						return
					}

					if (!this.transform || this.use_delete_method) {
						obj.destroy()
						return
					}

					obj.active = true
					this.root_transform.owner.addChild(obj)
					ResetTransform(obj.transform)
					local_Set3DLocalRotationEuler(obj.transform, this.rotate.x, this.rotate.y, this.rotate.z)
					local_Set3DLocalScale(obj.transform, 5 * this.scale, 5 * this.scale, 5 * this.scale)

					this.liveness_particle = obj

					delete this.is_loading_flag["liveness_particle"]
					this.CheckAllLoadCallback()
				}
				this.is_loading_flag["liveness_particle"] = true
				this.resMgr.CreatePrefab(this.hashCode, local_GameResPath.GetEffectPath(EffectResType.XingHe, effect_name), load_call_back)
			}
		}
	}

	//加载背饰粒子特效
	public LoadBackOrnamentParticle(back_ornament_id?) {
		if (UIModelClass3D.no_particle) return
		this.RemoveBackOrnamentParticle()
		if (back_ornament_id && back_ornament_id > 0 && this.back_ornament_transform && this.back_ornament_particle_dic == null) {
			let back_ornament_pvo = Config.PRELOAD_CLIENT_CONFIG.SceneObjectParticle.BackOrnament[back_ornament_id]
			if (back_ornament_pvo && back_ornament_pvo.always) {
				this.back_ornament_particle_dic = {}
				for (let bone_name in back_ornament_pvo.always) {
					let particle_vo = back_ornament_pvo.always[bone_name]
					if (this.back_ornament_particle_dic[bone_name] == null) {
						this.back_ornament_particle_dic[bone_name] = { particle_name: particle_vo.name, particle_go: null }
						let bone = local_Util.FindBone(this.back_ornament_gameObject, bone_name)
						if (bone) {
							let load_call_back = (obj: Laya.Sprite3D) => {
								if (local_Util.IsNull(obj)) {
									console.warn("!!!!!!!!!!!!!!!!!!!!找不到特效资源 Load back_ornament Particle" + particle_vo.name)
									return
								}

								if (!this.back_ornament_transform || this.use_delete_method || !this.back_ornament_particle_dic || this.back_ornament_particle_dic[bone_name] == null) {
									obj.destroy()
									return
								}
								//这里必须要重新获取一次,可能有多次加载这个bone 上面的bone可能是之前删除的,但是引用还在
								let bone = local_Util.FindBone(this.back_ornament_gameObject, bone_name)
								if (local_Util.IsNull(bone)) {
									obj.destroy()
									return
								}
								if (this.back_ornament_particle_dic[bone_name] && this.back_ornament_particle_dic[bone_name].particle_go) {
									obj.destroy()
									return
								}

								obj.active = true

								let new_go = obj
								let transform = new_go.transform
								bone.addChild(new_go)
								ResetTransform(transform)
								this.back_ornament_particle_dic[bone_name].particle_go = new_go

								delete this.is_loading_flag["back_particle" + bone_name]
								this.CheckAllLoadCallback()

							}
							this.is_loading_flag["back_particle" + bone_name] = true
							this.resMgr.CreatePrefab(this.hashCode, local_GameResPath.GetEffectPath(EffectResType.BackOrnament, particle_vo.name), load_call_back)
						}
					}
				}
			}
		}
	}

	public ChangeWeapon(weapon_res_id?, career?, weapon_clothe_id?) {

		if (!weapon_res_id || weapon_res_id != this.weapon_res_id) {
			this.weapon_res_id = weapon_res_id
			this.weapon_clothe_id = weapon_clothe_id
			this.CreateWeapon(this.type, weapon_res_id, career, weapon_clothe_id)
		}
	}
	//创建武器
	public CreateWeapon(_type?, weapon_res_id?, career?, weapon_clothe?) {

		if (weapon_res_id) {
			let [weapon_attach_list, weapon_res_list] = local_GameResPath.GetWeaponRes(_type, weapon_res_id, career, true)
			this.weapon_container = {}
			let load_call_back = (objs) => {
				if (this.transform) {
					if (this.use_delete_method) {
						if (objs) {
							for (let i = 0; i < objs.length; i++) {
								let obj = objs[i]
								obj.destroy()
							}
						}
						return
					}
					if (weapon_attach_list && objs) {
						let bone_go = null
						for (let k = 0; k < weapon_attach_list.length; k++) {
							let boneName = weapon_attach_list[k]
							bone_go = local_Util.FindBone(this.transform.owner, boneName)
							if (bone_go) {
								if (local_Util.IsNull(objs[k])) {
									console.warn("!!!!!!!!!!!!can ! load weapon res_name = ", weapon_res_list[k])
									return
								}
								let go = objs[k]
								// go.setParent(bone_go)
								bone_go.addChild(go)
								ResetTransform(go.transform)
								this.weapon_container[boneName] = {
									go: go,
									res_name: weapon_res_list[k],
									index: k,
									mesh: null,
									default_mainTexture: null,
									default_shader: null
								}
							}
						}
					}
					if (this.show_gray) {
						let data
						for (let name in this.weapon_container) {
							data = this.weapon_container[name]
							let skin_mesh_renderer: Laya.SkinnedMeshSprite3D = local_Util.GetComponent(data.go, local_Laya.SkinnedMeshSprite3D)
							if (skin_mesh_renderer) {
								let unlit_materials: Laya.UnlitMaterial[] = skin_mesh_renderer.skinnedMeshRenderer.materials as Laya.UnlitMaterial[]
								let unlit_material: Laya.UnlitMaterial
								for (let i = 0; i < unlit_materials.length; i++) {
									unlit_material = unlit_materials[i]
									unlit_material.albedoColor = new local_Laya.Vector4(0.5, 0.5, 0.5, 1)
								}
							}
						}
					}
					else {
						this.LoadWeaponParticle(weapon_res_id)
					}

				}
			}
			if (this.transform && weapon_res_list) {
				let objs = []
				let length = weapon_res_list.length
				let call_back = (obj) => {
					objs.push(obj)
					if (length == objs.length) {
						load_call_back(objs)
						delete this.is_loading_flag["weapon"]
						this.CheckAllLoadCallback()
					}
				}
				let params = {
					module: "weapon",
					name: "AttachActionList", //挂在角色身上的武器只用idle，其他单独展示的会有另外的动作
				}
				this.is_loading_flag["weapon"] = true
				for (let i in weapon_res_list) {
					let full_url = local_GameResPath.GetObjectPath("weapon", weapon_res_list[i])
					full_url += GetParams(params)
					this.resMgr.CreatePrefab(this.hashCode, full_url, call_back)
				}
			}
		}
	}

	//时装衣服贴图
	public CreateClothTexture(fashion_model_id?, texture_id?) {

		this.fashion_model_id = fashion_model_id
		this.texture_id = texture_id
		if (fashion_model_id && texture_id && Number(texture_id) != 0 && this.gameObject) { //使用贴图
			if (this.clothe) {
				this.clothe.DeleteMe()
				this.clothe = null
			}
			let texture_res = ModelPartName[1] + fashion_model_id + "_" + texture_id
			if (!this.skin_mesh_renderer) {
				this.skin_mesh_renderer = GetSkinnedMeshSprite3D(this.gameObject)
			}
			if (this.skin_mesh_renderer && this.skin_mesh_renderer.skinnedMeshRenderer && texture_res) {
				if (!this.clothe)
					this.clothe = new Clothe(this.skin_mesh_renderer.skinnedMeshRenderer.material, texture_res)
				else
					this.clothe.LoadTexture(this.skin_mesh_renderer.skinnedMeshRenderer.material, texture_res)
			}
		}
	}

	//创建翅膀
	public CreateWing(_type?, wing_id?, is_god_wing?) {

		if (wing_id && wing_id > 0 && this.gameObject) {
			let load_call_back = (obj: Laya.Sprite3D) => {
				if (this.use_delete_method) {
					if (obj) obj.destroy()
					return
				}
				if (local_Util.IsNull(obj)) {
					console.warn("cannot find wing res = " + wing_id)
					return
				}
				let bone = local_Util.FindBone(this.transform.owner, AttachNode.Wing)
				if (bone == null) {
					return
				}

				this.wing_gameObject = obj
				this.wing_transform = obj.transform

				bone.addChild(obj)
				ResetTransform(obj.transform)

				if (this.show_gray) {
					let skin_mesh_renderer: Laya.SkinnedMeshSprite3D = local_Util.GetComponent(obj, local_Laya.SkinnedMeshSprite3D)
					if (skin_mesh_renderer) {
						let unlit_materials: Laya.UnlitMaterial[] = skin_mesh_renderer.skinnedMeshRenderer.materials as Laya.UnlitMaterial[]
						let unlit_material: Laya.UnlitMaterial
						for (let i = 0; i < unlit_materials.length; i++) {
							unlit_material = unlit_materials[i]
							unlit_material.albedoColor = new local_Laya.Vector4(0.5, 0.5, 0.5, 1)
						}
					}
				}
				else {
					this.LoadWingParticle(wing_id)
				}

				delete this.is_loading_flag["wing"]
				this.CheckAllLoadCallback()

			}
			let wing_abName = local_GameResPath.GetUIModelClotheRes(UI_MODEL_TYPE.WING, wing_id)
			if (wing_abName) {
				this.is_loading_flag["wing"] = true
				let full_url = local_GameResPath.GetObjectPath("wing", wing_abName)
				let params = {
					module: "wing",
					name: "UI"
				}
				full_url += GetParams(params)
				this.resMgr.CreatePrefab(this.hashCode, full_url, load_call_back)
			}
		}
	}

	//创建发型
	public CreateHeadWear(_type?, head_wear_id?, head_clothe_id?, career?) {

		if (head_wear_id && head_wear_id > 0) {//and ! this.HasBlockSetting("hat"
			let local_headWear_abName = local_GameResPath.GetHeadRes(_type, head_wear_id)
			let load_call_back = (obj: Laya.Sprite3D) => {
				if (local_Util.IsNull(obj)) {
					console.warn("LoadHeadWearRes cannot find headWear res = " + head_wear_id)
					return
				}


				if (this.use_delete_method || !this.transform) {
					obj.destroy()
					return
				}

				let bone = local_Util.FindBone(this.transform.owner, AttachNode.Head)
				if (bone == null) {
					return
				}
				if (this.default_head_go) {
					this.default_head_go.removeSelf()
					this.default_head_go = null
				}
				bone.addChild(obj)
				ResetTransform(obj.transform)
				let headWear_skin_mesh_renderer: Laya.SkinnedMeshSprite3D = GetSkinnedMeshSprite3D(obj)
				if (headWear_skin_mesh_renderer) {
					this.headWear_skin_mesh_renderer = headWear_skin_mesh_renderer
				}

				this.ChangeHeadClotheRes()

				if (this.show_gray) {
					let skin_mesh_renderer: Laya.SkinnedMeshSprite3D = local_Util.GetComponent(obj, local_Laya.SkinnedMeshSprite3D)
					if (skin_mesh_renderer) {
						let unlit_materials: Laya.UnlitMaterial[] = skin_mesh_renderer.skinnedMeshRenderer.materials as Laya.UnlitMaterial[]
						let unlit_material: Laya.UnlitMaterial
						for (let i = 0; i < unlit_materials.length; i++) {
							unlit_material = unlit_materials[i]
							unlit_material.albedoColor = new local_Laya.Vector4(0.5, 0.5, 0.5, 1)
						}
					}
				}

				delete this.is_loading_flag["head"]
				this.CheckAllLoadCallback()
			}
			if (local_headWear_abName) {
				this.is_loading_flag["head"] = true
				if (career) {
					this.default_head_go = this.resMgr.default_head_objs[career]
					if (this.default_head_go) {
						let bone = local_Util.FindBone(this.transform.owner, AttachNode.Head)
						if (bone == null) {
							return
						}
						bone.addChild(this.default_head_go)
						ResetTransform(this.default_head_go.transform)
					}
				}
				let full_url = local_GameResPath.GetObjectPath("head", local_headWear_abName);
				let params = {
					module: "head",
					name: "UI"
				}
				full_url += GetParams(params)
				this.resMgr.CreatePrefab(this.hashCode, full_url, load_call_back)
			}
		}
	}

	public ChangeHeadClotheRes() {

		if (!local_Util.IsNull(this.headWear_skin_mesh_renderer) && this.head_clothe_id) {
			let unlit_material: Laya.UnlitMaterial = this.headWear_skin_mesh_renderer.skinnedMeshRenderer.material as Laya.UnlitMaterial
			if (this.head_clothe_id && Number(this.head_clothe_id) != 0) {
				let texture_res = ModelPartName[6] + this.head_wear_id + "_" + this.head_clothe_id
				if (!this.head_clothe)
					this.head_clothe = new Clothe(unlit_material, texture_res)
				else
					this.head_clothe.LoadTexture(unlit_material, texture_res)
			}
		}
	}

	public CreateBackOrnament(_type?, back_ornament_id?) {
		if (back_ornament_id && back_ornament_id > 0 && this.gameObject) {
			let load_call_back = (obj: Laya.Sprite3D) => {
				if (this.use_delete_method) {
					if (obj) obj.destroy()
					return
				}
				if (local_Util.IsNull(obj)) {
					console.warn("cannot find back_ornament res = " + back_ornament_id)
					return
				}
				let bone = local_Util.FindBone(this.transform.owner, AttachNode.BackOrnament)
				if (bone == null) {
					return
				}

				this.back_ornament_gameObject = obj
				this.back_ornament_transform = obj.transform

				bone.addChild(obj)
				ResetTransform(obj.transform)

				if (this.show_gray) {
					let skin_mesh_renderer: Laya.SkinnedMeshSprite3D = local_Util.GetComponent(obj, local_Laya.SkinnedMeshSprite3D)
					if (skin_mesh_renderer) {
						let unlit_materials: Laya.UnlitMaterial[] = skin_mesh_renderer.skinnedMeshRenderer.materials as Laya.UnlitMaterial[]
						let unlit_material: Laya.UnlitMaterial
						for (let i = 0; i < unlit_materials.length; i++) {
							unlit_material = unlit_materials[i]
							unlit_material.albedoColor = new local_Laya.Vector4(0.5, 0.5, 0.5, 1)
						}
					}
				}
				else {
					this.LoadBackOrnamentParticle(back_ornament_id)
				}

				delete this.is_loading_flag["back"]
				this.CheckAllLoadCallback()

			}
			let back_abName = local_GameResPath.GetUIModelClotheRes(UI_MODEL_TYPE.BACKORNAMENT, back_ornament_id)
			if (back_abName) {
				this.is_loading_flag["back"] = true
				let full_url = local_GameResPath.GetObjectPath("back", back_abName)
				let params = {
					module: "back",
					name: "UI"
				}
				full_url += GetParams(params)
				this.resMgr.CreatePrefab(this.hashCode, full_url, load_call_back)
			}
		}
	}


	public AddEvents() {

		if (this.can_rotate || this.can_click) {
			let is_drag = false
			let touch_begin = (e: Laya.Event) => {
				is_drag = false
				this.pos_x = e.stageX
				local_Laya.stage.on(local_Laya.Event.MOUSE_MOVE, this, draging)
				local_Laya.stage.on(local_Laya.Event.MOUSE_UP, this, touch_end)
				local_Laya.stage.on(local_Laya.Event.MOUSE_OUT, this, touch_end)
			}
			let draging = (e: Laya.Event) => {
				if (e.stageX != this.pos_x) {
					is_drag = true
					if (this.can_rotate) {
						this.OnDragging(e.stageX)
					}
				}
			}
			let touch_end = (e: Laya.Event) => {
				local_Laya.stage.off(local_Laya.Event.MOUSE_MOVE, this, draging)
				local_Laya.stage.off(local_Laya.Event.MOUSE_UP, this, touch_end)
				local_Laya.stage.off(local_Laya.Event.MOUSE_OUT, this, touch_end)
				if (!is_drag && this.click_call_back) {
					this.click_call_back()
				}
			}
			this.parent.on(local_Laya.Event.MOUSE_DOWN, this, touch_begin)
		}

	}

	public OnDragging(pos_x?) {

		if (pos_x && this.pos_x) {
			let delta_x = pos_x - this.pos_x
			if (this.transform) {
				if (delta_x > 0) {
					this.rotate.y += 5
				} else {
					this.rotate.y -= 5
				}
				this.model_transform.localRotationEulerY = this.rotate.y
				// if (this.horse_transform) {
				// 	this.horse_transform.localRotationEulerY = this.rotate.y
				// } else {
				// 	this.transform.localRotationEulerY = this.rotate.y
				// }
				this.pos_x = pos_x
			}
		} else {
			console.log("//-UIModelClass3d//OnDragging-pos_x-:", pos_x)
		}
	}

	//主动删除所有挂接特效
	public RemoveAllParticle() {
		this.RemoveBodyParticle()
		this.RemoveHorseParticle()
		this.RemoveWeaponParticle()
		this.RemoveWingParticle()
		this.RemoveBoneParticleEffect()
		this.RemoveActionParticle()
		this.RemoveLivenessParticle()
	}

	public PlayIdelAnim() {

		if (this.gameObject) {
			let animator = this.gameObject.getComponent(local_Laya.Animator)
			if (animator) {
				animator.speed = this.custom_speed
				animator.CrossFade("idle", 0, 0.0)
			}
		}
	}

	public ChangeRotate(rotate?) {

		if (!rotate && this.rotate == 0) {
			return
		}
		let rotate_type = typeof (rotate)
		if (rotate_type == "number") {
			this.model_transform.rotate(new local_Laya.Vector3(0, 180 + (rotate), 0))
			this.rotate = rotate
		} else if (rotate_type == "object") {
			this.model_transform.localRotationEuler = rotate
			this.rotate = rotate.y
		} else {
			this.model_transform.rotate(new local_Laya.Vector3(0, 180, 0))
			this.rotate = 0
		}
	}

	public AddBoneParticleEffect(bone, effect_res_type, effect_name) {
		let load_call_back = (obj: Laya.Sprite3D) => {
			if (obj == null || local_Util.IsNull(obj)) {
				console.warn("!!!!!!!!!!!!!!!!!!!!找不到特效资源 Load Particle" + effect_name)
				return
			}
			if (this.use_delete_method) {
				obj.destroy()
				return
			}
			if (local_Util.IsNull(bone)) {
				obj.destroy()
				return
			}
			obj.active = false
			bone.addChild(obj)
			ResetTransform(obj.transform)
			if (!this.bone_particle_list) {
				this.bone_particle_list = []
			}
			table.insert(this.bone_particle_list, obj)
			delete this.is_loading_flag[`${effect_res_type}@${effect_name}`]
			this.CheckAllLoadCallback()
		}
		this.is_loading_flag[`${effect_res_type}@${effect_name}`] = true
		let full_url = local_GameResPath.GetEffectPath(effect_res_type, effect_name)
		this.resMgr.CreatePrefab(this.hashCode, full_url, load_call_back)
	}

	public PlayBoneparticle() {
		if (this.bone_particle_list) {
			for (let obj of this.bone_particle_list) {
				obj.active = true
			}
		}
	}

	public RemoveBoneParticleEffect() {
		if (this.bone_particle_list) {
			for (let obj of this.bone_particle_list) {
				obj.destroy()
			}
			this.bone_particle_list = undefined
		}
	}
}
window["UIModelClass3D"] = UIModelClass3D