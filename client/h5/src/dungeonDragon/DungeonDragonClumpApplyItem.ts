import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { TeamEvent, TeamModel } from "../commonModel/TeamModel"
import { Util } from "../util/Util"

export class DungeonDragonClumpApplyItem extends BaseItemRenderer {
	role_head
	public WIDTH = 576
	public HEIGT = 104
	is_set
	public constructor(parent) {
		super()
		this.is_set=false
		this.base_file = "dungeonDragon"
		this.layout_file = "DungeonDragonClumpApplyItem"

		this.load_callback = () => {

			this.InitEvent()

			if(!this.is_set){
				this.is_set=true
				this.SetData()
			}
		}
		this.Load()
	}

	public InitEvent() {

		Util.AddClickEvent(
			this._gp_agree, () => {
				if (this.data) {
					TeamModel.GetInstance().Fire(TeamEvent.TEAM_REQUEST_OTHER_PROTO, 24004, [[1, this.data.server_id, this.data.player_id]])
				}
			},
			this,
			true
		)
		Util.AddClickEvent(
			this._gp_refuse, () => {
				if (this.data) {
					TeamModel.GetInstance().Fire(TeamEvent.TEAM_REQUEST_OTHER_PROTO, 24004, [[0, this.data.server_id, this.data.player_id]])
				}
			},
			this,
			true
		)
	}

	public dataChanged() {
		if (!super.dataChanged()) return
		if(this.is_loaded){
			this.SetData()
			this.is_set=true
		}else{
			this.is_set=false
		}
	}


	SetData(){
		if(!this.data)return
		let data = this.data
		this._lb_name.text = "S" + data.server_num + "." + data.name
		this._lb_fighting.text = "战力:" + data.combat_power
		this._lb_level.text = "Lv." + data.level
		//let picture = data.picture
		//let career = data.career
		//let picture_source = null
		//let _source = career + "001"
		//if (picture && Trim(picture) != "" ) {
		//    // [ts2lua]Config.PRELOAD_SETVER_CONFIG.config_picture下标访问可能不正确
		//    let picture_cfg = Config.Picture[picture]
		//    if (picture_cfg ) {
		//        _source = picture_cfg.resource
		//    }
		//}
		//picture_source = GameResPath.GetIcon("head", _source)
		//lua_resM:SetOutsideImageSprite(this, this._img_head, picture_source)
		if (!this.role_head) {
			this.role_head = new CustomHeadItem(this._img_head)
			this.role_head.Load()
		}
		//data.role_id = data.id
		//this.role_head.SetRoleVoData(data)
		this.role_head.SetData(data.player_id, data.career, data.sex, data.picture, data.picture_ver)
	}

	public DeleteMe() {

		if (this.role_head) {
			this.role_head.DeleteMe()
			this.role_head = null
		}
		super.DeleteMe()
	}


_Image1:Laya.Image
_img_head:Laya.Box
_lb_name:Laya.Label
_lb_fighting:Laya.Label
_lb_level:Laya.Label
_gp_agree:Laya.Box
_Image4:Laya.Image
_Label1:Laya.Label
_gp_refuse:Laya.Box
_Image5:Laya.Image
_Label2:Laya.Label
public GetComponents() {
[
this._Image1,
this._img_head,
this._lb_name,
this._lb_fighting,
this._lb_level,
this._gp_agree,
this._Image4,
this._Label1,
this._gp_refuse,
this._Image5,
this._Label2,
]
 = this.GetChildrenByNames([

"_Image1",
"_img_head",
"_lb_name",
"_lb_fighting",
"_lb_level",
"_gp_agree",
"_Image4",
"_Label1",
"_gp_refuse",
"_Image5",
"_Label2",
])
}
}
 window["DungeonDragonClumpApplyItem"]= DungeonDragonClumpApplyItem