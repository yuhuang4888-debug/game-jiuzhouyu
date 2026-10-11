import { BaseItem1 } from "../common/BaseItem1"
import { CustomActivityModel } from "../commonModel/CustomActivityModel"
import { Config } from "../common/Config"
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine"
import { GameResPath } from "../util/GameResPath"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { DailyLogInItem } from "./DailyLogInItem"
import { TimeUtil } from "../util/TimeUtil"
import { ErlangParser } from "../util/ErlangParser"
import { CongratulationObtainView } from "../common/CongratulationObtainView"
import { GlobalTimerQuest } from "../util/Util"

export class DailyLogInView extends BaseItem1 {
    _img_top_title: Laya.Image
    _gp_time: Laya.Box
    _lb_time: Laya.Label
    _scroller: Laya.Panel
    content: Laya.VBox
    InitView
    InitEvent
    LoadSuccess
    Local_DeleteMe
    Settime
    UpdateView
    CreateItem
    data
    info
    item_group_1
    StartCountTime
    CancelCountTime
    public constructor(parent?) {
        super(parent)


        this.base_file = "dailylogin"
        this.layout_file = "DailyLogInView"
        this.is_load_res = false
        let model = CustomActivityModel.GetInstance()
        this.item_group_1=[]
        let local_CustomActivityDefine = CustomActivityDefine
        let cfg_ = null
        let base_type_ = Config.PRELOAD_CLIENT_CONFIG.ConfigCustomActivity.ACT_ID.DAILY_LOGIN
        let show_id_ = 0
        let sub_type_ = 1
        let time_func_
        let time_id_
        let timer=null
        this.preload_server_config = {

        }
        this.load_callback = () => {
            this.LoadSuccess()

        }

        this.InitEvent = () => {

            this.BindEvent(model, CustomActivityDefine.EVENT.UPDATE_VIEW, (base_type?, sub_type?) => {
                if (this.use_delete_method) { return }
                if (this.info && this.info.base_type == base_type && this.info.sub_type == sub_type) {
                    this.UpdateView()
                }
            })
            let GetReward = (...new_args) => {
				let args = new_args
				if (this.info.base_type == args[0] && this.info.sub_type == args[1]) {
					let data = []
					let info = args[3]
					let reward = model.GetActReward(this.info.base_type, this.info.sub_type, info.form_type, info.reward)
					if (reward.length > 0) {
						let view = new CongratulationObtainView(reward, 10)
						view.Open()
					}
					this.UpdateView()
				}
			}

			this.BindEvent(model, local_CustomActivityDefine.EVENT.ANSWER_TARGET, GetReward)
        }


        this.LoadSuccess = () => {
            ResManager.GetInstance().SetTexture(this,this._img_top_title,GameResPath.GetIcon("dailylogin","uimrbj_004"))
            this.data=model.GetActData(this.info.base_type, this.info.sub_type)
            model.CloseACTRed(this.info.base_type, this.info.sub_type)
            if(!this.data){
                return
            }
            this.Settime()
            this.InitEvent()
            this.UpdateView()
        }



        this.UpdateView = () => {
            this.data=model.GetActData(this.info.base_type, this.info.sub_type)
            if(this.item_group_1.length > 0 ){
                for( let key in this.item_group_1 ){
                    var item = this.item_group_1[key]
                    item.DeleteMe()
                }
                this.item_group_1=[]
            }
            let server_time=TimeUtil.getServerTime()
            let now_day= Math.floor( (server_time - this.info.stime) / (3600 * 24)) + 1
            let reward_list_=this.data.reward_list

            if (reward_list_.length <= 0) {
				return
			}else{
                
                let temp_reward_list=[]
                let count=0
                for ( let i = reward_list_.length-1 ; i>=0 ; i--){
                    temp_reward_list[count] =reward_list_[i]
                    count++
                }
                reward_list_=temp_reward_list
            }
			for (let index in reward_list_) {
                let day = reward_list_[index].name
                let condition_list = ErlangParser.GetInstance().Parse(reward_list_[index].condition)
                day=day.replace("第","")
                day = day.replace("天","")
                if(now_day == Number(day) || (now_day+1 == Number(day) && condition_list[1][1] == "0" )){
                    let item = this.item_group_1[index]
                    if (!item) {
                        item = new DailyLogInItem(this.content)
                        item.Load()
                        table.insert(this.item_group_1, item)
                    }
                    let callback = () => {
                        item.visible = true
                        item.setData(reward_list_[index], this.data.base_type, this.data.sub_type,undefined,now_day)
                    }

                    item.ExcuteCallback(callback)
                }
            }
        }

        this.Settime = (end_time?) => {
            // if(timer){
            //     timer.DeleteMe()
            //     timer = null
            // }
            // timer=model.LoadActTimer(this._gp_time,this.info.etime,20,"#00fa64", null, "#ffffff", "活动剩余时间：")
            this.StartCountTime(() => {
				let time = 3600* 24 -TimeUtil.timeHMS(TimeUtil.getServerTime()* 1000)
				if (time < 0) {
					this.CancelCountTime()
					return
				}
				this._lb_time.text = TimeUtil.timeConvert(time, "hh-mm-ss2")
			}
				, 1)
        }

        this.StartCountTime = (func?, time?) => {
			this.CancelCountTime()
			time_func_ = func
			time_id_ = GlobalTimerQuest.AddPeriodQuest(func, time, -1)
			func()
		}
        this.CancelCountTime = ()=> {
            if (time_id_) {
				GlobalTimerQuest.CancelQuest(time_id_)
				time_func_ = null
				time_id_ = null
			}
        }

        this.Local_DeleteMe = () => {
          this.CancelCountTime()
            if(timer){
                timer.DeleteMe()
                timer = null
            }
            if(this.item_group_1.length > 0 ){
                for( let key in this.item_group_1 ){
                    var item = this.item_group_1[key]
                    item.DeleteMe()
                }
                this.item_group_1=[]
            }
        }
    }

    public CustomMehod(index?,info?){
        this.info=info
    }
    
    public DeleteMe() {

        this.Local_DeleteMe()
        super.DeleteMe()
    }


    public GetComponents() {
        [
            this._img_top_title,
            this._gp_time,
            this._scroller,
            this.content,
            this._lb_time
     
        ]
            = this.GetChildrenByNames([

                "_img_top_title",
                "_gp_time",
                "_scroller",
                "content",
                "_lb_time"

            ])
        this._scroller.vScrollBar.visible=false
    }
}
window["DailyLogInView"]=DailyLogInView