import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { GoodsModel } from "../commonModel/GoodsModel"
import { KfHolyAreaModel } from "../commonModel/KfHolyAreaModel"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { SYTweenLite } from "../util/SYTweenLite"
import { Util } from "../util/Util"

export class KfHolyAreaScoreRewardItem extends BaseItem1 {
	_Image1: Laya.Image
	_gp_behind: Laya.Box
	_img_box: Laya.Image
	_gp_front: Laya.Box
	_lb_score: Laya.Label
	_img_get: Laya.Image
	red: Laya.Image
	cfg
	model
	need_refresh_data
	tween_list
	vo
	wait_time_id
	posx
	posy





	public constructor(parent) {
		super(parent)


		this.base_file = "kfHolyArea"

		this.layout_file = "KfHolyAreaScoreRewardItem"

		this.model = KfHolyAreaModel.GetInstance()

		this.load_callback = () => {

			this.LoadSuccess()

		}
		//this.Load()
	}



	public LoadSuccess() {


		//this.form.pivot = Vector2(0,1)





		this.InitEvent()

	}



	public InitEvent() {




		Util.AddClickEvent(this._img_box, () => {

			if (this.vo) {

				if (this.vo.state == 1) {

					this.model.Fire(KfHolyAreaModel.REQUEST_CCMD_EVENT, 28409, this.vo.score_cfg)

				} else {
					if (this.cfg) {

						let preview_list = JSON.parse(this.cfg.preview)

						let vo = preview_list && preview_list[0]

						if (vo) {

							UIToolTipMgr.GetInstance().DefaultAppendTips(Number(vo[1]), Number(vo[2]))

						}

					}

				}

			}

		}, this, false)



		if (this.need_refresh_data) {

			this.UpdateView()

			this.need_refresh_data = false

		}

	}



	public SetData(vo?, cfg?, x?, y?) {


		this.vo = vo

		this.cfg = cfg
		this.posx = x
		this.posy = y

		if (this.is_loaded) {

			this.UpdateView()

		} else {
			this.need_refresh_data = true

		}

	}



	public UpdateView() {


		let vo = this.vo

		let cfg = this.cfg

		if (vo && cfg) {

			let preview_list = JSON.parse(this.cfg.preview)

			let goods_vo = preview_list && preview_list[0]

			if (goods_vo) {

				let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(goods_vo[1])

				ResManager.GetInstance().SetOutsideImageSprite(this, this._img_box, GameResPath.GetGoodsIconPath(basic.goods_icon))

			}

			this._lb_score.text = vo.score_cfg

			this.ChangeBoxState(vo.state)
			this.display_obj.x = this.posx
			this.display_obj.y = this.posy

		}

	}



	public ChangeBoxState(state?) {


		this._img_get.visible = false
		switch (state) {
			case 0:
				this.red.visible = false
				this.StopAction()
				break;
			case 1:
				this.red.visible = true
				this.StartAction()
				break;
			case 2:
				this.red.visible = false
				this._img_get.visible = true
				this.StopAction()
				break;

		}


	}



	public StartAction() {


		this.StopAction()

		this.PlayTween()


	}



	public StopAction() {


		this.ClearTween()

		this.ClearTimer()



		// this.ClearUIEffect(this._gp_behind)

		// this.ClearUIEffect(this._gp_front)

	}



	public PlayTween() {

		if (!this.tween_list) {

			this.tween_list = []

		}



		table.insert(this.tween_list, SYTweenLite.to(this, this._img_box, SYTweenLite.UiAnimationType.ROTATION, -30, 0.15, () => {

			table.insert(this.tween_list, SYTweenLite.to(this, this._img_box, SYTweenLite.UiAnimationType.ROTATION, 30, 0.3, () => {

				table.insert(this.tween_list, SYTweenLite.to(this, this._img_box, SYTweenLite.UiAnimationType.ROTATION, 0, 0.15, () => {

					this.WaitTime()

				}))

			}))

		}))

	}





	public WaitTime() {


		this.ClearTween()



		this.wait_time_id = setTimeout(() => {

			this.PlayTween()

		}, 0.15)

	}



	public ClearTimer() {


		if (this.wait_time_id) {

			clearTimeout(this.wait_time_id)

			this.wait_time_id = false

		}

	}



	public ClearTween() {




		if (this.tween_list) {

			for (let i = 0; i < this.tween_list.length; i++) {
				var v = this.tween_list[i]

				SYTweenLite.Stop(v)

			}

			this.tween_list = false

		}

		//SetLocalRotation(this._img_box, 0, 0, 0)

	}



	public DeleteMe() {


		this.StopAction()
		super.DeleteMe()

	}




	public GetComponents() {
		[
			this._Image1,
			this._gp_behind,
			this._img_box,
			this._gp_front,
			this._lb_score,
			this._img_get,
			this.red
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_gp_behind",
				"_img_box",
				"_gp_front",
				"_lb_score",
				"_img_get",
				"red"
			])
	}
}
window["KfHolyAreaScoreRewardItem"] = KfHolyAreaScoreRewardItem