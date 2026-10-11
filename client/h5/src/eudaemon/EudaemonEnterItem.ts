import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Config } from "../common/Config"
import { ResManager } from "../common/ResManager"
import { BossModel } from "../commonModel/BossModel"
import { ColorUtil } from "../util/ColorUtil"
import { GameResPath } from "../util/GameResPath"
import { TimeUtil } from "../util/TimeUtil"
import { GlobalTimerQuest, Util } from "../util/Util"

export class EudaemonEnterItem extends BaseItemRenderer {

	end_time
	call_back
	index
	need_refresh_data
	select_cache
	vo
	tims_id_
	boss_model
	WIDTH = 351
	HEIGT = 104
	public constructor(parent?) {
		super()
		this.base_file = "eudaemon"
		this.layout_file = "EudaemonEnterItem"
		this.boss_model = BossModel.GetInstance()
		this.load_callback = () => {
			this._img_shop_red.visible = false
			this.LoadSuccess()


			Util.AddClickEvent(this._img_attention, () => {
				if (this.data) {
					let state = this.data.is_remind ? 0 : 1
					if (this.data.boss_type == BossModel.BossType.holy_wuxian)
						this.boss_model.Fire(BossModel.SCMD_REQUEST, 46007, this.data.boss_type, this.data.boss_id, state, 0)
					else
						this.boss_model.Fire(BossModel.SCMD_REQUEST, 47005, this.data.boss_type - BossModel.cross_boss_base_index, this.data.boss_id, state)
				}
			}, this, true)


			this.BindEvent(this.boss_model, BossModel.UPDATE_BOSS_INFO, (boss_type?) => {
				if (!this.data) return
				if (boss_type == this.data.boss_type) {
					let boss_info = this.boss_model.GetBossInfo(this.data.boss_type, this.data.boss_id)
					if (boss_info) {
						this.data = boss_info
						this.dataChanged()
					}
				}
			}

			)


			this.BindEvent(this.boss_model, BossModel.BOSS_EUDA_REMIAN_UPDATE, (scmd?) => {
				if (!this.data) return
				let boss_info = this.boss_model.GetBossInfo(scmd.boss_type, scmd.boss_id)
				if (boss_info&&this.data.boss_id==boss_info.boss_id) {
					this.data = boss_info
					this.dataChanged()
				}
			})

			Util.AddClickEvent(this._img_bg, () => {
				this.boss_model.Fire(BossModel.BOSS_EUDA_UPDATE_BOSS_ROOM, this.index)
			}, this)

		}

		this.Load()
	}

	public OnTime = () => {
		let left_time = this.end_time - TimeUtil.getServerTime()
		if (left_time < 0) {
			this.CancelTime()
			this.UpdateLiveState(true)
			return
		}

		this._lb_time.text = TimeUtil.convertTime(left_time)
	}


	protected dataChanged() {
		if (!super.dataChanged()) return
		this.UpdateView()
		this._img_select.visible = this.selected
	}



	private UpdateLiveState(bool) {
		if (bool) {
			this._lb_time.visible = false
			ResManager.GetInstance().SetImageSprite(this, this._img_active, "eudaemon", "ui_kaf_hy001aa")
		} else {
			this._lb_time.visible = true
			ResManager.GetInstance().SetImageSprite(this, this._img_active, "eudaemon", "ui_kaf_hy001bb")
		}
	}

	private UpdateView() {

		this.CancelTime()
		if (this.data) {
			let bool = this.data.reborn_time == 0 || this.data.reborn_time < TimeUtil.getServerTime()

			this.UpdateLiveState(bool)

			if (!bool) {
				this.StartTime(this.data.reborn_time)
			}

			let mon_cfg = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, this.data.boss_id, false)
			if (mon_cfg) {
				this._lb_name.text = `LV.${mon_cfg.lv} ${mon_cfg.name}`
				ResManager.GetInstance().SetOutsideImageSprite(this, this._img_icon, GameResPath.GetMonsterBigHeadPath(mon_cfg.icon))
			}


			let is_remind = this.data.is_remind

			//是否有奖励次数
			if (this.data.layer == 0) {
				this._img_shop_red.visible = BossModel.GetInstance().CheckBossRemainState(this.data)
			} else {
				let cross_server_boss_info = BossModel.GetInstance().GetBossTypeInfo(BossModel.BossType.holy)
				let left_time = cross_server_boss_info.max_tired - cross_server_boss_info.tired
				this._img_shop_red.visible = BossModel.GetInstance().CheckBossRemainState(this.data) && left_time > 0
			}


			if (is_remind) {
				this._img_attention.width = 58
				this._img_attention.height = 112
				ResManager.GetInstance().SetImageSprite(this, this._img_attention, "eudaemon", "ui_kfa_007a")
				this._lb_attention.text = "已关注"
				this._lb_attention.color = "#a51c1c"
				this._lb_attention.stroke = 2
			}
			else {
				this._img_attention.width = 42
				this._img_attention.height = 98
				ResManager.GetInstance().SetImageSprite(this, this._img_attention, "eudaemon", "ui_kfa_008")
				this._lb_attention.color = "#ffffff"
				this._lb_attention.text = "未关注"
				this._lb_attention.stroke = 0
			}
		}
	}

	private StartTime(end_time?) {

		this.end_time = end_time
		this.tims_id_ = GlobalTimerQuest.AddPeriodQuest(this.OnTime, 1, -1)

		this.OnTime()
	}

	private CancelTime() {

		if (this.tims_id_) {
			GlobalTimerQuest.CancelQuest(this.tims_id_)
			this.tims_id_ = null
		}
	}

	private LoadSuccess() {
		Util.AddClickEvent(this._img_bg, () => {
			if (this.call_back) {
				this.call_back(this.index)
			}
		}, this)
	}

	public DeleteMe() {
		this.CancelTime()
		super.DeleteMe()
	}


	_img_bg: Laya.Image
	_box_att: Laya.Box
	_img_attention: Laya.Image
	_lb_attention: Laya.Label
	_img_bg3: Laya.Image
	_img_icon: Laya.Image
	_img_bg4: Laya.Image
	_lb_name: Laya.Label
	_img_select: Laya.Image
	_img_active: Laya.Image
	_lb_time: Laya.Label
	_img_shop_red: Laya.Image
	public GetComponents() {
		[
			this._img_bg,
			this._box_att,
			this._img_attention,
			this._lb_attention,
			this._img_bg3,
			this._img_icon,
			this._img_bg4,
			this._lb_name,
			this._img_select,
			this._img_active,
			this._lb_time,
			this._img_shop_red,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_box_att",
				"_img_attention",
				"_lb_attention",
				"_img_bg3",
				"_img_icon",
				"_img_bg4",
				"_lb_name",
				"_img_select",
				"_img_active",
				"_lb_time",
				"_img_shop_red",
			])
	}
}
window["EudaemonEnterItem"] = EudaemonEnterItem