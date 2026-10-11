import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { BaseDungeonModel, DUN_TYPE } from "../commonModel/BaseDungeonModel"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { DungeonRuneTargetItem } from "./DungeonRuneTargetItem"

export class DungeonRuneTargetView extends BaseView1 {

	item_loop_mgr
	model

	public constructor() {
		super()
		this.base_file = "dungeonRune"
		this.layout_file = "DungeonRuneTargetView"
		this.layer_value = Enum_UILayer.Activity
		this.use_background = true
		this.click_bg_toClose = true
		this.is_center = true

		this.model = BaseDungeonModel.GetInstance()
		
		this.preload_server_config = {
			config_dun_reward: false
		}

		this.load_callback = () => {
			// if (PlatformManager.IsEyouThPlatform() ) {
			// 	// SetSizeDeltaY(this.Text,50)
			//     this.Text.y = 50
			// }
			this.LoadSuccess()
		}

		this.open_callback = () =>{
			if(this._list_item.scrollBar)
				this._list_item.scrollBar.value = 0
			this.InitItem()
        }
        this.close_callback = () =>{
            
        }

		this.destroy_callback = () => {
			this.Remove()
		}
	}

	public InitEvent = () => {
		Util.AddClickEvent(this._img_close, () => {
			this.Close()
		}, this, true)

		Util.AddClickEvent(this._gp_get, () => {
			this.model.RuneRewardOneKey()
		}, this, true)

		this.BindEvent(this.model, BaseDungeonModel.CHANGE_RUNE_DUN_REWARD, () => {
			this.InitItem()
		})
	}

	public LoadSuccess() {
		this._img_title_bg.skin = GameResPath.GetIcon("common2", "com_title_bg_1")
		// ResManager.GetInstance().SetOutsideImageSprite(this, this._img_title_bg, GameResPath.GetIcon("common2", "com_title_bg_1"))
		this.InitEvent()
	}

	public InitItem() {
		let config_dun_reward = ResManager.GetInstance().GetGameConfigFromCache(this, "config_dun_reward", false)
		let data = this.model.GetDunReward(DUN_TYPE.Rune, config_dun_reward)
		table.sort(data, (a?, b?) => {
			let aIndex = a.dun_id
			let bIndex = b.dun_id
			let adata = this.model.GetRuneRewardData(a.dun_id)
			if (adata && adata.reward_status == 1) {
				aIndex = aIndex + 200
			}
			let bdata = this.model.GetRuneRewardData(b.dun_id)
			if (bdata && bdata.reward_status == 1) {
				bIndex = bIndex + 200
			}
			return aIndex < bIndex
		})

		if (!this.item_loop_mgr) {
			this.item_loop_mgr = new LoopScrowViewMgr()
		}
		this.item_loop_mgr.SetData(this._list_item, DungeonRuneTargetItem, data, LoopScrCon.Vertical)
	}


	public Remove() {

		if (this.item_loop_mgr) {
			this.item_loop_mgr.DeleteMe()
			this.item_loop_mgr = null
		}
	}

	_img_bg: Laya.Image
	_img_title_bg: Laya.Image
	_img_bg2: Laya.Image
	_lb_title: Laya.Label
	_list_item: Laya.List
	_img_close: Laya.Image
	_gp_get: Laya.Box
	_img_get: Laya.Image
	_lb_get: Laya.Label
	public GetComponents() {
		[
			this._img_bg,
			this._img_title_bg,
			this._img_bg2,
			this._lb_title,
			this._list_item,
			this._img_close,
			this._gp_get,
			this._img_get,
			this._lb_get,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_title_bg",
				"_img_bg2",
				"_lb_title",
				"_list_item",
				"_img_close",
				"_gp_get",
				"_img_get",
				"_lb_get",
			])
	}
}
window["DungeonRuneTargetView"] = DungeonRuneTargetView