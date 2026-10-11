import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer, LayerManager } from "../common/LayerManager"
import { TeamModel, TeamEvent } from "../commonModel/TeamModel"
import { Util, GetSizeDeltaY, GetLocalPositionX, GetLocalPositionY, SetSizeDeltaY, SetLocalPositionY } from "../util/Util"

export class TeamSmallDescView extends BaseView1 {
    click_bg: Laya.Box
    con: Laya.Box
    bg: Laya.Image
    arrow: Laya.Image
    desc: Laya.HTMLDivElement



    InitEvent
    InitView
    LoadSuccess
    Local_Open
    destroy_callback
    destroy_imm
    open_callback

    public constructor() {
        super()

        let local_Util = Util
        let pos_ = null
        let content_ = null
        let need_adaptation_view = null
        let desc_y_ = null
        let bg_height_ = null
        let arrow_y_ = null
        let arrow_x_ = null
        this.base_file = "team"
        this.layout_file = "TeamSmallDescView"
        this.layer_value = Enum_UILayer.Activity
        this.destroy_imm = true
        this.load_callback = () => {

            this.LoadSuccess()
            this.InitEvent()
        }

        this.open_callback = () => {
            this.InitView()
        }

        this.destroy_callback = () => {
        }

        this.Local_Open = (...new_args) => {
            let parms = new_args
            // pos_, content_ = parms[1], parms[2]
            pos_ = parms[0]
            content_ = parms[1]
            need_adaptation_view = parms[2]
            super.Open()
        }

        this.LoadSuccess = () => {
            bg_height_ = GetSizeDeltaY(this.bg)
            desc_y_ = this.desc.y
            arrow_x_ = GetLocalPositionX(this.arrow)
            arrow_y_ = GetLocalPositionY(this.arrow)
        }

        this.InitEvent = () => {
            let close_fun = () => {
                this.Close()
            }

            Util.AddClickEvent(this.click_bg, close_fun, this)
            this.BindEvent(TeamModel.GetInstance(), TeamEvent.TEAM_VIEW_IS_CLOSE, close_fun)
        }

        this.InitView = () => {
            if (content_) {
                this.desc.width=324
                this.desc.innerHTML = local_Util.StrToHTML(content_)
                if (this.desc.contextHeight > bg_height_ - desc_y_ * 2) {
                    this.bg.height = this.desc.contextHeight + desc_y_ * 2
                }
                this.arrow.y = this.bg.height+18//arrow_y_ + (this.bg.height - bg_height_)
                if (pos_) {
                    let stage_width = LayerManager.GetInstance().stageWidth
			        // let stage_height = LayerManager.GetInstance().stageHeight
                    //ΩÁ√Êµƒ  ≈‰
                    if(need_adaptation_view){
                        let delta = stage_width - pos_.x
                        if(delta < this.con.width){
                            this.con.x = pos_.x - this.con.width
                        }else{
                            this.con.x = pos_.x - arrow_x_ - 10
                        }
                    }else{
                        this.con.x = pos_.x - arrow_x_ - 10
                    }
                    this.con.y = pos_.y - (this.bg.height + this.arrow.height)
                }
            }
        }
    }

    public Open(...new_args) {

        this.Local_Open(...new_args)
    }


    public GetComponents() {
        [
            this.click_bg,
            this.con,
            this.bg,
            this.arrow,
            this.desc,
        ]
            = this.GetChildrenByNames([

                "click_bg",
                "con",
                "bg",
                "arrow",
                "desc",
            ])
        this.desc.style.fontSize=24
        this.desc.style.color="#4a3a32"
    }
}
window["TeamSmallDescView"]=TeamSmallDescView