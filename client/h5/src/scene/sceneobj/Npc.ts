import { AutoFightManager } from "../../autofight/AutoFightManager"
import { Config } from "../../common/Config"
import { SceneEventType } from "../../common/EventName"
import { GlobalEventSystem } from "../../util/DeclareGlobalVar"
import { GetAnimatorState, GlobalTimerQuest, Util } from "../../util/Util"
import { Scene } from "../Scene"
import { SceneBaseType } from "../SceneConfig"
import { SceneManager } from "../SceneManager"
import { Character } from "./Character"
import { SceneObj } from "./SceneObj"

let local_SceneBaseType = SceneBaseType
let local_SceneObj = SceneObj
let local_GlobalEventSystem = GlobalEventSystem
let local_GlobalTimerQuest = GlobalTimerQuest
let local_SceneEventType = SceneEventType
export class Npc extends Character {
	assign_angle
	default_angle
	delay_id
	event_id
	event_id2
	event_id3
	idle_event_id
	move_end_id
	replay_event_id
	restore_id
	static DefaultCasualAniName = "casual1"
	static CasualAniList = ["casual1"]
	public constructor() {
		super()
		this._type = local_SceneBaseType.Npc
	}


	public DeleteMe() {
		this.ClearNpc()
		super.DeleteMe()
	}

	public ReleaseObj() {
		// if (this.name_board) {
		// 	this.name_board.SetHpVisible(true)
		// }
		this.DoStand()
		this.ClearNpc()
		this.ReleaseCharacter()
	}

	public ResetObj() {

		this.ResetCharacter()
	}

	public ClearNpc() {

		if (this.event_id) {
			local_GlobalTimerQuest.CancelQuest(this.event_id)
			this.event_id = null
		}
		if (this.idle_event_id) {
			local_GlobalTimerQuest.CancelQuest(this.idle_event_id)
			this.idle_event_id = null
		}
		if (this.replay_event_id) {
			local_GlobalTimerQuest.CancelQuest(this.replay_event_id)
			this.replay_event_id = null
		}
		if (this.restore_id) {
			local_GlobalTimerQuest.CancelQuest(this.restore_id)
			this.restore_id = null
		}
		if (this.delay_id) {
			local_GlobalTimerQuest.CancelQuest(this.delay_id)
			this.delay_id = null
		}
		if (this.event_id2) {
			local_GlobalEventSystem.UnBind(this.event_id2)
			this.event_id2 = null
		}
		if (this.event_id3) {
			local_GlobalEventSystem.UnBind(this.event_id3)
			this.event_id3 = null
		}
		if (this.vo) {
			this.vo.DeleteMe()
			this.vo = false
		}
		this.CancelTalkTime()
	}

	public InitNpc(vo?) {
		this.id = vo.instance_id
		this.vo = vo
		this.name = this.vo.name
		this.assign_angle = this.vo.assign_angle
		this.compress_id = this.scene.CompressObjId(local_SceneBaseType.Npc, this.id)
		this.SetHideNameBord(false)
		let cfg = Config.GetConfigVo("config_npc", this.vo.type_id, false)
		if (this.name_board) {
			let str = ""//this.vo.name
			if (cfg && cfg.title && cfg.title !="" ) {
				str = `<${cfg.title}>`
			}
			this.name_board.SetName(str, "#fcf910",36)
			this.name_board.SetNpcName(this.vo.name)
			this.name_board.SetHpVisible(false)
		}
		if (cfg && cfg.icon_scale) {
			this.scale = Number(cfg.icon_scale)
		}
		this.SetRealPos(this.vo.pos_x, this.vo.pos_y, true)
		this.BindVoEvents()

		let call_func = (instance_id?) => {
			if (instance_id == this.id) {
				if (this.restore_id) {
					local_GlobalTimerQuest.CancelQuest(this.restore_id)
					this.restore_id = null
				}
			}
		}
		this.event_id2 = local_GlobalEventSystem.Bind(local_SceneEventType.DIALOGUE_VIEW_IS_OPEN, call_func)

		let dialogue_close = (instance_id?) => {
			if (instance_id == this.id) {
				this.RestoreDirection()
			}
		}
		this.event_id3 = local_GlobalEventSystem.Bind(local_SceneEventType.DIALOGUE_VIEW_IS_CLOSE, dialogue_close)

		this.NpcClothChange()
		this.DoStand()


		//这个npc特殊处理
		if (this.id == 10039010) {
			this.SetBodyXY(0, -120)
			if (this.name_board) {
				this.name_board.SetVisible(false)
			}
			this.can_pick = false
		}
		
		this.CreatTalkTimer()
	}

	public EnterStateStand(state_name?) {
		if (this.vo && this.vo.icon == 3010200) {
			this.PlayAction("idle2")
		} else {
			this.PlayAction("idle")
		}
	}

	//绑定vo事件，因为vo在外部会改变
	public BindVoEvents() {
		this.SetPickInfo(true)
	}

	public LoadClotheResComplete() {
		super.LoadClotheResComplete()
		this.default_angle = this.GetDirectionAngle()  //npc初始的，默认的角度
		this.SetRotate()
		this.PlayAnimation()
	}
	
	public NpcClothChange() {
		this.CreateClotheSprite(this.vo.icon, null, this.vo.icon_res_type)
	}

	public BirthAngleChange() {

	}

	//设置自定义角度
	public SetRotate() {
		if (this.assign_angle != -1) {
			//加90方便策划填配置
			this.SetRotateY(this.assign_angle + 90)
			return
		}
		let fly_talk_npc_id = AutoFightManager.GetInstance().GetFlyTalkNpcId()
		if (fly_talk_npc_id == this.id) {
			let angle = AutoFightManager.GetInstance().GetFlyTalkAngle()
			AutoFightManager.GetInstance().ClearFlyTalkNpcInfo()
			this.SetRotateY(angle, null, true)
			return
		}
		if (this.default_angle) {
			this.SetRotateY(this.default_angle)
		}
	}

	public EnterStateMove(state_name?) {
		super.EnterStateMove(state_name)
		if (this.idle_event_id) {
			local_GlobalTimerQuest.CancelQuest(this.idle_event_id)
			this.idle_event_id = null
		}
		if (this.replay_event_id) {
			local_GlobalTimerQuest.CancelQuest(this.replay_event_id)
			this.replay_event_id = null
		}
	}

	public QuitStateMove(state_name?) {
		super.QuitStateMove(state_name)
		if (this.delay_id) {
			local_GlobalTimerQuest.CancelQuest(this.delay_id)
			this.delay_id = null
		}
		let delay_fun = () => {
			if (this.delay_id) {
				local_GlobalTimerQuest.CancelQuest(this.delay_id)
				this.delay_id = null
			}
			this.PlayAnimation()
		}
		this.delay_id = local_GlobalTimerQuest.AddDelayQuest(delay_fun, 2)

	}

	public PlayAnimation() {
		//资源类型是npc才会有待机动作
		if(this.vo.icon_res_type != local_SceneBaseType.Npc){
			this.PlayAction("idle")
			return
		}

		if (this.idle_event_id) {
			local_GlobalTimerQuest.CancelQuest(this.idle_event_id)
			this.idle_event_id = null
		}
		if (this.replay_event_id) {
			local_GlobalTimerQuest.CancelQuest(this.replay_event_id)
			this.replay_event_id = null
		}

		if (this.state_signals["MOVE"]) {
			return
		}
 
		let index = Math.floor((Math.random() * Npc.CasualAniList.length))
		let casual_ani_name = Npc.CasualAniList[index]

		if(!GetAnimatorState(this.animator, casual_ani_name)){
			casual_ani_name = Npc.DefaultCasualAniName
		}
		this.PlayAction(casual_ani_name)
		let ani_state = GetAnimatorState(this.animator, casual_ani_name)
		let last_time = ani_state && ani_state.clip.duration()
		if(!last_time) return
		let to_idle = () => {
			if (this.idle_event_id) {
				local_GlobalTimerQuest.CancelQuest(this.idle_event_id)
				this.idle_event_id = null
			}
			if (this.state_signals["MOVE"]) {
				return
			}

			this.PlayAction("idle")
			let replay_fun = () => {
				if (this.replay_event_id) {
					local_GlobalTimerQuest.CancelQuest(this.replay_event_id)
					this.replay_event_id = null
				}
				if (this.state_signals["MOVE"]) {
					return
				}
				this.PlayAnimation()
			}
			this.replay_event_id = local_GlobalTimerQuest.AddDelayQuest(replay_fun, 10)
		}
		this.idle_event_id = local_GlobalTimerQuest.AddDelayQuest(to_idle, last_time)
	}

	//点击npc后，npc朝向玩家,n秒后恢复回npc的初始朝向
	public RestoreDirection(time?) {
		let second = time || 5
		if (this.restore_id) {
			local_GlobalTimerQuest.CancelQuest(this.restore_id)
			this.restore_id = null
		}
		let replay_fun = () => {
			if (this.restore_id) {
				local_GlobalTimerQuest.CancelQuest(this.restore_id)
				this.restore_id = null
			}
			if (this) {
				this.SetRotate()
			}
		}
		this.restore_id = local_GlobalTimerQuest.AddDelayQuest(replay_fun, second)
	}

	protected ResetMaterialProperty(skin_mesh_renderer)
	{
		//只有坐骑重置颜色和透明度
		if(this.vo.icon_res_type == local_SceneBaseType.Horse){
			let unlit_materials: Laya.UnlitMaterial[] = skin_mesh_renderer.skinnedMeshRenderer.materials as Laya.UnlitMaterial[]
			if (unlit_materials && unlit_materials.length > 0){
				let unlit_material
				for(let i = 0; i < unlit_materials.length; i++){
					unlit_material = unlit_materials[i]
					if(unlit_material)
					{
						if (unlit_material.renderMode != Laya.UnlitMaterial.RENDERMODE_OPAQUE)
							unlit_material.renderMode = Laya.UnlitMaterial.RENDERMODE_OPAQUE
						unlit_material.albedoColor = new Laya.Vector4(1, 1, 1, 1)
					}
				}
			}
		}
		super.ResetMaterialsProperty(skin_mesh_renderer)
	}
}

window["Npc"] = Npc