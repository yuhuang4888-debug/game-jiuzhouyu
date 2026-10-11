import { BaseItem1 } from "../common/BaseItem1"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { ResManager } from "../common/ResManager"
import { RoleManager } from "../commonModel/RoleManager"
import { RefBoxChildsLayout } from "../util/Util"

export class GuildFightKillItem extends BaseItem1 {
    LoadSuccess
    SetData
    role_head


    public constructor(parent?, data?) {
        super(parent)

        let kill_data_ = null
        let need_refresh_ = null
        this.dependent_res = ["mainUI"]
        this.base_file = "guildFight"
        this.layout_file = "GuildFightKillItem"
        kill_data_ = data
        //let SetOutsideImageSprite = ResManager.GetInstance().SetOutsideImageSprite
        let roleVo = RoleManager.GetInstance().GetMainRoleVo()
        this.load_callback = () => {

            this.LoadSuccess()
        }

        this.LoadSuccess = () => {
            ResManager.GetInstance().LoadFont(this, "scene_boss", this.kill_number, null, false)
            if (kill_data_) {
                this.SetData(kill_data_)
            }
        }

        this.SetData = (scmd?) => {
            kill_data_ = scmd
            if (this.is_loaded) {
                need_refresh_ = false
                this.kill_name.text = kill_data_.role_name
                if (!this.role_head) {
                    this.role_head = new CustomHeadItem(this.kill_head)
                    this.role_head.Load()
                    this.role_head.SetActiveBg2(false)
                }
                this.role_head.SetData(kill_data_.role_id,
                    kill_data_.career,
                    null, kill_data_.picture,
                    kill_data_.picture_ver,
                    kill_data_.turn,
                    kill_data_.atter_server_id,
                    null,
                    kill_data_.lv
                )
               

                let level = roleVo.vip_flag
                this.kill_vip_flag.visible=level>0
                if(level>0){
                    ResManager.GetInstance().SetImageSprite(this, this.kill_vip_flag, "mainUI_asset", "uivip_zjm_" + level)
                }
                
                let str=kill_data_.ckill_num+""
                this.kill_number.text = str
                this.kill_number.width= str.length*25*this.kill_number.scaleX
                if (kill_data_.ckill_num > 8) {
                    ResManager.GetInstance().SetImageSprite(this, this.kill_image, "guildFight_asset", "uijhsd_kill8", true)
                } else if (kill_data_.ckill_num >= 3) {
                    ResManager.GetInstance().SetImageSprite(this, this.kill_image, "guildFight_asset", "uijhsd_kill" + kill_data_.ckill_num, true)
                }

                RefBoxChildsLayout(this._box_name,2,null,true,"center")
            } else {
                need_refresh_ = true
            }
        }

    }

    public DeleteMe() {

        if (this.role_head) {
            this.role_head.DeleteMe()
            this.role_head = null
        }
        super.DeleteMe()
    }



kill_tips_group:Laya.Box
kill_bg:Laya.Image
kill_avatar_icon:Laya.Image
kill_image:Laya.Image
kill_head:Laya.Box
_box_name:Laya.Box
kill_vip_flag:Laya.Image
kill_name:Laya.Label
kill_number:Laya.Label
_Image1:Laya.Image
public GetComponents() {
[
this.kill_tips_group,
this.kill_bg,
this.kill_avatar_icon,
this.kill_image,
this.kill_head,
this._box_name,
this.kill_vip_flag,
this.kill_name,
this.kill_number,
this._Image1,
]
 = this.GetChildrenByNames([

"kill_tips_group",
"kill_bg",
"kill_avatar_icon",
"kill_image",
"kill_head",
"_box_name",
"kill_vip_flag",
"kill_name",
"kill_number",
"_Image1",
])
}
}
 window["GuildFightKillItem"]= GuildFightKillItem