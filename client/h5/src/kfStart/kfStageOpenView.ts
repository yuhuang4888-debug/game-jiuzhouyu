import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { kfStageModel } from "../commonModel/kfStageModel"
import { Util } from "../util/Util"
import { SYTweenLite } from "../util/SYTweenLite"
import { kfStageShow2View } from "./kfStageShow2View"
import { table } from "../common/table"

export class kfStageOpenView extends BaseView1 {
	res_mgr: ResManager
	model
	anim_time = 0.7
	sec_view: kfStageShow2View
	tween_list
	time_id

	public constructor() {
		super()
		this.base_file = "kfStart"
		this.layout_file = "kfStageOpenView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.use_background = true
		this.click_bg_toClose=true
		this.append_to_ctl_queue = true;
		this.not_show_item_use = true
		this.sec_view = null
		this.tween_list = []

		this.res_mgr = ResManager.GetInstance()
		this.model = kfStageModel.GetInstance()

		this.load_callback = () => {
			
			this.display_obj.left = 0
			this.display_obj.right = 0
			this.display_obj.top = Util.GetLiuhaiHeight()
			this.display_obj.bottom = 0
			
			this._gp_click2.visible=false

			this.sec_view = new kfStageShow2View(this._box1)
			this.sec_view.ExcuteCallback(() => {
				this.InitEvent()
				this.LoadSuccess()
			})
			this.sec_view.Load()
			this.sec_view.SetVisible(false)
		}

		this.close_callback = () => {
			this.Remove()
		}
	}

	private LoadSuccess() {
		this.model.Fire(kfStageModel.CLOSE_VIEW)

		this.res_mgr.SetOutsideImageSprite(this, this._img_left, "resource/game/kfStart/other/ui_kqkf_tc_004a.jpg")
		this.res_mgr.SetOutsideImageSprite(this, this._img_right, "resource/game/kfStart/other/ui_kqkf_tc_004a.jpg")
		this.res_mgr.SetOutsideImageSprite(this, this._img_left2, "resource/game/kfStart/other/ui_kqkf_tc_006a.png")
		this.res_mgr.SetOutsideImageSprite(this, this._img_right2, "resource/game/kfStart/other/ui_kqkf_tc_006b.png")
		this.res_mgr.SetOutsideImageSprite(this, this._img_center, "resource/game/kfStart/other/ui_kqkf_tc_002.png")

		// this.display_obj.width = Laya.stage.width
		// this.display_obj.height = Laya.stage.height
		// this._gp_click.width = Laya.stage.width
		// this._gp_click.height = Laya.stage.height
	}

	private InitEvent() {
		Util.AddClickEvent(this._gp_click, () => {
			this._img_center.visible = false
			this._gp_click.visible = false
			this.PlayAnim()
		}, this, true)

		Util.AddClickEvent(this._gp_click2, () => {
			this.Close()
		}, this, true)


		Util.AddClickEvent(this._btn_close, () => {
			this.Close()
		}, this, true)

	}


	private ClearTween() {
		if (this.tween_list && this.tween_list.length > 0) {
			for (let i = 0; i < this.tween_list.length; i++) {
				SYTweenLite.Stop(this.tween_list[i])
			}
			this.tween_list = []
		}

		if (this.time_id) {
			clearTimeout(this.time_id)
			this.time_id = null
		}
	}

	private Remove() {

		this.ClearTween()

		if (this.sec_view) {
			this.sec_view.DeleteMe()
			this.sec_view = null
		}
	}

	//关闭动画
	private PlayAnim() {
		if (this.sec_view) this.sec_view.SetVisible(true)
		this.ClearTween()

	

		let left_move = this._img_left.x - (Laya.stage.width + this._img_left.width) / 2
		let right_move = this._img_right.x + (Laya.stage.width + this._img_left.width) / 2
		let id1 = SYTweenLite.to(this, this._img_left, SYTweenLite.UiAnimationType.POSX, left_move, this.anim_time)
		table.insert(this.tween_list, id1)
		let id2 = SYTweenLite.to(this, this._img_right, SYTweenLite.UiAnimationType.POSX, right_move, this.anim_time, () => {
			this._img_left.visible = this._img_right.visible = false
		})
		table.insert(this.tween_list, id2)


		let dispose_k = 0.4 //大门运动 this.anim_time*0.7 时间后开始渐隐
		this.time_id = setTimeout(() => {
			let id3 = SYTweenLite.to(this, this._img_left, SYTweenLite.UiAnimationType.ALPHA, 0, this.anim_time * (1 - dispose_k))
			table.insert(this.tween_list, id3)

			let id4 = SYTweenLite.to(this, this._img_right, SYTweenLite.UiAnimationType.ALPHA, 0, this.anim_time * (1 - dispose_k),()=>{
				this._gp_click.visible=false
				this._gp_click2.visible=true
			})
			table.insert(this.tween_list, id4)

		}, this.anim_time * dispose_k*1000);

	}

_box1:Laya.Box
_btn_close:Laya.Image
_gp_click2:Laya.Box
_box2:Laya.Box
_img_left:Laya.Image
_img_left2:Laya.Image
_img_right:Laya.Image
_img_right2:Laya.Image
_img_center:Laya.Image
_img_tips:Laya.Image
_gp_click:Laya.Box
public GetComponents() {
[
this._box1,
this._btn_close,
this._gp_click2,
this._box2,
this._img_left,
this._img_left2,
this._img_right,
this._img_right2,
this._img_center,
this._img_tips,
this._gp_click,
]
 = this.GetChildrenByNames([

"_box1",
"_btn_close",
"_gp_click2",
"_box2",
"_img_left",
"_img_left2",
"_img_right",
"_img_right2",
"_img_center",
"_img_tips",
"_gp_click",
])
}
}
 window["kfStageOpenView"]= kfStageOpenView