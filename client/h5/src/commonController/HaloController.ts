import { BaseController } from "../common/BaseController"
import { EventName } from "../common/EventName"
import { UserMsgAdapter } from "../common/UserMsgAdapter"
import { BaseDungeonModel, DUN_TYPE } from "../commonModel/BaseDungeonModel"
import { HaloModel, HaloPrivilegeType } from "../commonModel/HaloModel"
import { RoleManager } from "../commonModel/RoleManager"
import "../halo/HaloMainView"
import { ServerTimeModel } from "../serverTime/ServerTimeModel"
import { GlobalEventSystem } from "../util/DeclareGlobalVar"
import { TimeUtil } from "../util/TimeUtil"


export class HaloController extends BaseController {
	model: HaloModel
	user_msg_adapter: UserMsgAdapter
	debug_mode = false
	role_mgr: RoleManager
	local_GlobalEventSystem
	public constructor() {
		super()
		this.model = HaloModel.GetInstance()
		this.user_msg_adapter = UserMsgAdapter.GetInstance()
		this.role_mgr = RoleManager.GetInstance()
		this.local_GlobalEventSystem = GlobalEventSystem
		this.RegisterAll()
		this.InitEvent()
	}


	public InitEvent() {
		this.Bind(EventName.GAME_START, () => {
			this.model.ResetData()
			this.model.Fire(HaloModel.REQUEST_SCMD, 51400)

			// //每次重登重置勾选状态
			// this.model.Fire(HaloModel.REQUEST_SCMD, 51402, "hhc", HaloPrivilegeType.ArenaSweep, 0, 0)
			// this.model.Fire(HaloModel.REQUEST_SCMD, 51402, "hhc", HaloPrivilegeType.DungeonSweep, DUN_TYPE.Equip, 0)
			// this.model.Fire(HaloModel.REQUEST_SCMD, 51402, "hhc", HaloPrivilegeType.DungeonSweep, DUN_TYPE.Dragon, 0)
		})

		this.model.Bind(HaloModel.REQUEST_SCMD, (id, fmt, ...new_args) => {
			if(this.debug_mode){
				this.TestReceive(id, fmt, ...new_args)
			}
			else{
				this.SendFmtToGame(id, fmt, ...new_args)
			}
		})

		this.role_mgr.GetMainRoleVo().Bind(EventName.CHANGE_LEVEL, (level?)=>{
			if(this.model.GetOpenState()){
				this.model.AddNewReward()
				this.model.Fire(HaloModel.UPDATE_ITEM)
			}
		} )

		let day_change = () =>{
			this.model.DayChange()
		}
		this.local_GlobalEventSystem.Bind(ServerTimeModel.DAY_CHANGE, day_change)
	}


	public RegisterAll() {
		// 活动信息
		let On51400 = (scmd?:ProtoRecvVObj<51400>) => {
			scmd = scmd || this.user_msg_adapter.GetSCMD(51400)
			this.model.SetHaloData(scmd)
			this.model.SetOpenRewardCanGetState()
			this.model.SetHaloIconRed()
			GlobalEventSystem.Fire(EventName.OPEN_HALO_ICON, true)
		}

		// 特权奖励领取
		let On51401 = (scmd?:ProtoRecvVObj<51401>) => {
			scmd = scmd || this.user_msg_adapter.GetSCMD(51401)
			this.model.ShowHaloReward(scmd.id, scmd.state)
		}

		// 特权设置
		let On51402 = (scmd?:ProtoRecvVObj<51402>) => {
			scmd = scmd || this.user_msg_adapter.GetSCMD(51402)
			this.model.SetSettingData(scmd)
			this.model.Fire(HaloModel.RecvFmt51302, scmd.id, scmd.type)
		}

		this.RegisterProtocal(51400, On51400)
		this.RegisterProtocal(51401, On51401)
		this.RegisterProtocal(51402, On51402)
	}


	public TestReceive = (id, fmt, ...new_args) => {
		let scmd
		let parms = new_args
		if (id == 51400) {
			let local_scmd:ProtoRecvVObj<51400>
			local_scmd = {
				end_time: TimeUtil.getServerTime() + 9999999,
				rewards: [

				],
			}
			scmd = local_scmd
		} else if (id == 51401) {
			
		} else if (id == 51402) {
			let local_scmd:ProtoRecvVObj<51402>
			local_scmd = {
				id: parms[0],
				type: parms[1],
				state: parms[2],
				errcode: 1,
			}
			scmd = local_scmd
		} else {
			return
		}

		if (scmd) {
			setTimeout(() => {
				let func = UserMsgAdapter.GetInstance().register_list[id]
				if(func){
					func(scmd)
				}
			}, 200);
			// Laya.timer.frameOnce(10, this, this["On" + id], [scmd])
		}
	}
}

window["HaloController"] = HaloController