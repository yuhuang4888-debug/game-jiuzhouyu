import { BaseView1 } from "../common/BaseView1";
import { Enum_UILayer } from "../common/LayerManager";
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr";
import { ResManager } from "../common/ResManager";
import { DsgtModel } from "../commonModel/DsgtModel";
import { MarriageEvent, MarriageModel } from "../commonModel/MarriageModel";
import { GameResPath } from "../util/GameResPath";
import { Util } from "../util/Util";
import { MarriageDsgtItem } from "./MarriageDsgtItem";

//伴侣-称号界面
export class MarriageDsgtView extends BaseView1 {

    LoadSuccess
    InitEvent
    UpdateView
    UpdateItems
    SetDsgtDataList
    GetDsgtDataList
    GetDsgtFirstlockData
    loop_mgr: LoopScrowViewMgr
    public constructor() {
        super()
        this.base_file = "marriage"
        this.dependent_res = ["marriage2"]
        this.layout_file = "MarriageDsgtView"
        this.layer_value = Enum_UILayer.Activity;
        this.is_center = true
        this.use_background = true
        this.click_bg_toClose = true
        // this.show_open_movie = true
        this.destroy_imm = true

        let _model = MarriageModel.GetInstance(),
            res_mgr = ResManager.GetInstance(),
            local_MarriageEvent = MarriageEvent,
            // _ac_item_: eui.ArrayCollection,
            _dsgt_data_list_

        this.load_callback = function () {
            ResManager.GetInstance().SetOutsideImageSprite(this, this._Image1, GameResPath.GetIcon("marriage", "ui_marry_10"))
            this.LoadSuccess()
            this.InitEvent()
        }
        this.preload_server_config = {
            "config_love_dsgt_cfg": false
        }

        this.destroy_callback = function () {
            if (this.loop_mgr) {
                this.loop_mgr.DeleteMe()
                this.loop_mgr = null
            }
        }

        this.LoadSuccess = () => {
            this._list.scrollBar.visible = false
            // res_mgr.SetTexture(this, this._img_005c, "resource/game/marriage/texture/uijh_005c.jpg")
            // res_mgr.SetTexture(this, this._img_040, "resource/game/marriage/texture/uijh_040.png")
            // res_mgr.SetTexture(this, this._img_progress, "resource/game/marriage/texture/uijh_050.png")


            //为了不频繁加载特效，且数据不多，所以不采用虚拟布局
            // _ac_item_ = new eui.ArrayCollection()
            // this._list.dataProvider = _ac_item_
            // this._list.itemRenderer = MarriageDsgtItem
            // this._list.useVirtualLayout = false

            var expMask_: Laya.Sprite;
            expMask_ = new Laya.Sprite();
            expMask_.graphics.drawRect(0, 0, this._img_progress.width, this._img_progress.height + 2, "#ffffff");
            expMask_.pos(0, 0);
            this._img_progress.mask = expMask_

            // let mask = new egret.Rectangle(0, 0, this._img_progress.width, this._img_progress.height)
            // this._img_progress.mask = mask

            this.SetDsgtDataList()
            this.UpdateView()
        }

        this.InitEvent = () => {
            Util.AddClickEvent(this._btn_close, () => {
                this.Close()
            }, this, true)

            this.BindVar(_model, "_mate_info", () => {
                this.UpdateView()
            })

            this.BindEvent(_model, local_MarriageEvent.CHANGE_KEY_VALUE, (key, val) => {
                if (key != 1) return
                this.UpdateView()
            })

            this.BindEvent(_model, local_MarriageEvent.UPDATE_DSGT, () => {
                this.UpdateView()
            })
        }

        this.UpdateView = () => {
            let mate_info = _model.GetMateInfo()
            if (!mate_info) return
            let data = this.GetDsgtFirstlockData()
            this._lb_progress.text = data ? `${mate_info.love_num}/${data.love_num}` : "MAX"
            // this._img_progress.mask.width = data ? mate_info.love_num / data.love_num * this._img_progress.width : this._img_progress.width
            let width = data ? mate_info.love_num / data.love_num * this._img_progress.width : this._img_progress.width
            this._img_progress.mask.graphics.clear()
            this._img_progress.mask.graphics.drawRect(0, 0, width, this._img_progress.height + 2, "#ffffff");


            let list = this.GetDsgtDataList()
            this.UpdateItems(list)

            //检查配置错误导致称号不激活
            if (data && mate_info.love_num >= data.love_num) {
                _model.Fire(local_MarriageEvent.REQUEST_PROTO, 17236, "c", data.id)
            }
        }

        this.UpdateItems = (list) => {
            // _ac_item_.source = list
            if (!this.loop_mgr) {
                this.loop_mgr = new LoopScrowViewMgr()
                this.loop_mgr.SetData(this._list, MarriageDsgtItem, list, LoopScrCon.Vertical, undefined)
            } else {
                this.loop_mgr.replaceAll(list)
            }
        }

        this.SetDsgtDataList = () => {
            let config = res_mgr.GetGameConfigFromCache(this, "config_love_dsgt_cfg", false)
            _dsgt_data_list_ = []
            let tag_dic = {}
            let dic = config
            let _dsgt_max_love_num = 0
            for (let key in dic) {
                if (_dsgt_max_love_num < dic[key].love_num) {
                    _dsgt_max_love_num = dic[key].love_num
                }
                _dsgt_data_list_.push(dic[key])
            }
            _dsgt_data_list_.sort((a, b) => {
                return a.love_num - b.love_num
            })
        }

        //获取称号数据列表
        this.GetDsgtDataList = () => {
            return _dsgt_data_list_
        }

        this.GetDsgtFirstlockData = () => {
            let dic = DsgtModel.GetInstance().GetDsgtInfoVo()
            let list = this.GetDsgtDataList()
            for (let info of list) {
                if (dic[info.dsgt] && dic[info.dsgt].status != 0) continue
                return info
            }
        }
    }

    _Image1: Laya.Image
    _Image31: Laya.Image
    _Image3: Laya.Image
    _btn_close: Laya.Image
    _Image4: Laya.Image
    _Scroller1: Laya.Panel
    _list: Laya.List
    _Image7: Laya.Image
    _Group1: Laya.Box
    _Image8: Laya.Image
    _img_progress: Laya.Image
    _lb_progress: Laya.Label
    _Label1: Laya.Label
    public GetComponents() {
        [
            this._Image1,
            this._Image31,
            this._Image3,
            this._btn_close,
            this._Image4,
            this._Scroller1,
            this._list,
            this._Image7,
            this._Group1,
            this._Image8,
            this._img_progress,
            this._lb_progress,
            this._Label1,
        ]
            = this.GetChildrenByNames([

                "_Image1",
                "_Image31",
                "_Image3",
                "_btn_close",
                "_Image4",
                "_Scroller1",
                "_list",
                "_Image7",
                "_Group1",
                "_Image8",
                "_img_progress",
                "_lb_progress",
                "_Label1",
            ])
    }
}
window["MarriageDsgtView"] = MarriageDsgtView