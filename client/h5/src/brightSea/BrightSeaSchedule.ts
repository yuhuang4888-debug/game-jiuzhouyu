import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { BrightSeaModel } from "../commonModel/BrightSeaModel"
import { SetHtmlCenter, SetHtmlStyle, Util } from "../util/Util"
import { BrightSeaSchItem } from "./BrightSeaSchItem"

export class BrightSeaSchedule extends BaseView1 {
    InitView
    click_bg_toClose
    destroy_imm
    is_center
    preload_server_config
    serverGp
    use_background
    server_loop_mgr 
    //require("game.brightSea.BrightSeaSchItem")
    public constructor() {
        super()

        this.base_file = "brightSea"
        this.layout_file = "BrightSeaSchedule"
        this.layer_value = Enum_UILayer.Activity
        this.destroy_imm = true
        this.is_center = true
        this.use_background = true
        this.click_bg_toClose = true
        let local_util = Util
        this.preload_server_config = { "config_sea_treasure_mod": false }
        let server_loop_list = null
        this.server_loop_mgr = null
        this.load_callback = () => {
            SetHtmlStyle(this._html_desc, { f: 22, c: "#663915",a:"center",w:400,li:15,ww:false})
			SetHtmlStyle(this._html_desc2, { f: 20, c: "#663915", ww:false })
            this.InitView()
        }

        this.destroy_callback = () => {
			if (this.server_loop_mgr) {
				this.server_loop_mgr.DeleteMe()
				this.server_loop_mgr = null
			}
		}
        //this.preload_server_config = [config_territory_mode = false]
        this.InitView = () => {
            let data = BrightSeaModel.GetInstance().serInfo
            Util.AddClickEvent(
                this._img_close, () => {
                    this.Close()
                },
                this,
                true
            )
            //console.log("___________data")
            //PrintTable(data)
            var CompareSerNum = (cfg_ser_num, ser_num, is_un_satisfy) => {
                if (cfg_ser_num && ser_num) {
                    if (is_un_satisfy) {
                        return cfg_ser_num == ser_num
                    } else {
                        return cfg_ser_num > ser_num
                    }
                }
                return false
            }
            let is_un_satisfy = false
            if (data && data.un_satisfy && data.un_satisfy.length > 0) {
                server_loop_list = data.un_satisfy
                is_un_satisfy = true
            } else {
                if (data) {
                    server_loop_list = data.enemy
                }
            }
            if (server_loop_list) {
                this.server_loop_mgr = new LoopScrowViewMgr()
                this.server_loop_mgr.SetData(this._list_item, BrightSeaSchItem, server_loop_list,LoopScrCon.Vertical)

                let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_sea_treasure_mod", false)// Config.Seatreasuremod
                let showModelNum = 2
                let modelNum

                let is_open_next = true
                if (data && data.treasure_mod && cfg[data.treasure_mod] && cfg[data.treasure_mod].ser_num) {
                    showModelNum = cfg[data.treasure_mod].ser_num
                    let next_mode_id = data.treasure_mod + 1
                    if (!cfg[next_mode_id]) {
                        is_open_next = false
                    }
                }

                if (is_un_satisfy) {
                    if (data.un_satisfy_mod && cfg[data.un_satisfy_mod]) {
                        modelNum = cfg[data.un_satisfy_mod].ser_num
                    }
                } else {
                    if (data.treasure_mod && cfg[data.treasure_mod]) {
                        modelNum = cfg[data.treasure_mod].ser_num
                    }
                }
                let str = ""
                if (!is_open_next) {
                    str = "暂未开放下一阶段跨服模式，敬请期待！<br>"
                }
                else if (cfg) {
                    for (let key = 0; key < cfg.length; key++) {

                        if (CompareSerNum(cfg[key].ser_num, modelNum, is_un_satisfy)) {
                            //if (data.un_satisfy_wlv > cfg[key].wlv_max ) {
                            //    str = "暂未开放下一阶段跨服模式，敬请期待！\n"
                            //}else{
                            showModelNum = cfg[key].ser_num
                            let level = (cfg[key].wlv_min > 370 && ("神创" + (cfg[key].wlv_min - 370)) || (cfg[key].wlv_min))
                            str = "当跨服世界等级达到<font color='#0a953e'>" + level + "级</font>后开启<font color='#0a953e'>" + cfg[key].name + "</font><br>"
                            //}
                            break
                        }
                    }
                }
                let wlv = data.un_satisfy_wlv < 1 && data.wlv || data.un_satisfy_wlv
                let level = wlv > 370 && "神创" + (wlv - 370) || wlv
                str = str + "(当前" + (showModelNum == 1 && ("本") || (showModelNum)) + "服跨服世界等级为<font color='#0a953e'>" + level + "级</font>)"
                this._html_desc.innerHTML = Util.StrToHTML(str)
                this._html_desc2.innerHTML = Util.StrToHTML("每日<font color='#0a953e'>4:00</font>刷新服务器分区状态模式")
                //SetHtmlCenter(this.Lb1,{x:30,w:this.display_obj.width-60})

            }
        }
    }


    public DeleteMe() {
        super.DeleteMe()
    }


_img_bg:Laya.Image
_img_close:Laya.Image
_img_tips:Laya.Image
_img_bg2:Laya.Image
_html_desc:Laya.HTMLDivElement
_html_desc2:Laya.HTMLDivElement
_list_item:Laya.List
public GetComponents() {
[
this._img_bg,
this._img_close,
this._img_tips,
this._img_bg2,
this._html_desc,
this._html_desc2,
this._list_item,
]
 = this.GetChildrenByNames([

"_img_bg",
"_img_close",
"_img_tips",
"_img_bg2",
"_html_desc",
"_html_desc2",
"_list_item",
])
}
}
 window["BrightSeaSchedule"]= BrightSeaSchedule