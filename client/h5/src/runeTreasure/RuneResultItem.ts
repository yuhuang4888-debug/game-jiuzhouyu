import { BaseItem1 } from "../common/BaseItem1"
import { GlobalTimerQuest, SetMaterialTexture, Util } from "../util/Util"
import { ResManager } from "../common/ResManager"
import { SYTweenLite } from "../util/SYTweenLite"
import { RuneTreasureEvent, RuneTreasureModel } from "../commonModel/RuneTreasureModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { RuneModel } from "../commonModel/RuneModel"
import { WordManager } from "../common/WordManager"

export class RuneResultItem extends BaseItem1 {
	model
	res_mgr
	goods_model
	rune_model

	data
	need_refresh = false
	is_anim = false
	anim_time = 0.2
	tween_id1 = null
	tween_id2 = null
	rune_color = {
		1: "rune_N",
		2: "rune_R",
		3: "rune_SR",
		4: "rune_SSR",
		5: "rune_UR",
		6: "rune_SP"
	}
	rune_bg = {
		1: "rune_back.png",
		2: "rune_back.png",
		3: "rune_back.png",
		4: "rune_orange.png",
		5: "rune_red.png",
		6: "rune_pink.png"
	}
	//rune_mat:Laya.EffectMaterial
	//rune_tex

	public constructor(parent) {
		super(parent)
		this.base_file = "runeTreasure"
		this.layout_file = "RuneResultItem"

		this.res_mgr = ResManager.GetInstance()
		this.model = RuneTreasureModel.GetInstance()
		this.goods_model = GoodsModel.GetInstance()
		this.rune_model = RuneModel.GetInstance()

		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvent()

			if (this.need_refresh) {
				this.need_refresh = false
				this.SetData(this.data)
			}
		}
	}

	public LoadSuccess() {
		// 效果一
		//this._img_icon.skewY = 90

		// 效果二
		//this._img_icon.visible = false

		// 效果三
		this._img_icon.scaleX = 0

	}

	public InitEvent() {
		Util.AddClickEvent(this._btn_click, () => {
			this.PlayAnim()
		}, this, true)
	}
	/**this.data[0] 为99是特殊字段 */
	public SetData(data) {
		this.data = data
		if (!this.is_loaded) {
			this.need_refresh = true
			return
		}
		let url = "resource/game/runeIcon/" + this.data[1] + ".png"
		this.res_mgr.SetOutsideImageSprite(this, this._img_icon, url)
		let is_pink = false
		let basic = this.goods_model.GetGoodsBasicByTypeId(this.data[1])
		if (basic) {
			let icon = this.rune_color[basic.color]
			let bgRes = "rune_back.png"
			let scale = 1
			let effect = basic.color == 4 ? "ui_yuhunkuang_03" : "ui_yuhunkuang_04"
			if (this.data[1] == 26270005 || this.data[1] == 26260005) {
				icon = "rune_SP"
				effect = "ui_yuhunkuang_05"
				is_pink = true
			}
			if (this.data[0] == 99) {
				this._img_bg.visible = false
				this._img_icon.scaleX = 1
				scale = 2.2
				effect = this.data[2] == 1 ? "ui_yuhun_wushiyiji_1" : "ui_yuhun_jueduifangyu_1"
			}
			if (basic.color > 3 || this.data[0] == 99) {
				this.AddUIEffect(effect, this._gp_effect, { x: 0, y: 0 }, scale, true)
				bgRes = is_pink ? this.rune_bg[6] : this.rune_bg[basic.color]
			}
			this.res_mgr.SetOutsideImageSprite(this, this._img_bg, `resource/game/runeIcon/${bgRes}`)
			this.res_mgr.SetImageSprite(this, this._img_color, "runeTreasure", icon)
			let rune = this.rune_model.GetRuneProList(basic.subtype, 1, basic.color)
			if (rune) {
				if (rune.length == 1) {
					this._lb_msg1.text = ""
					this._lb_msg2.text = basic.goods_name
					this._lb_msg3.text = WordManager.GetProperties(rune[0][0]) + "：" + WordManager.ConvertToPercentValue(rune[0][0], rune[0][1])
				} else {
					this._lb_msg1.text = basic.goods_name
					this._lb_msg2.text = WordManager.GetProperties(rune[0][0]) + "：" + WordManager.ConvertToPercentValue(rune[0][0], rune[0][1])
					this._lb_msg3.text = WordManager.GetProperties(rune[1][0]) + "：" + WordManager.ConvertToPercentValue(rune[1][0], rune[1][1])
				}
			}
		}
	}

	public PlayAnim() {
		if (this.is_anim) {
			return
		}
		this.is_anim = true
		this._gp_effect.visible = false

		// 效果一 skew
		/*
		this.tween_id1 = SYTweenLite.to(this, this._img_bg, SYTweenLite.UiAnimationType.SKEW_Y, -90, this.anim_time, () => {
			SYTweenLite.Stop(this.tween_id1)
			this.tween_id1 = null
			this.tween_id2 = SYTweenLite.to(this, this._img_icon, SYTweenLite.UiAnimationType.SKEW_Y, 0, this.anim_time, () => {
				SYTweenLite.Stop(this.tween_id2)
				this.tween_id2 = null
				this._gp_effect.visible = true
				this.model.Fire(RuneTreasureEvent.RUNE_ANIM_END)
			})
		})
		*/

		// 效果二  特效
		/*
		this._img_bg.visible = false
		let mesh
		this.AddUIEffect("ui_fanpai_01", this._gp_anieff, null, 8, false, 1.2, () => {
			this._gp_effect.visible = true
			this._img_icon.visible = true
			this.model.Fire(RuneTreasureEvent.RUNE_ANIM_END)
		}, (obj: Laya.Sprite3D) => {
			mesh = obj.getChildByName("fuwen01_000")
			if (mesh instanceof Laya.MeshSprite3D) {
				//this.rune_mat = mesh.meshRenderer.sharedMaterial as Laya.EffectMaterial
			}
			if (mesh) {
				GlobalTimerQuest.AddDelayQuest(() => {
					if (!this.use_delete_method && mesh && this.rune_tex) {
						//this.rune_mat.texture = this.rune_tex
						let mat = new Laya.EffectMaterial()
						mat.color = new Laya.Vector4(0.5, 0.5, 0.5, 1)
						mat.texture = this.rune_tex
						mesh.meshRenderer.sharedMaterial = mat
					}
				}, 0.35)
			}
		}, null, null, null, null, false)
		*/

		// 效果三 缩放
		this.tween_id1 = SYTweenLite.to(this, this._img_bg, SYTweenLite.UiAnimationType.SCALE, { x: 0, y: 1 }, this.anim_time, () => {
			SYTweenLite.Stop(this.tween_id1)
			this.tween_id1 = null
			this.tween_id2 = SYTweenLite.to(this, this._img_icon, SYTweenLite.UiAnimationType.SCALE, { x: 1, y: 1 }, this.anim_time, () => {
				SYTweenLite.Stop(this.tween_id2)
				this.tween_id2 = null
				this._gp_effect.visible = true
				this.model.Fire(RuneTreasureEvent.RUNE_ANIM_END)
			})
		})
	}

	public DeleteMe() {
		if (this.tween_id1) {
			SYTweenLite.Stop(this.tween_id1)
			this.tween_id1 = null
		}
		if (this.tween_id2) {
			SYTweenLite.Stop(this.tween_id2)
			this.tween_id2 = null
		}
		super.DeleteMe()
	}

	_btn_click: Laya.Box
	_img_icon: Laya.Image
	_img_color: Laya.Image
	_lb_msg1: Laya.Label
	_lb_msg2: Laya.Label
	_lb_msg3: Laya.Label
	_img_bg: Laya.Image
	_gp_effect: Laya.Box
	_gp_anieff: Laya.Box
	public GetComponents() {
		[
			this._btn_click,
			this._img_icon,
			this._img_color,
			this._lb_msg1,
			this._lb_msg2,
			this._lb_msg3,
			this._img_bg,
			this._gp_effect,
			this._gp_anieff,
		]
			= this.GetChildrenByNames([

				"_btn_click",
				"_img_icon",
				"_img_color",
				"_lb_msg1",
				"_lb_msg2",
				"_lb_msg3",
				"_img_bg",
				"_gp_effect",
				"_gp_anieff",
			])
	}
}
window["RuneResultItem"] = RuneResultItem