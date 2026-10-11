import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { Util } from "../util/Util"
import { GoodsModel } from "../commonModel/GoodsModel"
import { GodCourtModel } from "../commonModel/GodCourtModel"
import { EquipmentItem } from "../common/EquipmentItem"
import { ResManager } from "../common/ResManager"

export class GodHouseRewardView extends BaseView1 {
	DesFunc
	InitView
	SetLvData
	rewardGp1
	rewardGp2
	cfg_reward

	public constructor() {
		super()
		this.base_file = "godCourt"
		this.layout_file = "GodHouseRewardView"
		this.layer_value = Enum_UILayer.Activity
		this.show_open_movie = true
		this.use_background = true
		this.click_bg_toClose = true
		this.destroy_imm = true
		this.is_center = true
		this.preload_server_config = {
			"config_god_house_reward":false
		}

		let rewardList1 = null
		let rewardList2 = null
		let model = GodCourtModel.GetInstance()

		this.load_callback = () => {
			this.cfg_reward = ResManager.GetInstance().GetGameConfigFromCache(this, "config_god_house_reward", false)
			this._Scroller1.hScrollBarSkin = ""
			this._Scroller2.hScrollBarSkin = ""
			this.InitView()
		}

		this.destroy_callback = () => {
			this.DesFunc()
		}

		this.InitView = () => {
			Util.AddClickEvent(this._btn_close, () => {
				this.Close()
			}, this, true)

			this.BindEvent(model, GodCourtModel.UPDATE_COLOR, () => {
				this.SetLvData()
			})
			this.SetLvData()
		}

		this.SetLvData = () => {
			let houseData = model.houseData
			let rewardCfg = this.cfg_reward
			if (houseData) {
				let sum_num = houseData.sum_num || 1
				let curReward = null
				let nextReward = null
				let nextNum = 0
				if (rewardCfg) {
					let find = false
					for (let key in rewardCfg) {
						let vo = rewardCfg[key]
						if (sum_num >= vo.down_num && sum_num <= vo.up_num) {
							find = true
							curReward = JSON.parse(vo.reweard_pool)
							if (!rewardList1) {
								rewardList1 = []
							}
							let i = 0
							do {
								let rewardVo = curReward[i]
								let item = rewardList1[i]
								if (!item) {
									item = new EquipmentItem(this.Content1)
									item.Load()
									rewardList1[i] = item
									item.SetItemSize(90, 90)
								}
								let [type_id, bind] = GoodsModel.GetInstance().GetMappingTypeId(rewardVo[0], rewardVo[1])
								item.SetData(type_id, rewardVo[2])
								i = i + 1
							} while ((i < curReward.length))
							let next_cfg = rewardCfg[Number(key) + 1]
							if (next_cfg) {
								nextReward = JSON.parse(next_cfg.reweard_pool)
								nextNum = next_cfg.down_num
								if (!rewardList2) {
									rewardList2 = []
								}
								let i = 0
								do {
									let rewardVo = nextReward[i]
									let item = rewardList2[i]
									if (!item) {
										item = new EquipmentItem(this.Content)
										item.Load()
										rewardList2[i] = item
										item.SetItemSize(90, 90)
									}
									let [type_id, bind] = GoodsModel.GetInstance().GetMappingTypeId(rewardVo[0], rewardVo[1])
									item.SetData(type_id, rewardVo[2])
									i = i + 1
								} while ((i < nextReward.length))
							}
							break
						}
					}
				}
				this.lvLb.text = "Lv." + houseData.reward_lv
				this.countLb.text = houseData.sum_num + "/" + nextNum + "(勾玉提升次数)"
				this.expImg.width = Math.min(1, sum_num / nextNum) * 410
			}
		}

		this.DesFunc = () => {
			if (rewardList1) {
				for (let _tmpi in rewardList1) {
					let vo = rewardList1[_tmpi]
					vo.DeleteMe()
				}
				rewardList1 = null
			}
			if (rewardList2) {
				for (let _tmpi in rewardList2) {
					let vo = rewardList2[_tmpi]
					vo.DeleteMe()
				}
				rewardList2 = null
			}
		}
	}

	_img_bg1: Laya.Image
	_btn_close: Laya.Image
	_img_title: Laya.Image
	_lb_title: Laya.Label
	_img_bg2: Laya.Image
	_img_bg3: Laya.Image
	_img_title1: Laya.Image
	_lb_title1: Laya.Label
	_img_title2: Laya.Image
	_lb_title2: Laya.Label
	_Scroller1: Laya.Panel
	Content1: Laya.HBox
	_Scroller2: Laya.Panel
	Content: Laya.HBox
	_img_proBg: Laya.Image
	expImg: Laya.Image
	countLb: Laya.Label
	lvLb: Laya.Label
	_lb_tips: Laya.Label
	public GetComponents() {
		[
			this._img_bg1,
			this._btn_close,
			this._img_title,
			this._lb_title,
			this._img_bg2,
			this._img_bg3,
			this._img_title1,
			this._lb_title1,
			this._img_title2,
			this._lb_title2,
			this._Scroller1,
			this.Content1,
			this._Scroller2,
			this.Content,
			this._img_proBg,
			this.expImg,
			this.countLb,
			this.lvLb,
			this._lb_tips,
		]
			= this.GetChildrenByNames([
				"_img_bg1",
				"_btn_close",
				"_img_title",
				"_lb_title",
				"_img_bg2",
				"_img_bg3",
				"_img_title1",
				"_lb_title1",
				"_img_title2",
				"_lb_title2",
				"_Scroller1",
				"Content1",
				"_Scroller2",
				"Content",
				"_img_proBg",
				"expImg",
				"countLb",
				"lvLb",
				"_lb_tips",
			])
	}
}
window["GodHouseRewardView"] = GodHouseRewardView