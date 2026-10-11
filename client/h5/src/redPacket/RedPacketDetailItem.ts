import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { ResManager } from "../common/ResManager"
import { RedPacketModel } from "../commonModel/RedPacketModel"

export class RedPacketDetailItem extends BaseItemRenderer {
	_model= RedPacketModel.GetInstance()
	head_item

	public WIDTH = 256
	public HEIGT = 67

	public constructor(parent) {
		super()

		this.base_file = "redPacket"
		this.layout_file = "RedPacketDetailItem"

		this.load_callback = () => {
			this.load_callback1()
		}
		this.Load()
	}

	public DeleteMe() {

		if(this.head_item){
			this.head_item.DeleteMe()
			this.head_item=null
		}
		
		super.DeleteMe()
	}

	// function RedPacketDetailItem.createChildren()
	public load_callback1() {

		// super.createChildren()


	
	}

	public dataChanged() {

		if (! super.dataChanged()) {
			return
		}
		let data = this.data
		if(!this.head_item){
			this.head_item = new CustomHeadItem(this._img_head)
			this.head_item.Load()
		}
		this.head_item.SetRoleVoData(data)
		this._lb_role_name.text = data.role_name
		this._lb_money.text = data.receive_money
		this._gp_best.visible = data.is_best
		ResManager.GetInstance().SetImageSprite(this, this._img_money, "common_asset", (data.type == 100 && ("com_diamond") || ("com_bind_diamond")))
	}


_Image1:Laya.Image
_lb_role_name:Laya.Label
_img_head:Laya.Box
_Group1:Laya.HBox
_lb_money:Laya.Label
_img_money:Laya.Image
_gp_best:Laya.Box
_Image3:Laya.Image
_lb_money0:Laya.Label
public GetComponents() {
[
this._Image1,
this._lb_role_name,
this._img_head,
this._Group1,
this._lb_money,
this._img_money,
this._gp_best,
this._Image3,
this._lb_money0,
]
 = this.GetChildrenByNames([

"_Image1",
"_lb_role_name",
"_img_head",
"_Group1",
"_lb_money",
"_img_money",
"_gp_best",
"_Image3",
"_lb_money0",
])
}
}
 window["RedPacketDetailItem"]= RedPacketDetailItem