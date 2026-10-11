import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { LuaSoundManager } from "../common/SoundManager"
import { BossModel } from "../commonModel/BossModel"
import { PlatformManager } from "../PlatformManager"
import { Util } from "../util/Util"
import { BossDropRecordItem } from "./BossDropRecordItem"

export class BossDropRecordView extends BaseView1 {
	model:BossModel
	need_refresh
	boss_type
	item_list
	item_loop_mgr:LoopScrowViewMgr
	change

	public constructor() {
		super()

		this.base_file = "boss"
		this.layout_file = "BossDropRecordView"
		this.layer_value = Enum_UILayer.Activity

		this.need_refresh = false
		this.change = false
		this.change_scene_close = true
		this.click_bg_toClose = true
		this.use_background = true
		this.is_center = true
		this.destroy_imm = true
		this.show_open_movie = true
		
		this.model = BossModel.GetInstance()

		this.load_callback = () => {
			this.InitEvent()
			this.Init()
		}

		this.close_callback = () => {
			this.Remove()
		}
	}


	Remove = () => {
		this.need_refresh = false
		if (this.item_loop_mgr) {
			this.item_loop_mgr.DeleteMe()
			this.item_loop_mgr = undefined
		}
	}

	InitEvent = () => {
		Util.AddClickEvent(this._img_close, () => {
			this.Close()
		}
			, this, true, null, null, null, null, LuaSoundManager.SOUND_UI.CLOSE)
		this.BindEvent(this.model, BossModel.DROPRECORDDATA_RETURN, () => {
			this.InitItem()
		}
		)
	}

	Init = () => {
		if (!this.need_refresh) 
			return

		if (this.boss_type == BossModel.BossType.eudaemon) {
			this.model.RequestEudeamonDrop()
		} else if (this.boss_type == BossModel.BossType.domain) {
			this.model.RequestDomainBossDrop()
		} else if(this.boss_type == BossModel.BossType.mystery){
			this.model.RequestMysteryBossDrop()
		}else {
			this.model.RequestDropRecordData(this.change)
		}
	}

	InitItem = () => {
		let data = this.model.DropRecordData().drop_log
		data = this.model.SortDopLog(data)
		this._gp_null.visible = data.length == 0

		

		if (this.item_loop_mgr) {
			this.item_loop_mgr.replaceAll(data)
		} else {
			this.item_loop_mgr = new LoopScrowViewMgr()
			this.item_loop_mgr.SetData(this._list_item, BossDropRecordItem, data,LoopScrCon.Vertical , null)
		}
	}


	public Open(boss_type?) {
		if (this.boss_type != boss_type) {
			this.change = true
		}
		this.boss_type = boss_type
		if (this.is_loaded) {
			this.Init()
		} else {
			this.need_refresh = true
		}
		super.Open()
	}

_img_bg:Laya.Image
_img_bg2:Laya.Image
_img_bg3:Laya.Image
_list_item:Laya.List
_box_con:Laya.Box
_img_bg4:Laya.Image
_lb_title2:Laya.Label
_lb_title3:Laya.Label
_lb_title4:Laya.Label
_lb_title5:Laya.Label
_img_close:Laya.Image
_gp_null:Laya.Box
_lb_null:Laya.Label
_lb_title:Laya.Label
public GetComponents() {
[
this._img_bg,
this._img_bg2,
this._img_bg3,
this._list_item,
this._box_con,
this._img_bg4,
this._lb_title2,
this._lb_title3,
this._lb_title4,
this._lb_title5,
this._img_close,
this._gp_null,
this._lb_null,
this._lb_title,
]
 = this.GetChildrenByNames([

"_img_bg",
"_img_bg2",
"_img_bg3",
"_list_item",
"_box_con",
"_img_bg4",
"_lb_title2",
"_lb_title3",
"_lb_title4",
"_lb_title5",
"_img_close",
"_gp_null",
"_lb_null",
"_lb_title",
])
}
}
window["BossDropRecordView"] = BossDropRecordView