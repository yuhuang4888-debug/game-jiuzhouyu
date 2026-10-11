import { BaseView1 } from "../common/BaseView1";
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr";
import { ResManager } from "../common/ResManager";
import { table } from "../common/table";
import { CustomActivityDefine } from "../commonModel/CustomActivityDefine";
import { CustomActivityModel } from "../commonModel/CustomActivityModel";
import { GameResPath } from "../util/GameResPath";
import { Util } from "../util/Util";
import { KfGBRecordItem } from "./KfGBRecordItem";


export class KfGBRecordView extends BaseView1 {
    InitEvent
    InitView
    CancelAniTimer
    StarAni
    PlayAni
    StarAniTimer
    StarStopTimer
    CancelStopTimer
    DestroyCallback
    LoadSucess
    UpDataRecordItem
    loop_ScrowMgr

    public constructor() {
        super()
        this.base_file = "kfGroupBuy"
        this.layout_file = "KfGBRecordView"
        this.is_load_res = false
        this.is_center = true
        this.show_open_movie = true
        this.use_background = true
        this.click_bg_toClose = true

        let act_model = CustomActivityModel.GetInstance(),
            local_Event = CustomActivityDefine.EVENT,
            ani_timer,
            stop_ani_timer,
            base_type,
            sub_type,
            info
        this.loop_ScrowMgr = null

        this.load_callback = () => {
            this.InitEvent()
            this.LoadSucess()
        }

        this.LoadSucess = () => {
            ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIconOtherPath("kfGroupBuy", "bg_03"), false)
        }

        this.open_callback = () => {
            this.InitView()
        }

        this.destroy_callback = () => {
            this.DestroyCallback()
        }

        this.InitEvent = () => {
            Util.AddClickEvent(this._img_close, () => {
                this.Close()
            }, this, true)

            this.BindEvent(act_model, local_Event.UP_LOG_LIST, (scmd) => {
                if (scmd.base_type == base_type && scmd.sub_type == sub_type) {
                    if (scmd.record_list.length > 0) {
                        let list = []
                        let _data = act_model.GetActData(base_type, sub_type)
                        let reward_dic = {}
                        if (_data.reward_list)
                            for (let v of _data.reward_list)
                                reward_dic[v.grade] = v
                        let NewList = (v, v0, time, bool) => {
                            let data = {}
                            data["role_id"] = v.role_id
                            data["role_name"] = v.role_name
                            data["server_num"] = v.server_num
                            data["time"] = time + v0.gap_time
                            let grade_data = reward_dic[v.grade_id]
                            if (grade_data) {
                                let reward = act_model.GetActReward(base_type, sub_type, grade_data.form_type, grade_data.reward)
                                data["reward"] = reward && reward[0]
                                data["is_buy"] = bool
                                list.push(data)
                            }
                        }
                        for (let v of scmd.record_list) {
                            if (v.first_buy.length > 0) {
                                for (let v0 of v.first_buy) {
                                    NewList(v, v0, v.first_buy_time, true)
                                }
                            }
                            if (v.tail_buy.length > 0) {
                                for (let v1 of v.tail_buy) {
                                    NewList(v, v1, v.tail_buy_time, false)
                                }
                            }
                        }
                        if (list.length > 0) {
                            let sort_fun = (a, b) => {
                                return a.time - b.time
                            }
                            list.sort(sort_fun)
                            this.UpDataRecordItem(list)
                        }
                    }
                }
            })
        }


        this.InitView = () => {
            if (!info) return
            base_type = info.base_type
            sub_type = info.sub_type
            act_model.Fire(local_Event.SCMD_REQUEST, 33228, base_type, sub_type)
        }

        this.UpDataRecordItem = (list)=>{
            //最新的记录放在最前面
            table.sort(list, (a?, b?)=>{
                return a.time > b.time
            })

            if(!this.loop_ScrowMgr){
                this.loop_ScrowMgr = new LoopScrowViewMgr()
                this.loop_ScrowMgr.SetData(this._gp_data, KfGBRecordItem, list, LoopScrCon.Vertical)
            }else {
                this.loop_ScrowMgr.replaceAll(list)
            }
        }

        this.Open = (...prams) => {
            let index = 0
            info = prams[index]
            super.Open()
        }

        this.DestroyCallback = () => {
            if(this.loop_ScrowMgr){
                this.loop_ScrowMgr.DeleteMe()
                this.loop_ScrowMgr = null
            }
        }
    }

    _Image1: Laya.Image
    _Group1: Laya.Box
    _Image3: Laya.Image
    _Label1: Laya.Label
    _scr_log: Laya.Panel
    _gp_data: Laya.List
    _img_close: Laya.Image
    public GetComponents() {
        [
            this._Image1,
            this._Group1,
            this._Image3,
            this._Label1,
            this._scr_log,
            this._gp_data,
            this._img_close,
        ]
        = this.GetChildrenByNames([
            "_Image1",
            "_Group1",
            "_Image3",
            "_Label1",
            "_scr_log",
            "_gp_data",
            "_img_close",
        ])
    }
}
 window["KfGBRecordView"]= KfGBRecordView