import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { ResManager } from "../common/ResManager"
import { Kf1vnModel } from "../commonModel/Kf1vnModel"
import { GetSexByCareer } from "../util/Util"

export class Kf1vnChallengerMsgItem extends BaseItemRenderer {

	head1:CustomHeadItem
	model
	public WIDTH = 214
	public HEIGT = 58

	public constructor(parent) {
		super()

		this.base_file = "kf1vn"
		this.layout_file = "Kf1vnChallengerMsgItem"
		this.model = Kf1vnModel.GetInstance()
		this.Load()
	}

	public load_callback() {
	}


	public dataChanged() {
		if(!super.dataChanged())return
		if(!this.head1 ){
		this.head1 = new CustomHeadItem(this.role_head)
		this.head1.CloseClick()
			this.head1.ExcuteCallback(()=>{
				this.head1.SetRoleVoData(this.data)
				this.head1.SetActiveLevel(false)
			})
		this.head1.Load()

	}





		this.head1.SetRoleVoData(this.data)
		this.head1.SetActiveLevel(false)
			this.role_name.text = `S${this.data.server_num}.${this.data.name}`
			this.fight.text = `战力:${this.data.combat_power}`
		this._bg.visible = !this.data.not_show_line
	}

	public DeleteMe() {

		if (this.head1) {
			this.head1.DeleteMe()
			this.head1=null
		}
		super.DeleteMe()
	}


_bg:Laya.Image
role_head:Laya.Box
role_name:Laya.Label
fight:Laya.Label
public GetComponents() {
[
this._bg,
this.role_head,
this.role_name,
this.fight,
]
 = this.GetChildrenByNames([

"_bg",
"role_head",
"role_name",
"fight",
])
}
}
 window["Kf1vnChallengerMsgItem"]= Kf1vnChallengerMsgItem