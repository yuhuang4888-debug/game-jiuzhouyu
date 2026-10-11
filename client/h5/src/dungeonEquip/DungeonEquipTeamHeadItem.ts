import { BaseItem1 } from "../common/BaseItem1"
import { CustomHeadItem } from "../common/CustomHeadItem"
import { RoleManager } from "../commonModel/RoleManager"

export class DungeonEquipTeamHeadItem extends BaseItem1 {
    need_refresh_data
    role_head
    vo

    public constructor(parent?) {
        super(parent)

        this.base_file = "dungeonEquip"
        this.layout_file = "DungeonEquipTeamHeadItem"
        this.load_callback = () => {
            this.LoadSuccess()
        }
    }

    public LoadSuccess() {


        this.InitEvent()
        if (this.need_refresh_data) {
            this.UpdateView()
            this.need_refresh_data = false
        }
    }

    public InitEvent() {

    }
    public SetData(vo?) {

        this.vo = vo
        if (this.is_loaded) {
            this.UpdateView()
        } else {
            this.need_refresh_data = true
        }
    }

    public UpdateView() {

        let is_show = this.vo.none ? true : false
        this._gp_head.visible = !is_show
        this._img_add.visible = is_show
        if (!is_show) {

            if (!this.role_head) {
                this.role_head = new CustomHeadItem(this._gp_head)
                this.role_head.SetActiveLevel(false)
                this.role_head.SetActiveBg2(false)
                this.role_head.Load()
            }
            this.role_head.SetRoleVoData(this.vo, this.vo.turn, this.vo.server_id)

        }
    }

    public DeleteMe() {

        if (this.role_head) {
            this.role_head.DeleteMe()
            this.role_head = null
        }
        super.DeleteMe()
    }


_gp_head:Laya.Box
_img_add:Laya.Image
public GetComponents() {
[
this._gp_head,
this._img_add,
]
 = this.GetChildrenByNames([

"_gp_head",
"_img_add",
])
}
}
 window["DungeonEquipTeamHeadItem"]= DungeonEquipTeamHeadItem