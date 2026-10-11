import { BaseController } from "../common/BaseController"
import { Config } from "../common/Config"
import { EventName } from "../common/EventName"
import { FigureProtoVo } from "../common/FigureProtoVo"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { GoodsModel } from "../commonModel/GoodsModel"
import { OutWardBaseModel } from "../commonModel/OutWardBaseModel"
import { TaskModel } from "../commonModel/TaskModel"
import { SceneManager } from "../scene/SceneManager"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { Util } from "../util/Util"
import { PartnerModel } from "../commonModel/PartnerModel"
import { SkillUIModel } from "../commonModel/SkillUIModel"

export class PartnerController extends BaseController {

	public model
	public user_msg_adapter = UserMsgAdapter.GetInstance()

	public constructor() {
		super()

		this.model = PartnerModel.GetInstance()

		this.InitEvents()

		let On14200 = () => {

			let scmd = this.user_msg_adapter.GetSCMD(14200)
			let role_vo = SceneManager.GetInstance().GetRoleVo(scmd.role_id)
			if (role_vo) {
				role_vo.SetFigureId(FigureProtoVo.FigureType.Partner, scmd.figure_id)
			}
		}

		let On14201 = () => {

			let scmd = this.user_msg_adapter.GetSCMD(14201)
			this.model.RefOnePartner(scmd)
			//预加载技能特效
			let arr = this.model.GetSkill()
			SkillUIModel.GetInstance().PreLoadSkillEffectRes(arr[1])
			this.model.Fire(PartnerModel.UPDATE_VIEW, 14201, scmd)
			this.model.Fire(PartnerModel.REF_PARTNERSKILL)
		}

		let On14202 = () => {

			let scmd = this.user_msg_adapter.GetSCMD(14202)
			this.model.SetScmd14202(scmd)
			//预加载技能特效
			let arr = this.model.GetSkill()
			SkillUIModel.GetInstance().PreLoadSkillEffectRes(arr[1])
			this.model.Fire(PartnerModel.UPDATE_VIEW, 14202, scmd)
			this.model.Fire(PartnerModel.REF_PARTNERSKILL)
			this.model.UpdateCompanionBiogRed()
		}

		let On14203 = () => {

			let scmd = this.user_msg_adapter.GetSCMD(14203)
			if (scmd.code == 1) {
				this.model.UpdateFollowData(scmd)
				//预加载技能特效
				let arr = this.model.GetSkill()
				SkillUIModel.GetInstance().PreLoadSkillEffectRes(arr[1])
			} else {
				Util.ErrorCodeShow(scmd.code)
			}
		}

		let On14204 = () => {

			let scmd = this.user_msg_adapter.GetSCMD(14204)
			if (scmd.errcode != 1) {
				Util.ErrorCodeShow(scmd.errcode)
				return
			}
			let data = {
				_type: 142,
				id: scmd.companion_id,
				combat: scmd.combat,
				isFirst: true
			}
			// console.log("激活伙伴////////////////-")
			if (!TaskModel.GetInstance().GetHasReceiveTaskList(Config.PRELOAD_CLIENT_CONFIG.ConfigPartnerAwake.ExpDungeonTaskId)) {
				// console.log("打开激活伙伴界面////////////////-")
				OutWardBaseModel.GetInstance().Fire(OutWardBaseModel.OPEN_VIEW, "OutwardChangedView", data)
			}
			this.model.SetAutoStatus(data.id, true)
			this.model.UpdateCompanionBiogRed()
		}

		let On14205 = () => {

			let scmd = this.user_msg_adapter.GetSCMD(14205)
			if (scmd.errcode != 1) {
				Util.ErrorCodeShow(scmd.errcode)
				PartnerModel.Is_Requeste = false
				this.model.Fire(PartnerModel.REF_REQUEST_STATUS)
			} else {
				let data = this.model.GetInfoByID(scmd.companion_id)
				this.model.Fire(PartnerModel.UP_LV_ANIMATION, scmd, Util.DeepCopy(data))
				if (data) {
					let is_up= false
					if (data.stage != scmd.stage || data.star != scmd.star) { // 升级
						this.model.Fire(PartnerModel.REQUSET_SCMD, 14201, scmd.companion_id)
						this.model.Fire(PartnerModel.UPDATE_STATE)
						is_up = true
					}
					data.stage = scmd.stage
					data.star = scmd.star
					data.blessing = scmd.blessing
					if(is_up)this.model.UpdateCompanionBiogRed()
				}
				this.model.RefRed()
			}
		}

		let On14206 = () => {

			let scmd = this.user_msg_adapter.GetSCMD(14206)
			if ((scmd.errcode != 1)) {
				Util.ErrorCodeShow(scmd.errcode)
			} else {
				this.model.Fire(PartnerModel.UPDATE_NUCLEUS, scmd.companion_id)
			}
		}

		let On14207 = () => {
			let scmd = this.user_msg_adapter.GetSCMD(14207)
			if (scmd.code != 1) {
				Util.ErrorCodeShow(scmd.errcode)
			} else {
				this.model.SaveBiogLockStatus(scmd.companion_id, scmd.biog_lv)
				this.model.Fire(PartnerModel.UNLOCK_BIOG, scmd)
				let rewards = PartnerModel.GetInstance().GetBiogLockReward(scmd.companion_id, scmd.biog_lv)
				Util.ShowCongratulationView(rewards)
			}
		}
		this.RegisterProtocal(14200, On14200)
		this.RegisterProtocal(14201, On14201)
		this.RegisterProtocal(14202, On14202)
		this.RegisterProtocal(14203, On14203)
		this.RegisterProtocal(14204, On14204)
		this.RegisterProtocal(14205, On14205)
		this.RegisterProtocal(14206, On14206)
		this.RegisterProtocal(14207, On14207)

	}

	public InitEvents() {
		let request_func = (scmd, ...new_args) => {
			let fmt_str
			if ((scmd == 14201 || scmd == 14203 || scmd == 14204 || scmd == 14205 || scmd == 14206)) {
				fmt_str = "i"
			} else if (scmd == 14207) {
				fmt_str = "ic"
			}
			else if (scmd == 14202) {
				this.SendFmtToGame(scmd)
				return
			}
			this.SendFmtToGameImme(scmd, fmt_str, ...new_args)
		}
		this.model.Bind(PartnerModel.REQUSET_SCMD, request_func)

		let gameStart_func = () => {
			this.model.InitConfig()
			this.model.Fire(PartnerModel.REQUSET_SCMD, 14202)
			GoodsModel.GetInstance().Fire(GoodsModel.REQUEST_EXCHANGE_GOODS, 7)
		}
		GlobalEventSystem.Bind(EventName.GAME_START, gameStart_func)

		let change_bag = (list?) => {
			if (list) {
				let checkOutList = []
				for (let k in list) {
					let v = list[k]
					let basic = GoodsModel.GetInstance().GetGoodsBasicByTypeId(v.type_id)
					if (basic && basic.type == 22) {
						this.model.RefRed()
					}
				}
			}
		}
		GoodsModel.GetInstance().Bind(GoodsModel.CHANGE_BAG_LIST, change_bag)

	}


}

window["PartnerController"] = PartnerController