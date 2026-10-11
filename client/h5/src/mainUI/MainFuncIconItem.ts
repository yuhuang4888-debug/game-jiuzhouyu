import { BaseItem1 } from "../common/BaseItem1"
import { EventName } from "../common/EventName"
import { ResManager } from "../common/ResManager"
import { MainFunc, MainUIModel } from "../commonModel/MainUIModel"
import { enum_OutWardType } from "../commonModel/OutWardBaseModel"
import { TaskTipType } from "../commonModel/TaskModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { SetLocalPosition, Util } from "../util/Util"

export class MainFuncIconItem extends BaseItem1 {
	LoadSuccess
	UpdateItem
	SetData
	SetStoryArrow
	SetIconPos
	SetRedPos
	SetRedState
	Click
	InitEvent
	TryRefreshFun
	RefreshFun

	public constructor(parent?) {
		super(parent)
		this.base_file = "mainUI"
		this.layout_file = "MainFuncIconItem"

		let refresh_time_id,
		model = MainUIModel.GetInstance(),
		red_pos,
		need_refresh_data = false,
		red_state,
		local_vo,
		func,
		pos

		this.load_callback = () => {
			this.LoadSuccess()
		}
		

		this.LoadSuccess = () => {
			if (need_refresh_data) {
				
				this.UpdateItem()
			}
			this.InitEvent()
		}
		
		this.UpdateItem = () => {
			if (local_vo) {
				ResManager.GetInstance().SetImageSprite(this, this._img_icon, this.base_file, local_vo.res)
				this.SetRedState()
				if (pos) {
					this.SetIconPos(pos[0], pos[1])
				}
				if (red_pos) {
					this.SetRedPos(red_pos[0], red_pos[1])
				}
				this.RefreshFun()
			}
		}
	
		this.SetData = (vo?) => {
			local_vo = vo
			func = vo.func
			if (this.is_loaded) {
				this.SetStoryArrow(true)
				this.UpdateItem()
			} else {
				need_refresh_data = true
			}
		}

		this.SetStoryArrow = (bool?) => {
			if (bool) {
				this.story_target_name_dic = {}
				if (local_vo && local_vo.story_arr) {
					for (let _tmpi = 0; _tmpi < local_vo.story_arr.length; _tmpi++) {
						let story = local_vo.story_arr[_tmpi]
						this.story_target_name_dic[story] = this._img_icon
					}
				}
			} else {
				this.story_target_name_dic = {}
			}
		}
		
		this.SetIconPos = (x?, y?) => {
	
			if (x == null) {
				x = 0
			}
			if (y == null) {
				y = 0
			}
			if (this.is_loaded) {
				this.SetPosition(x, y)
			} else {
				pos = [x, y]
			}
		}
	
		this.SetRedPos = (x?, y?) => {
	
			if (x == null) {
				x = 0
			}
			if (y == null) {
				y = 0
			}
			if (this.is_loaded) {
				SetLocalPosition(this._img_red, x, y, 0)
			} else {
				red_pos = [x, y]
			}
		}

		
		this.SetRedState = (bool?) => {
	
			if (bool == null) {
				bool = false
			}
			red_state = bool //  != null && bool || red_state
			if (this.is_loaded) {
				this._img_red.visible = red_state
			}
		}

		
		this.Click = () => {
	
			if (local_vo) {
				let index
				//如果当前有侍魂升级引导且点击式神标签
				let main_task_vo = this.task_model.GetMainLineTaskVo()
				if(func == MainFunc.Pet && main_task_vo && main_task_vo.task_tips_type == TaskTipType.MountLevel && main_task_vo.id == enum_OutWardType.Partner && main_task_vo.has_finish == 0){
					index = 1
				}

				GlobalEventSystem.Fire(EventName.SWITCH_MAIN_FUNC_VIEW, func, index)
			}
		}
	
		this.InitEvent = () => {
	
			Util.AddClickEvent(
				this._img_icon, () => {
					this.Click()
				},
				this,
				true
			)
			this.BindEvent(
				GlobalEventSystem,
				EventName.REFRESH_FUNCTION_ICON_RED_DOT,
				(func?) => {
					if (func == func) {
						this.TryRefreshFun()
					}
				}
			)
			// if (local_vo.func == 5){
			// 	this.BindEvent(
			// 		GlobalEventSystem,
			// 		EventName.SET_TR_ARROW,
			// 		() => {
			// 			GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this._img_icon, undefined, undefined, undefined, true);
			// 		}
			// 	)
			// }
			
		}
	
		this.TryRefreshFun = () => {
	
			if (!refresh_time_id) {
				refresh_time_id =
					setTimeout(() => {
						if (!this.use_delete_method) {
							this.RefreshFun(true)
						}
						refresh_time_id = null
					},
						0.1
					)
			}
		}
	
		this.RefreshFun = (bool?) => {
	
			if (bool == null) {
				bool = false
			}
			if (local_vo) {
				this.SetRedState(model.GetMainFuncRedState(func))
				if (bool) {
					model.RefreshTurnRed()
				}
			}
		}
	}

	public localToGlobal(x,y){
		if (this.display_obj){
			let point:Laya.Point=new Laya.Point(x,y)
			return this.display_obj.localToGlobal(point)
		}
    }

	public createChildren () {
		
		if (this["GetComponents"]){
			this["GetComponents"]()
			this.is_get = true
			this.SetStoryArrow(true)
		}
		super.createChildren()
	}

	
	_img_icon: Laya.Image
	_img_red: Laya.Image
	public GetComponents() {
		[
			this._img_icon,
			this._img_red,
		]
			= this.GetChildrenByNames([

				"_img_icon",
				"_img_red",
			])
	}
}
window["MainFuncIconItem"] = MainFuncIconItem