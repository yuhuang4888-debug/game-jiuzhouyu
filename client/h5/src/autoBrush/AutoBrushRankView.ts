import { updateFor } from "../../node_modules/typescript/lib/typescript"
import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { AutoBrushModel } from "../commonModel/AutoBrushModel"
import { GameResPath } from "../util/GameResPath"
import { HtmlColorTxt, Util } from "../util/Util"
import { AutoBrushRankItem } from "./AutoBrushRankItem"

export class AutoBrushRankView extends BaseView1 {

    auto_brush_model: AutoBrushModel
    res_mgr: ResManager

    item_loop_mgr:LoopScrowViewMgr
    public constructor() {
        super()
        this.base_file = "autoBrush"
        this.layout_file = "AutoBrushRankView"
        this.layer_value = Enum_UILayer.Activity

        this.use_background = true
        this.click_bg_toClose = true
        this.is_center = true
        this.show_open_movie = true

        this.auto_brush_model = AutoBrushModel.GetInstance()
        this.res_mgr = ResManager.GetInstance()

        this.load_callback = function () {
            this.LoadSuccess()
        }

        this.destroy_callback = function () {
            this.Remove()
        }
    }

    LoadSuccess() {
        //resource/game/autoBrush/other/ui_activity_06.png
        this.res_mgr.SetTexture(this, this._img_bg, GameResPath.GetIconOtherPath("autoBrush", "ui_activity_06"))

        this._list_item.vScrollBarSkin = ""

        this._html_my_rank.style.color = "#763320"
        this._html_my_rank.style.fontSize = 20
        this._html_my_rank.style.wordWrap = false


        this._html_my_level.style.color = "#763320"
        this._html_my_level.style.fontSize = 20
        this._html_my_level.style.wordWrap = false

        this.InitEvent()
        this.UpdateView()

        this.auto_brush_model.Fire(AutoBrushModel.REQUEST_PROTO_EVENT, 13301)//请求排行榜
    }

    InitEvent() {
        Util.AddClickEvent(this._img_close, () => {
            this.Close()
        }, this, true)

        this.BindEvent(this.auto_brush_model, AutoBrushModel.UPDATE_RANK, () => {
            this.UpdateView()
        })
    }

    UpdateView() {
        let rank_data = this.auto_brush_model.GetRankData()
        if (rank_data && rank_data.length > 0) {
            this._lb_none.visible = false
            this._list_item.visible = true


            if (! this.item_loop_mgr ) {
				this.item_loop_mgr =  new LoopScrowViewMgr()
				this.item_loop_mgr.SetData(this._list_item, AutoBrushRankItem, rank_data ,LoopScrCon.Vertical, 1)
			}else{
				this.item_loop_mgr.replaceAll(rank_data)
			}

            let my_rank = this.auto_brush_model.GetMyRank()
            let local_rank
            if(my_rank && my_rank > 0){
                local_rank = `第${my_rank}名`
            }
            else{
                local_rank = "未上榜"
            }

            this._html_my_rank.innerHTML = `我的排名:${HtmlColorTxt(local_rank, "'#fe1a1a'")}`


            let my_level = this.auto_brush_model.GetLevel()
            let local_level
            if(my_level && my_level > 0){
                local_level = `${my_level}关`
            }
            else{
                local_level = "暂未通关"
            }

            this._html_my_level.innerHTML = `我的关数:${local_level}`
            
        }
        else {
            this._lb_none.visible = true
            this._list_item.visible = false
        }
    }

    Remove() {
        if(this.item_loop_mgr){
            this.item_loop_mgr.DeleteMe()
            this.item_loop_mgr = undefined
        }
    }
    _img_bg: Laya.Image
    _img_bg2: Laya.Image
    _img_bg3: Laya.Image
    _img_bg4: Laya.Image
    _img_close: Laya.Image
    _lb_title: Laya.Label
    _lb_title2: Laya.Label
    _lb_title3: Laya.Label
    _lb_title4: Laya.Label
    _lb_none: Laya.Label
    _list_item: Laya.List
    _html_my_rank: Laya.HTMLDivElement
    _html_my_level: Laya.HTMLDivElement
    public GetComponents() {
        [
            this._img_bg,
            this._img_bg2,
            this._img_bg3,
            this._img_bg4,
            this._img_close,
            this._lb_title,
            this._lb_title2,
            this._lb_title3,
            this._lb_title4,
            this._lb_none,
            this._list_item,
            this._html_my_rank,
            this._html_my_level,
        ]
            = this.GetChildrenByNames([

                "_img_bg",
                "_img_bg2",
                "_img_bg3",
                "_img_bg4",
                "_img_close",
                "_lb_title",
                "_lb_title2",
                "_lb_title3",
                "_lb_title4",
                "_lb_none",
                "_list_item",
                "_html_my_rank",
                "_html_my_level",
            ])
    }
}
window["AutoBrushRankView"] = AutoBrushRankView