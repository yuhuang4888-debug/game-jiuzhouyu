import { BaseItem1 } from "../common/BaseItem1"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { RankModel, RankModelEvent } from "../commonModel/RankModel"
import { TSCrackModel } from "../commonModel/TSCrackModel"
import { GameResPath } from "../util/GameResPath"
import { TSCrackLockServerItem } from "./TSCrackLockServerItem"
import { Config } from "../common/Config"

export class TSCrackLockItem extends BaseItem1 {
	_Image1: Laya.Image
	_img_bg: Laya.Image
	_lb_tips: Laya.Label
	_Label1: Laya.Label
	Content: Laya.List
	Scr_Scroller1
	item_loop_mgr
	preload_server_config
	ts_crack_model

	public constructor(parent?) {
		super(parent)
		this.base_file = "tsCrack"
		this.layout_file = "TSCrackLockItem"

		this.ts_crack_model = TSCrackModel.GetInstance()

		this.load_callback = () => {
			this.display_obj.y = 10
			this.LoadSuccess()
		}
	}

	public LoadSuccess() {
		// if (PlatformMgr.GetInstance().IsEyouEnPlatform()) {

		// 	this._lb_tips.size = 16

		// }

		ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("tsCrack", "uisksh_112"))
		ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIcon("tsCrack", "ui_kfjd_009"), true)


		this.UpdateView()

		this.InitEvent()

	}



	public InitEvent() {


		this.BindEvent(RankModel.GetInstance(), RankModelEvent.RANK_DATA_UPDATE, (data?) => {

			this.UpdateView()

		}

		)

	}



	public UpdateView() {


		let cfg = Config.PRELOAD_SERVER_CONFIG.config_chrono_rift_castle_kv

		let lv_cfg = cfg && cfg["need_world_lv"]

		let need_world_lv = lv_cfg && lv_cfg.value

		let server_data = this.ts_crack_model.GetServerData()

		let avg_wlv = 0

		if (server_data) {

			let count = server_data.server_list.length

			let total_wlv = 0

			for (let _tmpi in server_data.server_list) {
				var vo = server_data.server_list[_tmpi]

				total_wlv = total_wlv + vo.lv

			}

			avg_wlv = Math.floor(total_wlv / count)

			let level = need_world_lv > 370 && "神创" + (need_world_lv - 370) || need_world_lv

			let lv = avg_wlv > 370 && "神创" + (avg_wlv - 370) || avg_wlv

			// if (PlatformMgr.GetInstance().IsEyouThPlatform()) {

			// 	this._lb_tips.text = "Lv.โลกข้ามเซิร์ฟถึงLv." + level + "เปิดอย่างเป็นทางการ\nขณะนี้8เซิร์ฟข้ามเซิร์ฟLv.โลกเป็นLv." + lv + ""

			// } else {
			this._lb_tips.text = "跨服世界等级达到" + level + "级时正式开启\n当前8服跨服世界等级为" + lv + "级"

			//}





			if (this.item_loop_mgr) {

				this.item_loop_mgr.replaceAll(server_data.server_list)

			} else {
				this.item_loop_mgr = new LoopScrowViewMgr()

				this.item_loop_mgr.SetData(this.Content, TSCrackLockServerItem, server_data.server_list, LoopScrCon.Horizontal)

			}

		}

	}



	public DeleteMe() {


		if (this.item_loop_mgr) {

			this.item_loop_mgr.DeleteMe()

			this.item_loop_mgr = false

		}
		super.DeleteMe()

	}




	public GetComponents() {
		[
			this._Image1,
			this._img_bg,
			this._lb_tips,
			this._Label1,
			this.Content,
		]
			= this.GetChildrenByNames([

				"_Image1",
				"_img_bg",
				"_lb_tips",
				"_Label1",
				"Content",
			])
	}
}
window["TSCrackLockItem"] = TSCrackLockItem