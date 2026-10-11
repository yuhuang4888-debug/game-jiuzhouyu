import { BaseView1, OpenMode } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { BaseDungeonModel } from "../commonModel/BaseDungeonModel"
import { RoleManager } from "../commonModel/RoleManager"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { Util } from "../util/Util"
import { DungeonPolarRankItem } from "./DungeonPolarRankItem"
import { DungeonPolarRwRenderItem } from "./DungeonPolarRwRenderItem"

export class DungeonPolarRankView extends BaseView1 {
	InitEvent
	LoadSuccess
	_rank_list
	background_alpha
	click_bg_toClose
	destroy_imm
	initRank
	is_center
	loop_mgr
	mask_corner
	open_callback
	open_mode
	use_background
	_dun_id
	public constructor() {
		super()

		this.base_file = "dungeonPolar"
		this.layout_file = "DungeonPolarRankView"
		this.layer_value = Enum_UILayer.Activity
		this.open_mode = OpenMode.OpenToggle
		this.destroy_imm = true
		this.use_background = true
		this.background_alpha = 0
		this.click_bg_toClose = true
		this.preload_server_config = { "config_week_dungeon_rank": false }
		this.is_center = true
		let _model = BaseDungeonModel.GetInstance()
		this.load_callback = () => {

			this.InitEvent()
			this.LoadSuccess()
		}

		this.open_callback = () => {
			if (this.is_loaded) {
				this.initRank()
			}
			_model.Fire(BaseDungeonModel.SCMD_REQUEST, 50802, this._dun_id, 1, _model.polarRankMax)
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._close, () => {
				this.Close()
			}
				, this, true)
			this.BindEvent(_model, BaseDungeonModel.POLAR_RANK_DATA_RETURN, () => {
				this.initRank()
			}
			)
		}

		this.LoadSuccess = () => {
			this.initRank()
		}

		this.initRank = () => {
			if (!this.is_loaded) {
				return
			}
			let data = _model.getPolarRank(this._dun_id)
			if (!data) {
				return
			}
			let list = []
			let i = 0
			if (i < _model.polarRankMax) {
				do {
					let info = data.rank_list[i]
					if (info) {
						info["team_dun_id"] = data.team_dun_id
						info["mask_corner"] = this.mask_corner
						table.insert(list, info)
					} else {
						info = []
						info["is_null"] = true
						info["team_dun_id"] = data.team_dun_id
						info["mask_corner"] = this.mask_corner
						table.insert(list, info)
					}
					i = i + 1
				} while ((i < _model.polarRankMax)
				)
			}

			if (!this.loop_mgr) {
				this.loop_mgr = new LoopScrowViewMgr()
				this.loop_mgr.SetData(this.Content, DungeonPolarRankItem, list, LoopScrCon.Vertical)
			} else {
				this.loop_mgr.replaceAll(list)
			}
			this._lb_rank.text = (!data || !data.self_rank||data.self_rank == 0) ? "未上榜" : "第" + data.self_rank + "名"
			this._lb_time.text = (!data || !data.self_rank||data.self_rank == 0) ? "暂未通关" : TimeUtil.convertTime(data.self_pass_time) + ""
			this._lb_name.text = RoleManager.GetInstance().GetMainRoleVo().name




			let list_test = []
			for (let p = 0; p < 3; p++) {
				table.insert(list_test, {
					"0": 0,
					"1": 7305002,
					"2": 1
				})
			}


		}


	}

	public DeleteMe() {

		if (this.loop_mgr) {
			this.loop_mgr.DeleteMe()
			this.loop_mgr = null
		}

		super.DeleteMe()
	}

	public Open(...new_args) {

		let parms = new_args
		this._dun_id = parms[0]
		super.Open()
	}


_Image1:Laya.Image
_Image4:Laya.Image
_gp_rank:Laya.Box
_Group2:Laya.Box
_Image5:Laya.Image
_Label1:Laya.Label
_Image6:Laya.Image
_Label2:Laya.Label
_Image7:Laya.Image
_Label3:Laya.Label
_Image8:Laya.Image
_Label4:Laya.Label
Content:Laya.List
_Image9:Laya.Image
_Group3:Laya.Box
_Image10:Laya.Image
_Image11:Laya.Image
_lb_rank:Laya.Label
_lb_name:Laya.Label
_lb_time:Laya.Label
_Label5:Laya.Label
_Label6:Laya.Label
_close:Laya.Image
img_title:Laya.Image
lb_title:Laya.Label
public GetComponents() {
[
this._Image1,
this._Image4,
this._gp_rank,
this._Group2,
this._Image5,
this._Label1,
this._Image6,
this._Label2,
this._Image7,
this._Label3,
this._Image8,
this._Label4,
this.Content,
this._Image9,
this._Group3,
this._Image10,
this._Image11,
this._lb_rank,
this._lb_name,
this._lb_time,
this._Label5,
this._Label6,
this._close,
this.img_title,
this.lb_title,
]
 = this.GetChildrenByNames([

"_Image1",
"_Image4",
"_gp_rank",
"_Group2",
"_Image5",
"_Label1",
"_Image6",
"_Label2",
"_Image7",
"_Label3",
"_Image8",
"_Label4",
"Content",
"_Image9",
"_Group3",
"_Image10",
"_Image11",
"_lb_rank",
"_lb_name",
"_lb_time",
"_Label5",
"_Label6",
"_close",
"img_title",
"lb_title",
])
}
}
 window["DungeonPolarRankView"]= DungeonPolarRankView