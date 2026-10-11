import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { WordManager } from "../common/WordManager"
import { GoodsModel } from "../commonModel/GoodsModel"
import { OnHookModel } from "../commonModel/OnHookModel"
import { RoleManager } from "../commonModel/RoleManager"
import { Util } from "../util/Util"
import { OnHookAdditionItem } from "./OnHookAdditionItem"

export class OnHookAdditionView extends BaseView1 {
    static NeedCheckGoodTypeId = {
        //一倍经验符
        37020001:true, 
        //二倍经验符
        37020002:true
    }


    _img_top_title: Laya.Image
    _gp_time: Laya.Box
    _lb_time: Laya.Label
    _scroller: Laya.Panel
    content: Laya.VBox

    loop_mgr
    InitView
    InitEvent
    LoadSuccess
    Local_DeleteMe
    UpdateView
    data


    

    public constructor() {
        super()


        this.base_file = "onHook"
        this.layout_file = "OnHookAdditionView"
        this.is_load_res = false
        this.layer_value = Enum_UILayer.Activity
        this.use_background = true
        this.click_bg_toClose = true
        this.is_center = true
        this.show_open_movie = true
        this.destroy_imm = true
        this.append_to_ctl_queue = true;
        let model = OnHookModel.GetInstance()


        this.preload_client_config = {
            "ClientOnHookInfo": false
        }
        this.load_callback = () => {
            this.InitEvent()
            this.LoadSuccess()

        }

        this.close_callback = () => {
            this.Local_DeleteMe()
        }

        this.InitEvent = () => {
            Util.AddClickEvent(this._img_close, () => {
                this.Close()
            }, this, true)

            this.BindEvent(model, OnHookModel.UPDATE_ADDITION_VIEW, (scmd?) => {
                this.UpdateView(scmd)
            })

            this.BindEvent(model,OnHookModel.CLOSE_ALL_VIEW,()=>{
                this.Close()
            })

            this.BindEvent(model,OnHookModel.CLOSE_ONHOOK_TIPS,()=>{
                this.Close()
            })

            this.BindEvent(GoodsModel.GetInstance(), GoodsModel.UPDATE_GOODS_NUM, (goods_list?) => {
                if (this.use_delete_method) {
                    return
                }
                for (let _tmpi in goods_list) {
                    var info = goods_list[_tmpi]
                    if (OnHookAdditionView.NeedCheckGoodTypeId[info.type_id]) {
                        model.Fire(OnHookModel.REQUEST_PROTO, 13217)
                        break
                    }
                }
            })
        }


        this.LoadSuccess = () => {
            model.Fire(OnHookModel.REQUEST_PROTO, 13217)
        }



        this.UpdateView = (scmd) => {
            let roleVo = RoleManager.GetInstance().GetMainRoleVo()
            let lv = roleVo.worldLv > 370 && "神创" + (roleVo.worldLv - 370) || roleVo.worldLv
            let all_add = 0
            for (let key in scmd.exp_list) {
                if (scmd.exp_list[key] && scmd.exp_list[key].ratio) {
                    all_add += scmd.exp_list[key].ratio
                }
            }
            this.lb_1.innerHTML = "当前经验加成：<font color= '#0a953e'>" + (all_add / 100) + "%</font>"
            this.lb_2.innerHTML = "世界等级加成：<font color= '#0a953e'>" + roleVo.worldLvExp + "</font>%"
            this.lb_3.innerHTML = "当前经验效率：<font color= '#0a953e'>" + WordManager.ConvertNum(model.exp_effect, true) + "/分</font>"
            this.lb_4.innerHTML = "当前世界等级：<font color= '#0a953e'>" + lv + "</font>"
            let data =Object.assign({}, ResManager.GetInstance().GetGameConfigFromCache(this, "ClientOnHookInfo").addition)
            let temp_data = []
            for (let key in data) {
                for (let _ in scmd.exp_list) {
                    if (data[key].type == scmd.exp_list[_].type) {
                        data[key]["real_numb"] = scmd.exp_list[_].ratio
                        data[key]["end_time"] = scmd.exp_list[_].end_time
                        temp_data.push(data[key])
                    }
                }
            }
            if (!this.loop_mgr) { 
                this.loop_mgr = new LoopScrowViewMgr();
                this.loop_mgr.SetData(this.gp_item, OnHookAdditionItem, temp_data, LoopScrCon.Vertical)
            } else {
                this.loop_mgr.replaceAll(temp_data)
            }
        }

        this.Local_DeleteMe = () => {
            if (this.loop_mgr) {
                this.loop_mgr.DeleteMe()
                this.loop_mgr = null
            }
        }
    }
    

    public DeleteMe() {
        super.DeleteMe()
    }

    bg: Laya.Image
    _img_bg_1: Laya.Image
    gp_item: Laya.List
    _img_close: Laya.Image
    _img_title_bg: Laya.Image
    lb_1: Laya.HTMLDivElement
    lb_2: Laya.HTMLDivElement
    lb_3: Laya.HTMLDivElement
    lb_4: Laya.HTMLDivElement
    _lb_tile: Laya.Label
    public GetComponents() {
        [
            this.bg,
            this._img_bg_1,
            this.gp_item,
            this._img_close,
            this._img_title_bg,
            this.lb_1,
            this.lb_2,
            this.lb_3,
            this.lb_4,
            this._lb_tile,
        ]
            = this.GetChildrenByNames([

                "bg",
                "_img_bg_1",
                "gp_item",
                "_img_close",
                "_img_title_bg",
                "lb_1",
                "lb_2",
                "lb_3",
                "lb_4",
                "_lb_tile",
            ])
        this.lb_1.style.fontSize = 20
        this.lb_1.style.color = '#663915'
        this.lb_1.style.wordWrap = false
        this.lb_2.style.fontSize = 20
        this.lb_2.style.color = '#663915'
        this.lb_2.style.wordWrap = false
        this.lb_3.style.fontSize = 20
        this.lb_3.style.color = '#663915'
        this.lb_3.style.wordWrap = false
        this.lb_4.style.fontSize = 20
        this.lb_4.style.color = '#663915'
        this.lb_4.style.wordWrap = false
    }
}
window["OnHookAdditionView"] = OnHookAdditionView