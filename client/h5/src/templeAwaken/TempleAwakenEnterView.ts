import { BaseView1 } from "../common/BaseView1"
import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { EventName } from "../common/EventName"
import { FigureProtoVo } from "../common/FigureProtoVo"
import { Enum_UILayer, LayerManager } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { UI_MODEL_TYPE } from "../common/UIModelClass3D"
import { MainUIController } from "../commonController/MainUIController"
import { StoryModel } from "../commonModel/StoryModel"
import { TaskTipType } from "../commonModel/TaskModel"
import { TempleAwakenEvent, TempleAwakenModel } from "../commonModel/TempleAwakenModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneBaseType } from "../scene/SceneConfig"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { SYTweenFunc } from "../util/SYTweenFunc"
import { SYTweenLite } from "../util/SYTweenLite"
import { GlobalTimerQuest, Util } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { Vector3 } from "../util/Vector3"
import { Config } from "../common/Config"

export class TempleAwakenEnterView extends BaseView1 {

	change_scene_close
	close_callback
	curr_sorting_order
	destroy_imm
	layer_mgr
	mainUI_controller
	open_callback
	time_id
	tween
	tween1
	_iid
	public constructor() {
		super()

		this.base_file = "templeAwaken"
		this.layout_file = "TempleAwakenEnterView"
		this.layer_value = Enum_UILayer.Top
		this.destroy_imm = true
		this.is_center = true
		this.background_alpha = 1
		this.use_background = true
		//this.change_scene_close = true
		this.layer_mgr = LayerManager.GetInstance()
		this.mainUI_controller = MainUIController.GetInstance()
		this.preload_server_config =
		{
			"config_temple_awaken_suit": false,
			"config_temple_awaken": false,
			"config_temple_awaken_kv": false
		}

		this.load_callback = () => {
			ResManager.GetInstance().SetOutsideImageSprite(this,this.awaken_bg,"resource/game/templeAwaken/texture/jxzl_0011.png")
			//StoryModel.GetInstance().CreateFinger(this.finger_con,0,0,false)
			this.LoadSuccess()
			this.InitEvent()
		}

		this.open_callback = () => {
		}

		this.close_callback = () => {
			this.Remove()
		}
	}

	public Remove() {


		if (this.time_id != null) {
			GlobalTimerQuest.CancelQuest(this.time_id)
			this.time_id = null
		}
		if (this.tween) {
			SYTweenLite.Stop(this.tween)
			this.tween = null
		}
		if (this.tween1) {
			SYTweenLite.Stop(this.tween1)
			this.tween1 = null
		}
		delete BaseWindowComponent.CURR_OPEN_VIEW[this._iid]
		ResManager.GetInstance().ClearRoleMode(this.hashCode)
	}

	public InitEvent() {



	}
	public LoadSuccess() {

		BaseWindowComponent.CURR_OPEN_VIEW[this._iid] = true


		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetBigBgPath("jxzl_bg1.jpg"))
		this.CreateModel()
	}

	public GetModelId = () => {
		let mainVo = RoleManager.GetInstance().GetMainRoleVo()
		let career = mainVo.career
		let cfg =Config.PRELOAD_SERVER_CONFIG.config_temple_awaken_suit
		let cfg_chapter = Config.PRELOAD_SERVER_CONFIG.config_temple_awaken
		let list = []
		for (let _ in cfg_chapter) {
			var v = cfg_chapter[_]
			table.insert(list, { chapter: v.chapter_id, model_id: cfg[v.chapter_id + "@" + career].figure_id })
		}
		table.sort(list, (a?, b?) => {
			return a.chapter < b.chapter
		})

		return [list[0] && list[0].model_id, list[1] && list[1].model_id, list[2] && list[2].model_id, list[3] && list[3].model_id, list[4] && list[4].model_id]
	}

	public CreateModel() {

		ResManager.GetInstance().ClearRoleMode(this.hashCode)

		let mainVo = RoleManager.GetInstance().GetMainRoleVo()
		let [awaken_fashion, awaken_hallow, awaken_wing, awaken_artiface, awaken_mount] = this.GetModelId()
		let cfg_kv = ResManager.GetInstance().GetGameConfigFromCache(this, "config_temple_awaken_kv", false)//Config.Templeawakenkv
		let head_model_id = Number(ErlangParser.GetInstance().Parse(cfg_kv[7].value)[mainVo.sex-1][1])
		let type = UI_MODEL_TYPE.ROLE
		let rotate = null

		let attack_action_list = ["show_3"]
		//let ani = (mainVo.career == 1 || mainVo.career == 3) && "idle_1" || "idle_3b"

		let data = {
			career: mainVo.career,
			sex: mainVo.sex,
			type: type,
			layer_value: Enum_UILayer.UI,
			clothe_res_id:awaken_fashion,
			head_wear_id: Number(head_model_id),
			weapon_res_id: awaken_artiface,
			weapon_clothe_id: 0,
			wing_id: awaken_wing,
			horse_id: awaken_mount,
			fashion_model_id: undefined,
			//hallows_id = awaken_hallow,
			position: new Vector3(0, 1.9, 0),//position,
			scale: 0.6,
			rotate: rotate,
			//action_name_list: attack_action_list,//["show_3",ani],
			hair_id: 0,//1014+mainVo.sex*100  
			layout_file:"TempleAwakenEnterView"

		}

		ResManager.GetInstance().SetRoleModel(this, this.model_gp, data)

		if (awaken_hallow) {

			let data2 = {

				career: mainVo.career,
				sex: mainVo.sex,
				type: UI_MODEL_TYPE.ARTIFACT,
				layer_value: Enum_UILayer.UI,
				clothe_res_id: awaken_hallow,
				head_wear_id: 0,
				weapon_res_id: 0,
				weapon_clothe_id: 0,
				wing_id: 0,
				horse_id: 0,
				fashion_model_id: undefined,
				//hallows_id = awaken_hallow,
				position: new Vector3(0, 0, 0),//position,
				scale: 2,
				rotate: null,
				hair_id: 0


			}
			if (data2) {
				ResManager.GetInstance().SetRoleModel(this, this.hallow_model_gp, data2)
			}
		}

		if(awaken_mount){
			let data3 = {
				clothe_res_id: awaken_mount,
				type: UI_MODEL_TYPE.HORSE,
				can_rotate: true,
				layer_value: Enum_UILayer.UI,
				scale : 0.4,//pos_cfg && pos_cfg.scale,
				position :new Vector3(0, 0, 0),//pos_cfg && pos_cfg.position,
				rotate : 225,//pos_cfg && pos_cfg.rotate,
				//texture_size = Vector2(567,415),
				action_name_list : ["show","idle"],
			}
			if (data3) {
				ResManager.GetInstance().SetRoleModel(this, this.mount_model_gp, data3)
			}
		}
	

		// this.time_id1 = setTimeout(() => {
		// 	this.CoverMode(this.bg1, this.layer_value, this.curr_sorting_order)
		// 	this.CoverMode(this.bg2, this.layer_value, this.curr_sorting_order)
		// }, 1.2)


		this.canvas_gp.alpha = 0
		this._box_1.alpha=0
		this.time_id = GlobalTimerQuest.AddDelayQuest(() => {
			this.tween1 = SYTweenLite.to(this, this._box_1, SYTweenLite.UiAnimationType.ALPHA, 1, 1, null, SYTweenFunc.LINEAR)
			this.tween = SYTweenLite.to(this, this.canvas_gp, SYTweenLite.UiAnimationType.ALPHA, 1, 1, () => {
				this.TaskFingerFun()
				Util.AddClickEvent(
					this._click_gp, () => {
						GlobalEventSystem.Fire(EventName.OPEN_VIEW, "TempleAwakenBaseView")
						TempleAwakenModel.GetInstance().Fire(TempleAwakenEvent.REQUEST_PROTO, 42900)
						//TempleAwakenModel.GetInstance().Fire(TempleAwakenEvent.REQUEST_PROTO, 42901)
						GlobalEventSystem.Fire(EventName.HIDE_FINGER, this.finger_con)
						this.Close()
					},
					this,
					true
				)
			}, SYTweenFunc.LINEAR)
		}, 1)


	}

	public TaskFingerFun() {

		if (this.task_model.IsCurrMainLineTaskTipType(TaskTipType.Open_function)) {

			this.story_model.curr_view_story_step = 2

			GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this._click_gp, "UI")
			//GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this.finger_con, this.layer_value, null, null, null, null, null, true)
			// let delayFunc = () => {
			// 	if (!this.use_delete_method && this._click_gp) {
			// 		// let finger = this.story_model.GetFinger(this, this._click_gp)
			// 		// if (finger) {
			// 		// 	finger.SetCoverMode()
			// 		// }
			// 	}
			// }
			// setTimeout(delayFunc, 0.5)
		}
	}



_img_bg:Laya.Image
_box_1:Laya.Box
_img_board:Laya.Image
_lb_content:Laya.Label
_lb_content2:Laya.Label
mount_model_gp:Laya.Box
model_gp:Laya.Box
hallow_model_gp:Laya.Box
canvas_gp:Laya.Box
awaken_bg:Laya.Image
finger_con:Laya.Box
_click_gp:Laya.Box
awaken:Laya.Image
_img_instruction:Laya.Image
public GetComponents() {
[
this._img_bg,
this._box_1,
this._img_board,
this._lb_content,
this._lb_content2,
this.mount_model_gp,
this.model_gp,
this.hallow_model_gp,
this.canvas_gp,
this.awaken_bg,
this.finger_con,
this._click_gp,
this.awaken,
this._img_instruction,
]
 = this.GetChildrenByNames([

"_img_bg",
"_box_1",
"_img_board",
"_lb_content",
"_lb_content2",
"mount_model_gp",
"model_gp",
"hallow_model_gp",
"canvas_gp",
"awaken_bg",
"finger_con",
"_click_gp",
"awaken",
"_img_instruction",
])
}
}
 window["TempleAwakenEnterView"]= TempleAwakenEnterView