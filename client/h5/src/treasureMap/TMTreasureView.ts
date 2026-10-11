import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseView1 } from "../common/BaseView1"
import { EventName } from "../common/EventName"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { TreasureMapModel } from "../commonModel/TreasureMapModel"
import { Scene } from "../scene/Scene"
import { Message } from "../sysInfo/SysInfoController"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { GlobalTimerQuest, SetLocalPositionX, Util } from "../util/Util"
import { GameResPath } from './../util/GameResPath';

export class TMTreasureView extends BaseView1 {
	DestroyCallback
	InitEvent
	InitView
	OnTimer
	ShowPointerAnim
	ShowReward
	destroy_callback
	Open

	private loop_mgr: LoopScrowViewMgr;
	private time_id: any;
	private count_time: number = 10;


	public constructor() {
		super()


		this.base_file = "treasureMap";
		this.layout_file = "TMTreasureView";
		this.layer_value = Enum_UILayer.Activity;
		this.use_background = true;
		this.click_bg_toClose = false;
		this.show_open_movie = true;
		this.destroy_imm = true;
		this.is_center = true;
		this.not_show_item_use = true;
		let local_TreasureMapModel = TreasureMapModel;
		let model: TreasureMapModel = local_TreasureMapModel.GetInstance();
		let proview_list = [];
		let reward_item_list = [];
		let all_reward_count = 10;

		let playing = false;
		let data = null;
		let goods_model: GoodsModel = GoodsModel.GetInstance();
		let record_item = null;
		this.load_callback = () => {
			this.InitEvent()
		}

		this.preload_server_config = {
			config_treasure_map_new: false
		}

		this.open_callback = () => {
			this.InitView()
		}

		this.close_callback = () => {
			this.DestroyCallback()
		}

		this.InitEvent = () => {
			Util.AddClickEvent(this._Image1, () => {
				GlobalEventSystem.Fire(EventName.OPEN_INSTRUCTION_VIEW, 20301)
			}, this, true);

			Util.AddClickEvent(this._img_bg3, () => {
				if (this.click_bg_toClose) {
					this.Close();
				}
			}, this);

			Util.AddClickEvent(this._img_close, () => {
				if (playing) {
					Message.show("正在挖取宝物中")
				} else {
					this.Close();
				}
			}, this, true);

			Util.AddClickEvent(this._img_proview, () => {
				let list = []
				if (proview_list.length > 0) {
					list = proview_list
				} else {
					let rewards = ResManager.GetInstance().GetGameConfigFromCache(this, "config_treasure_map_new", false)
					if (rewards) {
						for (const i in rewards) {
							let vo = rewards[i]
							if (vo.type == 2) {
								let _reward = JSON.parse(vo.reward_list)
								let [type, lock] = goods_model.GetMappingTypeId(_reward[0][0], _reward[0][1])
								let v = []
								v[0] = type
								v[1] = _reward[0][2]
								table.insert(list, v)
							}
						}
						proview_list = list
					}
				}
				if (list.length > 0) {
					CustomActivityModel.GetInstance().Fire(CustomActivityDefine.EVENT.OPEN_CUSTOM_VIEW, "CommonActRewardPreview", "customActivity", list, true)
				}
			}, this, true);

			// 退出采集动作
			Scene.GetInstance().MainRoleQuitCollect()
		}

		let SetOutsideImageSprite = (img?, url?) => {
			ResManager.GetInstance().SetOutsideImageSprite(this, img, GameResPath.GetIconOtherPath('treasureMap', url))
		}

		this.InitView = () => {
			SetOutsideImageSprite(this._img_bg1, "uicscbg_006-2");
			SetOutsideImageSprite(this._img_bg2, "uicscbg_008-2");
			SetOutsideImageSprite(this._img_bg3, "uicscbg_021");
			SetOutsideImageSprite(this._img_bg5, "uicscbg_008");

			this.ShowReward()
			record_item = CustomActivityModel.GetInstance().LoadActRecord(this._gp_record, null, null, 2, null, 20303, '#5A1C20')
			record_item.ExcuteCallback(() => {
				record_item._lb_desc.fontSize = 18;
				record_item._lb_desc.color = '#5A1C20';
				record_item._lb_desc.centerX = -30
				record_item._record.style.fontSize = 16;
				record_item._panel.height = 100;
			})


		}

		let all_rotation = 0
		let timeout_id = null
		let max_count = 10
		let min_count = 8
		this.ShowReward = () => {
			let _list = data.goods_list
			let _reward = data.reward
			if ((!data || !_list) || !_reward) {
				return
			}

			// 先插入数据
			let newList = _list.concat(_reward);
			// 随机打乱数组
			let len: number = newList.length;
			for (let i = 0; i < len - 1; i++) {
				let index = parseInt((Math.random() * (len - i)).toString());
				let temp = newList[index];
				newList[index] = newList[len - i - 1];
				newList[len - i - 1] = temp;
			}

			let index: number = newList.findIndex((data: any) => {
				return data.typeId == _reward[0].typeId && data.count == _reward[0].count;
			});

			for (let i = 0; i < newList.length; i++) {
				const e = newList[i];
				let item: BaseAwardItem = reward_item_list[i]
				if (!item) {
					item = new BaseAwardItem(this._gp_reward)
					item.Load()
					item.SetItemSize(80, 80)
					table.insert(reward_item_list, item)
					let radius = 185;
					let angle = (i * 36) - 18;
					let radians = angle * Math.PI / 180
					item.SetPosition(radius * Math.sin(radians), radius * Math.cos(radians))
				}
				let [type, lock] = goods_model.GetMappingTypeId(e.style, e.typeId)
				item.SetData(e.typeId, e.count, lock);
			}
			this.ShowPointerAnim(index)
		}



		this.ShowPointerAnim = (index?) => {
			// all_rotation = Util.getRotationLong(all_reward_count, 0.5, max_count, min_count, index, 4);
			let all_rotation1: number = Util.getRotationLong(all_reward_count, 0, max_count, min_count, index, 5);
			playing = true;
			// let imgRotation = this._img_pointer.rotation;
			// this._img_pointer.rotation = imgRotation % 360;
			let imgRotation2 = this.pointerBox.rotation;
			this.pointerBox.rotation = imgRotation2 % 360;


			this._lb_time.style.color = "#FFFFFF"
			this._lb_time.style.align = "center"
			this._lb_time.style.fontSize = 20
			this._lb_time.style.wordWrap = false

			Laya.Tween.to(this.pointerBox, { rotation: -all_rotation1 }, 5000, Laya.Ease.circOut, Laya.Handler.create(this, () => {
				playing = false;
				model.Fire(local_TreasureMapModel.TM_REQUEST_SCMD, 20304);
				Laya.timer.once(500, this, () => {
					if (this.use_delete_method) return
					let reward = data && data.reward;
					if (reward) {
						Util.ShowCongratulationView(data.reward, 10);
					}
					this.click_bg_toClose = true;
					model.Fire(local_TreasureMapModel.TM_REQUEST_SCMD, 20303);
					this.StartTimer();
				})
			}, null, true));
		}


		this.DestroyCallback = () => {
			this.click_bg_toClose = false
			all_rotation = 0
			this.count_time = 10
			timeout_id = null
			proview_list = []
			if (data) {
				model.Fire(local_TreasureMapModel.TM_USE_GOODS_AGAIN, data.type)
			}
			if (reward_item_list.length > 0) {
				for (let _tmpi in reward_item_list) {
					var item = reward_item_list[_tmpi]
					item.DeleteMe();
				}
				reward_item_list = []
			}
			if (timeout_id) {
				clearTimeout(timeout_id)
				timeout_id = null
			}
			if (record_item) {
				record_item.DeleteMe()
				record_item = null
			}

			if (this.loop_mgr) {
				this.loop_mgr.DeleteMe();
				this.loop_mgr = null;
			}
			Laya.Tween.clearAll(this.pointerBox);
			Laya.timer.clearAll(this);
			this.StopTimer();

		}

		this.Open = (...new_args) => {
			let parms = new_args
			data = parms[0]
			super.Open()
		}
	}



	private StartTimer() {
		this.StopTimer();
		let loop_func = () => {
			this._lb_time.visible = true;
			this.count_time -= 1;
			if (this.count_time <= 0) {
				this.StopTimer();
				this.Close();
			} else {
				this._lb_time.innerHTML = Util.StrToHTML(`点击任意位置关闭<font color='#08F04A'>(${this.count_time}s)</font>`)
			}
		}

		this.time_id = GlobalTimerQuest.AddPeriodQuest(loop_func, 1, -1);
		loop_func();
	}

	private StopTimer() {
		if (this.time_id) {
			GlobalTimerQuest.CancelQuest(this.time_id);
			this.time_id = null;
		}
	}




	public DeleteMe() {
		this.StopTimer();
		super.DeleteMe();
	}


	_img_bg3: Laya.Image
	_img_bg1: Laya.Image
	_img_bg2: Laya.Image
	_img_bg5: Laya.Image
	_img_pointer1: Laya.Image
	_img_pointer: Laya.Image
	_img_close: Laya.Image
	_gp_reward: Laya.Box
	_img_proview: Laya.Image
	_lb_time: Laya.HTMLDivElement
	_gp_record: Laya.Box
	pointerBox: Laya.Box
	_Image1: Laya.Image
	_img_treasure: Laya.Image
	public GetComponents() {
		[
			this._img_bg3,
			this._img_bg1,
			this._img_bg2,
			this._img_bg5,
			this._img_pointer1,
			this._img_pointer,
			this._img_close,
			this._gp_reward,
			this._img_proview,
			this._lb_time,
			this._gp_record,
			this.pointerBox,
			this._Image1,
			this._img_treasure,
		]
			= this.GetChildrenByNames([

				"_img_bg3",
				"_img_bg1",
				"_img_bg2",
				"_img_bg5",
				"_img_pointer1",
				"_img_pointer",
				"_img_close",
				"_gp_reward",
				"_img_proview",
				"_lb_time",
				"_gp_record",
				"pointerBox",
				"_Image1",
				"_img_treasure",
			])
	}
}
window["TMTreasureView"] = TMTreasureView