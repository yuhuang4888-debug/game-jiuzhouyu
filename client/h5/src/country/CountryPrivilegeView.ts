import { BaseView1 } from "../common/BaseView1"
import { Enum_UILayer } from "../common/LayerManager"
import { LoopScrCon, LoopScrowViewMgr } from "../common/LoopScrowViewMgr"
import { ResManager } from "../common/ResManager"
import { table } from "../common/table"
import { SeaHegemonyModel } from "../commonModel/SeaHegemonyModel"
import { GameResPath } from "../util/GameResPath"
import { Util } from "../util/Util"
import { PrivilegeItem } from "./PrivilegeItem"

export class CountryPrivilegeView extends BaseView1 {
    InitView
    itemArr
    public constructor() {
        super()

        this.base_file = "country"
        this.layout_file = "CountryPrivilegeView"
        this.layer_value = Enum_UILayer.Activity
        this.preload_server_config = { "config_sea_privilege": false }
        this.use_background = true
        this.click_bg_toClose = true
        let local_model = SeaHegemonyModel
        let local_modelIns = local_model.GetInstance()
        this.is_center = true
        this.load_callback = () => {

            this.InitView()
        }

        this.destroy_callback=()=>{
            if (this.itemArr) {
                this.itemArr.DeleteMe()
                this.itemArr = null
            }
        }

        this.InitView = () => {

            this.BindEvent(
                local_modelIns,
                local_model.UPDATE_PRIVI_DATA, () => {
                    let data = local_modelIns.privilegeData
                    let showList = []
                    let cfg = ResManager.GetInstance().GetGameConfigFromCache(this, "config_sea_privilege", false)//Config.Seaprivilege
                    if (data && cfg) {
                        for (let _tmpi in data.list) {
                            var vo = data.list[_tmpi]
                            // [ts2lua]cfg下标访问可能不正确
                            vo.cfg = cfg[vo.priv_id]
                            table.insert(showList, { data: vo, type: 1 })
                            table.insert(showList, { data: vo, type: 0 })
                        }

                        if (!this.itemArr) {
                            this.itemArr = new LoopScrowViewMgr()
                            this.itemArr.SetData(this.Content, PrivilegeItem, showList, LoopScrCon.Vertical)
                        } else {
                            this.itemArr.replaceAll(showList)
                        }

                    }
                }
            )
            Util.AddClickEvent(
                this.closeBtn, () => {
                    this.Close()
                },
                this,
                true
            )
            local_modelIns.Fire(local_model.REQUEST_PROTO, 18651)
        }
    }

    public DeleteMe() {


        super.DeleteMe()
    }


    bg: Laya.Image
    closeBtn: Laya.Image
    _Image2: Laya.Image
    _Image4: Laya.Image
    Content: Laya.List
    _Label1: Laya.Label
    _Label2: Laya.Label
    _Label3: Laya.Label
    _Label4: Laya.Label
    _Image2_title: Laya.Image
    _lb_win_name: Laya.Label
    public GetComponents() {
        [
            this.bg,
            this.closeBtn,
            this._Image2,
            this._Image4,
            this.Content,
            this._Label1,
            this._Label2,
            this._Label3,
            this._Label4,
            this._Image2_title,
            this._lb_win_name,
        ]
            = this.GetChildrenByNames([

                "bg",
                "closeBtn",
                "_Image2",
                "_Image4",
                "Content",
                "_Label1",
                "_Label2",
                "_Label3",
                "_Label4",
                "_Image2_title",
                "_lb_win_name",
            ])
    }
}
window["CountryPrivilegeView"] = CountryPrivilegeView