import { GuildModel } from "../commonModel/GuildModel";
import { TaskModel } from "../commonModel/TaskModel";
import { Enum_ColorUtil_Dark } from "../util/ColorUtil";
import { GlobalEventSystem } from "../util/DeclareGlobalVar";
import { RefGridLayout, Util } from "../util/Util";
import { EquipToolTips } from "./EquipToolTips";
import { EventName } from "./EventName";
import { ResManager } from "./ResManager";

export class GuildExchangeTips extends EquipToolTips {

    ShowTaskExchangeArrow
    CheckShowGuildScore
	btn_list
    public constructor() {
        super()

        let guild_model = GuildModel.GetInstance()
        let local_Util = Util
        let local_Enum_ColorUtil_Dark = Enum_ColorUtil_Dark

        this.base_file = "common";
        this.layout_file = "EquipToolTips";
        this.load_callback = function () {
            this.LoadSuccess()
            this.InitEvent()

			this.grade.visible=false
            this.ShowTaskExchangeArrow()
        }


        //按钮
        this.RefreshBtnState = () => {
			let btn:any
			for(let k=0;k<this.btn_conta.numChildren;k++){
				btn = this.btn_conta.getChildAt(k)
				if(btn){
					btn.visible=false
				}
			}


            this.btn_list = [this.destroyBtn, this.guildExchangeBtn, this.guildDonateBtn];

            for (let i = 0; i < this.btn_list.length; i++) {
                let show = this.CheckIsVisible(i)     //this.show_btn_list.indexOf(i) != -1
                let child = this.btn_list[i]
                child.visible = show
                child.includeInLayout = show
            }
            if (this.CheckIsVisible(1) ) { //兑换按钮 
                this.CheckShowGuildScore(true)
                this.guild_conta.visible = true
            } else if (this.CheckIsVisible(2)) {//捐献按钮
                this.CheckShowGuildScore(false)
                this.guild_conta.visible = true
            } else {
                this.guild_conta.visible = false
            }

			RefGridLayout(this.btn_conta, {
                frist_item_space:30,
				column: 2,
				h_gap: 6,
				v_gap: 0,
				item_w: 131,
				item_h: 65
			})
        }

        //结社积分
        this.CheckShowGuildScore = (is_color: boolean) => {
            let config_guild_depot_score = ResManager.GetInstance().GetGameConfigFromCache(this, "config_guild_depot_score", false)
            let cfg = guild_model.GetDepotScoreCfgByTypeID(this.type_id, this.equip_attr, config_guild_depot_score)
            if (cfg) {
                let score_cost = this.goods_vo.goods_id==1?5000: cfg.score_cost
                if (is_color) {
                    let score = guild_model.GetDepotScore()
                    let color = score >= score_cost ? local_Enum_ColorUtil_Dark.WHITE : local_Enum_ColorUtil_Dark.RED
                    this.guild_score.innerHTML = local_Util.StrToHTML(`积分：${local_Util.HtmlColorTxt(score_cost, color)}`)
                } else {
                    this.guild_score.innerHTML = `积分：${score_cost}`
                }
            } else {
                this.guild_score.innerHTML = ""
            }
        }
        		/**公会兑换支线引导 */
		this.ShowTaskExchangeArrow = () => {
			if (!this.task_model.IsHasBranchTask(TaskModel.GuildExchangeTaskId)) {
				return
			}
			if (!this.story_model.task_supplement_list["GuildDonateTaskId"]) return
			if (!this.task_model.IsAllStepFinish(TaskModel.GuildExchangeTaskId)) {
				let step = this.task_model.GetBranchTaskCfg(TaskModel.GuildExchangeTaskId, 3)
				if (step) {
					GlobalEventSystem.Fire(EventName.SHOW_FINGER, this, this.guildExchangeBtn, "Main", null, null, null, null, step, true)
    }
			}
		}

    }
	CheckIsVisible(i:number):boolean{
		return Util.TableContains(this.show_btn_list, i)
	}



}
window["GuildExchangeTips"] = GuildExchangeTips