import { MainUIModel } from "../commonModel/MainUIModel"
import { Runner } from "../util/Runner"
import { SetLocalPositionY, SetLocalPositionX, Util, GetTargetHashcode } from "../util/Util"
import { BaseClass } from "./BaseClass"
import { table } from "./table"
import { Mathf } from "../util/Mathf"
import { EventDispatcher } from "../util/EventDispatcher"
import { LayerManager } from "./LayerManager"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "./EventName"
export class MainUIManager extends EventDispatcher {

	public static UPDATE_MOVE_STATE = "MainUIManager.UPDATE_MOVE_STATE"

	public static MOVE_TYPE = {
		Top: 1,
		Buttom: 2,
		Left: 3,
		Right: 4,
		Stay: 5	//原地不动
	}
	static Instance: MainUIManager
	move_com_dic
	main_ui_move_timer: number
	update_timer: boolean
	reset: boolean
	layer_mgr: LayerManager

	/**
	 * 添加移动组件 暂不支持 （left,right) / ( top, bottom)同时设置时的移动
	 * @param ref 
	 * @param transform 
	 * @param show_type true/false 主界面同时显示/隐藏主界面时显示
	 * @param move_type 移动类型  MainUIManager.MOVE_TYPE
	 * @returns 
	 */
	public AddMoveComponent(ref: BaseClass, transform: Laya.Sprite, show_type?, move_type?) {
		if (!ref || ref.use_delete_method || !transform) { return }
		if (this.move_com_dic == null) {
			this.move_com_dic = {}
		}
		if (this.move_com_dic[ref.hashCode] == null) {
			this.move_com_dic[ref.hashCode] = { "ref": ref }
		}

		let attr = this.GetMoveAttr(transform)
		let start_value = transform[attr]
		let end_value = this.GetMoveValue(attr, move_type, transform)

		let data = {
			transform: transform,
			move_type: move_type,
			show_type: show_type,
			attr: attr,
			start_value: start_value,
			end_value: end_value,
		}
		this.UpdateDefalutState(data)
		this.move_com_dic[ref.hashCode][GetTargetHashcode(transform)] = data
	}

	public GetMoveValue(attr, move_type, transform) {
		let end_value, ScreenHeight = this.layer_mgr.stageHeight, ScreenWidth = this.layer_mgr.stageWidth

		if (move_type == MainUIManager.MOVE_TYPE.Top) {

			if (attr == "centerY") {
				end_value = - (ScreenHeight + transform.width) / 2
			} else if (attr == "top") {
				end_value = - transform.height
			} else if (attr == "bottom") {
				end_value = ScreenHeight
			} else if (attr == "y") {
				end_value = - transform.height
			}

		} else if (move_type == MainUIManager.MOVE_TYPE.Buttom) {

			if (attr == "centerY") {
				end_value = (ScreenHeight + transform.width) / 2
			} else if (attr == "top") {
				end_value = ScreenHeight
			} else if (attr == "bottom") {
				end_value = - transform.width
			} else if (attr == "y") {
				end_value = ScreenHeight
			}

		} else if (move_type == MainUIManager.MOVE_TYPE.Left) {

			if (attr == "centerX") {
				end_value = -(ScreenWidth + transform.width) / 2
			} else if (attr == "left") {
				end_value = -transform.width
			} else if (attr == "right") {
				end_value = ScreenWidth
			} else if (attr == "x") {
				end_value = -transform.width
			}

		} else if (move_type == MainUIManager.MOVE_TYPE.Right) {

			if (attr == "centerX") {
				end_value = (ScreenWidth + transform.width) / 2
			} else if (attr == "left") {
				end_value = ScreenWidth
			} else if (attr == "right") {
				end_value = -transform.width
			} else if (attr == "x") {
				end_value = ScreenWidth
			}
		}

		return end_value
	}


	public UpdateMoveEndValue() {
		if (this.move_com_dic) {
			let dic, data
			for (let hashCode in this.move_com_dic) {
				dic = this.move_com_dic[hashCode]
				for (let hashCode2 in dic) {
					if (hashCode2 != "ref") {
						data = dic[hashCode2]
						if (data.move_type == MainUIManager.MOVE_TYPE.Top || data.move_type == MainUIManager.MOVE_TYPE.Buttom || data.move_type == MainUIManager.MOVE_TYPE.Left || data.move_type == MainUIManager.MOVE_TYPE.Right) {
							if (!data.transform.destroyed) {
								let end_value = this.GetMoveValue(data.attr, data.move_type, data.transform)
								data.end_value = end_value
							}
						}
					}
				}
			}
		}
	}

	public UpdateDefalutState(data) {
		if (data && !Util.IsNull(data.transform)) {
			if (data.show_type != MainUIModel.GetInstance().activity_icon_in_show) {
				if (data.move_type == MainUIManager.MOVE_TYPE.Top || data.move_type == MainUIManager.MOVE_TYPE.Buttom || data.move_type == MainUIManager.MOVE_TYPE.Left || data.move_type == MainUIManager.MOVE_TYPE.Right) {
					data.transform[data.attr] = data.end_value
				}
				data.transform.visible = false
				data.transform.alpha = 0
			} else {
				if (data.move_type == MainUIManager.MOVE_TYPE.Top || data.move_type == MainUIManager.MOVE_TYPE.Buttom || data.move_type == MainUIManager.MOVE_TYPE.Left || data.move_type == MainUIManager.MOVE_TYPE.Right) {
					data.transform[data.attr] = data.start_value
				}
				data.transform.visible = true
				data.transform.alpha = 1
			}
		}
	}

	public UpdateAllDefalutState() {
		if (this.move_com_dic) {
			let dic, data
			for (let hashCode in this.move_com_dic) {
				dic = this.move_com_dic[hashCode]
				for (let hashCode2 in dic) {
					if (hashCode2 != "ref") {
						data = dic[hashCode2]
						this.UpdateDefalutState(data)
					}
				}
			}
		}
	}

	public GetMoveAttr(transform: Laya.Sprite, isVertical = false) {
		let com = <Laya.UIComponent>transform
		if (isVertical) {
			if (com) {
				if (!isNaN(com.centerY)) {
					return "centerY"
				} else if (!isNaN(com.top)) {
					return "top"
				} else if (!isNaN(com.bottom)) {
					return "bottom"
				}
			}
			return "y"

		}
		else {
			if (com) {
				if (!isNaN(com.centerX)) {
					return "centerX"
				} else if (!isNaN(com.left)) {
					return "left"
				} else if (!isNaN(com.right)) {
					return "right"
				}
			}
			return "x"
		}
	}

	public RemoveMoveComponent(ref: BaseClass) {

		if (this.move_com_dic && this.move_com_dic[ref.hashCode]) {
			delete this.move_com_dic[ref.hashCode]
		}
	}

	public RemoveMoveOneComponent(ref, transform, reset = true) {
		if (transform && this.move_com_dic && this.move_com_dic[ref.hashCode] && this.move_com_dic[ref.hashCode][GetTargetHashcode(transform)]) {
			let data = this.move_com_dic[ref.hashCode][GetTargetHashcode(transform)]
			if (reset && data) {
				if (data.move_type == MainUIManager.MOVE_TYPE.Top || data.move_type == MainUIManager.MOVE_TYPE.Buttom || data.move_type == MainUIManager.MOVE_TYPE.Left || data.move_type == MainUIManager.MOVE_TYPE.Right) {
					data.transform[data.attr] = data.start_value
				}
				data.transform.visible = true
				data.transform.alpha = 1
			}
			delete this.move_com_dic[ref.hashCode][GetTargetHashcode(transform)]
		}
	}

	public HasMoveComponent(ref, transform) {

		return this.move_com_dic && this.move_com_dic[ref.hashCode] && this.move_com_dic[ref.hashCode][GetTargetHashcode(transform)]
	}

	public Update() {

		let show_type = MainUIModel.GetInstance().activity_icon_in_show

		let ratio = Mathf.Min((Laya.timer.currTimer - this.main_ui_move_timer) / 1000 / MainUIModel.Move_Time_Interval, 1)
		let delete_com_dic = []
		if (this.move_com_dic) {
			for (let ref_hashcode in this.move_com_dic) {
				let com_list = this.move_com_dic[ref_hashcode]
				if (com_list && com_list.ref) {
					if (com_list.ref.use_delete_method) {
						delete this.move_com_dic[ref_hashcode]
					} else {
						for (let transform_hashcode in com_list) {
							let data = com_list[transform_hashcode]
							if (data && !Util.IsNull(data.transform)) {
								let transform = data.transform
								if (this.reset) {
									let start_value
									if (data.move_type == MainUIManager.MOVE_TYPE.Top || data.move_type == MainUIManager.MOVE_TYPE.Buttom || data.move_type == MainUIManager.MOVE_TYPE.Left || data.move_type == MainUIManager.MOVE_TYPE.Right) {
										start_value = transform[data.attr]
									}
									if (show_type == data.show_type) {
										transform.visible = true
										data.move_data = { end_value: data.start_value, start_value: start_value, end_alpha: 1, start_alpha: transform.alpha }
									} else {
										data.move_data = { end_value: data.end_value, start_value: start_value, end_alpha: 0, start_alpha: transform.alpha }
									}
								}

								//没有move_data 说明是 循环过程中添加进来的 添加时已经设置过默认值了 不需要播动画
								if (data.move_data) {
									if (data.move_type == MainUIManager.MOVE_TYPE.Top || data.move_type == MainUIManager.MOVE_TYPE.Buttom || data.move_type == MainUIManager.MOVE_TYPE.Left || data.move_type == MainUIManager.MOVE_TYPE.Right) {
										transform[data.attr] = data.move_data.start_value + ratio * (data.move_data.end_value - data.move_data.start_value)
									}

									transform.alpha = Mathf.Floor((data.move_data.start_alpha + ratio * (data.move_data.end_alpha - data.move_data.start_alpha)) * 10) / 10

									if (ratio == 1 && show_type != data.show_type) {
										transform.visible = false
									}
								}
							}
						}
					}
				}
			}
		}

		// for (let _ in delete_com_dic) {
		// 	let ref = delete_com_dic[_]
		// 	this.move_com_dic[ref] = null
		// }
		this.reset = false
		if (ratio == 1) {
			this.RemoveRunner()
		}
	}


	public constructor() {
		super()
		if (MainUIManager.Instance) {
			return
		}
		this.layer_mgr = LayerManager.GetInstance()
		// MainUIManager.Instance = this
		this.InitEvent()
	}


	public InitEvent() {
		this.Bind(MainUIManager.UPDATE_MOVE_STATE, () => {
			Laya.timer.frameLoop(2, this, this.Update)
			this.main_ui_move_timer = Laya.timer.currTimer
			this.update_timer = true
			this.reset = true
		})

		GlobalEventSystem.Bind(EventName.STATE_RESET_SIZE, () => {
			Laya.timer.callLater(this, this.ResetScreenSize)
			// this.ResetScreenSize()
		})
	}

	public ResetScreenSize = () => {
		this.RemoveRunner()
		this.UpdateMoveEndValue()
		this.UpdateAllDefalutState()
	}

	public RemoveRunner() {
		if (this.update_timer) {
			Laya.timer.clear(this, this.Update)
			this.update_timer = false
		}
	}

	public static GetInstance() {
		if (MainUIManager.Instance == null) {
			MainUIManager.Instance = new MainUIManager()
		}
		return MainUIManager.Instance
	}
}




window["MainUIManager"] = MainUIManager