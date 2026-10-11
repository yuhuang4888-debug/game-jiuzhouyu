import { AutoFightManager } from "../autofight/AutoFightManager"
import { BaseItem1 } from "../common/BaseItem1"
import { Config } from "../common/Config"
import { EternityEvent, EternityModel } from "../commonModel/EternityModel"
import { Scene } from "../scene/Scene"
import { SceneObj } from "../scene/sceneobj/SceneObj"
import { Util } from "../util/Util"
import { Vector2 } from "../util/Vector2"

export class EternityMonItem extends BaseItem1 {
	click: Laya.Box
	_Image1: Laya.Image
	_Image2: Laya.Image
	_Label1: Laya.Label
	_lb_name: Laya.Label
	_lb_lv: Laya.Label
	_img_select: Laya.Image
	_map_data
	_model

	public constructor(parent?) {
		super(parent)


		this.base_file = "eternity"
		this.layout_file = "EternityMonItem"
		this._model = EternityModel.GetInstance()
		this.load_callback = () => {

			// if (PlatformMgr.GetInstance().IsEyouEnPlatform() ) {
			// 	this._Label1.size  = 12
			// 	this._lb_name.size  = 12
			// 	this._lb_lv.size  = 12
			// 	SetAnchoredPosition(this._lb_name,50,0)
			// 	SetAnchoredPosition(this._lb_lv,182,0)
			// }
			this.LoadSuccess()
			this.InitEvent()
		}
	}

	public InitEvent() {

		Util.AddClickEvent(this.click, () => {
			if (!this._map_data) {
				return
			}
			AutoFightManager.GetInstance().SetAutoFight(false)
			let tar_pos = new Vector2(this._map_data.x / SceneObj.GetLogicRealRatio().x, this._map_data.y / SceneObj.GetLogicRealRatio().y)
			Scene.GetInstance().MainRoleMove(tar_pos, 2, () => {
				AutoFightManager.GetInstance().SetAutoFight(true)
			}
			)
			Scene.GetInstance().SetClickTarget(null)
			this._model.Fire(EternityEvent.SELECT_MON, this._map_data.mon_id)
		}
			, this)
		this.BindEvent(this._model, EternityEvent.SELECT_MON, (mon_id?) => {
			if (!this._map_data) {
				return
			}
			this._img_select.visible = this._map_data.mon_id == mon_id
		}
		)
	}

	public LoadSuccess() {
	}
	public SetData(data?) {
	}
	public SetMapData(mData?) {

		this._map_data = mData
		if (mData) {
			let mdata = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, mData.mon_id, false)
			this._lb_name.text = (mdata && (mdata.name) || (""))
			this._lb_lv.text = "LV." + mdata.lv
		}
	}



	public GetComponents() {
		[
			this.click,
			this._Image1,
			this._Image2,
			this._Label1,
			this._lb_name,
			this._lb_lv,
			this._img_select,
		]
			= this.GetChildrenByNames([

				"click",
				"_Image1",
				"_Image2",
				"_Label1",
				"_lb_name",
				"_lb_lv",
				"_img_select",
			])
	}
}
window["EternityMonItem"] = EternityMonItem