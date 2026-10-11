import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { Util, HtmlColorTxt, SetAnchoredPosition, RefBoxChildsLayout } from "../util/Util"
import { DungeonDragonDefine } from "./DungeonDragonDefine"
import { DungeonDragonRecordItem } from "./DungeonDragonRecordItem"

export class DungeonDragonRecordView extends BaseView1 {
	InitEvent
	LoadSuccess
	Local_Open
	Remove
	UpdateView
	change_scene_close
	click_bg_toClose
	destroy_callback
	destroy_imm
	is_center
	show_open_movie
	use_background


	public static RolePos = [[186, -12], [-2, 94], [381, 94]];
	public constructor() {
		super()

		this.base_file = "dungeonDragon"
		this.layout_file = "DungeonDragonRecordView"
		this.layer_value = Enum_UILayer.Activity
		this.show_open_movie = true
		this.change_scene_close = true
		this.use_background = true
		this.click_bg_toClose = true
		this.destroy_imm = true
		this.is_center = true
		let base_model = BaseDungeonModel.GetInstance()

		let local_BaseDungeonModel = BaseDungeonModel
		let local_Util = Util
		let local_TimeUtil = TimeUtil
		let dun_id_ = null
		let wave_ = null
		let role_item_list_ = null
		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.destroy_callback = () => {
			this.Remove()
		}

		this.Local_Open = (parms?) => {
			if (parms) {
				dun_id_ = parms[0]
				wave_ = parms[1]
			}
			super.Open()
		}

		this.LoadSuccess = () => {
			//ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("dungeonDragon", "uiboss_049"))
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg0, GameResPath.GetIcon("dungeonDragon", "ui_copy_38"))
			this.InitEvent()
			this._lb_wave2.text = wave_
			this._lb_wave1.text= `${DungeonDragonDefine.LevelTips[dun_id_]}试炼·第`
			base_model.Fire(local_BaseDungeonModel.SCMD_REQUEST, 61050, dun_id_, wave_)
			RefBoxChildsLayout(this._Group1,2)
		}

		this.InitEvent = () => {
			this.BindEvent(base_model, local_BaseDungeonModel.UPDATE_BEST_RECORD, (scmd?) => {
				this.UpdateView(scmd)
			}
			)

			Util.AddClickEvent(this._img_close, () => {
				this.Close()
			}, this, true)
		}

		this.Remove = () => {
			if (role_item_list_) {
				for (let _tmpi in role_item_list_) {
					var obj = role_item_list_[_tmpi]
					obj.DeleteMe()
				}
				role_item_list_ = null
			}
		}

		this.UpdateView = (scmd?) => {
			this._lb_fast_record2.text=scmd.best_time == 0?"暂无记录":local_TimeUtil.timeConvert(scmd.best_time, "mm:ss");
			this._lb_my_record2.text=scmd.my_time == 0?"暂无记录":local_TimeUtil.timeConvert(scmd.my_time, "mm:ss");
			if (!role_item_list_) {
				role_item_list_ = []
			}

			for (let i = 0; i < 3; i++) {
				let item= role_item_list_[i]
				if (!item) {
					item = new DungeonDragonRecordItem(this._gp_role_con)
					item.Load()
					role_item_list_[i] = item
					item.SetPosition(DungeonDragonRecordView.RolePos[i][0], DungeonDragonRecordView.RolePos[i][1])
					// item.ExcuteCallback(() => {
					// 	let pos = DungeonDragonRecordView.RolePos[i]
					// })
				}
				let data = scmd.role_list[i]
				if (data) {
					item.SetData(data)
				} else {
					item.SetData({ none:true })
				}
			}
		}
	}

	public Open(...new_args) {

		let parms = new_args
		this.Local_Open(parms)
	}


	public DeleteMe() {

		super.DeleteMe()
	}


_img_bg:Laya.Image
_img_bg0:Laya.Image
_img_close:Laya.Image
_Group1:Laya.Box
_lb_wave1:Laya.Label
_lb_wave2:Laya.Label
_lb_wave3:Laya.Label
_Image2:Laya.Image
_Image3:Laya.Image
_Image4:Laya.Image
_gp_role_con:Laya.Box
_lb_fast_record:Laya.Label
_lb_fast_record2:Laya.Label
_lb_my_record:Laya.Label
_lb_my_record2:Laya.Label
public GetComponents() {
[
this._img_bg,
this._img_bg0,
this._img_close,
this._Group1,
this._lb_wave1,
this._lb_wave2,
this._lb_wave3,
this._Image2,
this._Image3,
this._Image4,
this._gp_role_con,
this._lb_fast_record,
this._lb_fast_record2,
this._lb_my_record,
this._lb_my_record2,
]
 = this.GetChildrenByNames([

"_img_bg",
"_img_bg0",
"_img_close",
"_Group1",
"_lb_wave1",
"_lb_wave2",
"_lb_wave3",
"_Image2",
"_Image3",
"_Image4",
"_gp_role_con",
"_lb_fast_record",
"_lb_fast_record2",
"_lb_my_record",
"_lb_my_record2",
])
}
}
 window["DungeonDragonRecordView"]= DungeonDragonRecordView