import { BaseController } from "../common/BaseController"
import { CommonManager } from "../common/CommonManager"
import { EventName } from "../common/EventName"
import { RedDotManager, ModuleType } from "../common/RedDotManager"
import { ResManager } from "../common/ResManager"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { GoodsModel } from "../commonModel/GoodsModel"
import { MedalModel } from "../commonModel/MedalModel"
import { RoleManager } from "../commonModel/RoleManager"
import { SceneManager } from "../scene/SceneManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Util } from "../util/Util"
import { Config } from "../common/Config"
import "../medal/MedalEnterView"
import { OutWardBaseModel } from "../commonModel/OutWardBaseModel"

export class MedalController extends BaseController {
	InitInfo
	open_title
	public constructor() {
		super()

		this.InitInfo = () => {
			let _model = MedalModel.GetInstance()
			let reincarnation_enter_view = null
			let medal_enter_view = null
			let user_msg_adapter = UserMsgAdapter.GetInstance()
			let local_redMgr = RedDotManager.GetInstance()

			let gameStar = () => {

			}

			GlobalEventSystem.Bind(EventName.INIT_CONFIG, gameStar)

			GlobalEventSystem.Bind(EventName.GAME_START, () => {
				this.SendFmtToGame(13401)
				this.SendFmtToGame(13405)
			}
			)

			_model.Bind(MedalModel.MEDAL_REQUEST_PROTO, (id, ...new_args) => {
				let parms = new_args
				if (13407 == id) {
					this.WriteBegin(id)
					let list = parms[0]
					this.WriteFMT("h", Util.TableSize(list))
					for (let key in list) {

						let count = list[key]
						this.WriteFMT("l", key)
						this.WriteFMT("i", count)
					}
					this.SendToGame()
				} else if (13403 == id) {
					this.SendFmtToGame(id, "i", parms[0])
				} else if (13404 == id) {
					this.SendFmtToGame(id, "i", parms[0])
				} else if (13406 == id) {
					this.SendFmtToGame(id)
				} else if ("default" == id) {
					this.SendFmtToGame(id)
				}
			}
			)

			let updateReddot = (goods_list?) => {
				let cfg = Config.PRELOAD_SERVER_CONFIG.config_medal
				_model.Fire(MedalModel.UPDATE_TITLE_MAIN_VIEW)
				if (!local_redMgr.CheckRedStatus(ModuleType.MEDAL, 1)) {
					_model.setShowRedDot(cfg)
					_model.Fire(MedalModel.CHANGE_RED_DOT)
				}

				if (!local_redMgr.CheckRedStatus(ModuleType.MEDAL_STRENGTHEN, 1)) {
					_model.setMedalStrRed()
				}
				let cfgs = Config.PRELOAD_SERVER_CONFIG.config_title_cfg
				if (goods_list && CommonManager.GetInstance().CheckFuncOpenState("TitleMainView", true)) {
					for (let k in goods_list) {
						var v = goods_list[k]
						let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(v.type_id)
						if (basic && basic.type == 76) {
							_model.SetTitleRedDot(cfgs)
							break
						}
					}
				}
			}
			GoodsModel.GetInstance().Bind(GoodsModel.CHANGE_BAG_LIST, updateReddot)

			RoleManager.GetInstance().GetMainRoleVo().BindOne("fighting", (event_name?, value?, old_value?) => {
				let cfg = Config.PRELOAD_SERVER_CONFIG.config_medal
				_model.setShowRedDot(cfg)
				let cfgs = Config.PRELOAD_SERVER_CONFIG.config_title_cfg
				if (CommonManager.GetInstance().CheckFuncOpenState("TitleMainView", true)) {
					_model.SetTitleRedDot(cfgs)
				}
			})

			let open_medal_view = (index?) => {
				if (!medal_enter_view) {
					let _view_class = window["MedalEnterView"];
					medal_enter_view = new _view_class();
				}
				if (!medal_enter_view.HasOpen()) {
					if (index != null) {
						medal_enter_view.SetDefaultIndex(index)
					}
					medal_enter_view.Open()
				} else {
					medal_enter_view.SetSelectIndex(index || 0)
				}
			}

			GlobalEventSystem.Bind(EventName.OPEN_MEDAL_ENTER_VIEW, open_medal_view)
			let close_medal_view = () => {
				if (reincarnation_enter_view && reincarnation_enter_view.HasOpen()) {
					reincarnation_enter_view.Close()
				}
			}

			_model.Bind(MedalModel.CLOSE_MEDAL_VIEW, close_medal_view)
			let request_medal_data = () => {
				this.SendFmtToGame(13401)
			}

			_model.Bind(MedalModel.RequestData, request_medal_data)
			let request_medal_up = () => {
				this.SendFmtToGame(13402)
			}

			_model.Bind(MedalModel.MedalUP, request_medal_up)

			let LevelChange = () => {
				if (CommonManager.GetInstance().CheckFuncOpenState("TitleMainView", true) && !this.open_title) {
					this.open_title = true
					this.SendFmtToGame(13405)
				}
			}
			RoleManager.GetInstance().GetMainRoleVo().Bind(EventName.CHANGE_LEVEL, LevelChange)

			let On13400 = () => {
				let scmd = user_msg_adapter.GetSCMD("13400")
				Util.ErrorCodeShow(scmd.code)
			}

			let On13401 = () => {
				let scmd = user_msg_adapter.GetSCMD("13401")
				_model.medalData = scmd
				_model.setMedalData(scmd.honour, scmd.id)
				_model.passLayers = scmd.pass_layers;
			}

			let On13402 = () => {
				let scmd = user_msg_adapter.GetSCMD("13402")
				_model.successUp = true;
				let cfgs = Config.PRELOAD_SERVER_CONFIG.config_medal;
				let conf = cfgs[scmd.id];
				let roleId: number = RoleManager.GetInstance().GetMainRoleId();
				if (scmd.id == 2) {
					if (conf) {
						let data = {
							type_id : roleId,
							id: conf.title
						}
						OutWardBaseModel.GetInstance().Fire(OutWardBaseModel.OPEN_VIEW, "OutwardChangedView", data);

					}
				} else if (scmd.id > 2 && scmd.id % 10 == 1) {
					let data = {
						type_id: RoleManager.GetInstance().GetMainRoleId(),
						id: conf.title
					}
					OutWardBaseModel.GetInstance().Fire(OutWardBaseModel.OPEN_VIEW, "OutwardChangedView", data);
				}
				_model.setMedalData(scmd.honour, scmd.id)
			}

			let On13403 = () => {
				let scmd = user_msg_adapter.GetSCMD("13403")
				if (scmd.code == 1) {
					this.SendFmtToGame(13405)
					// [ts2lua]lua中0和空字符串也是true，此处scmd.level == 0需要确认
					let type = (scmd.level == 0 && (1) || (2))
					_model.Fire(MedalModel.SUCCCESS_UP_LEVEL, type)
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}

			let On13404 = () => {
				let scmd = user_msg_adapter.GetSCMD("13404")
				if (scmd.code == 1) {
					this.SendFmtToGame(13405)
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}

			let On13405 = () => {
				let scmd = user_msg_adapter.GetSCMD("13405")
				_model.SetTitleInfo(scmd.list)
				let cfgs = Config.PRELOAD_SERVER_CONFIG.config_title_cfg
				_model.SetTitleRedDot(cfgs)
				_model.Fire(MedalModel.UPDATE_TITLE_MAIN_VIEW)
			}

			let On13406 = () => {
				let scmd = user_msg_adapter.GetSCMD("13406")
				if (scmd.code == 1) {
					this.SendFmtToGame(13405)
				} else {
					Util.ErrorCodeShow(scmd.code)
				}
			}

			let On13407 = () => {
				let scmd = user_msg_adapter.GetSCMD("13407")
				let change_lv = _model.medalData.stren_lv != scmd.lv
				_model.medalData.stren_lv = scmd.lv
				_model.medalData.stren_exp = scmd.exp
				_model.medalData.power = scmd.power
				if (change_lv) {
					_model.Fire(MedalModel.MEDAL_STRENGTHEN_LEVEL_CHANGE)
				}
				_model.Fire(MedalModel.MEDAL_STRENGTHEN_RETURN)
				_model.setMedalStrRed()
			}



			this.RegisterProtocal(13400, On13400)
			this.RegisterProtocal(13401, On13401)
			this.RegisterProtocal(13402, On13402)
			this.RegisterProtocal(13403, On13403)
			this.RegisterProtocal(13404, On13404)
			this.RegisterProtocal(13405, On13405)
			this.RegisterProtocal(13406, On13406)
			this.RegisterProtocal(13407, On13407)
		}
		this.InitInfo()
	}

}
window["MedalController"] = MedalController