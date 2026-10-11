import { BaseClass } from "../common/BaseClass"
import { table } from "../common/table"
import { Status } from "./Status"
import { SYTweenFunc } from "./SYTweenFunc"
import { GetLocalPositionX, GetLocalPositionY, GetSizeDeltaX, GetSizeDeltaY, GlobalTimerQuest, SetLocalPosition, SetLocalPositionX, SetLocalPositionY, SetSizeDeltaX, SetSizeDeltaY, SetLocalScale, Util, GetAlpha, SetAlpha } from "./Util"

export class SYTweenLite {

	public static UiAnimationType = {
		POS: "POS",
		POSX: "POSX",
		POSY: "POSY",
		ALPHA: "ALPHA", //新版的alpha 不要用旧版的
		ALPHA_OLD: "ALPHA_OLD",//旧版的alpha变化 后续不要再调用
		WIDTH: "WIDTH",
		HEIGHT: "HEIGHT",
		ROTATION: "ROTATION",    //rotateion.z
		CANVAS_POSX: "CANVAS_POSX",
		CANVAS_POSY: "CANVAS_POSY",
		SCALE: "SCALE",
		ROTATION_Y: "ROTATION_Y",
		SRECT_HORIZONTAL: "SRECT_HORIZONTAL",
		SRECT_VERTICAL: "SRECT_VERTICAL",
		ANCHORED_POS: "ANCHORED_POS",
		ANCHORED_POSX: "ANCHORED_POSX",
		ANCHORED_POSY: "ANCHORED_POSY",
		ALPHA_ALL: "ALPHA_ALL", //动态添加CanvasGroup设置透明度，也可以自己在prefab里添加然后调用TweenLite.UiAnimationType.ALPHA
		FILLAMOUNT: "FILLAMOUNT",
		ALPHA_MODEL: "ALPHA_MODEL", //anim_wnd传{ gameObject = obj, startalpha = value}
		CENTER_POS:"CENTER_POS",
		CENTER_POSX:"CENTER_POSX",
		CENTER_POSY:"CENTER_POSY",
		SKEW_Y:"SKEW_Y",
		BOTTOM:"BOTTOM"
	}

	public static moving_info_list = {} //当前正在缓动的列表
	public static moving_info_list_delay // 保存正在更新的过程中添加进来的对象  本次更新完以后才会添加到moving_info_list里  避免更新过程中触发rehash产生影响
	public static moving_info_delete_list_delay //保存正在更新的过程中需要删除的对象
	public static curr_info_index = 0
	public static is_updating = false //是否正在更新
	static delayfun_timer: any

	/*
	参数
	parent_wnd:父容器  继承baseclass的父容器 用来判断是否已经被删除
	anim_wnd:缓动对象
	tweentype:缓动类型
	endValue:结束值
	AnimaTime:缓动时间（s）
	anim_end_func:结束调用方法
	tween_type:缓动类型 默认线性
	*/
	public static to(parent_wnd, anim_wnd , tweentype, endValue, AnimaTime, anim_end_func?, tween_type?, loop?) {
		if (!anim_wnd || parent_wnd.use_delete_method) {
			return
		}
		let startvalue
		switch(tweentype)
		{
			case local_SYTweenLite.UiAnimationType.POS:
				startvalue = [anim_wnd.x, anim_wnd.y] // anim_wnd.localPosition
				break;
			case local_SYTweenLite.UiAnimationType.POSX:
				startvalue = GetLocalPositionX(anim_wnd)
				break;
			case local_SYTweenLite.UiAnimationType.POSY:
				startvalue = GetLocalPositionY(anim_wnd)
				break;
			case local_SYTweenLite.UiAnimationType.ALPHA:
				startvalue = anim_wnd.alpha
				break;
			case local_SYTweenLite.UiAnimationType.ALPHA_OLD:
				startvalue = GetAlpha(anim_wnd)
				break;
			case local_SYTweenLite.UiAnimationType.WIDTH:
				startvalue = GetSizeDeltaX(anim_wnd)
				break;
			case local_SYTweenLite.UiAnimationType.HEIGHT:
				startvalue = GetSizeDeltaY(anim_wnd)
				break;
			case local_SYTweenLite.UiAnimationType.ROTATION:
				startvalue = anim_wnd.rotation
				break;
			case local_SYTweenLite.UiAnimationType.ROTATION_Y:
				// startvalue = anim_wnd.eulerAngles.y
				// break;
				// case local_SYTweenLite.UiAnimationType.CANVAS_POSY :
				// 	startvalue=anim_wnd:GetVector2(ScrollViewProperty.CanvasPosition).y
				// break;
				// case local_SYTweenLite.UiAnimationType.CANVAS_POSX :
				// 	startvalue=anim_wnd:GetVector2(ScrollViewProperty.CanvasPosition).x
				return;
			case local_SYTweenLite.UiAnimationType.SCALE:
				startvalue = [anim_wnd.scaleX, anim_wnd.scaleY]
				break;
			case local_SYTweenLite.UiAnimationType.SRECT_HORIZONTAL:
				startvalue = anim_wnd.horizontalCenter // horizontalNormalizedPosition
				break;
			case local_SYTweenLite.UiAnimationType.SRECT_VERTICAL:
				startvalue = anim_wnd.verticalCenter // verticalNormalizePosition
				break;
			case local_SYTweenLite.UiAnimationType.ANCHORED_POS:
				startvalue = [anim_wnd.x, anim_wnd.y]// anim_wnd.anchoredPosition
				break;
			case local_SYTweenLite.UiAnimationType.ANCHORED_POSX:
				startvalue = anim_wnd.x //.anchoredPosition.x
				break;
			case local_SYTweenLite.UiAnimationType.ANCHORED_POSY:
				startvalue = anim_wnd.y //.anchoredPosition.y
				break;
			case local_SYTweenLite.UiAnimationType.BOTTOM:
				startvalue = anim_wnd.bottom //.anchoredPosition.y
				break;
			case local_SYTweenLite.UiAnimationType.FILLAMOUNT:
				// startvalue = anim_wnd.GetComponent("Image").fillAmount
				return;
			case local_SYTweenLite.UiAnimationType.ALPHA_ALL:
				//添加一个CanvasGroup组件
				return;
				// let component = anim_wnd.GetComponent("CanvasGroup")
				// if (! component ) {
				// 	component = anim_wnd.AddComponent(typeof(UnityEngine.CanvasGroup))
				// }
				// startvalue = component.alpha
			case local_SYTweenLite.UiAnimationType.ALPHA_MODEL:
				// if (! IsNull(anim_wnd.gameObject) ) {
					return;
				// 	startvalue = anim_wnd.startalpha
				// 	anim_wnd = anim_wnd.gameObject
				// 	let renders = anim_wnd.GetComponentsInChildren(typeof(UnityEngine.SkinnedMeshRenderer))
				// 	if (! renders || renders.Length == 0 ) {
				// 		renders = anim_wnd.GetComponentsInChildren(typeof(UnityEngine.MeshRenderer))
				// 	}
				// 	if (renders && renders.Length > 0 ) {
				// 		for (let j = 0; j < renders.Length; j++){
				// 			let render = renders[j]
				// 			let mat = render.material
				// 			if (mat && mat.shader.name == "Unlit/Texture" ) {
				// 				mat.shader = SceneManager.GetInstance().GetColorTextureShader()
				// 				mat.color = Color(1, 1, 1, startvalue)
				// 			}
				// 		}
				// 		anim_wnd = renders
				// 	}else{
				// 		return
				// 	}
				// }else{
				// 	return
				// }
			case local_SYTweenLite.UiAnimationType.CENTER_POS:
				startvalue = [anim_wnd.centerX, anim_wnd.centerY]
				break;
			case local_SYTweenLite.UiAnimationType.CENTER_POSX:
				startvalue = anim_wnd.centerX
				break;
			case local_SYTweenLite.UiAnimationType.CENTER_POSY:
				startvalue = anim_wnd.centerY
				break;
			case local_SYTweenLite.UiAnimationType.SKEW_Y:
				startvalue = anim_wnd.skewY
				break;
			default:
				return;
		}
		let tid = local_SYTweenLite.AddMovingItem(parent_wnd, anim_wnd, tweentype, startvalue, endValue, AnimaTime, anim_end_func, tween_type, loop)

		if (!local_SYTweenLite.delayfun_timer) {
			var delayfun = () => {
				local_SYTweenLite.Update()
			}
			local_SYTweenLite.delayfun_timer = GlobalTimerQuest.AddPeriodQuest(delayfun, 0.02, -1)
		}
		return tid
	}

	public static setMovingInfo(v, progress) {
		if (!v || v.parent_wnd.use_delete_method || v.anim_wnd.destroyed) { //|| Util.IsNull(v.anim_wnd)
			return true
		}

		let curr_value = v.startvalue + (v.endValue - v.startvalue) * progress
		switch(v.tweentype)
		{
			case local_SYTweenLite.UiAnimationType.POS:
				curr_value = [v.startvalue[0] + (v.endValue.x - v.startvalue[0]) * progress, v.startvalue[1] + (v.endValue.y - v.startvalue[1]) * progress]
				SetLocalPosition(v.anim_wnd, curr_value[0], curr_value[1])
				break;
			case local_SYTweenLite.UiAnimationType.POSX:
				curr_value = v.startvalue + (v.endValue - v.startvalue) * progress
				SetLocalPositionX(v.anim_wnd, curr_value)
				break;
			case local_SYTweenLite.UiAnimationType.POSY:
				curr_value = v.startvalue + (v.endValue - v.startvalue) * progress
				SetLocalPositionY(v.anim_wnd, curr_value)
				break;
			case local_SYTweenLite.UiAnimationType.ALPHA:
				curr_value = v.startvalue + (v.endValue - v.startvalue) * progress
				v.anim_wnd.alpha = curr_value
				break;
			case local_SYTweenLite.UiAnimationType.ALPHA_OLD:
				curr_value = v.startvalue + (v.endValue - v.startvalue) * progress
				SetAlpha(v.anim_wnd, curr_value)
				break;
			case local_SYTweenLite.UiAnimationType.WIDTH:
				curr_value = v.startvalue + (v.endValue - v.startvalue) * progress
				SetSizeDeltaX(v.anim_wnd, curr_value)
				break;
			case local_SYTweenLite.UiAnimationType.HEIGHT:
				curr_value = v.startvalue + (v.endValue - v.startvalue) * progress
				SetSizeDeltaY(v.anim_wnd, curr_value)
				break;
			case local_SYTweenLite.UiAnimationType.ROTATION:
				curr_value = v.startvalue + (v.endValue - v.startvalue) * progress
				v.anim_wnd.rotation = curr_value // Quaternion.Euler(0, 0, curr_value)
				break;
			case local_SYTweenLite.UiAnimationType.ROTATION_Y:
				curr_value = v.startvalue + (v.endValue - v.startvalue) * progress
				v.anim_wnd.localRotation = curr_value // Quaternion.Euler(0, curr_value, 0)
				break;
			case local_SYTweenLite.UiAnimationType.FILLAMOUNT:
				curr_value = v.startvalue + (v.endValue - v.startvalue) * progress
				v.anim_wnd.GetComponent("Image").fillAmount = curr_value
				break;
				// } else if (v.tweentype==local_SYTweenLite.UiAnimationType.CANVAS_POSY ) {
				// 	anim_wnd.SetVectorR(ScrollViewProperty.CanvasPosition,  pass_time)
				// } else if (v.tweentype==local_SYTweenLite.UiAnimationType.CANVAS_POSX ) {
				// 	anim_wnd.SetVectorL(ScrollViewProperty.CanvasPosition, pass_time)
			case local_SYTweenLite.UiAnimationType.SCALE:
				curr_value = [v.startvalue[0] + (v.endValue.x - v.startvalue[0]) * progress, v.startvalue[1] + (v.endValue.y - v.startvalue[1]) * progress]
				SetLocalScale(v.anim_wnd, curr_value[0], curr_value[1])
				break;
			case local_SYTweenLite.UiAnimationType.SRECT_HORIZONTAL:
				curr_value = v.startvalue + (v.endValue - v.startvalue) * progress
				v.anim_wnd.horizontalCenter = curr_value
				break;
			case local_SYTweenLite.UiAnimationType.SRECT_VERTICAL:
				curr_value = v.startvalue + (v.endValue - v.startvalue) * progress
				v.anim_wnd.verticalCenter = curr_value
				break;
			case local_SYTweenLite.UiAnimationType.ANCHORED_POS :
				v.anim_wnd.x = v.startvalue[0] + (v.endValue.x - v.startvalue[0]) * progress
				v.anim_wnd.y = v.startvalue[1] + (v.endValue.y - v.startvalue[1]) * progress
				break;
			case local_SYTweenLite.UiAnimationType.ANCHORED_POSX :
				curr_value = v.startvalue + (v.endValue - v.startvalue) * progress
				v.anim_wnd.x = curr_value
				break;
			case local_SYTweenLite.UiAnimationType.ANCHORED_POSY :
				curr_value = v.startvalue + (v.endValue - v.startvalue) * progress
				v.anim_wnd.y = curr_value
				break;
			case local_SYTweenLite.UiAnimationType.BOTTOM :
				curr_value = v.startvalue + (v.endValue - v.startvalue) * progress
				v.anim_wnd.bottom = curr_value
				break;
			case local_SYTweenLite.UiAnimationType.ALPHA_ALL:
				curr_value = v.startvalue + (v.endValue - v.startvalue) * progress
				let component = v.anim_wnd.GetComponent("CanvasGroup")
				component.alpha = curr_value
				break;
			case local_SYTweenLite.UiAnimationType.ALPHA_MODEL:
				// for (let j = 0; j < v.anim_wnd.Length; j++){
				// 	let render = v.anim_wnd[j]
				break;
				// 	if (render ) {
				// 		let mat = render.material
				// 		if (mat ) {
				// 			mat.color = Color(1, 1, 1, curr_value)
				// 		}
				// 	}
				// }
			case local_SYTweenLite.UiAnimationType.CENTER_POS:
				v.anim_wnd.centerX = v.startvalue[0] + (v.endValue.x - v.startvalue[0]) * progress
				v.anim_wnd.centerY = v.startvalue[1] + (v.endValue.y - v.startvalue[1]) * progress
				break;
			case local_SYTweenLite.UiAnimationType.CENTER_POSX:
				curr_value = v.startvalue + (v.endValue - v.startvalue) * progress
				v.anim_wnd.centerX = curr_value
				break;
			case local_SYTweenLite.UiAnimationType.CENTER_POSY:
				curr_value = v.startvalue + (v.endValue - v.startvalue) * progress
				v.anim_wnd.centerY = curr_value
				break;
			case local_SYTweenLite.UiAnimationType.SKEW_Y:
				v.anim_wnd.skewY = curr_value
				break;
			default:
				break;
		}
		return false
	}

	public static AddMovingItem(parent_wnd, anim_wnd, tweentype, startvalue, endValue, AnimaTime, anim_end_func, tween_type, loop) {
		let info = {
			parent_wnd: parent_wnd, anim_wnd: anim_wnd, tweentype: tweentype, startvalue: startvalue, endValue: endValue, AnimaTime: AnimaTime,
			anim_end_func: anim_end_func, tween_func: tween_type && SYTweenFunc[tween_type] || SYTweenFunc[SYTweenFunc.LINEAR], startTime: Status.NowTime, loop: loop || false
		}
		local_SYTweenLite.curr_info_index = local_SYTweenLite.curr_info_index + 1
		if (local_SYTweenLite.is_updating == false) {
			local_SYTweenLite.moving_info_list[local_SYTweenLite.curr_info_index] = info
		} else {
			local_SYTweenLite.moving_info_list_delay = local_SYTweenLite.moving_info_list_delay || {}
			local_SYTweenLite.moving_info_list_delay[local_SYTweenLite.curr_info_index] = info
		}
		return local_SYTweenLite.curr_info_index
	}

	public static Update() {
		local_SYTweenLite.is_updating = true
		let delete_list = null //更新完后再删除列表  避免更新过程中触发rehash产生影响
		for (let k in local_SYTweenLite.moving_info_list) {
			var v = local_SYTweenLite.moving_info_list[k]
			let usetime = Status.NowTime - v.startTime
			let need_delete = false
			if (v.tween_func) {
				//经过时间
				let ratio = Math.min(usetime / v.AnimaTime, 1)
				let progress = v.tween_func(ratio)
				need_delete = local_SYTweenLite.setMovingInfo(v, progress)
			}
			let timeout = false
			if (usetime >= v.AnimaTime) {
				if (v.loop) {
					v.startTime = Status.NowTime
				} else {
					timeout = true
				}
			}
			if (need_delete || timeout) {
				//结束回调
				if (!need_delete && v.anim_end_func != null) {
					v.anim_end_func()
				}
				delete_list = delete_list || []
				table.insert(delete_list, k)
			}
		}
		local_SYTweenLite.is_updating = false

		if(delete_list)
		{
			for (let i = 0; i < delete_list.length; i++) {
				delete local_SYTweenLite.moving_info_list[delete_list[i]]
			}
		}
		if(local_SYTweenLite.moving_info_list_delay)
		{
			for (let k in local_SYTweenLite.moving_info_list_delay) {
				var v = local_SYTweenLite.moving_info_list_delay[k]
				v.startTime = Status.NowTime
				local_SYTweenLite.moving_info_list[k] = v
			}
			local_SYTweenLite.moving_info_list_delay = null
		}

		if(local_SYTweenLite.moving_info_delete_list_delay)
		{
			for (let k in local_SYTweenLite.moving_info_delete_list_delay) {
				var v = local_SYTweenLite.moving_info_delete_list_delay[k]
				delete local_SYTweenLite.moving_info_list[v]
			}
			local_SYTweenLite.moving_info_delete_list_delay = null
		}

		if (Util.IsTableEmpty(local_SYTweenLite.moving_info_list)) {
			if (local_SYTweenLite.delayfun_timer) {
				GlobalTimerQuest.CancelQuest(local_SYTweenLite.delayfun_timer)
				local_SYTweenLite.delayfun_timer = null
			}
		}
	}

	public static Stop(id) {
		if (!id) { return }
		if (local_SYTweenLite.is_updating) {
			local_SYTweenLite.moving_info_delete_list_delay = local_SYTweenLite.moving_info_delete_list_delay || []
			table.insert(local_SYTweenLite.moving_info_delete_list_delay, id)
		} else {
			delete local_SYTweenLite.moving_info_list[id]
			if(local_SYTweenLite.moving_info_list_delay)
				delete local_SYTweenLite.moving_info_list_delay[id]
		}
	}
}
var local_SYTweenLite = SYTweenLite
window["SYTweenLite"] = SYTweenLite