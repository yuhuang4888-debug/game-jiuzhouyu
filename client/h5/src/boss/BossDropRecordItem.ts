import { BaseItem1 } from "../common/BaseItem1"
import { BaseItemRenderer } from "../common/BaseItemRenderer"
import { Config } from "../common/Config"
import { EquipmentItem } from "../common/EquipmentItem"
import { BossModel } from "../commonModel/BossModel"
import { FriendEvent, FriendModel } from "../commonModel/FriendModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Message } from "../sysInfo/SysInfoController"
import { TimeUtil } from "../util/TimeUtil"
import { Util } from "../util/Util"

export class BossDropRecordItem extends BaseItemRenderer {
	public WIDTH = 578 //86 + 13
	public HEIGT = 106

	friend_model
	model:BossModel
	item
	public static height = 100
	public static width = 620
	public constructor(parent) {
		super()

		this.base_file = "boss"
		this.layout_file = "BossDropRecordItem"
		this.model = BossModel.GetInstance()
		this.friend_model = FriendModel.GetInstance()

		this.load_callback = () => {
			this.LoadSuccess()
		}
		this.Load()
	}

	public LoadSuccess() {

		Util.AddClickEvent(
			this._lb_name, () => {
				if (this.data.name == "蒙面人") {
					Message.show("无法查看蒙面人信息")
				} else {
					// let point = this._gp_point.localToGlobal()
					//this.friend_model.Fire(
					//FriendEvent.REQUEST_MENU_DATA,
					//this.data.role_id,
					//point.x,
					//point.y + this._lb_name.height,
					//this.itemIndex
					//)
				}
			},
			this
		)

		this.BindEvent(
			this.friend_model,
			FriendEvent.MENU_DATA_UPDTE, (id?, index?) => {
				if (this.data.role_id && id == this.data.role_id && index != null && index == this.index) {
					this.CheckMenu(id)
				}
			}
		)
	}

	public dataChanged() {
		if (super.dataChanged()) {
			this._lb_time.text = TimeUtil.timeConversion(this.data.time, "yyyy-mm-dd")
			this._lb_time2.text = TimeUtil.timeConversion(this.data.time, "hh:MM:ss")
			if (this.data.boss_type) {
				this._lb_dunName.text = this.model.GetBossTypeName(this.data.boss_type)
			} else if (this.data.layers) {
				this._lb_dunName.text = this.model.GetLayerName(this.data.layers)
			} else {
				this._lb_dunName.text = "龙语秘境"
			}
			let bossVo = Config.GetConfigVo(Config.ConfigHasDefaultValue.config_mon.name, this.data.boss_id, false)
			this._lb_bossName.text = "LV." + bossVo.lv + " " + bossVo.name
			let this_mask = this.data.name == "蒙面人" && RoleManager.GetInstance().GetMainRoleId() == this.data.role_id
			let name = this_mask && "蒙面人(自己)" || this.data.name
			this._lb_name.text =this.data["server_num"]!=null?`S${this.data.server_num}.${name}` :name 
			this._img_top.visible = this.data.is_top && this.data.is_top != 0

			if (!this.item) {
				this.item = new EquipmentItem(this._box_reward)
				this.item.SetScale(0.67)
				this.item.SetUseMask(true)
				this.item.Load()
			}
			this.item.ExcuteCallback(() => {
				this.item.SetData(
					this.data.goods_id,
					this.data.num,
					false
				)
			}
			)
		}
	}

	public CheckMenu(id?) {

		if (id == RoleManager.GetInstance().GetMainRoleId()) {
			return
		}
		let data = this.friend_model.getMenuData(this.data.role_id)
		let point = data.point
		// RankModel.GetInstance().Fire(RankModelEvent.OPEN_MENU_VIEW, point, this.data.role_id, this.data.server_id)
	}

	public DeleteMe() {

		if (this.item) {
			this.item.DeleteMe()
			this.item = null
		}
		super.DeleteMe()
	}
	_img_bg: Laya.Image
	_img_top: Laya.Image
	_lb_time: Laya.Label
	_lb_time2: Laya.Label
	_box_reward: Laya.Box
	_lb_dunName: Laya.Label
	_lb_bossName: Laya.Label
	_lb_name: Laya.Label
	_gp_point: Laya.Box
	public GetComponents() {
		[
			this._img_bg,
			this._img_top,
			this._lb_time,
			this._lb_time2,
			this._box_reward,
			this._lb_dunName,
			this._lb_bossName,
			this._lb_name,
			this._gp_point,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_img_top",
				"_lb_time",
				"_lb_time2",
				"_box_reward",
				"_lb_dunName",
				"_lb_bossName",
				"_lb_name",
				"_gp_point",
			])
	}
}
window["BossDropRecordItem"] = BossDropRecordItem