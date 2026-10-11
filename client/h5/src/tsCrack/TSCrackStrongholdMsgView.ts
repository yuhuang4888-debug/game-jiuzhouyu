import { BaseView1 } from "../common/BaseView1"
import { CommonRewardItem } from "../common/CommonRewardItem"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { TSCrackModel } from "../commonModel/TSCrackModel"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { ErlangParser } from "../util/ErlangParser"
import { GameResPath } from "../util/GameResPath"
import { HtmlColorTxt, Util } from "../util/Util"
import { TSCrackStrongholdMsgItem } from "./TSCrackStrongholdMsgItem"

export class TSCrackStrongholdMsgView extends BaseView1 {
	_Image1: Laya.Image
	_Image2: Laya.Image
	_Image3: Laya.Image
	_img_close: Laya.Image
	_Image4: Laya.Image
	_Image5: Laya.Image
	_Image6: Laya.Image
	_img_bg: Laya.Image
	_img_bg0: Laya.Image
	_Image7: Laya.Image
	_img_icon: Laya.Image
	_Image8: Laya.Image
	_Label1: Laya.Label
	_Label2: Laya.Label
	_Label3: Laya.Label
	_Label4: Laya.Label
	_Label5: Laya.Label
	_Label6: Laya.Label
	_lb_server_none: Laya.Label
	_lb_role_none: Laya.Label
	_gp_get: Laya.Box
	_Image9: Laya.Image
	_Label7: Laya.Label
	_gp_go: Laya.Box
	_Image10: Laya.Image
	_lb_go_desc: Laya.Label
	_lb_name: Laya.Label
	_lb_cond: Laya.HTMLDivElement
	_Label8: Laya.Label
	Content: Laya.List
	Content1: Laya.List
	Content11: Laya.List
	Emp_gp_get
	Emp_gp_go
	Scr_Scroller1
	Scr_Scroller2
	Scr_Scroller3
	array_reward
	array_role
	array_server
	reward_loop_mgr
	role_loop_mgr
	server_loop_mgr
	stronghold_id
	ts_crack_model






	public constructor() {
		super()


		this.base_file = "tsCrack"
		this.layout_file = "TSCrackStrongholdMsgView"
		this.layer_value = Enum_UILayer.Activity
		this.destroy_imm = true
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.show_open_movie = true
		this.change_scene_close = true

		this.ts_crack_model = TSCrackModel.GetInstance()

		this.stronghold_id = null

		this.array_server = null
		this.array_role = null
		this.array_reward = null
		this.preload_server_config = {
			"config_chrono_rift_castle_reward": false
		}
		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.destroy_callback = () => {
			if (this.server_loop_mgr) {
				this.server_loop_mgr.DeleteMe()
				this.server_loop_mgr = false
			}

			if (this.role_loop_mgr) {
				this.role_loop_mgr.DeleteMe()
				this.role_loop_mgr = false
			}

			if (this.reward_loop_mgr) {
				this.reward_loop_mgr.DeleteMe()
				this.reward_loop_mgr = false
			}
			this.ts_crack_model.select_season_id = 0
		}
	}

	public LoadSuccess() {

		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("tsCrack", "uisksh_109"))
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg0, GameResPath.GetIcon("tsCrack", "uisksh_109"))
		

		this.UpdateView()
		this.UpdateGoBtnState()
		this.InitEvent()
	}

	public InitEvent() {


		this.BindEvent(this.ts_crack_model, TSCrackModel.UPDATE_STRONGHOLD_DATA, () => {
			this.UpdateView()
		})

		this.BindEvent(this.ts_crack_model, TSCrackModel.UPDATE_OWNER_ID, () => {
			this.UpdateGoBtnState()
		})

		Util.AddClickEvent(this._img_close, () => {
			this.Close()
		}, this, true)

		Util.AddClickEvent(this._gp_get, () => {
			this.Close()
			GlobalEventSystem.Fire(EventName.OPEN_VIEW, "TSCrackScrambleView")
		}, this, true)

		Util.AddClickEvent(this._gp_go, () => {
			let data = this.ts_crack_model.GetStrongholdDataById(this.stronghold_id)
			if (data) {
				if (data.stronghold_id == this.ts_crack_model.GetOwnerPosId()) {
					Message.show("当前已位于该点")
				} else if (this.ts_crack_model.CanMove(this.ts_crack_model.GetOwnerPosId(), data.stronghold_id)) {
					this.ts_crack_model.SetLastStrongholdId(this.ts_crack_model.GetOwnerPosId())
					GlobalEventSystem.Fire(EventName.OPEN_VIEW, "TSCrackTeleportView", data.stronghold_id)
				} else {
					Message.show("当前暂无可前往的通路")
				}
			}
		}, this, true)
	}

	public UpdateView() {

		let data = this.ts_crack_model.GetStrongholdDataById(this.stronghold_id)
		if (data) {
			// this.array_server.replaceAll(data.server_list)
			if (this.server_loop_mgr) {
				this.server_loop_mgr.replaceAll(data.server_list)
			} else {
				this.server_loop_mgr = new LoopScrowViewMgr()
				this.server_loop_mgr.SetData(this.Content, TSCrackStrongholdMsgItem, data.server_list, LoopScrCon.Vertical)
			}
			this._lb_server_none.visible = data.server_list.length == 0


			// this.array_role.replaceAll(data.role_list)
			if (this.role_loop_mgr) {
				this.role_loop_mgr.replaceAll(data.role_list)
			} else {
				this.role_loop_mgr = new LoopScrowViewMgr()
				this.role_loop_mgr.SetData(this.Content1, TSCrackStrongholdMsgItem, data.role_list, LoopScrCon.Vertical)
			}
			this._lb_role_none.visible = data.role_list.length == 0

			let chrono_rift_castle_reward_cfgs = ResManager.GetInstance().GetGameConfigFromCache(this, "config_chrono_rift_castle_reward", false)
			let chrono_rift_castle_reward_cfg = chrono_rift_castle_reward_cfgs && chrono_rift_castle_reward_cfgs[data.lv]
			let reward_list = JSON.parse(chrono_rift_castle_reward_cfg.reward)
			let list = []
			for (let _tmpi in reward_list) {
				var vo = reward_list[_tmpi]
				table.insert(list, { size: 75, vo: { style: vo[0], typeId: vo[1], count: vo[2] } })
			}

			// this.array_reward.replaceAll(list)
			if (this.reward_loop_mgr) {
				this.reward_loop_mgr.replaceAll(list)
			} else {
				this.reward_loop_mgr = new LoopScrowViewMgr()
				this.reward_loop_mgr.SetData(this.Content11, CommonRewardItem, list, LoopScrCon.Horizontal)
			}

			this._lb_name.text = data.stronghold_name
			let index = this.ts_crack_model.GetIndexByServerNum(data.server_num)
			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_icon, GameResPath.GetTsPath("build", data.icon + "0"),true)
			ResManager.GetInstance().SetOutsideImageSprite(this, this._Image8, GameResPath.GetTsPath("floor", "floor_" + index))
			this._lb_cond.style.fontSize = 20
			this._lb_cond.style.color = "#5a1c20"
			this._lb_cond.style.wordWrap = false
			this._lb_cond.innerHTML = Util.StrToHTML("占领所需:	" + HtmlColorTxt(data.need_value, "'#089f41'"))
		}
	}

	public UpdateGoBtnState() {

		let data = this.ts_crack_model.GetStrongholdDataById(this.stronghold_id)
		if (data && data.stronghold_id == this.ts_crack_model.GetOwnerPosId()) {
			// Util.SetImageGray(this._gp_go, true)
			this._lb_go_desc.text = "已位于该点"
		} else {
			// Util.SetImageGray(this._gp_go, false)
			this._lb_go_desc.text = "传送"
		}
	}

	public Open(...new_args) {

		let parms = new_args
		this.stronghold_id = parms[0]
		this.ts_crack_model.select_season_id = this.stronghold_id
		super.Open()
	}


	public GetComponents() {
		[
			this._Image1,
			this._Image2,
			this._Image3,
			this._img_close,
			this._Image4,
			this._Image5,
			this._Image6,
			this._img_bg,
			this._img_bg0,
			this._Image7,
			this._img_icon,
			this._Image8,
			this._Label1,
			this._Label2,
			this._Label3,
			this._Label4,
			this._Label5,
			this._Label6,
			this._lb_server_none,
			this._lb_role_none,
			this._gp_get,
			this._Image9,
			this._Label7,
			this._gp_go,
			this._Image10,
			this._lb_go_desc,
			this._lb_name,
			this._lb_cond,
			this._Label8,
			this.Content,
			this.Content1,
			this.Content11,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_Image2",
				"_Image3",
				"_img_close",
				"_Image4",
				"_Image5",
				"_Image6",
				"_img_bg",
				"_img_bg0",
				"_Image7",
				"_img_icon",
				"_Image8",
				"_Label1",
				"_Label2",
				"_Label3",
				"_Label4",
				"_Label5",
				"_Label6",
				"_lb_server_none",
				"_lb_role_none",
				"_gp_get",
				"_Image9",
				"_Label7",
				"_gp_go",
				"_Image10",
				"_lb_go_desc",
				"_lb_name",
				"_lb_cond",
				"_Label8",
				"Content",
				"Content1",
				"Content11",
			])
	}
}
window["TSCrackStrongholdMsgView"] = TSCrackStrongholdMsgView