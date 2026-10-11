import { BaseItem1 } from "../common/BaseItem1"
import { ResManager } from "../common/ResManager"
import { UIToolTipMgr } from "../common/UIToolTipMgr"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { Util } from "../util/Util"
import { FtvActivenessTipsView } from "./FtvActivenessTipsView"

export class FtvActivenessAllItem extends BaseItem1 {
	_gp_tips: Laya.Box
	_img_bg: Laya.Image
	_img_icon: Laya.Image
	_img_red: Laya.Image
	data
	info
	needRefreshData

	public constructor(parent?) {
		super(parent)


		this.base_file = "ftvActiveness"
		this.layout_file = "FtvActivenessAllItem"
		this.preload_client_config = {
			"ConfigCustomActivityView": false
		}
		this.load_callback = () => {

			this.InitEvent()
			if(this.needRefreshData){
				this.InitView()
				this.needRefreshData = undefined
			}
		}


	}

	public InitEvent() {


		Util.AddClickEvent(this._gp_tips, () => {
			if (this.data && this.info && this.data.reward.length > 0) {
				if (this.data.status == 1) {
					CustomActivityModel.GetInstance().Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33195, this.info.base_type, this.info.sub_type, this.data.grade)
				} else {
					let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(this.data.reward[0].style, this.data.reward[0].typeId)
					UIToolTipMgr.GetInstance().AppendGoodsTips(type_id)
				}
				return
			} else if (this.data) {
				let tipe_view = new FtvActivenessTipsView()
				tipe_view.SetData(this.data)
				tipe_view.Open()
			}
		}
			, this, true)
	}

	public InitView() {
		if(!this.data) return

		let data = this.data
		for (let _tmpi in data.condition) {
			var v = data.condition[_tmpi]
			if (v[0] == "icon") {
				ResManager.GetInstance().SetImageSprite(this, this._img_icon, "ftvActiveness_asset", v[1])
				break
			}
		}
		let red_bool = (data.status == 1 && (true) || (false))
		this._img_red.visible = red_bool

		let cfg = this.preload_client_config["ConfigCustomActivityView"]
		if (cfg) {
			// CustomActivityModel.GetInstance().LoadCompontRes(this, cfg, "FtvActivenessAllItem", this.info.show_id)
		}
	}

	public SetData(...new_args) {

		let arg = new_args
		this.data = arg[0]
		this.info = arg[1]
		if(this.is_loaded){
			this.InitView()
		}
		else{
			this.needRefreshData = true
		}
	}

	public GetComponents() {
		[
			this._gp_tips,
			this._img_bg,
			this._img_icon,
			this._img_red,
		]
			= this.GetChildrenByNames([

				"_gp_tips",
				"_img_bg",
				"_img_icon",
				"_img_red",
			])
	}
}
window["FtvActivenessAllItem"]=FtvActivenessAllItem