import { BaseAwardItem } from "../common/BaseAwardItem"
import { BaseView1 } from "../common/BaseView1"
import { DragonBallTooltips } from "../common/DragonBallTooltips"
import { Enum_UILayer } from "../common/LayerManager"
import { DragonBallModel } from "../commonModel/DragonBallModel"
import { GoodsModel } from "../commonModel/GoodsModel"
import { SkillManager } from "../skill/SkillManager"
import { ColorUtil } from "../util/ColorUtil"
import { ErlangParser } from "../util/ErlangParser"
import { Util, Trim } from "../util/Util"
import { Config } from "../common/Config"
import { table } from "../common/table"


export class PlayerMessageDragonBallTips extends BaseView1 {
    model
    act_num
    num
    goods_model
    data
    dragonball_id = []
    public constructor() {
        super()
        this.base_file = "playerMessage"
        this.layout_file = "PlayerMessageDragonBallTips"
        this.layer_value = Enum_UILayer.Top
        this.destroy_imm = true
        this.use_background = true
        this.click_bg_toClose = true
        this.is_center = true
        this.is_delay_callback = false
        this.dragonball_id = [38410001, 38410002, 38410003, 38410004, 38410005, 38410006, 38410007]
        this.goods_model = GoodsModel.GetInstance()
        this.model = DragonBallModel.GetInstance()


        this.num = 7
        this.act_num = 0

        this.load_callback = () => {
            this.LoadSucess()
            this.InitEvent()
        }

        this.open_callback = () => {
            this.InitView()
        }

        this.destroy_callback = () => {
        }
    }

    public LoadSucess() {
        this.detail_scroller.vScrollBar.visible = false
        this.InitHtmlText()
    }

    public SetData(type_id?, act_num?, dragon_list?) {
    }

    public InitEvent() {
        Util.AddClickEvent(this.close_btn, () => {
            this.Close()
        }, this, true)
    }

    public InitHtmlText() {
        this.lb_detail.width = 310
        this.lb_detail.style.fontSize = 20
        this.lb_detail.style.color = "#783528"
        this.lb_detail.style.wordWrap = true
        this.lb_detail.style.leading = 5
    }

    public InitView() {
        let index, skill_id, skill_lv
        let skill_info, skill_vo, skill_desc
        let num = 1
        let str = ""
        let is_have_dragongball = false
        for (let key in this.dragonball_id) {
            is_have_dragongball = false
            for (let _ in this.data.ball_list) {
                if (this.dragonball_id[key] == this.data.ball_list[_].dragon_ball_id) {
                    is_have_dragongball = true
                    break
                }
            }
            if (!is_have_dragongball) {
                this.data.ball_list.push({ dragon_ball_id: this.dragonball_id[key], level: 0 })
            }
        }
        table.sort(this.data.ball_list,(a,b) => {
            return a.dragon_ball_id<b.dragon_ball_id
        })
        for (let k in this.data.ball_list) {
            var v = this.data.ball_list[k]
            // 获取龙珠技能信息
            skill_lv = v.level == 0 && 1 || v.level
            index = String(v.dragon_ball_id) + "@" + String(skill_lv)
            skill_info = ErlangParser.GetInstance().Parse(Config.PRELOAD_SERVER_CONFIG.config_dragon_ball[index].skill)
            skill_id = Number(skill_info[0][0])
            skill_vo = SkillManager.GetInstance().getSkill(skill_id)
            if (skill_vo) {
                skill_desc = skill_vo.getDesc(skill_lv)
            } else {
                skill_desc = "  "
            }

            if (v.level > 0) {		//  激活的状态
                str += Util.StrToHTML("<font color='#ff4f50' style='font-weight:bold;'>" + num + "." + Config.PRELOAD_CLIENT_CONFIG.ConfigDragonBallMsg[v.dragon_ball_id].name + "</font>" + "&nbsp;<font color='#639c12'>" + v.level + "级</font><br/>")
                str += Util.StrToHTML(skill_desc + "<br/><br/>")
            } else {						//  未激活状态
                str += Util.StrToHTML("<font color='#5a1c20' style='font-weight:bold;'>" + num + "." + Config.PRELOAD_CLIENT_CONFIG.ConfigDragonBallMsg[v.dragon_ball_id].name + "  " + "(未激活)</font><br/>")
                skill_desc = Util.DeleteColorTag(skill_desc)
                str += Util.StrToHTML("<font color='#5a1c20'>" + skill_desc + "</font><br/><br/>")
            }
            num = num + 1
        }
        this.lb_detail.innerHTML = str
    }

    public Open(...parms) {
        if (parms) {
            this.data = parms[0]
        }
        super.Open()
    }

    root_wnd: Laya.Box
    img_bg1: Laya.Image
    img_title: Laya.Image
    lb_name: Laya.Label
    detail_scroller: Laya.Panel
    Content: Laya.VBox
    lb_detail: Laya.HTMLDivElement
    close_btn: Laya.Image
    public GetComponents() {
        [
            this.root_wnd,
            this.img_bg1,
            this.img_title,
            this.lb_name,
            this.detail_scroller,
            this.Content,
            this.lb_detail,
            this.close_btn
        ]
            = this.GetChildrenByNames([

                "root_wnd",
                "img_bg1",
                "img_title",
                "lb_name",
                "detail_scroller",
                "Content",
                "lb_detail",
                "close_btn"
            ])
    }
}
window["PlayerMessageDragonBallTips"] = PlayerMessageDragonBallTips