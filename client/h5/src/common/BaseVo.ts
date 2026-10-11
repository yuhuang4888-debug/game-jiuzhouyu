import { EventDispatcher } from "../util/EventDispatcher"
import { GlobalTimerQuest } from "../util/Util"

/*@//////////////////////////////////////////////////////////////////
说明: BaseVo, 提供公用的Vo操作方法
作者: deadline
//////////////////////////////////////////////////////////////////////*/
export class BaseVo extends EventDispatcher {
	fire_event_startTime
	delay_fire_BindId

	//用于代表所有属性值都被改变
	public static ALL_VAR = "ALL"
	public static ALL_CHANGED = "BaseVo.ALL_CHANGED"
	/*
		说明:	Vo中一些属性值发生改变时触发该事件
		触发:	通过ChangeVar函数调整属性或者第一次创建Vo时触发
		参数:
				var_name 属性名称 string 为BaseVo.ALL_VAR时表示所有属性均被改变
				value 属性值 any
	*/
	public static CHANGE_VAR = "vo_change_var"

	public constructor() {
		super()


	}

	public DeleteMe() {

		if (this.delay_fire_BindId) {
			GlobalTimerQuest.CancelQuest(this.delay_fire_BindId)
			this.delay_fire_BindId = null
		}
		this.fire_event_startTime = null
	}

	/*@
	功能:	改变Vo中的某个值
	参数:	
			oldVar1 string 属性名称
			value any 值类型
			delay_to_fire   是否延迟触发
			force_fire   强制触发
	返回值:
			无
	其它:	该接口会触发Vo本身的事件触发
	作者:	deadline
	*/
	// public ChangeVar(oldVar1?, value?, delay_to_fire?, force_fire?) {

	// 	// console.log("////- BaseVo //-",oldVar1,value)
	// 	if (oldVar1 == BaseVo.ALL_VAR) {
	// 		//此时仅触发ChangeVar事件
	// 		// this.Fire(BaseVo.CHANGE_VAR, BaseVo.ALL_VAR)

	// 		for (let k in this) {
	// 			var v = this[k]
	// 			let event_name = "vo_one_var_chg_" + k
	// 			this.Fire(event_name, k, v)
	// 		}
	// 		this.Fire(BaseVo.ALL_CHANGED)
	// 		// } else if (oldVar1 == BaseVo.ALL_CHANGED ) {
	// 		// 	this.Fire(BaseVo.ALL_CHANGED)
	// 	} else if (this[oldVar1] != value || force_fire) {
	// 		//判定this[oldVar1]是否存在
	// 		if (this[oldVar1] == null) {
	// 			console.log("Waring: BaseVo.ChangeVar to change a property ! exist, oldVar1:", oldVar1, value)
	// 		}
	// 		let old_value = this[oldVar1]
	// 		this[oldVar1] = value
	// 		var fire_func = () => {
	// 			if (delay_to_fire) {
	// 				this.fire_event_startTime = Status.NowTime
	// 				if (this.delay_fire_BindId) {
	// 					GlobalTimerQuest.CancelQuest(this.delay_fire_BindId)
	// 					this.delay_fire_BindId = null
	// 				}
	// 			}
	// 			// this.Fire(BaseVo.CHANGE_VAR, oldVar1, this[oldVar1])
	// 			let event_name = "vo_one_var_chg_" + oldVar1
	// 			this.Fire(event_name, oldVar1, this[oldVar1], old_value)
	// 			// console.log("Status.NowTime=",Status.NowTime,oldVar1)
	// 		}
	// 		if (delay_to_fire) {
	// 			if (this.fire_event_startTime == null || Status.NowTime - this.fire_event_startTime >= 0.02) {
	// 				fire_func()
	// 			} else {
	// 				if (this.delay_fire_BindId == null) {
	// 					var delayFunc = () => {
	// 						fire_func()
	// 					}
	// 					this.delay_fire_BindId = GlobalTimerQuest.AddDelayQuest(delayFunc, 0.02)
	// 				}
	// 			}
	// 		} else {
	// 			fire_func()
	// 		}
	// 	}
	// }

	// public BindOne(oldVar1?, func?) {

	// 	let event_name = "vo_one_var_chg_" + oldVar1
	// 	let eventId = this.Bind(event_name, func)
	// 	return eventId
	// }

	// public BindAll(func?) {

	// 	let eventId = this.Bind(BaseVo.ALL_CHANGED, func)
	// 	return eventId
	// }
}
window["BaseVo"] = BaseVo