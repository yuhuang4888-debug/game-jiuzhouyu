import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { ResManager } from "../common/ResManager"
import { BaseDungeonModel, DUN_TYPE } from "../commonModel/BaseDungeonModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { ColorUtil } from "../util/ColorUtil"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest } from "../util/Util"

export class DungeonRuneUnlockView extends BaseView1 {


	model
	scmd61116
	close_time
	time_id

	left_time = 3
	public constructor() {
		super()
		this.base_file = "dungeonRune"
		this.layout_file = "DungeonRuneUnlockView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.click_bg_toClose = true
		this.destroy_imm = true
		this.is_center = true


		this.model = BaseDungeonModel.GetInstance()
		this.load_callback = () => {
			this.LoadSuccess()
		}

		this.preload_server_config = {
			config_dungeon_rune_lv_data: false
		}

		this.open_callback = () => {
			this.UpdateView()
		}

		this.close_callback = () => {
			this.CancelTime()
			// if (this.result_data) {
			// 	this.model.SetDungeonResultInfo(this.result_data)
			// 	//this.model:TryAddResultDrop()
			// 	this.model.Fire(BaseDungeonModel.OPEN_DENGEON_RESULT_VIEW)
			// 	this.result_data = null
			// }
		}
	}

	public LoadSuccess = () => {
		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("dungeonRune", "ui_copy_78"))

	}

	public UpdateView = () => {
		let floor = this.scmd61116.level
		let dungeon_rune_lv_data_cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_dungeon_rune_lv_data", false)
		let cfg_data = dungeon_rune_lv_data_cfg[floor]
		if (cfg_data && Number(cfg_data.unlock_rune) != 0) {
			let goods_vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(cfg_data.unlock_rune)
			if (goods_vo) {
				ResManager.GetInstance().SetImageSprite(this, this._img_rune_bg, "common_asset", "com_goods_plate_" + goods_vo.color)
				ResManager.GetInstance().SetOutsideImageSprite(this, this._img_rune_icon, GameResPath.GetGoodsIconPath(goods_vo.goods_icon))
				let color = ColorUtil.GetColorLight(goods_vo.color)
				this._lb_rune_name.text = goods_vo.goods_name
				this._lb_rune_name.color = ColorUtil.TryParseHtmlString(color)
			}
		}
	}

	public StartTime() {
		this.CancelTime()
		this.close_time = this.left_time + TimeUtil.getServerTime()
		this.time_id = GlobalTimerQuest.AddPeriodQuest(this.OnTime, 1)
		this.OnTime()
	}

	public OnTime = () => {
		let left_time = this.close_time - TimeUtil.getServerTime()
		if (left_time < 0) {
			this.CancelTime()
			this.Close()
			return
		}
	}

	public CancelTime() {
		if (this.time_id) {
			GlobalTimerQuest.CancelQuest(this.time_id)
			this.time_id = null
		}
	}

	public Open(...new_args) {
		let parms = new_args
		if (parms) {
			this.scmd61116 = parms[0]
		}
		super.Open()
	}

	_img_bg: Laya.Image
	_img_bg2: Laya.Image
	_img_bg3: Laya.Image
	_img_bg4: Laya.Image
	_img_rune_bg: Laya.Image
	_img_rune_icon: Laya.Image
	_lb_rune_name: Laya.Label
	_lb_tips: Laya.Label
	public GetComponents() {
		[
			this._img_bg,
			this._img_bg2,
			this._img_bg3,
			this._img_bg4,
			this._img_rune_bg,
			this._img_rune_icon,
			this._lb_rune_name,
			this._lb_tips,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_bg2",
				"_img_bg3",
				"_img_bg4",
				"_img_rune_bg",
				"_img_rune_icon",
				"_lb_rune_name",
				"_lb_tips",
			])
	}
}
window["DungeonRuneUnlockView"] = DungeonRuneUnlockView