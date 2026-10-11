import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { GuildFightModel } from "../commonModel/GuildFightModel"
import { Util, SetAnchoredPositionX, HtmlColorTxt, SetHtmlCenter, SetHtmlStyle } from "../util/Util"
import { GuildFightSchItem } from "./GuildFightSchItem"

export class GuildFightSchedule extends BaseView1 {
    InitView
    destroy_imm
    is_center
    preload_server_config
    serverGp
    use_background

    color_str = "'#0a953e'"
    color_str2 = "'#0a953e'"
    server_loop_mgr
    public constructor() {
        super()

        this.base_file = "guildFight"
        this.layout_file = "GuildFightSchedule"
        this.layer_value = Enum_UILayer.Activity
        this.destroy_imm = true
        this.is_center = true
        this.use_background = true
        this.click_bg_toClose = true
        let local_util = Util
        //let serArr_ = null
        let server_loop_list = null
        this.load_callback = () => {
            SetHtmlStyle(this._html_desc, { f: 22, c: "#663915",a:"center",w:400,li:15,ww:false})
			SetHtmlStyle(this._html_desc2, { f: 20, c: "#663915", ww:false })
            this.InitView()
        }

        this.preload_server_config = { "config_territory_mode": false }
        this.InitView = () => {
            let data = GuildFightModel.GetInstance().serInfo
            Util.AddClickEvent(
                this._img_close, () => {
                    this.Close()
                },this,true)
                
            if (data && data.server_list) {
                server_loop_list = data.server_list
                this.server_loop_mgr = new LoopScrowViewMgr()
                this.server_loop_mgr.SetData(this._list_item, GuildFightSchItem, server_loop_list,LoopScrCon.Vertical)

                let showModelNum = 2
                let modelNum = data.mode_num
                let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_territory_mode", false)//Config.Territorymode
                let str = null
                if (modelNum == 8) {
                    str = "暂未开放下一阶段跨服模式，敬请期待！<br>"
                    showModelNum = 8
                }
                else if (cfg) {
                    for (let key in cfg) {
                        if (cfg[key].mode_num > modelNum) {
                            if (data.avg_wlv > cfg[key].wlv) {
                                str = "暂未开放下一阶段跨服模式，敬请期待！<br>"
                            } else {
                                showModelNum = cfg[key].mode_num
                                let level = (cfg[key].wlv > 370 && ("神创" + (cfg[key].wlv - 370)) || (cfg[key].wlv))


                                str = `当跨服世界等级达到${HtmlColorTxt(level + "级", this.color_str)}后开启${HtmlColorTxt(cfg[key].mode_name, this.color_str)}<br>`
                                //str = "当跨服世界等级达到<font color=\"#439500\">" + level + "级</font>后开启<font color=\"#439500\">" + cfg[key].mode_name + "</font>\n"
                                // }
                            }
                            break
                        }
                    }
                }

                let level = (data.avg_wlv > 370 && ("神创" + (data.avg_wlv - 370)) || (data.avg_wlv))
                let server_num = showModelNum == 1 ? "本" : showModelNum//(showModelNum == 1 && ("本") || (showModelNum)
                let temp_str = `(当前${server_num}服跨服世界等级为${HtmlColorTxt(level + "级", this.color_str)}`
                str = str + temp_str 
                this._html_desc.innerHTML = Util.StrToHTML(str)
                this._html_desc2.innerHTML = Util.StrToHTML("每日<font color='#0a953e'>4:00</font>刷新服务器分区状态模式")
            }
        }


        this.destroy_callback=()=>{
            if( this.server_loop_mgr){
                this.server_loop_mgr.DeleteMe()
                this.server_loop_mgr=null
            }
        }
    }

    public DeleteMe() {
        if( this.server_loop_mgr){
            this.server_loop_mgr.DeleteMe()
            this.server_loop_mgr=null
        }
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
 window["GuildFightSchedule"]= GuildFightSchedule