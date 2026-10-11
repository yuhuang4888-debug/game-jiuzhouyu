import { AutoFightManager } from "../autofight/AutoFightManager";
import { BaseAwardItem } from "../common/BaseAwardItem";
import { BaseItem1 } from "../common/BaseItem1";
import { CongratulationObtainView } from "../common/CongratulationObtainView";
import { SceneEventType } from "../common/EventName";
import { Enum_UILayer } from "../common/LayerManager";
import { ResManager } from "../common/ResManager";
import { table } from "../common/table";
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine";
import { CustomActivityModel } from "../commonModel/CustomActivityModel";
import { GoodsModel } from "../commonModel/GoodsModel";
import { TaskModel } from "../commonModel/TaskModel";
import { Scene } from "../scene/Scene";
import { SceneManager } from "../scene/SceneManager";
import { SceneObj } from "../scene/sceneobj/SceneObj";
import { Message } from "../sysInfo/SysInfoController";
import { ColorUtil } from "../util/ColorUtil";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { ErlangParser } from "../util/ErlangParser";
import { GameResPath } from "../util/GameResPath";
import { Util } from "../util/Util";
import { Vector2 } from "../util/Vector2";
import { FtvCollectionGoodItem } from "./FtvCollectionGoodItem";

export class FtvCollectionExchangeItem extends BaseItem1 {
	public bg_img: Laya.Image;
	public _scl_goods
	public _gp_goods: Laya.Box;
	public _gp_label: Laya.Box;
	public _lb_one
	public _lb_all
	public _gp_btn: Laya.Box;
	public _gp_btn_go: Laya.Box;
	public _btn_go: Laya.Box;
	public _Image1: Laya.Image;
	public _lb_go: Laya.Label;
	public _gp_btn_exchange: Laya.Box;
	public _btn_exchange: Laya.Box;
	public _Image2: Laya.Image;
	public _lb_exchange: Laya.Label;
	public _Group0: Laya.Box;
	public _img_symbol: Laya.Image;
	public _gp_reward: Laya.Box;
	public label_person
	public label_all

	_view_goods
	all_num
	base_type
	can_exchange
	exchange_good_id_list
	good_item_list
	goods_type
	grade_info
	parent_mask
	personal_num
	sub_type
	StartFieldSceneAutoFight
	redDot
	has_gray

	public constructor(parent?) {
		super(parent)


		this.exchange_good_id_list = []
		this.good_item_list = []
		this.can_exchange = true
		this.personal_num = 0	//个人可兑换次数
		this.all_num = 0		//全服可兑换次数
		this.base_file = "ftvCollectionExchange"
		this.layout_file = "FtvCollectionExchangeItem"
		this.layer_value = Enum_UILayer.UI
		this.has_gray=false
		this.load_callback = () => {
			this.LoadSuccess()
			this.InitEvent()
		}
	}

	public LoadSuccess() {
		ResManager.GetInstance().SetImageSprite(this, this.bg_img,"ftvCollectionExchange", "uidjtz_005a")
		//ResManager.GetInstance().SetTexture(this, this.bg_img, GameResPath.GetIcon("ftvCollectionExchange", "uidjtz_005a"))
	}

	public InitEvent() {
		let updata_goods = (list?) => {
			if (this.use_delete_method) {
				return
			}
			for (let _tmpi in list) {
				let v = list[_tmpi]
				for (let i in this.exchange_good_id_list) {
					if (this.exchange_good_id_list[i][0] == v.type_id) {
						let num = GoodsModel.GetInstance().GetTypeGoodsNum(v.type_id)
						this.good_item_list[i].RefreshCount(num)
						this.exchange_good_id_list[i][3] = num
						if (num >= this.exchange_good_id_list[i][1]) {
							this.exchange_good_id_list[i][2] = true
						} else {
							this.exchange_good_id_list[i][2] = false
						}
						break
					}
				}
			}
			this.RefreshExchangeStatus()
		}
		this.BindEvent(GoodsModel.GetInstance(), GoodsModel.UPDATE_GOODS_NUM, updata_goods)

		let exchange_btn_fun = () => {
			if ((this.personal_num != null && this.personal_num <= 0 && this.all_num == null)
				|| (this.all_num != null && this.all_num <= 0 && this.personal_num == null)
				|| (this.personal_num != null && this.all_num != null && this.personal_num <= 0 && this.all_num <= 0)) {
				Message.show("该奖励今天已被兑完，请明天再来")
			} else if (!this.can_exchange) {
				Message.show("物品不足，请前往收集")
			}
			if (this.can_exchange
				&& ((this.personal_num != null && this.personal_num > 0) || (this.all_num != null && this.all_num > 0))) {
				let v = {}
				let goods_num = null
				for (let i in this.exchange_good_id_list) {
					let vo = this.exchange_good_id_list[i]
					let have_num = null
					if (vo[3] >= 0) {
						have_num = vo[3]
					} else {
						have_num = GoodsModel.GetInstance().GetTypeGoodsNum(vo[0])
					}
					if (goods_num == null || goods_num > have_num) {
						goods_num = have_num
					}
				}
				let limit_num = this.personal_num && this.personal_num || this.all_num
				limit_num = (limit_num > goods_num ? (goods_num) : (limit_num))
				v["goods_id"] = this.goods_type
				v["max_num"] = limit_num
				v["args"] = [this.base_type, this.sub_type, this.grade_info.grade]
				v["scmd"] = 33179
				v["cur_num"] = 1
				CustomActivityModel.GetInstance().Fire(CustomActivityDefine.EVENT.OPEN_CUSTOM_VIEW, "FtvBulkPurchaseView", "ftvCollectionExchange", v)
			}
		}
		Util.AddClickEvent(this._btn_exchange, exchange_btn_fun, this, true)

		let go_btn_fun = () => {
			if (AutoFightManager.GetInstance().NowAreaIsFitAutoFight()) {
				Message.show("已在最佳挂机点")
			} else {
				this.StartFieldSceneAutoFight()
				CustomActivityModel.GetInstance().Fire(CustomActivityDefine.EVENT.CLOSE)
			}
		}
		Util.AddClickEvent(this._btn_go, go_btn_fun, this, true)

		let get_reward = (...new_args) => {
			let args = new_args
			if (args[0] == this.base_type && args[1] == this.sub_type && args[2].grade == this.grade_info.grade) {
				this.grade_info = args[3]
				if (typeof (this.grade_info.reward) == "string") {
					this.grade_info.reward = ErlangParser.GetInstance().Parse(this.grade_info.reward)
				}
				if (args[2].grade >= 3) {
					let reward = this.grade_info.reward
					reward[0][2] = args[2].num
					let reward_view = new CongratulationObtainView(reward)
					reward_view.Open()
				} else {
					let reward = this.grade_info.reward
					for (let i in reward) {
						let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(reward[i][0], reward[i][1])
						let vo = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
						if (vo) {
							Message.show("获得<font color=" + ColorUtil.GetColorLight(vo.color) + ">" + vo.goods_name + "x" + args[2].num + "</font>")
						}
					}
				}
				this.InitExchangeCount()
			}
		}
		this.BindEvent(CustomActivityModel.GetInstance(), CustomActivityDefine.EVENT.ANSWER_TARGET, get_reward)

		let update_all_cout = (...new_args) => {
			let args = new_args
			if (typeof (this.grade_info.condition) == "string") {
				this.grade_info.condition = ErlangParser.GetInstance().Parse(this.grade_info.condition)
			}
			if (args[0] == this.base_type && args[1] == this.sub_type && Number(this.grade_info.condition[0][3]) == args[2].counter_id) {
				this.InitExchangeCount(args[2].count)
			}
		}
		this.BindEvent(CustomActivityModel.GetInstance(), CustomActivityDefine.EVENT.UPDATE_ALL_COUNT, update_all_cout)

		let updata_view = (...new_args) => {
			let args = new_args
			if (args[0] == this.base_type && args[1] == this.sub_type) {
				let data = CustomActivityModel.GetInstance().GetActData(args[0], args[1])
				if (data && data.reward_list) {
					for (let i in data.reward_list) {
						if (this.grade_info.grade == data.reward_list[i].grade) {
							this.grade_info.receive_times = data.reward_list[i].receive_times
							this.InitExchangeCount()
						}
					}
				}
			}
		}
		this.BindEvent(CustomActivityModel.GetInstance(), CustomActivityDefine.EVENT.UPDATE_VIEW, updata_view)

		this.StartFieldSceneAutoFight = () => {
            let task_model = TaskModel.GetInstance()
			ResManager.GetInstance().LoadGameConfig(this, "config_onhook", false, undefined, (cfg) => {
				let RoleManager = window["RoleManager"]
				let main_role_vo = RoleManager.GetInstance().GetMainRoleVo();
				let  target_cfg
				if (cfg) {
					let level = main_role_vo.level
					let tmp = null
					for (let key in cfg) {
						tmp = cfg[key]
						if (level >= tmp.min_lv && level < tmp.max_lv) {
							target_cfg = tmp
							break
						}
					}
				}
				ResManager.GetInstance().DestoryGameConfig(this, "config_onhook", false);
				if (target_cfg) {
					if (SceneManager.GetInstance().IsFieldScene()) {
						let pos_arr = JSON.parse(target_cfg.xy)
						if (pos_arr) {
							let index=Math.ceil(Math.random() * pos_arr.length)-1
							let pos = pos_arr[index]
							if (pos) {
								pos[0] = Number(pos[0])
								pos[1] = Number(pos[1])
								let end_func = () => {
									AutoFightManager.GetInstance().SetAutoFight(true)
									task_model.monster_center_pos = null
									Scene.GetInstance().SetClickTarget(null)
								}
								let move_fun = () => {
									task_model.monster_center_pos = new Vector2(pos[0], pos[1])
									Scene.GetInstance().MainRoleMove(new Vector2(pos[0] / SceneObj.GetLogicRealRatio().x, pos[1] / SceneObj.GetLogicRealRatio().y), 0, end_func)
								}
								if (target_cfg.scene_id == SceneManager.GetInstance().GetSceneId()) {
									move_fun()
								} else {
									let change_scene_call = () => {
										move_fun()
									}
									GlobalEventSystem.Fire(SceneEventType.REQUEST_CHANGE_SCENE, Number(target_cfg.scene_id), pos[0], pos[1], 1, change_scene_call)
									// scene_id, pos_x, pos_y, send_type, change_scene_call_back?
								}
							}
						}
					} else {
						Message.show("当前场景不能前往")
					}
				} else {
					Message.show("没有合适的挂机区域哦~")
				}
			})
            
        }
	}

	public RefreshExchangeStatus() {
		this.can_exchange = true
		for (let i in this.exchange_good_id_list) {
			if (!this.exchange_good_id_list[i][2]) {
				this.can_exchange = false
			}
		}
		

		if (this.can_exchange) {
				this._gp_btn_go.visible = false
				this._gp_btn_exchange.visible =   true
				this.redDot.visible=!this.has_gray
			} else {
				this._gp_btn_go.visible = true
				this._gp_btn_exchange.visible =  false
			}
	}

	public InitExchangeCount(all_cout?) {
		let cond = CustomActivityModel.GetInstance().GetActCondition(this.base_type, this.sub_type, "data", this.grade_info.grade)
		if (cond) {
			if (cond.personal_num != null && Number(cond.personal_num) != 0) {
				this.personal_num = Number(cond.personal_num) - this.grade_info.receive_times
				this.all_num = null
				this._lb_one.visible = true
				this._lb_one.text = this.personal_num+"次"
				Util.SetImageGray(this._gp_btn_exchange, this.personal_num <= 0)
				this.label_person.visible=true
				this.has_gray=this.personal_num <= 0
				if(this._gp_btn_exchange.visible){
					this.redDot.visible=!this.has_gray
				}else{
					this.redDot.visible=false
				}
			} else if (cond.all_num != null) {
				if (this.grade_info.all_count != null) {
					this.all_num = Number(cond.all_num) - this.grade_info.all_count
					this.personal_num = null
					this._lb_all.visible = true
					this._lb_all.text =this.all_num+"次"
					this.label_all.visible=true
					Util.SetImageGray(this._gp_btn_exchange, this.all_num <= 0)
					this.has_gray=this.all_num <= 0
					if(this._gp_btn_exchange.visible){
						this.redDot.visible=!this.has_gray
					}else{
						this.redDot.visible=false
					}
				} else {
					CustomActivityModel.GetInstance().Fire(CustomActivityDefine.EVENT.SCMD_REQUEST, 33106, this.base_type, this.sub_type, CustomActivityDefine.ICON_KEY, this.grade_info.condition[0][3], this.grade_info.grade)
				}
			}
		}
	}

	public InitView() {
		this.can_exchange = true
		if (this.good_item_list.length > 0) {
			for (let _tmpi in this.good_item_list) {
				let item = this.good_item_list[_tmpi]
				item.visible =  false
			}
		}
		if (this.grade_info.condition) {
			for (let i in this.grade_info.condition[0][1]) {
				let good = this.grade_info.condition[0][1][i]
				let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(good[0], good[1])
				let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(type_id)
				if (basic) {
					let have_num = GoodsModel.GetInstance().GetTypeGoodsNum(type_id)
					this.exchange_good_id_list.push([type_id, good[2], have_num >= good[2], have_num])
					let item = this.good_item_list[i]
					if (!item) {
						item = new FtvCollectionGoodItem(this._gp_goods)
						item.Load()
						table.insert(this.good_item_list, item)
					}
					item.ExcuteCallback(() => {
						item.SetData(type_id, have_num, Number(good[2]), "good", i)
					}
					)
				}
			}
		}
		if (this.grade_info.reward) {
			for (let i in this.grade_info.reward) {
				let good = this.grade_info.reward[i]
				let item = this.good_item_list[this.grade_info.condition[0][1].length]
				if (!item) {
					item = new BaseAwardItem(this._gp_reward)
					item.SetItemSize(87, 87)
					item.Load()
					table.insert(this.good_item_list, item)
				}
				item.ExcuteCallback(() => {
					let [type_id, lock] = GoodsModel.GetInstance().GetMappingTypeId(good[0], good[1])
					this.goods_type = type_id
					item.SetData(type_id, Number(good[2]))
				}
				)
			}
		}
		this._lb_one.visible = false
		this._lb_all.visible = false
		this.label_person.visible=false
		this.label_all.visible=false
		this.InitExchangeCount()
		this.RefreshExchangeStatus()
	}

	public SetData(base_type?, sub_type?, grade_info?) {
		this.grade_info = grade_info
		this.base_type = base_type
		this.sub_type = sub_type
		this.InitView()
	}

	public SetParentMask(paren_mask?) {

		this.parent_mask = paren_mask
	}

	public DeleteMe() {
		if (this.good_item_list.length > 0) {
			for (let _tmpi in this.good_item_list) {
				let item = this.good_item_list[_tmpi]
				item.DeleteMe()
			}
			this.good_item_list = []
		}
		super.DeleteMe()
	}

	public GetComponents() {
		[
			this.bg_img,
			this._scl_goods,
			this._gp_goods,
			this._gp_label,
			this._lb_one,
			this._lb_all,
			this._gp_btn,
			this._gp_btn_go,
			this._btn_go,
			this._Image1,
			this._lb_go,
			this._gp_btn_exchange,
			this._btn_exchange,
			this._Image2,
			this._lb_exchange,
			this._Group0,
			this._img_symbol,
			this._gp_reward,
			this.label_person,
			this.label_all,
			this.redDot
		]
			= this.GetChildrenByNames([

				"bg_img",
				"_scl_goods",
				"_gp_goods",
				"_gp_label",
				"_lb_one",
				"_lb_all",
				"_gp_btn",
				"_gp_btn_go",
				"_btn_go",
				"_Image1",
				"_lb_go",
				"_gp_btn_exchange",
				"_btn_exchange",
				"_Image2",
				"_lb_exchange",
				"_Group0",
				"_img_symbol",
				"_gp_reward",
				"label_person",
				"label_all",
				"redDot"
			])
			this.redDot.visible=false
	}
}

window["FtvCollectionExchangeItem"]=FtvCollectionExchangeItem