import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { MondaysAwardModel } from "../commonModel/MondaysAwardModel"
import { Util } from "../util/Util"

export class MondaysAwardRecordItem extends BaseItemRenderer {
	_head
	_lb_desc
	_lb_name
	_model
	head

	public WIDTH = 300
	public HEIGT = 75

	public constructor(parent) {
		super()

		this.base_file = "mondaysaward"
		this.layout_file = "MondaysAwardRecordItem"
		this._model = MondaysAwardModel.GetInstance()
		this.head = null
		this.Load()
	}

	public dataChanged() {
		if(super.dataChanged()){
			if (!this.data) {
				return
			}
			let [cDesc, desc] = this._model.recordDesc(this.data.type, this.data.pool_id)
			this._lb_name.style.fontSize=20
			this._lb_name.style.color="#957054"
			this._lb_name.style.wordWrap=true
			if (this.data.server_num != null) {
				this._lb_name.innerHTML = Util.StrToHTML("<font color='#f551ff'>s" + this.data.server_num + "." + this.data.role_name + "</font>获得" + cDesc+"<font color='#FFFFFF'>" + desc+ "</font>"
				)
			} else {
				this._lb_name.innerHTML = Util.StrToHTML("<font color='#f551ff'>" + this.data.role_name + "</font>获得" + cDesc+"<font color='#FFFFFF'>" + desc+ "</font>"
				)
			}
			this._lb_name.width=220
			// if(this._lb_name.contextHeight>20){
			// 	let context=this._lb_name.innerHTML
			// 	this._lb_name.innerHTML=context+"<font color='#FFFFFF'>" + desc+ "</font>"
			// 	this._lb_name.width=240
			// }else{
			// 	this._lb_desc.style.fontSize=20
			// 	this._lb_desc.style.color="#ffffff"
			// 	this._lb_desc.innerHTML = desc
			// 	this._lb_desc.width=200
			// }
			this._lb_desc.visible=false

			if (this.head == null) {
				this.head = new CustomHeadItem(this._head)
				this.head.SetActiveFrame(false)
				this.head.SetActiveLevel(false)
				this.head.Load()
			}
			this.head.SetRoleVoData(this.data, this.data.turn, this.data.serverid)
		}
	}

	public DeleteMe() {

		if (this.head) {
			this.head.DeleteMe()
			this.head = null
		}
		super.DeleteMe()
	}

	_Image1: Laya.Image
	public GetComponents() {
		[
			this._lb_name,
			this._lb_desc,
			this._Image1,
			this._head,
		]
			= this.GetChildrenByNames([

				"_lb_name",
				"_lb_desc",
				"_Image1",
				"_head",
			])
	}
}
window["MondaysAwardRecordItem"] = MondaysAwardRecordItem