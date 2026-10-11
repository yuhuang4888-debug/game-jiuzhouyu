import { Alert, Alert_Type } from "../alert/Alert";
import { BaseView1 } from "../common/BaseView1";
import { CustomHeadItem } from "../common/CustomHeadItem";
import { DownDropBtn } from "../common/DownDropBtn";
import { EventName } from "../common/EventName";
import { Enum_UILayer } from "../common/LayerManager";
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr";
// import { PlayerHead } from "../common/PlayerHead";
import { ResManager } from "../common/ResManager";
import { DressModel, DressType } from "../commonModel/DressModel";
import { FriendEvent, FriendModel, FRIEND_TYPE } from "../commonModel/FriendModel";
import { GoodsModel } from "../commonModel/GoodsModel";
import { MarriageEvent, MarriageModel } from "../commonModel/MarriageModel";
import { RoleManager } from "../commonModel/RoleManager";
import { Message } from "../sysInfo/SysInfoController";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { GameResPath } from "../util/GameResPath";
import { Util } from "../util/Util";
import { MarriageDropBtn } from "./MarriageDropBtn";
import { MarriageFlowerItem } from "./MarriageFlowerItem";

//伴侣-送花界面
export class MarriageFlowerView extends BaseView1 {

	public _head: CustomHeadItem;
	public _drop_btn: MarriageDropBtn;

	Local_Open
	LoadSuccess
	InitEvent
	SetFriendBtn
	UpdateView
	UpdateItems
	ClickFriendDrop
	SendGiftHandle
	loop_mgr: LoopScrowViewMgr
	public constructor() {
		super()
		this.base_file = "marriage";
		this.dependent_res = ["marriage2"]
		this.layout_file = "MarriageFlowerView"
		this.layer_value = Enum_UILayer.Activity;
		this.is_center = true
		this.use_background = true
		this.click_bg_toClose = true
		this.show_open_movie = true
		this.destroy_imm = true

		let _model = MarriageModel.GetInstance(),
			friend_model = FriendModel.GetInstance(),
			local_FriendEvent = FriendEvent,
			local_Util = Util,
			local_MarriageEvent = MarriageEvent,
			role_mgr = RoleManager.GetInstance(),
			goods_model = GoodsModel.GetInstance(),
			// _ac_item_: eui.ArrayCollection,
			_friend_list_,
			_cur_data_,
			_cur_role_data_,
			_no_friend_ = false

		this.load_callback = function () {
			this.LoadSuccess()
			this.InitEvent()
		}

		this.destroy_callback = function () {
			if (this._head) {
				this._head.DeleteMe()
				this._head = null
			}
			if (this._drop_btn) {
				this._drop_btn.DeleteMe()
				this._drop_btn = null
			}
			if (this.loop_mgr) {
				this.loop_mgr.DeleteMe()
				this.loop_mgr = null
			}
		}

		this.Local_Open = (parms) => {
			_cur_role_data_ = parms[0]
			if (_cur_role_data_) {
				let role_id = parms[0].role_id || parms[0].player_id
				_cur_role_data_["role_id"] = role_id
			}

			super.Open()
		}

		this.LoadSuccess = () => {
			this._gp_con.scrollBar.visible = false
			this._head = new CustomHeadItem(this._head_con)
			this._head.Load()
			// this._head_con.addChild(this._head)

			ResManager.GetInstance().SetOutsideImageSprite(this, this._img_bg, GameResPath.GetIcon("marriage", "ui_role_07"))

			// _ac_item_ = new eui.ArrayCollection()
			// this._list.dataProvider = _ac_item_
			// this._list.itemRenderer = MarriageFlowerItem

			//请求好友数据
			let [need_fire, list] = _model.GetFriendList()
			if (need_fire) {
				friend_model.Fire(local_FriendEvent.REQUEST_FRIEND_DATA, FRIEND_TYPE.FRIEND)
			} else {
				this.SetFriendBtn(list)
			}

			this.UpdateItems()
		}

		this.InitEvent = () => {
			local_Util.AddClickEvent(this._btn_close, () => {
				this.Close()
			}, this, true)

			local_Util.AddClickEvent(this._btn_help, () => {
				GlobalEventSystem.Fire(EventName.OPEN_INSTRUCTION_VIEW, 223)
			}, this, true)

			this.BindEvent(friend_model, local_FriendEvent.FRIEND_DATA_UPDATE, () => {
				let [need_fire, list] = _model.GetFriendList()
				this.SetFriendBtn(list)
			})

			this.BindEvent(_model, local_MarriageEvent.GIVE_GIFT, (type_id, num) => {
				this.SendGiftHandle(type_id, num)
			})

			this.BindEvent(_model, local_MarriageEvent.GET_FLOWER, (scmd) => {
				if (_cur_role_data_ && _cur_role_data_.role_id == scmd.role_id) {
					let fdata = friend_model.getFriendById(scmd.role_id)
					this._lb_intimacy.text = fdata ? `亲密度：${fdata.intimacy}` : `亲密度：0`
				}
				this.UpdateView()
			})

			this.BindEvent(_model, local_MarriageEvent.GIVE_GIFT_SUCCESS, (scmd) => {
				if (_cur_role_data_ && _cur_role_data_.role_id == scmd.receive_id) {
					let fdata = friend_model.getFriendById(scmd.receive_id)
					this._lb_intimacy.text = fdata ? `亲密度：${fdata.intimacy}` : `亲密度：0`
				}
				this.UpdateView()
			})
		}

		this.SetFriendBtn = (list) => {
			if (!_cur_role_data_) {
				_friend_list_ = list.length > 0 ? list : [{ role_name: local_Util.HtmlColorTxt("无可赠送对象", "'#F44767'") }]
				_no_friend_ = list.length <= 0
				let role_vo = role_mgr.GetMainRoleVo()
				// let career = role_vo.career == 1 ? 2 : 1
				if (_no_friend_) {
					let career = "s"
					// this._head.setData(null, career)
					this._head.SetData(null, career)

				}
			} else {
				if (!_cur_role_data_.role_name) {
					_cur_role_data_.role_name = _cur_role_data_.name
				}
				let fdata = friend_model.getFriendById(_cur_role_data_.role_id)
				if (!fdata) {
					list.unshift(_cur_role_data_)
				} else {
					if (list[0] != fdata) {
						let del_list = list.splice(list.indexOf(fdata), 1)
						list.unshift(del_list[0])
					}
				}
				_friend_list_ = list
				_no_friend_ = false
			}
			if (!this._drop_btn) {
				// this._drop_btn = new MarriageDropBtn(this._drop_btn_con)
				this._drop_btn = new DownDropBtn(this._drop_btn_con)
			}
			this._drop_btn.Init(_friend_list_, this.ClickFriendDrop, undefined, "role_name", undefined, 5, true)
			this._drop_btn.Load()

		}

		this.UpdateView = () => {
			this.UpdateItems()
		}

		this.UpdateItems = () => {
			let list = _model.GetFlowerList()
			list.sort((a, b) => {
				let aNum = goods_model.GetTypeGoodsNum(a.goods_id)
				let bNum = goods_model.GetTypeGoodsNum(b.goods_id)
				if (aNum != bNum) return bNum - aNum
				else return a.goods_id - b.goods_id
			})
			// _ac_item_.replaceAll(list)

			if (!this.loop_mgr) {
				this.loop_mgr = new LoopScrowViewMgr()
				this.loop_mgr.SetData(this._gp_con, MarriageFlowerItem, list, LoopScrCon.Vertical, undefined)
			} else {
				this.loop_mgr.replaceAll(list)
			}
		}

		this.ClickFriendDrop = (index, data) => {
			//下拉框是二级界面
			if (this.use_delete_method) return

			if (_no_friend_) {
				Message.show("无可赠送对象");
				return;
			}
			_cur_role_data_ = data
			let role_id = data.role_id || data.player_id
			_cur_role_data_["role_id"] = role_id
			let fdata = friend_model.getFriendById(role_id)
			this._lb_intimacy.text = fdata ? `亲密度：${fdata.intimacy}` : `亲密度:：0`
			this._gp_intimacy.visible = !!fdata
			this._gp_tips.visible = !fdata
			// this._lb_guild.text = data.guild_id ? data.guild_name : "暂未加入结社"
			let frame_id = DressModel.GetInstance().GetDressByType(data.dress_list, DressType.Photo)
			// this._head.setData(data.lv || data.level, data.career, data["picture"], undefined, undefined, frame_id)
			this._head.SetRoleVoData(data)


		}

		this.SendGiftHandle = (type_id, num) => {
			if (!type_id) return
			if (!num) return
			if (!_cur_role_data_) return
			let role_vo = _cur_role_data_
			let role_id = role_vo.role_id || role_vo.player_id
			let vo = friend_model.getFriendById(role_id)
			if (vo) {
				let server_id = role_mgr.mainRoleInfo.server_unique_id
				_model.Fire(local_MarriageEvent.REQUEST_PROTO, 22301, "lhihc", role_id, server_id, type_id, num, 0)
			} else {
				let str = "该玩家还不是您好友，非好友之间送花不加亲密度，是否继续赠送"
				let server_id = role_vo.server_id || role_vo.ser_id || role_mgr.mainRoleInfo.server_unique_id
				let alert = _model.is_alert_friend && server_id == role_mgr.mainRoleInfo.server_unique_id

				let addFriend = (is_from_close) => {
					if (!is_from_close) {
						_model.is_alert_friend = alert
						friend_model.Fire(local_FriendEvent.ADD_FRIEND, role_vo.role_id)
					}
				}
				let giveFlower = (is_from_close) => {
					if (is_from_close) return
					_model.is_alert_friend = alert
					_model.Fire(local_MarriageEvent.REQUEST_PROTO, 22301, "lhihc", role_id, server_id, type_id, num, 0)
				}
				let check_fun = () => {
					alert = !alert
				}
				if (!alert) {
					giveFlower(false)
				} else
					Alert.Show(str, Alert_Type.AlertTypeCheckBox, giveFlower, addFriend, "确定", "添加好友", undefined, undefined, check_fun)
			}
		}
	}

	public Open(...parms) {
		this.Local_Open(parms)
	}

	_img_bg: Laya.Image
	_btn_close: Laya.Image
	_btn_help: Laya.Image
	_lb_guild: Laya.Label
	_head_con: Laya.Box
	_gp_intimacy: Laya.HBox
	_Image2: Laya.Image
	_lb_intimacy: Laya.Label
	_gp_con: Laya.List
	_gp_tips: Laya.HBox
	_Image1: Laya.Image
	_Label1: Laya.Label
	_drop_btn_con: Laya.Box
	public GetComponents() {
		[
			this._img_bg,
			this._btn_close,
			this._btn_help,
			this._lb_guild,
			this._head_con,
			this._gp_intimacy,
			this._Image2,
			this._lb_intimacy,
			this._gp_con,
			this._gp_tips,
			this._Image1,
			this._Label1,
			this._drop_btn_con,
		]
			= this.GetChildrenByNames([

				"_img_bg",
				"_btn_close",
				"_btn_help",
				"_lb_guild",
				"_head_con",
				"_gp_intimacy",
				"_Image2",
				"_lb_intimacy",
				"_gp_con",
				"_gp_tips",
				"_Image1",
				"_Label1",
				"_drop_btn_con",
			])
	}
}
window["MarriageFlowerView"] = MarriageFlowerView