import { OpenMode } from "../common/BaseView1"
import { BaseWindowComponent } from "../common/BaseWindowComponent"
import { InstructionType } from "../common/InstructionType"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { Config } from "../common/Config"


import "../luckyTreasureTwo/LuckyTreasureTwoItem"
import "../luckyTreasureTwo/LuckyTreasureTwoView"
export class LuckyTreasureTwoBaseView extends BaseWindowComponent {


	public constructor() {
		super()
		this.dependent_res = ["luckyTreasureTwo"]
		this.destroy_imm = true
		this.open_mode = OpenMode.OpenToggle
		this.instruction_list = [InstructionType.LuckyTreasureTwo]
		this.money_list = [2, 1, 0]
		let key_str = Config.PRELOAD_CLIENT_CONFIG.ConfigCustomActivity.ACT_ID.LUC_TREA_TWO+"@"+CustomActivityModel.GetInstance().lucky_sub_type
		let cus_model = CustomActivityModel.GetInstance(),
			local_CustomActivityDefine = CustomActivityDefine,
			_key2index
		this.window_load_back = () => {
			
			//红点
			let value = cus_model.GetRedDotValue(102, 1)
			this.SetTabRed(0 ,value && value > 0)
			//监听绑定事件
			this.BindEvent(cus_model, local_CustomActivityDefine.EVENT.UPDATE_TAB_RED, (key?, state?) => {
				if(key==key_str){
					this.SetTabRed(0, state)
				}
			})
		}
	}

	public Open(...new_args) {
		this.titleStr = "luckyTreasureTwo.uixyjb_001"
		this.bg_list = ["uixyjb_009.jpg"]
		this.viewClassList = ["LuckyTreasureTwoView"]
		this.tabStrList = [{ label: "幸运鉴宝", icon_up_source: "guild_asset.guild_022", icon_down_source: "guild_asset.guild_021" }]
		super.Open()
	}


	public DeleteMe() {
		super.DeleteMe()
	}


}

window["LuckyTreasureTwoBaseView"] = LuckyTreasureTwoBaseView
