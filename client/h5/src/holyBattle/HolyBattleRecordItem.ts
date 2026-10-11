import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { ResManager } from "../common/ResManager"
import { RoleManager } from "../commonModel/RoleManager"
import { GameResPath } from "../util/GameResPath"
import { Color, SetHtmlStyle } from "../util/Util"

export class HolyBattleRecordItem extends BaseItemRenderer {

	public WIDTH = 540
	public HEIGT = 47

	public constructor(parent) {
		super()
		this.base_file = "holyBattle"
		this.layout_file = "HolyBattleRecordItem"
		this.load_callback = () => {
			
			this.LoadSuccess()
		}
		this.Load()
	}

	public LoadSuccess() {

		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_line, GameResPath.GetIcon("holyBattle", "uifh_031"))
	}

	public dataChanged() {
		if (!super.dataChanged()) return
		let data = this.data
		//this._lb_rank.text = this.index
		this._lb_name.text = `S${data.server_num}.${data.name}`//"S" + data.server_num + "." + data.name
		this._lb_score.text = data.point
		this._lb_count.text = data.kill
		let textcolor = data.role_id == RoleManager.GetInstance().GetMainRoleId() && "#c85a37" ||"#763320"
		this._lb_name.color = textcolor



		let str_list = ["ui_phb_1a", "ui_phb_1b", "ui_phb_1c"]
		let index = this.index
		let bool = index <=2
		this.img_rank.visible = bool
		this._lb_rank.visible = !bool
		if (bool) {
			let str = str_list[index]
			ResManager.GetInstance().SetImageSprite(this, this.img_rank, "holyBattle", str, true)
		} else {
			this._lb_rank.text = `${index+1}`
		}

	}
	
	public DeleteMe(){
		super.DeleteMe()
	}

_img_bg:Laya.Image
img_rank:Laya.Image
_lb_rank:Laya.Label
_lb_name:Laya.Label
_lb_score:Laya.Label
_lb_count:Laya.Label
_img_line:Laya.Image
public GetComponents() {
[
this._img_bg,
this.img_rank,
this._lb_rank,
this._lb_name,
this._lb_score,
this._lb_count,
this._img_line,
]
 = this.GetChildrenByNames([

"_img_bg",
"img_rank",
"_lb_rank",
"_lb_name",
"_lb_score",
"_lb_count",
"_img_line",
])
}
}
 window["HolyBattleRecordItem"]= HolyBattleRecordItem