import { BaseView1 } from "../common/BaseView1"
import { Config } from "../common/Config"
import { Enum_UILayer, LayerManager } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { WordManager } from "../common/WordManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GuardModel } from "../commonModel/GuardModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { ErlangParser } from "../util/ErlangParser"
import { GameError } from "../util/GameError"
import { TimeUtil } from "../util/TimeUtil"
import { Util, SetSizeDeltaY, Trim } from "../util/Util"
import { Vector2 } from "../util/Vector2"
import { MainUIBuffItem } from "./MainUIBuffItem"
import { MainUIModel } from "../commonModel/MainUIModel"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { EventName } from "../common/EventName"
import { BossModel } from "../commonModel/BossModel"
import { EternityModel } from "../commonModel/EternityModel"
import { MaskModel } from "../commonModel/MaskModel"
import { GuildFightModel } from "../commonModel/GuildFightModel"
import { VipModel } from "../commonModel/VipModel"
import { SkillUIModel } from "../commonModel/SkillUIModel"
export class MainUIBuffView extends BaseView1 {

	buff_loop_mgr: LoopScrowViewMgr
	model: MainUIModel = MainUIModel.GetInstance()
	buff_list
	public constructor() {
		super()

		this.base_file = "mainUI"
		this.layout_file = "MainUIBuffView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.click_bg_toClose = true
		this.background_alpha = 0
		this.destroy_imm = true
		// this.show_open_movie = true
		this.need_loading_view = false

		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.destroy_callback = () => {
			this.Remove()
		}
	}

	LoadSuccess() {
		let liu_hai_height = Util.GetLiuhaiHeight()
		this.display_obj.y = 115 + liu_hai_height

		this.UpdatePos()
		this.InitEvent()
		// this.UpdateView()
		GoodsModel.GetInstance().Fire(GoodsModel.GET_GOODS_BUFF_LIST)
	}

	UpdateView() {
		let buff_list = this.model.buff_list
		if (!buff_list || buff_list.length == 0) {
			this.Close()
		}
		let height = buff_list.length * 95 + (buff_list.length - 1) * 3 + 80
		this.buff_list = buff_list
		// 98*6.5 + 80 最多显示6个半
		if (height < 715.5) {
			SetSizeDeltaY(this.display_obj, height)
			this._list_buff_con.elasticEnabled = false
		} else {
			SetSizeDeltaY(this.display_obj, 715.5)
			this._list_buff_con.elasticEnabled = true
		}

		if (this.use_delete_method) return
		this.CallLater(this.UpdateItem)
	}

	UpdateItem = () => {
		if (this.use_delete_method) return
		if (this.buff_loop_mgr) {
			this.buff_loop_mgr.replaceAll(this.buff_list)
		}
		else {
			this.buff_loop_mgr = new LoopScrowViewMgr()
			this.buff_loop_mgr.SetData(this._list_buff_con, MainUIBuffItem, this.buff_list, LoopScrCon.Vertical)
		}
	}

	InitEvent() {
		this.BindEvent(GlobalEventSystem, EventName.STATE_RESET_SIZE, (width, height) => {
			this.UpdatePos()
		})

		this.BindEvent(GlobalEventSystem, EventName.UPDATE_BUFF_DATA, () => {
			this.UpdateView()
		})
	}

	UpdatePos() {
		this.display_obj.x = LayerManager.GetInstance().stageWidth / 2 - 720 / 2 + 90
	}

	Remove() {
		if (this.buff_loop_mgr) {
			this.buff_loop_mgr.DeleteMe()
			this.buff_loop_mgr = null
		}
	}

	image1: Laya.Image
	image2: Laya.Image
	label1: Laya.Label
	_list_buff_con: Laya.List
	public GetComponents() {
		[
			this.image1,
			this.image2,
			this.label1,
			this._list_buff_con,
		]
			= this.GetChildrenByNames([

				"image1",
				"image2",
				"label1",
				"_list_buff_con",
			])
	}
}
window["MainUIBuffView"] = MainUIBuffView